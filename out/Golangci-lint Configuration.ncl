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
      "_js2n__-:definitions/formats-path!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.enum [ "stdout", "stderr" ],
                _js2n__-prdslib.isType '"String"
              ]),
      "_js2n__-:definitions/formatter-names!contract"
        | doc "Usable formatter names."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [ "gci", "gofmt", "gofumpt", "goimports", "golines" ]),
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
                "badSyncOnceFunc",
                "boolExprSimplify",
                "builtinShadow",
                "builtinShadowDecl",
                "captLocal",
                "caseOrder",
                "codegenComment",
                "commentFormatting",
                "commentedOutCode",
                "commentedOutImport",
                "defaultCaseOrder",
                "deferInLoop",
                "deferUnlambda",
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
                "rangeAppendAll",
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
                "stringXbytes",
                "stringsCompare",
                "switchTrue",
                "syncMapLoadAndDelete",
                "timeExprSimplify",
                "todoCommentWithoutDetail",
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
                "G115",
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
                "G405",
                "G406",
                "G501",
                "G502",
                "G503",
                "G504",
                "G505",
                "G506",
                "G507",
                "G601",
                "G602"
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
                "stdversion",
                "stringintconv",
                "structtag",
                "testinggoroutine",
                "tests",
                "timeformat",
                "unmarshal",
                "unreachable",
                "unsafeptr",
                "unusedresult",
                "unusedwrite",
                "waitgroup"
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
              "stdversion",
              "stringintconv",
              "structtag",
              "testinggoroutine",
              "tests",
              "timeformat",
              "unmarshal",
              "unreachable",
              "unsafeptr",
              "unusedresult",
              "unusedwrite",
              "waitgroup"
            ],
      "_js2n__-:definitions/iface-analyzers!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum [ "identical", "unused", "opaque" ]),
      "_js2n__-:definitions/linter-names!contract"
        | doc "Usable linter names."
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
                    "exhaustive",
                    "exhaustruct",
                    "exptostd",
                    "fatcontext",
                    "forbidigo",
                    "forcetypeassert",
                    "funlen",
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
                    "goheader",
                    "gomoddirectives",
                    "gomodguard",
                    "goprintffuncname",
                    "gosec",
                    "gosimple",
                    "gosmopolitan",
                    "govet",
                    "grouper",
                    "iface",
                    "importas",
                    "inamedparam",
                    "ineffassign",
                    "interfacebloat",
                    "intrange",
                    "ireturn",
                    "lll",
                    "loggercheck",
                    "maintidx",
                    "makezero",
                    "mirror",
                    "misspell",
                    "mnd",
                    "musttag",
                    "nakedret",
                    "nestif",
                    "nilerr",
                    "nilnesserr",
                    "nilnil",
                    "nlreturn",
                    "noctx",
                    "nolintlint",
                    "nonamedreturns",
                    "nosprintfhostport",
                    "paralleltest",
                    "perfsprint",
                    "prealloc",
                    "predeclared",
                    "promlinter",
                    "protogetter",
                    "reassign",
                    "recvcheck",
                    "revive",
                    "rowserrcheck",
                    "sloglint",
                    "sqlclosecheck",
                    "staticcheck",
                    "stylecheck",
                    "tagalign",
                    "tagliatelle",
                    "tenv",
                    "testableexamples",
                    "testifylint",
                    "testpackage",
                    "thelper",
                    "tparallel",
                    "unconvert",
                    "unparam",
                    "unused",
                    "usestdlibvars",
                    "usetesting",
                    "varnamelen",
                    "wastedassign",
                    "whitespace",
                    "wrapcheck",
                    "wsl",
                    "zerologlint"
                  ],
                _js2n__-prdslib.isType '"String"
              ]),
      "_js2n__-:definitions/linter-names!predicate"
        | doc "Usable linter names."
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
                  "exhaustive",
                  "exhaustruct",
                  "exptostd",
                  "fatcontext",
                  "forbidigo",
                  "forcetypeassert",
                  "funlen",
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
                  "goheader",
                  "gomoddirectives",
                  "gomodguard",
                  "goprintffuncname",
                  "gosec",
                  "gosimple",
                  "gosmopolitan",
                  "govet",
                  "grouper",
                  "iface",
                  "importas",
                  "inamedparam",
                  "ineffassign",
                  "interfacebloat",
                  "intrange",
                  "ireturn",
                  "lll",
                  "loggercheck",
                  "maintidx",
                  "makezero",
                  "mirror",
                  "misspell",
                  "mnd",
                  "musttag",
                  "nakedret",
                  "nestif",
                  "nilerr",
                  "nilnesserr",
                  "nilnil",
                  "nlreturn",
                  "noctx",
                  "nolintlint",
                  "nonamedreturns",
                  "nosprintfhostport",
                  "paralleltest",
                  "perfsprint",
                  "prealloc",
                  "predeclared",
                  "promlinter",
                  "protogetter",
                  "reassign",
                  "recvcheck",
                  "revive",
                  "rowserrcheck",
                  "sloglint",
                  "sqlclosecheck",
                  "staticcheck",
                  "stylecheck",
                  "tagalign",
                  "tagliatelle",
                  "tenv",
                  "testableexamples",
                  "testifylint",
                  "testpackage",
                  "thelper",
                  "tparallel",
                  "unconvert",
                  "unparam",
                  "unused",
                  "usestdlibvars",
                  "usetesting",
                  "varnamelen",
                  "wastedassign",
                  "whitespace",
                  "wrapcheck",
                  "wsl",
                  "zerologlint"
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/relative-path-modes!predicate" =
        _js2n__-prdslib.enum [ "gomod", "gitroot", "cfg", "wd" ],
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
                "file-length-limit",
                "filename-format",
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
                "range-val-address",
                "range-val-in-closure",
                "range",
                "receiver-naming",
                "redefines-builtin-id",
                "redundant-build-tag",
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
                "use-errors-new",
                "useless-break",
                "var-declaration",
                "var-naming",
                "waitgroup-by-value"
              ]),
      "_js2n__-:definitions/settings/definitions/asasalintSettings!contract" =
        {
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
            use-builtin-exclusions
              | Bool
              | doc "To enable/disable the asasalint builtin exclusions of function names."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/bidichkSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/copyloopvarSettings!contract" =
        { check-alias | Bool | optional, },
      "_js2n__-:definitions/settings/definitions/customSettings!contract"
        | doc m%"
          The custom section can be used to define linter plugins to be loaded at runtime. See README of golangci-lint for more information.
          Each custom linter should have a unique name.
        "%
        = _js2n__-prdslib.contract_from_predicate
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
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        type =
                                          _js2n__-prdslib.enum [ "module" ],
                                      } {} true _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "path" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ]
                              ],
                            _js2n__-prdslib.records.record
                              {
                                description = _js2n__-prdslib.isType '"String",
                                original-url = _js2n__-prdslib.isType '"String",
                                path = _js2n__-prdslib.isType '"String",
                                settings = _js2n__-prdslib.isType 'Record,
                                type =
                                  _js2n__-prdslib.enum [ "module", "goplugin" ],
                              } {} false _js2n__-prdslib.never
                          ],
                  } true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/settings/definitions/cyclopSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/decorderSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/depguardSettings!contract" =
        {
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
                                            _js2n__-prdslib.records.record {} {}
                                              false _js2n__-prdslib.never
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
                                            _js2n__-prdslib.records.record {} {}
                                              false _js2n__-prdslib.never
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
          },
      "_js2n__-:definitions/settings/definitions/dogsledSettings!contract" =
        {
            max-blank-identifiers
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Check assignments with too many blank identifiers."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/duplSettings!contract" =
        {
            threshold
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Tokens count to trigger issue."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/dupwordSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/errcheckSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/errchkjsonSettings!contract" =
        {
            check-error-free-encoding | Bool | optional,
            report-no-exported
              | Bool
              | doc "Issue on struct that doesn't have exported fields."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/errorlintSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/exhaustiveSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/exhaustructSettings!contract" =
        {
            exclude
              | Array (String)
              | doc "List of regular expressions to exclude struct packages and names from check."
              | optional,
            include
              | Array (String)
              | doc "List of regular expressions to match struct packages and names."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/fatcontextSettings!contract" =
        {
            check-struct-pointers
              | Bool
              | doc "Check for potential fat contexts in struct pointers."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/forbidigoSettings!contract" =
        {
            analyze-types
              | Bool
              | doc "Instead of matching the literal source code, use type information to replace expressions with strings that contain the package name and (for methods and fields) the type name."
              | optional,
            exclude-godoc-examples
              | Bool
              | doc "Exclude code in godoc examples."
              | optional,
            forbid
              | Array
                {
                  msg | String | doc "Message" | optional,
                  pattern | String | doc "Pattern" | optional,
                  pkg | String | doc "Package" | optional,
                }
              | doc "List of identifiers to forbid (written using `regexp`)"
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/funlenSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/gciSettings!contract" =
        {
            custom-order
              | Bool
              | doc "Enable custom order of sections."
              | optional,
            no-inline-comments
              | Bool
              | doc "Checks that no inline Comments are present."
              | optional,
            no-lex-order
              | Bool
              | doc "Drops lexical ordering for custom sections."
              | optional,
            no-prefix-comments
              | Bool
              | doc "Checks that no prefix Comments(comment lines above an import) are present."
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
          },
      "_js2n__-:definitions/settings/definitions/ginkgolinterSettings!contract" =
        {
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
            force-succeed
              | Bool
              | doc "Force using the Succeed matcher for error functions, and the HaveOccurred matcher for non-function error values."
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
          },
      "_js2n__-:definitions/settings/definitions/gochecksumtypeSettings!contract" =
        {
            default-signifies-exhaustive
              | Bool
              | doc "Presence of `default` case in switch statements satisfies exhaustiveness, if all members are not listed."
              | optional,
            include-shared-interfaces
              | Bool
              | doc "Include shared interfaces in the exhaustiviness check."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/gocognitSettings!contract" =
        {
            min-complexity
              | std.number.Integer
              | doc "Minimal code complexity to report (we recommend 10-20)."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/goconstSettings!contract" =
        {
            ignore-calls
              | Bool
              | doc "Ignore when constant is not used as function argument"
              | optional,
            ignore-strings
              | String
              | doc "Exclude strings matching the given regular expression"
              | optional,
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
          },
      "_js2n__-:definitions/settings/definitions/gocriticSettings!contract" =
        {
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
                ifElseChain | { minThreshold | Number | optional, } | optional,
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
                unnamedResult | { checkExported | Bool | optional, } | optional,
              }
              | doc "Settings passed to gocritic. Properties must be valid and enabled check names."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/gocycloSettings!contract" =
        {
            min-complexity
              | std.number.Integer
              | doc "Minimum code complexity to report (we recommend 10-20)."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/godotSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/godoxSettings!contract" =
        {
            keywords
              | Array (String)
              | doc "Report any comments starting with one of these keywords. This is useful for TODO or FIXME comments that might be left in the code accidentally and should be resolved before merging."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/gofmtSettings!contract" =
        {
            rewrite-rules
              | Array
                {
                  pattern | String | optional,
                  replacement | String | optional,
                }
              | doc "Apply the rewrite rules to the source before reformatting."
              | optional,
            simplify | Bool | doc "Simplify code." | optional,
          },
      "_js2n__-:definitions/settings/definitions/gofumptSettings!contract" =
        {
            extra-rules
              | Bool
              | doc "Choose whether or not to use the extra rules that are disabled by default."
              | optional,
            module-path
              | String
              | doc " Module path which contains the source code being formatted."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/goheaderSettings!contract" =
        _js2n__-prdslib.contract_from_predicate
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
                                              _js2n__-prdslib.isType '"String",
                                          } false _js2n__-prdslib.never
                                      ],
                                regexp =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {}
                                          {
                                            "^.+$" =
                                              _js2n__-prdslib.isType '"String",
                                          } false _js2n__-prdslib.never
                                      ],
                              } {} false _js2n__-prdslib.never
                          ],
                  } {} false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/settings/definitions/goimportsSettings!contract" =
        {
            local-prefixes
              | Array (String)
              | doc "Put imports beginning with prefix after 3rd-party packages. It is a list of prefixes."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/golinesSettings!contract" =
        {
            chain-split-dots | Bool | optional,
            max-len | std.number.Integer | optional,
            reformat-tags | Bool | optional,
            shorten-comments | Bool | optional,
            tab-len | std.number.Integer | optional,
          },
      "_js2n__-:definitions/settings/definitions/gomoddirectivesSettings!contract" =
        {
            exclude-forbidden
              | Bool
              | doc "Forbid the use of the `exclude` directives."
              | optional,
            go-debug-forbidden
              | Bool
              | doc "Forbid the use of the `godebug` directive."
              | optional,
            go-version-pattern
              | String
              | doc "Defines a pattern to validate `go` minimum version directive."
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
            tool-forbidden
              | Bool
              | doc "Forbid the use of the `tool` directives."
              | optional,
            toolchain-forbidden
              | Bool
              | doc "Forbid the use of the `toolchain` directive."
              | optional,
            toolchain-pattern
              | String
              | doc "Defines a pattern to validate `toolchain` directive."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/gomodguardSettings!contract" =
        {
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
                local-replace-directives
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
          },
      "_js2n__-:definitions/settings/definitions/gosecSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/gosmopolitanSettings!contract" =
        {
            allow-time-local
              | Bool
              | doc "Allow and ignore `time.Local` usages."
              | optional,
            escape-hatches
              | Array (String)
              | doc "List of fully qualified names in the `full/pkg/path.name` form, to act as \"i18n escape hatches\"."
              | optional,
            watch-for-scripts
              | Array (String)
              | doc "List of Unicode scripts to watch for any usage in string literals."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/govetSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/grouperSettings!contract" =
        {
            const-require-grouping | Bool | optional,
            const-require-single-const | Bool | optional,
            import-require-grouping | Bool | optional,
            import-require-single-import | Bool | optional,
            type-require-grouping | Bool | optional,
            type-require-single-type | Bool | optional,
            var-require-grouping | Bool | optional,
            var-require-single-var | Bool | optional,
          },
      "_js2n__-:definitions/settings/definitions/ifaceSettings!contract" =
        {
            enable
              | Array
                _js2n__-refsenv."_js2n__-:definitions/iface-analyzers!contract"
              | doc "Enable analyzers by name."
              | optional,
            settings
              | {
                unused | { exclude | Array (String) | optional, } | optional,
              }
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/importasSettings!contract" =
        {
            alias
              | Array
                {
                  alias | String | doc "Package alias e.g. autoscalingv1alpha1",
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
          },
      "_js2n__-:definitions/settings/definitions/inamedparamSettings!contract" =
        {
            skip-single-param
              | Bool
              | doc "Skips check for interface methods with only a single parameter."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/interfacebloatSettings!contract" =
        {
            max
              | std.number.Integer
              | doc "The maximum number of methods allowed for an interface."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/ireturnSettings!contract"
        | doc "Use either `reject` or `allow` properties for interfaces matching."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.not
                          (_js2n__-prdslib.records.record
                            { allow = _js2n__-prdslib.const "reject", } {} true
                            _js2n__-prdslib.always),
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
              ]),
      "_js2n__-:definitions/settings/definitions/lllSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/loggercheckSettings!contract" =
        {
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
            slog
              | Bool
              | doc "Allow check for the log/slog library."
              | optional,
            zap
              | Bool
              | doc "Allow check for the \"sugar logger\" from go.uber.org/zap library."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/maintidxSettings!contract"
        | doc "Maintainability index https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022"
        = {
            under
              | Number
              | doc "Minimum accatpable maintainability index level (see https://docs.microsoft.com/en-us/visualstudio/code-quality/code-metrics-maintainability-index-range-and-meaning?view=vs-2022)"
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/makezeroSettings!contract" =
        {
            always
              | Bool
              | doc "Allow only slices initialized with a length of zero."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/misspellSettings!contract"
        | doc "Correct spellings using locale preferences for US or UK. Default is to use a neutral variety of English."
        = {
            extra-words
              | Array
                { correction | String | optional, typo | String | optional, }
              | doc "Extra word corrections."
              | optional,
            ignore-rules
              | Array (String)
              | doc "List of rules to ignore."
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
          },
      "_js2n__-:definitions/settings/definitions/mndSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/musttagSettings!contract" =
        {
            functions
              | Array
                {
                  arg-pos | std.number.Integer | optional,
                  name | String | optional,
                  tag | String | optional,
                }
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/nakedretSettings!contract" =
        {
            max-func-lines
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Report if a function has more lines of code than this value and it has naked returns."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/nestifSettings!contract" =
        {
            min-complexity
              | std.number.Integer
              | doc "Minimum complexity of \"if\" statements to report."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/nilnilSettings!contract" =
        {
            checked-types
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum
                    [
                      "chan",
                      "func",
                      "iface",
                      "map",
                      "ptr",
                      "uintptr",
                      "unsafeptr"
                    ])
              )
              | doc "List of return types to check."
              | optional,
            detect-opposite
              | Bool
              | doc "In addition, detect opposite situation (simultaneous return of non-nil error and valid value)."
              | optional,
            only-two
              | Bool
              | doc "To check functions with only two return values."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/nlreturnSettings!contract" =
        {
            block-size
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "set block size that is still ok"
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/nolintlintSettings!contract" =
        {
            allow-no-explanation
              | Array
                _js2n__-refsenv."_js2n__-:definitions/linter-names!contract"
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
          },
      "_js2n__-:definitions/settings/definitions/nonamedreturnsSettings!contract" =
        {
            report-error-in-defer
              | Bool
              | doc "Report named error if it is assigned inside defer."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/paralleltestSettings!contract" =
        {
            ignore-missing
              | Bool
              | doc "Ignore missing calls to `t.Parallel()` and only report incorrect uses of it."
              | optional,
            ignore-missing-subtests
              | Bool
              | doc "Ignore missing calls to `t.Parallel()` in subtests. Top-level tests are still required to have `t.Parallel`, but subtests are allowed to skip it."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/perfsprintSettings!contract" =
        {
            bool-format
              | Bool
              | doc "Enable/disable optimization of bool formatting."
              | optional,
            err-error
              | Bool
              | doc "Optimizes into `err.Error()` even if it is only equivalent for non-nil errors."
              | optional,
            error-format
              | Bool
              | doc "Enable/disable optimization of error formatting."
              | optional,
            errorf | Bool | doc "Optimizes `fmt.Errorf`." | optional,
            hex-format
              | Bool
              | doc "Enable/disable optimization of hex formatting."
              | optional,
            int-conversion
              | Bool
              | doc "Optimizes even if it requires an int or uint type cast."
              | optional,
            integer-format
              | Bool
              | doc "Enable/disable optimization of integer formatting."
              | optional,
            sprintf1
              | Bool
              | doc "Optimizes `fmt.Sprintf` with only one argument."
              | optional,
            strconcat
              | Bool
              | doc "Optimizes into strings concatenation."
              | optional,
            string-format
              | Bool
              | doc "Enable/disable optimization of string formatting."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/preallocSettings!contract"
        | doc m%"
          We do not recommend using this linter before doing performance profiling.
          For most programs usage of `prealloc` will be premature optimization.
        "%
        = {
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
          },
      "_js2n__-:definitions/settings/definitions/predeclaredSettings!contract" =
        {
            ignore
              | Array (String)
              | doc "List of predeclared identifiers to not report on."
              | optional,
            qualified-name
              | Bool
              | doc "Include method names and field names in checks."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/promlinterSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/protogetterSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/reassignSettings!contract" =
        { patterns | Array (String) | optional, },
      "_js2n__-:definitions/settings/definitions/recvcheckSettings!contract" =
        {
            disable-builtin
              | Bool
              | doc "Disables the built-in method exclusions."
              | optional,
            exclusions
              | Array (String)
              | doc "User-defined method exclusions."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/reviveSettings!contract" =
        {
            confidence | Number | optional,
            directives
              | Array
                {
                  arguments | Array Dyn | optional,
                  exclude | Array (String) | optional,
                  name
                    | std.enum.TagOrString
                    | [| 'specify-disable-reason |]
                    | optional,
                  severity
                    | std.enum.TagOrString
                    | [| 'error, 'warning |]
                    | optional,
                }
              | optional,
            enable-all-rules | Bool | optional,
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
            severity | std.enum.TagOrString | [| 'error, 'warning |] | optional,
          },
      "_js2n__-:definitions/settings/definitions/rowserrcheckSettings!contract" =
        { packages | Array (String) | optional, },
      "_js2n__-:definitions/settings/definitions/sloglintSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/spancheckSettings!contract" =
        {
            checks
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "end", "record-error", "set-status" ])
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
          },
      "_js2n__-:definitions/settings/definitions/staticcheckSettings!contract" =
        {
            checks
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/staticcheck-checks!predicate",
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
          },
      "_js2n__-:definitions/settings/definitions/tagalignSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/tagliatelleSettings!contract" =
        {
            case
              | {
                extended-rules
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^.+$" =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "case" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        case =
                                          _js2n__-refsenv."_js2n__-:definitions/tagliatelle-cases!predicate",
                                        extra-initialisms =
                                          _js2n__-prdslib.isType '"Bool",
                                        initialism-overrides =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {}
                                                  {
                                                    "^.+$" =
                                                      _js2n__-prdslib.isType
                                                          '"Bool",
                                                  } true _js2n__-prdslib.always
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                          } true _js2n__-prdslib.always
                      ])
                  | doc "Defines the association between tag name and case."
                  | optional,
                ignored-fields
                  | Array (String)
                  | doc "The field names to ignore."
                  | optional,
                overrides
                  | Array
                    {
                      extended-rules
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^.+$" =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "case" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              case =
                                                _js2n__-refsenv."_js2n__-:definitions/tagliatelle-cases!predicate",
                                              extra-initialisms =
                                                _js2n__-prdslib.isType '"Bool",
                                              initialism-overrides =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {}
                                                        {
                                                          "^.+$" =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                        } true
                                                        _js2n__-prdslib.always
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ],
                                } true _js2n__-prdslib.always
                            ])
                        | doc "Defines the association between tag name and case."
                        | optional,
                      ignore
                        | Bool
                        | doc "Ignore the package (takes precedence over all other configurations)."
                        | optional,
                      ignored-fields
                        | Array (String)
                        | doc "The field names to ignore."
                        | optional,
                      pkg | String | doc "A package path.",
                      rules
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^.+$" =
                                    _js2n__-refsenv."_js2n__-:definitions/tagliatelle-cases!predicate",
                                } true _js2n__-prdslib.always
                            ])
                        | optional,
                      use-field-name
                        | Bool
                        | doc "Use the struct field name to check the name of the struct tag."
                        | optional,
                    }
                  | doc "Overrides the default/root configuration."
                  | optional,
                rules
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^.+$" =
                              _js2n__-refsenv."_js2n__-:definitions/tagliatelle-cases!predicate",
                          } true _js2n__-prdslib.always
                      ])
                  | optional,
                use-field-name
                  | Bool
                  | doc "Use the struct field name to check the name of the struct tag."
                  | optional,
              }
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/tenvSettings!contract" =
        {
            all
              | Bool
              | doc "The option `all` will run against whole test files (`_test.go`) regardless of method/function signatures."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/testifylintSettings!contract" =
        {
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
                      "contains",
                      "empty",
                      "encoded-compare",
                      "equal-values",
                      "error-is-as",
                      "error-nil",
                      "expected-actual",
                      "float-compare",
                      "formatter",
                      "go-require",
                      "len",
                      "negative-positive",
                      "nil-compare",
                      "regexp",
                      "require-error",
                      "suite-broken-parallel",
                      "suite-dont-use-pkg",
                      "suite-extra-assert-call",
                      "suite-method-signature",
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
                      "contains",
                      "empty",
                      "encoded-compare",
                      "equal-values",
                      "error-is-as",
                      "error-nil",
                      "expected-actual",
                      "float-compare",
                      "formatter",
                      "go-require",
                      "len",
                      "negative-positive",
                      "nil-compare",
                      "regexp",
                      "require-error",
                      "suite-broken-parallel",
                      "suite-dont-use-pkg",
                      "suite-extra-assert-call",
                      "suite-method-signature",
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
                  | doc "To require f-assertions (e.g. assert.Equalf) if format string is used, even if there are no variable-length variables."
                  | optional,
                require-string-msg
                  | Bool
                  | doc "To require that the first element of msgAndArgs (msg) has a string type."
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
          },
      "_js2n__-:definitions/settings/definitions/testpackageSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/thelperSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/unconvertSettings!contract" =
        { fast-math | Bool | optional, safe | Bool | optional, },
      "_js2n__-:definitions/settings/definitions/unparamSettings!contract" =
        {
            check-exported
              | Bool
              | doc m%"
                Inspect exported functions. Set to true if no external program/library imports your code.
                
                WARNING: if you enable this setting, unparam will report a lot of false-positives in text editors:
                if it's called for subdir of a project it can't find external interfaces. All text editor integrations
                with golangci-lint call it on a directory with the changed file.
              "%
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/unusedSettings!contract" =
        {
            exported-fields-are-used | Bool | doc "" | optional,
            field-writes-are-uses | Bool | doc "" | optional,
            generated-is-used | Bool | doc "" | optional,
            local-variables-are-used | Bool | doc "" | optional,
            parameters-are-used | Bool | doc "" | optional,
            post-statements-are-reads | Bool | doc "" | optional,
          },
      "_js2n__-:definitions/settings/definitions/usestdlibvarsSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/usetestingSettings!contract" =
        {
            context-background | Bool | optional,
            context-todo | Bool | optional,
            os-chdir | Bool | optional,
            os-create-temp | Bool | optional,
            os-mkdir-temp | Bool | optional,
            os-setenv | Bool | optional,
            os-temp-dir | Bool | optional,
          },
      "_js2n__-:definitions/settings/definitions/varnamelenSettings!contract" =
        {
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
          },
      "_js2n__-:definitions/settings/definitions/whitespaceSettings!contract" =
        {
            multi-func
              | Bool
              | doc "Enforces newlines (or comments) after every multi-line function signature"
              | optional,
            multi-if
              | Bool
              | doc "Enforces newlines (or comments) after every multi-line if statement"
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/wrapcheckSettings!contract" =
        {
            extra-ignore-sigs
              | Array (String)
              | doc "An array of strings specifying additional substrings of signatures to ignore."
              | optional,
            ignore-interface-regexps
              | Array (String)
              | doc "An array of glob patterns which, if matched to an underlying interface name, will ignore unwrapped errors returned from a function whose call is defined on the given interface."
              | optional,
            ignore-package-globs
              | Array (String)
              | doc "An array of glob patterns which, if any match the package of the function returning the error, will skip wrapcheck analysis for this error."
              | optional,
            ignore-sig-regexps
              | Array (String)
              | doc "An array of strings which specify regular expressions of signatures to ignore."
              | optional,
            ignore-sigs
              | Array (String)
              | doc "An array of strings which specify substrings of signatures to ignore."
              | optional,
          },
      "_js2n__-:definitions/settings/definitions/wslSettings!contract" =
        {
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
            allow-cuddle-used-in-block
              | Bool
              | doc "Allow cuddling with any block as long as the variable is used somewhere in the block"
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
          },
      "_js2n__-:definitions/simple-format!contract" =
        {
            path
              | _js2n__-refsenv."_js2n__-:definitions/formats-path!contract"
              | optional,
          },
      "_js2n__-:definitions/staticcheck-checks!predicate" =
        _js2n__-prdslib.enum
            [
              "*",
              "all",
              "SA*",
              "-SA*",
              "SA1*",
              "-SA1*",
              "SA1000",
              "-SA1000",
              "SA1001",
              "-SA1001",
              "SA1002",
              "-SA1002",
              "SA1003",
              "-SA1003",
              "SA1004",
              "-SA1004",
              "SA1005",
              "-SA1005",
              "SA1006",
              "-SA1006",
              "SA1007",
              "-SA1007",
              "SA1008",
              "-SA1008",
              "SA1010",
              "-SA1010",
              "SA1011",
              "-SA1011",
              "SA1012",
              "-SA1012",
              "SA1013",
              "-SA1013",
              "SA1014",
              "-SA1014",
              "SA1015",
              "-SA1015",
              "SA1016",
              "-SA1016",
              "SA1017",
              "-SA1017",
              "SA1018",
              "-SA1018",
              "SA1019",
              "-SA1019",
              "SA1020",
              "-SA1020",
              "SA1021",
              "-SA1021",
              "SA1023",
              "-SA1023",
              "SA1024",
              "-SA1024",
              "SA1025",
              "-SA1025",
              "SA1026",
              "-SA1026",
              "SA1027",
              "-SA1027",
              "SA1028",
              "-SA1028",
              "SA1029",
              "-SA1029",
              "SA1030",
              "-SA1030",
              "SA1031",
              "-SA1031",
              "SA1032",
              "-SA1032",
              "SA2*",
              "-SA2*",
              "SA2000",
              "-SA2000",
              "SA2001",
              "-SA2001",
              "SA2002",
              "-SA2002",
              "SA2003",
              "-SA2003",
              "SA3*",
              "-SA3*",
              "SA3000",
              "-SA3000",
              "SA3001",
              "-SA3001",
              "SA4*",
              "-SA4*",
              "SA4000",
              "-SA4000",
              "SA4001",
              "-SA4001",
              "SA4003",
              "-SA4003",
              "SA4004",
              "-SA4004",
              "SA4005",
              "-SA4005",
              "SA4006",
              "-SA4006",
              "SA4008",
              "-SA4008",
              "SA4009",
              "-SA4009",
              "SA4010",
              "-SA4010",
              "SA4011",
              "-SA4011",
              "SA4012",
              "-SA4012",
              "SA4013",
              "-SA4013",
              "SA4014",
              "-SA4014",
              "SA4015",
              "-SA4015",
              "SA4016",
              "-SA4016",
              "SA4017",
              "-SA4017",
              "SA4018",
              "-SA4018",
              "SA4019",
              "-SA4019",
              "SA4020",
              "-SA4020",
              "SA4021",
              "-SA4021",
              "SA4022",
              "-SA4022",
              "SA4023",
              "-SA4023",
              "SA4024",
              "-SA4024",
              "SA4025",
              "-SA4025",
              "SA4026",
              "-SA4026",
              "SA4027",
              "-SA4027",
              "SA4028",
              "-SA4028",
              "SA4029",
              "-SA4029",
              "SA4030",
              "-SA4030",
              "SA4031",
              "-SA4031",
              "SA4032",
              "-SA4032",
              "SA5*",
              "-SA5*",
              "SA5000",
              "-SA5000",
              "SA5001",
              "-SA5001",
              "SA5002",
              "-SA5002",
              "SA5003",
              "-SA5003",
              "SA5004",
              "-SA5004",
              "SA5005",
              "-SA5005",
              "SA5007",
              "-SA5007",
              "SA5008",
              "-SA5008",
              "SA5009",
              "-SA5009",
              "SA5010",
              "-SA5010",
              "SA5011",
              "-SA5011",
              "SA5012",
              "-SA5012",
              "SA6*",
              "-SA6*",
              "SA6000",
              "-SA6000",
              "SA6001",
              "-SA6001",
              "SA6002",
              "-SA6002",
              "SA6003",
              "-SA6003",
              "SA6005",
              "-SA6005",
              "SA6006",
              "-SA6006",
              "SA9*",
              "-SA9*",
              "SA9001",
              "-SA9001",
              "SA9002",
              "-SA9002",
              "SA9003",
              "-SA9003",
              "SA9004",
              "-SA9004",
              "SA9005",
              "-SA9005",
              "SA9006",
              "-SA9006",
              "SA9007",
              "-SA9007",
              "SA9008",
              "-SA9008",
              "SA9009",
              "-SA9009",
              "ST*",
              "-ST*",
              "ST1*",
              "-ST1*",
              "ST1000",
              "-ST1000",
              "ST1001",
              "-ST1001",
              "ST1003",
              "-ST1003",
              "ST1005",
              "-ST1005",
              "ST1006",
              "-ST1006",
              "ST1008",
              "-ST1008",
              "ST1011",
              "-ST1011",
              "ST1012",
              "-ST1012",
              "ST1013",
              "-ST1013",
              "ST1015",
              "-ST1015",
              "ST1016",
              "-ST1016",
              "ST1017",
              "-ST1017",
              "ST1018",
              "-ST1018",
              "ST1019",
              "-ST1019",
              "ST1020",
              "-ST1020",
              "ST1021",
              "-ST1021",
              "ST1022",
              "-ST1022",
              "ST1023",
              "-ST1023",
              "S*",
              "-S*",
              "S1*",
              "-S1*",
              "S1000",
              "-S1000",
              "S1001",
              "-S1001",
              "S1002",
              "-S1002",
              "S1003",
              "-S1003",
              "S1004",
              "-S1004",
              "S1005",
              "-S1005",
              "S1006",
              "-S1006",
              "S1007",
              "-S1007",
              "S1008",
              "-S1008",
              "S1009",
              "-S1009",
              "S1010",
              "-S1010",
              "S1011",
              "-S1011",
              "S1012",
              "-S1012",
              "S1016",
              "-S1016",
              "S1017",
              "-S1017",
              "S1018",
              "-S1018",
              "S1019",
              "-S1019",
              "S1020",
              "-S1020",
              "S1021",
              "-S1021",
              "S1023",
              "-S1023",
              "S1024",
              "-S1024",
              "S1025",
              "-S1025",
              "S1028",
              "-S1028",
              "S1029",
              "-S1029",
              "S1030",
              "-S1030",
              "S1031",
              "-S1031",
              "S1032",
              "-S1032",
              "S1033",
              "-S1033",
              "S1034",
              "-S1034",
              "S1035",
              "-S1035",
              "S1036",
              "-S1036",
              "S1037",
              "-S1037",
              "S1038",
              "-S1038",
              "S1039",
              "-S1039",
              "S1040",
              "-S1040",
              "QF*",
              "-QF*",
              "QF1*",
              "-QF1*",
              "QF1001",
              "-QF1001",
              "QF1002",
              "-QF1002",
              "QF1003",
              "-QF1003",
              "QF1004",
              "-QF1004",
              "QF1005",
              "-QF1005",
              "QF1006",
              "-QF1006",
              "QF1007",
              "-QF1007",
              "QF1008",
              "-QF1008",
              "QF1009",
              "-QF1009",
              "QF1010",
              "-QF1010",
              "QF1011",
              "-QF1011",
              "QF1012",
              "-QF1012"
            ],
      "_js2n__-:definitions/tagliatelle-cases!predicate" =
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
    }
    in
  {
      formatters
        | {
          enable
            | Array
              _js2n__-refsenv."_js2n__-:definitions/formatter-names!contract"
            | doc "List of enabled formatters."
            | optional,
          exclusions
            | {
              generated
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "strict", "lax", "disable" ])
                | optional,
              paths | Array (String) | optional,
            }
            | optional,
          settings
            | {
              gci
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gciSettings!contract"
                | optional,
              gofmt
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gofmtSettings!contract"
                | optional,
              gofumpt
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gofumptSettings!contract"
                | optional,
              goimports
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/goimportsSettings!contract"
                | optional,
              golines
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/golinesSettings!contract"
                | optional,
            }
            | optional,
        }
        | optional,
      issues
        | {
          fix
            | Bool
            | doc "Fix found issues (if it's supported by the linter)."
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
          new-from-merge-base
            | String
            | doc "Show only new issues created after the best common ancestor (merge-base against HEAD)."
            | optional,
          new-from-patch
            | String
            | doc "Show only new issues created in git patch with this file path."
            | optional,
          new-from-rev
            | String
            | doc "Show only new issues created after this git revision."
            | optional,
          uniq-by-line
            | Bool
            | doc "Make issues output unique by line."
            | optional,
          whole-files
            | Bool
            | doc "Show issues in any part of update files (requires new-from-rev or new-from-patch)."
            | optional,
        }
        | optional,
      linters
        | {
          "default"
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "standard", "all", "none", "fast" ])
            | optional,
          disable
            | Array _js2n__-refsenv."_js2n__-:definitions/linter-names!contract"
            | doc "List of disabled linters."
            | optional,
          enable
            | Array _js2n__-refsenv."_js2n__-:definitions/linter-names!contract"
            | doc "List of enabled linters."
            | optional,
          exclusions
            | {
              generated
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.enum [ "strict", "lax", "disable" ])
                | optional,
              paths | Array (String) | optional,
              paths-except | Array (String) | optional,
              presets
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [
                        "comments",
                        "std-error-handling",
                        "common-false-positives",
                        "legacy"
                      ])
                )
                | optional,
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
                                _js2n__-prdslib.records.required
                                  [ "path-except" ],
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
                        _js2n__-prdslib.records.record
                          {
                            linters =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      _js2n__-refsenv."_js2n__-:definitions/linter-names!predicate"
                                  ],
                            path = _js2n__-prdslib.isType '"String",
                            path-except = _js2n__-prdslib.isType '"String",
                            source = _js2n__-prdslib.isType '"String",
                            text = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ])
                )
                | optional,
              warn-unused | Bool | optional,
            }
            | optional,
          settings
            | {
              asasalint
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/asasalintSettings!contract"
                | optional,
              bidichk
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/bidichkSettings!contract"
                | optional,
              copyloopvar
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/copyloopvarSettings!contract"
                | optional,
              custom
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/customSettings!contract"
                | optional,
              cyclop
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/cyclopSettings!contract"
                | optional,
              decorder
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/decorderSettings!contract"
                | optional,
              depguard
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/depguardSettings!contract"
                | optional,
              dogsled
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/dogsledSettings!contract"
                | optional,
              dupl
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/duplSettings!contract"
                | optional,
              dupword
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/dupwordSettings!contract"
                | optional,
              errcheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/errcheckSettings!contract"
                | optional,
              errchkjson
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/errchkjsonSettings!contract"
                | optional,
              errorlint
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/errorlintSettings!contract"
                | optional,
              exhaustive
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/exhaustiveSettings!contract"
                | optional,
              exhaustruct
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/exhaustructSettings!contract"
                | optional,
              fatcontext
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/fatcontextSettings!contract"
                | optional,
              forbidigo
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/forbidigoSettings!contract"
                | optional,
              funlen
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/funlenSettings!contract"
                | optional,
              ginkgolinter
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/ginkgolinterSettings!contract"
                | optional,
              gochecksumtype
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gochecksumtypeSettings!contract"
                | optional,
              gocognit
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gocognitSettings!contract"
                | optional,
              goconst
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/goconstSettings!contract"
                | optional,
              gocritic
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gocriticSettings!contract"
                | optional,
              gocyclo
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gocycloSettings!contract"
                | optional,
              godot
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/godotSettings!contract"
                | optional,
              godox
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/godoxSettings!contract"
                | optional,
              goheader
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/goheaderSettings!contract"
                | optional,
              gomoddirectives
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gomoddirectivesSettings!contract"
                | optional,
              gomodguard
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gomodguardSettings!contract"
                | optional,
              gosec
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gosecSettings!contract"
                | optional,
              gosmopolitan
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/gosmopolitanSettings!contract"
                | optional,
              govet
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/govetSettings!contract"
                | optional,
              grouper
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/grouperSettings!contract"
                | optional,
              iface
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/ifaceSettings!contract"
                | optional,
              importas
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/importasSettings!contract"
                | optional,
              inamedparam
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/inamedparamSettings!contract"
                | optional,
              interfacebloat
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/interfacebloatSettings!contract"
                | optional,
              ireturn
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/ireturnSettings!contract"
                | optional,
              lll
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/lllSettings!contract"
                | optional,
              loggercheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/loggercheckSettings!contract"
                | optional,
              maintidx
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/maintidxSettings!contract"
                | optional,
              makezero
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/makezeroSettings!contract"
                | optional,
              misspell
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/misspellSettings!contract"
                | optional,
              mnd
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/mndSettings!contract"
                | optional,
              musttag
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/musttagSettings!contract"
                | optional,
              nakedret
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/nakedretSettings!contract"
                | optional,
              nestif
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/nestifSettings!contract"
                | optional,
              nilnil
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/nilnilSettings!contract"
                | optional,
              nlreturn
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/nlreturnSettings!contract"
                | optional,
              nolintlint
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/nolintlintSettings!contract"
                | optional,
              nonamedreturns
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/nonamedreturnsSettings!contract"
                | optional,
              paralleltest
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/paralleltestSettings!contract"
                | optional,
              perfsprint
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/perfsprintSettings!contract"
                | optional,
              prealloc
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/preallocSettings!contract"
                | optional,
              predeclared
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/predeclaredSettings!contract"
                | optional,
              promlinter
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/promlinterSettings!contract"
                | optional,
              protogetter
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/protogetterSettings!contract"
                | optional,
              reassign
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/reassignSettings!contract"
                | optional,
              recvcheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/recvcheckSettings!contract"
                | optional,
              revive
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/reviveSettings!contract"
                | optional,
              rowserrcheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/rowserrcheckSettings!contract"
                | optional,
              sloglint
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/sloglintSettings!contract"
                | optional,
              spancheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/spancheckSettings!contract"
                | optional,
              staticcheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/staticcheckSettings!contract"
                | optional,
              tagalign
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/tagalignSettings!contract"
                | optional,
              tagliatelle
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/tagliatelleSettings!contract"
                | optional,
              tenv
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/tenvSettings!contract"
                | optional,
              testifylint
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/testifylintSettings!contract"
                | optional,
              testpackage
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/testpackageSettings!contract"
                | optional,
              thelper
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/thelperSettings!contract"
                | optional,
              unconvert
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/unconvertSettings!contract"
                | optional,
              unparam
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/unparamSettings!contract"
                | optional,
              unused
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/unusedSettings!contract"
                | optional,
              usestdlibvars
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/usestdlibvarsSettings!contract"
                | optional,
              usetesting
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/usetestingSettings!contract"
                | optional,
              varnamelen
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/varnamelenSettings!contract"
                | optional,
              whitespace
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/whitespaceSettings!contract"
                | optional,
              wrapcheck
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/wrapcheckSettings!contract"
                | optional,
              wsl
                | _js2n__-refsenv."_js2n__-:definitions/settings/definitions/wslSettings!contract"
                | optional,
            }
            | doc "All available settings of specific linters."
            | optional,
        }
        | optional,
      output
        | {
          formats
            | {
              checkstyle
                | _js2n__-refsenv."_js2n__-:definitions/simple-format!contract"
                | optional,
              code-climate
                | _js2n__-refsenv."_js2n__-:definitions/simple-format!contract"
                | optional,
              html
                | _js2n__-refsenv."_js2n__-:definitions/simple-format!contract"
                | optional,
              json
                | _js2n__-refsenv."_js2n__-:definitions/simple-format!contract"
                | optional,
              junit-xml
                | {
                  extended | Bool | optional,
                  path
                    | _js2n__-refsenv."_js2n__-:definitions/formats-path!contract"
                    | optional,
                }
                | optional,
              sarif
                | _js2n__-refsenv."_js2n__-:definitions/simple-format!contract"
                | optional,
              tab
                | {
                  colors | Bool | optional,
                  path
                    | _js2n__-refsenv."_js2n__-:definitions/formats-path!contract"
                    | optional,
                  print-linter-name | Bool | optional,
                }
                | optional,
              teamcity
                | _js2n__-refsenv."_js2n__-:definitions/simple-format!contract"
                | optional,
              text
                | {
                  colors | Bool | optional,
                  path
                    | _js2n__-refsenv."_js2n__-:definitions/formats-path!contract"
                    | optional,
                  print-issued-lines | Bool | optional,
                  print-linter-name | Bool | optional,
                }
                | optional,
            }
            | doc "Output formats to use."
            | optional,
          path-prefix
            | String
            | doc "Add a prefix to the output file references."
            | optional,
          show-stats | Bool | doc "Show statistics per linter." | optional,
          sort-order
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum [ "linter", "severity", "file" ])
            )
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
          relative-path-mode
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-refsenv."_js2n__-:definitions/relative-path-modes!predicate"
                ])
            | doc "The mode used to evaluate relative paths."
            | optional,
          tests | Bool | doc "Enable inclusion of test files." | optional,
          timeout
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^((\\d+h)?(\\d+m)?(\\d+(?:\\.\\d)?s)?|0)$"
                ])
            | doc "Timeout for the analysis."
            | optional,
        }
        | doc "Options for analysis running,"
        | optional,
      severity
        | {
          "default"
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
                                  _js2n__-refsenv."_js2n__-:definitions/linter-names!predicate"
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
      version | String,
    }