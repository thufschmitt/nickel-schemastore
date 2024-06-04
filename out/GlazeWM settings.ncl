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
      "_js2n__-:definitions/background-property!contract" =
        _js2n__-refsenv."_js2n__-:definitions/color!contract",
      "_js2n__-:definitions/background-property!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
      "_js2n__-:definitions/binding!predicate"
        | doc m%"
          A binding
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#keybindings
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.not (_js2n__-prdslib.strings.pattern "^\\s+$")
            ],
      "_js2n__-:definitions/bindings!predicate"
        | doc m%"
          Bindings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#keybindings
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/binding!predicate",
              _js2n__-prdslib.arrays.minItems 2,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/border-color-property!contract" =
        _js2n__-refsenv."_js2n__-:definitions/color!contract",
      "_js2n__-:definitions/border-color-property!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
      "_js2n__-:definitions/border-width-property!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.not
                  _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/border-width-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.not
                _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/color!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^\\S+$"
              ]),
      "_js2n__-:definitions/color!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^\\S+$"
            ],
      "_js2n__-:definitions/command!predicate"
        | doc m%"
          A command
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#available-commands
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.not
                _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/commands!predicate"
        | doc m%"
          Commands
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#available-commands
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/command!predicate",
              _js2n__-prdslib.arrays.minItems 2,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/component.background-property!predicate"
        | doc m%"
          A background of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/background-property!predicate",
      "_js2n__-:definitions/component.border-color-property!predicate"
        | doc m%"
          A border color of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/border-color-property!predicate",
      "_js2n__-:definitions/component.border-width-property!predicate"
        | doc m%"
          A border width of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/border-width-property!predicate",
      "_js2n__-:definitions/component.font-family-property!predicate"
        | doc m%"
          A font family of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/font-family-property!predicate",
      "_js2n__-:definitions/component.font-size-property!predicate"
        | doc m%"
          A font size of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/font-size-property!predicate",
      "_js2n__-:definitions/component.font-weight-property!predicate"
        | doc m%"
          A font weight of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/font-weight-property!predicate",
      "_js2n__-:definitions/component.foreground-property!predicate"
        | doc m%"
          A foreground of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/foreground-property!predicate",
      "_js2n__-:definitions/component.margin-property!predicate"
        | doc m%"
          A margin of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.not
                _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/component.opacity-property!predicate"
        | doc m%"
          An opacity of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/opacity-property!predicate",
      "_js2n__-:definitions/component.padding-property!predicate"
        | doc m%"
          A padding of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-refsenv."_js2n__-:definitions/padding-property!predicate",
      "_js2n__-:definitions/component.type-property!predicate"
        | doc m%"
          A type of the component
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-component-configuration
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.strings.pattern "\\S"
            ],
      "_js2n__-:definitions/components!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "clock", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                time_formatting =
                                  _js2n__-prdslib.isType '"String",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "battery", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label_charging =
                                  _js2n__-prdslib.isType '"String",
                                label_draining =
                                  _js2n__-prdslib.isType '"String",
                                label_power_saver =
                                  _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "cpu", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label = _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                refresh_interval_ms =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "gpu", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label = _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                refresh_interval_ms =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "memory", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label = _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                refresh_interval_ms =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "network", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label_ethernet =
                                  _js2n__-prdslib.isType '"String",
                                label_no_internet =
                                  _js2n__-prdslib.isType '"String",
                                label_wifi_strength_0 =
                                  _js2n__-prdslib.isType '"String",
                                label_wifi_strength_100 =
                                  _js2n__-prdslib.isType '"String",
                                label_wifi_strength_25 =
                                  _js2n__-prdslib.isType '"String",
                                label_wifi_strength_50 =
                                  _js2n__-prdslib.isType '"String",
                                label_wifi_strength_75 =
                                  _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "volume", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label_high = _js2n__-prdslib.isType '"String",
                                label_low = _js2n__-prdslib.isType '"String",
                                label_medium = _js2n__-prdslib.isType '"String",
                                label_mute = _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "text file", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                file_path =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.minLength 1
                                      ],
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "weather", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label = _js2n__-prdslib.isType '"String",
                                label_cloud = _js2n__-prdslib.isType '"String",
                                label_cloud_moon =
                                  _js2n__-prdslib.isType '"String",
                                label_cloud_moon_rain =
                                  _js2n__-prdslib.isType '"String",
                                label_cloud_rain =
                                  _js2n__-prdslib.isType '"String",
                                label_cloud_sun =
                                  _js2n__-prdslib.isType '"String",
                                label_cloud_sun_rain =
                                  _js2n__-prdslib.isType '"String",
                                label_moon = _js2n__-prdslib.isType '"String",
                                label_snow_flake =
                                  _js2n__-prdslib.isType '"String",
                                label_sun = _js2n__-prdslib.isType '"String",
                                label_thunderstorm =
                                  _js2n__-prdslib.isType '"String",
                                latitude =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.maximum 90,
                                        _js2n__-prdslib.numbers.minimum (-90)
                                      ],
                                longitude =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.numbers.maximum 180,
                                        _js2n__-prdslib.numbers.minimum (-180)
                                      ],
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "image", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                source =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.minLength 1
                                      ],
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "system tray", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label_collapse_text =
                                  _js2n__-prdslib.isType '"String",
                                label_expand_text =
                                  _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "music", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                background =
                                  _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                                border_color =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                                border_width =
                                  _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                                font_family =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                                font_size =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                                font_weight =
                                  _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                                foreground =
                                  _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                                label_not_playing =
                                  _js2n__-prdslib.isType '"String",
                                label_paused = _js2n__-prdslib.isType '"String",
                                label_playing =
                                  _js2n__-prdslib.isType '"String",
                                margin =
                                  _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                                max_artist_length =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                max_title_length =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                opacity =
                                  _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                                padding =
                                  _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                                type =
                                  _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.records.record
                        {
                          background =
                            _js2n__-refsenv."_js2n__-:definitions/component.background-property!predicate",
                          border_color =
                            _js2n__-refsenv."_js2n__-:definitions/component.border-color-property!predicate",
                          border_width =
                            _js2n__-refsenv."_js2n__-:definitions/component.border-width-property!predicate",
                          font_family =
                            _js2n__-refsenv."_js2n__-:definitions/component.font-family-property!predicate",
                          font_size =
                            _js2n__-refsenv."_js2n__-:definitions/component.font-size-property!predicate",
                          font_weight =
                            _js2n__-refsenv."_js2n__-:definitions/component.font-weight-property!predicate",
                          foreground =
                            _js2n__-refsenv."_js2n__-:definitions/component.foreground-property!predicate",
                          margin =
                            _js2n__-refsenv."_js2n__-:definitions/component.margin-property!predicate",
                          opacity =
                            _js2n__-refsenv."_js2n__-:definitions/component.opacity-property!predicate",
                          padding =
                            _js2n__-refsenv."_js2n__-:definitions/component.padding-property!predicate",
                          type =
                            _js2n__-refsenv."_js2n__-:definitions/component.type-property!predicate",
                        } {} true _js2n__-prdslib.always
                    ]),
                _js2n__-prdslib.arrays.minItems 1,
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/font-family-property!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1,
                _js2n__-prdslib.strings.pattern "^\\S+(\\s+\\S+)*$"
              ]),
      "_js2n__-:definitions/font-family-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.strings.pattern "^\\S+(\\s+\\S+)*$"
            ],
      "_js2n__-:definitions/font-size-property!contract" =
        _js2n__-refsenv."_js2n__-:definitions/length!contract",
      "_js2n__-:definitions/font-size-property!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/length!predicate",
      "_js2n__-:definitions/font-weight-property!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Integer,
                _js2n__-prdslib.numbers.minimum 0
              ]),
      "_js2n__-:definitions/font-weight-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/foreground-property!contract" =
        _js2n__-refsenv."_js2n__-:definitions/color!contract",
      "_js2n__-:definitions/foreground-property!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
      "_js2n__-:definitions/invalid-shorthand-property!predicate" =
        _js2n__-prdslib.strings.pattern "^\\s+$|\\spx\\s|\\spx$|^px",
      "_js2n__-:definitions/length!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^\\d+px$"
              ]),
      "_js2n__-:definitions/length!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^\\d+px$"
            ],
      "_js2n__-:definitions/opacity-property!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.numbers.maximum 1,
                _js2n__-prdslib.numbers.minimum 0
              ]),
      "_js2n__-:definitions/opacity-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 1,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/padding-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.not
                _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
              _js2n__-prdslib.strings.minLength 1
            ],
    }
    in
  {
      bar
        | {
          always_on_top
            | Bool
            | doc m%"
              Whether to keep the bar above other windows
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          background
            | _js2n__-refsenv."_js2n__-:definitions/background-property!contract"
            | doc m%"
              A background of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          border_color
            | _js2n__-refsenv."_js2n__-:definitions/border-color-property!contract"
            | doc m%"
              A border color of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          border_radius
            | std.number.Integer
            | doc m%"
              A border radius of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          border_width
            | _js2n__-refsenv."_js2n__-:definitions/border-width-property!contract"
            | doc m%"
              A border width of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          components_center
            | _js2n__-refsenv."_js2n__-:definitions/components!contract"
            | doc m%"
              Center component settings
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          components_left
            | _js2n__-refsenv."_js2n__-:definitions/components!contract"
            | doc m%"
              Left component settings
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          components_right
            | _js2n__-refsenv."_js2n__-:definitions/components!contract"
            | doc m%"
              Right component settings
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          enabled
            | Bool
            | doc m%"
              Whether to enable the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          font_family
            | _js2n__-refsenv."_js2n__-:definitions/font-family-property!contract"
            | doc m%"
              A font family of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          font_size
            | _js2n__-refsenv."_js2n__-:definitions/font-size-property!contract"
            | doc m%"
              A font size of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          font_weight
            | _js2n__-refsenv."_js2n__-:definitions/font-weight-property!contract"
            | doc m%"
              A font weight of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          foreground
            | _js2n__-refsenv."_js2n__-:definitions/foreground-property!contract"
            | doc m%"
              A foreground of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          height
            | _js2n__-refsenv."_js2n__-:definitions/length!contract"
            | doc m%"
              A height of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          offset_x
            | std.number.Integer
            | doc m%"
              A horizontal offset of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          offset_y
            | std.number.Integer
            | doc m%"
              A vertical offset of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          opacity
            | _js2n__-refsenv."_js2n__-:definitions/opacity-property!contract"
            | doc m%"
              An opacity of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          padding
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.not
                    _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
                  _js2n__-prdslib.strings.minLength 1
                ])
            | doc m%"
              A padding of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
          position
            | std.enum.TagOrString
            | [| 'bottom, 'top |]
            | doc m%"
              A position of the bar
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
            "%
            | optional,
        }
        | doc m%"
          Bar settings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#bar-configuration
        "%
        | optional,
      focus_borders
        | {
          active
            | {
              color
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  A color of the active border
                  https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
                "%
                | optional,
              enabled
                | Bool
                | doc m%"
                  Whether to enable the active border
                  https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
                "%
                | optional,
            }
            | doc m%"
              An active border
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
            "%
            | optional,
          inactive
            | {
              color
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  A color of the active border
                  https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
                "%
                | optional,
              enabled
                | Bool
                | doc m%"
                  Whether to enable the inactive border
                  https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
                "%
                | optional,
            }
            | doc m%"
              An inactive border
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
            "%
            | optional,
        }
        | doc m%"
          Focus settings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#focus-window-border-configuration
        "%
        | optional,
      gaps
        | {
          inner_gap
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.not
                    _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
                  _js2n__-prdslib.strings.minLength 1
                ])
            | doc m%"
              An inner gap
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#gap-configuration
            "%
            | optional,
          outer_gap
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.not
                    _js2n__-refsenv."_js2n__-:definitions/invalid-shorthand-property!predicate",
                  _js2n__-prdslib.strings.minLength 1
                ])
            | doc m%"
              An outer gap
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#gap-configuration
            "%
            | optional,
        }
        | doc m%"
          Gap settings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#gap-configuration
        "%
        | optional,
      general
        | {
          center_new_floating_windows
            | Bool
            | doc m%"
              Whether to center new floating windows
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
          cursor_follows_focus
            | Bool
            | doc m%"
              Whether to jump the cursor between windows focused by the WM
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
          floating_window_move_amount
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 2,
                  _js2n__-prdslib.strings.pattern "^\\d+%$"
                ])
            | doc m%"
              An amount to move floating windows by
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
          focus_follows_cursor
            | Bool
            | doc m%"
              Whether to automatically focus windows underneath the cursor
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
          show_floating_on_top
            | Bool
            | doc m%"
              Whether to show floating windows as always on top
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
          toggle_workspace_on_refocus
            | Bool
            | doc m%"
              Whether to switch back and forth between the previously focused workspace when focusing the current workspace
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
          window_animations
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.const "unchanged"
                    ]
                ])
            | doc m%"
              Whether to enable window transition animations
              https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
            "%
            | optional,
        }
        | doc m%"
          General settings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#general
        "%
        | optional,
      keybindings
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.records.record
                          {
                            binding =
                              _js2n__-refsenv."_js2n__-:definitions/binding!predicate",
                            command =
                              _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                          } {} false _js2n__-prdslib.never,
                        _js2n__-prdslib.records.record
                          {
                            bindings =
                              _js2n__-refsenv."_js2n__-:definitions/bindings!predicate",
                            command =
                              _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                          } {} false _js2n__-prdslib.never,
                        _js2n__-prdslib.records.record
                          {
                            binding =
                              _js2n__-refsenv."_js2n__-:definitions/binding!predicate",
                            commands =
                              _js2n__-refsenv."_js2n__-:definitions/commands!predicate",
                          } {} false _js2n__-prdslib.never,
                        _js2n__-prdslib.records.record
                          {
                            bindings =
                              _js2n__-refsenv."_js2n__-:definitions/bindings!predicate",
                            commands =
                              _js2n__-refsenv."_js2n__-:definitions/commands!predicate",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.records.maxProperties 2,
                    _js2n__-prdslib.records.minProperties 2,
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Keybindings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#keybindings
        "%
        | optional,
      window_rules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        command =
                          _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                        match_class_name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        match_process_name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        match_title =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Windows rule settings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#window-rules
        "%
        | optional,
      workspaces
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        bind_to_monitor = _js2n__-prdslib.isType '"Bool",
                        display_name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "\\S"
                              ],
                        keep_alive = _js2n__-prdslib.isType '"Bool",
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.strings.pattern "\\S"
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Workspace settings
          https://github.com/glzr-io/glazewm?tab=readme-ov-file#workspaces-configuration
        "%
        | optional,
      ..
    }