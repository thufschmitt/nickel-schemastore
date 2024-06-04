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
      categories
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
                        "1C Enterprise",
                        "4D",
                        "ABAP CDS",
                        "ABAP",
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
                        "Alloy",
                        "Alpine Abuild",
                        "Altium Designer",
                        "AngelScript",
                        "Ant Build System",
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
                        "BibTeX",
                        "Bicep",
                        "Bison",
                        "BitBake",
                        "Blade",
                        "BlitzBasic",
                        "BlitzMax",
                        "Boo",
                        "Boogie",
                        "Brainfuck",
                        "Brightscript",
                        "Browserslist",
                        "C",
                        "C#",
                        "C++",
                        "C-ObjDump",
                        "C2hs Haskell",
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
                        "Cabal Config",
                        "Cabal",
                        "Cap'n Proto",
                        "Carto",
                        "CartoCSS",
                        "Ceylon",
                        "Chapel",
                        "Charity",
                        "ChucK",
                        "Cirru",
                        "Clarion",
                        "Classic ASP",
                        "Clean",
                        "Click",
                        "Clojure",
                        "Closure Templates",
                        "Cloud Firestore Security Rules",
                        "CoNLL",
                        "CoNLL-U",
                        "CoNLL-X",
                        "ColdFusion CFC",
                        "ColdFusion",
                        "Common Lisp",
                        "Common Workflow Language",
                        "Component Pascal",
                        "Containerfile",
                        "Cool",
                        "Coq",
                        "Cpp-ObjDump",
                        "Crystal",
                        "Csound Document",
                        "Csound Score",
                        "Csound",
                        "Cuda",
                        "Cue Sheet",
                        "Cycript",
                        "Cython",
                        "D-ObjDump",
                        "DIGITAL Command Language",
                        "DM",
                        "DTrace",
                        "Dafny",
                        "Darcs Patch",
                        "Dart",
                        "DataWeave",
                        "Dhall",
                        "Diff",
                        "Dlang",
                        "Dockerfile",
                        "Dogescript",
                        "Dylan",
                        "E",
                        "E-mail",
                        "EBNF",
                        "ECL",
                        "ECLiPSe",
                        "EJS",
                        "EQ",
                        "Eagle",
                        "Earthly",
                        "Easybuild",
                        "Ecere Projects",
                        "EditorConfig",
                        "Eiffel",
                        "Elixir",
                        "Elm",
                        "Emacs Lisp",
                        "EmberScript",
                        "Erlang",
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
                        "Fortran Free Form",
                        "Fortran",
                        "FreeBasic",
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
                        "Game Maker Language",
                        "Gemfile.lock",
                        "Genie",
                        "Genshi",
                        "Gentoo Eclass",
                        "Gerber Image",
                        "Gettext Catalog",
                        "Gherkin",
                        "Git Config",
                        "Glyph Bitmap Distribution Format",
                        "Glyph",
                        "Gnuplot",
                        "Go Checksums",
                        "Go Module",
                        "Go",
                        "Golo",
                        "Gosu",
                        "Grace",
                        "Gradle",
                        "Grammatical Framework",
                        "Graph Modeling Language",
                        "GraphQL",
                        "Graphviz (DOT)",
                        "Groovy Server Pages",
                        "Groovy",
                        "HAProxy",
                        "HCL",
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
                        "Hy",
                        "IDL",
                        "IGOR Pro",
                        "IPython Notebook",
                        "Idris",
                        "Ignore List",
                        "ImageJ Macro",
                        "Inform 7",
                        "Io",
                        "Ioke",
                        "Isabelle ROOT",
                        "Isabelle",
                        "J",
                        "JAR Manifest",
                        "JFlex",
                        "JSON with Comments",
                        "JSON",
                        "JSON5",
                        "JSONLD",
                        "JSONiq",
                        "Jasmin",
                        "Java Properties",
                        "Java Server Pages",
                        "Java",
                        "JavaScript",
                        "JavaScript+ERB",
                        "Jest Snapshot",
                        "Jinja",
                        "Jison Lex",
                        "Jison",
                        "Jolie",
                        "Jsonnet",
                        "Julia",
                        "Jupyter Notebook",
                        "Kaitai Struct",
                        "KakouneScript",
                        "KiCad Layout",
                        "KiCad Legacy Layout",
                        "KiCad Schematic",
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
                        "Lean",
                        "Less",
                        "Lex",
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
                        "Mathematica",
                        "Max",
                        "Mercury",
                        "Meson",
                        "Metal",
                        "Microsoft Developer Studio Project",
                        "Microsoft Visual Studio Solution",
                        "MiniD",
                        "Mirah",
                        "Modelica",
                        "Modula-2",
                        "Modula-3",
                        "Module Management System",
                        "Monkey",
                        "Moocode",
                        "MoonScript",
                        "Motoko",
                        "Motorola 68K Assembly",
                        "Muse",
                        "Myghty",
                        "NASL",
                        "NCL",
                        "NEON",
                        "NPM Config",
                        "NSIS",
                        "NWScript",
                        "Nearley",
                        "Nemerle",
                        "NeoSnippet",
                        "NetLinx",
                        "NetLinx+ERB",
                        "NetLogo",
                        "NewLisp",
                        "Nextflow",
                        "Nginx",
                        "Ninja",
                        "Nit",
                        "Nix",
                        "NumPy",
                        "Nunjucks",
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
                        "OpenCL",
                        "OpenEdge ABL",
                        "OpenQASM",
                        "OpenRC runscript",
                        "OpenSCAD",
                        "OpenStep Property List",
                        "OpenType Feature File",
                        "Org",
                        "Ox",
                        "Oxygene",
                        "Oz",
                        "P4",
                        "PEG.js",
                        "PHP",
                        "PLpgSQL",
                        "POV-Ray SDL",
                        "Pan",
                        "Papyrus",
                        "Parrot Assembly",
                        "Parrot Internal Representation",
                        "Parrot",
                        "Pascal",
                        "Pawn",
                        "Pep8",
                        "Perl",
                        "Pickle",
                        "PicoLisp",
                        "PigLatin",
                        "Pike",
                        "PlantUML",
                        "Pod 6",
                        "Pod",
                        "PogoScript",
                        "Pony",
                        "PostCSS",
                        "PostScript",
                        "PowerShell",
                        "Prisma",
                        "Processing",
                        "Proguard",
                        "Prolog",
                        "Promela",
                        "Propeller Spin",
                        "Protocol Buffer",
                        "Protocol Buffers",
                        "Public Key",
                        "Pug",
                        "Puppet",
                        "Pure Data",
                        "PureBasic",
                        "PureScript",
                        "Python",
                        "Q#",
                        "QMake",
                        "Qt Script",
                        "Quake",
                        "R",
                        "RAML",
                        "RDoc",
                        "REALbasic",
                        "REXX",
                        "RMarkdown",
                        "RPC",
                        "RPM Spec",
                        "Racket",
                        "Ragel",
                        "Raw token data",
                        "ReScript",
                        "Readline Config",
                        "Reason",
                        "Rebol",
                        "Record Jar",
                        "Red",
                        "Redirect Rules",
                        "Regular Expression",
                        "RenderScript",
                        "Rich Text Format",
                        "Ring",
                        "Riot",
                        "RobotFramework",
                        "Roff",
                        "Rouge",
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
                        "STON",
                        "SVG",
                        "SWIG",
                        "Sage",
                        "SaltStack",
                        "Sass",
                        "Scala",
                        "Scaml",
                        "Scheme",
                        "Scilab",
                        "Self",
                        "ShaderLab",
                        "Shell",
                        "ShellCheck Config",
                        "Sieve",
                        "Singularity",
                        "Slash",
                        "Slice",
                        "Slim",
                        "SmPL",
                        "Smalltalk",
                        "SnipMate",
                        "Solidity",
                        "Soong",
                        "SourcePawn",
                        "Spline Font Database",
                        "Squirrel",
                        "Stan",
                        "Standard ML",
                        "Starlark",
                        "StringTemplate",
                        "Stylus",
                        "SubRip Text",
                        "SugarSS",
                        "SuperCollider",
                        "Svelte",
                        "Swift",
                        "SystemVerilog",
                        "TI Program",
                        "TLA",
                        "TOML",
                        "TSQL",
                        "TSV",
                        "TSX",
                        "TXL",
                        "Tcl",
                        "Tcsh",
                        "TeX",
                        "Tea",
                        "Terra",
                        "Texinfo",
                        "Text",
                        "TextMate Properties",
                        "Textile",
                        "Thrift",
                        "Turing",
                        "Turtle",
                        "Twig",
                        "Type Language",
                        "TypeScript",
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
                        "VCL",
                        "VHDL",
                        "Vala",
                        "Valve Data Format",
                        "Verilog",
                        "Vim Help File",
                        "Vim Script",
                        "Vim Snippet",
                        "Visual Basic .NET",
                        "Vue",
                        "Wavefront Material",
                        "Wavefront Object",
                        "Web Ontology Language",
                        "WebAssembly",
                        "WebVTT",
                        "Wget Config",
                        "Wikitext",
                        "Windows Registry Entries",
                        "Wollok",
                        "World of Warcraft Addon Data",
                        "X BitMap",
                        "X Font Directory Index",
                        "X PixMap",
                        "X10",
                        "XC",
                        "XCompose",
                        "XML Property List",
                        "XML",
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
                        "ZAP",
                        "ZIL",
                        "Zeek",
                        "ZenScript",
                        "Zephir",
                        "Zig",
                        "Zimpl",
                        "abl",
                        "abuild",
                        "acfm",
                        "aconf",
                        "actionscript 3",
                        "actionscript3",
                        "ada2005",
                        "ada95",
                        "adobe composite font metrics",
                        "adobe multiple font metrics",
                        "advpl",
                        "ags",
                        "ahk",
                        "altium",
                        "amfm",
                        "amusewiki",
                        "apache",
                        "apkbuild",
                        "arexx",
                        "as3",
                        "asm",
                        "asp",
                        "aspx",
                        "aspx-vb",
                        "ats2",
                        "au3",
                        "autoconf",
                        "b3d",
                        "bash session",
                        "bash",
                        "bat",
                        "batch",
                        "bazel",
                        "blitz3d",
                        "blitzplus",
                        "bmax",
                        "bplus",
                        "bro",
                        "bsdmake",
                        "byond",
                        "bzl",
                        "c++-objdump",
                        "c2hs",
                        "cURL Config",
                        "cake",
                        "cakescript",
                        "cfc",
                        "cfm",
                        "cfml",
                        "chpl",
                        "clipper",
                        "coccinelle",
                        "coffee",
                        "coffee-script",
                        "coldfusion html",
                        "console",
                        "cperl",
                        "cpp",
                        "csharp",
                        "csound-csd",
                        "csound-orc",
                        "csound-sco",
                        "cucumber",
                        "curlrc",
                        "cwl",
                        "dcl",
                        "delphi",
                        "desktop",
                        "dircolors",
                        "django",
                        "dosbatch",
                        "dosini",
                        "dpatch",
                        "dtrace-script",
                        "eC",
                        "ecr",
                        "editor-config",
                        "edn",
                        "eeschema schematic",
                        "eex",
                        "elisp",
                        "emacs muse",
                        "emacs",
                        "email",
                        "eml",
                        "erb",
                        "fb",
                        "fish",
                        "flex",
                        "foxpro",
                        "fsharp",
                        "fstar",
                        "ftl",
                        "fundamental",
                        "gf",
                        "git-ignore",
                        "gitattributes",
                        "gitconfig",
                        "gitignore",
                        "gitmodules",
                        "go mod",
                        "go sum",
                        "go.mod",
                        "go.sum",
                        "golang",
                        "groff",
                        "gsp",
                        "hbs",
                        "heex",
                        "help",
                        "html+django",
                        "html+jinja",
                        "html+ruby",
                        "htmlbars",
                        "htmldjango",
                        "hylang",
                        "i7",
                        "ignore",
                        "igor",
                        "igorpro",
                        "ijm",
                        "inc",
                        "inform7",
                        "inputrc",
                        "irc logs",
                        "irc",
                        "java server page",
                        "jq",
                        "jruby",
                        "js",
                        "jsonc",
                        "jsp",
                        "kak",
                        "kakscript",
                        "keyvalues",
                        "ksy",
                        "lassoscript",
                        "latex",
                        "leex",
                        "lhaskell",
                        "lhs",
                        "lisp",
                        "litcoffee",
                        "live-script",
                        "ls",
                        "m2",
                        "m68k",
                        "mIRC Script",
                        "macruby",
                        "mail",
                        "make",
                        "man page",
                        "man",
                        "man-page",
                        "manpage",
                        "markojs",
                        "max/msp",
                        "maxmsp",
                        "mbox",
                        "mcfunction",
                        "mdoc",
                        "mediawiki",
                        "mf",
                        "mma",
                        "mumps",
                        "mupad",
                        "nanorc",
                        "nasm",
                        "ne-on",
                        "nesC",
                        "nette object notation",
                        "nginx configuration file",
                        "nixos",
                        "njk",
                        "node",
                        "npmrc",
                        "nroff",
                        "nush",
                        "nvim",
                        "obj-c",
                        "obj-c++",
                        "obj-j",
                        "objc",
                        "objc++",
                        "objectivec",
                        "objectivec++",
                        "objectivej",
                        "objectpascal",
                        "objj",
                        "octave",
                        "odin-lang",
                        "odinlang",
                        "oncrpc",
                        "ooc",
                        "openedge",
                        "openrc",
                        "osascript",
                        "pandoc",
                        "pasm",
                        "pcbnew",
                        "perl-6",
                        "perl6",
                        "pir",
                        "plain text",
                        "posh",
                        "postscr",
                        "pot",
                        "pov-ray",
                        "povray",
                        "progress",
                        "protobuf",
                        "pwsh",
                        "pycon",
                        "pyrex",
                        "python3",
                        "q",
                        "ql",
                        "qsharp",
                        "ragel-rb",
                        "ragel-ruby",
                        "rake",
                        "raw",
                        "razor",
                        "rb",
                        "rbx",
                        "reStructuredText",
                        "readline",
                        "red/system",
                        "redirects",
                        "regex",
                        "regexp",
                        "renpy",
                        "rhtml",
                        "robots txt",
                        "robots",
                        "robots.txt",
                        "rpcgen",
                        "rs",
                        "rs-274x",
                        "rss",
                        "rst",
                        "rusthon",
                        "salt",
                        "saltstate",
                        "sed",
                        "sepolicy",
                        "sh",
                        "shell-script",
                        "shellcheckrc",
                        "sml",
                        "snippet",
                        "sourcemod",
                        "soy",
                        "specfile",
                        "splus",
                        "squeak",
                        "terraform",
                        "tl",
                        "tm-properties",
                        "troff",
                        "ts",
                        "udiff",
                        "vb .net",
                        "vb.net",
                        "vb6",
                        "vbnet",
                        "vdf",
                        "vim",
                        "vimhelp",
                        "viml",
                        "visual basic 6",
                        "visual basic for applications",
                        "visual basic",
                        "vlang",
                        "wasm",
                        "wast",
                        "wdl",
                        "wgetrc",
                        "wiki",
                        "winbatch",
                        "wisp",
                        "wl",
                        "wolfram lang",
                        "wolfram language",
                        "wolfram",
                        "wsdl",
                        "xBase",
                        "xbm",
                        "xdr",
                        "xhtml",
                        "xml+genshi",
                        "xml+kid",
                        "xpm",
                        "xsd",
                        "xsl",
                        "xten",
                        "yas",
                        "yml",
                        "zsh"
                      ]
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          A workflow category
          https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization#creating-a-starter-workflow
        "%
        | optional,
      description
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A workflow template description
          https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization#creating-a-starter-workflow
        "%,
      filePatterns
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
          A file name pattern to match against repository to enable this workflow when match is succeed
          https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization#creating-a-starter-workflow
        "%
        | optional,
      iconName
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A workflow template icon
          Must be the name of an SVG file, without the file name extension, stored in the workflow-templates directory
          https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization#creating-a-starter-workflow
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
          A workflow template name
          https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization#creating-a-starter-workflow
        "%,
    }