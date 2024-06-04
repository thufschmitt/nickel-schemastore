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
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              build =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          excludeCorrectable = _js2n__-prdslib.isType '"Bool",
                          maxIssues = _js2n__-prdslib.isType 'Integer,
                          weights =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.isType 'Integer)
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              comments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AbsentOrWrongFileLicense =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      licenseTemplateFile =
                                        _js2n__-prdslib.isType '"String",
                                      licenseTemplateIsRegex =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          CommentOverPrivateFunction =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          CommentOverPrivateProperty =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          DeprecatedBlockTag =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EndOfSentenceFormat =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      endOfSentenceFormat =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          KDocReferencesNonPublicProperty =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          OutdatedDocumentation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowParamOnConstructorProperties =
                                        _js2n__-prdslib.isType '"Bool",
                                      matchDeclarationsOrder =
                                        _js2n__-prdslib.isType '"Bool",
                                      matchTypeParameters =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UndocumentedPublicClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      searchInInnerClass =
                                        _js2n__-prdslib.isType '"Bool",
                                      searchInInnerInterface =
                                        _js2n__-prdslib.isType '"Bool",
                                      searchInInnerObject =
                                        _js2n__-prdslib.isType '"Bool",
                                      searchInNestedClass =
                                        _js2n__-prdslib.isType '"Bool",
                                      searchInProtectedClass =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UndocumentedPublicFunction =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      searchProtectedFunction =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UndocumentedPublicProperty =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      searchProtectedProperty =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              complexity =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          CognitiveComplexMethod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          ComplexCondition =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          ComplexInterface =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreOverloaded =
                                        _js2n__-prdslib.isType '"Bool",
                                      includePrivateDeclarations =
                                        _js2n__-prdslib.isType '"Bool",
                                      includeStaticDeclarations =
                                        _js2n__-prdslib.isType '"Bool",
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          CyclomaticComplexMethod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreNestingFunctions =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreSimpleWhenEntries =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreSingleWhenExpression =
                                        _js2n__-prdslib.isType '"Bool",
                                      nestingFunctions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          LabeledExpression =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoredLabels =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          LargeClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          LongMethod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          LongParameterList =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      constructorThreshold =
                                        _js2n__-prdslib.isType 'Integer,
                                      functionThreshold =
                                        _js2n__-prdslib.isType 'Integer,
                                      ignoreAnnotatedParameter =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      ignoreDataClasses =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreDefaultParameters =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          MethodOverloading =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          NamedArguments =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreArgumentsMatchingNames =
                                        _js2n__-prdslib.isType '"Bool",
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          NestedBlockDepth =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          NestedScopeFunctions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      functions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          ReplaceSafeCallChainWithRun =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          StringLiteralDuplication =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeStringsWithLessThan5Characters =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreAnnotation =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreStringsRegex =
                                        _js2n__-prdslib.isType '"String",
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          TooManyFunctions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreDeprecated =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignorePrivate =
                                        _js2n__-prdslib.isType '"Bool",
                                      thresholdInClasses =
                                        _js2n__-prdslib.isType 'Integer,
                                      thresholdInEnums =
                                        _js2n__-prdslib.isType 'Integer,
                                      thresholdInFiles =
                                        _js2n__-prdslib.isType 'Integer,
                                      thresholdInInterfaces =
                                        _js2n__-prdslib.isType 'Integer,
                                      thresholdInObjects =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              config =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          checkExhaustiveness = _js2n__-prdslib.isType '"Bool",
                          excludes = _js2n__-prdslib.isType '"String",
                          validation = _js2n__-prdslib.isType '"Bool",
                          warningsAsErrors = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              console-reports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          active = _js2n__-prdslib.isType '"Bool",
                          exclude =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              coroutines =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          GlobalCoroutineUsage =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          InjectDispatcher =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      dispatcherNames =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          RedundantSuspendModifier =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          SleepInsteadOfDelay =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          SuspendFunWithCoroutineScopeReceiver =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          SuspendFunWithFlowReturnType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              empty-blocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          EmptyCatchBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowedExceptionNameRegex =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          EmptyClassBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyDefaultConstructor =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyDoWhileBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyElseBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyFinallyBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyForBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyFunctionBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          EmptyIfBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyInitBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyKtFile =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptySecondaryConstructor =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyTryBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyWhenBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EmptyWhileBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              exceptions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          ExceptionRaisedInUnexpectedLocation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      methodNames =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          InstanceOfCheckForException =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NotImplementedDeclaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ObjectExtendsThrowable =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          PrintStackTrace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          RethrowCaughtException =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ReturnFromFinally =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreLabeled =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SwallowedException =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowedExceptionNameRegex =
                                        _js2n__-prdslib.isType '"String",
                                      ignoredExceptionTypes =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ThrowingExceptionFromFinally =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ThrowingExceptionInMain =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ThrowingExceptionsWithoutMessageOrCause =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      exceptions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ThrowingNewInstanceOfSameException =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          TooGenericExceptionCaught =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowedExceptionNameRegex =
                                        _js2n__-prdslib.isType '"String",
                                      exceptionNames =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          TooGenericExceptionThrown =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      exceptionNames =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              formatting =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AnnotationOnSeparateLine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          AnnotationSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ArgumentListWrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                      maxLineLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          BlockCommentInitialStarAlignment =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ChainWrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          CommentSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          CommentWrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          DiscouragedCommentLocation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          EnumEntryNameCase =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          Filename =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          FinalNewline =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      insertFinalNewLine =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunKeywordSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionReturnTypeSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionSignature =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      forceMultilineWhenParameterCountGreaterOrEqualThan =
                                        _js2n__-prdslib.isType 'Integer,
                                      functionBodyExpressionWrapping =
                                        _js2n__-prdslib.isType '"String",
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                      maxLineLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionStartOfBodySpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionTypeReferenceSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ImportOrdering =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      layout = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          Indentation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          KdocWrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          MaximumLineLength =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreBackTickedIdentifier =
                                        _js2n__-prdslib.isType '"Bool",
                                      maxLineLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          ModifierListSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ModifierOrdering =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          MultiLineIfElse =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoBlankLineBeforeRbrace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoBlankLinesInChainedMethodCalls =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoConsecutiveBlankLines =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoEmptyClassBody =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoEmptyFirstLineInMethodBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoLineBreakAfterElse =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoLineBreakBeforeAssignment =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoMultipleSpaces =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoSemicolons =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoTrailingSpaces =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoUnitReturn =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoUnusedImports =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoWildcardImports =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      packagesToUseImportOnDemandProperty =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NullableTypeSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          PackageName =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ParameterListSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ParameterListWrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      maxLineLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundAngleBrackets =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundColon =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundComma =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundCurly =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundDot =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundDoubleColon =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundKeyword =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundOperators =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundParens =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundRangeOperator =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingAroundUnaryOperator =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingBetweenDeclarationsWithAnnotations =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingBetweenDeclarationsWithComments =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          SpacingBetweenFunctionNameAndOpeningParenthesis =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          StringTemplate =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          TrailingCommaOnCallSite =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      useTrailingCommaOnCallSite =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          TrailingCommaOnDeclarationSite =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      useTrailingCommaOnDeclarationSite =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          TypeArgumentListSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          TypeParameterListSpacing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UnnecessaryParenthesesBeforeTrailingLambda =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          Wrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      autoCorrect =
                                        _js2n__-prdslib.isType '"Bool",
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                          android = _js2n__-prdslib.isType '"Bool",
                          autoCorrect = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              libraries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          ForbiddenPublicDataClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignorePackages =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          LibraryCodeMustSpecifyReturnType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          LibraryEntitiesShouldNotBePublic =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              naming =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          BooleanPropertyNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowedPattern =
                                        _js2n__-prdslib.isType '"String",
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ClassNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      classPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ConstructorParameterNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeClassPattern =
                                        _js2n__-prdslib.isType '"String",
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                      parameterPattern =
                                        _js2n__-prdslib.isType '"String",
                                      privateParameterPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          EnumNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      enumEntryPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForbiddenClassName =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      forbiddenName =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionMaxLength =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      maximumFunctionNameLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionMinLength =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      minimumFunctionNameLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeClassPattern =
                                        _js2n__-prdslib.isType '"String",
                                      functionPattern =
                                        _js2n__-prdslib.isType '"String",
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionParameterNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeClassPattern =
                                        _js2n__-prdslib.isType '"String",
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                      parameterPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          InvalidPackageDeclaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      requireRootInDeclaration =
                                        _js2n__-prdslib.isType '"Bool",
                                      rootPackage =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          LambdaParameterNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      parameterPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          MatchingDeclarationName =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      mustBeFirst =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          MemberNameEqualsClassName =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          NoNameShadowing =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NonBooleanPropertyPrefixedWithIs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ObjectPropertyNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      constantPattern =
                                        _js2n__-prdslib.isType '"String",
                                      privatePropertyPattern =
                                        _js2n__-prdslib.isType '"String",
                                      propertyPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          PackageNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      packagePattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          TopLevelPropertyNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      constantPattern =
                                        _js2n__-prdslib.isType '"String",
                                      privatePropertyPattern =
                                        _js2n__-prdslib.isType '"String",
                                      propertyPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          VariableMaxLength =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      maximumVariableNameLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          VariableMinLength =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      minimumVariableNameLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          VariableNaming =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeClassPattern =
                                        _js2n__-prdslib.isType '"String",
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                      privateVariablePattern =
                                        _js2n__-prdslib.isType '"String",
                                      variablePattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              output-reports =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          active = _js2n__-prdslib.isType '"Bool",
                          exclude =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              performance =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          ArrayPrimitive =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          CouldBeSequence =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      threshold =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForEachOnRange =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          SpreadOperator =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryPartOfBinaryExpression =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryTemporaryInstantiation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              potential-bugs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AvoidReferentialEquality =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      forbiddenTypePatterns =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          CastToNullableType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          Deprecation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          DontDowncastCollectionTypes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          DoubleMutabilityForCollection =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      mutableTypes =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ElseCaseInsteadOfExhaustiveWhen =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EqualsAlwaysReturnsTrueOrFalse =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EqualsWithHashCodeExist =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ExitOutsideMain =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ExplicitGarbageCollectionCall =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          HasPlatformType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          IgnoredReturnValue =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreFunctionCall =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      ignoreReturnValueAnnotations =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      restrictToConfig =
                                        _js2n__-prdslib.isType '"Bool",
                                      returnValueAnnotations =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      returnValueTypes =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ImplicitDefaultLocale =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ImplicitUnitReturnType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowExplicitReturnType =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          InvalidRange =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          IteratorHasNextCallsNextMethod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          IteratorNotThrowingNoSuchElementException =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          LateinitUsage =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreOnClassesPattern =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          MapGetWithNotNullAssertionOperator =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          MissingPackageDeclaration =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NullCheckOnMutableProperty =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NullableToStringCall =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnconditionalJumpStatementInLoop =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryNotNullCheck =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryNotNullOperator =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessarySafeCall =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnreachableCatchBlock =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnreachableCode =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnsafeCallOnNullableType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnsafeCast =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnusedUnaryOperator =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UselessPostfixExpression =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          WrongEqualsTypeParameter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              processors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          active = _js2n__-prdslib.isType '"Bool",
                          exclude =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              ruleauthors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          UseEntityAtName =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ViolatesTypeResolutionRequirements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AlsoCouldBeApply =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          CanBeNonNullable =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          CascadingCallWrapping =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      includeElvis =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ClassOrdering =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          CollapsibleIfStatements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          DataClassContainsFunctions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      conversionFunctionPrefix =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          DataClassShouldBeImmutable =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          DestructuringDeclarationWithTooManyEntries =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      maxDestructuringEntries =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          EqualsNullCall =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          EqualsOnSignatureLine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ExplicitCollectionElementAccessMethod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ExplicitItLambdaParameter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ExpressionBodySyntax =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      includeLineWrapping =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForbiddenComment =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowedPatterns =
                                        _js2n__-prdslib.isType '"String",
                                      customMessage =
                                        _js2n__-prdslib.isType '"String",
                                      values =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForbiddenImport =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      forbiddenPatterns =
                                        _js2n__-prdslib.isType '"String",
                                      imports =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "value" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        reason =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        value =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ])
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForbiddenMethodCall =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      methods =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "value" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        reason =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        value =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ])
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForbiddenSuppress =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      rules =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          ForbiddenVoid =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreOverridden =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreUsageInGenerics =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          FunctionOnlyReturningConstant =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludedFunctions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      ignoreActualFunction =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreOverridableFunction =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          LoopWithTooManyJumpStatements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      maxJumpCount =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          MagicNumber =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreAnnotation =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreCompanionObjectPropertyDeclaration =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreConstantDeclaration =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreEnums =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreExtensionFunctions =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreHashCodeFunction =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreLocalVariableDeclaration =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreNamedArgument =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreNumbers =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      ignorePropertyDeclaration =
                                        _js2n__-prdslib.isType '"Bool",
                                      ignoreRanges =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          MandatoryBracesIfStatements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          MandatoryBracesLoops =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          MaxChainedCallsOnSameLine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      maxChainedCalls =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          MaxLineLength =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeCommentStatements =
                                        _js2n__-prdslib.isType '"Bool",
                                      excludeImportStatements =
                                        _js2n__-prdslib.isType '"Bool",
                                      excludePackageStatements =
                                        _js2n__-prdslib.isType '"Bool",
                                      excludeRawStrings =
                                        _js2n__-prdslib.isType '"Bool",
                                      maxLineLength =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          MayBeConst =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ModifierOrder =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          MultilineLambdaItParameter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          MultilineRawStringIndentation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      indentSize =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          NestedClassesVisibility =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NewLineAtEndOfFile =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NoTabs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          NullableBooleanCheck =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ObjectLiteralToLambda =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          OptionalAbstractKeyword =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          OptionalUnit =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          OptionalWhenBraces =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          PreferToOverPairSyntax =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ProtectedMemberInFinalClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          RedundantExplicitType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          RedundantHigherOrderMapUsage =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          RedundantVisibilityModifierRule =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ReturnCount =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeGuardClauses =
                                        _js2n__-prdslib.isType '"Bool",
                                      excludeLabeled =
                                        _js2n__-prdslib.isType '"Bool",
                                      excludeReturnFromLambda =
                                        _js2n__-prdslib.isType '"Bool",
                                      excludedFunctions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      max = _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          SafeCast =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          SerialVersionUIDInSerializableClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          SpacingBetweenPackageAndImports =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          ThrowsCount =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeGuardClauses =
                                        _js2n__-prdslib.isType '"Bool",
                                      max = _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          TrailingWhitespace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          TrimMultilineRawString =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnderscoresInNumericLiterals =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      acceptableLength =
                                        _js2n__-prdslib.isType 'Integer,
                                      allowNonStandardGrouping =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UnnecessaryAbstractClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryAnnotationUseSiteTarget =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryApply =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryBackticks =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryFilter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryInheritance =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryInnerClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryLet =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnnecessaryParentheses =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowForUnclearPrecedence =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UntilInsteadOfRangeTo =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnusedImports =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnusedPrivateClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UnusedPrivateMember =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowedNames =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UseAnyOrNoneInsteadOfFind =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseArrayLiteralsInAnnotations =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseCheckNotNull =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseCheckOrError =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseDataClass =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowVars =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          UseEmptyCounterpart =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseIfEmptyOrIfBlank =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseIfInsteadOfWhen =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseIsNullOrEmpty =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseOrEmpty =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseRequire =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseRequireNotNull =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UseSumOfInsteadOfFlatMapSize =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UselessCallOnNotNull =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          UtilityClassWithPublicConstructor =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always
                                ],
                          VarCouldBeVal =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreLateinitVar =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          WildcardImport =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.always,
                                  _js2n__-prdslib.records.record
                                    {
                                      excludeImports =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          active = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
            } {} true _js2n__-prdslib.always
        ])