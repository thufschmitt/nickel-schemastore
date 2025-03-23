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
      "_js2n__-:definitions/historyOptions!predicate" =
        _js2n__-prdslib.records.record
            {
              block_repeats =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              material = _js2n__-prdslib.isType '"String",
              ozone_concentration = _js2n__-prdslib.isType '"Number",
              period =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              preage_temperature = _js2n__-prdslib.isType '"Number",
              preage_time =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              step_repeats =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              temperature = _js2n__-prdslib.isType '"Number",
              type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "ne",
                                "le",
                                "dg",
                                "gls",
                                "ne_plane_stress",
                                "le_plane_stress",
                                "gls_plane_stress",
                                "dg_ss",
                                "ne_eq",
                                "ne_pl",
                                "ne_si",
                                "ne_vol",
                                "le_eq",
                                "le_pl",
                                "le_si",
                                "hydrostatic_stress",
                                "temperature"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              volume =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ],
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/historyOptionsBlock!contract" =
        {
            block_repeats
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | optional,
            ozone_concentration | Number | optional,
            period
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | optional,
            temperature | Number | optional,
          },
      "_js2n__-:definitions/historyOptionsBlock!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  block_repeats =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  ozone_concentration = _js2n__-prdslib.isType '"Number",
                  period =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  temperature = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/historyOptionsGlobal!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.records.record
              {
                block_repeats =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                material = _js2n__-prdslib.isType '"String",
                ozone_concentration = _js2n__-prdslib.isType '"Number",
                period =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                preage_temperature = _js2n__-prdslib.isType '"Number",
                preage_time =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                rolling =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            sectors =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.numbers.multipleOf 1
                                  ],
                            stride =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.numbers.multipleOf 1
                                  ],
                          } {} true _js2n__-prdslib.always
                      ],
                step_repeats =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                temperature = _js2n__-prdslib.isType '"Number",
                type =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "ne",
                                  "le",
                                  "dg",
                                  "gls",
                                  "ne_plane_stress",
                                  "le_plane_stress",
                                  "gls_plane_stress",
                                  "dg_ss",
                                  "ne_eq",
                                  "ne_pl",
                                  "ne_si",
                                  "ne_vol",
                                  "le_eq",
                                  "le_pl",
                                  "le_si",
                                  "hydrostatic_stress",
                                  "temperature"
                                ]
                            ]),
                        _js2n__-prdslib.arrays.uniqueItems
                      ],
                volume =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.exclusiveMinimum 0
                      ],
              } {} false _js2n__-prdslib.never),
      "_js2n__-:definitions/historyOptionsStep!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.records.record
              {
                block_repeats =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                ozone_concentration = _js2n__-prdslib.isType '"Number",
                period =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                step_repeats =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.numbers.minimum 0
                      ],
                temperature = _js2n__-prdslib.isType '"Number",
              } {} false _js2n__-prdslib.never),
      "_js2n__-:definitions/historyOptionsStep!predicate" =
        _js2n__-prdslib.records.record
            {
              block_repeats =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              ozone_concentration = _js2n__-prdslib.isType '"Number",
              period =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              step_repeats =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              temperature = _js2n__-prdslib.isType '"Number",
            } {} false _js2n__-prdslib.never,
    }
    in
  {
      header
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Text section used to document the analysis."
        | optional,
      history
        | {
          histories
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "label" ],
                            _js2n__-prdslib.records.record
                              {
                                label = _js2n__-prdslib.isType '"String",
                                options =
                                  _js2n__-refsenv."_js2n__-:definitions/historyOptions!predicate",
                                steps =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  blocks =
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
                                                                    data =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"Array",
                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                              (_js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    '"Array",
                                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                                    (_js2n__-prdslib.isType
                                                                                      '"Number")
                                                                                ])
                                                                          ],
                                                                    label =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                    options =
                                                                      _js2n__-refsenv."_js2n__-:definitions/historyOptionsBlock!predicate",
                                                                  } {} false
                                                                  _js2n__-prdslib.never
                                                              ])
                                                        ],
                                                  label =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  options =
                                                    _js2n__-refsenv."_js2n__-:definitions/historyOptionsStep!predicate",
                                                } {} false _js2n__-prdslib.never
                                            ])
                                      ],
                              } {} false _js2n__-prdslib.never
                          ])
                    ]
                ])
            | doc "An array of histories or a file path to an external input file containing an array of histories"
            | optional,
          length
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.multipleOf 1
                ])
            | doc "Specify the number of histories in the analysis"
            | optional,
          options
            | _js2n__-refsenv."_js2n__-:definitions/historyOptionsGlobal!contract"
            | optional,
          schedule
            | {
              steps
                | Array
                  {
                    blocks
                      | Array
                        {
                          file | String,
                          label | String | optional,
                          options
                            | _js2n__-refsenv."_js2n__-:definitions/historyOptionsBlock!contract"
                            | optional,
                        },
                    label | String | optional,
                    options
                      | _js2n__-refsenv."_js2n__-:definitions/historyOptionsStep!contract"
                      | optional,
                  },
            }
            | doc "A schedule definition of steps and blocks, where a block is defined by an external input file containing an array of histories"
            | optional,
        }
        | doc "History definitions."
        | optional,
      material_analysis
        | {
          ageing_crack_growth_rate
            | {
              T_max | Number | optional,
              T_min | Number | optional,
              age_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ]),
              age_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | optional,
              n_T
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              n_age
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
            }
            | doc "Crack growth rate curves at varying ages."
            | optional,
          ageing_strain_life
            | {
              age_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ]),
              age_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | optional,
              n_age
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              n_strain
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              strain_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ]),
              strain_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ]),
            }
            | doc "Strain-life curves at varying ages."
            | optional,
          crack_growth_rate
            | {
              R_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 1,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | optional,
              R_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 1,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | optional,
              T_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ])
                | optional,
              T_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ])
                | optional,
              n_R
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              n_T
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
            }
            | doc "Crack growth rate curves at varying R ratios."
            | optional,
          haigh_diagram
            | {
              n
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              strain_amplitude_max | Number | optional,
              strain_mean_max | Number | optional,
            }
            | doc "Haigh diagram output."
            | optional,
          hysteresis_frequency_sweep
            | {
              deformation_mode
                | std.enum.TagOrString
                | [| 'simple_shear, 'planar_tension, 'simple_tension |]
                | optional,
              frequency_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ])
                | optional,
              frequency_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ])
                | optional,
              n_points
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              strain_amplitude | Number | optional,
              temperature | Number | optional,
            }
            | doc "Hysteresis frequency sweep."
            | optional,
          hysteresis_strain_sweep
            | {
              deformation_mode
                | std.enum.TagOrString
                | [| 'simple_shear, 'planar_tension, 'simple_tension |]
                | optional,
              frequency | Number | optional,
              n_points
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              strain_amplitude_max
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ])
                | optional,
              strain_amplitude_min
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.exclusiveMinimum 0
                    ])
                | optional,
              temperature | Number | optional,
            }
            | doc "Hysteresis strain sweep."
            | optional,
          stress_strain
            | {
              n_points
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              n_unloads
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 2
                    ])
                | optional,
              strain_max | Number | optional,
              strain_min | Number | optional,
              volume_strain_max | Number | optional,
              volume_strain_min | Number | optional,
            }
            | doc "Stress-Strain curves for different modes of deformation."
            | optional,
        }
        | doc "Material analysis definitions that will be performed for each material definition."
        | optional,
      materials
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        ageing =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        type =
                                          _js2n__-prdslib.enum [ "default" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        absolute_zero = _js2n__-prdslib.always,
                                        activation_energy =
                                          _js2n__-prdslib.always,
                                        gas_constant = _js2n__-prdslib.always,
                                        stiffness =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Number",
                                                      _js2n__-prdslib.numbers.minimum
                                                        0
                                                    ])
                                              ],
                                        temp_ref = _js2n__-prdslib.always,
                                        time =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Number",
                                                      _js2n__-prdslib.numbers.minimum
                                                        0
                                                    ])
                                              ],
                                        type =
                                          _js2n__-prdslib.enum [ "arrhenius" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        c0 =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.numbers.exclusiveMinimum 0,
                                _js2n__-prdslib.always
                              ],
                        cf =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.numbers.exclusiveMinimum 0,
                                _js2n__-prdslib.always
                              ],
                        crack_growth_rate =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        F0 = _js2n__-prdslib.always,
                                        Tcritical = _js2n__-prdslib.always,
                                        rc = _js2n__-prdslib.always,
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "thomas" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        F0 = _js2n__-prdslib.always,
                                        Tcritical = _js2n__-prdslib.always,
                                        rc = _js2n__-prdslib.always,
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        threshold = _js2n__-prdslib.always,
                                        transition = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "lakelindley" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        table =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.items
                                                        [
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ]
                                                        ],
                                                      _js2n__-prdslib.arrays.maxItems
                                                        2,
                                                      _js2n__-prdslib.arrays.minItems
                                                        2
                                                    ]),
                                                _js2n__-prdslib.arrays.minItems
                                                  2
                                              ],
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "tabular" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        cyclic_softening =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        type =
                                          _js2n__-prdslib.enum [ "default" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        table =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.items
                                                        [
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.maximum
                                                                1,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.maximum
                                                                1,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ]
                                                        ],
                                                      _js2n__-prdslib.arrays.maxItems
                                                        2,
                                                      _js2n__-prdslib.arrays.minItems
                                                        2
                                                    ])
                                              ],
                                        type =
                                          _js2n__-prdslib.enum [ "tabular" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        elasticity =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        D1 = _js2n__-prdslib.always,
                                        bulk_modulus = _js2n__-prdslib.always,
                                        limit_stretch = _js2n__-prdslib.always,
                                        shear_modulus = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "arrudaboyce" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        alpha1 = _js2n__-prdslib.always,
                                        alpha2 = _js2n__-prdslib.always,
                                        alpha3 = _js2n__-prdslib.always,
                                        alpha4 = _js2n__-prdslib.always,
                                        alpha5 = _js2n__-prdslib.always,
                                        alpha6 = _js2n__-prdslib.always,
                                        mu1 = _js2n__-prdslib.always,
                                        mu2 = _js2n__-prdslib.always,
                                        mu3 = _js2n__-prdslib.always,
                                        mu4 = _js2n__-prdslib.always,
                                        mu5 = _js2n__-prdslib.always,
                                        mu6 = _js2n__-prdslib.always,
                                        nu1 = _js2n__-prdslib.always,
                                        nu2 = _js2n__-prdslib.always,
                                        nu3 = _js2n__-prdslib.always,
                                        nu4 = _js2n__-prdslib.always,
                                        nu5 = _js2n__-prdslib.always,
                                        nu6 = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "hyperfoam" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        C01 = _js2n__-prdslib.always,
                                        C10 = _js2n__-prdslib.always,
                                        D1 = _js2n__-prdslib.always,
                                        bulk_modulus = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "mooneyrivlin" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        C10 = _js2n__-prdslib.always,
                                        D1 = _js2n__-prdslib.always,
                                        bulk_modulus = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "neohookean" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        D1 = _js2n__-prdslib.always,
                                        D2 = _js2n__-prdslib.always,
                                        D3 = _js2n__-prdslib.always,
                                        D4 = _js2n__-prdslib.always,
                                        D5 = _js2n__-prdslib.always,
                                        D6 = _js2n__-prdslib.always,
                                        alpha1 = _js2n__-prdslib.always,
                                        alpha2 = _js2n__-prdslib.always,
                                        alpha3 = _js2n__-prdslib.always,
                                        alpha4 = _js2n__-prdslib.always,
                                        alpha5 = _js2n__-prdslib.always,
                                        alpha6 = _js2n__-prdslib.always,
                                        mu1 = _js2n__-prdslib.always,
                                        mu2 = _js2n__-prdslib.always,
                                        mu3 = _js2n__-prdslib.always,
                                        mu4 = _js2n__-prdslib.always,
                                        mu5 = _js2n__-prdslib.always,
                                        mu6 = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.enum [ "ogden" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        D1 = _js2n__-prdslib.always,
                                        D2 = _js2n__-prdslib.always,
                                        D3 = _js2n__-prdslib.always,
                                        D4 = _js2n__-prdslib.always,
                                        D5 = _js2n__-prdslib.always,
                                        D6 = _js2n__-prdslib.always,
                                        alpha1 = _js2n__-prdslib.always,
                                        alpha2 = _js2n__-prdslib.always,
                                        alpha3 = _js2n__-prdslib.always,
                                        alpha4 = _js2n__-prdslib.always,
                                        alpha5 = _js2n__-prdslib.always,
                                        alpha6 = _js2n__-prdslib.always,
                                        mu1 = _js2n__-prdslib.always,
                                        mu2 = _js2n__-prdslib.always,
                                        mu3 = _js2n__-prdslib.always,
                                        mu4 = _js2n__-prdslib.always,
                                        mu5 = _js2n__-prdslib.always,
                                        mu6 = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "ogden2" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        C10 = _js2n__-prdslib.always,
                                        C20 = _js2n__-prdslib.always,
                                        C30 = _js2n__-prdslib.always,
                                        C40 = _js2n__-prdslib.always,
                                        C50 = _js2n__-prdslib.always,
                                        C60 = _js2n__-prdslib.always,
                                        D1 = _js2n__-prdslib.always,
                                        D2 = _js2n__-prdslib.always,
                                        D3 = _js2n__-prdslib.always,
                                        D4 = _js2n__-prdslib.always,
                                        D5 = _js2n__-prdslib.always,
                                        D6 = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "reducedpolynomial" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        prop1 = _js2n__-prdslib.always,
                                        prop2 = _js2n__-prdslib.always,
                                        prop3 = _js2n__-prdslib.always,
                                        prop4 = _js2n__-prdslib.always,
                                        prop5 = _js2n__-prdslib.always,
                                        prop6 = _js2n__-prdslib.always,
                                        prop7 = _js2n__-prdslib.always,
                                        prop8 = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "uhyper" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        D1 = _js2n__-prdslib.always,
                                        alpha = _js2n__-prdslib.always,
                                        beta = _js2n__-prdslib.always,
                                        bulk_modulus = _js2n__-prdslib.always,
                                        limit_stretch = _js2n__-prdslib.always,
                                        shear_modulus = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "vanderwaals" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        hysteresis =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        PL_frequency_coef =
                                          _js2n__-prdslib.always,
                                        TK_frequency_coef =
                                          _js2n__-prdslib.always,
                                        WLF_C1 = _js2n__-prdslib.always,
                                        WLF_C2 = _js2n__-prdslib.always,
                                        WLF_Gp = _js2n__-prdslib.always,
                                        WLF_Gpp = _js2n__-prdslib.always,
                                        WLF_frequencies =
                                          _js2n__-prdslib.always,
                                        chi = _js2n__-prdslib.always,
                                        deformation_mode =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "simple_tension",
                                                    "planar_tension",
                                                    "simple_shear"
                                                  ]
                                              ],
                                        frequency_ref = _js2n__-prdslib.always,
                                        gamma = _js2n__-prdslib.always,
                                        hys_ref = _js2n__-prdslib.always,
                                        strain_amplitude_ref =
                                          _js2n__-prdslib.always,
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "powerlaw" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        Gp_0 = _js2n__-prdslib.always,
                                        Gp_inf = _js2n__-prdslib.always,
                                        Gpp_inf = _js2n__-prdslib.always,
                                        Gpp_max = _js2n__-prdslib.always,
                                        PL_frequency_coef =
                                          _js2n__-prdslib.always,
                                        TK_frequency_coef =
                                          _js2n__-prdslib.always,
                                        WLF_C1 = _js2n__-prdslib.always,
                                        WLF_C2 = _js2n__-prdslib.always,
                                        WLF_Gp = _js2n__-prdslib.always,
                                        WLF_Gpp = _js2n__-prdslib.always,
                                        WLF_frequencies =
                                          _js2n__-prdslib.always,
                                        chi = _js2n__-prdslib.always,
                                        deformation_mode =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "simple_tension",
                                                    "planar_tension",
                                                    "simple_shear"
                                                  ]
                                              ],
                                        delta_Gpp_U = _js2n__-prdslib.always,
                                        frequency_ref = _js2n__-prdslib.always,
                                        m = _js2n__-prdslib.always,
                                        strain_amplitude_c =
                                          _js2n__-prdslib.always,
                                        strain_amplitude_ref =
                                          _js2n__-prdslib.always,
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.enum [ "kraus" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        mullins =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        beta = _js2n__-prdslib.always,
                                        m = _js2n__-prdslib.always,
                                        r = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "ogdenroxburgh" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        name = _js2n__-prdslib.isType '"String",
                        nonrelaxing =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        type = _js2n__-prdslib.enum [ "paris" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        table =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.items
                                                        [
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.maximum
                                                                1,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.maximum
                                                                1,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ]
                                                        ],
                                                      _js2n__-prdslib.arrays.maxItems
                                                        2,
                                                      _js2n__-prdslib.arrays.minItems
                                                        2
                                                    ])
                                              ],
                                        type =
                                          _js2n__-prdslib.enum [ "xR_tabular" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        type =
                                          _js2n__-prdslib.enum [ "lindley73" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        F1 = _js2n__-prdslib.always,
                                        F2 = _js2n__-prdslib.always,
                                        F3 = _js2n__-prdslib.always,
                                        Fexp = _js2n__-prdslib.always,
                                        temperatures = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "marsfatemi" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        ozone_attack =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        Tz = _js2n__-prdslib.always,
                                        rz = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "williams" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        Fv = _js2n__-prdslib.always,
                                        Gv = _js2n__-prdslib.always,
                                        Kv = _js2n__-prdslib.always,
                                        Kz = _js2n__-prdslib.always,
                                        Tg = _js2n__-prdslib.always,
                                        Tz = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "gentmcgrath" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        thermal_runaway =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        density = _js2n__-prdslib.always,
                                        heat_rate = _js2n__-prdslib.always,
                                        specific_heat = _js2n__-prdslib.always,
                                        temperature_limit =
                                          _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.enum [ "limit" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        viscoelastic_rupture =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.records.record
                                      {
                                        F = _js2n__-prdslib.always,
                                        T0 = _js2n__-prdslib.always,
                                        Tq = _js2n__-prdslib.always,
                                        rq = _js2n__-prdslib.always,
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "powerlaw" ],
                                      } {} false _js2n__-prdslib.never,
                                    _js2n__-prdslib.records.record
                                      {
                                        table =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.items
                                                        [
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                          _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ]
                                                        ],
                                                      _js2n__-prdslib.arrays.maxItems
                                                        2,
                                                      _js2n__-prdslib.arrays.minItems
                                                        2
                                                    ]),
                                                _js2n__-prdslib.arrays.minItems
                                                  2
                                              ],
                                        temp_coef = _js2n__-prdslib.always,
                                        temp_ref = _js2n__-prdslib.always,
                                        type =
                                          _js2n__-prdslib.enum [ "tabular" ],
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "List of material definitions."
        | optional,
      outputs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "adiabatic_time_limit",
                            "age",
                            "block_cycle",
                            "cauchy_stress",
                            "cavitation",
                            "ced",
                            "ced_cycle_count",
                            "ced_sphere",
                            "crack_growth",
                            "crack_size_calibration",
                            "engineering_strain",
                            "engineering_stress",
                            "factor_of_safety",
                            "factor_of_safety_ced",
                            "factor_of_safety_sphere",
                            "history_compression",
                            "hysteresis",
                            "life",
                            "life_sphere",
                            "logarithmic_strain",
                            "principal_cauchy_stress",
                            "principal_engineering_strain",
                            "principal_engineering_stress",
                            "principal_logarithmic_strain",
                            "residual_strength",
                            "sed",
                            "stiffness_ratio",
                            "stiffness_ratio_ageing",
                            "stiffness_ratio_cyclic",
                            "thermal_runaway",
                            "volume_adjustment",
                            "wrinkling"
                          ]
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "adiabatic_time_limit" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "age" ], } {}
                              false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                n_ced =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.multipleOf 1,
                                        _js2n__-prdslib.numbers.minimum 1
                                      ],
                                n_r_ratio =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.multipleOf 1,
                                        _js2n__-prdslib.numbers.minimum 1
                                      ],
                                name = _js2n__-prdslib.enum [ "block_cycle" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name = _js2n__-prdslib.enum [ "cauchy_stress" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "cavitation" ], }
                              {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "ced" ], } {}
                              false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "ced_cycle_cout" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "ced_sphere" ], }
                              {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name = _js2n__-prdslib.enum [ "crack_growth" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                c0_min = _js2n__-prdslib.isType '"Number",
                                n_points =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.multipleOf 1,
                                        _js2n__-prdslib.numbers.minimum 1
                                      ],
                                name =
                                  _js2n__-prdslib.enum
                                      [ "crack_size_calibration" ],
                                target_life = _js2n__-prdslib.isType '"Number",
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "engineering_strain" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "engineering_stress" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "factor_of_safety" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "factor_of_safety_ced" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "factor_of_safety_sphere" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                keep =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.maximum 1,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                n_ced =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.multipleOf 1,
                                        _js2n__-prdslib.numbers.minimum 1
                                      ],
                                n_r_ratio =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.multipleOf 1,
                                        _js2n__-prdslib.numbers.minimum 1
                                      ],
                                name =
                                  _js2n__-prdslib.enum
                                      [ "history_compression" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "hysteresis" ], }
                              {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "life" ], } {}
                              false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "life_sphere" ], }
                              {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "logarithmic_strain" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "principal_cauchy_stress" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "principal_engineering_strain" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "principal_engineering_stress" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "principal_logarithmic_strain" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "residual_strength" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "sed" ], } {}
                              false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "stiffness_ratio" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "stiffness_ratio_ageing" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum
                                      [ "stiffness_ratio_cyclic" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "thermal_runaway" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              {
                                name =
                                  _js2n__-prdslib.enum [ "volume_adjustment" ],
                              } {} false _js2n__-prdslib.never,
                            _js2n__-prdslib.records.record
                              { name = _js2n__-prdslib.enum [ "wrinkling" ], }
                              {} false _js2n__-prdslib.never
                          ],
                        _js2n__-prdslib.records.record
                          { name = _js2n__-prdslib.isType '"String", } {} true
                          _js2n__-prdslib.always
                      ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "List of output requests for the analysis."
        | optional,
      settings
        | {
          ced_integration
            | {
              steps
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.minimum 1
                    ])
                | optional,
              type | std.enum.TagOrString | [| 'fixed |] | optional,
            }
            | optional,
          crack_plane_discretization
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.records.record
                        {
                          nmesh =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Number",
                                  _js2n__-prdslib.numbers.multipleOf 1,
                                  _js2n__-prdslib.numbers.maximum 10,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          type =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "tri3d" ]
                                ],
                        } {} false _js2n__-prdslib.never,
                      _js2n__-prdslib.records.record
                        {
                          planes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.items
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.numbers.maximum
                                                  1
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.numbers.maximum
                                                  1
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.numbers.maximum
                                                  1
                                              ]
                                          ],
                                        _js2n__-prdslib.arrays.maxItems 3,
                                        _js2n__-prdslib.arrays.minItems 3
                                      ]),
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          type =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "user" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ]
                ])
            | optional,
          history_subset
            | {
              labels | Array (String) | optional,
              materials | Array (String) | optional,
              type | std.enum.TagOrString | [| '"default" |] | optional,
            }
            | optional,
          microsphere_discretization
            | {
              nmesh
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.multipleOf 1,
                      _js2n__-prdslib.numbers.maximum 10,
                      _js2n__-prdslib.numbers.minimum 1
                    ])
                | optional,
              type | std.enum.TagOrString | [| 'tri3d |] | optional,
            }
            | optional,
        }
        | doc "Settings that control different aspects of the analysis."
        | optional,
    }