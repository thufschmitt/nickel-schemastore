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
      "_js2n__-:definitions/AdditionalStitchingBatchResolverObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "keyField",
                  "keysArg",
                  "sourceFieldName",
                  "sourceName",
                  "sourceTypeName",
                  "targetFieldName",
                  "targetTypeName"
                ],
              _js2n__-prdslib.records.record
                {
                  additionalArgs = _js2n__-prdslib.isType 'Record,
                  keyField = _js2n__-prdslib.isType '"String",
                  keysArg = _js2n__-prdslib.isType '"String",
                  requiredSelectionSet = _js2n__-prdslib.isType '"String",
                  result = _js2n__-prdslib.isType '"String",
                  resultType = _js2n__-prdslib.isType '"String",
                  sourceFieldName = _js2n__-prdslib.isType '"String",
                  sourceName = _js2n__-prdslib.isType '"String",
                  sourceSelectionSet = _js2n__-prdslib.isType '"String",
                  sourceTypeName = _js2n__-prdslib.isType '"String",
                  targetFieldName = _js2n__-prdslib.isType '"String",
                  targetTypeName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AdditionalStitchingResolverObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "sourceFieldName",
                  "sourceName",
                  "sourceTypeName",
                  "targetFieldName",
                  "targetTypeName"
                ],
              _js2n__-prdslib.records.record
                {
                  requiredSelectionSet = _js2n__-prdslib.isType '"String",
                  result = _js2n__-prdslib.isType '"String",
                  resultType = _js2n__-prdslib.isType '"String",
                  sourceArgs = _js2n__-prdslib.isType 'Record,
                  sourceFieldName = _js2n__-prdslib.isType '"String",
                  sourceName = _js2n__-prdslib.isType '"String",
                  sourceSelectionSet = _js2n__-prdslib.isType '"String",
                  sourceTypeName = _js2n__-prdslib.isType '"String",
                  targetFieldName = _js2n__-prdslib.isType '"String",
                  targetTypeName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AdditionalSubscriptionObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "pubsubTopic", "targetFieldName", "targetTypeName" ],
              _js2n__-prdslib.records.record
                {
                  filterBy = _js2n__-prdslib.isType '"String",
                  pubsubTopic = _js2n__-prdslib.isType '"String",
                  result = _js2n__-prdslib.isType '"String",
                  targetFieldName = _js2n__-prdslib.isType '"String",
                  targetTypeName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CFWorkersKVCacheConfig!contract" =
        {
            namespace
              | String
              | doc m%"
                The name of the Workers KV namespace to use for caching.
                
                Make sure you have configured the following namespace described in [here](https://developers.cloudflare.com/workers/wrangler/cli-wrangler/commands/#kv).
              "%,
          },
      "_js2n__-:definitions/Cache!contract" =
        {
            cfwKv
              | _js2n__-refsenv."_js2n__-:definitions/CFWorkersKVCacheConfig!contract"
              | optional,
            file
              | _js2n__-refsenv."_js2n__-:definitions/FileCacheConfig!contract"
              | optional,
            localforage
              | _js2n__-refsenv."_js2n__-:definitions/LocalforageConfig!contract"
              | optional,
            redis
              | _js2n__-refsenv."_js2n__-:definitions/RedisConfig!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/CacheEffectingOperationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "operation" ],
              _js2n__-prdslib.records.record
                {
                  matchKey = _js2n__-prdslib.isType '"String",
                  operation = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CacheInvalidateConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  effectingOperations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CacheEffectingOperationConfig!predicate"
                        ],
                  ttl = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CacheTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "field" ],
              _js2n__-prdslib.records.record
                {
                  cacheKey = _js2n__-prdslib.isType '"String",
                  field = _js2n__-prdslib.isType '"String",
                  invalidate =
                    _js2n__-refsenv."_js2n__-:definitions/CacheInvalidateConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComposeMongooseInputType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  fields =
                    _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseFieldsOpts!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  resolvers =
                    _js2n__-refsenv."_js2n__-:definitions/TypeConverterResolversOpts!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComposeWithMongooseFieldsOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  only =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  remove =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  required =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComposeWithMongooseOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  fields =
                    _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseFieldsOpts!predicate",
                  inputType =
                    _js2n__-refsenv."_js2n__-:definitions/ComposeMongooseInputType!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  resolvers =
                    _js2n__-refsenv."_js2n__-:definitions/TypeConverterResolversOpts!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/FilterHelperArgsOpts!predicate",
                  limit =
                    _js2n__-refsenv."_js2n__-:definitions/LimitHelperArgsOpts!predicate",
                  record =
                    _js2n__-refsenv."_js2n__-:definitions/RecordHelperArgsOpts!predicate",
                  skip = _js2n__-prdslib.isType '"Bool",
                  sort =
                    _js2n__-refsenv."_js2n__-:definitions/SortHelperArgsOpts!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComputedAnnotation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "selectionSet" ],
              _js2n__-prdslib.records.record
                { selectionSet = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CorsConfig!contract" =
        {
            allowedHeaders
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ])
              | optional,
            credentials | Bool | optional,
            exposedHeaders
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ])
              | optional,
            maxAge | std.number.Integer | optional,
            optionsSuccessStatus | std.number.Integer | optional,
            origin
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Array"
                  ])
              | optional,
            preflightContinue | Bool | optional,
          },
      "_js2n__-:definitions/CustomPersistedQueryErrors!contract" =
        {
            keyNotFound
              | String
              | doc "Error to be thrown when the extraction of the persisted operation id failed"
              | optional,
            notFound
              | String
              | doc "Error to be thrown when the persisted operation is not found"
              | optional,
            persistedQueryOnly
              | String
              | doc "Error to be thrown when rejecting non-persisted operations"
              | optional,
          },
      "_js2n__-:definitions/EncapsulateTransformApplyTo!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mutation = _js2n__-prdslib.isType '"Bool",
                  query = _js2n__-prdslib.isType '"Bool",
                  subscription = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EncapsulateTransformObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  applyTo =
                    _js2n__-refsenv."_js2n__-:definitions/EncapsulateTransformApplyTo!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ExtendTransform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  resolvers =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  typeDefs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationField!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config", "name" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/FederationFieldConfig!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationFieldConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  external = _js2n__-prdslib.isType '"Bool",
                  inaccessible = _js2n__-prdslib.isType '"Bool",
                  override =
                    _js2n__-refsenv."_js2n__-:definitions/FederationFieldOverrideConfig!predicate",
                  provides =
                    _js2n__-refsenv."_js2n__-:definitions/FederationFieldProvidesConfig!predicate",
                  requires =
                    _js2n__-refsenv."_js2n__-:definitions/FederationFieldRequiresConfig!predicate",
                  tag =
                    _js2n__-refsenv."_js2n__-:definitions/FederationFieldTagConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationFieldOverrideConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { from = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationFieldProvidesConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { fields = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationFieldRequiresConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { fields = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationFieldTagConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationObjectConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extends = _js2n__-prdslib.isType '"Bool",
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FederationField!predicate"
                        ],
                  key =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FederationObjectKeyConfig!predicate"
                        ],
                  resolveReference =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/ResolveReferenceObject!predicate"
                        ],
                  shareable = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationObjectKeyConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { fields = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationTransform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FederationTransformType!predicate"
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FederationTransformType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/FederationObjectConfig!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileCacheConfig!contract" =
        { path | String | optional, },
      "_js2n__-:definitions/FilterHelperArgsOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filterTypeName = _js2n__-prdslib.isType '"String",
                  isRequired = _js2n__-prdslib.isType '"Bool",
                  onlyIndexed = _js2n__-prdslib.isType '"Bool",
                  operators =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                  removeFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requiredFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FilterSchemaTransform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "filters" ],
              _js2n__-prdslib.records.record
                {
                  filterDeprecatedFields = _js2n__-prdslib.isType '"Bool",
                  filterDeprecatedTypes = _js2n__-prdslib.isType '"Bool",
                  filters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bare", "wrap" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GenerateOperationsConfig!contract" =
        { selectionSetDepth | std.number.Integer | optional, },
      "_js2n__-:definitions/GetFromMockStoreConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fieldName = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphQLHandlerCodeFirstConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source" ],
              _js2n__-prdslib.records.record
                {
                  source =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphQLHandlerHTTPConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  batch = _js2n__-prdslib.isType '"Bool",
                  connectionParams = _js2n__-prdslib.isType 'Record,
                  credentials =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "omit", "include" ]
                        ],
                  endpoint = _js2n__-prdslib.isType '"String",
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "GET", "POST" ]
                        ],
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  retry = _js2n__-prdslib.isType 'Integer,
                  schemaHeaders =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  source = _js2n__-prdslib.isType '"String",
                  subscriptionsEndpoint = _js2n__-prdslib.isType '"String",
                  subscriptionsProtocol =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SSE", "WS", "LEGACY_WS" ]
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                  useGETForQueries = _js2n__-prdslib.isType '"Bool",
                  webSocketImpl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphQLHandlerMultipleHTTPConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "sources" ],
              _js2n__-prdslib.records.record
                {
                  sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/GraphQLHandlerHTTPConfiguration!predicate"
                        ],
                  strategy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "fallback", "race", "highestValue" ]
                        ],
                  strategyConfig =
                    _js2n__-refsenv."_js2n__-:definitions/GraphQLHandlerhighestValueStrategyConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GraphQLHandlerhighestValueStrategyConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "selectionSet", "value" ],
              _js2n__-prdslib.records.record
                {
                  selectionSet = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GrpcCredentialsSsl!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  certChain = _js2n__-prdslib.isType '"String",
                  privateKey = _js2n__-prdslib.isType '"String",
                  rootCA = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GrpcHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  credentialsSsl =
                    _js2n__-refsenv."_js2n__-:definitions/GrpcCredentialsSsl!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  metaData = _js2n__-prdslib.isType 'Record,
                  prefixQueryMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requestTimeout = _js2n__-prdslib.isType 'Integer,
                  schemaHeaders = _js2n__-prdslib.isType 'Record,
                  source =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ProtoFilePath!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  useHTTPS = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HTTPCachePlugin!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignores =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/URLPatternObj!predicate"
                              ])
                        ],
                  matches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/URLPatternObj!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HTTPDetailsExtensionsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "if" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HTTPSConfig!contract" =
        { cert | String, key | String, },
      "_js2n__-:definitions/Handler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  graphql =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/GraphQLHandlerHTTPConfiguration!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GraphQLHandlerCodeFirstConfiguration!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/GraphQLHandlerMultipleHTTPConfiguration!predicate"
                        ],
                  grpc =
                    _js2n__-refsenv."_js2n__-:definitions/GrpcHandler!predicate",
                  jsonSchema =
                    _js2n__-refsenv."_js2n__-:definitions/JsonSchemaHandler!predicate",
                  mongoose =
                    _js2n__-refsenv."_js2n__-:definitions/MongooseHandler!predicate",
                  mysql =
                    _js2n__-refsenv."_js2n__-:definitions/MySQLHandler!predicate",
                  neo4j =
                    _js2n__-refsenv."_js2n__-:definitions/Neo4jHandler!predicate",
                  odata =
                    _js2n__-refsenv."_js2n__-:definitions/ODataHandler!predicate",
                  openapi =
                    _js2n__-refsenv."_js2n__-:definitions/OpenapiHandler!predicate",
                  postgraphile =
                    _js2n__-refsenv."_js2n__-:definitions/PostGraphileHandler!predicate",
                  raml =
                    _js2n__-refsenv."_js2n__-:definitions/RAMLHandler!predicate",
                  soap =
                    _js2n__-refsenv."_js2n__-:definitions/SoapHandler!predicate",
                  supergraph =
                    _js2n__-refsenv."_js2n__-:definitions/SupergraphHandler!predicate",
                  thrift =
                    _js2n__-refsenv."_js2n__-:definitions/ThriftHandler!predicate",
                  tuql =
                    _js2n__-refsenv."_js2n__-:definitions/TuqlHandler!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HiveAgentOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  logger =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  maxRetries = _js2n__-prdslib.isType 'Integer,
                  maxSize = _js2n__-prdslib.isType 'Integer,
                  minTimeout = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  sendInterval = _js2n__-prdslib.isType 'Integer,
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HiveClientInfo!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HivePlugin!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "token" ],
              _js2n__-prdslib.records.record
                {
                  agent =
                    _js2n__-refsenv."_js2n__-:definitions/HiveAgentOptions!predicate",
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  reporting =
                    _js2n__-refsenv."_js2n__-:definitions/HiveReportingOptions!predicate",
                  selfHosting =
                    _js2n__-refsenv."_js2n__-:definitions/HiveSelfHostingOptions!predicate",
                  token = _js2n__-prdslib.isType '"String",
                  usage =
                    _js2n__-refsenv."_js2n__-:definitions/HiveUsageOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HiveReportingOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "author", "commit" ],
              _js2n__-prdslib.records.record
                {
                  author = _js2n__-prdslib.isType '"String",
                  commit = _js2n__-prdslib.isType '"String",
                  serviceName = _js2n__-prdslib.isType '"String",
                  serviceUrl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HiveSelfHostingOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "applicationUrl", "graphqlEndpoint" ],
              _js2n__-prdslib.records.record
                {
                  applicationUrl = _js2n__-prdslib.isType '"String",
                  graphqlEndpoint = _js2n__-prdslib.isType '"String",
                  usageEndpoint = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HiveUsageOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clientInfo =
                    _js2n__-refsenv."_js2n__-:definitions/HiveClientInfo!predicate",
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max = _js2n__-prdslib.isType 'Integer,
                  processVariables = _js2n__-prdslib.isType '"Bool",
                  sampleRate = _js2n__-prdslib.isType '"Number",
                  sampler =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  ttl = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HoistFieldTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "newFieldName", "pathConfig", "typeName" ],
              _js2n__-prdslib.records.record
                {
                  alias = _js2n__-prdslib.isType '"String",
                  filterArgsInPath = _js2n__-prdslib.isType '"Bool",
                  newFieldName = _js2n__-prdslib.isType '"String",
                  pathConfig =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/HoistFieldTransformFieldPathConfigObject!predicate"
                              ])
                        ],
                  typeName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HoistFieldTransformFieldPathConfigObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fieldName", "filterArgs" ],
              _js2n__-prdslib.records.record
                {
                  fieldName = _js2n__-prdslib.isType '"String",
                  filterArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonSchemaHTTPOperation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "field", "path", "type" ],
              _js2n__-prdslib.records.record
                {
                  argTypeMap = _js2n__-prdslib.isType 'Record,
                  binary = _js2n__-prdslib.isType '"Bool",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  exposeResponseMetadata = _js2n__-prdslib.isType '"Bool",
                  field = _js2n__-prdslib.isType '"String",
                  headers = _js2n__-prdslib.isType 'Record,
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "GET",
                              "HEAD",
                              "POST",
                              "PUT",
                              "DELETE",
                              "CONNECT",
                              "OPTIONS",
                              "TRACE",
                              "PATCH"
                            ]
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  queryParamArgMap = _js2n__-prdslib.isType 'Record,
                  requestBaseBody =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  requestSample =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  requestSchema =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  requestTypeName = _js2n__-prdslib.isType '"String",
                  responseByStatusCode =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  responseSample =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  responseSchema =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  responseTypeName = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Query", "Mutation", "Subscription" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonSchemaHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endpoint = _js2n__-prdslib.isType '"String",
                  ignoreErrorResponses = _js2n__-prdslib.isType '"Bool",
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  operations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/JsonSchemaHTTPOperation!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/JsonSchemaPubSubOperation!predicate"
                              ])
                        ],
                  queryParams =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  queryStringOptions =
                    _js2n__-refsenv."_js2n__-:definitions/QueryStringOptions!predicate",
                  schemaHeaders = _js2n__-prdslib.isType 'Record,
                  source = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JsonSchemaPubSubOperation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "field", "pubsubTopic", "type" ],
              _js2n__-prdslib.records.record
                {
                  argTypeMap = _js2n__-prdslib.isType 'Record,
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  field = _js2n__-prdslib.isType '"String",
                  pubsubTopic = _js2n__-prdslib.isType '"String",
                  requestBaseBody =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  requestSample =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  requestSchema =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  requestTypeName = _js2n__-prdslib.isType '"String",
                  responseSample =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  responseSchema =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  responseTypeName = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Query", "Mutation", "Subscription" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KeyAnnotation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "selectionSet" ],
              _js2n__-prdslib.records.record
                { selectionSet = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LimitHelperArgsOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { defaultValue = _js2n__-prdslib.isType 'Integer, } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LiveQueryConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  idFieldName = _js2n__-prdslib.isType '"String",
                  includeIdentifierExtension = _js2n__-prdslib.isType '"Bool",
                  indexBy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/LiveQueryIndexBy!predicate"
                        ],
                  invalidations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/LiveQueryInvalidation!predicate"
                        ],
                  resourceIdentifier = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LiveQueryIndexBy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "args", "field" ],
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  field = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LiveQueryInvalidation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "field", "invalidate" ],
              _js2n__-prdslib.records.record
                {
                  field = _js2n__-prdslib.isType '"String",
                  invalidate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LoadOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaults = _js2n__-prdslib.isType '"Bool",
                  includeDirs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocalforageConfig!contract" =
        {
            description | String | optional,
            driver
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "WEBSQL", "INDEXEDDB", "LOCALSTORAGE" ]
                        ])
                  ])
              | doc "Allowed values: WEBSQL, INDEXEDDB, LOCALSTORAGE"
              | optional,
            name | String | optional,
            size | std.number.Integer | optional,
            storeName | String | optional,
            version | Number | optional,
          },
      "_js2n__-:definitions/MaskedErrorsPluginConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { errorMessage = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MergedRootFieldConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "queryFieldName" ],
              _js2n__-prdslib.records.record
                {
                  additionalArgs = _js2n__-prdslib.isType '"String",
                  argsExpr = _js2n__-prdslib.isType '"String",
                  key =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  keyArg = _js2n__-prdslib.isType '"String",
                  keyField = _js2n__-prdslib.isType '"String",
                  queryFieldName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MergedTypeConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  canonical = _js2n__-prdslib.isType '"Bool",
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MergedTypeField!predicate"
                        ],
                  key =
                    _js2n__-refsenv."_js2n__-:definitions/KeyAnnotation!predicate",
                  typeName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MergedTypeField!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fieldName" ],
              _js2n__-prdslib.records.record
                {
                  computed =
                    _js2n__-refsenv."_js2n__-:definitions/ComputedAnnotation!predicate",
                  fieldName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MockingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "if" = _js2n__-prdslib.isType '"Bool",
                  initializeStore =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  mocks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MockingFieldConfig!predicate"
                        ],
                  preserveResolvers = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MockingFieldConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apply" ],
              _js2n__-prdslib.records.record
                {
                  apply = _js2n__-prdslib.isType '"String",
                  custom = _js2n__-prdslib.isType '"String",
                  faker = _js2n__-prdslib.isType '"String",
                  "if" = _js2n__-prdslib.isType '"Bool",
                  length = _js2n__-prdslib.isType 'Integer,
                  store =
                    _js2n__-refsenv."_js2n__-:definitions/GetFromMockStoreConfig!predicate",
                  updateStore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/UpdateMockStoreConfig!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MongooseHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connectionString = _js2n__-prdslib.isType '"String",
                  discriminators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MongooseModel!predicate"
                        ],
                  models =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MongooseModel!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MongooseModel!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseOpts!predicate",
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MySQLHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  database = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  localAddress = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  pool =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  port = _js2n__-prdslib.isType 'Integer,
                  ssl =
                    _js2n__-refsenv."_js2n__-:definitions/MySQLSSLOptions!predicate",
                  tableFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TableField!predicate"
                        ],
                  tables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MySQLSSLOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ca = _js2n__-prdslib.isType '"String",
                  rejectUnauthorized = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NamingConventionTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enumValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "camelCase",
                              "capitalCase",
                              "constantCase",
                              "dotCase",
                              "headerCase",
                              "noCase",
                              "paramCase",
                              "pascalCase",
                              "pathCase",
                              "sentenceCase",
                              "snakeCase",
                              "upperCase",
                              "lowerCase"
                            ]
                        ],
                  fieldArgumentNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "camelCase",
                              "capitalCase",
                              "constantCase",
                              "dotCase",
                              "headerCase",
                              "noCase",
                              "paramCase",
                              "pascalCase",
                              "pathCase",
                              "sentenceCase",
                              "snakeCase",
                              "upperCase",
                              "lowerCase"
                            ]
                        ],
                  fieldNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "camelCase",
                              "capitalCase",
                              "constantCase",
                              "dotCase",
                              "headerCase",
                              "noCase",
                              "paramCase",
                              "pascalCase",
                              "pathCase",
                              "sentenceCase",
                              "snakeCase",
                              "upperCase",
                              "lowerCase"
                            ]
                        ],
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bare", "wrap" ]
                        ],
                  typeNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "camelCase",
                              "capitalCase",
                              "constantCase",
                              "dotCase",
                              "headerCase",
                              "noCase",
                              "paramCase",
                              "pascalCase",
                              "pathCase",
                              "sentenceCase",
                              "snakeCase",
                              "upperCase",
                              "lowerCase"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Neo4jHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "endpoint", "password", "username" ],
              _js2n__-prdslib.records.record
                {
                  alwaysIncludeRelationships = _js2n__-prdslib.isType '"Bool",
                  database = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  source = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NewrelicConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extractOperationName = _js2n__-prdslib.isType '"String",
                  includeExecuteVariables = _js2n__-prdslib.isType '"Bool",
                  includeOperationDocument = _js2n__-prdslib.isType '"Bool",
                  includeRawResult = _js2n__-prdslib.isType '"Bool",
                  includeResolverArgs = _js2n__-prdslib.isType '"Bool",
                  rootFieldsNaming = _js2n__-prdslib.isType '"Bool",
                  trackResolvers = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OASSelectQueryOrMutationFieldConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fieldName", "type" ],
              _js2n__-prdslib.records.record
                {
                  fieldName = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "query", "mutation", "Query", "Mutation" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ODataHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  batch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "multipart", "json" ]
                        ],
                  endpoint = _js2n__-prdslib.isType '"String",
                  expandNavProps = _js2n__-prdslib.isType '"Bool",
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  schemaHeaders = _js2n__-prdslib.isType 'Record,
                  source = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OpenapiHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source" ],
              _js2n__-prdslib.records.record
                {
                  endpoint = _js2n__-prdslib.isType '"String",
                  fallbackFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "json", "yaml", "js", "ts" ]
                        ],
                  ignoreErrorResponses = _js2n__-prdslib.isType '"Bool",
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  queryParams = _js2n__-prdslib.isType 'Record,
                  schemaHeaders = _js2n__-prdslib.isType 'Record,
                  selectQueryOrMutationField =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/OASSelectQueryOrMutationFieldConfig!predicate"
                        ],
                  source = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OperationFieldPermission!predicate" =
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
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "if" = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OperationFieldPermissionsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  permissions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/OperationFieldPermission!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PaginationResolverOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { perPage = _js2n__-prdslib.isType 'Integer, } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PersistedOperationsConfig!contract" =
        {
            allowArbitraryOperations
              | Bool
              | doc "Whether to allow execution of arbitrary GraphQL operations aside from persisted operations."
              | optional,
            customErrors
              | _js2n__-refsenv."_js2n__-:definitions/CustomPersistedQueryErrors!contract"
              | doc "Custom errors to be thrown"
              | optional,
            skipDocumentValidation
              | Bool
              | doc "Whether to skip validation of the persisted operation"
              | optional,
          },
      "_js2n__-:definitions/Plugin!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deduplicateRequest =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  hive =
                    _js2n__-refsenv."_js2n__-:definitions/HivePlugin!predicate",
                  httpCache =
                    _js2n__-refsenv."_js2n__-:definitions/HTTPCachePlugin!predicate",
                  httpDetailsExtensions =
                    _js2n__-refsenv."_js2n__-:definitions/HTTPDetailsExtensionsConfig!predicate",
                  immediateIntrospection =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  liveQuery =
                    _js2n__-refsenv."_js2n__-:definitions/LiveQueryConfig!predicate",
                  maskedErrors =
                    _js2n__-refsenv."_js2n__-:definitions/MaskedErrorsPluginConfig!predicate",
                  mock =
                    _js2n__-refsenv."_js2n__-:definitions/MockingConfig!predicate",
                  newrelic =
                    _js2n__-refsenv."_js2n__-:definitions/NewrelicConfig!predicate",
                  operationFieldPermissions =
                    _js2n__-refsenv."_js2n__-:definitions/OperationFieldPermissionsConfig!predicate",
                  prometheus =
                    _js2n__-refsenv."_js2n__-:definitions/PrometheusConfig!predicate",
                  rateLimit =
                    _js2n__-refsenv."_js2n__-:definitions/RateLimitPluginConfig!predicate",
                  responseCache =
                    _js2n__-refsenv."_js2n__-:definitions/ResponseCacheConfig!predicate",
                  snapshot =
                    _js2n__-refsenv."_js2n__-:definitions/SnapshotPluginConfig!predicate",
                  statsd =
                    _js2n__-refsenv."_js2n__-:definitions/StatsdPlugin!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PostGraphileHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appendPlugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  connectionString = _js2n__-prdslib.isType '"String",
                  contextOptions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  live = _js2n__-prdslib.isType '"Bool",
                  options =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                  pool =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  schemaName =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipPlugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  subscriptions = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PrefixTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includeRootOperations = _js2n__-prdslib.isType '"Bool",
                  includeTypes = _js2n__-prdslib.isType '"Bool",
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bare", "wrap" ]
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PrometheusConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  contextBuilding =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  delegation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  delegationArgs = _js2n__-prdslib.isType '"Bool",
                  delegationKey = _js2n__-prdslib.isType '"Bool",
                  deprecatedFields =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  endpoint =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  errors =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  execute =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  fetchMetrics =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  fetchRequestHeaders = _js2n__-prdslib.isType '"Bool",
                  fetchResponseHeaders = _js2n__-prdslib.isType '"Bool",
                  http =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  httpRequestHeaders = _js2n__-prdslib.isType '"Bool",
                  httpResponseHeaders = _js2n__-prdslib.isType '"Bool",
                  parse =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  registry = _js2n__-prdslib.isType '"String",
                  requestCount =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  requestSummary =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  requestTotalDuration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  skipIntrospection = _js2n__-prdslib.isType '"Bool",
                  subgraphExecute =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  validate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProtoFilePath!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  file = _js2n__-prdslib.isType '"String",
                  load =
                    _js2n__-refsenv."_js2n__-:definitions/LoadOptions!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PruneTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  skipEmptyCompositeTypePruning =
                    _js2n__-prdslib.isType '"Bool",
                  skipEmptyUnionPruning = _js2n__-prdslib.isType '"Bool",
                  skipPruning =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipUnimplementedInterfacesPruning =
                    _js2n__-prdslib.isType '"Bool",
                  skipUnusedTypesPruning = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PubSubConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/QueryStringOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arrayFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "indices", "brackets", "repeat", "comma" ]
                        ],
                  commaRoundTrip = _js2n__-prdslib.isType '"Bool",
                  indices = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RAMLHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source" ],
              _js2n__-prdslib.records.record
                {
                  endpoint = _js2n__-prdslib.isType '"String",
                  ignoreErrorResponses = _js2n__-prdslib.isType '"Bool",
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  queryParams =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  schemaHeaders = _js2n__-prdslib.isType 'Record,
                  selectQueryOrMutationField =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RAMLSelectQueryOrMutationFieldConfig!predicate"
                        ],
                  source = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RAMLSelectQueryOrMutationFieldConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fieldName", "type" ],
              _js2n__-prdslib.records.record
                {
                  fieldName = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "query", "mutation", "Query", "Mutation" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RateLimitPluginConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config" ],
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RateLimitTransformConfig!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RateLimitTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "field", "identifier", "max", "ttl", "type" ],
              _js2n__-prdslib.records.record
                {
                  field = _js2n__-prdslib.isType '"String",
                  identifier = _js2n__-prdslib.isType '"String",
                  max = _js2n__-prdslib.isType 'Integer,
                  ttl = _js2n__-prdslib.isType 'Integer,
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RecordHelperArgsOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  isRequired = _js2n__-prdslib.isType '"Bool",
                  recordTypeName = _js2n__-prdslib.isType '"String",
                  removeFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requiredFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RedisConfig!contract" =
        {
            host | String | optional,
            lazyConnect
              | Bool
              | doc m%"
                Flag to indicate lazyConnect value for Redis client.
                
                @default: true
              "%
              | optional,
            password | String | optional,
            port | String | optional,
            url | String | optional,
          },
      "_js2n__-:definitions/RenameConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  argument = _js2n__-prdslib.isType '"String",
                  field = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RenameTransform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "renames" ],
              _js2n__-prdslib.records.record
                {
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bare", "wrap" ]
                        ],
                  renames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RenameTransformObject!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RenameTransformObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/RenameConfig!predicate",
                  includeDefaults = _js2n__-prdslib.isType '"Bool",
                  regExpFlags = _js2n__-prdslib.isType '"String",
                  to =
                    _js2n__-refsenv."_js2n__-:definitions/RenameConfig!predicate",
                  useRegExpForArguments = _js2n__-prdslib.isType '"Bool",
                  useRegExpForFields = _js2n__-prdslib.isType '"Bool",
                  useRegExpForTypes = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReplaceFieldConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "field", "type" ],
              _js2n__-prdslib.records.record
                {
                  field = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReplaceFieldTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "replacements" ],
              _js2n__-prdslib.records.record
                {
                  replacements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ReplaceFieldTransformObject!predicate"
                        ],
                  typeDefs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReplaceFieldTransformObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  composer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  from =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceFieldConfig!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  scope =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "config", "hoistValue" ]
                        ],
                  to =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceFieldConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResolveReferenceObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "queryFieldName" ],
              _js2n__-prdslib.records.record
                {
                  args = _js2n__-prdslib.isType 'Record,
                  queryFieldName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResolversCompositionTransform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "compositions" ],
              _js2n__-prdslib.records.record
                {
                  compositions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ResolversCompositionTransformObject!predicate"
                        ],
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "bare", "wrap" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResolversCompositionTransformObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "composer", "resolver" ],
              _js2n__-prdslib.records.record
                {
                  composer =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  resolver = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResponseCacheConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cacheKey = _js2n__-prdslib.isType '"String",
                  idFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "if" = _js2n__-prdslib.isType '"String",
                  ignoredTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includeExtensionMetadata = _js2n__-prdslib.isType '"Bool",
                  invalidateViaMutation = _js2n__-prdslib.isType '"Bool",
                  sessionId = _js2n__-prdslib.isType '"String",
                  shouldCacheResult = _js2n__-prdslib.isType '"String",
                  ttl = _js2n__-prdslib.isType '"Number",
                  ttlPerCoordinate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ResponseCacheTTLConfig!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResponseCacheTTLConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "coordinate", "ttl" ],
              _js2n__-prdslib.records.record
                {
                  coordinate = _js2n__-prdslib.isType '"String",
                  ttl = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SDKConfig!contract" =
        {
            generateOperations
              | _js2n__-refsenv."_js2n__-:definitions/GenerateOperationsConfig!contract"
              | doc m%"
                Use this only if you don't want to use `documents` for SDK,
                and let Mesh generate them for you
              "%
              | optional,
          },
      "_js2n__-:definitions/ServeConfig!contract" =
        {
            batchingLimit
              | std.number.Integer
              | doc "Enable and define a limit for [Request Batching](https://github.com/graphql/graphql-over-http/blob/main/rfcs/Batching.md)"
              | optional,
            browser
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | doc m%"
                Path to the browser that will be used by `mesh serve` to open a playground window in development mode
                This feature can be disabled by passing `false` (Any of: String, Boolean)
              "%
              | optional,
            cors
              | _js2n__-refsenv."_js2n__-:definitions/CorsConfig!contract"
              | doc "Configuration for CORS"
              | optional,
            endpoint
              | String
              | doc "Path to GraphQL Endpoint (default: /graphql)"
              | optional,
            fork
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | doc "Spawn multiple server instances as node clusters (default: `1`) (Any of: Int, Boolean)"
              | optional,
            healthCheckEndpoint
              | String
              | doc "Endpoint for [Health Check](https://the-guild.dev/graphql/yoga-server/docs/features/health-check)"
              | optional,
            hostname
              | String
              | doc "The binding hostname (default: `localhost`)"
              | optional,
            playground | Bool | doc "Show GraphiQL Playground" | optional,
            playgroundTitle
              | String
              | doc "Title of GraphiQL Playground"
              | optional,
            port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "TCP Port to listen (default: `4000`) (Any of: Int, String)"
              | optional,
            sslCredentials
              | _js2n__-refsenv."_js2n__-:definitions/HTTPSConfig!contract"
              | doc m%"
                SSL Credentials for HTTPS Server
                If this is provided, Mesh will be served via HTTPS
              "%
              | optional,
            staticFiles
              | String
              | doc "Path to your static files you want to be served with GraphQL Mesh HTTP Server"
              | optional,
            trustProxy
              | String
              | doc m%"
                Configure Express Proxy Handling
                [Learn more](https://expressjs.com/en/guide/behind-proxies.html)
              "%
              | optional,
          },
      "_js2n__-:definitions/SnapshotPluginConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apply", "outputDir" ],
              _js2n__-prdslib.records.record
                {
                  apply =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "if" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  outputDir = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SoapHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source" ],
              _js2n__-prdslib.records.record
                {
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  schemaHeaders =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  source = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SortHelperArgsOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { sortTypeName = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Source!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "handler", "name" ],
              _js2n__-prdslib.records.record
                {
                  handler =
                    _js2n__-refsenv."_js2n__-:definitions/Handler!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  transforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Transform!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StatsdClientBufferHolder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "buffer" ],
              _js2n__-prdslib.records.record
                { buffer = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StatsdClientConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bufferFlushInterval = _js2n__-prdslib.isType 'Integer,
                  bufferHolder =
                    _js2n__-refsenv."_js2n__-:definitions/StatsdClientBufferHolder!predicate",
                  cacheDns = _js2n__-prdslib.isType '"Bool",
                  cacheDnsTtl = _js2n__-prdslib.isType 'Integer,
                  closingFlushInterval = _js2n__-prdslib.isType 'Integer,
                  globalTags = _js2n__-prdslib.isType 'Record,
                  globalize = _js2n__-prdslib.isType '"Bool",
                  host = _js2n__-prdslib.isType '"String",
                  isChild = _js2n__-prdslib.isType '"Bool",
                  maxBufferSize = _js2n__-prdslib.isType 'Integer,
                  mock = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  protocol =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tcp", "udp", "uds", "stream" ]
                        ],
                  sampleRate = _js2n__-prdslib.isType '"Number",
                  suffix = _js2n__-prdslib.isType '"String",
                  tagPrefix = _js2n__-prdslib.isType '"String",
                  tagSeperator = _js2n__-prdslib.isType '"String",
                  tcpGracefulErrorHandling = _js2n__-prdslib.isType '"Bool",
                  tcpGracefulRestartRateLimit = _js2n__-prdslib.isType 'Integer,
                  telegraf = _js2n__-prdslib.isType '"Bool",
                  udsGracefulErrorHandling = _js2n__-prdslib.isType '"Bool",
                  udsGracefulRestartRateLimit = _js2n__-prdslib.isType 'Integer,
                  useDefaultRoute = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StatsdPlugin!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  client =
                    _js2n__-refsenv."_js2n__-:definitions/StatsdClientConfiguration!predicate",
                  prefix = _js2n__-prdslib.isType '"String",
                  skipIntrospection = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SubgraphConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  connectionParams = _js2n__-prdslib.isType 'Record,
                  credentials =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "omit", "include" ]
                        ],
                  endpoint = _js2n__-prdslib.isType '"String",
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "GET", "POST" ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  retry = _js2n__-prdslib.isType 'Integer,
                  source = _js2n__-prdslib.isType '"String",
                  subscriptionsEndpoint = _js2n__-prdslib.isType '"String",
                  subscriptionsProtocol =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SSE", "WS", "LEGACY_WS" ]
                        ],
                  timeout = _js2n__-prdslib.isType 'Integer,
                  useGETForQueries = _js2n__-prdslib.isType '"Bool",
                  webSocketImpl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SupergraphHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "source" ],
              _js2n__-prdslib.records.record
                {
                  batch = _js2n__-prdslib.isType '"Bool",
                  operationHeaders =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  schemaHeaders =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  source = _js2n__-prdslib.isType '"String",
                  subgraphs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SubgraphConfiguration!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TableField!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fields", "table" ],
              _js2n__-prdslib.records.record
                {
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  table = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ThriftHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "hostName", "idl", "port", "serviceName" ],
              _js2n__-prdslib.records.record
                {
                  hostName = _js2n__-prdslib.isType '"String",
                  https = _js2n__-prdslib.isType '"Bool",
                  idl = _js2n__-prdslib.isType '"String",
                  operationHeaders = _js2n__-prdslib.isType 'Record,
                  path = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  protocol =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "binary", "compact", "json" ]
                        ],
                  schemaHeaders = _js2n__-prdslib.isType 'Record,
                  serviceName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TransferSchemaTransformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "transfers" ],
              _js2n__-prdslib.records.record
                {
                  transfers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TransferSchemaTransformObject!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TransferSchemaTransformObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "to" ],
              _js2n__-prdslib.records.record
                {
                  action =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "move", "copy" ]
                        ],
                  from = _js2n__-prdslib.isType '"String",
                  to = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Transform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CacheTransformConfig!predicate"
                        ],
                  encapsulate =
                    _js2n__-refsenv."_js2n__-:definitions/EncapsulateTransformObject!predicate",
                  extend =
                    _js2n__-refsenv."_js2n__-:definitions/ExtendTransform!predicate",
                  federation =
                    _js2n__-refsenv."_js2n__-:definitions/FederationTransform!predicate",
                  filterSchema =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/FilterSchemaTransform!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ]
                        ],
                  hoistField =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HoistFieldTransformConfig!predicate"
                        ],
                  namingConvention =
                    _js2n__-refsenv."_js2n__-:definitions/NamingConventionTransformConfig!predicate",
                  prefix =
                    _js2n__-refsenv."_js2n__-:definitions/PrefixTransformConfig!predicate",
                  prune =
                    _js2n__-refsenv."_js2n__-:definitions/PruneTransformConfig!predicate",
                  rateLimit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RateLimitTransformConfig!predicate"
                        ],
                  rename =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RenameTransform!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ]
                        ],
                  replaceField =
                    _js2n__-refsenv."_js2n__-:definitions/ReplaceFieldTransformConfig!predicate",
                  resolversComposition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ResolversCompositionTransform!predicate",
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ]
                        ],
                  transferSchema =
                    _js2n__-refsenv."_js2n__-:definitions/TransferSchemaTransformConfig!predicate",
                  typeMerging =
                    _js2n__-refsenv."_js2n__-:definitions/TypeMergingConfig!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TuqlHandler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  db = _js2n__-prdslib.isType '"String",
                  infile = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TypeConverterResolversOpts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connection =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                  count =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  createMany =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  createOne =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  findById =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  findByIds =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  findMany =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  findOne =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  pagination =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/PaginationResolverOpts!predicate"
                        ],
                  removeById =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  removeMany =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  removeOne =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  updateById =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  updateMany =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                  updateOne =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/ComposeWithMongooseResolverOpts!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TypeMergingConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additionalConfiguration =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  queryFields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MergedRootFieldConfig!predicate"
                        ],
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MergedTypeConfig!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/URLPatternObj!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  baseURL = _js2n__-prdslib.isType '"String",
                  hash = _js2n__-prdslib.isType '"String",
                  hostname = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  pathname = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType '"String",
                  protocol = _js2n__-prdslib.isType '"String",
                  search = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UpdateMockStoreConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fieldName = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      additionalEnvelopPlugins
        | String
        | doc "Path to a JavaScript file with a default export of Envelop plugins"
        | optional,
      additionalResolvers
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-refsenv."_js2n__-:definitions/AdditionalStitchingResolverObject!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/AdditionalStitchingBatchResolverObject!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/AdditionalSubscriptionObject!predicate"
                  ])
            ])
        | doc "Additional resolvers, or resolvers overrides you wish to add to the schema mesh (Any of: String, AdditionalStitchingResolverObject, AdditionalStitchingBatchResolverObject, AdditionalSubscriptionObject)"
        | optional,
      additionalTypeDefs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Array"
            ])
        | doc "Additional type definitions, or type definitions overrides you wish to add to the schema mesh"
        | optional,
      cache
        | _js2n__-refsenv."_js2n__-:definitions/Cache!contract"
        | doc "Backend cache"
        | optional,
      codegen
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Array"
            ])
        | doc "Codegen Configuration"
        | optional,
      customFetch
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Array"
            ])
        | doc "Path to a custom W3 Compatible Fetch Implementation"
        | optional,
      documents
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          Provide a query or queries for GraphQL Playground, validation and SDK Generation
          The value can be the file path, glob expression for the file paths or the SDL.
          (.js, .jsx, .graphql, .gql, .ts and .tsx files are supported.
        "%
        | optional,
      logger
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Array"
            ])
        | doc "Logger instance that matches `Console` interface of NodeJS"
        | optional,
      merger | String | doc "Merge method" | optional,
      persistedOperations
        | _js2n__-refsenv."_js2n__-:definitions/PersistedOperationsConfig!contract"
        | doc "Configure persisted operations options"
        | optional,
      plugins
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Plugin!predicate"
            ])
        | optional,
      pollingInterval
        | std.number.Integer
        | doc "If you are using a CDN for a source (e.g. Federation Supergraph), this will be the polling interval in milliseconds for the CDN without a downtime"
        | optional,
      pubsub
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/PubSubConfig!predicate"
            ])
        | doc "PubSub Implementation (Any of: String, PubSubConfig)"
        | optional,
      require
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | optional,
      sdk
        | _js2n__-refsenv."_js2n__-:definitions/SDKConfig!contract"
        | doc "SDK Configuration"
        | optional,
      serve
        | _js2n__-refsenv."_js2n__-:definitions/ServeConfig!contract"
        | doc m%"
          Configuration for `mesh start` or `mesh dev` command.
          Those commands won't be available in programmatic usage.
        "%
        | optional,
      skipSSLValidation
        | Bool
        | doc "Allow connections to an SSL endpoint without certificates"
        | optional,
      sources
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Source!predicate"
            ])
        | doc "Defines the list of your external data sources for your API mesh",
      transforms
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Transform!predicate"
            ])
        | doc "Transform to apply to the unified mesh schema"
        | optional,
    }