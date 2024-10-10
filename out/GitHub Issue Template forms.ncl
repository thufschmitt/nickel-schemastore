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
      "_js2n__-:definitions/assignee!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 39,
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9](-?[a-zA-Z0-9])*$"
            ],
      "_js2n__-:definitions/description!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/form_item!predicate"
        | doc m%"
          A form item
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "markdown", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "attributes", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            attributes =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "value" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        value =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.strings.minLength
                                                  1
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            type =
                              _js2n__-refsenv."_js2n__-:definitions/type!predicate",
                          } {} false _js2n__-prdslib.never
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "textarea", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "attributes", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            attributes =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "label" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        description =
                                          _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                                        label =
                                          _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                                        placeholder =
                                          _js2n__-refsenv."_js2n__-:definitions/placeholder!predicate",
                                        render =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "1C Enterprise",
                                                    "1c enterprise",
                                                    "2-Dimensional Array",
                                                    "2-dimensional array",
                                                    "4D",
                                                    "4d",
                                                    "ABAP",
                                                    "ABAP CDS",
                                                    "ABNF",
                                                    "AFDKO",
                                                    "AGS Script",
                                                    "AIDL",
                                                    "AL",
                                                    "AMPL",
                                                    "ANTLR",
                                                    "API Blueprint",
                                                    "APL",
                                                    "ASL",
                                                    "ASN.1",
                                                    "ASP.NET",
                                                    "ATS",
                                                    "ActionScript",
                                                    "Ada",
                                                    "Adblock Filter List",
                                                    "Adobe Font Metrics",
                                                    "Agda",
                                                    "Alloy",
                                                    "Alpine Abuild",
                                                    "Altium Designer",
                                                    "AngelScript",
                                                    "Ant Build System",
                                                    "Antlers",
                                                    "ApacheConf",
                                                    "Apex",
                                                    "Apollo Guidance Computer",
                                                    "AppleScript",
                                                    "Arc",
                                                    "AsciiDoc",
                                                    "AspectJ",
                                                    "Assembly",
                                                    "Astro",
                                                    "Asymptote",
                                                    "Augeas",
                                                    "AutoHotkey",
                                                    "AutoIt",
                                                    "AutoIt3",
                                                    "AutoItScript",
                                                    "Avro IDL",
                                                    "Awk",
                                                    "BASIC",
                                                    "Ballerina",
                                                    "Batchfile",
                                                    "Beef",
                                                    "Befunge",
                                                    "Berry",
                                                    "BibTeX",
                                                    "Bicep",
                                                    "Bikeshed",
                                                    "Bison",
                                                    "BitBake",
                                                    "Blade",
                                                    "BlitzBasic",
                                                    "BlitzMax",
                                                    "Bluespec",
                                                    "Bluespec BH",
                                                    "Boo",
                                                    "Boogie",
                                                    "Brainfuck",
                                                    "BrighterScript",
                                                    "Brightscript",
                                                    "Browserslist",
                                                    "C",
                                                    "C#",
                                                    "C++",
                                                    "C-ObjDump",
                                                    "C2hs Haskell",
                                                    "CAP CDS",
                                                    "CIL",
                                                    "CLIPS",
                                                    "CMake",
                                                    "COBOL",
                                                    "CODEOWNERS",
                                                    "COLLADA",
                                                    "CSON",
                                                    "CSS",
                                                    "CSV",
                                                    "CUE",
                                                    "CWeb",
                                                    "Cabal",
                                                    "Cabal Config",
                                                    "Cadence",
                                                    "Cairo",
                                                    "CameLIGO",
                                                    "Cap'n Proto",
                                                    "Carto",
                                                    "CartoCSS",
                                                    "Ceylon",
                                                    "Chapel",
                                                    "Charity",
                                                    "Checksums",
                                                    "ChucK",
                                                    "Circom",
                                                    "Cirru",
                                                    "Clarion",
                                                    "Clarity",
                                                    "Classic ASP",
                                                    "Clean",
                                                    "Click",
                                                    "Clojure",
                                                    "Closure Templates",
                                                    "Cloud Firestore Security Rules",
                                                    "CoNLL",
                                                    "CoNLL-U",
                                                    "CoNLL-X",
                                                    "CodeQL",
                                                    "CoffeeScript",
                                                    "ColdFusion",
                                                    "ColdFusion CFC",
                                                    "Common Lisp",
                                                    "Common Workflow Language",
                                                    "Component Pascal",
                                                    "Containerfile",
                                                    "Cool",
                                                    "Coq",
                                                    "Cpp-ObjDump",
                                                    "Creole",
                                                    "Crystal",
                                                    "Csound",
                                                    "Csound Document",
                                                    "Csound Score",
                                                    "Cuda",
                                                    "Cue Sheet",
                                                    "Curry",
                                                    "Cycript",
                                                    "Cypher",
                                                    "Cython",
                                                    "D",
                                                    "D-ObjDump",
                                                    "D2",
                                                    "DIGITAL Command Language",
                                                    "DM",
                                                    "DNS Zone",
                                                    "DTrace",
                                                    "Dafny",
                                                    "Darcs Patch",
                                                    "Dart",
                                                    "DataWeave",
                                                    "Debian Package Control File",
                                                    "DenizenScript",
                                                    "Dhall",
                                                    "Diff",
                                                    "DirectX 3D File",
                                                    "Dlang",
                                                    "Dockerfile",
                                                    "Dogescript",
                                                    "Dotenv",
                                                    "Dylan",
                                                    "E",
                                                    "E-mail",
                                                    "EBNF",
                                                    "ECL",
                                                    "ECLiPSe",
                                                    "EJS",
                                                    "EQ",
                                                    "Eagle",
                                                    "Earthfile",
                                                    "Earthly",
                                                    "Easybuild",
                                                    "Ecere Projects",
                                                    "Ecmarkup",
                                                    "EdgeQL",
                                                    "EditorConfig",
                                                    "Edje Data Collection",
                                                    "Eiffel",
                                                    "Elixir",
                                                    "Elm",
                                                    "Elvish",
                                                    "Elvish Transcript",
                                                    "Emacs Lisp",
                                                    "EmberScript",
                                                    "Erlang",
                                                    "Euphoria",
                                                    "F#",
                                                    "F*",
                                                    "FIGfont",
                                                    "FIGlet Font",
                                                    "FLUX",
                                                    "Factor",
                                                    "Fancy",
                                                    "Fantom",
                                                    "Faust",
                                                    "Fennel",
                                                    "Filebench WML",
                                                    "Filterscript",
                                                    "Fluent",
                                                    "Formatted",
                                                    "Forth",
                                                    "Fortran",
                                                    "Fortran Free Form",
                                                    "FreeBasic",
                                                    "FreeMarker",
                                                    "Frege",
                                                    "Futhark",
                                                    "G-code",
                                                    "GAML",
                                                    "GAMS",
                                                    "GAP",
                                                    "GCC Machine Description",
                                                    "GDB",
                                                    "GDScript",
                                                    "GEDCOM",
                                                    "GLSL",
                                                    "GN",
                                                    "GSC",
                                                    "Game Maker Language",
                                                    "Gemfile.lock",
                                                    "Gemini",
                                                    "Genero 4gl",
                                                    "Genero per",
                                                    "Genie",
                                                    "Genshi",
                                                    "Gentoo Ebuild",
                                                    "Gentoo Eclass",
                                                    "Gerber Image",
                                                    "Gettext Catalog",
                                                    "Gherkin",
                                                    "Git Attributes",
                                                    "Git Blame Ignore Revs",
                                                    "Git Config",
                                                    "Git Revision List",
                                                    "Gleam",
                                                    "Glimmer JS",
                                                    "Glyph",
                                                    "Glyph Bitmap Distribution Format",
                                                    "Gnuplot",
                                                    "Go",
                                                    "Go Checksums",
                                                    "Go Module",
                                                    "Go Workspace",
                                                    "Godot Resource",
                                                    "Golo",
                                                    "Gosu",
                                                    "Grace",
                                                    "Gradle",
                                                    "Gradle Kotlin DSL",
                                                    "Grammatical Framework",
                                                    "Graph Modeling Language",
                                                    "GraphQL",
                                                    "Graphviz (DOT)",
                                                    "Groovy",
                                                    "Groovy Server Pages",
                                                    "HAProxy",
                                                    "HCL",
                                                    "HLSL",
                                                    "HOCON",
                                                    "HTML",
                                                    "HTML+ECR",
                                                    "HTML+EEX",
                                                    "HTML+ERB",
                                                    "HTML+PHP",
                                                    "HTML+Razor",
                                                    "HTTP",
                                                    "HXML",
                                                    "Hack",
                                                    "Haml",
                                                    "Handlebars",
                                                    "Harbour",
                                                    "HashiCorp Configuration Language",
                                                    "Haskell",
                                                    "Haxe",
                                                    "HiveQL",
                                                    "HolyC",
                                                    "Hosts File",
                                                    "Hy",
                                                    "HyPhy",
                                                    "IDL",
                                                    "IGOR Pro",
                                                    "INI",
                                                    "IPython Notebook",
                                                    "IRC log",
                                                    "Idris",
                                                    "Ignore List",
                                                    "ImageJ Macro",
                                                    "Imba",
                                                    "Inform 7",
                                                    "Ink",
                                                    "Inno Setup",
                                                    "Io",
                                                    "Ioke",
                                                    "Isabelle",
                                                    "Isabelle ROOT",
                                                    "J",
                                                    "JAR Manifest",
                                                    "JCL",
                                                    "JFlex",
                                                    "JSON",
                                                    "JSON with Comments",
                                                    "JSON5",
                                                    "JSONLD",
                                                    "JSONiq",
                                                    "Janet",
                                                    "Jasmin",
                                                    "Java",
                                                    "Java Properties",
                                                    "Java Server Pages",
                                                    "JavaScript",
                                                    "JavaScript+ERB",
                                                    "Jest Snapshot",
                                                    "JetBrains MPS",
                                                    "Jinja",
                                                    "Jison",
                                                    "Jison Lex",
                                                    "Jolie",
                                                    "Jsonnet",
                                                    "Julia",
                                                    "Jupyter Notebook",
                                                    "Just",
                                                    "Justfile",
                                                    "KRL",
                                                    "Kaitai Struct",
                                                    "KakouneScript",
                                                    "KerboScript",
                                                    "KiCad Layout",
                                                    "KiCad Legacy Layout",
                                                    "KiCad Schematic",
                                                    "Kickstart",
                                                    "Kit",
                                                    "Kotlin",
                                                    "Kusto",
                                                    "LFE",
                                                    "LLVM",
                                                    "LOLCODE",
                                                    "LSL",
                                                    "LTspice Symbol",
                                                    "LabVIEW",
                                                    "Lark",
                                                    "Lasso",
                                                    "Latte",
                                                    "Lean",
                                                    "Lean 4",
                                                    "Less",
                                                    "Lex",
                                                    "LigoLANG",
                                                    "LilyPond",
                                                    "Limbo",
                                                    "Linker Script",
                                                    "Linux Kernel Module",
                                                    "Liquid",
                                                    "Literate Agda",
                                                    "Literate CoffeeScript",
                                                    "Literate Haskell",
                                                    "LiveScript",
                                                    "Logos",
                                                    "Logtalk",
                                                    "LookML",
                                                    "LoomScript",
                                                    "Lua",
                                                    "M",
                                                    "M4",
                                                    "M4Sugar",
                                                    "MATLAB",
                                                    "MAXScript",
                                                    "MDX",
                                                    "MLIR",
                                                    "MQL4",
                                                    "MQL5",
                                                    "MTML",
                                                    "MUF",
                                                    "Macaulay2",
                                                    "Makefile",
                                                    "Mako",
                                                    "Markdown",
                                                    "Marko",
                                                    "Mask",
                                                    "Mathematica",
                                                    "Maven POM",
                                                    "Max",
                                                    "Mercury",
                                                    "Mermaid",
                                                    "Meson",
                                                    "Metal",
                                                    "Microsoft Developer Studio Project",
                                                    "Microsoft Visual Studio Solution",
                                                    "MiniD",
                                                    "MiniYAML",
                                                    "Mint",
                                                    "Mirah",
                                                    "Modelica",
                                                    "Modula-2",
                                                    "Modula-3",
                                                    "Module Management System",
                                                    "Monkey",
                                                    "Monkey C",
                                                    "Moocode",
                                                    "MoonScript",
                                                    "Motoko",
                                                    "Motorola 68K Assembly",
                                                    "Move",
                                                    "Muse",
                                                    "Mustache",
                                                    "Myghty",
                                                    "NASL",
                                                    "NCL",
                                                    "NEON",
                                                    "NL",
                                                    "NPM Config",
                                                    "NSIS",
                                                    "NWScript",
                                                    "Nasal",
                                                    "Nearley",
                                                    "Nemerle",
                                                    "NeoSnippet",
                                                    "NetLinx",
                                                    "NetLinx+ERB",
                                                    "NetLogo",
                                                    "NewLisp",
                                                    "Nextflow",
                                                    "Nginx",
                                                    "Nim",
                                                    "Ninja",
                                                    "Nit",
                                                    "Nix",
                                                    "Nu",
                                                    "NumPy",
                                                    "Nunjucks",
                                                    "Nushell",
                                                    "OASv2-json",
                                                    "OASv2-yaml",
                                                    "OASv3-json",
                                                    "OASv3-yaml",
                                                    "OCaml",
                                                    "ObjDump",
                                                    "Object Data Instance Notation",
                                                    "ObjectScript",
                                                    "Objective-C",
                                                    "Objective-C++",
                                                    "Objective-J",
                                                    "Odin",
                                                    "Omgrofl",
                                                    "Opa",
                                                    "Opal",
                                                    "Open Policy Agent",
                                                    "OpenAPI Specification v2",
                                                    "OpenAPI Specification v3",
                                                    "OpenCL",
                                                    "OpenEdge ABL",
                                                    "OpenQASM",
                                                    "OpenRC runscript",
                                                    "OpenSCAD",
                                                    "OpenStep Property List",
                                                    "OpenType Feature File",
                                                    "Option List",
                                                    "Org",
                                                    "Ox",
                                                    "Oxygene",
                                                    "Oz",
                                                    "P4",
                                                    "PDDL",
                                                    "PEG.js",
                                                    "PHP",
                                                    "PLSQL",
                                                    "PLpgSQL",
                                                    "POV-Ray SDL",
                                                    "Pact",
                                                    "Pan",
                                                    "Papyrus",
                                                    "Parrot",
                                                    "Parrot Assembly",
                                                    "Parrot Internal Representation",
                                                    "Pascal",
                                                    "Pawn",
                                                    "Pep8",
                                                    "Perl",
                                                    "Pic",
                                                    "Pickle",
                                                    "PicoLisp",
                                                    "PigLatin",
                                                    "Pike",
                                                    "PlantUML",
                                                    "Pod",
                                                    "Pod 6",
                                                    "PogoScript",
                                                    "Polar",
                                                    "Pony",
                                                    "Portugol",
                                                    "PostCSS",
                                                    "PostScript",
                                                    "PowerBuilder",
                                                    "PowerShell",
                                                    "Praat",
                                                    "Prisma",
                                                    "Processing",
                                                    "Procfile",
                                                    "Proguard",
                                                    "Prolog",
                                                    "Promela",
                                                    "Propeller Spin",
                                                    "Protocol Buffer",
                                                    "Protocol Buffer Text Format",
                                                    "Protocol Buffers",
                                                    "Public Key",
                                                    "Pug",
                                                    "Puppet",
                                                    "Pure Data",
                                                    "PureBasic",
                                                    "PureScript",
                                                    "Pyret",
                                                    "Python",
                                                    "Python console",
                                                    "Python traceback",
                                                    "Q#",
                                                    "QML",
                                                    "QMake",
                                                    "Qt Script",
                                                    "Quake",
                                                    "R",
                                                    "RAML",
                                                    "RBS",
                                                    "RDoc",
                                                    "REALbasic",
                                                    "REXX",
                                                    "RMarkdown",
                                                    "RPC",
                                                    "RPGLE",
                                                    "RPM Spec",
                                                    "RUNOFF",
                                                    "Racket",
                                                    "Ragel",
                                                    "Raku",
                                                    "Rascal",
                                                    "Raw token data",
                                                    "ReScript",
                                                    "Readline Config",
                                                    "Reason",
                                                    "ReasonLIGO",
                                                    "Rebol",
                                                    "Record Jar",
                                                    "Red",
                                                    "Redcode",
                                                    "Redirect Rules",
                                                    "Regular Expression",
                                                    "Ren'Py",
                                                    "RenderScript",
                                                    "Rez",
                                                    "Rich Text Format",
                                                    "Ring",
                                                    "Riot",
                                                    "RobotFramework",
                                                    "Roff",
                                                    "Roff Manpage",
                                                    "Rouge",
                                                    "RouterOS Script",
                                                    "Rscript",
                                                    "Ruby",
                                                    "Rust",
                                                    "SAS",
                                                    "SCSS",
                                                    "SELinux Kernel Policy Language",
                                                    "SELinux Policy",
                                                    "SMT",
                                                    "SPARQL",
                                                    "SQF",
                                                    "SQL",
                                                    "SQLPL",
                                                    "SRecode Template",
                                                    "SSH Config",
                                                    "STAR",
                                                    "STL",
                                                    "STON",
                                                    "SVG",
                                                    "SWIG",
                                                    "Sage",
                                                    "SaltStack",
                                                    "Sass",
                                                    "Scala",
                                                    "Scaml",
                                                    "Scenic",
                                                    "Scheme",
                                                    "Scilab",
                                                    "Self",
                                                    "ShaderLab",
                                                    "Shell",
                                                    "ShellCheck Config",
                                                    "ShellSession",
                                                    "Shen",
                                                    "Sieve",
                                                    "Simple File Verification",
                                                    "Singularity",
                                                    "Slash",
                                                    "Slice",
                                                    "Slim",
                                                    "SmPL",
                                                    "Smali",
                                                    "Smalltalk",
                                                    "Smarty",
                                                    "Smithy",
                                                    "Snakemake",
                                                    "SnipMate",
                                                    "Solidity",
                                                    "Soong",
                                                    "SourcePawn",
                                                    "Spline Font Database",
                                                    "Squirrel",
                                                    "Stan",
                                                    "Standard ML",
                                                    "Starlark",
                                                    "Stata",
                                                    "StringTemplate",
                                                    "Stylus",
                                                    "SubRip Text",
                                                    "SugarSS",
                                                    "SuperCollider",
                                                    "Svelte",
                                                    "Sway",
                                                    "Sweave",
                                                    "Swift",
                                                    "SystemVerilog",
                                                    "TI Program",
                                                    "TL-Verilog",
                                                    "TLA",
                                                    "TOML",
                                                    "TSQL",
                                                    "TSV",
                                                    "TSX",
                                                    "TXL",
                                                    "Talon",
                                                    "Tcl",
                                                    "Tcsh",
                                                    "TeX",
                                                    "Tea",
                                                    "Terra",
                                                    "Terraform Template",
                                                    "Texinfo",
                                                    "Text",
                                                    "TextMate Properties",
                                                    "Textile",
                                                    "Thrift",
                                                    "Toit",
                                                    "Turing",
                                                    "Turtle",
                                                    "Twig",
                                                    "Type Language",
                                                    "TypeScript",
                                                    "Typst",
                                                    "UltiSnip",
                                                    "UltiSnips",
                                                    "Unified Parallel C",
                                                    "Unity3D Asset",
                                                    "Unix Assembly",
                                                    "Uno",
                                                    "UnrealScript",
                                                    "Ur",
                                                    "Ur/Web",
                                                    "UrWeb",
                                                    "V",
                                                    "VBA",
                                                    "VBScript",
                                                    "VCL",
                                                    "VHDL",
                                                    "Vala",
                                                    "Valve Data Format",
                                                    "Velocity Template Language",
                                                    "Verilog",
                                                    "Vim Help File",
                                                    "Vim Script",
                                                    "Vim Snippet",
                                                    "Visual Basic .NET",
                                                    "Visual Basic 6.0",
                                                    "Volt",
                                                    "Vue",
                                                    "Vyper",
                                                    "WDL",
                                                    "WGSL",
                                                    "Wavefront Material",
                                                    "Wavefront Object",
                                                    "Web Ontology Language",
                                                    "WebAssembly",
                                                    "WebAssembly Interface Type",
                                                    "WebIDL",
                                                    "WebVTT",
                                                    "Wget Config",
                                                    "Whiley",
                                                    "Wikitext",
                                                    "Win32 Message File",
                                                    "Windows Registry Entries",
                                                    "Witcher Script",
                                                    "Wollok",
                                                    "Workflow Description Language",
                                                    "World of Warcraft Addon Data",
                                                    "Wren",
                                                    "X BitMap",
                                                    "X Font Directory Index",
                                                    "X PixMap",
                                                    "X10",
                                                    "XC",
                                                    "XCompose",
                                                    "XML",
                                                    "XML Property List",
                                                    "XPages",
                                                    "XProc",
                                                    "XQuery",
                                                    "XS",
                                                    "XSLT",
                                                    "Xojo",
                                                    "Xonsh",
                                                    "Xtend",
                                                    "YAML",
                                                    "YANG",
                                                    "YARA",
                                                    "YASnippet",
                                                    "Yacc",
                                                    "Yul",
                                                    "ZAP",
                                                    "ZIL",
                                                    "Zeek",
                                                    "ZenScript",
                                                    "Zephir",
                                                    "Zig",
                                                    "Zimpl",
                                                    "abap",
                                                    "abap cds",
                                                    "abl",
                                                    "abnf",
                                                    "abuild",
                                                    "acfm",
                                                    "ackrc",
                                                    "aconf",
                                                    "actionscript",
                                                    "actionscript 3",
                                                    "actionscript3",
                                                    "ad block",
                                                    "ad block filters",
                                                    "ada",
                                                    "ada2005",
                                                    "ada95",
                                                    "adb",
                                                    "adblock",
                                                    "adblock filter list",
                                                    "adobe composite font metrics",
                                                    "adobe font metrics",
                                                    "adobe multiple font metrics",
                                                    "advpl",
                                                    "agda",
                                                    "ags",
                                                    "ags script",
                                                    "ahk",
                                                    "aidl",
                                                    "al",
                                                    "alloy",
                                                    "alpine abuild",
                                                    "altium",
                                                    "altium designer",
                                                    "amfm",
                                                    "ampl",
                                                    "amusewiki",
                                                    "angelscript",
                                                    "ant build system",
                                                    "antlers",
                                                    "antlr",
                                                    "apache",
                                                    "apacheconf",
                                                    "apex",
                                                    "api blueprint",
                                                    "apkbuild",
                                                    "apl",
                                                    "apollo guidance computer",
                                                    "applescript",
                                                    "arc",
                                                    "arexx",
                                                    "as3",
                                                    "ascii stl",
                                                    "asciidoc",
                                                    "asl",
                                                    "asm",
                                                    "asn.1",
                                                    "asp",
                                                    "asp.net",
                                                    "aspectj",
                                                    "aspx",
                                                    "aspx-vb",
                                                    "assembly",
                                                    "astro",
                                                    "asymptote",
                                                    "ats",
                                                    "ats2",
                                                    "au3",
                                                    "augeas",
                                                    "autoconf",
                                                    "autohotkey",
                                                    "autoit",
                                                    "avro idl",
                                                    "awk",
                                                    "b3d",
                                                    "ballerina",
                                                    "bash",
                                                    "bash session",
                                                    "basic",
                                                    "bat",
                                                    "batch",
                                                    "batchfile",
                                                    "bazel",
                                                    "be",
                                                    "beef",
                                                    "befunge",
                                                    "berry",
                                                    "bh",
                                                    "bibtex",
                                                    "bicep",
                                                    "bikeshed",
                                                    "bison",
                                                    "bitbake",
                                                    "blade",
                                                    "blitz3d",
                                                    "blitzbasic",
                                                    "blitzmax",
                                                    "blitzplus",
                                                    "bluespec",
                                                    "bluespec bh",
                                                    "bluespec bsv",
                                                    "bluespec classic",
                                                    "bmax",
                                                    "boo",
                                                    "boogie",
                                                    "bplus",
                                                    "brainfuck",
                                                    "brighterscript",
                                                    "brightscript",
                                                    "bro",
                                                    "browserslist",
                                                    "bsdmake",
                                                    "bsv",
                                                    "byond",
                                                    "bzl",
                                                    "c",
                                                    "c#",
                                                    "c++",
                                                    "c++-objdump",
                                                    "c-objdump",
                                                    "c2hs",
                                                    "c2hs haskell",
                                                    "cURL Config",
                                                    "cabal config",
                                                    "cadence",
                                                    "cairo",
                                                    "cake",
                                                    "cakescript",
                                                    "cameligo",
                                                    "cap cds",
                                                    "cap'n proto",
                                                    "cartocss",
                                                    "cds",
                                                    "ceylon",
                                                    "cfc",
                                                    "cfm",
                                                    "cfml",
                                                    "chapel",
                                                    "charity",
                                                    "checksum",
                                                    "checksums",
                                                    "chpl",
                                                    "chuck",
                                                    "cil",
                                                    "circom",
                                                    "cirru",
                                                    "clarion",
                                                    "clarity",
                                                    "classic asp",
                                                    "classic visual basic",
                                                    "clean",
                                                    "click",
                                                    "clipper",
                                                    "clips",
                                                    "clojure",
                                                    "closure templates",
                                                    "cloud firestore security rules",
                                                    "cmake",
                                                    "cobol",
                                                    "coccinelle",
                                                    "codeowners",
                                                    "codeql",
                                                    "coffee",
                                                    "coffee-script",
                                                    "coffeescript",
                                                    "coldfusion",
                                                    "coldfusion cfc",
                                                    "coldfusion html",
                                                    "collada",
                                                    "common lisp",
                                                    "common workflow language",
                                                    "component pascal",
                                                    "conll-u",
                                                    "console",
                                                    "cool",
                                                    "coq",
                                                    "cperl",
                                                    "cpp",
                                                    "cpp-objdump",
                                                    "creole",
                                                    "crystal",
                                                    "csharp",
                                                    "cson",
                                                    "csound",
                                                    "csound document",
                                                    "csound score",
                                                    "csound-csd",
                                                    "csound-orc",
                                                    "csound-sco",
                                                    "css",
                                                    "csv",
                                                    "cucumber",
                                                    "cuda",
                                                    "cue",
                                                    "cue sheet",
                                                    "curl config",
                                                    "curlrc",
                                                    "curry",
                                                    "cweb",
                                                    "cwl",
                                                    "cycript",
                                                    "cypher",
                                                    "cython",
                                                    "d",
                                                    "d-objdump",
                                                    "d2",
                                                    "d2lang",
                                                    "dafny",
                                                    "darcs patch",
                                                    "dart",
                                                    "dataweave",
                                                    "dcl",
                                                    "debian package control file",
                                                    "delphi",
                                                    "denizenscript",
                                                    "desktop",
                                                    "dhall",
                                                    "diff",
                                                    "digital command language",
                                                    "dircolors",
                                                    "directx 3d file",
                                                    "django",
                                                    "dm",
                                                    "dns zone",
                                                    "dockerfile",
                                                    "dogescript",
                                                    "dosbatch",
                                                    "dosini",
                                                    "dotenv",
                                                    "dpatch",
                                                    "dtrace",
                                                    "dtrace-script",
                                                    "dylan",
                                                    "e",
                                                    "e-mail",
                                                    "eC",
                                                    "eagle",
                                                    "earthly",
                                                    "easybuild",
                                                    "ebnf",
                                                    "ec",
                                                    "ecere projects",
                                                    "ecl",
                                                    "eclipse",
                                                    "ecmarkdown",
                                                    "ecmarkup",
                                                    "ecr",
                                                    "edgeql",
                                                    "editor-config",
                                                    "editorconfig",
                                                    "edje data collection",
                                                    "edn",
                                                    "eeschema schematic",
                                                    "eex",
                                                    "eiffel",
                                                    "ejs",
                                                    "elisp",
                                                    "elixir",
                                                    "elm",
                                                    "elvish",
                                                    "elvish transcript",
                                                    "emacs",
                                                    "emacs lisp",
                                                    "emacs muse",
                                                    "email",
                                                    "emberscript",
                                                    "eml",
                                                    "eq",
                                                    "erb",
                                                    "erlang",
                                                    "esdl",
                                                    "euphoria",
                                                    "f#",
                                                    "f*",
                                                    "factor",
                                                    "fancy",
                                                    "fantom",
                                                    "faust",
                                                    "fb",
                                                    "fennel",
                                                    "figlet font",
                                                    "filebench wml",
                                                    "filterscript",
                                                    "fish",
                                                    "flex",
                                                    "fluent",
                                                    "flux",
                                                    "formatted",
                                                    "forth",
                                                    "fortran",
                                                    "fortran free form",
                                                    "foxpro",
                                                    "freebasic",
                                                    "freemarker",
                                                    "frege",
                                                    "fsharp",
                                                    "fstar",
                                                    "ftl",
                                                    "fundamental",
                                                    "futhark",
                                                    "g-code",
                                                    "game maker language",
                                                    "gaml",
                                                    "gams",
                                                    "gap",
                                                    "gas",
                                                    "gcc machine description",
                                                    "gdb",
                                                    "gdscript",
                                                    "gedcom",
                                                    "gemfile.lock",
                                                    "gemini",
                                                    "gemtext",
                                                    "genero 4gl",
                                                    "genero per",
                                                    "genie",
                                                    "genshi",
                                                    "gentoo ebuild",
                                                    "gentoo eclass",
                                                    "geojson",
                                                    "gerber image",
                                                    "gettext catalog",
                                                    "gf",
                                                    "gherkin",
                                                    "git attributes",
                                                    "git config",
                                                    "git revision list",
                                                    "git-ignore",
                                                    "gitattributes",
                                                    "gitconfig",
                                                    "gitignore",
                                                    "gitmodules",
                                                    "gleam",
                                                    "glimmer js",
                                                    "glsl",
                                                    "glyph",
                                                    "glyph bitmap distribution format",
                                                    "gn",
                                                    "gnu asm",
                                                    "gnuplot",
                                                    "go",
                                                    "go checksums",
                                                    "go mod",
                                                    "go module",
                                                    "go sum",
                                                    "go work",
                                                    "go work sum",
                                                    "go workspace",
                                                    "go.mod",
                                                    "go.sum",
                                                    "go.work",
                                                    "go.work.sum",
                                                    "godot resource",
                                                    "golang",
                                                    "golo",
                                                    "gosu",
                                                    "grace",
                                                    "gradle",
                                                    "gradle kotlin dsl",
                                                    "grammatical framework",
                                                    "graph modeling language",
                                                    "graphql",
                                                    "graphviz (dot)",
                                                    "groff",
                                                    "groovy",
                                                    "groovy server pages",
                                                    "gsc",
                                                    "gsp",
                                                    "hack",
                                                    "haml",
                                                    "handlebars",
                                                    "haproxy",
                                                    "harbour",
                                                    "hash",
                                                    "hashes",
                                                    "haskell",
                                                    "haxe",
                                                    "hbs",
                                                    "hcl",
                                                    "heex",
                                                    "help",
                                                    "hiveql",
                                                    "hlsl",
                                                    "hocon",
                                                    "holyc",
                                                    "hoon",
                                                    "hosts",
                                                    "hosts file",
                                                    "html",
                                                    "html+django",
                                                    "html+ecr",
                                                    "html+eex",
                                                    "html+erb",
                                                    "html+jinja",
                                                    "html+php",
                                                    "html+razor",
                                                    "html+ruby",
                                                    "htmlbars",
                                                    "htmldjango",
                                                    "http",
                                                    "hxml",
                                                    "hy",
                                                    "hylang",
                                                    "hyphy",
                                                    "i7",
                                                    "idl",
                                                    "idris",
                                                    "ignore",
                                                    "ignore list",
                                                    "igor",
                                                    "igor pro",
                                                    "igorpro",
                                                    "ijm",
                                                    "ile rpg",
                                                    "imagej macro",
                                                    "imba",
                                                    "inc",
                                                    "inform 7",
                                                    "inform7",
                                                    "ini",
                                                    "ink",
                                                    "inno setup",
                                                    "inputrc",
                                                    "io",
                                                    "ioke",
                                                    "irc",
                                                    "irc log",
                                                    "irc logs",
                                                    "isabelle",
                                                    "isabelle root",
                                                    "j",
                                                    "janet",
                                                    "jar manifest",
                                                    "jasmin",
                                                    "java",
                                                    "java properties",
                                                    "java server page",
                                                    "java server pages",
                                                    "javascript",
                                                    "javascript+erb",
                                                    "jcl",
                                                    "jest snapshot",
                                                    "jetbrains mps",
                                                    "jflex",
                                                    "jinja",
                                                    "jison",
                                                    "jison lex",
                                                    "jolie",
                                                    "jq",
                                                    "jruby",
                                                    "js",
                                                    "json",
                                                    "json with comments",
                                                    "json5",
                                                    "jsonc",
                                                    "jsoniq",
                                                    "jsonl",
                                                    "jsonld",
                                                    "jsonnet",
                                                    "jsp",
                                                    "julia",
                                                    "jupyter notebook",
                                                    "just",
                                                    "kaitai struct",
                                                    "kak",
                                                    "kakounescript",
                                                    "kakscript",
                                                    "kerboscript",
                                                    "keyvalues",
                                                    "kicad layout",
                                                    "kicad legacy layout",
                                                    "kicad schematic",
                                                    "kickstart",
                                                    "kit",
                                                    "kotlin",
                                                    "krl",
                                                    "ksy",
                                                    "kusto",
                                                    "kvlang",
                                                    "labview",
                                                    "lark",
                                                    "lasso",
                                                    "lassoscript",
                                                    "latex",
                                                    "latte",
                                                    "lean",
                                                    "lean 4",
                                                    "leex",
                                                    "less",
                                                    "less-css",
                                                    "lex",
                                                    "lfe",
                                                    "lhaskell",
                                                    "lhs",
                                                    "ligolang",
                                                    "lilypond",
                                                    "limbo",
                                                    "linker script",
                                                    "linux kernel module",
                                                    "liquid",
                                                    "lisp",
                                                    "litcoffee",
                                                    "literate agda",
                                                    "literate coffeescript",
                                                    "literate haskell",
                                                    "live-script",
                                                    "livescript",
                                                    "llvm",
                                                    "logos",
                                                    "logtalk",
                                                    "lolcode",
                                                    "lookml",
                                                    "loomscript",
                                                    "ls",
                                                    "lsl",
                                                    "ltspice symbol",
                                                    "lua",
                                                    "m",
                                                    "m2",
                                                    "m4",
                                                    "m4sugar",
                                                    "m68k",
                                                    "mIRC Script",
                                                    "macaulay2",
                                                    "macruby",
                                                    "mail",
                                                    "make",
                                                    "makefile",
                                                    "mako",
                                                    "man",
                                                    "man page",
                                                    "man-page",
                                                    "manpage",
                                                    "markdown",
                                                    "marko",
                                                    "markojs",
                                                    "mask",
                                                    "mathematica",
                                                    "matlab",
                                                    "maven pom",
                                                    "max",
                                                    "max/msp",
                                                    "maxmsp",
                                                    "maxscript",
                                                    "mbox",
                                                    "mcfunction",
                                                    "md",
                                                    "mdoc",
                                                    "mdx",
                                                    "mediawiki",
                                                    "mercury",
                                                    "mermaid",
                                                    "mermaid example",
                                                    "meson",
                                                    "metal",
                                                    "mf",
                                                    "microsoft developer studio project",
                                                    "microsoft visual studio solution",
                                                    "minid",
                                                    "miniyaml",
                                                    "mint",
                                                    "mirah",
                                                    "mirc script",
                                                    "mlir",
                                                    "mma",
                                                    "modelica",
                                                    "modula-2",
                                                    "modula-3",
                                                    "module management system",
                                                    "monkey",
                                                    "monkey c",
                                                    "moocode",
                                                    "moonscript",
                                                    "motoko",
                                                    "motorola 68k assembly",
                                                    "move",
                                                    "mps",
                                                    "mql4",
                                                    "mql5",
                                                    "mtml",
                                                    "muf",
                                                    "mumps",
                                                    "mupad",
                                                    "muse",
                                                    "mustache",
                                                    "myghty",
                                                    "nanorc",
                                                    "nasal",
                                                    "nasl",
                                                    "nasm",
                                                    "ncl",
                                                    "ne-on",
                                                    "nearley",
                                                    "nemerle",
                                                    "neon",
                                                    "nesC",
                                                    "nesc",
                                                    "netlinx",
                                                    "netlinx+erb",
                                                    "netlogo",
                                                    "nette object notation",
                                                    "newlisp",
                                                    "nextflow",
                                                    "nginx",
                                                    "nginx configuration file",
                                                    "nim",
                                                    "ninja",
                                                    "nit",
                                                    "nix",
                                                    "nixos",
                                                    "njk",
                                                    "nl",
                                                    "node",
                                                    "npm config",
                                                    "npmrc",
                                                    "nroff",
                                                    "nsis",
                                                    "nu",
                                                    "nu-script",
                                                    "numpy",
                                                    "nunjucks",
                                                    "nush",
                                                    "nushell",
                                                    "nushell-script",
                                                    "nvim",
                                                    "nwscript",
                                                    "oasv2",
                                                    "oasv2-json",
                                                    "oasv2-yaml",
                                                    "oasv3",
                                                    "oasv3-json",
                                                    "oasv3-yaml",
                                                    "obj-c",
                                                    "obj-c++",
                                                    "obj-j",
                                                    "objc",
                                                    "objc++",
                                                    "objdump",
                                                    "object data instance notation",
                                                    "objective-c",
                                                    "objective-c++",
                                                    "objective-j",
                                                    "objectivec",
                                                    "objectivec++",
                                                    "objectivej",
                                                    "objectpascal",
                                                    "objectscript",
                                                    "objj",
                                                    "ocaml",
                                                    "octave",
                                                    "odin",
                                                    "odin-lang",
                                                    "odinlang",
                                                    "omgrofl",
                                                    "oncrpc",
                                                    "ooc",
                                                    "opa",
                                                    "opal",
                                                    "open policy agent",
                                                    "openapi specification v2",
                                                    "openapi specification v3",
                                                    "opencl",
                                                    "openedge",
                                                    "openedge abl",
                                                    "openqasm",
                                                    "openrc",
                                                    "openrc runscript",
                                                    "openscad",
                                                    "openstep property list",
                                                    "opentype feature file",
                                                    "option list",
                                                    "opts",
                                                    "org",
                                                    "osascript",
                                                    "ox",
                                                    "oxygene",
                                                    "oz",
                                                    "p4",
                                                    "pact",
                                                    "pan",
                                                    "pandoc",
                                                    "papyrus",
                                                    "parrot",
                                                    "parrot assembly",
                                                    "parrot internal representation",
                                                    "pascal",
                                                    "pasm",
                                                    "pawn",
                                                    "pcbnew",
                                                    "pddl",
                                                    "peg.js",
                                                    "pep8",
                                                    "perl",
                                                    "perl-6",
                                                    "perl6",
                                                    "php",
                                                    "pic",
                                                    "pickle",
                                                    "picolisp",
                                                    "piglatin",
                                                    "pikchr",
                                                    "pike",
                                                    "pir",
                                                    "plain text",
                                                    "plantuml",
                                                    "plpgsql",
                                                    "plsql",
                                                    "pod",
                                                    "pod 6",
                                                    "pogoscript",
                                                    "polar",
                                                    "pony",
                                                    "portugol",
                                                    "posh",
                                                    "postcss",
                                                    "postscr",
                                                    "postscript",
                                                    "pot",
                                                    "pov-ray",
                                                    "pov-ray sdl",
                                                    "povray",
                                                    "powerbuilder",
                                                    "powershell",
                                                    "praat",
                                                    "prisma",
                                                    "processing",
                                                    "procfile",
                                                    "progress",
                                                    "proguard",
                                                    "prolog",
                                                    "promela",
                                                    "propeller spin",
                                                    "proto",
                                                    "protobuf",
                                                    "protobuf text format",
                                                    "protocol buffer",
                                                    "protocol buffer text format",
                                                    "public key",
                                                    "pug",
                                                    "puppet",
                                                    "pure data",
                                                    "purebasic",
                                                    "purescript",
                                                    "pwsh",
                                                    "pycon",
                                                    "pyret",
                                                    "pyrex",
                                                    "python",
                                                    "python console",
                                                    "python traceback",
                                                    "python3",
                                                    "q",
                                                    "q#",
                                                    "ql",
                                                    "qmake",
                                                    "qml",
                                                    "qsharp",
                                                    "qt script",
                                                    "quake",
                                                    "r",
                                                    "racket",
                                                    "ragel",
                                                    "ragel-rb",
                                                    "ragel-ruby",
                                                    "rake",
                                                    "raku",
                                                    "raml",
                                                    "rascal",
                                                    "raw",
                                                    "raw token data",
                                                    "razor",
                                                    "rb",
                                                    "rbs",
                                                    "rbx",
                                                    "rdoc",
                                                    "reStructuredText",
                                                    "readline",
                                                    "readline config",
                                                    "realbasic",
                                                    "reason",
                                                    "reasonligo",
                                                    "rebol",
                                                    "record jar",
                                                    "red",
                                                    "red/system",
                                                    "redcode",
                                                    "redirect rules",
                                                    "redirects",
                                                    "regex",
                                                    "regexp",
                                                    "regular expression",
                                                    "ren'py",
                                                    "renderscript",
                                                    "renpy",
                                                    "rescript",
                                                    "restructuredtext",
                                                    "rexx",
                                                    "rez",
                                                    "rhtml",
                                                    "rich text format",
                                                    "ring",
                                                    "riot",
                                                    "rmarkdown",
                                                    "robotframework",
                                                    "robots",
                                                    "robots txt",
                                                    "robots.txt",
                                                    "roff",
                                                    "roff manpage",
                                                    "rouge",
                                                    "routeros script",
                                                    "rpc",
                                                    "rpcgen",
                                                    "rpgle",
                                                    "rpm spec",
                                                    "rs",
                                                    "rs-274x",
                                                    "rss",
                                                    "rst",
                                                    "ruby",
                                                    "runoff",
                                                    "rust",
                                                    "rusthon",
                                                    "sage",
                                                    "salt",
                                                    "saltstack",
                                                    "saltstate",
                                                    "sas",
                                                    "sass",
                                                    "scala",
                                                    "scaml",
                                                    "scenic",
                                                    "scheme",
                                                    "scilab",
                                                    "scss",
                                                    "sdc",
                                                    "sed",
                                                    "self",
                                                    "selinux policy",
                                                    "sepolicy",
                                                    "sfv",
                                                    "sh",
                                                    "shaderlab",
                                                    "shell",
                                                    "shell-script",
                                                    "shellcheck config",
                                                    "shellcheckrc",
                                                    "shellsession",
                                                    "shen",
                                                    "sieve",
                                                    "simple file verification",
                                                    "singularity",
                                                    "slash",
                                                    "slice",
                                                    "slim",
                                                    "smali",
                                                    "smalltalk",
                                                    "smarty",
                                                    "smithy",
                                                    "sml",
                                                    "smpl",
                                                    "smt",
                                                    "snakefile",
                                                    "snakemake",
                                                    "snippet",
                                                    "solidity",
                                                    "soong",
                                                    "sourcemod",
                                                    "sourcepawn",
                                                    "soy",
                                                    "sparql",
                                                    "specfile",
                                                    "spline font database",
                                                    "splus",
                                                    "sqf",
                                                    "sql",
                                                    "sqlpl",
                                                    "sqlrpgle",
                                                    "squeak",
                                                    "squirrel",
                                                    "srecode template",
                                                    "ssh config",
                                                    "stan",
                                                    "standard ml",
                                                    "star",
                                                    "starlark",
                                                    "stata",
                                                    "stl",
                                                    "stla",
                                                    "ston",
                                                    "stringtemplate",
                                                    "stylus",
                                                    "subrip text",
                                                    "sugarss",
                                                    "sum",
                                                    "sums",
                                                    "supercollider",
                                                    "svelte",
                                                    "svg",
                                                    "sway",
                                                    "sweave",
                                                    "swift",
                                                    "swig",
                                                    "systemverilog",
                                                    "talon",
                                                    "tcl",
                                                    "tcsh",
                                                    "tea",
                                                    "terra",
                                                    "terraform",
                                                    "terraform template",
                                                    "tex",
                                                    "texinfo",
                                                    "text",
                                                    "text proto",
                                                    "textile",
                                                    "textmate properties",
                                                    "thrift",
                                                    "ti program",
                                                    "tl",
                                                    "tl-verilog",
                                                    "tla",
                                                    "tm-properties",
                                                    "toit",
                                                    "toml",
                                                    "topojson",
                                                    "troff",
                                                    "ts",
                                                    "tsql",
                                                    "tsv",
                                                    "tsx",
                                                    "turing",
                                                    "turtle",
                                                    "twig",
                                                    "txl",
                                                    "typ",
                                                    "type language",
                                                    "typescript",
                                                    "typst",
                                                    "udiff",
                                                    "unified parallel c",
                                                    "unity3d asset",
                                                    "unix asm",
                                                    "unix assembly",
                                                    "uno",
                                                    "unrealscript",
                                                    "urweb",
                                                    "v",
                                                    "vala",
                                                    "valve data format",
                                                    "vb .net",
                                                    "vb 6",
                                                    "vb.net",
                                                    "vb6",
                                                    "vba",
                                                    "vbnet",
                                                    "vbscript",
                                                    "vcl",
                                                    "vdf",
                                                    "velocity",
                                                    "velocity template language",
                                                    "verilog",
                                                    "vhdl",
                                                    "vim",
                                                    "vim help file",
                                                    "vim script",
                                                    "vim snippet",
                                                    "vimhelp",
                                                    "viml",
                                                    "visual basic",
                                                    "visual basic .net",
                                                    "visual basic 6",
                                                    "visual basic 6.0",
                                                    "visual basic classic",
                                                    "visual basic for applications",
                                                    "vlang",
                                                    "volt",
                                                    "vtl",
                                                    "vtt",
                                                    "vue",
                                                    "vyper",
                                                    "wasm",
                                                    "wast",
                                                    "wavefront material",
                                                    "wavefront object",
                                                    "wdl",
                                                    "web ontology language",
                                                    "webassembly",
                                                    "webassembly interface type",
                                                    "webidl",
                                                    "webvtt",
                                                    "wget config",
                                                    "wgetrc",
                                                    "wgsl",
                                                    "whiley",
                                                    "wiki",
                                                    "wikitext",
                                                    "win32 message file",
                                                    "winbatch",
                                                    "windows registry entries",
                                                    "wisp",
                                                    "wit",
                                                    "witcher script",
                                                    "wl",
                                                    "wolfram",
                                                    "wolfram lang",
                                                    "wolfram language",
                                                    "wollok",
                                                    "world of warcraft addon data",
                                                    "wren",
                                                    "wrenlang",
                                                    "wsdl",
                                                    "x bitmap",
                                                    "x font directory index",
                                                    "x pixmap",
                                                    "x10",
                                                    "xBase",
                                                    "xbase",
                                                    "xbm",
                                                    "xc",
                                                    "xcompose",
                                                    "xdc",
                                                    "xdr",
                                                    "xhtml",
                                                    "xml",
                                                    "xml property list",
                                                    "xml+genshi",
                                                    "xml+kid",
                                                    "xojo",
                                                    "xonsh",
                                                    "xpages",
                                                    "xpm",
                                                    "xproc",
                                                    "xquery",
                                                    "xs",
                                                    "xsd",
                                                    "xsl",
                                                    "xslt",
                                                    "xten",
                                                    "xtend",
                                                    "yacc",
                                                    "yaml",
                                                    "yang",
                                                    "yara",
                                                    "yas",
                                                    "yasnippet",
                                                    "yml",
                                                    "yul",
                                                    "zap",
                                                    "zeek",
                                                    "zenscript",
                                                    "zephir",
                                                    "zig",
                                                    "zil",
                                                    "zimpl",
                                                    "zsh"
                                                  ]
                                              ],
                                        value =
                                          _js2n__-refsenv."_js2n__-:definitions/value!predicate",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            id =
                              _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                            type =
                              _js2n__-refsenv."_js2n__-:definitions/type!predicate",
                            validations =
                              _js2n__-refsenv."_js2n__-:definitions/validations!predicate",
                          } {} false _js2n__-prdslib.never
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "input", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "attributes", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            attributes =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "label" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        description =
                                          _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                                        label =
                                          _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                                        placeholder =
                                          _js2n__-refsenv."_js2n__-:definitions/placeholder!predicate",
                                        value =
                                          _js2n__-refsenv."_js2n__-:definitions/value!predicate",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            id =
                              _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                            type =
                              _js2n__-refsenv."_js2n__-:definitions/type!predicate",
                            validations =
                              _js2n__-refsenv."_js2n__-:definitions/validations!predicate",
                          } {} false _js2n__-prdslib.never
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "dropdown", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "attributes", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            attributes =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "label", "options" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        "default" =
                                          _js2n__-prdslib.isType 'Integer,
                                        description =
                                          _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                                        label =
                                          _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                                        multiple =
                                          _js2n__-prdslib.isType '"Bool",
                                        options =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.minLength
                                                        1
                                                    ]),
                                                _js2n__-prdslib.arrays.minItems
                                                  1,
                                                _js2n__-prdslib.arrays.uniqueItems
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            id =
                              _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                            type =
                              _js2n__-refsenv."_js2n__-:definitions/type!predicate",
                            validations =
                              _js2n__-refsenv."_js2n__-:definitions/validations!predicate",
                          } {} false _js2n__-prdslib.never
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "checkboxes", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "attributes", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            attributes =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "label", "options" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        description =
                                          _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                                        label =
                                          _js2n__-refsenv."_js2n__-:definitions/label!predicate",
                                        options =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "label" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          label =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.minLength
                                                                    1
                                                                ],
                                                          required =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ]),
                                                _js2n__-prdslib.arrays.minItems
                                                  1
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            id =
                              _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                            type =
                              _js2n__-refsenv."_js2n__-:definitions/type!predicate",
                          } {} false _js2n__-prdslib.never
                      ]) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  type = _js2n__-refsenv."_js2n__-:definitions/type!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/id!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_-]+$"
            ],
      "_js2n__-:definitions/label!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/placeholder!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/type!predicate"
        | doc m%"
          A form item type
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#keys
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "checkboxes", "dropdown", "input", "markdown", "textarea" ]
            ],
      "_js2n__-:definitions/validations!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { required = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/value!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
    }
    in
  {
      assignees
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/assignee!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/assignee!predicate",
                  _js2n__-prdslib.arrays.minItems 1,
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ])
        | doc m%"
          An issue template assignees
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax
        "%
        | optional,
      body
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/form_item!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ])
        | doc m%"
          An issue template body
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax
        "%,
      description
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          An issue template description
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax
        "%,
      labels
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          An issue template labels
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax
        "%
        | optional,
      name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          An issue template name
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax
        "%,
      projects
        | Array (String)
        | doc "Projects that any issues created with this template will automatically be added to."
        | optional,
      title
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          An issue template title
          https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax
        "%
        | optional,
      type
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          An issue type, currently in beta
          https://github.com/orgs/community/discussions/139933
        "%
        | optional,
    }