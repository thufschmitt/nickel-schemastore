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
      "_js2n__-:definitions/plugins?interface=task!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  abort = _js2n__-prdslib.always,
                  abort_if_exists = _js2n__-prdslib.always,
                  accept_all = _js2n__-prdslib.always,
                  add_trackers = _js2n__-prdslib.always,
                  age = _js2n__-prdslib.always,
                  all_series = _js2n__-prdslib.always,
                  anidb_list = _js2n__-prdslib.always,
                  anilist = _js2n__-prdslib.always,
                  apple_trailers = _js2n__-prdslib.always,
                  archive = _js2n__-prdslib.always,
                  archives = _js2n__-prdslib.always,
                  aria2 = _js2n__-prdslib.always,
                  assume_quality = _js2n__-prdslib.always,
                  backlog = _js2n__-prdslib.always,
                  best_quality = _js2n__-prdslib.always,
                  betaseries_list = _js2n__-prdslib.always,
                  bluray_lookup = _js2n__-prdslib.always,
                  cfscraper = _js2n__-prdslib.always,
                  change_warn = _js2n__-prdslib.always,
                  check_subtitles = _js2n__-prdslib.always,
                  clean_transmission = _js2n__-prdslib.always,
                  configure_series = _js2n__-prdslib.always,
                  content_filter = _js2n__-prdslib.always,
                  content_size = _js2n__-prdslib.always,
                  convert_magnet = _js2n__-prdslib.always,
                  cookies = _js2n__-prdslib.always,
                  copy = _js2n__-prdslib.always,
                  couchpotato_list = _js2n__-prdslib.always,
                  cronitor = _js2n__-prdslib.always,
                  crossmatch = _js2n__-prdslib.always,
                  csv = _js2n__-prdslib.always,
                  decompress = _js2n__-prdslib.always,
                  delay = _js2n__-prdslib.always,
                  delete = _js2n__-prdslib.always,
                  deluge = _js2n__-prdslib.always,
                  details = _js2n__-prdslib.always,
                  digest = _js2n__-prdslib.always,
                  disable = _js2n__-prdslib.always,
                  disable_phases = _js2n__-prdslib.always,
                  disable_urlrewriters = _js2n__-prdslib.always,
                  discover = _js2n__-prdslib.always,
                  domain_delay = _js2n__-prdslib.always,
                  download = _js2n__-prdslib.always,
                  download_auth = _js2n__-prdslib.always,
                  dump = _js2n__-prdslib.always,
                  dump_config = _js2n__-prdslib.always,
                  duplicates = _js2n__-prdslib.always,
                  emby_list = _js2n__-prdslib.always,
                  emby_lookup = _js2n__-prdslib.always,
                  emby_refresh = _js2n__-prdslib.always,
                  entry_list = _js2n__-prdslib.always,
                  entry_operations = _js2n__-prdslib.always,
                  exec = _js2n__-prdslib.always,
                  exists = _js2n__-prdslib.always,
                  exists_movie = _js2n__-prdslib.always,
                  exists_series = _js2n__-prdslib.always,
                  extension = _js2n__-prdslib.always,
                  filesystem = _js2n__-prdslib.always,
                  filmweb_watchlist = _js2n__-prdslib.always,
                  form = _js2n__-prdslib.always,
                  free_space = _js2n__-prdslib.always,
                  from_deluge = _js2n__-prdslib.always,
                  from_digest = _js2n__-prdslib.always,
                  from_emby = _js2n__-prdslib.always,
                  from_imdb = _js2n__-prdslib.always,
                  from_piratebay = _js2n__-prdslib.always,
                  from_qbittorrent = _js2n__-prdslib.always,
                  from_rtorrent = _js2n__-prdslib.always,
                  from_task = _js2n__-prdslib.always,
                  from_telegram = _js2n__-prdslib.always,
                  from_transmission = _js2n__-prdslib.always,
                  ftp_download = _js2n__-prdslib.always,
                  ftp_list = _js2n__-prdslib.always,
                  gazelle = _js2n__-prdslib.always,
                  gazellemusic = _js2n__-prdslib.always,
                  gen_series_data = _js2n__-prdslib.always,
                  generate = _js2n__-prdslib.always,
                  headers = _js2n__-prdslib.always,
                  history = _js2n__-prdslib.always,
                  horriblesubs = _js2n__-prdslib.always,
                  html = _js2n__-prdslib.always,
                  "if" = _js2n__-prdslib.always,
                  imdb = _js2n__-prdslib.always,
                  imdb_list = _js2n__-prdslib.always,
                  imdb_lookup = _js2n__-prdslib.always,
                  imdb_watchlist = _js2n__-prdslib.always,
                  include = _js2n__-prdslib.always,
                  inputs = _js2n__-prdslib.always,
                  interval = _js2n__-prdslib.always,
                  json = _js2n__-prdslib.always,
                  kitsu = _js2n__-prdslib.always,
                  kodi_library = _js2n__-prdslib.always,
                  letterboxd = _js2n__-prdslib.always,
                  limit = _js2n__-prdslib.always,
                  limit_new = _js2n__-prdslib.always,
                  list_add = _js2n__-prdslib.always,
                  list_clear = _js2n__-prdslib.always,
                  list_match = _js2n__-prdslib.always,
                  list_remove = _js2n__-prdslib.always,
                  log_filter = _js2n__-prdslib.always,
                  lostfilm = _js2n__-prdslib.always,
                  magnet_btih = _js2n__-prdslib.always,
                  magnetdl = _js2n__-prdslib.always,
                  magnets = _js2n__-prdslib.always,
                  make_html = _js2n__-prdslib.always,
                  make_rss = _js2n__-prdslib.always,
                  manipulate = _js2n__-prdslib.always,
                  manual = _js2n__-prdslib.always,
                  max_reruns = _js2n__-prdslib.always,
                  medusa = _js2n__-prdslib.always,
                  metainfo_content_size = _js2n__-prdslib.always,
                  metainfo_media_id = _js2n__-prdslib.always,
                  metainfo_movie = _js2n__-prdslib.always,
                  metainfo_quality = _js2n__-prdslib.always,
                  metainfo_series = _js2n__-prdslib.always,
                  metainfo_task = _js2n__-prdslib.always,
                  mock = _js2n__-prdslib.always,
                  mock_output = _js2n__-prdslib.always,
                  modify_trackers = _js2n__-prdslib.always,
                  move = _js2n__-prdslib.always,
                  movie_list = _js2n__-prdslib.always,
                  my_anime_list = _js2n__-prdslib.always,
                  myepisodes = _js2n__-prdslib.always,
                  myepisodes_list = _js2n__-prdslib.always,
                  next_series_episodes = _js2n__-prdslib.always,
                  next_series_seasons = _js2n__-prdslib.always,
                  next_sonarr_episodes = _js2n__-prdslib.always,
                  next_trakt_episodes = _js2n__-prdslib.always,
                  nfo_lookup = _js2n__-prdslib.always,
                  no_entries_ok = _js2n__-prdslib.always,
                  notify = _js2n__-prdslib.always,
                  notwhatcd = _js2n__-prdslib.always,
                  npo_watchlist = _js2n__-prdslib.always,
                  nzb_size = _js2n__-prdslib.always,
                  nzbget = _js2n__-prdslib.always,
                  ombi_list = _js2n__-prdslib.always,
                  only_new = _js2n__-prdslib.always,
                  parameterize = _js2n__-prdslib.always,
                  parsing = _js2n__-prdslib.always,
                  path_by_ext = _js2n__-prdslib.always,
                  path_by_space = _js2n__-prdslib.always,
                  pathscrub = _js2n__-prdslib.always,
                  pending_approval = _js2n__-prdslib.always,
                  pending_list = _js2n__-prdslib.always,
                  periscope = _js2n__-prdslib.always,
                  piratebay = _js2n__-prdslib.always,
                  plex = _js2n__-prdslib.always,
                  plex_watchlist = _js2n__-prdslib.always,
                  plugin_priority = _js2n__-prdslib.always,
                  pogcal = _js2n__-prdslib.always,
                  pogcal_acquired = _js2n__-prdslib.always,
                  "priority" = _js2n__-prdslib.always,
                  private_torrents = _js2n__-prdslib.always,
                  proper_movies = _js2n__-prdslib.always,
                  proxy = _js2n__-prdslib.always,
                  pyload = _js2n__-prdslib.always,
                  qbittorrent = _js2n__-prdslib.always,
                  quality = _js2n__-prdslib.always,
                  radarr_list = _js2n__-prdslib.always,
                  redacted = _js2n__-prdslib.always,
                  redirect_url = _js2n__-prdslib.always,
                  regex_extract = _js2n__-prdslib.always,
                  regexp = _js2n__-prdslib.always,
                  regexp_list = _js2n__-prdslib.always,
                  regexp_parse = _js2n__-prdslib.always,
                  remember_rejected = _js2n__-prdslib.always,
                  remove_trackers = _js2n__-prdslib.always,
                  reorder_quality = _js2n__-prdslib.always,
                  require_field = _js2n__-prdslib.always,
                  rerun = _js2n__-prdslib.always,
                  retry_failed = _js2n__-prdslib.always,
                  rlsbb = _js2n__-prdslib.always,
                  rlslog = _js2n__-prdslib.always,
                  rmz = _js2n__-prdslib.always,
                  rottentomatoes = _js2n__-prdslib.always,
                  rottentomatoes_list = _js2n__-prdslib.always,
                  rottentomatoes_lookup = _js2n__-prdslib.always,
                  rss = _js2n__-prdslib.always,
                  rtorrent = _js2n__-prdslib.always,
                  rtorrent_magnet = _js2n__-prdslib.always,
                  run_task = _js2n__-prdslib.always,
                  rutracker_auth = _js2n__-prdslib.always,
                  sabnzbd = _js2n__-prdslib.always,
                  scan_imdb = _js2n__-prdslib.always,
                  sceper = _js2n__-prdslib.always,
                  seen = _js2n__-prdslib.always,
                  seen_info_hash = _js2n__-prdslib.always,
                  seen_movies = _js2n__-prdslib.always,
                  sequence = _js2n__-prdslib.always,
                  serienjunkies = _js2n__-prdslib.always,
                  series = _js2n__-prdslib.always,
                  series_db = _js2n__-prdslib.always,
                  series_premiere = _js2n__-prdslib.always,
                  series_remove = _js2n__-prdslib.always,
                  set = _js2n__-prdslib.always,
                  set_series_begin = _js2n__-prdslib.always,
                  sftp_download = _js2n__-prdslib.always,
                  sftp_list = _js2n__-prdslib.always,
                  sftp_upload = _js2n__-prdslib.always,
                  sickbeard = _js2n__-prdslib.always,
                  sleep = _js2n__-prdslib.always,
                  sns = _js2n__-prdslib.always,
                  solidtorrents = _js2n__-prdslib.always,
                  sonarr_list = _js2n__-prdslib.always,
                  sort_by = _js2n__-prdslib.always,
                  sort_by_weight = _js2n__-prdslib.always,
                  spy_headers = _js2n__-prdslib.always,
                  status = _js2n__-prdslib.always,
                  subliminal = _js2n__-prdslib.always,
                  subtitle_list = _js2n__-prdslib.always,
                  subtitles = _js2n__-prdslib.always,
                  symlink = _js2n__-prdslib.always,
                  tail = _js2n__-prdslib.always,
                  template = _js2n__-prdslib.always,
                  text = _js2n__-prdslib.always,
                  thetvdb = _js2n__-prdslib.always,
                  thetvdb_list = _js2n__-prdslib.always,
                  thetvdb_lookup = _js2n__-prdslib.always,
                  timeframe = _js2n__-prdslib.always,
                  tmdb_lookup = _js2n__-prdslib.always,
                  torrent = _js2n__-prdslib.always,
                  torrent_alive = _js2n__-prdslib.always,
                  torrent_cache = _js2n__-prdslib.always,
                  torrent_files = _js2n__-prdslib.always,
                  torrent_match = _js2n__-prdslib.always,
                  torrent_scrub = _js2n__-prdslib.always,
                  torrent_size = _js2n__-prdslib.always,
                  trakt_calendar = _js2n__-prdslib.always,
                  trakt_list = _js2n__-prdslib.always,
                  trakt_lookup = _js2n__-prdslib.always,
                  transmission = _js2n__-prdslib.always,
                  tvmaze_lookup = _js2n__-prdslib.always,
                  twitterfeed = _js2n__-prdslib.always,
                  unique = _js2n__-prdslib.always,
                  upgrade = _js2n__-prdslib.always,
                  urlfix = _js2n__-prdslib.always,
                  urlrewrite = _js2n__-prdslib.always,
                  urlrewrite_search = _js2n__-prdslib.always,
                  urlrewriting = _js2n__-prdslib.always,
                  utorrent = _js2n__-prdslib.always,
                  verbose = _js2n__-prdslib.always,
                  verify_ssl_certificates = _js2n__-prdslib.always,
                  version_checker = _js2n__-prdslib.always,
                  wordpress_auth = _js2n__-prdslib.always,
                  yaml_list = _js2n__-prdslib.always,
                } { "^_" = _js2n__-prdslib.always, } false _js2n__-prdslib.never
            ],
    }
    in
  {
      irc
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
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
                                      [ "channels", "server" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "tracker_file" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ]
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "task" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "task_re" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ]
                              ]
                          ],
                        _js2n__-prdslib.records.required [ "port" ],
                        _js2n__-prdslib.records.record
                          {
                            channels =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^([#&][^\\x07\\x2C\\s]{0,200})"
                                            ]),
                                        _js2n__-prdslib.arrays.minItems 1
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.pattern
                                          "^([#&][^\\x07\\x2C\\s]{0,200})"
                                      ]
                                  ],
                            invite_message = _js2n__-prdslib.isType '"String",
                            invite_nickname = _js2n__-prdslib.isType '"String",
                            nickname = _js2n__-prdslib.isType '"String",
                            nickserv_password =
                              _js2n__-prdslib.isType '"String",
                            password = _js2n__-prdslib.isType '"String",
                            port = _js2n__-prdslib.isType 'Integer,
                            queue_size = _js2n__-prdslib.isType 'Integer,
                            server = _js2n__-prdslib.isType '"String",
                            task =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String"),
                                        _js2n__-prdslib.arrays.minItems 1
                                      ],
                                    _js2n__-prdslib.isType '"String"
                                  ],
                            task_delay = _js2n__-prdslib.isType 'Integer,
                            task_re =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "patterns", "task" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              patterns =
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
                                                                "field",
                                                                "regexp"
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                field =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                regexp =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ])
                                                    ],
                                              task =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ],
                            tracker_file = _js2n__-prdslib.isType '"String",
                            use_ssl = _js2n__-prdslib.isType '"Bool",
                          } {} true (_js2n__-prdslib.isType '"String")
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.enum [ false ]
                ]
            ])
        | optional,
      log_filter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.minProperties 1,
                    _js2n__-prdslib.records.record
                      {
                        level =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "trace",
                                    "debug",
                                    "verbose",
                                    "info",
                                    "success",
                                    "warning",
                                    "error",
                                    "critical"
                                  ]
                              ],
                        message = _js2n__-prdslib.isType '"String",
                        plugin = _js2n__-prdslib.isType '"String",
                        task = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ])
        | optional,
      schedules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.maxProperties 2,
                        _js2n__-prdslib.records.minProperties 2,
                        _js2n__-prdslib.records.required [ "tasks" ],
                        _js2n__-prdslib.records.record
                          {
                            interval =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "minutes" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "hours" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "days" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "weeks" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ]
                                      ],
                                    _js2n__-prdslib.records.record
                                      {
                                        days = _js2n__-prdslib.isType '"Number",
                                        hours =
                                          _js2n__-prdslib.isType '"Number",
                                        jitter =
                                          _js2n__-prdslib.isType 'Integer,
                                        minutes =
                                          _js2n__-prdslib.isType '"Number",
                                        weeks =
                                          _js2n__-prdslib.isType '"Number",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            schedule =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        day =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        day_of_week =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        hour =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        jitter =
                                          _js2n__-prdslib.isType 'Integer,
                                        minute =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        month =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        week =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        year =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            tasks =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String"),
                                        _js2n__-prdslib.arrays.minItems 1
                                      ],
                                    _js2n__-prdslib.isType '"String"
                                  ],
                          } {} false _js2n__-prdslib.never
                      ])
                ],
              _js2n__-prdslib.isType '"Bool"
            ])
        | doc "Runs tasks periodically (when FlexGet is run as a daemon)"
        | optional,
      tasks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/plugins?interface=task!predicate"
            ])
        | doc "All tasks which can be run by FlexGet are defined in this section",
      templates
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/plugins?interface=task!predicate"
            ])
        | optional,
      variables
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType 'Record
            ])
        | optional,
      web_server
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.maximum 65536,
                  _js2n__-prdslib.numbers.minimum 0
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      base_url = _js2n__-prdslib.isType '"String",
                      bind = _js2n__-prdslib.isType '"String",
                      port =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 65536,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      run_v1 = _js2n__-prdslib.isType '"Bool",
                      run_v2 = _js2n__-prdslib.isType '"Bool",
                      ssl_certificate = _js2n__-prdslib.isType '"String",
                      ssl_private_key = _js2n__-prdslib.isType '"String",
                      web_ui = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.dependencies
                    {
                      ssl_certificate = [ "ssl_private_key" ],
                      ssl_private_key = [ "ssl_certificate" ],
                    }
                ]
            ])
        | optional,
    }