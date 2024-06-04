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
      "_js2n__-:definitions/address!contract"
        | doc "The address of the place you meet"
        = {
            name | String | doc "The name of the place you meet" | optional,
            street
              | String
              | doc "The street address of your meeting place"
              | optional,
            zipcode
              | String
              | doc "The zip code of your meeting place"
              | optional,
          },
      "_js2n__-:definitions/city!contract" | doc "Name of the city" = String,
      "_js2n__-:definitions/country!contract"
        | doc "Your country, list has been taken from http://countrylist.net/de/"
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'ZW,
                'ZM,
                'YE,
                'EH,
                'WF,
                'VI,
                'VG,
                'VN,
                'VE,
                'VU,
                'UZ,
                'UY,
                'US,
                'GB,
                'AE,
                'UA,
                'UG,
                'TV,
                'TC,
                'TM,
                'TR,
                'TN,
                'TA,
                'TT,
                'TO,
                'TK,
                'TG,
                'TL,
                'TH,
                'TZ,
                'TJ,
                'TW,
                'SY,
                'CH,
                'SE,
                'SZ,
                'SJ,
                'SR,
                'SD,
                'LK,
                'ES,
                'SU,
                'GS,
                'ZA,
                'SO,
                'SB,
                'SI,
                'SK,
                'SG,
                'SL,
                'SC,
                'CS,
                'SN,
                'NT,
                'SA,
                'ST,
                'SM,
                'WS,
                'VC,
                'PM,
                'LC,
                'KN,
                'SH,
                'RW,
                'RU,
                'RO,
                'RE,
                'QA,
                'PR,
                'PT,
                'PL,
                'PN,
                'PH,
                'PE,
                'PY,
                'PG,
                'PA,
                'PS,
                'PW,
                'PK,
                'OM,
                'NO,
                'MP,
                'NF,
                'NU,
                'NG,
                'NE,
                'NI,
                'NZ,
                'NC,
                'AN,
                'NL,
                'NP,
                'NR,
                'NA,
                'MM,
                'MZ,
                'MA,
                'MS,
                'ME,
                'MN,
                'MC,
                'MD,
                'FM,
                'MX,
                'YT,
                'MU,
                'MR,
                'MQ,
                'MH,
                'MT,
                'ML,
                'MV,
                'MY,
                'MW,
                'MG,
                'MK,
                'MO,
                'LU,
                'LT,
                'LI,
                'LY,
                'LR,
                'LS,
                'LB,
                'LV,
                'LA,
                'KG,
                'KW,
                'KR,
                'KP,
                'KI,
                'KE,
                'KZ,
                'JO,
                'JE,
                'JP,
                'JM,
                'IT,
                'IL,
                'IM,
                'IE,
                'IQ,
                'IR,
                'ID,
                'IN,
                'IS,
                'HU,
                'HK,
                'HN,
                'VA,
                'HM,
                'HT,
                'GY,
                'GW,
                'GN,
                'GG,
                'GT,
                'GU,
                'GP,
                'GD,
                'GL,
                'GR,
                'GI,
                'GH,
                'DE,
                'GE,
                'GM,
                'GA,
                'TF,
                'PF,
                'GF,
                'FR,
                'FI,
                'FJ,
                'FO,
                'FK,
                'EU,
                'ET,
                'EE,
                'ER,
                'GQ,
                'SV,
                'EG,
                'EC,
                'DO,
                'DM,
                'DJ,
                'DG,
                'DK,
                'CZ,
                'CY,
                'CU,
                'HR,
                'CI,
                'CR,
                'CK,
                'CD,
                'CG,
                'KM,
                'CO,
                'CC,
                'CX,
                'CN,
                'CL,
                'TD,
                'CF,
                'KY,
                'CV,
                'IC,
                'CA,
                'CM,
                'KH,
                'BI,
                'BF,
                'BG,
                'BN,
                'IO,
                'BR,
                'BV,
                'BW,
                'BA,
                'BO,
                'BT,
                'BM,
                'BJ,
                'BZ,
                'BE,
                'BY,
                'BB,
                'BD,
                'BH,
                'BS,
                'AZ,
                'AT,
                'AU,
                'AC,
                'AW,
                'AM,
                'AR,
                'AG,
                'AQ,
                'AI,
                'AO,
                'AD,
                'AS,
                'DZ,
                'AL,
                'AX,
                'AF,
                '""
              |]
            ],
      "_js2n__-:definitions/email!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^[A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}$"
              ]),
      "_js2n__-:definitions/email!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}$"
            ],
      "_js2n__-:definitions/geoCode!contract" =
        {
            lat | Number | doc "Lattitude of your city in decimal degrees",
            lon | Number | doc "Longitude of your city in decimal degrees",
          },
      "_js2n__-:definitions/phone!predicate" = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/url!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^(http|https)://[A-Za-z0-9ÄÖÜäöüß\\-_\\./]+"
              ]),
      "_js2n__-:definitions/url!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(http|https)://[A-Za-z0-9ÄÖÜäöüß\\-_\\./]+"
            ],
    }
    in
  {
      api
        | std.enum.TagOrString
        | [|
          '"0.5.2",
          '"0.5.1",
          '"0.5.0",
          '"0.4.16",
          '"0.4.15",
          '"0.4.14",
          '"0.4.13",
          '"0.4.12",
          '"0.4.11",
          '"0.4.10",
          '"0.4.9",
          '"0.4.8",
          '"0.4.7",
          '"0.4.6",
          '"0.4.5",
          '"0.4.4",
          '"0.4.3",
          '"0.4.2",
          '"0.4.1",
          '"0.4.0",
          '"0.3.2",
          '"0.3.1",
          '"0.3.0",
          '"0.2.1",
          '"0.2.0",
          '"0.1"
        |]
        | doc "The Freifunk Community API version you use"
        | optional,
      contact
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  email =
                    _js2n__-refsenv."_js2n__-:definitions/email!predicate",
                  facebook =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(http|https)://([a-z\\-]*\\.|)facebook\\.com/[A-Za-z0-9ÄÖÜäöüß\\-_\\.]+"
                        ],
                  googleplus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(http|https)://plus\\.google\\.com/[A-Za-z0-9ÄÖÜäöüß\\+\\-\\./_]+"
                        ],
                  identica =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(http|https)://([a-z\\-]*\\.|)identi\\.ca/[A-Za-z0-9ÄÖÜäöüß\\-_\\.]+"
                        ],
                  irc =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(irc|ircs)://.*"
                        ],
                  jabber =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}(\\?join){0,1}$"
                        ],
                  mastodon =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                  matrix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^https://matrix\\.to/#/"
                        ],
                  ml =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([A-Za-z0-9äöüÄÖUß_\\-\\.]+@[A-Za-z0-9äöüÄÖUß_\\-\\.]+\\.[A-Za-z]{2,}|(http|https)://[A-Za-z0-9ÄÖÜäöüß\\-_\\./]+)$"
                        ],
                  phone =
                    _js2n__-refsenv."_js2n__-:definitions/phone!predicate",
                  twitter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^@[A-Za-z0-9_\\-]{1,15}"
                        ],
                  webform =
                    _js2n__-refsenv."_js2n__-:definitions/url!predicate",
                } {} false _js2n__-prdslib.never
            ]),
      feeds
        | Array
          {
            category
              | std.enum.TagOrString
              | [| '"", 'others, 'wiki, 'podcast, 'ics, 'forum, 'blog |]
              | doc "Category of the feed like blog entries, calendars, forum messages, wiki articles, ..."
              | optional,
            name | String | doc "Name of the feed" | optional,
            type
              | String
              | doc "Type of the feed like RSS, Atom, XML"
              | optional,
            url
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "URL of the feed"
              | optional,
          }
        | doc "Feeds you provide your community"
        | optional,
      location
        | {
          additionalLocations
            | Array
              {
                address
                  | _js2n__-refsenv."_js2n__-:definitions/address!contract"
                  | optional,
                city | _js2n__-refsenv."_js2n__-:definitions/city!contract",
                country
                  | _js2n__-refsenv."_js2n__-:definitions/country!contract"
                  | optional,
                geoCode
                  | _js2n__-refsenv."_js2n__-:definitions/geoCode!contract",
              }
            | doc "Add some more locations where your community is active."
            | optional,
          address
            | _js2n__-refsenv."_js2n__-:definitions/address!contract"
            | optional,
          city | _js2n__-refsenv."_js2n__-:definitions/city!contract",
          country
            | _js2n__-refsenv."_js2n__-:definitions/country!contract"
            | optional,
          geoCode | _js2n__-refsenv."_js2n__-:definitions/geoCode!contract",
        }
        | doc "Position data such as a postal address or geographic coordinates",
      metacommunity
        | String
        | doc "The name of your metacommunity, if your local community belongs to a bigger one"
        | optional,
      name | String | doc "The name of your community",
      nodeMaps
        | Array
          {
            interval
              | String
              | doc "How often the map will be refreshed"
              | optional,
            mapType
              | std.enum.TagOrString
              | [| '"list/status", 'structural, 'geographical, '"" |]
              | doc ""
              | optional,
            technicalType
              | std.enum.TagOrString
              | [|
                'hopglass,
                'meshviewer,
                'nodelist,
                'kml,
                'nodewatcher,
                'libremap,
                'netmon,
                'openwifimap,
                'olsr-dot,
                'ffsomething,
                'ffmap,
                '""
              |]
              | doc "The kind of map is used"
              | optional,
            url
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "The URL where the map is located"
              | optional,
          }
        | doc "Maps of nodes or topology your community provides"
        | optional,
      privacy
        | {
          policyurl
            | _js2n__-refsenv."_js2n__-:definitions/url!contract"
            | doc "URL to your privacy policy description"
            | optional,
        }
        | optional,
      services
        | Array
          {
            externalUri
              | String
              | doc "URI to use your service from the internet"
              | optional,
            internalUri
              | String
              | doc "URI to use your service from Freifunk or icvpn-networks"
              | optional,
            serviceDescription
              | String
              | doc "Describe your service"
              | optional,
            serviceName
              | String
              | doc "Name of your service (e.g. jabber...)"
              | optional,
          }
        | doc "Services Provided by your community"
        | optional,
      socialprojects
        | {
          contact
            | _js2n__-refsenv."_js2n__-:definitions/email!contract"
            | doc "Please provide an email address to contact you on refugees and social projects"
            | optional,
          number
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.isType 'Integer)
            | doc "Number of projects supported by your Community"
            | optional,
          website
            | _js2n__-refsenv."_js2n__-:definitions/url!contract"
            | doc "A link to a web site where people can find an overview over your projects"
            | optional,
        }
        | optional,
      state
        | {
          description
            | String
            | doc "Describe your community in a few lines"
            | optional,
          focus
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "infrastructure/backbone",
                            "Public Free Wifi",
                            "Social Community Building",
                            "Local services and content",
                            "Free internet access"
                          ]
                      ])
                ])
            | doc "What's the focus of your local community?"
            | optional,
          lastchange
            | String
            | doc "At what ISO 8601 timestamp has your community status lastly changed?",
          message
            | String
            | doc "A free-form string something like 'open for public', 'members only' or whatever you want it to be)"
            | optional,
          nodes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Number of active nodes. This field is predestined to be updated regularly, please see sample solutions for <a href=\"https://github.com/Freifunk-Mainz/changeffapi\" target=\"_blank\">Gluon</a> or <a href=\"https://github.com/freifunk/common.api.freifunk.net/blob/master/contrib/ffapi-update-nodes.py\" target=\"_blank\">OLSR</a>"
            | optional,
        }
        | doc "A collection of status-related data. Actual open/closed status, icons, last change timestamp etc.",
      support
        | {
          club
            | {
              board
                | Array (String)
                | doc "Who are the board members of the club?"
                | optional,
              city
                | _js2n__-refsenv."_js2n__-:definitions/city!contract"
                | optional,
              email
                | _js2n__-refsenv."_js2n__-:definitions/email!contract"
                | doc "Email address to contact the club (user@domain.com)"
                | optional,
              name | String | doc "Name of the Club" | optional,
              street | String | doc "Address - Street" | optional,
              url
                | _js2n__-refsenv."_js2n__-:definitions/url!contract"
                | doc "The club's website (http{s}://...)"
                | optional,
              zip | String | doc "Address - ZIP" | optional,
            }
            | optional,
          donations
            | {
              bankaccount
                | {
                  BIC | String | optional,
                  IBAN | String | optional,
                  usage
                    | String
                    | doc "Please use this string as transfer-purpose to define a special usage of your donation."
                    | optional,
                }
                | optional,
              campaigns
                | Array
                  {
                    projectid
                      | String
                      | doc "ID of your project, Betterplace-IDs are multiple digits and can be found within the URL"
                      | optional,
                    provider
                      | std.enum.TagOrString
                      | [| 'boost, 'betterplace, '"" |]
                      | doc "Where do you host your donations?"
                      | optional,
                  }
                | optional,
            }
            | optional,
        }
        | optional,
      techDetails
        | {
          dns
            | Array
              {
                domainname
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern
                          "^[A-Za-z0-9äöüÄÖÜß\\.\\-\\_]{2,}$"
                      ])
                  | doc "The domain name (e.g. ffhh, ffol)"
                  | optional,
                nameserver
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[A-Za-z0-9äöüÄÖÜß_\\-\\.:]*$"
                        ])
                  )
                  | doc "Nameservers servings zones of your domain"
                  | optional,
              }
            | doc "DNS servers for domains used by your community"
            | optional,
          firmware
            | {
              docs
                | _js2n__-refsenv."_js2n__-:definitions/url!contract"
                | doc "Link to your firmware docs"
                | optional,
              name | String | doc "Name of your firmware" | optional,
              orgrestrictions
                | String
                | doc "Are there any organizational restrictions when using/installing your firmware?"
                | optional,
              registrationurl
                | _js2n__-refsenv."_js2n__-:definitions/url!contract"
                | doc "link to your website to request a new VPN key"
                | optional,
              techrestrictions
                | String
                | doc "Are there any technical restrictions like hardware?"
                | optional,
              url
                | _js2n__-refsenv."_js2n__-:definitions/url!contract"
                | doc "Link to your firmware images"
                | optional,
              vpnaccess
                | std.enum.TagOrString
                | [| '"else", 'webform, 'mail, 'fwimage, 'automatic, '"" |]
                | doc "How to access your VPN services"
                | optional,
            }
            | optional,
          legals
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "nothing",
                            "vpnnational",
                            "vpninternational",
                            "zappscript",
                            "p2pblock",
                            "splashpage",
                            "termsconditions",
                            "anonymizer",
                            "institutions"
                          ]
                      ])
                ])
            | doc "What do you use to handle legal issues, e.g. the German Störerhaftung or restrictions in your country?"
            | optional,
          networks
            | {
              ipv4
                | Array
                  {
                    network
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(\\d|[1-2]\\d|3[0-2]))$"
                          ])
                      | doc "IPv4 network name (e.g. 10.w.x.y/z) in CIDR notation"
                      | optional,
                  }
                | doc "IPv4 networks used by your community"
                | optional,
              ipv6
                | Array
                  {
                    network
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^\\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:)))(%.+)?\\s*(\\/(\\d|\\d\\d|1[0-1]\\d|12[0-8]))$"
                          ])
                      | doc "IPv6 network network (e.g.2620:0:2d0:200::7/32) in CIDR notation"
                      | optional,
                  }
                | doc "IPv6 networks used by your community"
                | optional,
            }
            | doc "Networks used by your community"
            | optional,
          routing
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "802.11s",
                            "Babel",
                            "batman-adv",
                            "bmx6",
                            "bmxd",
                            "cjdns",
                            "OLSR",
                            "OLSRv2"
                          ]
                      ])
                ])
            | doc "Routing protocols used within your community"
            | optional,
          updatemode
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "none", "manual", "autoupdate" ]
                      ])
                ])
            | doc "How do you deploy firmware updates?"
            | optional,
        }
        | doc "Technical details of your community's Freifunk implementation",
      timeline
        | Array
          {
            description
              | String
              | doc "Description of your lifetime event"
              | optional,
            timestamp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^([0-9]{4})(?:-?W([0-9]+)(?:-?([0-9]+)D?)?|(?:-([0-9]+))?-([0-9]+))(?:[T ]([0-9]+):([0-9]+)(?::([0-9]+)(?:\\.([0-9]+))?)?)?(?:Z(-?[0-9]*))?"
                  ])
              | doc "ISO 8601 timestamp of the event's date (format yyyy-mm-dd)"
              | optional,
            url
              | _js2n__-refsenv."_js2n__-:definitions/url!contract"
              | doc "URL to details of this timeline-element"
              | optional,
          }
        | doc "These are lifetime events something like date of birth (and rebirth :-) of your community or other important milestones"
        | optional,
      url
        | _js2n__-refsenv."_js2n__-:definitions/url!contract"
        | doc "The main website (http{s}://...)",
    }