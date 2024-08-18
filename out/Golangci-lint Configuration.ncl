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
      "_js2n__-:definitions/gocritic-checks!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [
                "appendAssign",
                "appendCombine",
                "argOrder",
                "assignOp",
                "badCall",
                "badCond",
                "badLock",
                "badRegexp",
                "badSorting",
                "boolExprSimplify",
                "builtinShadow",
                "builtinShadowDecl",
                "captLocal",
                "caseOrder",
                "codegenComment",
                "commentedOutCode",
                "commentedOutImport",
                "commentFormatting",
                "defaultCaseOrder",
                "deferUnlambda",
                "deferInLoop",
                "deprecatedComment",
                "docStub",
                "dupArg",
                "dupBranchBody",
                "dupCase",
                "dupImport",
                "dupSubExpr",
                "dynamicFmtString",
                "elseif",
                "emptyDecl",
                "emptyFallthrough",
                "emptyStringTest",
                "equalFold",
                "evalOrder",
                "exitAfterDefer",
                "exposedSyncMutex",
                "externalErrorReassign",
                "filepathJoin",
                "flagDeref",
                "flagName",
                "hexLiteral",
                "httpNoBody",
                "hugeParam",
                "ifElseChain",
                "importShadow",
                "indexAlloc",
                "initClause",
                "ioutilDeprecated",
                "mapKey",
                "methodExprCall",
                "nestingReduce",
                "newDeref",
                "nilValReturn",
                "octalLiteral",
                "offBy1",
                "paramTypeCombine",
                "preferDecodeRune",
                "preferFilepathJoin",
                "preferFprint",
                "preferStringWriter",
                "preferWriteByte",
                "ptrToRefParam",
                "rangeExprCopy",
                "rangeValCopy",
                "redundantSprint",
                "regexpMust",
                "regexpPattern",
                "regexpSimplify",
                "returnAfterHttpError",
                "ruleguard",
                "singleCaseSwitch",
                "sliceClear",
                "sloppyLen",
                "sloppyReassign",
                "sloppyTypeAssert",
                "sortSlice",
                "sprintfQuotedString",
                "sqlQuery",
                "stringConcatSimplify",
                "stringsCompare",
                "stringXbytes",
                "suspiciousSorting",
                "switchTrue",
                "syncMapLoadAndDelete",
                "timeCmpSimplify",
                "timeExprSimplify",
                "tooManyResultsChecker",
                "truncateCmp",
                "typeAssertChain",
                "typeDefFirst",
                "typeSwitchVar",
                "typeUnparen",
                "uncheckedInlineErr",
                "underef",
                "unlabelStmt",
                "unlambda",
                "unnamedResult",
                "unnecessaryBlock",
                "unnecessaryDefer",
                "unslice",
                "valSwap",
                "weakCond",
                "whyNoLint",
                "wrapperFunc",
                "yodaStyleExpr"
              ]),
      "_js2n__-:definitions/gocritic-tags!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [
                "diagnostic",
                "style",
                "performance",
                "experimental",
                "opinionated",
                "security"
              ]),
      "_js2n__-:definitions/gosec-rules!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [
                "G101",
                "G102",
                "G103",
                "G104",
                "G106",
                "G107",
                "G108",
                "G109",
                "G110",
                "G111",
                "G112",
                "G113",
                "G114",
                "G201",
                "G202",
                "G203",
                "G204",
                "G301",
                "G302",
                "G303",
                "G304",
                "G305",
                "G306",
                "G307",
                "G401",
                "G402",
                "G403",
                "G404",
                "G501",
                "G502",
                "G503",
                "G504",
                "G505",
                "G601"
              ]),
      "_js2n__-:definitions/govet-analyzers!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [
                "appends",
                "asmdecl",
                "assign",
                "atomic",
                "atomicalign",
                "bools",
                "buildtag",
                "cgocall",
                "composites",
                "copylocks",
                "deepequalerrors",
                "defers",
                "directive",
                "errorsas",
                "fieldalignment",
                "findcall",
                "framepointer",
                "httpresponse",
                "ifaceassert",
                "loopclosure",
                "lostcancel",
                "nilfunc",
                "nilness",
                "printf",
                "reflectvaluecompare",
                "shadow",
                "shift",
                "sigchanyzer",
                "slog",
                "sortslice",
                "stdmethods",
                "stringintconv",
                "structtag",
                "testinggoroutine",
                "tests",
                "unmarshal",
                "unreachable",
                "unsafeptr",
                "unusedresult",
                "unusedwrite"
              ]),
      "_js2n__-:definitions/govet-analyzers!predicate" =
        _js2n__-prdslib.enum
            [
              "appends",
              "asmdecl",
              "assign",
              "atomic",
              "atomicalign",
              "bools",
              "buildtag",
              "cgocall",
              "composites",
              "copylocks",
              "deepequalerrors",
              "defers",
              "directive",
              "errorsas",
              "fieldalignment",
              "findcall",
              "framepointer",
              "httpresponse",
              "ifaceassert",
              "loopclosure",
              "lostcancel",
              "nilfunc",
              "nilness",
              "printf",
              "reflectvaluecompare",
              "shadow",
              "shift",
              "sigchanyzer",
              "slog",
              "sortslice",
              "stdmethods",
              "stringintconv",
              "structtag",
              "testinggoroutine",
              "tests",
              "unmarshal",
              "unreachable",
              "unsafeptr",
              "unusedresult",
              "unusedwrite"
            ],
      "_js2n__-:definitions/linters!contract"
        | doc "Linters usable."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.enum
                  [
                    "asasalint",
                    "asciicheck",
                    "bidichk",
                    "bodyclose",
                    "canonicalheader",
                    "containedctx",
                    "contextcheck",
                    "copyloopvar",
                    "cyclop",
                    "deadcode",
                    "decorder",
                    "depguard",
                    "dogsled",
                    "dupl",
                    "dupword",
                    "durationcheck",
                    "errcheck",
                    "errchkjson",
                    "errname",
                    "errorlint",
                    "execinquery",
                    "exhaustive",
                    "exhaustivestruct",
                    "exhaustruct",
                    "exportloopref",
                    "fatcontext",
                    "forbidigo",
                    "forcetypeassert",
                    "funlen",
                    "gci",
                    "ginkgolinter",
                    "gocheckcompilerdirectives",
                    "gochecknoglobals",
                    "gochecknoinits",
                    "gochecksumtype",
                    "gocognit",
                    "goconst",
                    "gocritic",
                    "gocyclo",
                    "godot",
                    "godox",
                    "err113",
                    "gofmt",
                    "gofumpt",
                    "goheader",
                    "goimports",
                    "golint",
                    "gomoddirectives",
                    "gomodguard",
                    "goprintffuncname",
                    "gosec",
                    "gosimple",
                    "gosmopolitan",
                    "govet",
                    "grouper",
                    "ifshort",
                    "importas",
                    "inamedparam",
                    "ineffassign",
                    "interfacebloat",
                    "interfacer",
                    "intrange",
                    "ireturn",
                    "lll",
                    "loggercheck",
                    "maintidx",
                    "makezero",
                    "maligned",
                    "mirror",
                    "misspell",
                    "mnd",
                    "musttag",
                    "nakedret",
                    "nestif",
                    "nilerr",
                    "nilnil",
                    "nlreturn",
                    "noctx",
                    "nolintlint",
                    "nonamedreturns",
                    "nosnakecase",
                    "nosprintfhostport",
                    "paralleltest",
                    "perfsprint",
                    "prealloc",
                    "predeclared",
                    "promlinter",
                    "protogetter",
                    "reassign",
                    "revive",
                    "rowserrcheck",
                    "scopelint",
                    "sloglint",
                    "sqlclosecheck",
                    "staticcheck",
                    "structcheck",
                    "stylecheck",
                    "tagalign",
                    "tagliatelle",
                    "tenv",
                    "testableexamples",
                    "testifylint",
                    "testpackage",
                    "thelper",
                    "tparallel",
                    "typecheck",
                    "unconvert",
                    "unparam",
                    "unused",
                    "usestdlibvars",
                    "varcheck",
                    "varnamelen",
                    "wastedassign",
                    "whitespace",
                    "wrapcheck",
                    "wsl",
                    "zerologlint"
                  ],
                _js2n__-prdslib.isType '"String"
              ]),
      "_js2n__-:definitions/linters!predicate"
        | doc "Linters usable."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "asasalint",
                  "asciicheck",
                  "bidichk",
                  "bodyclose",
                  "canonicalheader",
                  "containedctx",
                  "contextcheck",
                  "copyloopvar",
                  "cyclop",
                  "deadcode",
                  "decorder",
                  "depguard",
                  "dogsled",
                  "dupl",
                  "dupword",
                  "durationcheck",
                  "errcheck",
                  "errchkjson",
                  "errname",
                  "errorlint",
                  "execinquery",
                  "exhaustive",
                  "exhaustivestruct",
                  "exhaustruct",
                  "exportloopref",
                  "fatcontext",
                  "forbidigo",
                  "forcetypeassert",
                  "funlen",
                  "gci",
                  "ginkgolinter",
                  "gocheckcompilerdirectives",
                  "gochecknoglobals",
                  "gochecknoinits",
                  "gochecksumtype",
                  "gocognit",
                  "goconst",
                  "gocritic",
                  "gocyclo",
                  "godot",
                  "godox",
                  "err113",
                  "gofmt",
                  "gofumpt",
                  "goheader",
                  "goimports",
                  "golint",
                  "gomoddirectives",
                  "gomodguard",
                  "goprintffuncname",
                  "gosec",
                  "gosimple",
                  "gosmopolitan",
                  "govet",
                  "grouper",
                  "ifshort",
                  "importas",
                  "inamedparam",
                  "ineffassign",
                  "interfacebloat",
                  "interfacer",
                  "intrange",
                  "ireturn",
                  "lll",
                  "loggercheck",
                  "maintidx",
                  "makezero",
                  "maligned",
                  "mirror",
                  "misspell",
                  "mnd",
                  "musttag",
                  "nakedret",
                  "nestif",
                  "nilerr",
                  "nilnil",
                  "nlreturn",
                  "noctx",
                  "nolintlint",
                  "nonamedreturns",
                  "nosnakecase",
                  "nosprintfhostport",
                  "paralleltest",
                  "perfsprint",
                  "prealloc",
                  "predeclared",
                  "promlinter",
                  "protogetter",
                  "reassign",
                  "revive",
                  "rowserrcheck",
                  "scopelint",
                  "sloglint",
                  "sqlclosecheck",
                  "staticcheck",
                  "structcheck",
                  "stylecheck",
                  "tagalign",
                  "tagliatelle",
                  "tenv",
                  "testableexamples",
                  "testifylint",
                  "testpackage",
                  "thelper",
                  "tparallel",
                  "typecheck",
                  "unconvert",
                  "unparam",
                  "unused",
                  "usestdlibvars",
                  "varcheck",
                  "varnamelen",
                  "wastedassign",
                  "whitespace",
                  "wrapcheck",
                  "wsl",
                  "zerologlint"
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/revive-rules!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [
                "add-constant",
                "argument-limit",
                "atomic",
                "banned-characters",
                "bare-return",
                "blank-imports",
                "bool-literal-in-expr",
                "call-to-gc",
                "cognitive-complexity",
                "comment-spacings",
                "comments-density",
                "confusing-naming",
                "confusing-results",
                "constant-logical-expr",
                "context-as-argument",
                "context-keys-type",
                "cyclomatic",
                "datarace",
                "deep-exit",
                "defer",
                "dot-imports",
                "duplicated-imports",
                "early-return",
                "empty-block",
                "empty-lines",
                "enforce-map-style",
                "enforce-repeated-arg-type-style",
                "enforce-slice-style",
                "error-naming",
                "error-return",
                "error-strings",
                "errorf",
                "exported",
                "file-header",
                "flag-parameter",
                "function-length",
                "function-result-limit",
                "get-return",
                "identical-branches",
                "if-return",
                "import-alias-naming",
                "import-shadowing",
                "imports-blocklist",
                "increment-decrement",
                "indent-error-flow",
                "line-length-limit",
                "max-control-nesting",
                "max-public-structs",
                "modifies-parameter",
                "modifies-value-receiver",
                "nested-structs",
                "optimize-operands-order",
                "package-comments",
                "range",
                "range-val-address",
                "range-val-in-closure",
                "receiver-naming",
                "redefines-builtin-id",
                "redundant-import-alias",
                "string-format",
                "string-of-int",
                "struct-tag",
                "superfluous-else",
                "time-equal",
                "time-naming",
                "unchecked-type-assertion",
                "unconditional-recursion",
                "unexported-naming",
                "unexported-return",
                "unhandled-error",
                "unnecessary-stmt",
                "unreachable-code",
                "unused-parameter",
                "unused-receiver",
                "use-any",
                "useless-break",
                "var-declaration",
                "var-naming",
                "waitgroup-by-value"
              ]),
    }
    in
  {
      issues
        | {
          exclude
            | Array (String)
            | doc m%"
              List of regular expressions of issue texts to exclude.
              But independently from this option we use default exclude patterns. Their usage can be controlled through `exclude-use-default`.
            "%
            | optional,
          exclude-case-sensitive
            | Bool
            | doc "If set to true, exclude and exclude-rules regular expressions become case sensitive."
            | optional,
          exclude-dirs
            | Array (String)
            | doc "Which directories to exclude: issues from them won't be reported."
            | optional,
          exclude-dirs-use-default
            | Bool
            | doc "Enable exclusion of directories \"vendor\", \"third_party\", \"testdata\", \"examples\", \"Godeps\", and \"builtin\"."
            | optional,
          exclude-files
            | Array (String)
            | doc "Which files to exclude: they will be analyzed, but issues from them will not be reported."
            | optional,
          exclude-generated
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "lax", "strict", "disable" ])
            | doc "Mode of the generated files analysis."
            | optional,
          exclude-rules
            | Array
              {
                linters
                  | Array
                    _js2n__-refsenv."_js2n__-:definitions/linters!contract"
                  | optional,
                path | String | optional,
                path-except | String | optional,
                source | String | optional,
                text | String | optional,
              }
            | doc "Exclude configuration per-path, per-linter, per-text and per-source"
            | optional,
          exclude-use-default
            | Bool
            | doc "Independently from option `exclude` we use default exclude patterns. This behavior can be disabled by this option."
            | optional,
          fix
            | Bool
            | doc "Fix found issues (if it's supported by the linter)."
            | optional,
          include
            | Array (String)
            | doc "The list of ids of default excludes to include or disable."
            | optional,
          max-issues-per-linter
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Maximum issues count per one linter. Set to 0 to disable."
            | optional,
          max-same-issues
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Maximum count of issues with the same text. Set to 0 to disable."
            | optional,
          new
            | Bool
            | doc "Show only new issues: if there are unstaged changes or untracked files, only those changes are analyzed, else only changes in HEAD~ are analyzed."
            | optional,
          new-from-patch
            | String
            | doc "Show only new issues created in git patch with this file path."
            | optional,
          new-from-rev
            | String
            | doc "Show only new issues created after this git revision."
            | optional,
          whole-files
            | Bool
            | doc "Show issues in any part of update files (requires new-from-rev or new-from-patch)."
            | optional,
        }
        | optional,
      linters
        | {
          disable
            | Array _js2n__-refsenv."_js2n__-:definitions/linters!contract"
            | doc "List of disabled linters."
            | optional,
          disable-all
            | Bool
            | doc "Whether to disable all linters. You can re-enable them with `enable` explicitly."
            | optional,
          enable
            | Array _js2n__-refsenv."_js2n__-:definitions/linters!contract"
            | doc "List of enabled linters."
            | optional,
          enable-all
            | Bool
            | doc "Whether to enable all linters. You can re-disable them with `disable` explicitly."
            | optional,
          fast | Bool | doc "Enable run of fast linters." | optional,
          presets
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum
                  [
                    "bugs",
                    "comment",
                    "complexity",
                    "error",
                    "format",
                    "import",
                    "metalinter",
                    "module",
                    "performance",
                    "sql",
                    "style",
                    "test",
                    "unused"
                  ])
            )
            | doc "Allow to use different presets of linters"
            | optional,
        }
        | optional,
      linters-settings
        | {
          asasalint
            | {
              exclude
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "To specify a set of function names to exclude."
                | optional,
              ignore-test | Bool | doc "Ignore *_test.go files." | optional,
              use-builtin-exclusions
                | Bool
                | doc "To enable/disable the asasalint builtin exclusions of function names."
                | optional,
            }
            | optional,
          bidichk
            | {
              first-strong-isolate
                | Bool
                | doc "Disallow: FIRST-STRONG-ISOLATE"
                | optional,
              left-to-right-embedding
                | Bool
                | doc "Disallow: LEFT-TO-RIGHT-EMBEDDING"
                | optional,
              left-to-right-isolate
                | Bool
                | doc "Disallow: LEFT-TO-RIGHT-ISOLATE"
                | optional,
              left-to-right-override
                | Bool
                | doc "Disallow: LEFT-TO-RIGHT-OVERRIDE"
                | optional,
              pop-directional-formatting
                | Bool
                | doc "Disallow: POP-DIRECTIONAL-FORMATTING"
                | optional,
              pop-directional-isolate
                | Bool
                | doc "Disallow: POP-DIRECTIONAL-ISOLATE"
                | optional,
              right-to-left-embedding
                | Bool
                | doc "Disallow: RIGHT-TO-LEFT-EMBEDDING"
                | optional,
              right-to-left-isolate
                | Bool
                | doc "Disallow: RIGHT-TO-LEFT-ISOLATE"
                | optional,
              right-to-left-override
                | Bool
                | doc "Disallow: RIGHT-TO-LEFT-OVERRIDE"
                | optional,
            }
            | optional,
          copyloopvar | { check-alias | Bool | optional, } | optional,
          custom
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "^.*$" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.records.record
                                    {
                                      type = _js2n__-prdslib.enum [ "module" ],
                                    } {} true _js2n__-prdslib.always,
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "path" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.records.record
                                {
                                  description =
                                    _js2n__-prdslib.isType '"String",
                                  original-url =
                                    _js2n__-prdslib.isType '"String",
                                  path = _js2n__-prdslib.isType '"String",
                                  settings = _js2n__-prdslib.isType 'Record,
                                  type =
                                    _js2n__-prdslib.enum
                                        [ "module", "goplugin" ],
                                } {} false _js2n__-prdslib.never
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc m%"
              The custom section can be used to define linter plugins to be loaded at runtime. See README of golangci-lint for more information.
              Each custom linter should have a unique name.
            "%
            | optional,
          cyclop
            | {
              max-complexity
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Max complexity the function can have"
                | optional,
              package-average
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Max average complexity in package"
                | optional,
              skip-tests
                | Bool
                | doc "Should the linter execute on test files as well"
                | optional,
            }
            | optional,
          decorder
            | {
              dec-order
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum [ "type", "const", "var", "func" ])
                )
                | optional,
              disable-const-dec-num-check
                | Bool
                | doc "Const declarations will be ignored for dec num check"
                | optional,
              disable-dec-num-check
                | Bool
                | doc "Multiple global type, const and var declarations are allowed"
                | optional,
              disable-dec-order-check
                | Bool
                | doc "Order of declarations is not checked"
                | optional,
              disable-init-func-first-check
                | Bool
                | doc "Allow init func to be anywhere in file"
                | optional,
              disable-type-dec-num-check
                | Bool
                | doc "Type declarations will be ignored for dec num check"
                | optional,
              disable-var-dec-num-check
                | Bool
                | doc "Var declarations will be ignored for dec num check"
                | optional,
              ignore-underscore-vars
                | Bool
                | doc "Underscore vars (vars with \"_\" as the name) will be ignored at all checks"
                | optional,
            }
            | optional,
          depguard
            | {
              rules
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[^.]+$" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      allow =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ],
                                      deny =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        desc =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        pkg =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ])
                                            ],
                                      files =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.records.record {}
                                                {} false _js2n__-prdslib.never
                                            ],
                                      list-mode =
                                        _js2n__-prdslib.enum
                                            [ "original", "strict", "lax" ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } false _js2n__-prdslib.never
                    ])
                | doc "Rules to apply."
                | optional,
            }
            | optional,
          dogsled
            | {
              max-blank-identifiers
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Check assignments with too many blank identifiers."
                | optional,
            }
            | optional,
          dupl
            | {
              threshold
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Tokens count to trigger issue."
                | optional,
            }
            | optional,
          dupword
            | {
              ignore
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Keywords used to ignore detection."
                | optional,
              keywords
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Keywords for detecting duplicate words. If this list is not empty, only the words defined in this list will be detected."
                | optional,
            }
            | optional,
          errcheck
            | {
              check-blank
                | Bool
                | doc "Report about assignment of errors to blank identifier"
                | optional,
              check-type-assertions
                | Bool
                | doc "Report about not checking errors in type assertions, i.e.: `a := b.(MyStruct)`"
                | optional,
              disable-default-exclusions
                | Bool
                | doc "To disable the errcheck built-in exclude list"
                | optional,
              exclude-functions
                | Array (String)
                | doc "List of functions to exclude from checking, where each entry is a single function to exclude"
                | optional,
            }
            | optional,
          errchkjson
            | {
              check-error-free-encoding | Bool | optional,
              report-no-exported
                | Bool
                | doc "Issue on struct that doesn't have exported fields."
                | optional,
            }
            | optional,
          errorlint
            | {
              allowed-errors
                | Array { err | String | optional, "fun" | String | optional, }
                | optional,
              allowed-errors-wildcard
                | Array { err | String | optional, "fun" | String | optional, }
                | optional,
              asserts
                | Bool
                | doc "Check for plain type assertions and type switches."
                | optional,
              comparison
                | Bool
                | doc "Check for plain error comparisons"
                | optional,
              errorf
                | Bool
                | doc "Check whether fmt.Errorf uses the %w verb for formatting errors"
                | optional,
              errorf-multi
                | Bool
                | doc "Permit more than 1 %w verb, valid per Go 1.20"
                | optional,
            }
            | optional,
          exhaustive
            | {
              check
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "Program elements to check for exhaustiveness."
                | optional,
              check-generated
                | Bool
                | doc "Check switch statements in generated files"
                | optional,
              default-case-required
                | Bool
                | doc "Switch statement requires default case even if exhaustive."
                | optional,
              default-signifies-exhaustive
                | Bool
                | doc "Presence of `default` case in switch statements satisfies exhaustiveness, even if all enum members are not listed."
                | optional,
              explicit-exhaustive-map
                | Bool
                | doc "Only run exhaustive check on map literals with \"//exhaustive:enforce\" comment."
                | optional,
              explicit-exhaustive-switch
                | Bool
                | doc "Only run exhaustive check on switches with \"//exhaustive:enforce\" comment."
                | optional,
              ignore-enum-members
                | String
                | doc "Enum members matching `regex` do not have to be listed in switch statements to satisfy exhaustiveness"
                | optional,
              ignore-enum-types
                | String
                | doc "Enum types matching the supplied regex do not have to be listed in switch statements to satisfy exhaustiveness."
                | optional,
              package-scope-only
                | Bool
                | doc "Consider enums only in package scopes, not in inner scopes."
                | optional,
            }
            | optional,
          exhaustruct
            | {
              exclude
                | Array (String)
                | doc "List of regular expressions to exclude struct packages and names from check."
                | optional,
              include
                | Array (String)
                | doc "List of regular expressions to match struct packages and names."
                | optional,
            }
            | optional,
          forbidigo
            | {
              analyze-types
                | Bool
                | doc "Instead of matching the literal source code, use type information to replace expressions with strings that contain the package name and (for methods and fields) the type name."
                | optional,
              exclude-godoc-examples
                | Bool
                | doc "Exclude code in godoc examples."
                | optional,
              forbid
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                msg = _js2n__-prdslib.isType '"String",
                                p = _js2n__-prdslib.isType '"String",
                                pkg = _js2n__-prdslib.isType '"String",
                              } {} false _js2n__-prdslib.never
                          ]
                      ])
                )
                | doc "List of identifiers to forbid (written using `regexp`)"
                | optional,
            }
            | optional,
          funlen
            | {
              ignore-comments
                | Bool
                | doc "Ignore comments when counting lines."
                | optional,
              lines
                | std.number.Integer
                | doc "Limit lines number per function."
                | optional,
              statements
                | std.number.Integer
                | doc "Limit statements number per function."
                | optional,
            }
            | optional,
          gci
            | {
              custom-order
                | Bool
                | doc "Enable custom order of sections."
                | optional,
              sections
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.enum
                          [
                            "standard",
                            "default",
                            "blank",
                            "dot",
                            "alias",
                            "localmodule"
                          ],
                        _js2n__-prdslib.isType '"String"
                      ])
                )
                | doc "Section configuration to compare against."
                | optional,
              skip-generated | Bool | doc "Skip generated files." | optional,
            }
            | optional,
          ginkgolinter
            | {
              allow-havelen-zero
                | Bool
                | doc "Don't trigger warnings for HaveLen(0)."
                | optional,
              forbid-focus-container
                | Bool
                | doc "Trigger warning for ginkgo focus containers like FDescribe, FContext, FWhen or FIt."
                | optional,
              forbid-spec-pollution
                | Bool
                | doc "Trigger a warning for variable assignments in ginkgo containers like `Describe`, `Context` and `When`, instead of in `BeforeEach()`."
                | optional,
              force-expect-to
                | Bool
                | doc "Force using `Expect` with `To`, `ToNot` or `NotTo`"
                | optional,
              suppress-async-assertion
                | Bool
                | doc "Suppress the function all in async assertion warning."
                | optional,
              suppress-compare-assertion
                | Bool
                | doc "Suppress the wrong comparison assertion warning."
                | optional,
              suppress-err-assertion
                | Bool
                | doc "Suppress the wrong error assertion warning."
                | optional,
              suppress-len-assertion
                | Bool
                | doc "Suppress the wrong length assertion warning."
                | optional,
              suppress-nil-assertion
                | Bool
                | doc "Suppress the wrong nil assertion warning."
                | optional,
              suppress-type-compare-assertion
                | Bool
                | doc "Suppress warning for comparing values from different types, like int32 and uint32."
                | optional,
              validate-async-intervals
                | Bool
                | doc "Best effort validation of async intervals (timeout and polling)."
                | optional,
            }
            | optional,
          gocognit
            | {
              min-complexity
                | std.number.Integer
                | doc "Minimal code complexity to report (we recommend 10-20)."
                | optional,
            }
            | optional,
          goconst
            | {
              ignore-calls
                | Bool
                | doc "Ignore when constant is not used as function argument"
                | optional,
              ignore-strings
                | String
                | doc "Exclude strings matching the given regular expression"
                | optional,
              ignore-tests | Bool | doc "Ignore test files." | optional,
              match-constant
                | Bool
                | doc "Look for existing constants matching the values"
                | optional,
              max
                | std.number.Integer
                | doc "Maximum value, only works with `numbers`"
                | optional,
              min
                | std.number.Integer
                | doc "Minimum value, only works with `numbers`"
                | optional,
              min-len
                | std.number.Integer
                | doc "Minimum length of string constant."
                | optional,
              min-occurrences
                | std.number.Integer
                | doc "Minimum occurrences count to trigger."
                | optional,
              numbers
                | Bool
                | doc "Search also for duplicated numbers."
                | optional,
            }
            | optional,
          gocritic
            | {
              disable-all | Bool | optional,
              disabled-checks
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/gocritic-checks!contract"
                | doc "Which checks should be disabled."
                | optional,
              disabled-tags
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/gocritic-tags!contract"
                | doc "Disable multiple checks by tags, run `GL_DEBUG=gocritic golangci-lint run` to see all tags and checks."
                | optional,
              enable-all | Bool | optional,
              enabled-checks
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/gocritic-checks!contract"
                | doc "Which checks should be enabled. By default, a list of stable checks is used. To see it, run `GL_DEBUG=gocritic golangci-lint run`."
                | optional,
              enabled-tags
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/gocritic-tags!contract"
                | doc "Enable multiple checks by tags, run `GL_DEBUG=gocritic golangci-lint run` to see all tags and checks."
                | optional,
              settings
                | {
                  captLocal | { paramsOnly | Bool | optional, } | optional,
                  commentedOutCode
                    | { minLength | Number | optional, }
                    | optional,
                  elseif | { skipBalanced | Bool | optional, } | optional,
                  hugeParam | { sizeThreshold | Number | optional, } | optional,
                  ifElseChain
                    | { minThreshold | Number | optional, }
                    | optional,
                  nestingReduce | { bodyWidth | Number | optional, } | optional,
                  rangeExprCopy
                    | {
                      sizeThreshold | Number | optional,
                      skipTestFuncs | Bool | optional,
                    }
                    | optional,
                  rangeValCopy
                    | {
                      sizeThreshold | Number | optional,
                      skipTestFuncs | Bool | optional,
                    }
                    | optional,
                  ruleguard
                    | {
                      debug | String | optional,
                      disable | String | optional,
                      enable | String | optional,
                      failOn | String | optional,
                      rules | String | optional,
                    }
                    | optional,
                  tooManyResultsChecker
                    | { maxResults | Number | optional, }
                    | optional,
                  truncateCmp
                    | { skipArchDependent | Bool | optional, }
                    | optional,
                  underef | { skipRecvDeref | Bool | optional, } | optional,
                  unnamedResult
                    | { checkExported | Bool | optional, }
                    | optional,
                }
                | doc "Settings passed to gocritic. Properties must be valid and enabled check names."
                | optional,
            }
            | optional,
          gocyclo
            | {
              min-complexity
                | std.number.Integer
                | doc "Minimum code complexity to report (we recommend 10-20)."
                | optional,
            }
            | optional,
          godot
            | {
              capital
                | Bool
                | doc "Check that each sentence starts with a capital letter."
                | optional,
              check-all
                | Bool
                | doc "DEPRECATED: Check all top-level comments, not only declarations."
                | optional,
              exclude
                | Array (String)
                | doc "List of regexps for excluding particular comment lines from check."
                | optional,
              period
                | Bool
                | doc "Check that each sentence ends with a period."
                | optional,
              scope
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "declarations", "toplevel", "all" ])
                | doc "Comments to be checked."
                | optional,
            }
            | optional,
          godox
            | {
              keywords
                | Array (String)
                | doc "Report any comments starting with one of these keywords. This is useful for TODO or FIXME comments that might be left in the code accidentally and should be resolved before merging."
                | optional,
            }
            | optional,
          gofmt
            | {
              rewrite-rules
                | Array
                  {
                    pattern | String | optional,
                    replacement | String | optional,
                  }
                | doc "Apply the rewrite rules to the source before reformatting."
                | optional,
              simplify | Bool | doc "Simplify code." | optional,
            }
            | optional,
          gofumpt
            | {
              extra-rules
                | Bool
                | doc "Choose whether or not to use the extra rules that are disabled by default."
                | optional,
              module-path
                | String
                | doc " Module path which contains the source code being formatted."
                | optional,
            }
            | optional,
          goheader
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "template" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "template-path" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.records.record
                    {
                      template = _js2n__-prdslib.isType '"String",
                      template-path = _js2n__-prdslib.isType '"String",
                      values =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  const =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^.+$" =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } false _js2n__-prdslib.never
                                        ],
                                  regexp =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^.+$" =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } false _js2n__-prdslib.never
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                    } {} false _js2n__-prdslib.never
                ])
            | optional,
          goimports
            | {
              local-prefixes
                | String
                | doc "Put imports beginning with prefix after 3rd-party packages. It is a comma-separated list of prefixes."
                | optional,
            }
            | optional,
          gomoddirectives
            | {
              exclude-forbidden
                | Bool
                | doc "Forbid the use of the `exclude` directives."
                | optional,
              replace-allow-list
                | Array (String)
                | doc "List of allowed `replace` directives."
                | optional,
              replace-local
                | Bool
                | doc "Allow local `replace` directives."
                | optional,
              retract-allow-no-explanation
                | Bool
                | doc "Allow to not explain why the version has been retracted in the `retract` directives."
                | optional,
            }
            | optional,
          gomodguard
            | {
              allowed
                | {
                  domains
                    | Array (String)
                    | doc "List of allowed module domains."
                    | optional,
                  modules
                    | Array (String)
                    | doc "List of allowed modules."
                    | optional,
                }
                | optional,
              blocked
                | {
                  local_replace_directives
                    | Bool
                    | doc "Raise lint issues if loading local path with replace directive"
                    | optional,
                  modules
                    | Array (
                      _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record {}
                              {
                                "^.+$" =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            reason =
                                              _js2n__-prdslib.isType '"String",
                                            recommendations =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } false _js2n__-prdslib.never
                          ])
                    )
                    | doc "List of blocked modules."
                    | optional,
                  versions
                    | Array (
                      _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record {}
                              {
                                "^.*$" =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "reason" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            reason =
                                              _js2n__-prdslib.isType '"String",
                                            version =
                                              _js2n__-prdslib.isType '"String",
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } true _js2n__-prdslib.always
                          ])
                    )
                    | doc "List of blocked module version constraints."
                    | optional,
                }
                | optional,
            }
            | optional,
          gosec
            | {
              concurrency
                | std.number.Integer
                | doc "Concurrency value"
                | optional,
              confidence
                | std.enum.TagOrString
                | [| 'high, 'medium, 'low |]
                | doc "Filter out the issues with a lower confidence than the given value"
                | optional,
              config
                | {  .. }
                | doc "To specify the configuration of rules"
                | optional,
              exclude-generated
                | Bool
                | doc "Exclude generated files"
                | optional,
              excludes
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/gosec-rules!contract"
                | doc "To specify a set of rules to explicitly exclude"
                | optional,
              includes
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/gosec-rules!contract"
                | doc "To select a subset of rules to run"
                | optional,
              severity
                | std.enum.TagOrString
                | [| 'high, 'medium, 'low |]
                | doc "Filter out the issues with a lower severity than the given value"
                | optional,
            }
            | optional,
          gosimple
            | {
              checks
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.enum [ "all" ],
                        _js2n__-prdslib.isType '"String"
                      ])
                )
                | optional,
            }
            | optional,
          gosmopolitan
            | {
              allow-time-local
                | Bool
                | doc "Allow and ignore `time.Local` usages."
                | optional,
              escape-hatches
                | Array (String)
                | doc "List of fully qualified names in the `full/pkg/path.name` form, to act as \"i18n escape hatches\"."
                | optional,
              ignore-tests | Bool | doc "Ignore test files." | optional,
              watch-for-scripts
                | Array (String)
                | doc "List of Unicode scripts to watch for any usage in string literals."
                | optional,
            }
            | optional,
          govet
            | {
              disable
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/govet-analyzers!contract"
                | doc "Disable analyzers by name."
                | optional,
              disable-all | Bool | doc "Disable all analyzers." | optional,
              enable
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/govet-analyzers!contract"
                | doc "Enable analyzers by name."
                | optional,
              enable-all | Bool | doc "Enable all analyzers." | optional,
              settings
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.propertyNames
                        _js2n__-refsenv."_js2n__-:definitions/govet-analyzers!predicate",
                      _js2n__-prdslib.records.record {}
                        { "^.*$" = _js2n__-prdslib.isType 'Record, } true
                        _js2n__-prdslib.always
                    ])
                | doc m%"
                  Settings per analyzer. Map of analyzer name to specific settings.
                  Run `go tool vet help` to find out more.
                "%
                | optional,
            }
            | optional,
          grouper
            | {
              const-require-grouping | Bool | optional,
              const-require-single-const | Bool | optional,
              import-require-grouping | Bool | optional,
              import-require-single-import | Bool | optional,
              type-require-grouping | Bool | optional,
              type-require-single-type | Bool | optional,
              var-require-grouping | Bool | optional,
              var-require-single-var | Bool | optional,
            }
            | optional,
          importas
            | {
              alias
                | Array
                  {
                    alias
                      | String
                      | doc "Package alias e.g. autoscalingv1alpha1",
                    pkg
                      | String
                      | doc "Package path e.g. knative.dev/serving/pkg/apis/autoscaling/v1alpha1",
                  }
                | doc "List of aliases"
                | optional,
              no-extra-aliases
                | Bool
                | doc "Do not allow non-required aliases."
                | optional,
              no-unaliased
                | Bool
                | doc "Do not allow unaliased imports of aliased packages."
                | optional,
            }
            | optional,
          inamedparam
            | {
              skip-single-param
                | Bool
                | doc "Skips check for interface methods with only a single parameter."
                | optional,
            }
            | optional,
          interfacebloat
            | {
              max
                | std.number.Integer
                | doc "The maximum number of methods allowed for an interface."
                | optional,
            }
            | optional,
          ireturn
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.records.record
                              { allow = _js2n__-prdslib.const "reject", } {}
                              true _js2n__-prdslib.always),
                          _js2n__-prdslib.records.required [ "allow" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "reject" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.records.record
                    {
                      allow =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "anon", "error", "empty", "stdlib" ]
                                  ])
                            ],
                      reject =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "anon", "error", "empty", "stdlib" ]
                                  ])
                            ],
                    } {} false _js2n__-prdslib.never
                ])
            | doc "Use either `reject` or `allow` properties for interfaces matching."
            | optional,
          lll
            | {
              line-length
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 1
                    ])
                | doc "Maximum allowed line length, lines longer will be reported."
                | optional,
              tab-width
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Width of \"\\t\" in spaces."
                | optional,
            }
            | optional,
          loggercheck
            | {
              kitlog
                | Bool
                | doc "Allow check for the github.com/go-kit/log library."
                | optional,
              klog
                | Bool
                | doc "Allow check for the k8s.io/klog/v2 library."
                | optional,
              logr
                | Bool
                | doc "Allow check for the github.com/go-logr/logr library."
                | optional,
              no-printf-like
                | Bool
                | doc "Require printf-like format specifier (%s, %d for example) not present."
                | optional,
              require-string-key
                | Bool
                | doc "Require all logging keys to be inlined constant strings."
                | optional,
              rules
                | Array (String)
                | doc "List of custom rules to check against, where each rule is a single logger pattern, useful for wrapped loggers."
                | optional,
              zap
                | Bool
                | doc "Allow check for the \"sugar logger\" from go.uber.org/zap library."
                | optional,
            }
            | optional,
          maintidx
            | {
              under
                | Number
                | doc "Minimum accatpable maintainability index level (see https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022)"
                | optional,
            }
            | doc "Maintainability index https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022"
            | optional,
          makezero
            | {
              always
                | Bool
                | doc "Allow only slices initialized with a length of zero."
                | optional,
            }
            | optional,
          misspell
            | {
              extra-words
                | Array
                  { correction | String | optional, typo | String | optional, }
                | doc "Extra word corrections."
                | optional,
              ignore-words
                | Array (String)
                | doc "List of words to ignore."
                | optional,
              locale
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "US", "UK" ])
                | optional,
              mode
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "restricted", "", "default" ])
                | doc "Mode of the analysis."
                | optional,
            }
            | doc "Correct spellings using locale preferences for US or UK. Default is to use a neutral variety of English."
            | optional,
          mnd
            | {
              checks
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "argument",
                        "case",
                        "condition",
                        "operation",
                        "return",
                        "assign"
                      ])
                )
                | doc "The list of enabled checks, see https://github.com/tommy-muehle/go-mnd/#checks for description."
                | optional,
              ignored-files
                | Array (String)
                | doc "List of file patterns to exclude from analysis."
                | optional,
              ignored-functions
                | Array (String)
                | doc "Comma-separated list of function patterns to exclude from the analysis."
                | optional,
              ignored-numbers
                | Array (String)
                | doc "List of numbers to exclude from analysis."
                | optional,
            }
            | optional,
          musttag
            | {
              functions
                | Array
                  {
                    arg-pos | std.number.Integer | optional,
                    name | String | optional,
                    tag | String | optional,
                  }
                | optional,
            }
            | optional,
          nakedret
            | {
              max-func-lines
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Report if a function has more lines of code than this value and it has naked returns."
                | optional,
            }
            | optional,
          nestif
            | {
              min-complexity
                | std.number.Integer
                | doc "Minimum complexity of \"if\" statements to report."
                | optional,
            }
            | optional,
          nilnil
            | {
              checked-types
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "ptr",
                        "func",
                        "iface",
                        "map",
                        "chan",
                        "uintptr",
                        "unsafeptr"
                      ])
                )
                | doc "List of return types to check."
                | optional,
            }
            | optional,
          nlreturn
            | {
              block-size
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "set block size that is still ok"
                | optional,
            }
            | optional,
          nolintlint
            | {
              allow-no-explanation
                | Array _js2n__-refsenv."_js2n__-:definitions/linters!contract"
                | doc "Exclude these linters from requiring an explanation."
                | optional,
              allow-unused
                | Bool
                | doc "Enable to ensure that nolint directives are all used."
                | optional,
              require-explanation
                | Bool
                | doc "Enable to require an explanation of nonzero length after each nolint directive."
                | optional,
              require-specific
                | Bool
                | doc "Enable to require nolint directives to mention the specific linter being suppressed."
                | optional,
            }
            | optional,
          nonamedreturns
            | {
              report-error-in-defer
                | Bool
                | doc "Report named error if it is assigned inside defer."
                | optional,
            }
            | optional,
          paralleltest
            | {
              ignore-missing
                | Bool
                | doc "Ignore missing calls to `t.Parallel()` and only report incorrect uses of it."
                | optional,
              ignore-missing-subtests
                | Bool
                | doc "Ignore missing calls to `t.Parallel()` in subtests. Top-level tests are still required to have `t.Parallel`, but subtests are allowed to skip it."
                | optional,
            }
            | optional,
          perfsprint
            | {
              err-error
                | Bool
                | doc "Optimizes into `err.Error()` even if it is only equivalent for non-nil errors."
                | optional,
              errorf | Bool | doc "Optimizes `fmt.Errorf`." | optional,
              int-conversion
                | Bool
                | doc "Optimizes even if it requires an int or uint type cast."
                | optional,
              sprintf1
                | Bool
                | doc "Optimizes `fmt.Sprintf` with only one argument."
                | optional,
              strconcat
                | Bool
                | doc "Optimizes into strings concatenation."
                | optional,
            }
            | optional,
          prealloc
            | {
              for-loops
                | Bool
                | doc "Report preallocation suggestions on for loops."
                | optional,
              range-loops
                | Bool
                | doc "Report preallocation suggestions on range loops."
                | optional,
              simple
                | Bool
                | doc "Report preallocation suggestions only on simple loops that have no returns/breaks/continues/gotos in them."
                | optional,
            }
            | doc m%"
              We do not recommend using this linter before doing performance profiling.
              For most programs usage of `prealloc` will be premature optimization.
            "%
            | optional,
          predeclared
            | {
              ignore
                | String
                | doc "Comma-separated list of predeclared identifiers to not report on."
                | optional,
              q
                | Bool
                | doc "Include method names and field names (i.e., qualified names) in checks."
                | optional,
            }
            | optional,
          promlinter
            | {
              disabled-linters
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "Help",
                        "MetricUnits",
                        "Counter",
                        "HistogramSummaryReserved",
                        "MetricTypeInName",
                        "ReservedChars",
                        "CamelCase",
                        "UnitAbbreviations"
                      ])
                )
                | optional,
              strict
                | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
                | optional,
            }
            | optional,
          protogetter
            | {
              replace-first-arg-in-append
                | Bool
                | doc "Skip first argument of append function."
                | optional,
              skip-any-generated
                | Bool
                | doc "Skip any generated files from the checking."
                | optional,
              skip-files | Array (String) | optional,
              skip-generated-by | Array (String) | optional,
            }
            | optional,
          reassign | { patterns | Array (String) | optional, } | optional,
          revive
            | {
              confidence | Number | optional,
              enable-all-rules | Bool | optional,
              ignore-generated-header | Bool | optional,
              max-open-files | std.number.Integer | optional,
              rules
                | Array
                  {
                    arguments | Array Dyn | optional,
                    disabled | Bool | optional,
                    exclude | Array (String) | optional,
                    name
                      | _js2n__-refsenv."_js2n__-:definitions/revive-rules!contract",
                    severity
                      | std.enum.TagOrString
                      | [| 'error, 'warning |]
                      | optional,
                  }
                | optional,
              severity
                | std.enum.TagOrString
                | [| 'error, 'warning |]
                | optional,
            }
            | optional,
          rowserrcheck | { packages | Array (String) | optional, } | optional,
          sloglint
            | {
              args-on-sep-lines
                | Bool
                | doc "Enforce putting arguments on separate lines."
                | optional,
              attr-only
                | Bool
                | doc "Enforce using attributes only (incompatible with kv-only)."
                | optional,
              context
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "", "all", "scope" ])
                | doc "Enforce using methods that accept a context."
                | optional,
              forbidden-keys
                | Array (String)
                | doc "Enforce not using specific keys."
                | optional,
              key-naming-case
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "snake", "kebab", "camel", "pascal" ])
                | doc "Enforce a single key naming convention."
                | optional,
              kv-only
                | Bool
                | doc "Enforce using key-value pairs only (incompatible with attr-only)."
                | optional,
              no-global
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "", "all", "default" ])
                | doc "Enforce not using global loggers."
                | optional,
              no-mixed-args
                | Bool
                | doc "Enforce not mixing key-value pairs and attributes."
                | optional,
              no-raw-keys
                | Bool
                | doc "Enforce using constants instead of raw keys."
                | optional,
              static-msg
                | Bool
                | doc "Enforce using static values for log messages."
                | optional,
            }
            | optional,
          spancheck
            | {
              checks
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [ "end", "record-error", "set-status" ])
                )
                | doc "Checks to enable."
                | optional,
              extra-start-span-signatures
                | Array (String)
                | doc "A list of regexes for additional function signatures that create spans."
                | optional,
              ignore-check-signatures
                | Array (String)
                | doc "A list of regexes for function signatures that silence `record-error` and `set-status` reports if found in the call path to a returned error."
                | optional,
            }
            | optional,
          staticcheck
            | {
              checks
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.enum [ "all" ],
                        _js2n__-prdslib.isType '"String"
                      ])
                )
                | optional,
            }
            | optional,
          stylecheck
            | {
              checks
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.enum [ "all" ],
                        _js2n__-prdslib.isType '"String"
                      ])
                )
                | optional,
              dot-import-whitelist
                | Array (String)
                | doc "By default, ST1001 forbids all uses of dot imports in non-test packages. This setting allows setting a whitelist of import paths that can be dot-imported anywhere."
                | optional,
              http-status-code-whitelist
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "100",
                        "101",
                        "102",
                        "103",
                        "200",
                        "201",
                        "202",
                        "203",
                        "204",
                        "205",
                        "206",
                        "207",
                        "208",
                        "226",
                        "300",
                        "301",
                        "302",
                        "303",
                        "304",
                        "305",
                        "306",
                        "307",
                        "308",
                        "400",
                        "401",
                        "402",
                        "403",
                        "404",
                        "405",
                        "406",
                        "407",
                        "408",
                        "409",
                        "410",
                        "411",
                        "412",
                        "413",
                        "414",
                        "415",
                        "416",
                        "417",
                        "418",
                        "421",
                        "422",
                        "423",
                        "424",
                        "425",
                        "426",
                        "428",
                        "429",
                        "431",
                        "451",
                        "500",
                        "501",
                        "502",
                        "503",
                        "504",
                        "505",
                        "506",
                        "507",
                        "508",
                        "510",
                        "511"
                      ])
                )
                | doc "ST1013 recommends using constants from the net/http package instead of hard-coding numeric HTTP status codes. This setting specifies a list of numeric status codes that this check does not complain about."
                | optional,
              initialisms
                | Array (String)
                | doc "ST1003 check, among other things, for the correct capitalization of initialisms. The set of known initialisms can be configured with this option."
                | optional,
            }
            | optional,
          tagalign
            | {
              align
                | Bool
                | doc "Align and sort can be used together or separately."
                | optional,
              order
                | Array (String)
                | doc "Specify the order of tags, the other tags will be sorted by name."
                | optional,
              sort | Bool | doc "Whether enable tags sort." | optional,
              strict | Bool | doc "Whether enable strict style." | optional,
            }
            | optional,
          tagliatelle
            | {
              case
                | {
                  rules
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^.+$" =
                                _js2n__-prdslib.enum
                                    [
                                      "camel",
                                      "pascal",
                                      "kebab",
                                      "snake",
                                      "goCamel",
                                      "goPascal",
                                      "goKebab",
                                      "goSnake",
                                      "upper",
                                      "upperSnake",
                                      "lower",
                                      "header"
                                    ],
                            } true _js2n__-prdslib.always
                        ])
                    | optional,
                  use-field-name
                    | Bool
                    | doc "Use the struct field name to check the name of the struct tag."
                    | optional,
                }
                | optional,
            }
            | optional,
          tenv
            | {
              all
                | Bool
                | doc "The option `all` will run against whole test files (`_test.go`) regardless of method/function signatures."
                | optional,
            }
            | optional,
          testifylint
            | {
              bool-compare
                | {
                  ignore-custom-types
                    | Bool
                    | doc "To ignore user defined types (over builtin bool)."
                    | optional,
                }
                | optional,
              disable
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "blank-import",
                        "bool-compare",
                        "compares",
                        "empty",
                        "error-is-as",
                        "error-nil",
                        "expected-actual",
                        "float-compare",
                        "formatter",
                        "go-require",
                        "len",
                        "negative-positive",
                        "nil-compare",
                        "require-error",
                        "suite-broken-parallel",
                        "suite-dont-use-pkg",
                        "suite-extra-assert-call",
                        "suite-subtest-run",
                        "suite-thelper",
                        "useless-assert"
                      ])
                )
                | doc "Disable specific checkers."
                | optional,
              disable-all | Bool | doc "Disable all checkers." | optional,
              enable
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "blank-import",
                        "bool-compare",
                        "compares",
                        "empty",
                        "error-is-as",
                        "error-nil",
                        "expected-actual",
                        "float-compare",
                        "formatter",
                        "go-require",
                        "len",
                        "negative-positive",
                        "nil-compare",
                        "require-error",
                        "suite-broken-parallel",
                        "suite-dont-use-pkg",
                        "suite-extra-assert-call",
                        "suite-subtest-run",
                        "suite-thelper",
                        "useless-assert"
                      ])
                )
                | doc "Enable specific checkers."
                | optional,
              enable-all | Bool | doc "Enable all checkers." | optional,
              expected-actual
                | {
                  pattern
                    | String
                    | doc "Regexp for expected variable name."
                    | optional,
                }
                | optional,
              formatter
                | {
                  check-format-string
                    | Bool
                    | doc "To enable go vet's printf checks."
                    | optional,
                  require-f-funcs
                    | Bool
                    | doc "To require f-assertions if format string is used."
                    | optional,
                }
                | optional,
              go-require
                | {
                  ignore-http-handlers
                    | Bool
                    | doc "To ignore HTTP handlers (like http.HandlerFunc)."
                    | optional,
                }
                | optional,
              require-error
                | {
                  fn-pattern
                    | String
                    | doc "Regexp for assertions to analyze. If defined, then only matched error assertions will be reported."
                    | optional,
                }
                | optional,
              suite-extra-assert-call
                | {
                  mode
                    | std.enum.TagOrString
                    | [| 'require, 'remove |]
                    | doc "To require or remove extra Assert() call?"
                    | optional,
                }
                | optional,
            }
            | optional,
          testpackage
            | {
              allow-packages
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "List of packages that don't end with _test that tests are allowed to be in."
                | optional,
              skip-regexp
                | String
                | doc "Files with names matching this regular expression are skipped."
                | optional,
            }
            | optional,
          thelper
            | {
              benchmark
                | {
                  begin
                    | Bool
                    | doc "Check if `b.Helper()` begins helper function."
                    | optional,
                  first
                    | Bool
                    | doc "Check if *testing.B is first param of helper function."
                    | optional,
                  name
                    | Bool
                    | doc "Check if *testing.B param has b name."
                    | optional,
                }
                | optional,
              fuzz
                | {
                  begin
                    | Bool
                    | doc "Check if `f.Helper()` begins helper function."
                    | optional,
                  first
                    | Bool
                    | doc "Check if *testing.F is first param of helper function."
                    | optional,
                  name
                    | Bool
                    | doc "Check if *testing.F param has f name."
                    | optional,
                }
                | optional,
              tb
                | {
                  begin
                    | Bool
                    | doc "Check if `tb.Helper()` begins helper function."
                    | optional,
                  first
                    | Bool
                    | doc "Check if *testing.TB is first param of helper function."
                    | optional,
                  name
                    | Bool
                    | doc "Check if *testing.TB param has tb name."
                    | optional,
                }
                | optional,
              test
                | {
                  begin
                    | Bool
                    | doc "Check if `t.Helper()` begins helper function."
                    | optional,
                  first
                    | Bool
                    | doc "Check if *testing.T is first param of helper function."
                    | optional,
                  name
                    | Bool
                    | doc "Check if *testing.T param has t name."
                    | optional,
                }
                | optional,
            }
            | optional,
          unconvert
            | { fast-math | Bool | optional, safe | Bool | optional, }
            | optional,
          unparam
            | {
              check-exported
                | Bool
                | doc m%"
                  Inspect exported functions. Set to true if no external program/library imports your code.
                  
                  WARNING: if you enable this setting, unparam will report a lot of false-positives in text editors:
                  if it's called for subdir of a project it can't find external interfaces. All text editor integrations
                  with golangci-lint call it on a directory with the changed file.
                "%
                | optional,
            }
            | optional,
          unused
            | {
              exported-fields-are-used | Bool | doc "" | optional,
              field-writes-are-uses | Bool | doc "" | optional,
              generated-is-used | Bool | doc "" | optional,
              local-variables-are-used | Bool | doc "" | optional,
              parameters-are-used | Bool | doc "" | optional,
              post-statements-are-reads | Bool | doc "" | optional,
            }
            | optional,
          usestdlibvars
            | {
              constant-kind
                | Bool
                | doc "Suggest the use of constant.Kind.String()."
                | optional,
              crypto-hash
                | Bool
                | doc "Suggest the use of crypto.Hash.String()."
                | optional,
              default-rpc-path
                | Bool
                | doc "Suggest the use of rpc.DefaultXXPath."
                | optional,
              http-method
                | Bool
                | doc "Suggest the use of http.MethodXX."
                | optional,
              http-status-code
                | Bool
                | doc "Suggest the use of http.StatusXX."
                | optional,
              sql-isolation-level
                | Bool
                | doc "Suggest the use of sql.LevelXX.String()."
                | optional,
              time-layout
                | Bool
                | doc "Suggest the use of time.Layout."
                | optional,
              time-month
                | Bool
                | doc "Suggest the use of time.Month.String()."
                | optional,
              time-weekday
                | Bool
                | doc "Suggest the use of time.Weekday.String()."
                | optional,
              tls-signature-scheme
                | Bool
                | doc "Suggest the use of tls.SignatureScheme.String()."
                | optional,
            }
            | optional,
          varnamelen
            | {
              check-receiver
                | Bool
                | doc "Check method receiver names."
                | optional,
              check-return | Bool | doc "Check named return values." | optional,
              check-type-param | Bool | doc "Check type parameters." | optional,
              ignore-chan-recv-ok
                | Bool
                | doc "Ignore `ok` variables that hold the bool return value of a channel receive."
                | optional,
              ignore-decls
                | Array (String)
                | doc "Optional list of variable declarations that should be ignored completely."
                | optional,
              ignore-map-index-ok
                | Bool
                | doc "Ignore `ok` variables that hold the bool return value of a map index."
                | optional,
              ignore-names
                | Array (String)
                | doc "Optional list of variable names that should be ignored completely."
                | optional,
              ignore-type-assert-ok
                | Bool
                | doc "Ignore `ok` variables that hold the bool return value of a type assertion"
                | optional,
              max-distance
                | std.number.Integer
                | doc "Variables used in at most this N-many lines will be ignored."
                | optional,
              min-name-length
                | std.number.Integer
                | doc "The minimum length of a variable's name that is considered `long`."
                | optional,
            }
            | optional,
          whitespace
            | {
              multi-func
                | Bool
                | doc "Enforces newlines (or comments) after every multi-line function signature"
                | optional,
              multi-if
                | Bool
                | doc "Enforces newlines (or comments) after every multi-line if statement"
                | optional,
            }
            | optional,
          wrapcheck
            | {
              ignoreInterfaceRegexps
                | Array (String)
                | doc "An array of glob patterns which, if matched to an underlying interface name, will ignore unwrapped errors returned from a function whose call is defined on the given interface."
                | optional,
              ignorePackageGlobs
                | Array (String)
                | doc "An array of glob patterns which, if any match the package of the function returning the error, will skip wrapcheck analysis for this error."
                | optional,
              ignoreSigRegexps
                | Array (String)
                | doc "An array of strings which specify regular expressions of signatures to ignore."
                | optional,
              ignoreSigs
                | Array (String)
                | doc "An array of strings which specify substrings of signatures to ignore."
                | optional,
            }
            | optional,
          wsl
            | {
              allow-assign-and-anything
                | Bool
                | doc "Controls if you may cuddle assignments and anything without needing an empty line between them."
                | optional,
              allow-assign-and-call
                | Bool
                | doc "Allow calls and assignments to be cuddled as long as the lines have any matching variables, fields or types."
                | optional,
              allow-cuddle-declarations
                | Bool
                | doc "Allow declarations (var) to be cuddled."
                | optional,
              allow-cuddle-with-calls
                | Array (String)
                | doc "A list of call idents that everything can be cuddled with."
                | optional,
              allow-cuddle-with-rhs
                | Array (String)
                | doc "AllowCuddleWithRHS is a list of right hand side variables that is allowed to be cuddled with anything."
                | optional,
              allow-multiline-assign
                | Bool
                | doc "Allow multiline assignments to be cuddled."
                | optional,
              allow-separated-leading-comment
                | Bool
                | doc "Allow leading comments to be separated with empty lines."
                | optional,
              allow-trailing-comment
                | Bool
                | doc "Allow trailing comments in ending of blocks."
                | optional,
              error-variable-names
                | Array (String)
                | doc "When force-err-cuddling is enabled this is a list of names used for error variables to check for in the conditional."
                | optional,
              force-case-trailing-whitespace
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Force newlines in end of case at this limit (0 = never)."
                | optional,
              force-err-cuddling
                | Bool
                | doc "Causes an error when an If statement that checks an error variable doesn't cuddle with the assignment of that variable."
                | optional,
              force-short-decl-cuddling
                | Bool
                | doc "Causes an error if a short declaration (:=) cuddles with anything other than another short declaration."
                | optional,
              strict-append
                | Bool
                | doc "If true, append is only allowed to be cuddled if appending value is matching variables, fields or types on line above."
                | optional,
            }
            | optional,
        }
        | doc "All available settings of specific linters."
        | optional,
      output
        | {
          formats
            | Array
              {
                format
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "colored-line-number",
                        "line-number",
                        "json",
                        "colored-tab",
                        "tab",
                        "html",
                        "checkstyle",
                        "code-climate",
                        "junit-xml",
                        "github-actions",
                        "teamcity",
                        "sarif"
                      ]),
                path
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.enum [ "stdout", "stderr" ],
                        _js2n__-prdslib.isType '"String"
                      ])
                  | optional,
              }
            | doc "Output formats to use."
            | optional,
          path-prefix
            | String
            | doc "Add a prefix to the output file references."
            | optional,
          print-issued-lines
            | Bool
            | doc "Print lines of code with issue."
            | optional,
          print-linter-name
            | Bool
            | doc "Print linter name in the end of issue text."
            | optional,
          show-stats | Bool | doc "Show statistics per linter." | optional,
          sort-order
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum [ "linter", "severity", "file" ])
            )
            | optional,
          sort-results
            | Bool
            | doc "Sort results by: filepath, line and column."
            | optional,
          uniq-by-line
            | Bool
            | doc "Make issues output unique by line."
            | optional,
        }
        | doc "Output configuration options."
        | optional,
      run
        | {
          allow-parallel-runners
            | Bool
            | doc "Allow multiple parallel golangci-lint instances running. If disabled, golangci-lint acquires file lock on start."
            | optional,
          allow-serial-runners
            | Bool
            | doc "Allow multiple golangci-lint instances running, but serialize them around a lock."
            | optional,
          build-tags
            | Array (String)
            | doc "List of build tags to pass to all linters."
            | optional,
          concurrency
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "Number of concurrent runners. Defaults to the number of available CPU cores."
            | optional,
          go | String | doc "Targeted Go version." | optional,
          issues-exit-code
            | std.number.Integer
            | doc "Exit code when at least one issue was found."
            | optional,
          modules-download-mode
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "mod", "readonly", "vendor" ])
            | doc m%"
              Option to pass to "go list -mod={option}".
              See "go help modules" for more information.
            "%
            | optional,
          tests | Bool | doc "Enable inclusion of test files." | optional,
          timeout
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^\\d*[sm]$"
                ])
            | doc "Timeout for the analysis."
            | optional,
        }
        | doc "Options for analysis running,"
        | optional,
      severity
        | {
          case-sensitive
            | Bool
            | doc "If set to true, severity-rules regular expressions become case sensitive."
            | optional,
          default-severity
            | String
            | doc "Set the default severity for issues. If severity rules are defined and the issues do not match or no severity is provided to the rule this will be the default severity applied. Severities should match the supported severity names of the selected out format.",
          rules
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "path" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "path-except" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "linters" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "text" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "source" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.required [ "severity" ],
                    _js2n__-prdslib.records.record
                      {
                        linters =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/linters!predicate"
                              ],
                        path = _js2n__-prdslib.isType '"String",
                        path-except = _js2n__-prdslib.isType '"String",
                        severity = _js2n__-prdslib.isType '"String",
                        source = _js2n__-prdslib.isType '"String",
                        text = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            )
            | doc m%"
              When a list of severity rules are provided, severity information will be added to lint issues. Severity rules have the same filtering capability as exclude rules except you are allowed to specify one matcher per severity rule.
              Only affects out formats that support setting severity information.
            "%
            | optional,
        }
        | optional,
    }