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
      "_js2n__-:definitions/cascade!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aliases =
                    _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!predicate",
                  audio =
                    _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!predicate",
                  date =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  draft = _js2n__-prdslib.isType '"Bool",
                  expiryDate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  headless = _js2n__-prdslib.isType '"Bool",
                  images =
                    _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!predicate",
                  isCJKLanguage = _js2n__-prdslib.isType '"Bool",
                  keywords =
                    _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!predicate",
                  lastmod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  layout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  linkTitle =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  markup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "rst", "md" ]
                        ],
                  outputs =
                    _js2n__-refsenv."_js2n__-:definitions/outputFormats!predicate",
                  publishDate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              name =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              params =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                              title =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  series =
                    _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!predicate",
                  slug =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  summary =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  videos =
                    _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!predicate",
                  weight = _js2n__-prdslib.isType 'Integer,
                }
                {
                  "^(?!aliases|audio|date|description|draft|expiryDate|headless|images|isCJKLanguage|keywords|layout|lastmod|linkTitle|markup|outputs|publishDate|resources|series|slug|summary|title|type|url|videos|weight)$" =
                    _js2n__-prdslib.always,
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/hugoVersion!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^\\d+\\.\\d+\\.\\d+.*$"
              ]),
      "_js2n__-:definitions/mergeType!contract"
        | doc m%"
          Merge configuration from themes
          https://gohugo.io/getting-started/configuration/#merge-configuration-from-themes
        "%
        = std.contract.Sequence
            [ std.enum.TagOrString, [| 'deep, 'shallow, 'none |] ],
      "_js2n__-:definitions/mergeType!predicate"
        | doc m%"
          Merge configuration from themes
          https://gohugo.io/getting-started/configuration/#merge-configuration-from-themes
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "none", "shallow", "deep" ]
            ],
      "_js2n__-:definitions/mounts!contract" =
        Array
            {
              disableWatch
                | Bool
                | doc m%"
                  Whether to disable watching
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                "%
                | optional,
              excludeFiles
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ]
                    ])
                | doc m%"
                  The excluded files
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                "%
                | optional,
              includeFiles
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ]
                    ])
                | doc m%"
                  The included files
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                "%
                | optional,
              lang
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ])
                | doc m%"
                  The language code
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                "%
                | optional,
              source
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ])
                | doc m%"
                  The source path
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                "%,
              target
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ])
                | doc m%"
                  The target path
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                "%,
            },
      "_js2n__-:definitions/outputFormats!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          baseName = _js2n__-prdslib.isType '"String",
                          isHTML = _js2n__-prdslib.isType '"Bool",
                          isPlainText = _js2n__-prdslib.isType '"Bool",
                          mediaType =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "application/json",
                                      "application/manifest+json",
                                      "application/octet-stream",
                                      "application/pdf",
                                      "application/rss+xml",
                                      "application/toml",
                                      "application/wasm",
                                      "application/xml",
                                      "application/yaml",
                                      "font/otf",
                                      "font/ttf",
                                      "image/bmp",
                                      "image/gif",
                                      "image/jpeg",
                                      "image/png",
                                      "image/svg+xml",
                                      "image/tiff",
                                      "image/webp",
                                      "text/calendar",
                                      "text/css",
                                      "text/csv",
                                      "text/html",
                                      "text/javascript",
                                      "text/jsx",
                                      "text/markdown",
                                      "text/plain",
                                      "text/tsx",
                                      "text/typescript",
                                      "text/x-sass",
                                      "text/x-scss",
                                      "video/3gpp",
                                      "video/mp4",
                                      "video/mpeg",
                                      "video/ogg",
                                      "video/webm",
                                      "video/x-msvideo"
                                    ]
                                ],
                          name =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.minLength 1
                                ],
                          noUgly = _js2n__-prdslib.isType '"Bool",
                          notAlternative = _js2n__-prdslib.isType '"Bool",
                          path =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.minLength 1
                                ],
                          permalinkable = _js2n__-prdslib.isType '"Bool",
                          protocol = _js2n__-prdslib.isType '"String",
                          rel = _js2n__-prdslib.isType '"String",
                          weight = _js2n__-prdslib.isType 'Integer,
                        } {} false _js2n__-prdslib.never
                    ])
              ]),
      "_js2n__-:definitions/outputFormats!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        baseName = _js2n__-prdslib.isType '"String",
                        isHTML = _js2n__-prdslib.isType '"Bool",
                        isPlainText = _js2n__-prdslib.isType '"Bool",
                        mediaType =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "application/json",
                                    "application/manifest+json",
                                    "application/octet-stream",
                                    "application/pdf",
                                    "application/rss+xml",
                                    "application/toml",
                                    "application/wasm",
                                    "application/xml",
                                    "application/yaml",
                                    "font/otf",
                                    "font/ttf",
                                    "image/bmp",
                                    "image/gif",
                                    "image/jpeg",
                                    "image/png",
                                    "image/svg+xml",
                                    "image/tiff",
                                    "image/webp",
                                    "text/calendar",
                                    "text/css",
                                    "text/csv",
                                    "text/html",
                                    "text/javascript",
                                    "text/jsx",
                                    "text/markdown",
                                    "text/plain",
                                    "text/tsx",
                                    "text/typescript",
                                    "text/x-sass",
                                    "text/x-scss",
                                    "video/3gpp",
                                    "video/mp4",
                                    "video/mpeg",
                                    "video/ogg",
                                    "video/webm",
                                    "video/x-msvideo"
                                  ]
                              ],
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        noUgly = _js2n__-prdslib.isType '"Bool",
                        notAlternative = _js2n__-prdslib.isType '"Bool",
                        path =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        permalinkable = _js2n__-prdslib.isType '"Bool",
                        protocol = _js2n__-prdslib.isType '"String",
                        rel = _js2n__-prdslib.isType '"String",
                        weight = _js2n__-prdslib.isType 'Integer,
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/permalinkConfiguration!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-refsenv."_js2n__-:definitions/permalinkDefinition!predicate",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-refsenv."_js2n__-:definitions/permalinkDefinition!predicate"
                  ]
              ]),
      "_js2n__-:definitions/permalinkDefinition!predicate"
        | doc "A permalink"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/uniqueStringArray!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ]),
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/uniqueStringArray!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  {
      archetypeDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The directory to store archetype files
          https://gohugo.io/getting-started/configuration/#archetypedir
        "%
        | optional,
      assetDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The directory to store asset files
          https://gohugo.io/getting-started/configuration/#assetdir
        "%
        | optional,
      baseURL
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The hostname and the path to the root
          https://gohugo.io/getting-started/configuration/#baseurl
        "%
        | optional,
      build
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          buildStats
            | {
              disableClasses | Bool | optional,
              disableIDs | Bool | optional,
              disableTags | Bool | optional,
              enable | Bool | optional,
              ..
            }
            | doc m%"
              When enabled, creates a hugo_stats.json file in the root of your project.
              https://gohugo.io/getting-started/configuration/#configure-build
            "%
            | optional,
          cachebusters
            | Array { source | String | optional, target | String | optional, }
            | doc m%"
              Cache busters to support development using Tailwind 3.x's JIT compiler
              https://gohugo.io/getting-started/configuration/#configure-cache-busters
            "%
            | optional,
          noJSConfigInAssets
            | Bool
            | doc m%"
              Enable/disable `jsconfig.json` writing into your `/assets` folder with mapping of imports from running `js.Build`
              https://gohugo.io/getting-started/configuration/#configure-build
            "%
            | optional,
          useResourceCacheWhen
            | std.enum.TagOrString
            | [| 'fallback, 'always, 'never |]
            | doc m%"
              The time when to use the cached resources in `/resources/_gen` for `PostCSS` and `ToCSS`
              https://gohugo.io/getting-started/configuration/#configure-build
            "%
            | optional,
          writeStats
            | Bool
            | doc m%"
              Enable/disable `hugo_stats.json` writing to the root project directory.
              Although still functional, the writeStats key will be deprecated in a future release.
              https://gohugo.io/getting-started/configuration/#configure-build
            "%
            | optional,
        }
        | doc m%"
          The build options
          https://gohugo.io/getting-started/configuration/#configure-build
        "%
        | optional,
      buildDrafts
        | Bool
        | doc m%"
          Include/exclude the drafts when building
          https://gohugo.io/getting-started/configuration/#builddrafts-false
        "%
        | optional,
      buildExpired
        | Bool
        | doc m%"
          Include/exclude the content already expired
          https://gohugo.io/getting-started/configuration/#buildexpired
        "%
        | optional,
      buildFuture
        | Bool
        | doc m%"
          Include/exclude the content with `publishDate` in the future
          https://gohugo.io/getting-started/configuration/#buildfuture
        "%
        | optional,
      caches
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _merge =
                    _js2n__-refsenv."_js2n__-:definitions/mergeType!predicate",
                } {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        dir =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ],
                        maxAge =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.numbers.minimum (-1)
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern
                                      "^-?\\d+[smh]?$"
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
            ])
        | doc m%"
          The cache options
          https://gohugo.io/getting-started/configuration/#configure-file-caches
        "%
        | optional,
      canonifyURLs
        | Bool
        | doc m%"
          Enable/disable relative URLs to absolute conversion
          https://gohugo.io/getting-started/configuration/#canonifyurls
        "%
        | optional,
      cascade
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-refsenv."_js2n__-:definitions/cascade!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.record
                              {
                                _target =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            kind =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                            lang =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                            path =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always,
                            _js2n__-refsenv."_js2n__-:definitions/cascade!predicate"
                          ],
                        _js2n__-prdslib.records.required [ "_target" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ])
                ]
            ])
        | doc m%"
          The front matter options
          https://gohugo.io/content-management/front-matter#front-matter-cascade
        "%
        | optional,
      contentDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The directory where content files are stored
          https://gohugo.io/getting-started/configuration/#contentdir
        "%
        | optional,
      copyright
        | String
        | doc m%"
          The copyright notice for your site
          https://gohugo.io/getting-started/configuration/#copyright
        "%
        | optional,
      dataDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The directory where data files are stored
          https://gohugo.io/getting-started/configuration/#datadir
        "%
        | optional,
      defaultContentLanguage
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The default content language for the content without language indicator
          https://gohugo.io/getting-started/configuration/#defaultcontentlanguage
        "%
        | optional,
      defaultContentLanguageInSubdir
        | Bool
        | doc m%"
          Enable/disable rendering the default content language in subdir
          https://gohugo.io/getting-started/configuration/#defaultcontentlanguageinsubdir
        "%
        | optional,
      disableAliases
        | Bool
        | doc m%"
          Enable/disable generation of the alias redirects
          https://gohugo.io/getting-started/configuration/#disablealiases
        "%
        | optional,
      disableHugoGeneratorInject
        | Bool
        | doc m%"
          Enable/disable injecting a generator meta tag in the HTML head on the home page only
          https://gohugo.io/getting-started/configuration/#disablehugogeneratorinject
        "%
        | optional,
      disableKinds
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
                        "page",
                        "home",
                        "section",
                        "taxonomy",
                        "term",
                        "RSS",
                        "sitemap",
                        "robotsTXT",
                        "404"
                      ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Disabled kinds of pages
          https://gohugo.io/getting-started/configuration/#disablekinds
        "%
        | optional,
      disableLanguages
        | _js2n__-refsenv."_js2n__-:definitions/uniqueStringArray!contract"
        | doc m%"
          The disabled languages
          https://gohugo.io/content-management/multilingual/#disable-a-language
        "%
        | optional,
      disableLiveReload
        | Bool
        | doc m%"
          Enable/disable automatic live reloading of browser window
          https://gohugo.io/getting-started/configuration/#disablelivereload
        "%
        | optional,
      disablePathToLower
        | Bool
        | doc m%"
          Enable/disable the url/path to lowercase conversion
          https://gohugo.io/getting-started/configuration/#disablepathtolower
        "%
        | optional,
      enableEmoji
        | Bool
        | doc m%"
          Enable/disable Emoji emoticons support for page content
          https://gohugo.io/getting-started/configuration/#enableemoji
        "%
        | optional,
      enableGitInfo
        | Bool
        | doc m%"
          Enable/disable .GitInfo object for each page
          https://gohugo.io/getting-started/configuration/#enablegitinfo
        "%
        | optional,
      enableInlineShortcodes
        | Bool
        | doc m%"
          Enable/disable inline shortcode support
          https://gohugo.io/getting-started/configuration/#enableinlineshortcodes
        "%
        | optional,
      enableMissingTranslationPlaceholders
        | Bool
        | doc m%"
          Enable/disable placeholder substitution instead of the default value or an empty string if a translation is missing
          https://gohugo.io/getting-started/configuration/#enablemissingtranslationplaceholders
        "%
        | optional,
      enableRobotsTXT
        | Bool
        | doc m%"
          Enable/disable generation of robots.txt file
          https://gohugo.io/getting-started/configuration/#enablerobotstxt
        "%
        | optional,
      footnoteAnchorPrefix
        | String
        | doc m%"
          The prefix for footnote anchors
          https://gohugo.io/getting-started/configuration/#footnoteanchorprefix
        "%
        | optional,
      footnoteReturnLinkContents
        | String
        | doc m%"
          The text to display for footnote return links
          https://gohugo.io/getting-started/configuration/#footnotereturnlinkcontents
        "%
        | optional,
      frontmatter
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          date
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
                            ":default",
                            ":fileModTime",
                            ":filename",
                            ":git",
                            "date",
                            "lastmod",
                            "modified",
                            "pubdate",
                            "publishDate"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-dates
            "%
            | optional,
          expiryDate
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [ ":default", "expiryDate", "unpublishdate" ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-dates
            "%
            | optional,
          lastmod
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
                            ":default",
                            ":fileModTime",
                            ":filename",
                            ":git",
                            "date",
                            "lastmod",
                            "modified",
                            "pubdate",
                            "publishDate"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-dates
            "%
            | optional,
          publishDate
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
                            ":default",
                            ":fileModTime",
                            ":filename",
                            ":git",
                            "date",
                            "lastmod",
                            "modified",
                            "pubdate",
                            "publishDate"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-dates
            "%
            | optional,
        }
        | doc m%"
          The front matter options
          https://gohugo.io/getting-started/configuration/#configure-front-matter
        "%
        | optional,
      googleAnalytics
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "(UA-\\d{4,9}-\\d)|(G-\\w+)"
            ])
        | doc m%"
          The Google Analytics tracking ID
          https://gohugo.io/getting-started/configuration/#googleanalytics
        "%
        | optional,
      hasCJKLanguage
        | Bool
        | doc m%"
          Enable/disable auto-detecting Chinese/Japanese/Korean Languages in the content
          https://gohugo.io/getting-started/configuration/#hascjklanguage
        "%
        | optional,
      imaging
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          anchor
            | std.enum.TagOrString
            | [|
              'BottomRight,
              'Bottom,
              'BottomLeft,
              'Right,
              'Center,
              'Left,
              'TopRight,
              'Top,
              'TopLeft,
              'Smart
            |]
            | doc m%"
              The anchor used when cropping pictures with either .Fill or .Crop
              https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          bgColor
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^#(\\d|[ABCDEFabcdef]){6}$"
                ])
            | doc m%"
              The default background color
              https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          exif
            | {
              disableDate
                | Bool
                | doc m%"
                  Enable/disable extracting the 'photo taken' date/time into .Date
                  https://gohugo.io/content-management/image-processing/#image-processing-config
                "%
                | optional,
              disableLatLong
                | Bool
                | doc m%"
                  Enable/disable extracting the 'photo taken where' into .Long and .Lat
                  https://gohugo.io/content-management/image-processing/#image-processing-config
                "%
                | optional,
              excludeFields
                | String
                | doc m%"
                  The regexp matching the excluded fields
                  https://gohugo.io/content-management/image-processing/#image-processing-config
                "%
                | optional,
              includeFields
                | String
                | doc m%"
                  The regexp matching the included fields
                  https://gohugo.io/content-management/image-processing/#image-processing-config
                "%
                | optional,
            }
            | doc m%"
              Exif options
              https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          hint
            | std.enum.TagOrString
            | [| 'text, 'icon, 'drawing, 'photo, 'picture |]
            | doc m%"
              The default hint about what type of image
              https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          quality
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.maximum 100,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              The default quality
              https://gohugo.io/content-management/image-processing/#image-processing-config
            "%
            | optional,
          resampleFilter
            | std.enum.TagOrString
            | [|
              'Cosine,
              'Welch,
              'Bartlett,
              'Blackman,
              'Hamming,
              'Hann,
              'Lanczos,
              'Gaussian,
              'BSpline,
              'CatmullRom,
              'MitchellNetravali,
              'Hermite,
              'Linear,
              'Box,
              'NearestNeighbor
            |]
            | doc m%"
              The default resample filter
              https://gohugo.io/content-management/image-processing/#resampling-filter
            "%
            | optional,
        }
        | doc m%"
          The image processing options
          https://gohugo.io/getting-started/configuration/#imaging
        "%
        | optional,
      languageCode
        | String
        | doc m%"
          The language tag as defined by RFC 5646
          https://gohugo.io/getting-started/configuration/#languagecode
        "%
        | optional,
      languages
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _merge =
                    _js2n__-refsenv."_js2n__-:definitions/mergeType!predicate",
                } {} true (_js2n__-prdslib.isType 'Record)
            ])
        | doc m%"
          The language options
          https://gohugo.io/content-management/multilingual/#configure-languages
        "%
        | optional,
      markup
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          asciidocExt
            | {
              attributes
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ])
                | doc m%"
                  The document attributes
                  https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#document-settings
                "%
                | optional,
              backend
                | std.enum.TagOrString
                | [| 'html, 'manpage, 'docbook5, 'html5 |]
                | doc m%"
                  The backend output file format
                  https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#document-settings
                "%
                | optional,
              extensions
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#configure-markup
                "%
                | optional,
              failureLevel
                | String
                | doc m%"
                  The minimum logging level
                  https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#processing-information
                "%
                | optional,
              noHeaderOrFooter
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#configure-markup
                "%
                | optional,
              preserveTOC
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#configure-markup
                "%
                | optional,
              safeMode
                | std.enum.TagOrString
                | [| 'secure, 'server, 'safe, 'unsafe |]
                | doc m%"
                  The safe mode
                  https://docs.asciidoctor.org/asciidoctor/latest/safe-modes/
                "%
                | optional,
              sectionNumbers
                | Bool
                | doc m%"
                  Enable/disable section title's auto-numbering
                  https://docs.asciidoctor.org/asciidoctor.js/latest/cli/options/#document-conversion
                "%
                | optional,
              trace
                | Bool
                | doc m%"
                  Include/exclude the backtrace information on errors
                  https://gohugo.io/getting-started/configuration-markup#configure-markup
                "%
                | optional,
              verbose
                | Bool
                | doc m%"
                  Enable/disable verbose error printing
                  https://gohugo.io/getting-started/configuration-markup#configure-markup
                "%
                | optional,
              workingFolderCurrent
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#configure-markup
                "%
                | optional,
            }
            | doc m%"
              AsciidocExt options
              https://docs.asciidoctor.org/asciidoctor/latest/cli/man1/asciidoctor/#processing-information
            "%
            | optional,
          blackfriday
            | {
              angledQuotes
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              extensions
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.minLength 1
                          ]),
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              extensionsMask
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Null
                    ])
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              footnoteAnchorPrefix
                | String
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              footnoteReturnLinkContents
                | String
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              fractions
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              hrefTargetBlank
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              latexDashes
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              nofollowLinks
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              noreferrerLinks
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              plainIDAnchors
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              skipHTML
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              smartDashes
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              smartypants
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              smartypantsQuotesNBSP
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
              taskLists
                | Bool
                | doc "https://gohugo.io/getting-started/configuration-markup#blackfriday"
                | optional,
            }
            | doc m%"
              Blackfriday options
              https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          defaultMarkdownHandler
            | std.enum.TagOrString
            | [| 'blackfriday, 'goldmark |]
            | doc m%"
              The default markdown renderer
              https://gohugo.io/getting-started/configuration-markup#blackfriday
            "%
            | optional,
          goldmark
            | {
              extensions
                | {
                  definitionList
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  extras
                    | {
                      delete
                        | {
                          enable
                            | Bool
                            | doc m%"
                              
                              https://gohugo.io/configuration/markup/#extras
                            "%
                            | optional,
                          ..
                        }
                        | doc m%"
                          
                          https://gohugo.io/configuration/markup/#extras
                        "%
                        | optional,
                      insert
                        | {
                          enable
                            | Bool
                            | doc m%"
                              
                              https://gohugo.io/configuration/markup/#extras
                            "%
                            | optional,
                          ..
                        }
                        | doc m%"
                          
                          https://gohugo.io/configuration/markup/#extras
                        "%
                        | optional,
                      mark
                        | {
                          enable
                            | Bool
                            | doc m%"
                              
                              https://gohugo.io/configuration/markup/#extras
                            "%
                            | optional,
                          ..
                        }
                        | doc m%"
                          
                          https://gohugo.io/configuration/markup/#extras
                        "%
                        | optional,
                      subscript
                        | {
                          enable
                            | Bool
                            | doc m%"
                              
                              https://gohugo.io/configuration/markup/#extras
                            "%
                            | optional,
                          ..
                        }
                        | doc m%"
                          
                          https://gohugo.io/configuration/markup/#extras
                        "%
                        | optional,
                      superscript
                        | {
                          enable
                            | Bool
                            | doc m%"
                              
                              https://gohugo.io/configuration/markup/#extras
                            "%
                            | optional,
                          ..
                        }
                        | doc m%"
                          
                          https://gohugo.io/configuration/markup/#extras
                        "%
                        | optional,
                      ..
                    }
                    | doc m%"
                      
                      https://gohugo.io/configuration/markup/#extras
                    "%
                    | optional,
                  footnote
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  linkify
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  linkifyProtocol
                    | String
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  strikethrough
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  table
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  taskList
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  typographer
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                }
                | doc m%"
                  The extension options
                  https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              parser
                | {
                  attribute
                    | {
                      block
                        | Bool
                        | doc m%"
                          
                          https://gohugo.io/getting-started/configuration-markup#goldmark
                        "%
                        | optional,
                      title
                        | Bool
                        | doc m%"
                          
                          https://gohugo.io/getting-started/configuration-markup#goldmark
                        "%
                        | optional,
                    }
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  autoHeadingID
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  autoHeadingIDType
                    | String
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  wrapStandAloneImageWithinParagraph
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                }
                | doc m%"
                  The parser options
                  https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
              renderer
                | {
                  hardWraps
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  unsafe
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                  xhtml
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration-markup#goldmark
                    "%
                    | optional,
                }
                | doc m%"
                  The renderer options
                  https://gohugo.io/getting-started/configuration-markup#goldmark
                "%
                | optional,
            }
            | doc m%"
              Goldmark options
              https://gohugo.io/getting-started/configuration-markup#goldmark
            "%
            | optional,
          highlight
            | {
              anchorLineNos
                | Bool
                | doc m%"
                  Enable/disable anchors on line numbers
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              codeFences
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              guessSyntax
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              hl_Lines
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\d+( \\d+(-\\d+)?)*$"
                        ]
                    ])
                | doc m%"
                  The highlighted line number range
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              lineAnchors
                | String
                | doc m%"
                  The prefix for the anchors on line numbers
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              lineNoStart
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 1
                    ])
                | doc m%"
                  The first line
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              lineNos
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "table", "inline" ]
                        ]
                    ])
                | doc m%"
                  Enable/disable line numbers
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              lineNumbersInTable
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              noClasses
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              noHl
                | Bool
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              style
                | std.enum.TagOrString
                | [|
                  'xcode,
                  'xcode-dark,
                  'witchhazel,
                  'vulcan,
                  'vs,
                  'vim,
                  'trac,
                  'tango,
                  'swapoff,
                  'solarized-light,
                  'solarized-dark256,
                  'solarized-dark,
                  'rrt,
                  'rose-pine,
                  'rose-pine-moon,
                  'rose-pine-dawn,
                  'rainbow_dash,
                  'pygments,
                  'perldoc,
                  'pastie,
                  'paraiso-light,
                  'paraiso-dark,
                  'onesenterprise,
                  'onedark,
                  'nord,
                  'native,
                  'murphy,
                  'monokailight,
                  'monokai,
                  'modus-vivendi,
                  'modus-operandi,
                  'manni,
                  'lovelace,
                  'igor,
                  'hrdark,
                  'hr_high_contrast,
                  'gruvbox,
                  'gruvbox-light,
                  'github,
                  'github-dark,
                  'fruity,
                  'friendly,
                  'emacs,
                  'dracula,
                  'doom-one2,
                  'doom-one,
                  'colorful,
                  'catppuccin-mocha,
                  'catppuccin-macchiato,
                  'catppuccin-latte,
                  'catppuccin-frappe,
                  'bw,
                  'borland,
                  'base16-snazzy,
                  'average,
                  'autumn,
                  'arduino,
                  'algol_nu,
                  'algol,
                  'abap
                |]
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
              tabWidth
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 1
                    ])
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration-markup#highlight
                "%
                | optional,
            }
            | doc m%"
              The highlighting options
              https://gohugo.io/getting-started/configuration-markup#highlight
            "%
            | optional,
          tableOfContents
            | {
              endLevel
                | std.number.Integer
                | doc m%"
                  The end heading level
                  https://gohugo.io/getting-started/configuration-markup#table-of-contents
                "%
                | optional,
              ordered
                | Bool
                | doc m%"
                  Enable/disable ordered list generation
                  https://gohugo.io/getting-started/configuration-markup#table-of-contents
                "%
                | optional,
              startLevel
                | std.number.Integer
                | doc m%"
                  The start heading level
                  https://gohugo.io/getting-started/configuration-markup#table-of-contents
                "%
                | optional,
            }
            | doc m%"
              The table of contents options
              https://gohugo.io/getting-started/configuration-markup#table-of-contents
            "%
            | optional,
          ..
        }
        | doc m%"
          The markdown options
          https://gohugo.io/getting-started/configuration-markup
        "%
        | optional,
      mediaTypes
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          "application/json"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/manifest+json"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/octet-stream"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/pdf"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/rss+xml"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/toml"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/wasm"
            | {
              suffix
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/xml"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "application/yaml"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "font/otf"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "font/ttf"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/bmp"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/gif"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/jpeg"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/png"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/svg+xml"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/tiff"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "image/webp"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/calendar"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/css"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/csv"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/html"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/javascript"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/jsx"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/markdown"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/plain"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/tsx"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/typescript"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/x-sass"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "text/x-scss"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "video/3gpp"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "video/mp4"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "video/mpeg"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "video/ogg"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "video/webm"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
          "video/x-msvideo"
            | {
              suffixes
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/templates/output-formats/#media-types
                "%
                | optional,
              ..
            }
            | doc m%"
              
              https://gohugo.io/templates/output-formats/#media-types
            "%
            | optional,
        }
        | doc m%"
          The media type's options
          https://gohugo.io/templates/output-formats/#media-types
        "%
        | optional,
      menu
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _merge =
                    _js2n__-refsenv."_js2n__-:definitions/mergeType!predicate",
                } {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              identifier =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              name =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              pageRef = _js2n__-prdslib.isType '"String",
                              params = _js2n__-prdslib.isType 'Record,
                              parent = _js2n__-prdslib.isType '"String",
                              post = _js2n__-prdslib.isType '"String",
                              pre = _js2n__-prdslib.isType '"String",
                              title = _js2n__-prdslib.isType '"String",
                              url = _js2n__-prdslib.isType '"String",
                              weight = _js2n__-prdslib.isType 'Integer,
                            } {} false _js2n__-prdslib.never
                        ])
                  ])
            ])
        | doc m%"
          The menu options
          https://gohugo.io/content-management/menus/#add-non-content-entries-to-a-menu
        "%
        | optional,
      minify
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          disableCSS
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          disableHTML
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          disableJS
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          disableJSON
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          disableSVG
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          disableXML
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          minifyOutput
            | Bool
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
          tdewolff
            | {
              css
                | {
                  keepCSS2
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  precision
                    | std.number.Integer
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                }
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              html
                | {
                  keepComments
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  keepConditionalComments
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  keepDefaultAttrVals
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  keepDocumentTags
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  keepEndTags
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  keepQuotes
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  keepWhitespace
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                }
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              js
                | {
                  keepVarNames
                    | Bool
                    | doc m%"
                      Keeps variable names as they are and omits shortening variable names.
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  noNullishOperator
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  precision
                    | std.number.Integer
                    | doc m%"
                      Number of significant digits to preserve for numbers, 0 means no trimming.
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  version
                    | std.number.Integer
                    | doc m%"
                      ECMAScript version to use for output, 0 is the latest.
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                }
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              json
                | {
                  keepNumbers
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                  precision
                    | std.number.Integer
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                }
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              svg
                | {
                  keepComments | Bool | optional,
                  precision
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ])
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                }
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
              xml
                | {
                  keepWhitespace
                    | Bool
                    | doc m%"
                      
                      https://gohugo.io/getting-started/configuration/#configure-minify
                    "%
                    | optional,
                }
                | doc m%"
                  
                  https://gohugo.io/getting-started/configuration/#configure-minify
                "%
                | optional,
            }
            | doc m%"
              
              https://gohugo.io/getting-started/configuration/#configure-minify
            "%
            | optional,
        }
        | doc m%"
          
          https://gohugo.io/getting-started/configuration/#configure-minify
        "%
        | optional,
      module
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          hugoVersion
            | {
              extended
                | Bool
                | doc m%"
                  Enable/disable requiring the extended version
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-hugoversion
                "%
                | optional,
              max
                | _js2n__-refsenv."_js2n__-:definitions/hugoVersion!contract"
                | doc m%"
                  The maximum required version
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-hugoversion
                "%
                | optional,
              min
                | _js2n__-refsenv."_js2n__-:definitions/hugoVersion!contract"
                | doc m%"
                  The minimum required version
                  https://gohugo.io/hugo-modules/configuration/#module-configuration-hugoversion
                "%
                | optional,
            }
            | doc m%"
              The version
              https://gohugo.io/hugo-modules/configuration/#module-configuration-hugoversion
            "%
            | optional,
          imports
            | Array
              {
                disable
                  | Bool
                  | doc m%"
                    Enable/disable the module
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
                  "%
                  | optional,
                ignoreConfig
                  | Bool
                  | doc m%"
                    Use/ignore the configuration file
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
                  "%
                  | optional,
                ignoreImports
                  | Bool
                  | doc m%"
                    Use/ignore the imports
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
                  "%
                  | optional,
                mounts
                  | _js2n__-refsenv."_js2n__-:definitions/mounts!contract"
                  | doc m%"
                    The mount options
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
                  "%
                  | optional,
                noMounts
                  | Bool
                  | doc m%"
                    Enable/disable the folder mounting
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
                  "%
                  | optional,
                noVendor
                  | Bool
                  | doc m%"
                    Enable/disable vendoring this import
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
                  "%
                  | optional,
                path
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ])
                  | doc m%"
                    The path
                    https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
                  "%,
              }
            | doc m%"
              The import options
              https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
            "%
            | optional,
          mounts
            | _js2n__-refsenv."_js2n__-:definitions/mounts!contract"
            | doc m%"
              The mount options
              https://gohugo.io/hugo-modules/configuration/#module-configuration-mounts
            "%
            | optional,
          noProxy
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[^,]+(,[^,]+)*$"
                ])
            | doc m%"
              The glob list of the matching paths that should not use the proxy configured above
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
          noVendor
            | String
            | doc m%"
              The glob pattern matching the paths to skip when vendoring
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
          private
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[^,]+(,[^,]+)*$"
                ])
            | doc m%"
              The glob list of the matching paths that should be treated as private
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
          proxy
            | String
            | doc m%"
              The proxy server to download the remote modules
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
          replacements
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^[^,]+ -> [^,]+(,[^,]+ -> [^,]+)*$"
                ])
            | doc m%"
              The list of the module path to directory replacement mapping
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
          vendorClosest
            | Bool
            | doc m%"
              Enable/disable picking the vendored module closest to the module using it
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
          workspace
            | String
            | doc m%"
              The workspace file to use. This enables Go workspace mode.
              https://gohugo.io/hugo-modules/configuration/#module-configuration-top-level
            "%
            | optional,
        }
        | doc m%"
          The module options
          https://gohugo.io/hugo-modules/configuration/
        "%
        | optional,
      newContentEditor
        | String
        | doc m%"
          The content editor
          https://gohugo.io/getting-started/configuration/#newcontenteditor
        "%
        | optional,
      noChmod
        | Bool
        | doc m%"
          Enable/disable syncing permission mode of files
          https://gohugo.io/getting-started/configuration/#nochmod
        "%
        | optional,
      noTimes
        | Bool
        | doc m%"
          Enable/disable syncing modification time of files
          https://gohugo.io/getting-started/configuration/#notimes
        "%
        | optional,
      outputFormats
        | _js2n__-refsenv."_js2n__-:definitions/outputFormats!contract"
        | doc m%"
          The output format options
          https://gohugo.io/templates/output-formats/#configure-output-formats
        "%
        | optional,
      paginate
        | std.number.Integer
        | doc m%"
          The default number of elements per page in pagination
          https://gohugo.io/getting-started/configuration/#paginate
        "%
        | optional,
      paginatePath
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The path element used during pagination
          https://gohugo.io/getting-started/configuration/#paginatepath
        "%
        | optional,
      permalinks
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          page
            | _js2n__-refsenv."_js2n__-:definitions/permalinkConfiguration!contract"
            | optional,
          section
            | _js2n__-refsenv."_js2n__-:definitions/permalinkConfiguration!contract"
            | optional,
          term
            | _js2n__-refsenv."_js2n__-:definitions/permalinkConfiguration!contract"
            | optional,
          ..
        }
        | doc m%"
          The permalink options
          https://gohugo.io/content-management/urls/#permalinks
        "%
        | optional,
      pluralizeListTitles
        | Bool
        | doc m%"
          Pluralize/leave titles in lists
          https://gohugo.io/getting-started/configuration/#pluralizelisttitles
        "%
        | optional,
      publishDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The directory where Hugo writes the final static site
          https://gohugo.io/getting-started/configuration/#publishdir
        "%
        | optional,
      refLinksErrorLevel
        | std.enum.TagOrString
        | [| 'WARNING, 'ERROR |]
        | doc m%"
          The logging level for page links cannot be resolved
          https://gohugo.io/getting-started/configuration/#reflinkserrorlevel
        "%
        | optional,
      refLinksNotFoundURL
        | String
        | doc m%"
          The placeholder when a page reference cannot be found in `ref` or `relref`
          https://gohugo.io/getting-started/configuration/#reflinksnotfoundurl
        "%
        | optional,
      related
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          includeNewer
            | Bool
            | doc m%"
              Include/exclude the pages newer than the current page
              https://gohugo.io/content-management/related/#top-level-config-options
            "%
            | optional,
          indices
            | Array
              {
                applyFilter
                  | Bool
                  | doc m%"
                    Apply a type specific filter to the result of a search. This is currently only used for the fragments type
                    https://gohugo.io/content-management/related/#config-options-per-index
                  "%
                  | optional,
                cardinalityThreshold
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.numbers.maximum 100,
                        _js2n__-prdslib.numbers.minimum 0
                      ])
                  | doc m%"
                    A percentage (0-100) used to remove common keywords from the index
                    https://gohugo.io/content-management/related/#config-options-per-index
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
                    The index name
                    https://gohugo.io/content-management/related/#config-options-per-index
                  "%
                  | optional,
                pattern
                  | String
                  | doc m%"
                    The date format
                    https://gohugo.io/content-management/related/#config-options-per-index
                  "%
                  | optional,
                toLower
                  | Bool
                  | doc m%"
                    Enable/disable lowering the case keywords in both the indexes and the queries
                    https://gohugo.io/content-management/related/#config-options-per-index
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'fragments, 'basic |]
                  | doc m%"
                    The index type
                    https://gohugo.io/content-management/related/#config-options-per-index
                  "%
                  | optional,
                weight
                  | std.number.Integer
                  | doc m%"
                    The weight indicating how important this parameter is relative to the other parameters
                    https://gohugo.io/content-management/related/#config-options-per-index
                  "%
                  | optional,
              }
            | doc m%"
              The related content option's entry
              https://gohugo.io/content-management/related/#config-options-per-index
            "%
            | optional,
          threshold
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.maximum 100,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              
              https://gohugo.io/content-management/related/#top-level-config-options
            "%
            | optional,
          toLower
            | Bool
            | doc m%"
              Enable/disable lowering the case keywords in both the indexes and the queries
              https://gohugo.io/content-management/related/#top-level-config-options
            "%
            | optional,
        }
        | doc m%"
          The related content options
          https://gohugo.io/getting-started/configuration/#related
        "%
        | optional,
      relativeURLs
        | Bool
        | doc m%"
          Enable/disable making all relative URLs relative to content root
          https://gohugo.io/getting-started/configuration/#relativeurls
        "%
        | optional,
      removePathAccents
        | Bool
        | doc m%"
          Remove/leave non-spacing marks from composite characters in content paths
          https://gohugo.io/getting-started/configuration/#removepathaccents
        "%
        | optional,
      rssLimit
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum (-1)
            ])
        | doc m%"
          
          https://gohugo.io/getting-started/configuration/#rsslimit
        "%
        | optional,
      sectionPagesMenu
        | String
        | doc m%"
          
          https://gohugo.io/templates/menu-templates/#section-menu-for-lazy-bloggers
        "%
        | optional,
      security
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          enableInlineShortcodes
            | Bool
            | doc m%"
              
              https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
          exec
            | {
              allow
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/about/security-model/#security-policy
                "%
                | optional,
              osEnv
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/about/security-model/#security-policy
                "%
                | optional,
            }
            | doc m%"
              
              https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
          funcs
            | {
              getenv
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/about/security-model/#security-policy
                "%
                | optional,
            }
            | doc m%"
              
              https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
          http
            | {
              methods
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/about/security-model/#security-policy
                "%
                | optional,
              urls
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
                      _js2n__-prdslib.arrays.uniqueItems
                    ])
                | doc m%"
                  
                  https://gohugo.io/about/security-model/#security-policy
                "%
                | optional,
            }
            | doc m%"
              
              https://gohugo.io/about/security-model/#security-policy
            "%
            | optional,
        }
        | doc m%"
          The security options
          https://gohugo.io/about/security-model/#security-policy
        "%
        | optional,
      sitemap
        | {
          _merge
            | _js2n__-refsenv."_js2n__-:definitions/mergeType!contract"
            | optional,
          changefreq
            | String
            | doc m%"
              
              https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
            "%
            | optional,
          filename
            | String
            | doc m%"
              
              https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
            "%
            | optional,
          "priority"
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.maximum 1,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              
              https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
            "%
            | optional,
        }
        | doc m%"
          The sitemap options
          https://gohugo.io/templates/sitemap-template/#configure-sitemapxml
        "%
        | optional,
      summaryLength
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          The length of text in words to show in a .Summary
          https://gohugo.io/getting-started/configuration/#summarylength
        "%
        | optional,
      taxonomies
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _merge =
                    _js2n__-refsenv."_js2n__-:definitions/mergeType!predicate",
                  category =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  tag =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                }
                {
                  "^(?!tag|category)$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc m%"
          The taxonomy options
          https://gohugo.io/content-management/taxonomies#configure-taxonomies
        "%
        | optional,
      theme
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc m%"
          Theme or Theme list
          https://gohugo.io/hugo-modules/configuration/#module-configuration-imports
        "%
        | optional,
      themesDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          The directory where themes are stored
          https://gohugo.io/getting-started/configuration/#themesdir
        "%
        | optional,
      timeZone
        | std.enum.TagOrString
        | [|
          '"US/Samoa",
          '"US/Pacific",
          '"US/Mountain",
          '"US/Michigan",
          '"US/Indiana-Starke",
          '"US/Hawaii",
          '"US/Eastern",
          '"US/East-Indiana",
          '"US/Central",
          '"US/Arizona",
          '"US/Aleutian",
          '"US/Alaska",
          'Singapore,
          'ROC,
          'PRC,
          'Portugal,
          'Poland,
          '"Pacific/Yap",
          '"Pacific/Wallis",
          '"Pacific/Wake",
          '"Pacific/Truk",
          '"Pacific/Tongatapu",
          '"Pacific/Tarawa",
          '"Pacific/Tahiti",
          '"Pacific/Samoa",
          '"Pacific/Saipan",
          '"Pacific/Rarotonga",
          '"Pacific/Port_Moresby",
          '"Pacific/Ponape",
          '"Pacific/Pohnpei",
          '"Pacific/Pitcairn",
          '"Pacific/Palau",
          '"Pacific/Pago_Pago",
          '"Pacific/Noumea",
          '"Pacific/Norfolk",
          '"Pacific/Niue",
          '"Pacific/Nauru",
          '"Pacific/Midway",
          '"Pacific/Marquesas",
          '"Pacific/Majuro",
          '"Pacific/Kwajalein",
          '"Pacific/Kosrae",
          '"Pacific/Kiritimati",
          '"Pacific/Kanton",
          '"Pacific/Johnston",
          '"Pacific/Honolulu",
          '"Pacific/Guam",
          '"Pacific/Guadalcanal",
          '"Pacific/Gambier",
          '"Pacific/Galapagos",
          '"Pacific/Funafuti",
          '"Pacific/Fiji",
          '"Pacific/Fakaofo",
          '"Pacific/Enderbury",
          '"Pacific/Efate",
          '"Pacific/Easter",
          '"Pacific/Chuuk",
          '"Pacific/Chatham",
          '"Pacific/Bougainville",
          '"Pacific/Auckland",
          '"Pacific/Apia",
          'NZ-CHAT,
          'NZ,
          'Navajo,
          '"Mexico/General",
          '"Mexico/BajaSur",
          '"Mexico/BajaNorte",
          'Libya,
          'Kwajalein,
          'Japan,
          'Jamaica,
          'Israel,
          'Iran,
          '"Indian/Reunion",
          '"Indian/Mayotte",
          '"Indian/Mauritius",
          '"Indian/Maldives",
          '"Indian/Mahe",
          '"Indian/Kerguelen",
          '"Indian/Comoro",
          '"Indian/Cocos",
          '"Indian/Christmas",
          '"Indian/Chagos",
          '"Indian/Antananarivo",
          'Iceland,
          'Hongkong,
          'GB-Eire,
          'GB,
          '"Europe/Zurich",
          '"Europe/Zaporozhye",
          '"Europe/Zagreb",
          '"Europe/Warsaw",
          '"Europe/Volgograd",
          '"Europe/Vilnius",
          '"Europe/Vienna",
          '"Europe/Vatican",
          '"Europe/Vaduz",
          '"Europe/Uzhgorod",
          '"Europe/Ulyanovsk",
          '"Europe/Tiraspol",
          '"Europe/Tirane",
          '"Europe/Tallinn",
          '"Europe/Stockholm",
          '"Europe/Sofia",
          '"Europe/Skopje",
          '"Europe/Simferopol",
          '"Europe/Saratov",
          '"Europe/Sarajevo",
          '"Europe/San_Marino",
          '"Europe/Samara",
          '"Europe/Rome",
          '"Europe/Riga",
          '"Europe/Prague",
          '"Europe/Podgorica",
          '"Europe/Paris",
          '"Europe/Oslo",
          '"Europe/Nicosia",
          '"Europe/Moscow",
          '"Europe/Monaco",
          '"Europe/Minsk",
          '"Europe/Mariehamn",
          '"Europe/Malta",
          '"Europe/Madrid",
          '"Europe/Luxembourg",
          '"Europe/London",
          '"Europe/Ljubljana",
          '"Europe/Lisbon",
          '"Europe/Kirov",
          '"Europe/Kiev",
          '"Europe/Kaliningrad",
          '"Europe/Jersey",
          '"Europe/Istanbul",
          '"Europe/Isle_of_Man",
          '"Europe/Helsinki",
          '"Europe/Guernsey",
          '"Europe/Gibraltar",
          '"Europe/Dublin",
          '"Europe/Copenhagen",
          '"Europe/Chisinau",
          '"Europe/Busingen",
          '"Europe/Budapest",
          '"Europe/Bucharest",
          '"Europe/Brussels",
          '"Europe/Bratislava",
          '"Europe/Berlin",
          '"Europe/Belgrade",
          '"Europe/Belfast",
          '"Europe/Athens",
          '"Europe/Astrakhan",
          '"Europe/Andorra",
          '"Europe/Amsterdam",
          '"Etc/Zulu",
          '"Etc/UTC",
          '"Etc/Universal",
          '"Etc/UCT",
          '"Etc/Greenwich",
          '"Etc/GMT0",
          '"Etc/GMT-9",
          '"Etc/GMT-8",
          '"Etc/GMT-7",
          '"Etc/GMT-6",
          '"Etc/GMT-5",
          '"Etc/GMT-4",
          '"Etc/GMT-3",
          '"Etc/GMT-2",
          '"Etc/GMT-14",
          '"Etc/GMT-13",
          '"Etc/GMT-12",
          '"Etc/GMT-11",
          '"Etc/GMT-10",
          '"Etc/GMT-1",
          '"Etc/GMT-0",
          '"Etc/GMT+9",
          '"Etc/GMT+8",
          '"Etc/GMT+7",
          '"Etc/GMT+6",
          '"Etc/GMT+5",
          '"Etc/GMT+4",
          '"Etc/GMT+3",
          '"Etc/GMT+2",
          '"Etc/GMT+12",
          '"Etc/GMT+11",
          '"Etc/GMT+10",
          '"Etc/GMT+1",
          '"Etc/GMT+0",
          '"Etc/GMT",
          'Eire,
          'Egypt,
          'Cuba,
          '"Chile/EasterIsland",
          '"Chile/Continental",
          '"Canada/Yukon",
          '"Canada/Saskatchewan",
          '"Canada/Pacific",
          '"Canada/Newfoundland",
          '"Canada/Mountain",
          '"Canada/Eastern",
          '"Canada/Central",
          '"Canada/Atlantic",
          '"Brazil/West",
          '"Brazil/East",
          '"Brazil/DeNoronha",
          '"Brazil/Acre",
          '"Australia/Yancowinna",
          '"Australia/West",
          '"Australia/Victoria",
          '"Australia/Tasmania",
          '"Australia/Sydney",
          '"Australia/South",
          '"Australia/Queensland",
          '"Australia/Perth",
          '"Australia/NSW",
          '"Australia/North",
          '"Australia/Melbourne",
          '"Australia/Lord_Howe",
          '"Australia/Lindeman",
          '"Australia/LHI",
          '"Australia/Hobart",
          '"Australia/Eucla",
          '"Australia/Darwin",
          '"Australia/Currie",
          '"Australia/Canberra",
          '"Australia/Broken_Hill",
          '"Australia/Brisbane",
          '"Australia/Adelaide",
          '"Australia/ACT",
          '"Atlantic/Stanley",
          '"Atlantic/St_Helena",
          '"Atlantic/South_Georgia",
          '"Atlantic/Reykjavik",
          '"Atlantic/Madeira",
          '"Atlantic/Jan_Mayen",
          '"Atlantic/Faroe",
          '"Atlantic/Faeroe",
          '"Atlantic/Cape_Verde",
          '"Atlantic/Canary",
          '"Atlantic/Bermuda",
          '"Atlantic/Azores",
          '"Asia/Yerevan",
          '"Asia/Yekaterinburg",
          '"Asia/Yangon",
          '"Asia/Yakutsk",
          '"Asia/Vladivostok",
          '"Asia/Vientiane",
          '"Asia/Ust-Nera",
          '"Asia/Urumqi",
          '"Asia/Ulan_Bator",
          '"Asia/Ulaanbaatar",
          '"Asia/Ujung_Pandang",
          '"Asia/Tomsk",
          '"Asia/Tokyo",
          '"Asia/Thimphu",
          '"Asia/Thimbu",
          '"Asia/Tel_Aviv",
          '"Asia/Tehran",
          '"Asia/Tbilisi",
          '"Asia/Tashkent",
          '"Asia/Taipei",
          '"Asia/Srednekolymsk",
          '"Asia/Singapore",
          '"Asia/Shanghai",
          '"Asia/Seoul",
          '"Asia/Samarkand",
          '"Asia/Sakhalin",
          '"Asia/Saigon",
          '"Asia/Riyadh",
          '"Asia/Rangoon",
          '"Asia/Qyzylorda",
          '"Asia/Qostanay",
          '"Asia/Qatar",
          '"Asia/Pyongyang",
          '"Asia/Pontianak",
          '"Asia/Phnom_Penh",
          '"Asia/Oral",
          '"Asia/Omsk",
          '"Asia/Novosibirsk",
          '"Asia/Novokuznetsk",
          '"Asia/Nicosia",
          '"Asia/Muscat",
          '"Asia/Manila",
          '"Asia/Makassar",
          '"Asia/Magadan",
          '"Asia/Macau",
          '"Asia/Macao",
          '"Asia/Kuwait",
          '"Asia/Kuching",
          '"Asia/Kuala_Lumpur",
          '"Asia/Krasnoyarsk",
          '"Asia/Kolkata",
          '"Asia/Khandyga",
          '"Asia/Katmandu",
          '"Asia/Kathmandu",
          '"Asia/Kashgar",
          '"Asia/Karachi",
          '"Asia/Kamchatka",
          '"Asia/Kabul",
          '"Asia/Jerusalem",
          '"Asia/Jayapura",
          '"Asia/Jakarta",
          '"Asia/Istanbul",
          '"Asia/Irkutsk",
          '"Asia/Hovd",
          '"Asia/Hong_Kong",
          '"Asia/Ho_Chi_Minh",
          '"Asia/Hebron",
          '"Asia/Harbin",
          '"Asia/Gaza",
          '"Asia/Famagusta",
          '"Asia/Dushanbe",
          '"Asia/Dubai",
          '"Asia/Dili",
          '"Asia/Dhaka",
          '"Asia/Damascus",
          '"Asia/Dacca",
          '"Asia/Colombo",
          '"Asia/Chungking",
          '"Asia/Chongqing",
          '"Asia/Choibalsan",
          '"Asia/Chita",
          '"Asia/Calcutta",
          '"Asia/Brunei",
          '"Asia/Bishkek",
          '"Asia/Beirut",
          '"Asia/Barnaul",
          '"Asia/Bangkok",
          '"Asia/Baku",
          '"Asia/Bahrain",
          '"Asia/Baghdad",
          '"Asia/Atyrau",
          '"Asia/Ashkhabad",
          '"Asia/Ashgabat",
          '"Asia/Aqtobe",
          '"Asia/Aqtau",
          '"Asia/Anadyr",
          '"Asia/Amman",
          '"Asia/Almaty",
          '"Asia/Aden",
          '"Arctic/Longyearbyen",
          '"Antarctica/Vostok",
          '"Antarctica/Troll",
          '"Antarctica/Syowa",
          '"Antarctica/South_Pole",
          '"Antarctica/Rothera",
          '"Antarctica/Palmer",
          '"Antarctica/McMurdo",
          '"Antarctica/Mawson",
          '"Antarctica/Macquarie",
          '"Antarctica/DumontDUrville",
          '"Antarctica/Davis",
          '"Antarctica/Casey",
          '"America/Yellowknife",
          '"America/Yakutat",
          '"America/Winnipeg",
          '"America/Whitehorse",
          '"America/Virgin",
          '"America/Vancouver",
          '"America/Tortola",
          '"America/Toronto",
          '"America/Tijuana",
          '"America/Thunder_Bay",
          '"America/Thule",
          '"America/Tegucigalpa",
          '"America/Swift_Current",
          '"America/St_Vincent",
          '"America/St_Thomas",
          '"America/St_Lucia",
          '"America/St_Kitts",
          '"America/St_Johns",
          '"America/St_Barthelemy",
          '"America/Sitka",
          '"America/Shiprock",
          '"America/Scoresbysund",
          '"America/Sao_Paulo",
          '"America/Santo_Domingo",
          '"America/Santiago",
          '"America/Santarem",
          '"America/Santa_Isabel",
          '"America/Rosario",
          '"America/Rio_Branco",
          '"America/Resolute",
          '"America/Regina",
          '"America/Recife",
          '"America/Rankin_Inlet",
          '"America/Rainy_River",
          '"America/Punta_Arenas",
          '"America/Puerto_Rico",
          '"America/Porto_Velho",
          '"America/Porto_Acre",
          '"America/Port_of_Spain",
          '"America/Port-au-Prince",
          '"America/Phoenix",
          '"America/Paramaribo",
          '"America/Pangnirtung",
          '"America/Panama",
          '"America/Ojinaga",
          '"America/Nuuk",
          '"America/North_Dakota/New_Salem",
          '"America/North_Dakota/Center",
          '"America/North_Dakota/Beulah",
          '"America/Noronha",
          '"America/Nome",
          '"America/Nipigon",
          '"America/New_York",
          '"America/Nassau",
          '"America/Montserrat",
          '"America/Montreal",
          '"America/Montevideo",
          '"America/Monterrey",
          '"America/Moncton",
          '"America/Miquelon",
          '"America/Mexico_City",
          '"America/Metlakatla",
          '"America/Merida",
          '"America/Menominee",
          '"America/Mendoza",
          '"America/Mazatlan",
          '"America/Matamoros",
          '"America/Martinique",
          '"America/Marigot",
          '"America/Manaus",
          '"America/Managua",
          '"America/Maceio",
          '"America/Lower_Princes",
          '"America/Louisville",
          '"America/Los_Angeles",
          '"America/Lima",
          '"America/La_Paz",
          '"America/Kralendijk",
          '"America/Knox_IN",
          '"America/Kentucky/Monticello",
          '"America/Kentucky/Louisville",
          '"America/Juneau",
          '"America/Jujuy",
          '"America/Jamaica",
          '"America/Iqaluit",
          '"America/Inuvik",
          '"America/Indianapolis",
          '"America/Indiana/Winamac",
          '"America/Indiana/Vincennes",
          '"America/Indiana/Vevay",
          '"America/Indiana/Tell_City",
          '"America/Indiana/Petersburg",
          '"America/Indiana/Marengo",
          '"America/Indiana/Knox",
          '"America/Indiana/Indianapolis",
          '"America/Hermosillo",
          '"America/Havana",
          '"America/Halifax",
          '"America/Guyana",
          '"America/Guayaquil",
          '"America/Guatemala",
          '"America/Guadeloupe",
          '"America/Grenada",
          '"America/Grand_Turk",
          '"America/Goose_Bay",
          '"America/Godthab",
          '"America/Glace_Bay",
          '"America/Fortaleza",
          '"America/Fort_Wayne",
          '"America/Fort_Nelson",
          '"America/Ensenada",
          '"America/El_Salvador",
          '"America/Eirunepe",
          '"America/Edmonton",
          '"America/Dominica",
          '"America/Detroit",
          '"America/Denver",
          '"America/Dawson_Creek",
          '"America/Dawson",
          '"America/Danmarkshavn",
          '"America/Curacao",
          '"America/Cuiaba",
          '"America/Creston",
          '"America/Costa_Rica",
          '"America/Cordoba",
          '"America/Coral_Harbour",
          '"America/Chihuahua",
          '"America/Chicago",
          '"America/Cayman",
          '"America/Cayenne",
          '"America/Catamarca",
          '"America/Caracas",
          '"America/Cancun",
          '"America/Campo_Grande",
          '"America/Cambridge_Bay",
          '"America/Buenos_Aires",
          '"America/Boise",
          '"America/Bogota",
          '"America/Boa_Vista",
          '"America/Blanc-Sablon",
          '"America/Belize",
          '"America/Belem",
          '"America/Barbados",
          '"America/Bahia_Banderas",
          '"America/Bahia",
          '"America/Atka",
          '"America/Atikokan",
          '"America/Asuncion",
          '"America/Aruba",
          '"America/Argentina/Ushuaia",
          '"America/Argentina/Tucuman",
          '"America/Argentina/San_Luis",
          '"America/Argentina/San_Juan",
          '"America/Argentina/Salta",
          '"America/Argentina/Rio_Gallegos",
          '"America/Argentina/Mendoza",
          '"America/Argentina/La_Rioja",
          '"America/Argentina/Jujuy",
          '"America/Argentina/Cordoba",
          '"America/Argentina/ComodRivadavia",
          '"America/Argentina/Catamarca",
          '"America/Argentina/Buenos_Aires",
          '"America/Araguaina",
          '"America/Antigua",
          '"America/Anguilla",
          '"America/Anchorage",
          '"America/Adak",
          '"Africa/Windhoek",
          '"Africa/Tunis",
          '"Africa/Tripoli",
          '"Africa/Timbuktu",
          '"Africa/Sao_Tome",
          '"Africa/Porto-Novo",
          '"Africa/Ouagadougou",
          '"Africa/Nouakchott",
          '"Africa/Niamey",
          '"Africa/Ndjamena",
          '"Africa/Nairobi",
          '"Africa/Monrovia",
          '"Africa/Mogadishu",
          '"Africa/Mbabane",
          '"Africa/Maseru",
          '"Africa/Maputo",
          '"Africa/Malabo",
          '"Africa/Lusaka",
          '"Africa/Lubumbashi",
          '"Africa/Luanda",
          '"Africa/Lome",
          '"Africa/Libreville",
          '"Africa/Lagos",
          '"Africa/Kinshasa",
          '"Africa/Kigali",
          '"Africa/Khartoum",
          '"Africa/Kampala",
          '"Africa/Juba",
          '"Africa/Johannesburg",
          '"Africa/Harare",
          '"Africa/Gaborone",
          '"Africa/Freetown",
          '"Africa/El_Aaiun",
          '"Africa/Douala",
          '"Africa/Djibouti",
          '"Africa/Dar_es_Salaam",
          '"Africa/Dakar",
          '"Africa/Conakry",
          '"Africa/Ceuta",
          '"Africa/Casablanca",
          '"Africa/Cairo",
          '"Africa/Bujumbura",
          '"Africa/Brazzaville",
          '"Africa/Blantyre",
          '"Africa/Bissau",
          '"Africa/Banjul",
          '"Africa/Bangui",
          '"Africa/Bamako",
          '"Africa/Asmera",
          '"Africa/Asmara",
          '"Africa/Algiers",
          '"Africa/Addis_Ababa",
          '"Africa/Accra",
          '"Africa/Abidjan"
        |]
        | doc m%"
          The time zone
          https://gohugo.io/getting-started/configuration/#timezone
        "%
        | optional,
      timeout
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^\\d+s$"
            ])
        | doc m%"
          The timeout for generating page contents
          https://gohugo.io/getting-started/configuration/#timeout
        "%
        | optional,
      title
        | String
        | doc m%"
          The site title
          https://gohugo.io/getting-started/configuration/#title
        "%
        | optional,
      titleCaseStyle
        | std.enum.TagOrString
        | [| 'none, 'firstupper, 'go, 'chicago, 'ap |]
        | doc m%"
          The title case style
          https://gohugo.io/getting-started/configuration/#titlecasestyle
        "%
        | optional,
      uglyURLs
        | Bool
        | doc m%"
          Enable/disable adding file extensions to urls
          https://gohugo.io/getting-started/configuration/#uglyurls
        "%
        | optional,
      watch
        | Bool
        | doc m%"
          Enable/disable watching filesystem for changes and recreating as needed
          https://gohugo.io/getting-started/configuration/#watch
        "%
        | optional,
      ..
    }