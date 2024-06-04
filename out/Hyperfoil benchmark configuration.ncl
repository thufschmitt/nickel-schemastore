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
      "_js2n__-:definitions/agent!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.isType '"Bool"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      ".*" =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ],
                    } true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ergonomics!contract"
        | doc "Adjust scenario to implement common functionality out-of-the-box."
        = {
            autoRangeCheck
              | Bool
              | doc "Inject status handler that marks the request as invalid on status 4xx or 5xx. Default is true."
              | optional,
            followRedirect
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.enum
                  [ "NEVER", "LOCATION_ONLY", "HTML_ONLY", "ALWAYS" ])
              | doc "Automatically fire requests when the server responds with redirection. Default is NEVER."
              | optional,
            repeatCookies
              | Bool
              | doc "Store cookies in session and resend them on future requests. Default is true."
              | optional,
            stopOnInvalid
              | Bool
              | doc "Inject completion handler that will stop the session if the request has been marked as invalid. Default is true."
              | optional,
            userAgentFromSession
              | Bool
              | doc "Append session ID and client hostname as user agent"
              | optional,
          },
      "_js2n__-:definitions/fork!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  scenario =
                    _js2n__-refsenv."_js2n__-:definitions/scenario!predicate",
                  weight = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/http!predicate"
        | doc "HTTP connection pool configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "host" ],
              _js2n__-prdslib.records.record
                {
                  addresses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  allowHttp1x = _js2n__-prdslib.isType '"Bool",
                  allowHttp2 = _js2n__-prdslib.isType '"Bool",
                  connectionStrategy =
                    _js2n__-prdslib.enum
                        [
                          "SHARED_POOL",
                          "SESSION_POOLS",
                          "OPEN_ON_REQUEST",
                          "ALWAYS_NEW"
                        ],
                  directHttp2 = _js2n__-prdslib.isType '"Bool",
                  host = _js2n__-prdslib.isType '"String",
                  keyManager =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              alias = _js2n__-prdslib.isType '"String",
                              certFile = _js2n__-prdslib.isType '"String",
                              keyFile = _js2n__-prdslib.isType '"String",
                              password = _js2n__-prdslib.isType '"String",
                              storeFile = _js2n__-prdslib.isType '"String",
                              storeType = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  maxHttp2Streams =
                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                  pipeliningLimit =
                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                  port =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 65535,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  protocol = _js2n__-prdslib.enum [ "http", "https" ],
                  rawBytesHandlers = _js2n__-prdslib.isType '"Bool",
                  requestTimeout =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                  sharedConnections =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "buffer", "core", "max" ],
                              _js2n__-prdslib.records.record
                                {
                                  buffer =
                                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                                  core =
                                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                                  keepAliveTime =
                                    _js2n__-prdslib.isType 'Integer,
                                  max =
                                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  trustManager =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              certFile = _js2n__-prdslib.isType '"String",
                              password = _js2n__-prdslib.isType '"String",
                              storeFile = _js2n__-prdslib.isType '"String",
                              storeType = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/incrementableInteger!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "base", "increment" ],
                  _js2n__-prdslib.records.record
                    {
                      base =
                        _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                      increment = _js2n__-prdslib.isType 'Integer,
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/incrementableNumber!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-refsenv."_js2n__-:definitions/positiveNumber!predicate",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "base", "increment" ],
                    _js2n__-prdslib.records.record
                      {
                        base =
                          _js2n__-refsenv."_js2n__-:definitions/positiveNumber!predicate",
                        increment = _js2n__-prdslib.isType '"Number",
                      } {} false _js2n__-prdslib.never
                  ]
              ]),
      "_js2n__-:definitions/incrementableNumber!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/positiveNumber!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "base", "increment" ],
                  _js2n__-prdslib.records.record
                    {
                      base =
                        _js2n__-refsenv."_js2n__-:definitions/positiveNumber!predicate",
                      increment = _js2n__-prdslib.isType '"Number",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/io.hyperfoil.api.config.ListBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  blockedRatio = _js2n__-prdslib.isType '"Number",
                  errorRatio = _js2n__-prdslib.isType '"Number",
                  invalidRatio = _js2n__-prdslib.isType '"Number",
                  limits =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { ".*" = _js2n__-prdslib.isType '"String", }
                                true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        ".*" = _js2n__-prdslib.isType '"String",
                                      } true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder$LimitsBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder$LimitsBuilder!predicate"
                            ]
                        ],
                  meanResponseTime = _js2n__-prdslib.isType '"String",
                  window = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder$LimitsBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder$ListBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  addItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.AddItemAction$Builder!predicate",
                  addToInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.AddToIntAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  addToSharedCounter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.AddToSharedCounterAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  array =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.ArrayRecorder$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  clearHttpCache =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.ClearHttpCacheAction$Builder!predicate",
                  closeConnection =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.CloseConnectionHandler$Builder!predicate",
                  collection =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.CollectionRecorder$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  conditional =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.ConditionalProcessor$Builder!predicate",
                  count =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.CountRecorder$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  fail =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.FailAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  getIndex =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetIndexAction$Builder!predicate",
                  getItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetItemAction$Builder!predicate",
                  getSharedCounter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.GetSharedCounterAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  getSize =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetSizeAction$Builder!predicate",
                  gzipInflator =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.GzipInflatorProcessor$Builder!predicate",
                  json =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.json.JsonHandler$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  log =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.LogAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  logInvalid =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.LogInvalidHandler$BodyHandlerBuilder!predicate",
                  markRequestInvalid =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.MarkRequestInvalidAction$Builder!predicate",
                  newSequence =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.NewSequenceAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  parseHtml =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.HtmlHandler$Builder!predicate",
                  publishAgentData =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishAgentDataAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  publishGlobalCounters =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder!predicate",
                  queue =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.QueueProcessor$Builder!predicate",
                  readAgentData =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.ReadAgentDataAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  removeItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.RemoveItemAction$Builder!predicate",
                  restartSequence =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.RestartSequenceAction$Builder!predicate",
                  set =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  setInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetIntAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  setItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.SetItemAction$Builder!predicate",
                  setSharedCounter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.SetSharedCounterAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  simple =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.StoreProcessor$LegacyBuilder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  store =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.StoreProcessor$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  storeInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.StoreIntProcessor$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stringToInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.StringToIntAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  unset =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.UnsetAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.processor.RawBytesHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  transferSizeRecorder =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.TransferSizeRecorder$Builder!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.processor.Transformer$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.ActionsTransformer$Builder!predicate",
                  pattern =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.Pattern$TransformerBuilder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  addItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.AddItemAction$Builder!predicate",
                  addToInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.AddToIntAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  addToSharedCounter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.AddToSharedCounterAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  clearHttpCache =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.ClearHttpCacheAction$Builder!predicate",
                  conditional =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.ConditionalAction$Builder!predicate",
                  fail =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.FailAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  getIndex =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetIndexAction$Builder!predicate",
                  getItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetItemAction$Builder!predicate",
                  getSharedCounter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.GetSharedCounterAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  getSize =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetSizeAction$Builder!predicate",
                  log =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.LogAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  markRequestInvalid =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.MarkRequestInvalidAction$Builder!predicate",
                  newSequence =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.NewSequenceAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  publishAgentData =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishAgentDataAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  publishGlobalCounters =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder!predicate",
                  readAgentData =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.ReadAgentDataAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  removeItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.RemoveItemAction$Builder!predicate",
                  restartSequence =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.RestartSequenceAction$Builder!predicate",
                  set =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  setInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetIntAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  setItem =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.SetItemAction$Builder!predicate",
                  setSharedCounter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.SetSharedCounterAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stringToInt =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.StringToIntAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  unset =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.UnsetAction$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allConditions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate"
                            ]
                        ],
                  boolCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate"
                            ]
                        ],
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate"
                            ]
                        ],
                  stringCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  equalTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  fromVar = _js2n__-prdslib.isType '"String",
                  greaterOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  isSet = _js2n__-prdslib.isType '"Bool",
                  lessOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  notEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$ProvidedVarBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  equalTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  notEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder$ListBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.ObjectSourceBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  caseSensitive = _js2n__-prdslib.isType '"Bool",
                  endsWith = _js2n__-prdslib.isType '"String",
                  equalTo = _js2n__-prdslib.isType '"String",
                  fromVar = _js2n__-prdslib.isType '"String",
                  isSet = _js2n__-prdslib.isType '"Bool",
                  length =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType 'Integer
                        ],
                  matchVar = _js2n__-prdslib.isType '"String",
                  negate = _js2n__-prdslib.isType '"Bool",
                  notEqualTo = _js2n__-prdslib.isType '"String",
                  startsWith = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  caseSensitive = _js2n__-prdslib.isType '"Bool",
                  endsWith = _js2n__-prdslib.isType '"String",
                  equalTo = _js2n__-prdslib.isType '"String",
                  length =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType 'Integer
                        ],
                  matchVar = _js2n__-prdslib.isType '"String",
                  negate = _js2n__-prdslib.isType '"Bool",
                  notEqualTo = _js2n__-prdslib.isType '"String",
                  startsWith = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  equalTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  notEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.ActionsTransformer$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate"
                            ]
                        ],
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  pattern = _js2n__-prdslib.isType '"String",
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.IntValueProviderBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.Pattern$TransformerBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { pattern = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.RandomCsvRowStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  columns =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { ".*" = _js2n__-prdslib.isType '"String", }
                                true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        ".*" = _js2n__-prdslib.isType '"String",
                                      } true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomCsvRowStep$Builder$ColumnsBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomCsvRowStep$Builder$ColumnsBuilder!predicate"
                            ]
                        ],
                  file = _js2n__-prdslib.isType '"String",
                  separator = _js2n__-prdslib.isType '"String",
                  skipComments = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.RandomCsvRowStep$Builder$ColumnsBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.RandomFileStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filenameVar = _js2n__-prdslib.isType '"String",
                  files =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { ".*" = _js2n__-prdslib.isType '"String", }
                                true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        ".*" = _js2n__-prdslib.isType '"String",
                                      } true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.WeightedGenerator$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.WeightedGenerator$Builder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.RandomIntStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.IntValueProviderBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.IntValueProviderBuilder!predicate"
                            ]
                        ],
                  min =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.IntValueProviderBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.IntValueProviderBuilder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.RandomItemStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file = _js2n__-prdslib.isType '"String",
                  fromVar = _js2n__-prdslib.isType '"String",
                  list =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { ".*" = _js2n__-prdslib.isType '"String", }
                                true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        ".*" = _js2n__-prdslib.isType '"String",
                                      } true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.WeightedGenerator$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.WeightedGenerator$Builder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.RandomUUIDStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { toVar = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  pattern = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.TemplateStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pattern = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.generators.WeightedGenerator$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.ArrayRecorder$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  maxSize = _js2n__-prdslib.isType 'Integer,
                  silent = _js2n__-prdslib.isType '"Bool",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.CloseConnectionHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.CollectionRecorder$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.ConditionalAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate"
                            ]
                        ],
                  allConditions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate"
                            ]
                        ],
                  boolCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate"
                            ]
                        ],
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate"
                            ]
                        ],
                  stringCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.ConditionalProcessor$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allConditions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate"
                            ]
                        ],
                  boolCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate"
                            ]
                        ],
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate"
                            ]
                        ],
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                  stringCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.CountRecorder$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { toVar = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.GzipInflatorProcessor$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  encodingVar = _js2n__-prdslib.isType '"String",
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.MarkRequestInvalidAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.NewSequenceAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concurrencyPolicy = _js2n__-prdslib.enum [ "FAIL", "WARN" ],
                  forceSameIndex = _js2n__-prdslib.isType '"Bool",
                  sequence = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.QueueProcessor$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concurrency = _js2n__-prdslib.isType 'Integer,
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  maxSize = _js2n__-prdslib.isType 'Integer,
                  onCompletion =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate"
                            ]
                        ],
                  sequence = _js2n__-prdslib.isType '"String",
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.StoreIntProcessor$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  override = _js2n__-prdslib.isType '"Bool",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.StoreProcessor$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.StoreProcessor$LegacyBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.TransferSizeRecorder$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { key = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.handlers.json.JsonHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  delete = _js2n__-prdslib.isType '"Bool",
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                  query = _js2n__-prdslib.isType '"String",
                  replace =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Transformer$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Transformer$Builder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  toArray = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                  unquote = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.AddToIntAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  orElseSetTo = _js2n__-prdslib.isType 'Integer,
                  value = _js2n__-prdslib.isType 'Integer,
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.AwaitDelayStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { key = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.AwaitIntStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  equalTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  notEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.AwaitVarStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { var = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.BreakIfFinishedStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.BreakSequenceStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allConditions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate"
                            ]
                        ],
                  boolCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate"
                            ]
                        ],
                  dependency = _js2n__-prdslib.isType '"String",
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate"
                            ]
                        ],
                  onBreak =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate"
                            ]
                        ],
                  stringCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.FailAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allConditions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate"
                            ]
                        ],
                  boolCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate"
                            ]
                        ],
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate"
                            ]
                        ],
                  message = _js2n__-prdslib.isType '"String",
                  stringCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.ForeachStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  counterVar = _js2n__-prdslib.isType '"String",
                  dependency = _js2n__-prdslib.isType '"String",
                  fromVar = _js2n__-prdslib.isType '"String",
                  sequence = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.JsonStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  delete = _js2n__-prdslib.isType '"Bool",
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  fromVar = _js2n__-prdslib.isType '"String",
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                  query = _js2n__-prdslib.isType '"String",
                  replace =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Transformer$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Transformer$Builder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  toArray = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                  unquote = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.LogAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { message = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.LoopStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  counterVar = _js2n__-prdslib.isType '"String",
                  repeats = _js2n__-prdslib.isType 'Integer,
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.NextSequenceStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.NoopStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.RestartSequenceAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.RestartSequenceStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.ScheduleDelayStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  duration = _js2n__-prdslib.isType '"String",
                  fromLast = _js2n__-prdslib.isType 'Null,
                  fromNow = _js2n__-prdslib.isType 'Null,
                  key = _js2n__-prdslib.isType '"String",
                  max = _js2n__-prdslib.isType '"String",
                  min = _js2n__-prdslib.isType '"String",
                  random =
                    _js2n__-prdslib.enum
                        [ "CONSTANT", "LINEAR", "NEGATIVE_EXPONENTIAL" ],
                  type = _js2n__-prdslib.enum [ "FROM_LAST", "FROM_NOW" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.ScheduleDelayStep$ThinkTimeBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  duration = _js2n__-prdslib.isType '"String",
                  fromLast = _js2n__-prdslib.isType 'Null,
                  fromNow = _js2n__-prdslib.isType 'Null,
                  key = _js2n__-prdslib.isType '"String",
                  max = _js2n__-prdslib.isType '"String",
                  min = _js2n__-prdslib.isType '"String",
                  random =
                    _js2n__-prdslib.enum
                        [ "CONSTANT", "LINEAR", "NEGATIVE_EXPONENTIAL" ],
                  type = _js2n__-prdslib.enum [ "FROM_LAST", "FROM_NOW" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  intArray =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$IntArrayBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$IntArrayBuilder!predicate"
                            ]
                        ],
                  objectArray =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$ObjectArrayBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$ObjectArrayBuilder!predicate"
                            ]
                        ],
                  value = _js2n__-prdslib.isType '"String",
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$IntArrayBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  size = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$ObjectArrayBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  size = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.SetIntAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$ProvidedVarBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$ProvidedVarBuilder!predicate"
                            ]
                        ],
                  max =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder$ListBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder$ListBuilder!predicate"
                            ]
                        ],
                  min =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder$ListBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder$ListBuilder!predicate"
                            ]
                        ],
                  onlyIfNotSet = _js2n__-prdslib.isType '"Bool",
                  value = _js2n__-prdslib.isType 'Integer,
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.StopStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.StopwatchBeginStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.StringToIntAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.TimestampStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  localeCountry = _js2n__-prdslib.isType '"String",
                  pattern = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.UnsetAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { var = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.AddItemAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.BoolFilter$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { value = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetIndexAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  collection = _js2n__-prdslib.isType '"String",
                  item =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.ObjectSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.ObjectSourceBuilder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetItemAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetSizeAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  boolFilter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.BoolFilter$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.BoolFilter$Builder!predicate"
                            ]
                        ],
                  fromVar = _js2n__-prdslib.isType '"String",
                  intFilter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.IntFilter$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.IntFilter$Builder!predicate"
                            ]
                        ],
                  stringFilter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.StringFilter$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.StringFilter$Builder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                  undefinedValue = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.IntFilter$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  equalTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  greaterThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessOrEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  lessThan =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  notEqualTo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.RemoveItemAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.SetItemAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntSourceBuilder!predicate"
                            ]
                        ],
                  toVar = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.collections.StringFilter$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  caseSensitive = _js2n__-prdslib.isType '"Bool",
                  endsWith = _js2n__-prdslib.isType '"String",
                  equalTo = _js2n__-prdslib.isType '"String",
                  length =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder$LengthBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType 'Integer
                        ],
                  matchVar = _js2n__-prdslib.isType '"String",
                  negate = _js2n__-prdslib.isType '"Bool",
                  notEqualTo = _js2n__-prdslib.isType '"String",
                  startsWith = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.AddToSharedCounterAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  operator = _js2n__-prdslib.enum [ "ADD", "SUBTRACT" ],
                  value = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.GetSharedCounterAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishAgentDataAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  vars =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { ".*" = _js2n__-prdslib.isType '"String", }
                                true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        ".*" = _js2n__-prdslib.isType '"String",
                                      } true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder$VarsBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder$VarsBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder$VarsBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.PullSharedMapStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  "match" = _js2n__-prdslib.isType '"String",
                  vars =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.ListBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.ListBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.PushSharedMapStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  vars =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.ListBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.ListBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.ReadAgentDataAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.steps.data.SetSharedCounterAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.core.util.DoubleIncrementBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  base = _js2n__-prdslib.isType '"Number",
                  increment = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.example.DivideStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  divisor = _js2n__-prdslib.isType 'Integer,
                  fromVar = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.hotrod.steps.HotRodRequestBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cacheName =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  get = _js2n__-prdslib.isType '"String",
                  key =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  metric =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  operation = _js2n__-prdslib.enum [ "PUT", "GET" ],
                  put = _js2n__-prdslib.isType '"String",
                  value =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.api.HeaderHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  conditional =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.ConditionalHeaderHandler$Builder!predicate",
                  countHeaders =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.CountHeadersHandler$Builder!predicate",
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.FilterHeaderHandler$Builder!predicate",
                  logInvalid =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.LogInvalidHandler$HeaderHandlerBuilder!predicate",
                  recordHeaderTime =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.RecordHeaderTimeHandler$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.api.StatusHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.maxProperties 1,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  action =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.ActionStatusHandler$Builder!predicate",
                  counter =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.StatusToCounterHandler$Builder!predicate",
                  multiplex =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.MultiplexStatusHandler$Builder!predicate",
                  range =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.RangeStatusValidator$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stats =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.StatusToStatsHandler$Builder!predicate",
                  store =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.handlers.StoreStatusHandler$Builder!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.ActionStatusHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.ConditionalHeaderHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allConditions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.Condition$TypesBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.AllConditions$Builder!predicate"
                            ]
                        ],
                  boolCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.BoolCondition$Builder!predicate"
                            ]
                        ],
                  handler =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.HeaderHandler$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.HeaderHandler$Builder!predicate"
                            ]
                        ],
                  intCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.IntCondition$Builder!predicate"
                            ]
                        ],
                  stringCondition =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringCondition$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.CountHeadersHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.FilterHeaderHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  header =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.builders.StringConditionBuilder!predicate"
                            ]
                        ],
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.LogInvalidHandler$BodyHandlerBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.LogInvalidHandler$HeaderHandlerBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.MultiplexStatusHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.StatusHandler$Builder!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.RangeStatusValidator$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max = _js2n__-prdslib.isType 'Integer,
                  min = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.RecordHeaderTimeHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  header = _js2n__-prdslib.isType '"String",
                  metric = _js2n__-prdslib.isType '"String",
                  unit = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.StatusToCounterHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  add = _js2n__-prdslib.isType 'Integer,
                  expectStatus = _js2n__-prdslib.isType 'Integer,
                  init = _js2n__-prdslib.isType 'Integer,
                  set = _js2n__-prdslib.isType 'Integer,
                  var = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.StatusToStatsHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.handlers.StoreStatusHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { toVar = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.html.EmbeddedResourceHandlerBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fetchResource =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.FetchResourceHandler$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.FetchResourceHandler$Builder!predicate"
                            ]
                        ],
                  ignoreExternal = _js2n__-prdslib.isType '"Bool",
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.html.FetchResourceHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concurrency = _js2n__-prdslib.isType 'Integer,
                  maxResources = _js2n__-prdslib.isType 'Integer,
                  metric =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  onCompletion =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.html.HtmlHandler$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  onEmbeddedResource =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.EmbeddedResourceHandlerBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.EmbeddedResourceHandlerBuilder!predicate"
                            ]
                        ],
                  onTagAttribute =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.TagAttributeHandlerBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.html.TagAttributeHandlerBuilder!predicate"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.html.TagAttributeHandlerBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attribute = _js2n__-prdslib.isType '"String",
                  format =
                    _js2n__-prdslib.enum [ "BYTEBUF", "BYTES", "STRING" ],
                  processor =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                  tag = _js2n__-prdslib.isType '"String",
                  toArray = _js2n__-prdslib.isType '"String",
                  toVar = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.AwaitAllResponsesStep$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.BodyBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  form =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.FormGenerator$InputBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.FormGenerator$InputBuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.FormGenerator$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.FormGenerator$Builder!predicate"
                            ]
                        ],
                  fromFile = _js2n__-prdslib.isType '"String",
                  fromVar = _js2n__-prdslib.isType '"String",
                  pattern = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.ClearHttpCacheAction$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.FormGenerator$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.FormGenerator$InputBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  pattern = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  CONNECT =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  DELETE =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  GET =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  HEAD =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  OPTIONS =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  PATCH =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  POST =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  PUT =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  TRACE =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  authority =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  body =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.BodyBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.BodyBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  compensation =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$CompensationBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$CompensationBuilder!predicate"
                            ]
                        ],
                  compression =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$CompressionBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$CompressionBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  endpoint =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ]
                        ],
                  handler =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpResponseHandlersImpl$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpResponseHandlersImpl$Builder!predicate"
                            ]
                        ],
                  headers =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  ".*" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$PartialHeadersBuilder!predicate"
                                        ],
                                } true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {}
                                      {
                                        ".*" =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$PartialHeadersBuilder!predicate"
                                              ],
                                      } true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$HeadersBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$HeadersBuilder!predicate"
                            ]
                        ],
                  method =
                    _js2n__-prdslib.enum
                        [
                          "GET",
                          "HEAD",
                          "POST",
                          "PUT",
                          "DELETE",
                          "OPTIONS",
                          "PATCH",
                          "TRACE",
                          "CONNECT"
                        ],
                  metric =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  path =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.StringGeneratorImplBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  sla =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder$ListBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.config.SLABuilder$ListBuilder!predicate"
                            ]
                        ],
                  sync = _js2n__-prdslib.isType '"Bool",
                  timeout = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$CompensationBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  metric =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  targetRate =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.util.DoubleIncrementBuilder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.util.DoubleIncrementBuilder!predicate"
                            ],
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$CompressionBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  encoding = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.enum
                        [ "CONTENT_ENCODING", "TRANSFER_ENCODING" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$HeadersBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$PartialHeadersBuilder!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder$PartialHeadersBuilder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVar = _js2n__-prdslib.isType '"String",
                  pattern = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/io.hyperfoil.http.steps.HttpResponseHandlersImpl$Builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  autoRangeCheck = _js2n__-prdslib.isType '"Bool",
                  body =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.Processor$Builder!predicate"
                            ]
                        ],
                  followRedirect =
                    _js2n__-prdslib.enum
                        [ "NEVER", "LOCATION_ONLY", "HTML_ONLY", "ALWAYS" ],
                  header =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.HeaderHandler$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.HeaderHandler$Builder!predicate"
                            ]
                        ],
                  onCompletion =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.session.Action$Builder!predicate"
                            ]
                        ],
                  rawBytes =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.RawBytesHandler$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.api.processor.RawBytesHandler$Builder!predicate"
                            ]
                        ],
                  status =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.StatusHandler$Builder!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.api.StatusHandler$Builder!predicate"
                            ]
                        ],
                  stopOnInvalid = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/phase!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "scenario" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "forks" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  duration =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                  forks =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.maxProperties 1,
                                    _js2n__-prdslib.records.minProperties 1,
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-refsenv."_js2n__-:definitions/fork!predicate"
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-refsenv."_js2n__-:definitions/fork!predicate"
                            ]
                        ],
                  maxDuration =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                  maxIterations =
                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                  scenario =
                    _js2n__-refsenv."_js2n__-:definitions/scenario!predicate",
                  startAfter =
                    _js2n__-refsenv."_js2n__-:definitions/phaseReferenceList!predicate",
                  startAfterStrict =
                    _js2n__-refsenv."_js2n__-:definitions/phaseReferenceList!predicate",
                  startTime =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/phaseReference!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "phase" ],
                  _js2n__-prdslib.records.record
                    {
                      fork = _js2n__-prdslib.isType '"String",
                      iteration =
                        _js2n__-prdslib.enum [ "none", "previous", "same" ],
                      phase = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/phaseReferenceList!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/phaseReference!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/phaseReference!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ]
            ],
      "_js2n__-:definitions/positiveInteger!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Integer,
                _js2n__-prdslib.numbers.minimum 1
              ]),
      "_js2n__-:definitions/positiveInteger!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/positiveNumber!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.exclusiveMinimum 0
            ],
      "_js2n__-:definitions/rampRatePhase!predicate"
        | doc "Add new users to the system at varying rate."
        = _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/phase!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required
                    [ "initialUsersPerSec", "targetUsersPerSec" ],
                  _js2n__-prdslib.records.record
                    {
                      initialUsersPerSec =
                        _js2n__-refsenv."_js2n__-:definitions/incrementableNumber!predicate",
                      maxSessions =
                        _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                      targetUsersPerSec =
                        _js2n__-refsenv."_js2n__-:definitions/incrementableNumber!predicate",
                      variance = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/scenario!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        initialSequences =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/sequence!predicate"
                              ],
                        orderedSequences =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/sequence!predicate"
                              ],
                        sequences =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.strings.minLength 1,
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/sequence!predicate"
                              ],
                      } {} false _js2n__-prdslib.never
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/sequence!predicate",
                    _js2n__-prdslib.arrays.minItems 1
                  ]
              ]),
      "_js2n__-:definitions/scenario!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      initialSequences =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/sequence!predicate"
                            ],
                      orderedSequences =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/sequence!predicate"
                            ],
                      sequences =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/sequence!predicate"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/sequence!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ]
            ],
      "_js2n__-:definitions/sequence!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/step!predicate"
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/step!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      addItem =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.AddItemAction$Builder!predicate",
                      addToInt =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.AddToIntAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      addToSharedCounter =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.AddToSharedCounterAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      awaitAllResponses =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.AwaitAllResponsesStep$Builder!predicate",
                      awaitDelay =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.AwaitDelayStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      awaitInt =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.AwaitIntStep$Builder!predicate",
                      awaitVar =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.AwaitVarStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      breakIfFinished =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.BreakIfFinishedStep$Builder!predicate",
                      breakSequence =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.BreakSequenceStep$Builder!predicate",
                      clearHttpCache =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.ClearHttpCacheAction$Builder!predicate",
                      conditional =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.ConditionalAction$Builder!predicate",
                      divide =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.example.DivideStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      fail =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.FailAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      foreach =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.ForeachStep$Builder!predicate",
                      getIndex =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetIndexAction$Builder!predicate",
                      getItem =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetItemAction$Builder!predicate",
                      getSharedCounter =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.GetSharedCounterAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      getSize =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.GetSizeAction$Builder!predicate",
                      hotrodRequest =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.hotrod.steps.HotRodRequestBuilder!predicate",
                      httpRequest =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.http.steps.HttpRequestStepBuilder!predicate",
                      json =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.JsonStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      log =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.LogAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      loop =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.LoopStep$Builder!predicate",
                      markRequestInvalid =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.MarkRequestInvalidAction$Builder!predicate",
                      newSequence =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.handlers.NewSequenceAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      nextSequence =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.NextSequenceStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      noop =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.NoopStep$Builder!predicate",
                      publishAgentData =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishAgentDataAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      publishGlobalCounters =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PublishGlobalCountersAction$Builder!predicate",
                      pullSharedMap =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PullSharedMapStep$Builder!predicate",
                      pushSharedMap =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.PushSharedMapStep$Builder!predicate",
                      randomCsvRow =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomCsvRowStep$Builder!predicate",
                      randomFile =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomFileStep$Builder!predicate",
                      randomInt =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomIntStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      randomItem =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomItemStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      randomUUID =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.RandomUUIDStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      readAgentData =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.ReadAgentDataAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      removeItem =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.RemoveItemAction$Builder!predicate",
                      restartSequence =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.RestartSequenceStep$Builder!predicate",
                      scheduleDelay =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.ScheduleDelayStep$Builder!predicate",
                      set =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      setInt =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.SetIntAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      setItem =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.collections.SetItemAction$Builder!predicate",
                      setSharedCounter =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.data.SetSharedCounterAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      stop =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.StopStep$Builder!predicate",
                      stopwatch =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.StopwatchBeginStep$Builder!predicate",
                      stringToInt =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.StringToIntAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      template =
                        _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.generators.TemplateStep$Builder!predicate",
                      thinkTime =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.ScheduleDelayStep$ThinkTimeBuilder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      timestamp =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.TimestampStep$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                      unset =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/io.hyperfoil.core.steps.UnsetAction$Builder!predicate",
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.enum
                [
                  "stop",
                  "restartSequence",
                  "breakIfFinished",
                  "noop",
                  "awaitAllResponses",
                  "stopwatch"
                ]
            ],
      "_js2n__-:definitions/timeMillis!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType 'Integer,
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "[0-9]* *[smh]?"
                  ]
              ]),
      "_js2n__-:definitions/timeMillis!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "[0-9]* *[smh]?"
                ]
            ],
    }
    in
  {
      "$schema"
        | String
        | doc "This should point to either http://hyperfoil.io/schema or local file"
        | optional,
      agents
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      ".*" =
                        _js2n__-refsenv."_js2n__-:definitions/agent!predicate",
                    } true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.maxProperties 1,
                        _js2n__-prdslib.records.minProperties 1,
                        _js2n__-prdslib.records.record {}
                          {
                            ".*" =
                              _js2n__-refsenv."_js2n__-:definitions/agent!predicate",
                          } true _js2n__-prdslib.always
                      ])
                ]
            ])
        | doc "Agent nodes that should drive the load."
        | optional,
      duration
        | _js2n__-refsenv."_js2n__-:definitions/timeMillis!contract"
        | doc "Single-phase shortcut: Time relative to phase start for the phase to be finished."
        | optional,
      ergonomics
        | _js2n__-refsenv."_js2n__-:definitions/ergonomics!contract"
        | optional,
      http
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/http!predicate"
                ],
              _js2n__-refsenv."_js2n__-:definitions/http!predicate"
            ]),
      maxDuration
        | _js2n__-refsenv."_js2n__-:definitions/timeMillis!contract"
        | doc "Single-phase shortcut: Hard limit, relative to phase start, after which the phase will be terminated."
        | optional,
      maxSessions
        | _js2n__-refsenv."_js2n__-:definitions/positiveInteger!contract"
        | doc "Single-phase shortcut: Maximum number of users (active sessions) executing this phase concurrently."
        | optional,
      name | String | doc "Name of the benchmark.",
      phases
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.maxProperties 1,
                    _js2n__-prdslib.records.minProperties 1,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              always =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/phase!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "users" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              users =
                                                _js2n__-refsenv."_js2n__-:definitions/incrementableInteger!predicate",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              atOnce =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/phase!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "users" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              users =
                                                _js2n__-refsenv."_js2n__-:definitions/incrementableInteger!predicate",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              constantRate =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/phase!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "usersPerSec" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              maxSessions =
                                                _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                                              usersPerSec =
                                                _js2n__-refsenv."_js2n__-:definitions/incrementableNumber!predicate",
                                              variance =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              decreasingRate =
                                _js2n__-refsenv."_js2n__-:definitions/rampRatePhase!predicate",
                              increasingRate =
                                _js2n__-refsenv."_js2n__-:definitions/rampRatePhase!predicate",
                              noop =
                                _js2n__-refsenv."_js2n__-:definitions/phase!predicate",
                            } {} false _js2n__-prdslib.never
                        ])
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ])
        | doc "Benchmark execution phases."
        | optional,
      scenario
        | _js2n__-refsenv."_js2n__-:definitions/scenario!contract"
        | doc "Single-phase shortcut: the scenario"
        | optional,
      staircase
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  incrementUsersPerSec =
                    _js2n__-refsenv."_js2n__-:definitions/positiveNumber!predicate",
                  initialRampUpDuration =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                  initialUsersPerSec =
                    _js2n__-refsenv."_js2n__-:definitions/positiveNumber!predicate",
                  maxIterations =
                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                  maxSessions =
                    _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                  rampUpDuration =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                  steadyStateDuration =
                    _js2n__-refsenv."_js2n__-:definitions/timeMillis!predicate",
                } {} false _js2n__-prdslib.never
            ])
        | optional,
      threads
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ])
        | optional,
      usersPerSec
        | _js2n__-refsenv."_js2n__-:definitions/incrementableNumber!contract"
        | doc "Single-phase shortcut: Rate for new users"
        | optional,
    }