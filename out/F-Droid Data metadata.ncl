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
      "_js2n__-:definitions/anti_features!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "Ads",
                            "ApplicationDebuggable",
                            "KnownVuln",
                            "NonFreeAdd",
                            "NonFreeAssets",
                            "NonFreeDep",
                            "NonFreeNet",
                            "NoSourceSince",
                            "NSFW",
                            "UpstreamNonFree",
                            "TetheredNet",
                            "Tracking"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.minItems 1,
                  _js2n__-prdslib.arrays.uniqueItems
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "^(Ads|ApplicationDebuggable|KnownVuln|NonFreeAdd|NonFreeAssets|NonFreeDep|NonFreeNet|NoSourceSince|NSFW|UpstreamNonFree|TetheredNet|Tracking)$" =
                        _js2n__-refsenv."_js2n__-:definitions/localized_string!predicate",
                    } false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/localized_string!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-z]{2,3}(-([A-Z][a-zA-Z]+|\\d+|[a-z]+))*$" =
                    _js2n__-prdslib.isType '"String",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/string_list!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/url!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^https?://.*$"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "Repo", "RepoType", "SourceCode" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "NoSourceSince" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "ArchivePolicy" ],
                        _js2n__-prdslib.records.record
                          { ArchivePolicy = _js2n__-prdslib.const 0, } {} true
                          _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "NoSourceSince" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ]
                  ])
                (_js2n__-prdslib.records.record
                  { UpdateCheckMode = _js2n__-prdslib.const "None", } {} true
                  _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "Binaries" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "Builds" ],
                        _js2n__-prdslib.records.record
                          {
                            Builds =
                              _js2n__-prdslib.arrays.contains
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "binary" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ]),
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required
                      [ "AllowedAPKSigningKeys" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { UpdateCheckMode = _js2n__-prdslib.strings.pattern "^Tags", }
                  {} true _js2n__-prdslib.always)
                (_js2n__-prdslib.records.record
                  {
                    AutoUpdateMode =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^(None|Version( \\+.+)?)$"
                          ],
                  } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { UpdateCheckMode = _js2n__-prdslib.const "HTTP", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "UpdateCheckData" ],
                    _js2n__-prdslib.records.record
                      {
                        AutoUpdateMode =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^(None|Version .+)$"
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  {
                    UpdateCheckMode =
                      _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.enum [ "None", "Static" ],
                            _js2n__-prdslib.strings.pattern
                              "^RepoManifest(/.+)?$"
                          ],
                  } {} true _js2n__-prdslib.always)
                (_js2n__-prdslib.records.record
                  { AutoUpdateMode = _js2n__-prdslib.const "None", } {} true
                  _js2n__-prdslib.always) _js2n__-prdslib.always
            ],
          _js2n__-prdslib.records.required
            [ "Builds", "Categories", "License" ],
          _js2n__-prdslib.records.record
            {
              AllowedAPKSigningKeys =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[0-9a-f]{64}$"
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern "^[0-9a-f]{64}$"
                              ])
                        ]
                    ],
              AntiFeatures =
                _js2n__-refsenv."_js2n__-:definitions/anti_features!predicate",
              ArchivePolicy = _js2n__-prdslib.isType 'Integer,
              AuthorEmail =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
                    ],
              AuthorName = _js2n__-prdslib.isType '"String",
              AuthorWebSite =
                _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              AutoName = _js2n__-prdslib.isType '"String",
              AutoUpdateMode =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "None", "Version" ],
                          _js2n__-prdslib.strings.pattern
                            "^Version( \\+.+)? [^+].+"
                        ]
                    ],
              Binaries = _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              Bitcoin =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$"
                    ],
              Builds =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required
                              [ "versionCode", "versionName" ],
                            _js2n__-prdslib.records.record
                              {
                                androidupdate =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.const "auto",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ]
                                      ],
                                antcommands =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                antifeatures =
                                  _js2n__-refsenv."_js2n__-:definitions/anti_features!predicate",
                                binary =
                                  _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                                build =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                buildjni =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum [ "yes", "no" ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ]
                                      ],
                                commit = _js2n__-prdslib.isType '"String",
                                disable = _js2n__-prdslib.isType '"String",
                                encoding = _js2n__-prdslib.isType '"String",
                                extlibs =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                forcevercode = _js2n__-prdslib.const true,
                                forceversion = _js2n__-prdslib.const true,
                                gradle =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.const "yes"),
                                            _js2n__-prdslib.arrays.maxItems 1
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ]
                                      ],
                                gradleprops =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                init =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                maven =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "yes", "yes@" ]
                                          ]
                                      ],
                                ndk = _js2n__-prdslib.isType '"String",
                                novcheck = _js2n__-prdslib.const true,
                                oldsdkloc = _js2n__-prdslib.const true,
                                output = _js2n__-prdslib.isType '"String",
                                patch =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                postbuild =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                preassemble =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                prebuild =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                rm =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                scandelete =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                scanignore =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                srclibs =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                subdir = _js2n__-prdslib.isType '"String",
                                submodules = _js2n__-prdslib.const true,
                                sudo =
                                  _js2n__-refsenv."_js2n__-:definitions/string_list!predicate",
                                target = _js2n__-prdslib.isType '"String",
                                timeout = _js2n__-prdslib.isType 'Integer,
                                versionCode = _js2n__-prdslib.isType 'Integer,
                                versionName = _js2n__-prdslib.isType '"String",
                              } {} false _js2n__-prdslib.never
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              Categories =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "Connectivity",
                                "Development",
                                "Games",
                                "Graphics",
                                "Internet",
                                "Money",
                                "Multimedia",
                                "Navigation",
                                "Phone & SMS",
                                "Reading",
                                "Science & Education",
                                "Security",
                                "Sports & Health",
                                "System",
                                "Theming",
                                "Time",
                                "Writing"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              Changelog = _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              CurrentVersion = _js2n__-prdslib.isType '"String",
              CurrentVersionCode = _js2n__-prdslib.isType 'Integer,
              Description =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 4000
                    ],
              Disabled = _js2n__-prdslib.isType '"String",
              Donate = _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              FlattrID =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[0-9a-z]+$"
                    ],
              IssueTracker =
                _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              Liberapay = _js2n__-prdslib.isType '"String",
              License =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "0BSD",
                          "AAL",
                          "AFL-1.1",
                          "AFL-1.2",
                          "AFL-2.0",
                          "AFL-2.1",
                          "AFL-3.0",
                          "AGPL-3.0-only",
                          "AGPL-3.0-or-later",
                          "APL-1.0",
                          "APSL-1.0",
                          "APSL-1.1",
                          "APSL-1.2",
                          "APSL-2.0",
                          "Apache-1.0",
                          "Apache-1.1",
                          "Apache-2.0",
                          "Artistic-1.0",
                          "Artistic-1.0-Perl",
                          "Artistic-1.0-cl8",
                          "Artistic-2.0",
                          "Beerware",
                          "BSD-1-Clause",
                          "BSD-2-Clause",
                          "BSD-2-Clause-FreeBSD",
                          "BSD-2-Clause-Patent",
                          "BSD-3-Clause",
                          "BSD-3-Clause-Clear",
                          "BSD-3-Clause-LBNL",
                          "BSD-4-Clause",
                          "BSL-1.0",
                          "BitTorrent-1.1",
                          "CAL-1.0",
                          "CAL-1.0-Combined-Work-Exception",
                          "CATOSL-1.1",
                          "CC-BY-4.0",
                          "CC-BY-SA-4.0",
                          "CC0-1.0",
                          "CDDL-1.0",
                          "CECILL-2.0",
                          "CECILL-2.1",
                          "CECILL-B",
                          "CECILL-C",
                          "CNRI-Python",
                          "CPAL-1.0",
                          "CPL-1.0",
                          "CUA-OPL-1.0",
                          "ClArtistic",
                          "Condor-1.1",
                          "ECL-1.0",
                          "ECL-2.0",
                          "EFL-1.0",
                          "EFL-2.0",
                          "EPL-1.0",
                          "EPL-2.0",
                          "EUDatagrid",
                          "EUPL-1.1",
                          "EUPL-1.2",
                          "Entessa",
                          "FSFAP",
                          "FTL",
                          "Fair",
                          "Frameworx-1.0",
                          "GFDL-1.1-only",
                          "GFDL-1.1-or-later",
                          "GFDL-1.2-only",
                          "GFDL-1.2-or-later",
                          "GFDL-1.3-only",
                          "GFDL-1.3-or-later",
                          "GPL-2.0-only",
                          "GPL-2.0-or-later",
                          "GPL-3.0-only",
                          "GPL-3.0-or-later",
                          "HPND",
                          "IJG",
                          "IPA",
                          "IPL-1.0",
                          "ISC",
                          "Imlib2",
                          "Intel",
                          "LGPL-2.0-only",
                          "LGPL-2.0-or-later",
                          "LGPL-2.1-only",
                          "LGPL-2.1-or-later",
                          "LGPL-3.0-only",
                          "LGPL-3.0-or-later",
                          "LPL-1.0",
                          "LPL-1.02",
                          "LPPL-1.2",
                          "LPPL-1.3a",
                          "LPPL-1.3c",
                          "LiLiQ-P-1.1",
                          "LiLiQ-R-1.1",
                          "LiLiQ-Rplus-1.1",
                          "MIT",
                          "MIT-0",
                          "MIT-CMU",
                          "MPL-1.0",
                          "MPL-1.1",
                          "MPL-2.0",
                          "MPL-2.0-no-copyleft-exception",
                          "MS-PL",
                          "MS-RL",
                          "MirOS",
                          "Motosoto",
                          "MulanPSL-2.0",
                          "Multics",
                          "NASA-1.3",
                          "NCSA",
                          "NGPL",
                          "NOSL",
                          "NPL-1.0",
                          "NPL-1.1",
                          "NPOSL-3.0",
                          "NTP",
                          "Naumen",
                          "Nokia",
                          "OCLC-2.0",
                          "ODbL-1.0",
                          "OFL-1.0",
                          "OFL-1.1",
                          "OFL-1.1-RFN",
                          "OFL-1.1-no-RFN",
                          "OGTSL",
                          "OLDAP-2.3",
                          "OLDAP-2.7",
                          "OLDAP-2.8",
                          "OSET-PL-2.1",
                          "OSL-1.0",
                          "OSL-1.1",
                          "OSL-2.0",
                          "OSL-2.1",
                          "OSL-3.0",
                          "OpenSSL",
                          "PHP-3.0",
                          "PHP-3.01",
                          "PostgreSQL",
                          "Python-2.0",
                          "QPL-1.0",
                          "RPL-1.1",
                          "RPL-1.5",
                          "RPSL-1.0",
                          "RSCPL",
                          "Ruby",
                          "SGI-B-2.0",
                          "SISSL",
                          "SMLNJ",
                          "SPL-1.0",
                          "SimPL-2.0",
                          "Sleepycat",
                          "UCL-1.0",
                          "UPL-1.0",
                          "Unicode-DFS-2016",
                          "Unlicense",
                          "VSL-1.0",
                          "Vim",
                          "W3C",
                          "WTFPL",
                          "Watcom-1.0",
                          "X11",
                          "XFree86-1.1",
                          "Xnet",
                          "XSkat",
                          "YPL-1.1",
                          "ZPL-2.0",
                          "ZPL-2.1",
                          "Zend-2.0",
                          "Zimbra-1.3",
                          "Zlib",
                          "gnuplot",
                          "iMatix",
                          "xinetd",
                          "PublicDomain"
                        ]
                    ],
              Litecoin =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^([LM3][a-km-zA-HJ-NP-Z1-9]{26,33}|ltc1[a-km-z0-9]{39})$"
                    ],
              MaintainerNotes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 4000
                    ],
              Name = _js2n__-prdslib.isType '"String",
              NoSourceSince = _js2n__-prdslib.isType '"String",
              OpenCollective = _js2n__-prdslib.isType '"String",
              Repo = _js2n__-prdslib.isType '"String",
              RepoType =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "git", "svn", "git-svn", "hg", "bzr", "srclib" ]
                    ],
              RequiresRoot = _js2n__-prdslib.isType '"Bool",
              SourceCode = _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              Summary =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 80
                    ],
              Translation =
                _js2n__-refsenv."_js2n__-:definitions/url!predicate",
              UpdateCheckData = _js2n__-prdslib.isType '"String",
              UpdateCheckIgnore = _js2n__-prdslib.isType '"String",
              UpdateCheckMode =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "None", "Static", "HTTP" ],
                          _js2n__-prdslib.strings.pattern
                            "^RepoManifest(/.+)?$",
                          _js2n__-prdslib.strings.pattern "^Tags( .*)?$"
                        ]
                    ],
              UpdateCheckName =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Ignore" ]
                        ]
                    ],
              VercodeOperation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              WebSite = _js2n__-refsenv."_js2n__-:definitions/url!predicate",
            } {} false _js2n__-prdslib.never
        ])