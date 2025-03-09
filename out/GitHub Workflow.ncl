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
      "_js2n__-:definitions/branch!predicate"
        | doc m%"
          When using the push and pull_request events, you can configure a workflow to run on specific branches or tags. If you only define only tags or only branches, the workflow won't run for events affecting the undefined Git ref.
          The branches, branches-ignore, tags, and tags-ignore keywords accept glob patterns that use the * and ** wildcard characters to match more than one branch or tag name. For more information, see https://help.github.com/en/github/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet.
          The patterns defined in branches and tags are evaluated against the Git ref's name. For example, defining the pattern mona/octocat in branches will match the refs/heads/mona/octocat Git ref. The pattern releases/** will match the refs/heads/releases/10 Git ref.
          You can use two types of filters to prevent a workflow from running on pushes and pull requests to tags and branches:
          - branches or branches-ignore - You cannot use both the branches and branches-ignore filters for the same event in a workflow. Use the branches filter when you need to filter branches for positive matches and exclude branches. Use the branches-ignore filter when you only need to exclude branch names.
          - tags or tags-ignore - You cannot use both the tags and tags-ignore filters for the same event in a workflow. Use the tags filter when you need to filter tags for positive matches and exclude tags. Use the tags-ignore filter when you only need to exclude tag names.
          You can exclude tags and branches using the ! character. The order that you define patterns matters.
          - A matching negative pattern (prefixed with !) after a positive match will exclude the Git ref.
          - A matching positive pattern after a negative match will include the Git ref again.
        "%
        = _js2n__-refsenv."_js2n__-:definitions/globs!predicate",
      "_js2n__-:definitions/concurrency!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "group" ],
              _js2n__-prdslib.records.record
                {
                  cancel-in-progress =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                        ],
                  group = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/configuration!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/configuration!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/configuration!predicate"
                ]
            ],
      "_js2n__-:definitions/container!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image" ],
              _js2n__-prdslib.records.record
                {
                  credentials =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              password = _js2n__-prdslib.isType '"String",
                              username = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  env = _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                  image = _js2n__-prdslib.isType '"String",
                  options = _js2n__-prdslib.isType '"String",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"String"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern "^[^:]+:[^:]+$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/defaults!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.minProperties 1,
                _js2n__-prdslib.records.record
                  {
                    run =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.minProperties 1,
                            _js2n__-prdslib.records.record
                              {
                                shell =
                                  _js2n__-refsenv."_js2n__-:definitions/shell!predicate",
                                working-directory =
                                  _js2n__-refsenv."_js2n__-:definitions/working-directory!predicate",
                              } {} false _js2n__-prdslib.never
                          ],
                  } {} false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/defaults!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  run =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record
                            {
                              shell =
                                _js2n__-refsenv."_js2n__-:definitions/shell!predicate",
                              working-directory =
                                _js2n__-refsenv."_js2n__-:definitions/working-directory!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/env!contract"
        | doc "To set custom environment variables, you need to specify the variables in the workflow file. You can define environment variables for a step, job, or entire workflow using the jobs.<job_id>.steps[*].env, jobs.<job_id>.env, and env keywords. For more information, see https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idstepsenv"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  ],
                _js2n__-refsenv."_js2n__-:definitions/stringContainingExpressionSyntax!predicate"
              ]),
      "_js2n__-:definitions/env!predicate"
        | doc "To set custom environment variables, you need to specify the variables in the workflow file. You can define environment variables for a step, job, or entire workflow using the jobs.<job_id>.steps[*].env, jobs.<job_id>.env, and env keywords. For more information, see https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idstepsenv"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                ],
              _js2n__-refsenv."_js2n__-:definitions/stringContainingExpressionSyntax!predicate"
            ],
      "_js2n__-:definitions/environment!predicate"
        | doc "The environment that the job references"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "branch_protection_rule",
                  "check_run",
                  "check_suite",
                  "create",
                  "delete",
                  "deployment",
                  "deployment_status",
                  "discussion",
                  "discussion_comment",
                  "fork",
                  "gollum",
                  "issue_comment",
                  "issues",
                  "label",
                  "merge_group",
                  "milestone",
                  "page_build",
                  "project",
                  "project_card",
                  "project_column",
                  "public",
                  "pull_request",
                  "pull_request_review",
                  "pull_request_review_comment",
                  "pull_request_target",
                  "push",
                  "registry_package",
                  "release",
                  "status",
                  "watch",
                  "workflow_call",
                  "workflow_dispatch",
                  "workflow_run",
                  "repository_dispatch"
                ]
            ],
      "_js2n__-:definitions/eventObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/expressionSyntax!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^\\$\\{\\{(.|[\r\n])*\\}\\}$"
            ],
      "_js2n__-:definitions/globs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/jobNeeds!predicate"
        | doc "Identifies any jobs that must complete successfully before this job will run. It can be a string or array of strings. If a job fails, all jobs that need it are skipped unless the jobs use a conditional statement that causes the job to continue."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ],
              _js2n__-refsenv."_js2n__-:definitions/name!predicate"
            ],
      "_js2n__-:definitions/matrix!predicate"
        | doc m%"
          A build matrix is a set of different configurations of the virtual environment. For example you might run a job against more than one supported version of a language, operating system, or tool. Each configuration is a copy of the job that runs and reports a status.
          You can specify a matrix by supplying an array for the configuration options. For example, if the GitHub virtual environment supports Node.js versions 6, 8, and 10 you could specify an array of those versions in the matrix.
          When you define a matrix of operating systems, you must set the required runs-on keyword to the operating system of the current job, rather than hard-coding the operating system name. To access the operating system name, you can use the matrix.os context parameter to set runs-on. For more information, see https://help.github.com/en/articles/contexts-and-expression-syntax-for-github-actions.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.minProperties 1,
                  _js2n__-prdslib.records.record {}
                    {
                      "^(in|ex)clude$" =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {} {}
                                          true
                                          _js2n__-refsenv."_js2n__-:definitions/configuration!predicate"
                                      ]),
                                  _js2n__-prdslib.arrays.minItems 1
                                ]
                            ],
                    } true
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              _js2n__-refsenv."_js2n__-:definitions/configuration!predicate",
                            _js2n__-prdslib.arrays.minItems 1
                          ],
                        _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                      ])
                ],
              _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
            ],
      "_js2n__-:definitions/name!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[_a-zA-Z][a-zA-Z0-9_-]*$"
            ],
      "_js2n__-:definitions/normalJob!predicate"
        | doc "Each job must have an id to associate with the job. The key job_id is a string and its value is a map of the job's configuration data. You must replace <job_id> with a string that is unique to the jobs object. The <job_id> must start with a letter or _ and contain only alphanumeric characters, -, or _."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "runs-on" ],
              _js2n__-prdslib.records.record
                {
                  concurrency =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/concurrency!predicate"
                        ],
                  container =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/container!predicate"
                        ],
                  continue-on-error =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                        ],
                  defaults =
                    _js2n__-refsenv."_js2n__-:definitions/defaults!predicate",
                  env = _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                  environment =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/environment!predicate"
                        ],
                  "if" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  needs =
                    _js2n__-refsenv."_js2n__-:definitions/jobNeeds!predicate",
                  outputs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  permissions =
                    _js2n__-refsenv."_js2n__-:definitions/permissions!predicate",
                  runs-on =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.arrays.items
                                    [ _js2n__-prdslib.isType '"String" ],
                                  _js2n__-prdslib.arrays.minItems 1
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  group = _js2n__-prdslib.isType '"String",
                                  labels =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/stringContainingExpressionSyntax!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                        ],
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/container!predicate"
                        ],
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  strategy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "matrix" ],
                          _js2n__-prdslib.records.record
                            {
                              fail-fast =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              matrix =
                                _js2n__-refsenv."_js2n__-:definitions/matrix!predicate",
                              max-parallel =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  timeout-minutes =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/path!predicate"
        | doc m%"
          When using the push and pull_request events, you can configure a workflow to run when at least one file does not match paths-ignore or at least one modified file matches the configured paths. Path filters are not evaluated for pushes to tags.
          The paths-ignore and paths keywords accept glob patterns that use the * and ** wildcard characters to match more than one path name. For more information, see https://help.github.com/en/github/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#filter-pattern-cheat-sheet.
          You can exclude paths using two types of filters. You cannot use both of these filters for the same event in a workflow.
          - paths-ignore - Use the paths-ignore filter when you only need to exclude path names.
          - paths - Use the paths filter when you need to filter paths for positive matches and exclude paths.
        "%
        = _js2n__-refsenv."_js2n__-:definitions/globs!predicate",
      "_js2n__-:definitions/permissions!contract"
        | doc "You can modify the default permissions granted to the GITHUB_TOKEN, adding or removing access as required, so that you only allow the minimum required access."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "read-all", "write-all" ]
                  ],
                _js2n__-refsenv."_js2n__-:definitions/permissions-event!predicate"
              ]),
      "_js2n__-:definitions/permissions!predicate"
        | doc "You can modify the default permissions granted to the GITHUB_TOKEN, adding or removing access as required, so that you only allow the minimum required access."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "read-all", "write-all" ]
                ],
              _js2n__-refsenv."_js2n__-:definitions/permissions-event!predicate"
            ],
      "_js2n__-:definitions/permissions-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  attestations =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  checks =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  contents =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  deployments =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  discussions =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  id-token =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  issues =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  packages =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  pages =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  pull-requests =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  repository-projects =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  security-events =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                  statuses =
                    _js2n__-refsenv."_js2n__-:definitions/permissions-level!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/permissions-level!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "read", "write", "none" ]
            ],
      "_js2n__-:definitions/ref!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "branches", "branches-ignore" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "tags", "tags-ignore" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "paths", "paths-ignore" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ])
                        ]
                    ],
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  branches =
                    _js2n__-refsenv."_js2n__-:definitions/branch!predicate",
                  branches-ignore =
                    _js2n__-refsenv."_js2n__-:definitions/branch!predicate",
                  paths = _js2n__-refsenv."_js2n__-:definitions/path!predicate",
                  paths-ignore =
                    _js2n__-refsenv."_js2n__-:definitions/path!predicate",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/branch!predicate",
                  tags-ignore =
                    _js2n__-refsenv."_js2n__-:definitions/branch!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/reusableWorkflowCallJob!predicate"
        | doc "Each job must have an id to associate with the job. The key job_id is a string and its value is a map of the job's configuration data. You must replace <job_id> with a string that is unique to the jobs object. The <job_id> must start with a letter or _ and contain only alphanumeric characters, -, or _."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "uses" ],
              _js2n__-prdslib.records.record
                {
                  concurrency =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/concurrency!predicate"
                        ],
                  "if" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  needs =
                    _js2n__-refsenv."_js2n__-:definitions/jobNeeds!predicate",
                  permissions =
                    _js2n__-refsenv."_js2n__-:definitions/permissions!predicate",
                  secrets =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "inherit" ]
                            ]
                        ],
                  strategy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "matrix" ],
                          _js2n__-prdslib.records.record
                            {
                              fail-fast =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              matrix =
                                _js2n__-refsenv."_js2n__-:definitions/matrix!predicate",
                              max-parallel =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  uses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(.+\\/)+(.+)\\.(ya?ml)(@.+)?$"
                        ],
                  with = _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/shell!predicate"
        | doc "You can override the default shell settings in the runner's operating system using the shell keyword. You can use built-in shell keywords, or you can define a custom set of shell options."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [ "bash", "pwsh", "python", "sh", "cmd", "powershell" ]
                ]
            ],
      "_js2n__-:definitions/step!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "uses" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "run" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  continue-on-error =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                        ],
                  env = _js2n__-refsenv."_js2n__-:definitions/env!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  "if" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  run = _js2n__-prdslib.isType '"String",
                  shell =
                    _js2n__-refsenv."_js2n__-:definitions/shell!predicate",
                  timeout-minutes =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/expressionSyntax!predicate"
                        ],
                  uses = _js2n__-prdslib.isType '"String",
                  with =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record
                            {
                              args = _js2n__-prdslib.isType '"String",
                              entrypoint = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always,
                          _js2n__-refsenv."_js2n__-:definitions/env!predicate"
                        ],
                  working-directory =
                    _js2n__-refsenv."_js2n__-:definitions/working-directory!predicate",
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.dependencies
                { shell = [ "run" ], working-directory = [ "run" ], }
            ],
      "_js2n__-:definitions/stringContainingExpressionSyntax!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^.*\\$\\{\\{(.|[\r\n])*\\}\\}.*$"
            ],
      "_js2n__-:definitions/types!predicate"
        | doc m%"
          Selects the types of activity that will trigger a workflow run. Most GitHub events are triggered by more than one type of activity. For example, the event for the release resource is triggered when a release is published, unpublished, created, edited, deleted, or prereleased. The types keyword enables you to narrow down activity that causes the workflow to run. When only one activity type triggers a webhook event, the types keyword is unnecessary.
          You can use an array of event types. For more information about each event and their activity types, see https://help.github.com/en/articles/events-that-trigger-workflows#webhook-events.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/workflowDispatchInput!predicate"
        | doc "A string identifier to associate with the input. The value of <input_id> is a map of the input's metadata. The <input_id> must be a unique identifier within the inputs object. The <input_id> must start with a letter or _ and contain only alphanumeric characters, -, or _."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "type" ],
                        _js2n__-prdslib.records.record
                          { type = _js2n__-prdslib.const "string", } {} true
                          _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.records.record
                      { "default" = _js2n__-prdslib.isType '"String", } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "type" ],
                        _js2n__-prdslib.records.record
                          { type = _js2n__-prdslib.const "boolean", } {} true
                          _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.records.record
                      { "default" = _js2n__-prdslib.isType '"Bool", } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "type" ],
                        _js2n__-prdslib.records.record
                          { type = _js2n__-prdslib.const "number", } {} true
                          _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.records.record
                      { "default" = _js2n__-prdslib.isType '"Number", } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "type" ],
                        _js2n__-prdslib.records.record
                          { type = _js2n__-prdslib.const "environment", } {}
                          true _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.records.record
                      { "default" = _js2n__-prdslib.isType '"String", } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "type" ],
                        _js2n__-prdslib.records.record
                          { type = _js2n__-prdslib.const "choice", } {} true
                          _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "options" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ]) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "description" ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.always,
                  deprecationMessage = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  required = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "string",
                              "choice",
                              "boolean",
                              "number",
                              "environment"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/working-directory!predicate"
        | doc "Using the working-directory keyword, you can specify the working directory of where to run the command."
        = _js2n__-prdslib.isType '"String",
    }
    in
  {
      concurrency
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/concurrency!predicate"
            ])
        | doc m%"
          Concurrency ensures that only a single job or workflow using the same concurrency group will run at a time. A concurrency group can be any string or expression. The expression can use any context except for the secrets context. 
          You can also specify concurrency at the workflow level. 
          When a concurrent job or workflow is queued, if another job or workflow using the same concurrency group in the repository is in progress, the queued job or workflow will be pending. Any previously pending job or workflow in the concurrency group will be canceled. To also cancel any currently running job or workflow in the same concurrency group, specify cancel-in-progress: true.
        "%
        | optional,
      defaults
        | _js2n__-refsenv."_js2n__-:definitions/defaults!contract"
        | doc "A map of default settings that will apply to all jobs in the workflow."
        | optional,
      env
        | _js2n__-refsenv."_js2n__-:definitions/env!contract"
        | doc "A map of environment variables that are available to all jobs and steps in the workflow."
        | optional,
      jobs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {}
                {
                  "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/normalJob!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/reusableWorkflowCallJob!predicate"
                        ],
                } false _js2n__-prdslib.never
            ])
        | doc m%"
          A workflow run is made up of one or more jobs. Jobs run in parallel by default. To run jobs sequentially, you can define dependencies on other jobs using the jobs.<job_id>.needs keyword.
          Each job runs in a fresh instance of the virtual environment specified by runs-on.
          You can run an unlimited number of jobs as long as you are within the workflow usage limits. For more information, see https://help.github.com/en/github/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions#usage-limits.
        "%,
      name
        | String
        | doc "The name of your workflow. GitHub displays the names of your workflows on your repository's actions page. If you omit this field, GitHub sets the name to the workflow's filename."
        | optional,
      on
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/event!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/event!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      branch_protection_rule =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      check_run =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "rerequested",
                                                    "completed",
                                                    "requested_action"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      check_suite =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "completed",
                                                    "requested",
                                                    "rerequested"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      create =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      delete =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      deployment =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      deployment_status =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      discussion =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "edited",
                                                    "deleted",
                                                    "transferred",
                                                    "pinned",
                                                    "unpinned",
                                                    "labeled",
                                                    "unlabeled",
                                                    "locked",
                                                    "unlocked",
                                                    "category_changed",
                                                    "answered",
                                                    "unanswered"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      discussion_comment =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      fork =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      gollum =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      issue_comment =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      issues =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "opened",
                                                    "edited",
                                                    "deleted",
                                                    "transferred",
                                                    "pinned",
                                                    "unpinned",
                                                    "closed",
                                                    "reopened",
                                                    "assigned",
                                                    "unassigned",
                                                    "labeled",
                                                    "unlabeled",
                                                    "locked",
                                                    "unlocked",
                                                    "milestoned",
                                                    "demilestoned"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      label =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      merge_group =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "checks_requested" ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      milestone =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "closed",
                                                    "opened",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      page_build =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      project =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "updated",
                                                    "closed",
                                                    "reopened",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      project_card =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "moved",
                                                    "converted",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      project_column =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "updated",
                                                    "moved",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      public =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      pull_request =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "assigned",
                                                    "unassigned",
                                                    "labeled",
                                                    "unlabeled",
                                                    "opened",
                                                    "edited",
                                                    "closed",
                                                    "reopened",
                                                    "synchronize",
                                                    "converted_to_draft",
                                                    "ready_for_review",
                                                    "locked",
                                                    "unlocked",
                                                    "milestoned",
                                                    "demilestoned",
                                                    "review_requested",
                                                    "review_request_removed",
                                                    "auto_merge_enabled",
                                                    "auto_merge_disabled",
                                                    "enqueued",
                                                    "dequeued"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                }
                                {
                                  "^(branche|tag|path)s(-ignore)?$" =
                                    _js2n__-prdslib.isType '"Array",
                                } false _js2n__-prdslib.never,
                              _js2n__-refsenv."_js2n__-:definitions/ref!predicate"
                            ],
                      pull_request_review =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "submitted",
                                                    "edited",
                                                    "dismissed"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      pull_request_review_comment =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "created",
                                                    "edited",
                                                    "deleted"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      pull_request_target =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "assigned",
                                                    "unassigned",
                                                    "labeled",
                                                    "unlabeled",
                                                    "opened",
                                                    "edited",
                                                    "closed",
                                                    "reopened",
                                                    "synchronize",
                                                    "converted_to_draft",
                                                    "ready_for_review",
                                                    "locked",
                                                    "unlocked",
                                                    "review_requested",
                                                    "review_request_removed",
                                                    "auto_merge_enabled",
                                                    "auto_merge_disabled"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                }
                                {
                                  "^(branche|tag|path)s(-ignore)?$" =
                                    _js2n__-prdslib.always,
                                } false _js2n__-prdslib.never,
                              _js2n__-refsenv."_js2n__-:definitions/ref!predicate"
                            ],
                      push =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record {}
                                {
                                  "^(branche|tag|path)s(-ignore)?$" =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                } false _js2n__-prdslib.never,
                              _js2n__-refsenv."_js2n__-:definitions/ref!predicate"
                            ],
                      registry_package =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "published", "updated" ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      release =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "published",
                                                    "unpublished",
                                                    "created",
                                                    "edited",
                                                    "deleted",
                                                    "prereleased",
                                                    "released"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                } {} true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                      repository_dispatch =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      schedule =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        cron = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      status =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      watch =
                        _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate",
                      workflow_call =
                        _js2n__-prdslib.records.record
                            {
                              inputs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "type" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      "default" =
                                                        _js2n__-prdslib.anyOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Bool",
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.isType
                                                                '"String"
                                                            ],
                                                      deprecationMessage =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      required =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      type =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "boolean",
                                                                  "number",
                                                                  "string"
                                                                ]
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                        } false _js2n__-prdslib.never
                                    ],
                              secrets =
                                _js2n__-prdslib.records.record {}
                                    {
                                      "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "required" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  description =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  required =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } false _js2n__-prdslib.never,
                            } {} true _js2n__-prdslib.always,
                      workflow_dispatch =
                        _js2n__-prdslib.records.record
                            {
                              inputs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          "^[_a-zA-Z][a-zA-Z0-9_-]*$" =
                                            _js2n__-refsenv."_js2n__-:definitions/workflowDispatchInput!predicate",
                                        } false _js2n__-prdslib.never
                                    ],
                            } {} false _js2n__-prdslib.never,
                      workflow_run =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.record
                                {
                                  types =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "requested",
                                                    "completed",
                                                    "in_progress"
                                                  ]
                                              ]),
                                          _js2n__-refsenv."_js2n__-:definitions/types!predicate"
                                        ],
                                  workflows =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.minItems 1
                                        ],
                                }
                                {
                                  "^branches(-ignore)?$" =
                                    _js2n__-prdslib.always,
                                } true _js2n__-prdslib.always,
                              _js2n__-refsenv."_js2n__-:definitions/eventObject!predicate"
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ])
        | doc "The name of the GitHub event that triggers the workflow. You can provide a single event string, array of events, array of event types, or an event configuration map that schedules a workflow or restricts the execution of a workflow to specific files, tags, or branch changes. For a list of available events, see https://help.github.com/en/github/automating-your-workflow-with-github-actions/events-that-trigger-workflows.",
      permissions
        | _js2n__-refsenv."_js2n__-:definitions/permissions!contract"
        | optional,
      run-name
        | String
        | doc "The name for workflow runs generated from the workflow. GitHub displays the workflow run name in the list of workflow runs on your repository's 'Actions' tab."
        | optional,
    }