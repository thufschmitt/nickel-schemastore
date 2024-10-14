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
      "_js2n__-:definitions/AutoDiscover!predicate"
        | doc "Settings to determine how Flow should stay abreast of ongoing changes to collections and schemas."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addNewBindings = _js2n__-prdslib.isType '"Bool",
                  evolveIncompatibleCollections =
                    _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Capture!predicate"
        | doc "Capture names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$"
            ],
      "_js2n__-:definitions/CaptureBinding!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "resource", "target" ],
              _js2n__-prdslib.records.record
                {
                  backfill =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  disable = _js2n__-prdslib.isType '"Bool",
                  resource = _js2n__-prdslib.always,
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/Collection!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CaptureDef!predicate"
        | doc "A Capture binds an external system and target (e.x., a SQL table or cloud storage bucket) from which data should be continuously captured, with a Flow collection into that captured data is ingested. Multiple Captures may be bound to a single collection, but only one capture may exist for a given endpoint and target."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bindings", "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  autoDiscover =
                    _js2n__-refsenv."_js2n__-:definitions/AutoDiscover!predicate",
                  bindings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CaptureBinding!predicate"
                        ],
                  delete = _js2n__-prdslib.isType '"Bool",
                  endpoint =
                    _js2n__-refsenv."_js2n__-:definitions/CaptureEndpoint!predicate",
                  expectPubId =
                    _js2n__-refsenv."_js2n__-:definitions/Id!predicate",
                  interval =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.strings.pattern "^\\d+(s|m|h)$"
                        ],
                  shards =
                    _js2n__-refsenv."_js2n__-:definitions/ShardTemplate!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CaptureEndpoint!predicate"
        | doc "An endpoint from which Flow will capture."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "connector" ],
                  _js2n__-prdslib.records.record
                    {
                      connector =
                        _js2n__-refsenv."_js2n__-:definitions/ConnectorConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "local" ],
                  _js2n__-prdslib.records.record
                    {
                      local =
                        _js2n__-refsenv."_js2n__-:definitions/LocalConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/Collection!predicate"
        | doc "Collection names are paths of Unicode letters, numbers, '-', '_', or '.'. Each path component is separated by a slash '/', and a name may not begin or end in a '/'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$"
            ],
      "_js2n__-:definitions/CollectionDef!predicate"
        | doc "Collection describes a set of related documents, where each adheres to a common schema and grouping key. Collections are append-only: once a document is added to a collection, it is never removed. However, it may be replaced or updated (either in whole, or in part) by a future document sharing its key. Each new document of a given key is \"reduced\" into existing documents of the key. By default, this reduction is achieved by completely replacing the previous document, but much richer reduction behaviors can be specified through the use of annotated reduction strategies of the collection schema."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "schema" ],
                      _js2n__-prdslib.records.record
                        {
                          readSchema = _js2n__-prdslib.never,
                          writeSchema = _js2n__-prdslib.never,
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "readSchema", "writeSchema" ],
                      _js2n__-prdslib.records.record
                        { schema = _js2n__-prdslib.never, } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  delete = _js2n__-prdslib.isType '"Bool",
                  derive =
                    _js2n__-refsenv."_js2n__-:definitions/Derivation!predicate",
                  expectPubId =
                    _js2n__-refsenv."_js2n__-:definitions/Id!predicate",
                  journals =
                    _js2n__-refsenv."_js2n__-:definitions/JournalTemplate!predicate",
                  key =
                    _js2n__-refsenv."_js2n__-:definitions/CompositeKey!predicate",
                  projections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^([^/~]|(~[01]))+(/([^/~]|(~[01]))+)*$" =
                                _js2n__-refsenv."_js2n__-:definitions/Projection!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  readSchema =
                    _js2n__-refsenv."_js2n__-:definitions/Schema!predicate",
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/Schema!predicate",
                  writeSchema =
                    _js2n__-refsenv."_js2n__-:definitions/Schema!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CompositeKey!predicate"
        | doc "Ordered JSON-Pointers which define how a composite key may be extracted from a collection document."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/JsonPointer!predicate"
            ],
      "_js2n__-:definitions/CompressionCodec!predicate"
        | doc "A CompressionCodec may be applied to compress journal fragments before they're persisted to cloud stoage. The compression applied to a journal fragment is included in its filename, such as \".gz\" for GZIP. A collection's compression may be changed at any time, and will affect newly-written journal fragments."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "NONE",
                  "GZIP",
                  "ZSTANDARD",
                  "SNAPPY",
                  "GZIP_OFFLOAD_DECOMPRESSION"
                ]
            ],
      "_js2n__-:definitions/ConnectorConfig!predicate"
        | doc "Connector image and configuration specification."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "image" ],
              _js2n__-prdslib.records.record
                {
                  config = _js2n__-prdslib.always,
                  image = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DekafConfig!predicate"
        | doc "Dekaf service configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "variant" ],
              _js2n__-prdslib.records.record
                {
                  config = _js2n__-prdslib.always,
                  variant = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Derivation!predicate"
        | doc "Derive specifies how a collection is derived from other collections."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "transforms", "using" ],
              _js2n__-prdslib.records.record
                {
                  shards =
                    _js2n__-refsenv."_js2n__-:definitions/ShardTemplate!predicate",
                  shuffleKeyTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ShuffleType!predicate"
                        ],
                  transforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TransformDef!predicate"
                        ],
                  using =
                    _js2n__-refsenv."_js2n__-:definitions/DeriveUsing!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeriveUsing!predicate"
        | doc "A derivation runtime implementation."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "connector" ],
                  _js2n__-prdslib.records.record
                    {
                      connector =
                        _js2n__-refsenv."_js2n__-:definitions/ConnectorConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "sqlite" ],
                  _js2n__-prdslib.records.record
                    {
                      sqlite =
                        _js2n__-refsenv."_js2n__-:definitions/DeriveUsingSqlite!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "typescript" ],
                  _js2n__-prdslib.records.record
                    {
                      typescript =
                        _js2n__-refsenv."_js2n__-:definitions/DeriveUsingTypescript!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "local" ],
                  _js2n__-prdslib.records.record
                    {
                      local =
                        _js2n__-refsenv."_js2n__-:definitions/LocalConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/DeriveUsingSqlite!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  migrations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern "^[^ ]+$"
                                  ],
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DeriveUsingTypescript!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "module" ],
              _js2n__-prdslib.records.record
                {
                  module =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "^[^ ]+$"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Field!predicate"
        | doc "Field names a projection of a document location. They may include '/', but cannot begin or end with one. Many Fields are automatically inferred by Flow from a collection JSON Schema, and are the JSON Pointer of the document location with the leading '/' removed. User-provided Fields which act as a logical partitions are restricted to Unicode letters, numbers, '-', '_', or '.'"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^([^/~]|(~[01]))+(/([^/~]|(~[01]))+)*$"
            ],
      "_js2n__-:definitions/FragmentTemplate!predicate"
        | doc "A FragmentTemplate configures how journal fragment files are produced as part of a collection."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compressionCodec =
                    _js2n__-refsenv."_js2n__-:definitions/CompressionCodec!predicate",
                  flushInterval =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.strings.pattern "^\\d+(s|m|h)$"
                        ],
                  length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 4096,
                          _js2n__-prdslib.numbers.minimum 32
                        ],
                  retention =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.strings.pattern "^\\d+(s|m|h)$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FullSource!predicate"
        | doc "A source collection and details of how it's read."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/Collection!predicate",
                  notAfter =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  notBefore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  partitions =
                    _js2n__-refsenv."_js2n__-:definitions/PartitionSelector!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Id!predicate" = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/JournalTemplate!predicate"
        | doc "A JournalTemplate configures the journals which make up the physical partitions of a collection."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fragments" ],
              _js2n__-prdslib.records.record
                {
                  fragments =
                    _js2n__-refsenv."_js2n__-:definitions/FragmentTemplate!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonPointer!predicate"
        | doc "JSON Pointer which identifies a location in a document."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^(/([^/~]|(~[01]))+)*$"
            ],
      "_js2n__-:definitions/LocalConfig!predicate"
        | doc "Local command and its configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command", "config" ],
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  config = _js2n__-prdslib.always,
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  protobuf = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MaterializationBinding!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "resource", "source" ],
              _js2n__-prdslib.records.record
                {
                  backfill =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  disable = _js2n__-prdslib.isType '"Bool",
                  fields =
                    _js2n__-refsenv."_js2n__-:definitions/MaterializationFields!predicate",
                  onIncompatibleSchemaChange =
                    _js2n__-refsenv."_js2n__-:definitions/OnIncompatibleSchemaChange!predicate",
                  "priority" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  resource = _js2n__-prdslib.always,
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/Source!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MaterializationDef!predicate"
        | doc "A Materialization binds a Flow collection with an external system & target (e.x, a SQL table) into which the collection is to be continuously materialized."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "bindings", "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  bindings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MaterializationBinding!predicate"
                        ],
                  delete = _js2n__-prdslib.isType '"Bool",
                  endpoint =
                    _js2n__-refsenv."_js2n__-:definitions/MaterializationEndpoint!predicate",
                  expectPubId =
                    _js2n__-refsenv."_js2n__-:definitions/Id!predicate",
                  onIncompatibleSchemaChange =
                    _js2n__-refsenv."_js2n__-:definitions/OnIncompatibleSchemaChange!predicate",
                  shards =
                    _js2n__-refsenv."_js2n__-:definitions/ShardTemplate!predicate",
                  sourceCapture =
                    _js2n__-refsenv."_js2n__-:definitions/SourceCapture!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MaterializationEndpoint!predicate"
        | doc "An Endpoint connector used for Flow materializations."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "connector" ],
                  _js2n__-prdslib.records.record
                    {
                      connector =
                        _js2n__-refsenv."_js2n__-:definitions/ConnectorConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "local" ],
                  _js2n__-prdslib.records.record
                    {
                      local =
                        _js2n__-refsenv."_js2n__-:definitions/LocalConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "dekaf" ],
                  _js2n__-prdslib.records.record
                    {
                      dekaf =
                        _js2n__-refsenv."_js2n__-:definitions/DekafConfig!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/MaterializationFields!predicate"
        | doc "MaterializationFields defines a selection of projections to materialize, as well as optional per-projection, driver-specific configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "recommended" ],
              _js2n__-prdslib.records.record
                {
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Field!predicate"
                        ],
                  include =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  recommended = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OnIncompatibleSchemaChange!predicate"
        | doc "Determines how to handle incompatible schema changes for a given binding."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "abort" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "backfill" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "disableBinding" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "disableTask" ]
                ]
            ],
      "_js2n__-:definitions/PartitionSelector!predicate"
        | doc "Partition selectors identify a desired subset of the available logical partitions of a collection."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-prdslib.always
                              ])
                        ],
                  include =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-prdslib.always
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Projection!predicate"
        | doc "Projections are named locations within a collection document which may be used for logical partitioning or directly exposed to databases into which collections are materialized."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/JsonPointer!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "location" ],
                  _js2n__-prdslib.records.record
                    {
                      location =
                        _js2n__-refsenv."_js2n__-:definitions/JsonPointer!predicate",
                      partition = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/RelativeUrl!contract"
        | doc "A URL identifying a resource, which may be a relative local path with respect to the current resource (i.e, ../path/to/flow.yaml), or may be an external absolute URL (i.e., http://example/flow.yaml)."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[^ ]+$"
              ]),
      "_js2n__-:definitions/Schema!predicate"
        | doc m%"
          A schema is a draft 2020-12 JSON Schema which validates Flow documents. Schemas also provide annotations at document locations, such as reduction strategies for combining one document into another.
          
          Schemas may be defined inline to the catalog, or given as a relative or absolute URI. URIs may optionally include a JSON fragment pointer that locates a specific sub-schema therein.
          
          For example, "schemas/marketing.yaml#/$defs/campaign" would reference the schema at location {"$defs": {"campaign": ...}} within ./schemas/marketing.yaml.
        "%
        = _js2n__-prdslib.always,
      "_js2n__-:definitions/ShardTemplate!predicate"
        | doc "A ShardTemplate configures how shards process a catalog task."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disable = _js2n__-prdslib.isType '"Bool",
                  hotStandbys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  logLevel = _js2n__-prdslib.isType '"String",
                  maxTxnDuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.strings.pattern "^\\d+(s|m|h)$"
                        ],
                  minTxnDuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.strings.pattern "^\\d+(s|m|h)$"
                        ],
                  readChannelSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  ringBufferSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Shuffle!predicate"
        | doc "A Shuffle specifies how a shuffling key is to be extracted from collection documents."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "any" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "key" ],
                  _js2n__-prdslib.records.record
                    {
                      key =
                        _js2n__-refsenv."_js2n__-:definitions/CompositeKey!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "lambda" ],
                  _js2n__-prdslib.records.record
                    { lambda = _js2n__-prdslib.always, } {} false
                    _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/ShuffleType!predicate"
        | doc "Type of a shuffled key component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "boolean", "integer", "string" ]
            ],
      "_js2n__-:definitions/Source!predicate"
        | doc "A source collection and details of how it's read."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FullSource!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Collection!predicate"
            ],
      "_js2n__-:definitions/SourceCapture!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Capture!predicate",
              _js2n__-refsenv."_js2n__-:definitions/SourceCaptureDef!predicate"
            ],
      "_js2n__-:definitions/SourceCaptureDef!predicate"
        | doc "SourceCaptureDef specifies configuration for source captures"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "capture" ],
              _js2n__-prdslib.records.record
                {
                  capture =
                    _js2n__-refsenv."_js2n__-:definitions/Capture!predicate",
                  deltaUpdates = _js2n__-prdslib.isType '"Bool",
                  targetSchema =
                    _js2n__-refsenv."_js2n__-:definitions/SourceCaptureSchemaMode!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SourceCaptureSchemaMode!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "leaveEmpty" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "fromSourceName" ]
                ]
            ],
      "_js2n__-:definitions/TestDef!predicate"
        | doc "Test the behavior of reductions and derivations, through a sequence of test steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "steps" ],
              _js2n__-prdslib.records.record
                {
                  delete = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  expectPubId =
                    _js2n__-refsenv."_js2n__-:definitions/Id!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TestStep!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TestDocuments!predicate"
        | doc "A test step describes either an \"ingest\" of document fixtures into a collection, or a \"verify\" of expected document fixtures from a collection."
        = _js2n__-prdslib.always,
      "_js2n__-:definitions/TestStep!predicate"
        | doc "A test step describes either an \"ingest\" of document fixtures into a collection, or a \"verify\" of expected document fixtures from a collection."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "ingest" ],
                  _js2n__-prdslib.records.record
                    {
                      ingest =
                        _js2n__-refsenv."_js2n__-:definitions/TestStepIngest!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "verify" ],
                  _js2n__-prdslib.records.record
                    {
                      verify =
                        _js2n__-refsenv."_js2n__-:definitions/TestStepVerify!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/TestStepIngest!predicate"
        | doc "An ingestion test step ingests document fixtures into the named collection."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "collection", "documents" ],
              _js2n__-prdslib.records.record
                {
                  collection =
                    _js2n__-refsenv."_js2n__-:definitions/Collection!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  documents =
                    _js2n__-refsenv."_js2n__-:definitions/TestDocuments!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TestStepVerify!predicate"
        | doc "A verification test step verifies that the contents of the named collection match the expected fixtures, after fully processing all preceding ingestion test steps."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "collection", "documents" ],
              _js2n__-prdslib.records.record
                {
                  collection =
                    _js2n__-refsenv."_js2n__-:definitions/Source!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  documents =
                    _js2n__-refsenv."_js2n__-:definitions/TestDocuments!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Transform!predicate"
        | doc "Transform names are Unicode letters, numbers, '-', '_', or '.'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[\\p{Letter}\\p{Number}\\-_\\.]+$"
            ],
      "_js2n__-:definitions/TransformDef!predicate"
        | doc "A Transform reads and shuffles documents of a source collection, and processes each document through either one or both of a register \"update\" lambda and a derived document \"publish\" lambda."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "shuffle", "source" ],
              _js2n__-prdslib.records.record
                {
                  backfill =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  disable = _js2n__-prdslib.isType '"Bool",
                  lambda = _js2n__-prdslib.always,
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/Transform!predicate",
                  "priority" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  readDelay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.strings.pattern "^\\d+(s|m|h)$"
                        ],
                  shuffle =
                    _js2n__-refsenv."_js2n__-:definitions/Shuffle!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/Source!predicate",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      "$schema" | String | optional,
      captures
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
                    _js2n__-refsenv."_js2n__-:definitions/CaptureDef!predicate",
                } false _js2n__-prdslib.never
            ])
        | optional,
      collections
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
                    _js2n__-refsenv."_js2n__-:definitions/CollectionDef!predicate",
                } false _js2n__-prdslib.never
            ])
        | optional,
      "import"
        | Array _js2n__-refsenv."_js2n__-:definitions/RelativeUrl!contract"
        | doc "By importing another Flow catalog source, its collections, schemas, and derivations are bundled into the publication context of this specification. Imports are relative or absolute URLs, relative to this specification's location."
        | optional,
      materializations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
                    _js2n__-refsenv."_js2n__-:definitions/MaterializationDef!predicate",
                } false _js2n__-prdslib.never
            ])
        | optional,
      tests
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[\\p{Letter}\\p{Number}\\-_\\.]+(/[\\p{Letter}\\p{Number}\\-_\\.]+)*$" =
                    _js2n__-refsenv."_js2n__-:definitions/TestDef!predicate",
                } false _js2n__-prdslib.never
            ])
        | optional,
    }