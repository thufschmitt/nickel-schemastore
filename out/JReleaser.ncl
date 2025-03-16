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
      "_js2n__-:definitions/Active!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'SNAPSHOT,
                'RELEASE_PRERELEASE,
                'PRERELEASE,
                'RELEASE,
                'NEVER,
                'ALWAYS
              |]
            ],
      "_js2n__-:definitions/Active!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ALWAYS",
                  "NEVER",
                  "RELEASE",
                  "PRERELEASE",
                  "RELEASE_PRERELEASE",
                  "SNAPSHOT"
                ]
            ],
      "_js2n__-:definitions/Algorithm!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'SHA3_512,
                'SHA3_384,
                'SHA3_256,
                'SHA3_224,
                'SHA_512,
                'SHA_384,
                'SHA_256,
                'SHA_1,
                'RMD160,
                'MD5,
                'MD2
              |]
            ],
      "_js2n__-:definitions/Announce!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            article
              | _js2n__-refsenv."_js2n__-:definitions/ArticleAnnouncer!contract"
              | optional,
            bluesky
              | _js2n__-refsenv."_js2n__-:definitions/BlueskyAnnouncer!contract"
              | optional,
            configuredHttp
              | _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncers!contract"
              | optional,
            configuredWebhooks
              | _js2n__-refsenv."_js2n__-:definitions/WebhooksAnnouncer!contract"
              | optional,
            discord
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/DiscordAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            discourse
              | _js2n__-refsenv."_js2n__-:definitions/DiscourseAnnouncer!contract"
              | optional,
            discussions
              | _js2n__-refsenv."_js2n__-:definitions/DiscussionsAnnouncer!contract"
              | optional,
            gitter
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GitterAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            googleChat
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GoogleChatAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            http
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncer!predicate"
                      ]
                  ])
              | optional,
            linkedin
              | _js2n__-refsenv."_js2n__-:definitions/LinkedinAnnouncer!contract"
              | optional,
            mail
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/SmtpAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            mastodon
              | _js2n__-refsenv."_js2n__-:definitions/MastodonAnnouncer!contract"
              | optional,
            mattermost
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/MattermostAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            openCollective
              | _js2n__-refsenv."_js2n__-:definitions/OpenCollectiveAnnouncer!contract"
              | optional,
            sdkman
              | _js2n__-refsenv."_js2n__-:definitions/SdkmanAnnouncer!contract"
              | optional,
            slack
              | _js2n__-refsenv."_js2n__-:definitions/SlackAnnouncer!contract"
              | optional,
            smtp
              | _js2n__-refsenv."_js2n__-:definitions/SmtpAnnouncer!contract"
              | optional,
            teams
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/TeamsAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            telegram
              | _js2n__-refsenv."_js2n__-:definitions/TelegramAnnouncer!contract"
              | optional,
            twitter
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/TwitterAnnouncer!predicate",
                    _js2n__-prdslib.always
                  ])
              | optional,
            webhooks
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/WebhookAnnouncerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/WebhookAnnouncer!predicate"
                      ]
                  ])
              | optional,
            zulip
              | _js2n__-refsenv."_js2n__-:definitions/ZulipAnnouncer!contract"
              | optional,
          },
      "_js2n__-:definitions/AppImagePackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            categories | Array (String) | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            componentId | String | optional,
            continueOnError | Bool | optional,
            developerName | String | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            icons
              | Array _js2n__-refsenv."_js2n__-:definitions/Icon!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/AppImageRepository!contract"
              | optional,
            requiresTerminal | Bool | optional,
            screenshots
              | Array _js2n__-refsenv."_js2n__-:definitions/Screenshot!contract"
              | optional,
            skipReleases | Array (String) | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/AppImagePackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  categories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  componentId = _js2n__-prdslib.isType '"String",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  developerName = _js2n__-prdslib.isType '"String",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  icons =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Icon!predicate"
                        ],
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/AppImageRepository!predicate",
                  requiresTerminal = _js2n__-prdslib.isType '"Bool",
                  screenshots =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Screenshot!predicate"
                        ],
                  skipReleases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AppImageRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/AppImageRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Append!contract" =
        {
            content | String | optional,
            contentTemplate | String | optional,
            enabled | Bool | optional,
            target | String | optional,
            title | String | optional,
          },
      "_js2n__-:definitions/ApplicationPackage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appName = _js2n__-prdslib.isType '"String",
                  appVersion = _js2n__-prdslib.isType '"String",
                  copyright = _js2n__-prdslib.isType '"String",
                  fileAssociations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  licenseFile = _js2n__-prdslib.isType '"String",
                  vendor = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Apply!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'FORCE, 'WARN, 'ALWAYS, 'NEVER |] ],
      "_js2n__-:definitions/Architecture!contract" =
        {
            buildOn | Array (String) | optional,
            ignoreError | Bool | optional,
            runOn | Array (String) | optional,
          },
      "_js2n__-:definitions/Architecture!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  buildOn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreError = _js2n__-prdslib.isType '"Bool",
                  runOn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArchiveAssembler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyDefaultMatrix = _js2n__-prdslib.isType '"Bool",
                  archiveName = _js2n__-prdslib.isType '"String",
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  attachPlatform = _js2n__-prdslib.isType '"Bool",
                  distributionType =
                    _js2n__-refsenv."_js2n__-:definitions/DistributionType!predicate",
                  exported = _js2n__-prdslib.isType '"Bool",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fileSets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate"
                        ],
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  formats =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Format-1!predicate"
                        ],
                  matrix =
                    _js2n__-refsenv."_js2n__-:definitions/Matrix!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ArchiveOptions!predicate",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  swid =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArchiveAssemblerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/ArchiveAssembler!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/ArchiveAssembler!predicate"
            ],
      "_js2n__-:definitions/ArchiveOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bigNumberMode =
                    _js2n__-refsenv."_js2n__-:definitions/TarMode!predicate",
                  longFileMode =
                    _js2n__-refsenv."_js2n__-:definitions/TarMode!predicate",
                  timestamp = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArticleAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            files
              | Array _js2n__-refsenv."_js2n__-:definitions/Artifact!contract"
              | optional,
            readTimeout | std.number.Integer | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/Repository!contract"
              | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/Artifact!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            path | String | optional,
            platform | String | optional,
            transform | String | optional,
          },
      "_js2n__-:definitions/Artifact!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  path = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  transform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArtifactOverride!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactId = _js2n__-prdslib.isType '"String",
                  groupId = _js2n__-prdslib.isType '"String",
                  jar = _js2n__-prdslib.isType '"Bool",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArtifactoryMavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArtifactoryMavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/ArtifactoryMavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/ArtifactoryMavenDeployer!predicate"
            ],
      "_js2n__-:definitions/ArtifactoryRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  fileTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileType!predicate"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArtifactoryUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  host = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactoryRepository!predicate"
                        ],
                  signatures = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ArtifactoryUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/ArtifactoryUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/ArtifactoryUploader!predicate"
            ],
      "_js2n__-:definitions/AsdfPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/AsdfRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
            toolCheck | String | optional,
          },
      "_js2n__-:definitions/AsdfPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/AsdfRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  toolCheck = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AsdfRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/AsdfRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Assemble!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            archive
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ArchiveAssemblerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/ArchiveAssembler!predicate"
                      ]
                  ])
              | optional,
            deb
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/Map(String,DebAssembler)!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/DebAssembler!predicate"
                      ]
                  ])
              | optional,
            javaArchive
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/JavaArchiveAssemblerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/JavaArchiveAssembler!predicate"
                      ]
                  ])
              | optional,
            jlink
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/JlinkAssemblerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/JlinkAssembler!predicate"
                      ]
                  ])
              | optional,
            jpackage
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/JpackageAssemblerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/JpackageAssembler!predicate"
                      ]
                  ])
              | optional,
            nativeImage
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/NativeImageAssemblerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/NativeImageAssembler!predicate"
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Asset!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  input = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  unpack =
                    _js2n__-refsenv."_js2n__-:definitions/Unpack!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Authorization!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "BASIC", "BEARER" ]
            ],
      "_js2n__-:definitions/AzureMavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AzureMavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/AzureMavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/AzureMavenDeployer!predicate"
            ],
      "_js2n__-:definitions/BlueskyAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            handle | String | optional,
            host | String | optional,
            password | String | optional,
            readTimeout | std.number.Integer | optional,
            status | String | optional,
            statusTemplate | String | optional,
            statuses | Array (String) | optional,
          },
      "_js2n__-:definitions/BrewPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            cask
              | _js2n__-refsenv."_js2n__-:definitions/Cask!contract"
              | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            dependencies
              | Array _js2n__-refsenv."_js2n__-:definitions/Dependency!contract"
              | optional,
            downloadStrategy | String | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            formulaName | String | optional,
            livecheck | Array (String) | optional,
            multiPlatform | Bool | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/HomebrewRepository!contract"
              | optional,
            requireRelative | Array (String) | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/BrewPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  cask = _js2n__-refsenv."_js2n__-:definitions/Cask!predicate",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  downloadStrategy = _js2n__-prdslib.isType '"String",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  formulaName = _js2n__-prdslib.isType '"String",
                  livecheck =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  multiPlatform = _js2n__-prdslib.isType '"Bool",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/HomebrewRepository!predicate",
                  requireRelative =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Buildx!contract" =
        {
            createBuilder | Bool | optional,
            createBuilderFlags | Array (String) | optional,
            enabled | Bool | optional,
            platforms | Array (String) | optional,
          },
      "_js2n__-:definitions/Buildx!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  createBuilder = _js2n__-prdslib.isType '"Bool",
                  createBuilderFlags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  platforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Cask!contract" =
        {
            appName | String | optional,
            appcast | String | optional,
            displayName | String | optional,
            enabled | Bool | optional,
            name | String | optional,
            pkgName | String | optional,
            uninstall
              | Array _js2n__-refsenv."_js2n__-:definitions/CaskItem!contract"
              | optional,
            zap
              | Array _js2n__-refsenv."_js2n__-:definitions/CaskItem!contract"
              | optional,
          },
      "_js2n__-:definitions/Cask!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appName = _js2n__-prdslib.isType '"String",
                  appcast = _js2n__-prdslib.isType '"String",
                  displayName = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  pkgName = _js2n__-prdslib.isType '"String",
                  uninstall =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CaskItem!predicate"
                        ],
                  zap =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CaskItem!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CaskItem!contract" =
        { items | Array (String) | optional, name | String | optional, },
      "_js2n__-:definitions/CaskItem!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Catalog!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            github
              | _js2n__-refsenv."_js2n__-:definitions/GithubCataloger!contract"
              | optional,
            sbom
              | _js2n__-refsenv."_js2n__-:definitions/Sbom!contract"
              | optional,
            slsa
              | _js2n__-refsenv."_js2n__-:definitions/SlsaCataloger!contract"
              | optional,
            swid
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/SwidTagMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate"
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Category!contract" =
        {
            format | String | optional,
            key | String | optional,
            labels | Array (String) | optional,
            order | std.number.Integer | optional,
            title | String | optional,
          },
      "_js2n__-:definitions/Changelog!contract" =
        {
            append
              | _js2n__-refsenv."_js2n__-:definitions/Append!contract"
              | optional,
            categories
              | Array _js2n__-refsenv."_js2n__-:definitions/Category!contract"
              | optional,
            categoryTitleFormat | String | optional,
            content | String | optional,
            contentTemplate | String | optional,
            contributors
              | _js2n__-refsenv."_js2n__-:definitions/Contributors!contract"
              | optional,
            contributorsTitleFormat | String | optional,
            enabled | Bool | optional,
            excludeLabels | Array (String) | optional,
            external | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            format | String | optional,
            formatted
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            hide
              | _js2n__-refsenv."_js2n__-:definitions/Hide!contract"
              | optional,
            includeLabels | Array (String) | optional,
            labelers
              | Array _js2n__-refsenv."_js2n__-:definitions/Labeler!contract"
              | optional,
            links | Bool | optional,
            preset | String | optional,
            replacers
              | Array _js2n__-refsenv."_js2n__-:definitions/Replacer!contract"
              | optional,
            skipMergeCommits | Bool | optional,
            sort
              | _js2n__-refsenv."_js2n__-:definitions/Sort!contract"
              | optional,
          },
      "_js2n__-:definitions/Checksum!contract" =
        {
            algorithms
              | Array _js2n__-refsenv."_js2n__-:definitions/Algorithm!contract"
              | optional,
            artifacts | Bool | optional,
            files | Bool | optional,
            individual | Bool | optional,
            name | String | optional,
          },
      "_js2n__-:definitions/ChocolateyPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            apiKey | String | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            iconUrl | String | optional,
            packageName | String | optional,
            packageVersion | String | optional,
            remoteBuild | Bool | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/ChocolateyRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            source | String | optional,
            templateDirectory | String | optional,
            title | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/ChocolateyPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  apiKey = _js2n__-prdslib.isType '"String",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  iconUrl = _js2n__-prdslib.isType '"String",
                  packageName = _js2n__-prdslib.isType '"String",
                  packageVersion = _js2n__-prdslib.isType '"String",
                  remoteBuild = _js2n__-prdslib.isType '"Bool",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/ChocolateyRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  source = _js2n__-prdslib.isType '"String",
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ChocolateyRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/ChocolateyRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CodebergReleaser!contract" =
        {
            apiEndpoint | String | optional,
            artifacts | Bool | optional,
            branch | String | optional,
            branchPush | String | optional,
            catalogs | Bool | optional,
            changelog
              | _js2n__-refsenv."_js2n__-:definitions/Changelog!contract"
              | optional,
            checksums | Bool | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            commitUrl | String | optional,
            connectTimeout | std.number.Integer | optional,
            downloadUrl | String | optional,
            draft | Bool | optional,
            enabled | Bool | optional,
            files | Bool | optional,
            host | String | optional,
            issueTrackerUrl | String | optional,
            issues
              | _js2n__-refsenv."_js2n__-:definitions/Issues!contract"
              | optional,
            latestReleaseUrl | String | optional,
            milestone
              | _js2n__-refsenv."_js2n__-:definitions/Milestone!contract"
              | optional,
            name | String | optional,
            overwrite | Bool | optional,
            owner | String | optional,
            prerelease
              | _js2n__-refsenv."_js2n__-:definitions/Prerelease!contract"
              | optional,
            previousTagName | String | optional,
            readTimeout | std.number.Integer | optional,
            releaseName | String | optional,
            releaseNotesUrl | String | optional,
            repoCloneUrl | String | optional,
            repoUrl | String | optional,
            sign | Bool | optional,
            signatures | Bool | optional,
            skipRelease | Bool | optional,
            skipTag | Bool | optional,
            srcUrl | String | optional,
            tagName | String | optional,
            token | String | optional,
            update
              | _js2n__-refsenv."_js2n__-:definitions/Update!contract"
              | optional,
            uploadAssets
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/Command-1!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'MINOR, 'MAJOR |] ],
      "_js2n__-:definitions/Command-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "MAJOR", "MINOR" ]
            ],
      "_js2n__-:definitions/Command-2!contract" =
        {
            args | Array (String) | optional,
            defaultKeyring | Bool | optional,
            executable | String | optional,
            homeDir | String | optional,
            keyName | String | optional,
            publicKeyring | String | optional,
          },
      "_js2n__-:definitions/CommandHook!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            applyDefaultMatrix | Bool | optional,
            cmd | String | optional,
            condition | String | optional,
            continueOnError | Bool | optional,
            environment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            filter
              | _js2n__-refsenv."_js2n__-:definitions/Filter!contract"
              | optional,
            matrix
              | _js2n__-refsenv."_js2n__-:definitions/Matrix!contract"
              | optional,
            platforms | Array (String) | optional,
            verbose | Bool | optional,
          },
      "_js2n__-:definitions/CommandHooks!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            applyDefaultMatrix | Bool | optional,
            before
              | Array
                _js2n__-refsenv."_js2n__-:definitions/CommandHook!contract"
              | optional,
            condition | String | optional,
            environment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            failure
              | Array
                _js2n__-refsenv."_js2n__-:definitions/CommandHook!contract"
              | optional,
            matrix
              | _js2n__-refsenv."_js2n__-:definitions/Matrix!contract"
              | optional,
            success
              | Array
                _js2n__-refsenv."_js2n__-:definitions/CommandHook!contract"
              | optional,
          },
      "_js2n__-:definitions/CommitAuthor!contract" =
        { email | String | optional, name | String | optional, },
      "_js2n__-:definitions/CommitAuthor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  email = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Contributors!contract" =
        { enabled | Bool | optional, format | String | optional, },
      "_js2n__-:definitions/Control!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  breaks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  builtUsing = _js2n__-prdslib.isType '"String",
                  conflicts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  depends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  enhances =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  essential = _js2n__-prdslib.isType '"Bool",
                  homepage = _js2n__-prdslib.isType '"String",
                  maintainer = _js2n__-prdslib.isType '"String",
                  packageName = _js2n__-prdslib.isType '"String",
                  packageRevision = _js2n__-prdslib.isType 'Integer,
                  packageVersion = _js2n__-prdslib.isType '"String",
                  preDepends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "priority" =
                    _js2n__-refsenv."_js2n__-:definitions/Priority!predicate",
                  provides = _js2n__-prdslib.isType '"String",
                  recommends =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  section =
                    _js2n__-refsenv."_js2n__-:definitions/Section!predicate",
                  suggests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Cosign!contract" =
        {
            privateKeyFile | String | optional,
            publicKeyFile | String | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/CyclonedxSbomCataloger!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            distributions | Bool | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            files | Bool | optional,
            formats
              | Array _js2n__-refsenv."_js2n__-:definitions/Format-2!contract"
              | optional,
            pack
              | _js2n__-refsenv."_js2n__-:definitions/Pack!contract"
              | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/DebAssembler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  architecture = _js2n__-prdslib.isType '"String",
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  assemblerRef = _js2n__-prdslib.isType '"String",
                  control =
                    _js2n__-refsenv."_js2n__-:definitions/Control!predicate",
                  distributionType =
                    _js2n__-refsenv."_js2n__-:definitions/DistributionType!predicate",
                  executable = _js2n__-prdslib.isType '"String",
                  exported = _js2n__-prdslib.isType '"Bool",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fileSets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate"
                        ],
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  installationPath = _js2n__-prdslib.isType '"String",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  swid =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Dependencies!contract" =
        {
            externalDependencies | Array (String) | optional,
            packageDependencies
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PackageDependency!contract"
              | optional,
            windowsFeatures | Array (String) | optional,
            windowsLibraries | Array (String) | optional,
          },
      "_js2n__-:definitions/Dependencies!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  externalDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  packageDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PackageDependency!predicate"
                        ],
                  windowsFeatures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  windowsLibraries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Dependency!contract" =
        { key | String | optional, value | String | optional, },
      "_js2n__-:definitions/Dependency!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Deploy!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            maven
              | _js2n__-refsenv."_js2n__-:definitions/Maven!contract"
              | optional,
          },
      "_js2n__-:definitions/DiscordAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  webhook = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DiscourseAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            apiKey | String | optional,
            categoryName | String | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            host | String | optional,
            message | String | optional,
            messageTemplate | String | optional,
            readTimeout | std.number.Integer | optional,
            title | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/DiscussionsAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            message | String | optional,
            messageTemplate | String | optional,
            organization | String | optional,
            readTimeout | std.number.Integer | optional,
            team | String | optional,
            title | String | optional,
          },
      "_js2n__-:definitions/Distribution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  appImage =
                    _js2n__-refsenv."_js2n__-:definitions/AppImagePackager!predicate",
                  applyDefaultMatrix = _js2n__-prdslib.isType '"Bool",
                  artifactPattern =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  asdf =
                    _js2n__-refsenv."_js2n__-:definitions/AsdfPackager!predicate",
                  brew =
                    _js2n__-refsenv."_js2n__-:definitions/BrewPackager!predicate",
                  chocolatey =
                    _js2n__-refsenv."_js2n__-:definitions/ChocolateyPackager!predicate",
                  docker =
                    _js2n__-refsenv."_js2n__-:definitions/DockerPackager!predicate",
                  executable =
                    _js2n__-refsenv."_js2n__-:definitions/Executable!predicate",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  flatpak =
                    _js2n__-refsenv."_js2n__-:definitions/FlatpakPackager!predicate",
                  gofish =
                    _js2n__-refsenv."_js2n__-:definitions/GofishPackager!predicate",
                  java =
                    _js2n__-refsenv."_js2n__-:definitions/Java-2!predicate",
                  jbang =
                    _js2n__-refsenv."_js2n__-:definitions/JbangPackager!predicate",
                  jib =
                    _js2n__-refsenv."_js2n__-:definitions/JibPackager!predicate",
                  macports =
                    _js2n__-refsenv."_js2n__-:definitions/MacportsPackager!predicate",
                  matrix =
                    _js2n__-refsenv."_js2n__-:definitions/Matrix!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  scoop =
                    _js2n__-refsenv."_js2n__-:definitions/ScoopPackager!predicate",
                  sdkman =
                    _js2n__-refsenv."_js2n__-:definitions/SdkmanPackager!predicate",
                  snap =
                    _js2n__-refsenv."_js2n__-:definitions/SnapPackager!predicate",
                  spec =
                    _js2n__-refsenv."_js2n__-:definitions/SpecPackager!predicate",
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/DistributionType!predicate",
                  winget =
                    _js2n__-refsenv."_js2n__-:definitions/WingetPackager!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DistributionMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/Distribution!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/Distribution!predicate"
            ],
      "_js2n__-:definitions/DistributionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "BINARY",
                  "FLAT_BINARY",
                  "JAVA_BINARY",
                  "JLINK",
                  "SINGLE_JAR",
                  "NATIVE_IMAGE",
                  "NATIVE_PACKAGE"
                ]
            ],
      "_js2n__-:definitions/DockerPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            baseImage | String | optional,
            buildArgs | Array (String) | optional,
            buildx
              | _js2n__-refsenv."_js2n__-:definitions/Buildx!contract"
              | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            imageNames | Array (String) | optional,
            labels
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            postCommands | Array (String) | optional,
            preCommands | Array (String) | optional,
            registries
              | Array _js2n__-refsenv."_js2n__-:definitions/Registry-1!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/DockerRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            specs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/DockerSpecMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/DockerSpec!predicate"
                      ]
                  ])
              | optional,
            templateDirectory | String | optional,
            useLocalArtifact | Bool | optional,
          },
      "_js2n__-:definitions/DockerPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  baseImage = _js2n__-prdslib.isType '"String",
                  buildArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  buildx =
                    _js2n__-refsenv."_js2n__-:definitions/Buildx!predicate",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  imageNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  postCommands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  preCommands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  registries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Registry-1!predicate"
                        ],
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/DockerRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DockerSpecMap!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-refsenv."_js2n__-:definitions/DockerSpec!predicate"
                            ]
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  useLocalArtifact = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
            versionedSubfolders | Bool | optional,
          },
      "_js2n__-:definitions/DockerRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  versionedSubfolders = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerSpec!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifact =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  baseImage = _js2n__-prdslib.isType '"String",
                  buildArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  buildx =
                    _js2n__-refsenv."_js2n__-:definitions/Buildx!predicate",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  imageNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  matchers =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  postCommands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  preCommands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  registries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Registry-1!predicate"
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  useLocalArtifact = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerSpecMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/DockerSpec!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/DockerSpec!predicate"
            ],
      "_js2n__-:definitions/Download!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            ftp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/FtpDownloaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/FtpDownloader!predicate"
                      ]
                  ])
              | optional,
            http
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/HttpDownloaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/HttpDownloader!predicate"
                      ]
                  ])
              | optional,
            scp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ScpDownloaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/ScpDownloader!predicate"
                      ]
                  ])
              | optional,
            sftp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/SftpDownloaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/SftpDownloader!predicate"
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Entity!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  regid = _js2n__-prdslib.isType '"String",
                  roles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Environment!contract" =
        {
            properties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            variables | String | optional,
          },
      "_js2n__-:definitions/EnvironmentVariables!contract" =
        {
            linux
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            osx
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            universal
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            unix
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            windows
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/EnvironmentVariables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  linux =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  osx =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  universal =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  unix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  windows =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Executable!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  unixExtension = _js2n__-prdslib.isType '"String",
                  windowsExtension = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Extension!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  directory = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  gav = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  providers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Provider!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ExtensionMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/Extension!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/Extension!predicate"
            ],
      "_js2n__-:definitions/FileSet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  failOnMissingInput = _js2n__-prdslib.isType '"Bool",
                  includes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ASC",
                  "BAT",
                  "CMD",
                  "DEB",
                  "DMG",
                  "EXE",
                  "JAR",
                  "MSI",
                  "NUGET",
                  "PKG",
                  "PS1",
                  "RPM",
                  "SH",
                  "SIG",
                  "TAR",
                  "TAR_BZ2",
                  "TAR_GZ",
                  "TAR_XZ",
                  "TAR_ZST",
                  "TBZ2",
                  "TGZ",
                  "TXZ",
                  "ZIP",
                  "ZST"
                ]
            ],
      "_js2n__-:definitions/Files!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            artifacts
              | Array _js2n__-refsenv."_js2n__-:definitions/Artifact!contract"
              | optional,
            globs
              | Array _js2n__-refsenv."_js2n__-:definitions/Glob!contract"
              | optional,
          },
      "_js2n__-:definitions/Filter!contract" =
        {
            excludes | Array (String) | optional,
            includes | Array (String) | optional,
          },
      "_js2n__-:definitions/FlatpakPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            categories | Array (String) | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            componentId | String | optional,
            continueOnError | Bool | optional,
            developerName | String | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            finishArgs | Array (String) | optional,
            icons
              | Array _js2n__-refsenv."_js2n__-:definitions/Icon!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/FlatpakRepository!contract"
              | optional,
            runtime
              | _js2n__-refsenv."_js2n__-:definitions/Runtime!contract"
              | optional,
            runtimeVersion | String | optional,
            screenshots
              | Array _js2n__-refsenv."_js2n__-:definitions/Screenshot!contract"
              | optional,
            sdkExtensions | Array (String) | optional,
            skipReleases | Array (String) | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/FlatpakPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  categories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  componentId = _js2n__-prdslib.isType '"String",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  developerName = _js2n__-prdslib.isType '"String",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  finishArgs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  icons =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Icon!predicate"
                        ],
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/FlatpakRepository!predicate",
                  runtime =
                    _js2n__-refsenv."_js2n__-:definitions/Runtime!predicate",
                  runtimeVersion = _js2n__-prdslib.isType '"String",
                  screenshots =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Screenshot!predicate"
                        ],
                  sdkExtensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipReleases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FlatpakRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/FlatpakRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Format-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ZIP",
                  "TAR",
                  "TAR_BZ2",
                  "TAR_GZ",
                  "TAR_XZ",
                  "TAR_ZST",
                  "TBZ2",
                  "TGZ",
                  "TXZ"
                ]
            ],
      "_js2n__-:definitions/Format-2!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'PROTOBUF, 'XML, 'JSON |] ],
      "_js2n__-:definitions/Format-3!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'TEXT,
                'TABLE,
                'SPDX_JSON,
                'GITHUB_JSON,
                'CYCLONEDX_JSON,
                'CYCLONEDX_XML,
                'SYFT_JSON
              |]
            ],
      "_js2n__-:definitions/Format-4!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'OCI, 'DOCKER |] ],
      "_js2n__-:definitions/Format-4!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "DOCKER", "OCI" ]
            ],
      "_js2n__-:definitions/FtpDownloader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  assets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Asset!predicate"
                        ],
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  host = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FtpDownloaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/FtpDownloader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/FtpDownloader!predicate"
            ],
      "_js2n__-:definitions/FtpUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  host = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  signatures = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FtpUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/FtpUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/FtpUploader!predicate"
            ],
      "_js2n__-:definitions/GenericGitReleaser!contract" =
        {
            apiEndpoint | String | optional,
            artifacts | Bool | optional,
            branch | String | optional,
            branchPush | String | optional,
            catalogs | Bool | optional,
            changelog
              | _js2n__-refsenv."_js2n__-:definitions/Changelog!contract"
              | optional,
            checksums | Bool | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            commitUrl | String | optional,
            connectTimeout | std.number.Integer | optional,
            downloadUrl | String | optional,
            enabled | Bool | optional,
            files | Bool | optional,
            host | String | optional,
            issueTrackerUrl | String | optional,
            issues
              | _js2n__-refsenv."_js2n__-:definitions/Issues!contract"
              | optional,
            latestReleaseUrl | String | optional,
            milestone
              | _js2n__-refsenv."_js2n__-:definitions/Milestone!contract"
              | optional,
            name | String | optional,
            overwrite | Bool | optional,
            owner | String | optional,
            prerelease
              | _js2n__-refsenv."_js2n__-:definitions/Prerelease!contract"
              | optional,
            previousTagName | String | optional,
            readTimeout | std.number.Integer | optional,
            releaseName | String | optional,
            releaseNotesUrl | String | optional,
            repoCloneUrl | String | optional,
            repoUrl | String | optional,
            sign | Bool | optional,
            signatures | Bool | optional,
            skipRelease | Bool | optional,
            skipTag | Bool | optional,
            srcUrl | String | optional,
            tagName | String | optional,
            token | String | optional,
            update
              | _js2n__-refsenv."_js2n__-:definitions/Update!contract"
              | optional,
            uploadAssets
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/GiteaMavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GiteaMavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/GiteaMavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/GiteaMavenDeployer!predicate"
            ],
      "_js2n__-:definitions/GiteaReleaser!contract" =
        {
            apiEndpoint | String | optional,
            artifacts | Bool | optional,
            branch | String | optional,
            branchPush | String | optional,
            catalogs | Bool | optional,
            changelog
              | _js2n__-refsenv."_js2n__-:definitions/Changelog!contract"
              | optional,
            checksums | Bool | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            commitUrl | String | optional,
            connectTimeout | std.number.Integer | optional,
            downloadUrl | String | optional,
            draft | Bool | optional,
            enabled | Bool | optional,
            files | Bool | optional,
            host | String | optional,
            issueTrackerUrl | String | optional,
            issues
              | _js2n__-refsenv."_js2n__-:definitions/Issues!contract"
              | optional,
            latestReleaseUrl | String | optional,
            milestone
              | _js2n__-refsenv."_js2n__-:definitions/Milestone!contract"
              | optional,
            name | String | optional,
            overwrite | Bool | optional,
            owner | String | optional,
            prerelease
              | _js2n__-refsenv."_js2n__-:definitions/Prerelease!contract"
              | optional,
            previousTagName | String | optional,
            readTimeout | std.number.Integer | optional,
            releaseName | String | optional,
            releaseNotesUrl | String | optional,
            repoCloneUrl | String | optional,
            repoUrl | String | optional,
            sign | Bool | optional,
            signatures | Bool | optional,
            skipRelease | Bool | optional,
            skipTag | Bool | optional,
            srcUrl | String | optional,
            tagName | String | optional,
            token | String | optional,
            update
              | _js2n__-refsenv."_js2n__-:definitions/Update!contract"
              | optional,
            uploadAssets
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/GiteaUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  host = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  packageName = _js2n__-prdslib.isType '"String",
                  packageVersion = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  signatures = _js2n__-prdslib.isType '"Bool",
                  token = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GiteaUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/GiteaUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/GiteaUploader!predicate"
            ],
      "_js2n__-:definitions/GithubCataloger!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            artifacts | Bool | optional,
            attestationName | String | optional,
            deployables | Bool | optional,
            excludes | Array (String) | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            files | Bool | optional,
            includes | Array (String) | optional,
          },
      "_js2n__-:definitions/GithubMavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  repository = _js2n__-prdslib.isType '"String",
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GithubMavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/GithubMavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/GithubMavenDeployer!predicate"
            ],
      "_js2n__-:definitions/GithubReleaser!contract" =
        {
            apiEndpoint | String | optional,
            artifacts | Bool | optional,
            branch | String | optional,
            branchPush | String | optional,
            catalogs | Bool | optional,
            changelog
              | _js2n__-refsenv."_js2n__-:definitions/Changelog!contract"
              | optional,
            checksums | Bool | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            commitUrl | String | optional,
            connectTimeout | std.number.Integer | optional,
            discussionCategoryName | String | optional,
            downloadUrl | String | optional,
            draft | Bool | optional,
            enabled | Bool | optional,
            files | Bool | optional,
            host | String | optional,
            issueTrackerUrl | String | optional,
            issues
              | _js2n__-refsenv."_js2n__-:definitions/Issues!contract"
              | optional,
            latestReleaseUrl | String | optional,
            milestone
              | _js2n__-refsenv."_js2n__-:definitions/Milestone!contract"
              | optional,
            name | String | optional,
            overwrite | Bool | optional,
            owner | String | optional,
            prerelease
              | _js2n__-refsenv."_js2n__-:definitions/Prerelease!contract"
              | optional,
            previousTagName | String | optional,
            readTimeout | std.number.Integer | optional,
            releaseName | String | optional,
            releaseNotes
              | _js2n__-refsenv."_js2n__-:definitions/ReleaseNotes!contract"
              | optional,
            releaseNotesUrl | String | optional,
            repoCloneUrl | String | optional,
            repoUrl | String | optional,
            sign | Bool | optional,
            signatures | Bool | optional,
            skipRelease | Bool | optional,
            skipTag | Bool | optional,
            srcUrl | String | optional,
            tagName | String | optional,
            token | String | optional,
            update
              | _js2n__-refsenv."_js2n__-:definitions/Update!contract"
              | optional,
            uploadAssets
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/GitlabMavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  projectIdentifier = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitlabMavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/GitlabMavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/GitlabMavenDeployer!predicate"
            ],
      "_js2n__-:definitions/GitlabReleaser!contract" =
        {
            apiEndpoint | String | optional,
            artifacts | Bool | optional,
            branch | String | optional,
            branchPush | String | optional,
            catalogs | Bool | optional,
            changelog
              | _js2n__-refsenv."_js2n__-:definitions/Changelog!contract"
              | optional,
            checksums | Bool | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            commitUrl | String | optional,
            connectTimeout | std.number.Integer | optional,
            downloadUrl | String | optional,
            enabled | Bool | optional,
            files | Bool | optional,
            host | String | optional,
            issueTrackerUrl | String | optional,
            issues
              | _js2n__-refsenv."_js2n__-:definitions/Issues!contract"
              | optional,
            latestReleaseUrl | String | optional,
            milestone
              | _js2n__-refsenv."_js2n__-:definitions/Milestone!contract"
              | optional,
            name | String | optional,
            overwrite | Bool | optional,
            owner | String | optional,
            prerelease
              | _js2n__-refsenv."_js2n__-:definitions/Prerelease!contract"
              | optional,
            previousTagName | String | optional,
            projectIdentifier | String | optional,
            readTimeout | std.number.Integer | optional,
            releaseName | String | optional,
            releaseNotesUrl | String | optional,
            repoCloneUrl | String | optional,
            repoUrl | String | optional,
            sign | Bool | optional,
            signatures | Bool | optional,
            skipRelease | Bool | optional,
            skipTag | Bool | optional,
            srcUrl | String | optional,
            tagName | String | optional,
            token | String | optional,
            update
              | _js2n__-refsenv."_js2n__-:definitions/Update!contract"
              | optional,
            uploadAssets
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            uploadLinks
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/GitlabUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  host = _js2n__-prdslib.isType '"String",
                  packageName = _js2n__-prdslib.isType '"String",
                  packageVersion = _js2n__-prdslib.isType '"String",
                  projectIdentifier = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  signatures = _js2n__-prdslib.isType '"Bool",
                  token = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitlabUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/GitlabUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/GitlabUploader!predicate"
            ],
      "_js2n__-:definitions/GitterAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  webhook = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Glob!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            directory | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            pattern | String | optional,
            platform | String | optional,
          },
      "_js2n__-:definitions/Glob!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  directory = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  pattern = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GofishPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/GofishRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/GofishPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/GofishRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GofishRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/GofishRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GoogleChatAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  webhook = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Hide!contract" =
        {
            categories | Array (String) | optional,
            contributors | Array (String) | optional,
            uncategorized | Bool | optional,
          },
      "_js2n__-:definitions/HomebrewRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/HomebrewRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Hooks!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            applyDefaultMatrix | Bool | optional,
            command
              | _js2n__-refsenv."_js2n__-:definitions/CommandHooks!contract"
              | optional,
            condition | String | optional,
            environment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            matrix
              | _js2n__-refsenv."_js2n__-:definitions/Matrix!contract"
              | optional,
            script
              | _js2n__-refsenv."_js2n__-:definitions/ScriptHooks!contract"
              | optional,
          },
      "_js2n__-:definitions/HttpAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  bearerKeyword = _js2n__-prdslib.isType '"String",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  method =
                    _js2n__-refsenv."_js2n__-:definitions/Method!predicate",
                  password = _js2n__-prdslib.isType '"String",
                  payload = _js2n__-prdslib.isType '"String",
                  payloadTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HttpAnnouncerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncer!predicate"
            ],
      "_js2n__-:definitions/HttpAnnouncers!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            http
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/HttpAnnouncer!predicate"
                      ]
                  ])
              | optional,
            readTimeout | std.number.Integer | optional,
          },
      "_js2n__-:definitions/HttpDownloader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  assets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Asset!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HttpDownloaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/HttpDownloader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/HttpDownloader!predicate"
            ],
      "_js2n__-:definitions/HttpUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  method =
                    _js2n__-refsenv."_js2n__-:definitions/Method!predicate",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  signatures = _js2n__-prdslib.isType '"Bool",
                  uploadUrl = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HttpUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/HttpUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/HttpUploader!predicate"
            ],
      "_js2n__-:definitions/Icon!contract" =
        {
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            height | std.number.Integer | optional,
            primary | Bool | optional,
            url | String | optional,
            width | std.number.Integer | optional,
          },
      "_js2n__-:definitions/Icon!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  height = _js2n__-prdslib.isType 'Integer,
                  primary = _js2n__-prdslib.isType '"Bool",
                  url = _js2n__-prdslib.isType '"String",
                  width = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Installer!contract" =
        {
            command | String | optional,
            dependencies
              | _js2n__-refsenv."_js2n__-:definitions/Dependencies!contract"
              | optional,
            modes
              | Array _js2n__-refsenv."_js2n__-:definitions/Mode-1!contract"
              | optional,
            scope
              | _js2n__-refsenv."_js2n__-:definitions/Scope!contract"
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/Type-2!contract"
              | optional,
            upgradeBehavior
              | _js2n__-refsenv."_js2n__-:definitions/UpgradeBehavior!contract"
              | optional,
          },
      "_js2n__-:definitions/Installer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  dependencies =
                    _js2n__-refsenv."_js2n__-:definitions/Dependencies!predicate",
                  modes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Mode-1!predicate"
                        ],
                  scope =
                    _js2n__-refsenv."_js2n__-:definitions/Scope!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/Type-2!predicate",
                  upgradeBehavior =
                    _js2n__-refsenv."_js2n__-:definitions/UpgradeBehavior!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Issues!contract" =
        {
            applyMilestone
              | _js2n__-refsenv."_js2n__-:definitions/Apply!contract"
              | optional,
            comment | String | optional,
            enabled | Bool | optional,
            label
              | _js2n__-refsenv."_js2n__-:definitions/Label!contract"
              | optional,
          },
      "_js2n__-:definitions/JReleaserModel!contract"
        | doc "JReleaser 1.17.0"
        = {
            announce
              | _js2n__-refsenv."_js2n__-:definitions/Announce!contract"
              | optional,
            assemble
              | _js2n__-refsenv."_js2n__-:definitions/Assemble!contract"
              | optional,
            catalog
              | _js2n__-refsenv."_js2n__-:definitions/Catalog!contract"
              | optional,
            checksum
              | _js2n__-refsenv."_js2n__-:definitions/Checksum!contract"
              | optional,
            deploy
              | _js2n__-refsenv."_js2n__-:definitions/Deploy!contract"
              | optional,
            distributions
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/DistributionMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/Distribution!predicate"
                      ]
                  ])
              | optional,
            download
              | _js2n__-refsenv."_js2n__-:definitions/Download!contract"
              | optional,
            environment
              | _js2n__-refsenv."_js2n__-:definitions/Environment!contract"
              | optional,
            extensions
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ExtensionMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/Extension!predicate"
                      ]
                  ])
              | optional,
            files
              | _js2n__-refsenv."_js2n__-:definitions/Files!contract"
              | optional,
            hooks
              | _js2n__-refsenv."_js2n__-:definitions/Hooks!contract"
              | optional,
            matrix
              | _js2n__-refsenv."_js2n__-:definitions/Matrix!contract"
              | optional,
            packagers
              | _js2n__-refsenv."_js2n__-:definitions/Packagers!contract"
              | optional,
            platform
              | _js2n__-refsenv."_js2n__-:definitions/Platform!contract"
              | optional,
            project
              | _js2n__-refsenv."_js2n__-:definitions/Project!contract"
              | optional,
            release
              | _js2n__-refsenv."_js2n__-:definitions/Release!contract"
              | optional,
            signing
              | _js2n__-refsenv."_js2n__-:definitions/Signing!contract"
              | optional,
            upload
              | _js2n__-refsenv."_js2n__-:definitions/Upload!contract"
              | optional,
          },
      "_js2n__-:definitions/Java-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  environmentVariables =
                    _js2n__-refsenv."_js2n__-:definitions/EnvironmentVariables!predicate",
                  jvmOptions =
                    _js2n__-refsenv."_js2n__-:definitions/JvmOptions!predicate",
                  mainClass = _js2n__-prdslib.isType '"String",
                  mainModule = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Java-2!contract" =
        {
            artifactId | String | optional,
            enabled | Bool | optional,
            environmentVariables
              | _js2n__-refsenv."_js2n__-:definitions/EnvironmentVariables!contract"
              | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            groupId | String | optional,
            jvmOptions
              | _js2n__-refsenv."_js2n__-:definitions/JvmOptions!contract"
              | optional,
            mainClass | String | optional,
            mainModule | String | optional,
            multiProject | Bool | optional,
            options | Array (String) | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/Java-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifactId = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  environmentVariables =
                    _js2n__-refsenv."_js2n__-:definitions/EnvironmentVariables!predicate",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  groupId = _js2n__-prdslib.isType '"String",
                  jvmOptions =
                    _js2n__-refsenv."_js2n__-:definitions/JvmOptions!predicate",
                  mainClass = _js2n__-prdslib.isType '"String",
                  mainModule = _js2n__-prdslib.isType '"String",
                  multiProject = _js2n__-prdslib.isType '"Bool",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavaArchive!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  libDirectoryName = _js2n__-prdslib.isType '"String",
                  mainJarName = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavaArchiveAssembler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  archiveName = _js2n__-prdslib.isType '"String",
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  executable =
                    _js2n__-refsenv."_js2n__-:definitions/Executable!predicate",
                  exported = _js2n__-prdslib.isType '"Bool",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fileSets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate"
                        ],
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  formats =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Format-1!predicate"
                        ],
                  jars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  java =
                    _js2n__-refsenv."_js2n__-:definitions/Java-1!predicate",
                  mainJar =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ArchiveOptions!predicate",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  swid =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavaArchiveAssemblerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/JavaArchiveAssembler!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/JavaArchiveAssembler!predicate"
            ],
      "_js2n__-:definitions/JbangPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            alias | String | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/JbangRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/JbangPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  alias = _js2n__-prdslib.isType '"String",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/JbangRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JbangRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/JbangRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Jdeps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  ignoreMissingDeps = _js2n__-prdslib.isType '"Bool",
                  multiRelease = _js2n__-prdslib.isType '"String",
                  targets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  useWildcardInPath = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JibPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            baseImage | String | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            creationTime | String | optional,
            downloadUrl | String | optional,
            environment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            exposedPorts | Array (String) | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            format
              | _js2n__-refsenv."_js2n__-:definitions/Format-4!contract"
              | optional,
            imageNames | Array (String) | optional,
            labels
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            registries
              | Array _js2n__-refsenv."_js2n__-:definitions/Registry-2!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/JibRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            specs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/JibSpecMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/JibSpec!predicate"
                      ]
                  ])
              | optional,
            templateDirectory | String | optional,
            user | String | optional,
            version | String | optional,
            volumes | Array (String) | optional,
            workingDirectory | String | optional,
          },
      "_js2n__-:definitions/JibPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  baseImage = _js2n__-prdslib.isType '"String",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  creationTime = _js2n__-prdslib.isType '"String",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  environment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  exposedPorts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/Format-4!predicate",
                  imageNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  registries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Registry-2!predicate"
                        ],
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/JibRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  specs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/JibSpecMap!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-refsenv."_js2n__-:definitions/JibSpec!predicate"
                            ]
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  user = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  workingDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JibRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
            versionedSubfolders | Bool | optional,
          },
      "_js2n__-:definitions/JibRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  versionedSubfolders = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JibSpec!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifact =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  baseImage = _js2n__-prdslib.isType '"String",
                  creationTime = _js2n__-prdslib.isType '"String",
                  environment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  exposedPorts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/Format-4!predicate",
                  imageNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  matchers =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  registries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Registry-2!predicate"
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  user = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  workingDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JibSpecMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/JibSpec!predicate",
                } true _js2n__-refsenv."_js2n__-:definitions/JibSpec!predicate"
            ],
      "_js2n__-:definitions/JlinkAssembler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  additionalModuleNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  applyDefaultMatrix = _js2n__-prdslib.isType '"Bool",
                  archiveFormat =
                    _js2n__-refsenv."_js2n__-:definitions/Format-1!predicate",
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  copyJars = _js2n__-prdslib.isType '"Bool",
                  executable = _js2n__-prdslib.isType '"String",
                  exported = _js2n__-prdslib.isType '"Bool",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fileSets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate"
                        ],
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  imageName = _js2n__-prdslib.isType '"String",
                  imageNameTransform = _js2n__-prdslib.isType '"String",
                  jars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  java =
                    _js2n__-refsenv."_js2n__-:definitions/Java-2!predicate",
                  javaArchive =
                    _js2n__-refsenv."_js2n__-:definitions/JavaArchive!predicate",
                  jdeps =
                    _js2n__-refsenv."_js2n__-:definitions/Jdeps!predicate",
                  jdk =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  mainJar =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  matrix =
                    _js2n__-refsenv."_js2n__-:definitions/Matrix!predicate",
                  moduleNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ArchiveOptions!predicate",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  swid =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                  targetJdkPattern =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  targetJdks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JlinkAssemblerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/JlinkAssembler!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/JlinkAssembler!predicate"
            ],
      "_js2n__-:definitions/JpackageAssembler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applicationPackage =
                    _js2n__-refsenv."_js2n__-:definitions/ApplicationPackage!predicate",
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  attachPlatform = _js2n__-prdslib.isType '"Bool",
                  executable = _js2n__-prdslib.isType '"String",
                  exported = _js2n__-prdslib.isType '"Bool",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fileSets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate"
                        ],
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  jars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  java =
                    _js2n__-refsenv."_js2n__-:definitions/Java-2!predicate",
                  jlink = _js2n__-prdslib.isType '"String",
                  launcher =
                    _js2n__-refsenv."_js2n__-:definitions/Launcher!predicate",
                  linux =
                    _js2n__-refsenv."_js2n__-:definitions/Linux!predicate",
                  mainJar =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  osx = _js2n__-refsenv."_js2n__-:definitions/Osx!predicate",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  runtimeImages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  swid =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  verbose = _js2n__-prdslib.isType '"Bool",
                  windows =
                    _js2n__-refsenv."_js2n__-:definitions/Windows!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JpackageAssemblerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/JpackageAssembler!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/JpackageAssembler!predicate"
            ],
      "_js2n__-:definitions/JvmOptions!contract" =
        {
            linux | Array (String) | optional,
            osx | Array (String) | optional,
            universal | Array (String) | optional,
            unix | Array (String) | optional,
            windows | Array (String) | optional,
          },
      "_js2n__-:definitions/JvmOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  linux =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  osx =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  universal =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  unix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  windows =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Label!contract" =
        {
            color | String | optional,
            description | String | optional,
            name | String | optional,
          },
      "_js2n__-:definitions/Labeler!contract" =
        {
            body | String | optional,
            contributor | String | optional,
            label | String | optional,
            order | std.number.Integer | optional,
            title | String | optional,
          },
      "_js2n__-:definitions/Languages!contract" =
        {
            java
              | _js2n__-refsenv."_js2n__-:definitions/Java-2!contract"
              | optional,
          },
      "_js2n__-:definitions/Launcher!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  javaOptions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  launchers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LinkedinAnnouncer!contract" =
        {
            accessToken | String | optional,
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            message | String | optional,
            messageTemplate | String | optional,
            owner | String | optional,
            readTimeout | std.number.Integer | optional,
            subject | String | optional,
          },
      "_js2n__-:definitions/Links!contract" =
        {
            bugTracker | String | optional,
            contact | String | optional,
            contribute | String | optional,
            documentation | String | optional,
            donation | String | optional,
            faq | String | optional,
            help | String | optional,
            homepage | String | optional,
            license | String | optional,
            translate | String | optional,
            vcsBrowser | String | optional,
          },
      "_js2n__-:definitions/Linux!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appCategory = _js2n__-prdslib.isType '"String",
                  appName = _js2n__-prdslib.isType '"String",
                  appRelease = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-prdslib.isType '"String",
                  installDir = _js2n__-prdslib.isType '"String",
                  jdk =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  license = _js2n__-prdslib.isType '"String",
                  maintainer = _js2n__-prdslib.isType '"String",
                  menuGroup = _js2n__-prdslib.isType '"String",
                  packageDeps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  packageName = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  resourceDir = _js2n__-prdslib.isType '"String",
                  shortcut = _js2n__-prdslib.isType '"Bool",
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  validTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LinuxArm!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LinuxX86!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MacosArm!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MacosX86!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MacportsPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            categories | Array (String) | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            maintainers | Array (String) | optional,
            packageName | String | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/MacportsRepository!contract"
              | optional,
            revision | std.number.Integer | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/MacportsPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  categories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  maintainers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  packageName = _js2n__-prdslib.isType '"String",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/MacportsRepository!predicate",
                  revision = _js2n__-prdslib.isType 'Integer,
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MacportsRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/MacportsRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Map(String,DebAssembler)!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/DebAssembler!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/DebAssembler!predicate"
            ],
      "_js2n__-:definitions/Map(String,List(String))!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ])
            ],
      "_js2n__-:definitions/MastodonAnnouncer!contract" =
        {
            accessToken | String | optional,
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            host | String | optional,
            readTimeout | std.number.Integer | optional,
            status | String | optional,
            statusTemplate | String | optional,
            statuses | Array (String) | optional,
          },
      "_js2n__-:definitions/Matrix!contract" =
        {
            rows
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ]
                    ])
              )
              | optional,
            vars
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/Map(String,List(String))!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ])
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Matrix!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  rows =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.isType 'Null
                                      ],
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.isType '"String")
                                  ]
                              ])
                        ],
                  vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Map(String,List(String))!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ])
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MattermostAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  structuredMessage = _js2n__-prdslib.isType '"Bool",
                  webhook = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Maven!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            artifactory
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ArtifactoryMavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/ArtifactoryMavenDeployer!predicate"
                      ]
                  ])
              | optional,
            azure
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/AzureMavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/AzureMavenDeployer!predicate"
                      ]
                  ])
              | optional,
            gitea
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GiteaMavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/GiteaMavenDeployer!predicate"
                      ]
                  ])
              | optional,
            github
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GithubMavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/GithubMavenDeployer!predicate"
                      ]
                  ])
              | optional,
            gitlab
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GitlabMavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/GitlabMavenDeployer!predicate"
                      ]
                  ])
              | optional,
            mavenCentral
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/MavenCentralMavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/MavenCentralMavenDeployer!predicate"
                      ]
                  ])
              | optional,
            nexus2
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/Nexus2MavenDeployerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/Nexus2MavenDeployer!predicate"
                      ]
                  ])
              | optional,
            pomchecker
              | _js2n__-refsenv."_js2n__-:definitions/Pomchecker!contract"
              | optional,
          },
      "_js2n__-:definitions/MavenCentralMavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  deploymentId = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  maxRetries = _js2n__-prdslib.isType 'Integer,
                  namespace = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  retryDelay = _js2n__-prdslib.isType 'Integer,
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stage =
                    _js2n__-refsenv."_js2n__-:definitions/Stage-1!predicate",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                  verifyUrl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MavenCentralMavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/MavenCentralMavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/MavenCentralMavenDeployer!predicate"
            ],
      "_js2n__-:definitions/Method!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "PUT", "POST" ]
            ],
      "_js2n__-:definitions/Milestone!contract" =
        { close | Bool | optional, name | String | optional, },
      "_js2n__-:definitions/MimeType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'HTML, 'TEXT |] ],
      "_js2n__-:definitions/MimeType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "TEXT", "HTML" ]
            ],
      "_js2n__-:definitions/Mode-1!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'SILENT_WITH_PROGRESS, 'SILENT, 'INTERACTIVE |]
            ],
      "_js2n__-:definitions/Mode-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "INTERACTIVE", "SILENT", "SILENT_WITH_PROGRESS" ]
            ],
      "_js2n__-:definitions/Mode-2!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'COSIGN, 'COMMAND, 'FILE, 'MEMORY |] ],
      "_js2n__-:definitions/NativeImageAssembler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyDefaultMatrix = _js2n__-prdslib.isType '"Bool",
                  archiveFormat =
                    _js2n__-refsenv."_js2n__-:definitions/Format-1!predicate",
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  executable = _js2n__-prdslib.isType '"String",
                  exported = _js2n__-prdslib.isType '"Bool",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fileSets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FileSet!predicate"
                        ],
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  graal =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  graalJdkPattern =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  graalJdks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate"
                        ],
                  imageName = _js2n__-prdslib.isType '"String",
                  imageNameTransform = _js2n__-prdslib.isType '"String",
                  jars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Glob!predicate"
                        ],
                  java =
                    _js2n__-refsenv."_js2n__-:definitions/Java-2!predicate",
                  linuxArm =
                    _js2n__-refsenv."_js2n__-:definitions/LinuxArm!predicate",
                  linuxX86 =
                    _js2n__-refsenv."_js2n__-:definitions/LinuxX86!predicate",
                  macosArm =
                    _js2n__-refsenv."_js2n__-:definitions/MacosArm!predicate",
                  macosX86 =
                    _js2n__-refsenv."_js2n__-:definitions/MacosX86!predicate",
                  mainJar =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  matrix =
                    _js2n__-refsenv."_js2n__-:definitions/Matrix!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/ArchiveOptions!predicate",
                  platform =
                    _js2n__-refsenv."_js2n__-:definitions/Platform!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stereotype =
                    _js2n__-refsenv."_js2n__-:definitions/Stereotype!predicate",
                  swid =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                  templateDirectory = _js2n__-prdslib.isType '"String",
                  upx = _js2n__-refsenv."_js2n__-:definitions/Upx!predicate",
                  windowsX86 =
                    _js2n__-refsenv."_js2n__-:definitions/WindowsX86!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NativeImageAssemblerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/NativeImageAssembler!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/NativeImageAssembler!predicate"
            ],
      "_js2n__-:definitions/Nexus2MavenDeployer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  applyMavenCentralRules = _js2n__-prdslib.isType '"Bool",
                  artifactOverrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArtifactOverride!predicate"
                        ],
                  authorization =
                    _js2n__-refsenv."_js2n__-:definitions/Authorization!predicate",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  closeRepository = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  endStage =
                    _js2n__-refsenv."_js2n__-:definitions/Stage-2!predicate",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  javadocJar = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  releaseRepository = _js2n__-prdslib.isType '"Bool",
                  sign = _js2n__-prdslib.isType '"Bool",
                  snapshotSupported = _js2n__-prdslib.isType '"Bool",
                  snapshotUrl = _js2n__-prdslib.isType '"String",
                  sourceJar = _js2n__-prdslib.isType '"Bool",
                  stagingProfileId = _js2n__-prdslib.isType '"String",
                  stagingRepositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  stagingRepositoryId = _js2n__-prdslib.isType '"String",
                  startStage =
                    _js2n__-refsenv."_js2n__-:definitions/Stage-2!predicate",
                  transitionDelay = _js2n__-prdslib.isType 'Integer,
                  transitionMaxRetries = _js2n__-prdslib.isType 'Integer,
                  url = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  verifyPom = _js2n__-prdslib.isType '"Bool",
                  verifyUrl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Nexus2MavenDeployerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/Nexus2MavenDeployer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/Nexus2MavenDeployer!predicate"
            ],
      "_js2n__-:definitions/OpenCollectiveAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            host | String | optional,
            message | String | optional,
            messageTemplate | String | optional,
            readTimeout | std.number.Integer | optional,
            slug | String | optional,
            title | String | optional,
            token | String | optional,
          },
      "_js2n__-:definitions/Osx!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appName = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-prdslib.isType '"String",
                  installDir = _js2n__-prdslib.isType '"String",
                  jdk =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  packageIdentifier = _js2n__-prdslib.isType '"String",
                  packageName = _js2n__-prdslib.isType '"String",
                  packageSigningPrefix = _js2n__-prdslib.isType '"String",
                  platform = _js2n__-prdslib.isType '"String",
                  resourceDir = _js2n__-prdslib.isType '"String",
                  sign = _js2n__-prdslib.isType '"Bool",
                  signingKeyUsername = _js2n__-prdslib.isType '"String",
                  signingKeychain = _js2n__-prdslib.isType '"String",
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  validTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Pack!contract" =
        { enabled | Bool | optional, name | String | optional, },
      "_js2n__-:definitions/Package!contract" =
        {
            identifier | String | optional,
            name | String | optional,
            url | String | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/Package!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  identifier = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PackageDependency!contract" =
        {
            minimumVersion | String | optional,
            packageIdentifier | String | optional,
          },
      "_js2n__-:definitions/PackageDependency!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  minimumVersion = _js2n__-prdslib.isType '"String",
                  packageIdentifier = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Packagers!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            appImage
              | _js2n__-refsenv."_js2n__-:definitions/AppImagePackager!contract"
              | optional,
            asdf
              | _js2n__-refsenv."_js2n__-:definitions/AsdfPackager!contract"
              | optional,
            brew
              | _js2n__-refsenv."_js2n__-:definitions/BrewPackager!contract"
              | optional,
            chocolatey
              | _js2n__-refsenv."_js2n__-:definitions/ChocolateyPackager!contract"
              | optional,
            docker
              | _js2n__-refsenv."_js2n__-:definitions/DockerPackager!contract"
              | optional,
            flatpak
              | _js2n__-refsenv."_js2n__-:definitions/FlatpakPackager!contract"
              | optional,
            gofish
              | _js2n__-refsenv."_js2n__-:definitions/GofishPackager!contract"
              | optional,
            jbang
              | _js2n__-refsenv."_js2n__-:definitions/JbangPackager!contract"
              | optional,
            jib
              | _js2n__-refsenv."_js2n__-:definitions/JibPackager!contract"
              | optional,
            macports
              | _js2n__-refsenv."_js2n__-:definitions/MacportsPackager!contract"
              | optional,
            scoop
              | _js2n__-refsenv."_js2n__-:definitions/ScoopPackager!contract"
              | optional,
            sdkman
              | _js2n__-refsenv."_js2n__-:definitions/SdkmanPackager!contract"
              | optional,
            snap
              | _js2n__-refsenv."_js2n__-:definitions/SnapPackager!contract"
              | optional,
            spec
              | _js2n__-refsenv."_js2n__-:definitions/SpecPackager!contract"
              | optional,
            winget
              | _js2n__-refsenv."_js2n__-:definitions/WingetPackager!contract"
              | optional,
          },
      "_js2n__-:definitions/Platform!contract" =
        {
            replacements
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Platform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  replacements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Plug!contract" =
        {
            attributes
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            name | String | optional,
            reads | Array (String) | optional,
            writes | Array (String) | optional,
          },
      "_js2n__-:definitions/Plug!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  reads =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  writes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Pomchecker!contract" =
        {
            failOnError | Bool | optional,
            failOnWarning | Bool | optional,
            strict | Bool | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/Prerelease!contract" =
        { enabled | Bool | optional, pattern | String | optional, },
      "_js2n__-:definitions/Priority!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "REQUIRED", "IMPORTANT", "STANDARD", "OPTIONAL" ]
            ],
      "_js2n__-:definitions/Project!contract" =
        {
            authors | Array (String) | optional,
            copyright | String | optional,
            description | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            icons
              | Array _js2n__-refsenv."_js2n__-:definitions/Icon!contract"
              | optional,
            inceptionYear | String | optional,
            languages
              | _js2n__-refsenv."_js2n__-:definitions/Languages!contract"
              | optional,
            license | String | optional,
            links
              | _js2n__-refsenv."_js2n__-:definitions/Links!contract"
              | optional,
            longDescription | String | optional,
            maintainers | Array (String) | optional,
            name | String | optional,
            screenshots
              | Array _js2n__-refsenv."_js2n__-:definitions/Screenshot!contract"
              | optional,
            snapshot
              | _js2n__-refsenv."_js2n__-:definitions/Snapshot!contract"
              | optional,
            stereotype
              | _js2n__-refsenv."_js2n__-:definitions/Stereotype!contract"
              | optional,
            tags | Array (String) | optional,
            vendor | String | optional,
            version | String | optional,
            versionPattern
              | _js2n__-refsenv."_js2n__-:definitions/VersionPattern!contract"
              | optional,
          },
      "_js2n__-:definitions/Properties!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.isType '"String")
              ]),
      "_js2n__-:definitions/Properties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/Provider!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Publisher!contract" =
        {
            name | String | optional,
            supportUrl | String | optional,
            url | String | optional,
          },
      "_js2n__-:definitions/Publisher!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  supportUrl = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Registry-1!contract" =
        {
            externalLogin | Bool | optional,
            password | String | optional,
            repositoryName | String | optional,
            server | String | optional,
            serverName | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/Registry-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  externalLogin = _js2n__-prdslib.isType '"Bool",
                  password = _js2n__-prdslib.isType '"String",
                  repositoryName = _js2n__-prdslib.isType '"String",
                  server = _js2n__-prdslib.isType '"String",
                  serverName = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Registry-2!contract" =
        {
            fromPassword | String | optional,
            fromUsername | String | optional,
            name | String | optional,
            password | String | optional,
            server | String | optional,
            toPassword | String | optional,
            toUsername | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/Registry-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromPassword = _js2n__-prdslib.isType '"String",
                  fromUsername = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  server = _js2n__-prdslib.isType '"String",
                  toPassword = _js2n__-prdslib.isType '"String",
                  toUsername = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Release!contract" =
        {
            codeberg
              | _js2n__-refsenv."_js2n__-:definitions/CodebergReleaser!contract"
              | optional,
            generic
              | _js2n__-refsenv."_js2n__-:definitions/GenericGitReleaser!contract"
              | optional,
            gitea
              | _js2n__-refsenv."_js2n__-:definitions/GiteaReleaser!contract"
              | optional,
            github
              | _js2n__-refsenv."_js2n__-:definitions/GithubReleaser!contract"
              | optional,
            gitlab
              | _js2n__-refsenv."_js2n__-:definitions/GitlabReleaser!contract"
              | optional,
          },
      "_js2n__-:definitions/ReleaseNotes!contract" =
        { configurationFile | String | optional, enabled | Bool | optional, },
      "_js2n__-:definitions/Replacer!contract" =
        { replace | String | optional, search | String | optional, },
      "_js2n__-:definitions/Repository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/Runtime!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'ELEMENTARY, 'KDE, 'GNOME, 'FREEDESKTOP |]
            ],
      "_js2n__-:definitions/Runtime!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "FREEDESKTOP", "GNOME", "KDE", "ELEMENTARY" ]
            ],
      "_js2n__-:definitions/S3Uploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessKeyId = _js2n__-prdslib.isType '"String",
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  bucket = _js2n__-prdslib.isType '"String",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  region = _js2n__-prdslib.isType '"String",
                  secretKey = _js2n__-prdslib.isType '"String",
                  sessionToken = _js2n__-prdslib.isType '"String",
                  signatures = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/S3UploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/S3Uploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/S3Uploader!predicate"
            ],
      "_js2n__-:definitions/Sbom!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            cyclonedx
              | _js2n__-refsenv."_js2n__-:definitions/CyclonedxSbomCataloger!contract"
              | optional,
            syft
              | _js2n__-refsenv."_js2n__-:definitions/SyftSbomCataloger!contract"
              | optional,
          },
      "_js2n__-:definitions/ScoopPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            autoupdateUrl | String | optional,
            checkverUrl | String | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            packageName | String | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/ScoopRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/ScoopPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  autoupdateUrl = _js2n__-prdslib.isType '"String",
                  checkverUrl = _js2n__-prdslib.isType '"String",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  packageName = _js2n__-prdslib.isType '"String",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/ScoopRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScoopRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/ScoopRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Scope!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'MACHINE, 'USER |] ],
      "_js2n__-:definitions/Scope!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "USER", "MACHINE" ]
            ],
      "_js2n__-:definitions/ScpDownloader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  assets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Asset!predicate"
                        ],
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fingerprint = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  knownHostsFile = _js2n__-prdslib.isType '"String",
                  passphrase = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  privateKey = _js2n__-prdslib.isType '"String",
                  publicKey = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScpDownloaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/ScpDownloader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/ScpDownloader!predicate"
            ],
      "_js2n__-:definitions/ScpUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  fingerprint = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  knownHostsFile = _js2n__-prdslib.isType '"String",
                  passphrase = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  privateKey = _js2n__-prdslib.isType '"String",
                  publicKey = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  signatures = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScpUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/ScpUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/ScpUploader!predicate"
            ],
      "_js2n__-:definitions/Screenshot!contract" =
        {
            caption | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            height | std.number.Integer | optional,
            primary | Bool | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/Type-1!contract"
              | optional,
            url | String | optional,
            width | std.number.Integer | optional,
          },
      "_js2n__-:definitions/Screenshot!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  caption = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  height = _js2n__-prdslib.isType 'Integer,
                  primary = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/Type-1!predicate",
                  url = _js2n__-prdslib.isType '"String",
                  width = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScriptHook!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            applyDefaultMatrix | Bool | optional,
            condition | String | optional,
            continueOnError | Bool | optional,
            environment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            filter
              | _js2n__-refsenv."_js2n__-:definitions/Filter!contract"
              | optional,
            matrix
              | _js2n__-refsenv."_js2n__-:definitions/Matrix!contract"
              | optional,
            platforms | Array (String) | optional,
            run | String | optional,
            shell
              | _js2n__-refsenv."_js2n__-:definitions/Shell!contract"
              | optional,
            verbose | Bool | optional,
          },
      "_js2n__-:definitions/ScriptHooks!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            applyDefaultMatrix | Bool | optional,
            before
              | Array _js2n__-refsenv."_js2n__-:definitions/ScriptHook!contract"
              | optional,
            condition | String | optional,
            environment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            failure
              | Array _js2n__-refsenv."_js2n__-:definitions/ScriptHook!contract"
              | optional,
            matrix
              | _js2n__-refsenv."_js2n__-:definitions/Matrix!contract"
              | optional,
            success
              | Array _js2n__-refsenv."_js2n__-:definitions/ScriptHook!contract"
              | optional,
          },
      "_js2n__-:definitions/SdkmanAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            candidate | String | optional,
            command
              | _js2n__-refsenv."_js2n__-:definitions/Command-1!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            consumerKey | String | optional,
            consumerToken | String | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            readTimeout | std.number.Integer | optional,
            releaseNotesUrl | String | optional,
          },
      "_js2n__-:definitions/SdkmanPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            candidate | String | optional,
            command
              | _js2n__-refsenv."_js2n__-:definitions/Command-1!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            consumerKey | String | optional,
            consumerToken | String | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            readTimeout | std.number.Integer | optional,
            releaseNotesUrl | String | optional,
          },
      "_js2n__-:definitions/SdkmanPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  candidate = _js2n__-prdslib.isType '"String",
                  command =
                    _js2n__-refsenv."_js2n__-:definitions/Command-1!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  consumerKey = _js2n__-prdslib.isType '"String",
                  consumerToken = _js2n__-prdslib.isType '"String",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  releaseNotesUrl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Section!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ADMIN",
                  "CLI_MONO",
                  "COMM",
                  "DATABASE",
                  "DEBUG",
                  "DEVEL",
                  "DOC",
                  "EDITORS",
                  "EDUCATION",
                  "ELECTRONICS",
                  "EMBEDDED",
                  "FONTS",
                  "GAMES",
                  "GNOME",
                  "GNU_R",
                  "GNUSTEP",
                  "GRAPHICS",
                  "HAMRADIO",
                  "HASKELL",
                  "HTTPD",
                  "INTERPRETERS",
                  "INTROSPECTION",
                  "JAVA",
                  "JAVASCRIPT",
                  "KDE",
                  "KERNEL",
                  "LIBDEVEL",
                  "LIBS",
                  "LISP",
                  "LOCALIZATION",
                  "MAIL",
                  "MATH",
                  "METAPACKAGES",
                  "MISC",
                  "NET",
                  "NEWS",
                  "OCAML",
                  "OLDLIBS",
                  "OTHEROSFS",
                  "PERL",
                  "PHP",
                  "PYTHON",
                  "RUBY",
                  "RUST",
                  "SCIENCE",
                  "SHELLS",
                  "SOUND",
                  "TASKS",
                  "TEX",
                  "TEXT",
                  "UTILS",
                  "VCS",
                  "VIDEO",
                  "WEB",
                  "X11",
                  "XFCE",
                  "ZOPE"
                ]
            ],
      "_js2n__-:definitions/SftpDownloader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  assets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Asset!predicate"
                        ],
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  fingerprint = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  knownHostsFile = _js2n__-prdslib.isType '"String",
                  passphrase = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  privateKey = _js2n__-prdslib.isType '"String",
                  publicKey = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SftpDownloaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/SftpDownloader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/SftpDownloader!predicate"
            ],
      "_js2n__-:definitions/SftpUploader!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  artifacts = _js2n__-prdslib.isType '"Bool",
                  catalogs = _js2n__-prdslib.isType '"Bool",
                  checksums = _js2n__-prdslib.isType '"Bool",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  files = _js2n__-prdslib.isType '"Bool",
                  fingerprint = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  knownHostsFile = _js2n__-prdslib.isType '"String",
                  passphrase = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  privateKey = _js2n__-prdslib.isType '"String",
                  publicKey = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  signatures = _js2n__-prdslib.isType '"Bool",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SftpUploaderMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/SftpUploader!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/SftpUploader!predicate"
            ],
      "_js2n__-:definitions/Shell!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'POWERSHELL, 'PWSH, 'CMD, 'SH, 'BASH |]
            ],
      "_js2n__-:definitions/Signing!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            armored | Bool | optional,
            artifacts | Bool | optional,
            catalogs | Bool | optional,
            checksums | Bool | optional,
            command
              | _js2n__-refsenv."_js2n__-:definitions/Command-2!contract"
              | optional,
            cosign
              | _js2n__-refsenv."_js2n__-:definitions/Cosign!contract"
              | optional,
            files | Bool | optional,
            mode
              | _js2n__-refsenv."_js2n__-:definitions/Mode-2!contract"
              | optional,
            passphrase | String | optional,
            publicKey | String | optional,
            secretKey | String | optional,
            verify | Bool | optional,
          },
      "_js2n__-:definitions/SlackAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            channel | String | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            message | String | optional,
            messageTemplate | String | optional,
            readTimeout | std.number.Integer | optional,
            token | String | optional,
            webhook | String | optional,
          },
      "_js2n__-:definitions/Slot!contract" =
        {
            attributes
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            name | String | optional,
            reads | Array (String) | optional,
            writes | Array (String) | optional,
          },
      "_js2n__-:definitions/Slot!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  reads =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  writes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SlsaCataloger!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            artifacts | Bool | optional,
            attestationName | String | optional,
            deployables | Bool | optional,
            excludes | Array (String) | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            files | Bool | optional,
            includes | Array (String) | optional,
          },
      "_js2n__-:definitions/SmtpAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            auth | Bool | optional,
            bcc | String | optional,
            cc | String | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            from | String | optional,
            host | String | optional,
            message | String | optional,
            messageTemplate | String | optional,
            mimeType
              | _js2n__-refsenv."_js2n__-:definitions/MimeType!contract"
              | optional,
            password | String | optional,
            port | std.number.Integer | optional,
            properties
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ])
              | optional,
            readTimeout | std.number.Integer | optional,
            subject | String | optional,
            to | String | optional,
            transport
              | _js2n__-refsenv."_js2n__-:definitions/Transport!contract"
              | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/SmtpAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  auth = _js2n__-prdslib.isType '"Bool",
                  bcc = _js2n__-prdslib.isType '"String",
                  cc = _js2n__-prdslib.isType '"String",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  from = _js2n__-prdslib.isType '"String",
                  host = _js2n__-prdslib.isType '"String",
                  message = _js2n__-prdslib.isType '"String",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  mimeType =
                    _js2n__-refsenv."_js2n__-:definitions/MimeType!predicate",
                  password = _js2n__-prdslib.isType '"String",
                  port = _js2n__-prdslib.isType 'Integer,
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/StringProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  subject = _js2n__-prdslib.isType '"String",
                  to = _js2n__-prdslib.isType '"String",
                  transport =
                    _js2n__-refsenv."_js2n__-:definitions/Transport!predicate",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SnapPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            architectures
              | Array
                _js2n__-refsenv."_js2n__-:definitions/Architecture!contract"
              | optional,
            base | String | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            confinement | String | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            exportedLogin | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            grade | String | optional,
            localPlugs | Array (String) | optional,
            localSlots | Array (String) | optional,
            packageName | String | optional,
            plugs
              | Array _js2n__-refsenv."_js2n__-:definitions/Plug!contract"
              | optional,
            remoteBuild | Bool | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/SnapRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            slots
              | Array _js2n__-refsenv."_js2n__-:definitions/Slot!contract"
              | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/SnapPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  architectures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Architecture!predicate"
                        ],
                  base = _js2n__-prdslib.isType '"String",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  confinement = _js2n__-prdslib.isType '"String",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  exportedLogin = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  grade = _js2n__-prdslib.isType '"String",
                  localPlugs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  localSlots =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  packageName = _js2n__-prdslib.isType '"String",
                  plugs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Plug!predicate"
                        ],
                  remoteBuild = _js2n__-prdslib.isType '"Bool",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/SnapRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  slots =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Slot!predicate"
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SnapRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/SnapRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Snapshot!contract" =
        {
            fullChangelog | Bool | optional,
            label | String | optional,
            pattern | String | optional,
          },
      "_js2n__-:definitions/Sort!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'DESC, 'ASC |] ],
      "_js2n__-:definitions/SpecPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            packageName | String | optional,
            release | String | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/SpecRepository!contract"
              | optional,
            requires | Array (String) | optional,
            skipTemplates | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/SpecPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  packageName = _js2n__-prdslib.isType '"String",
                  release = _js2n__-prdslib.isType '"String",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/SpecRepository!predicate",
                  requires =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpecRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/SpecRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Stage-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UPLOAD", "PUBLISH", "FULL" ]
            ],
      "_js2n__-:definitions/Stage-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "UPLOAD", "CLOSE", "RELEASE" ]
            ],
      "_js2n__-:definitions/Stereotype!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'MOBILE, 'WEB, 'DESKTOP, 'CLI, 'NONE |]
            ],
      "_js2n__-:definitions/Stereotype!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "NONE", "CLI", "DESKTOP", "WEB", "MOBILE" ]
            ],
      "_js2n__-:definitions/StringProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/SwidTag!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  corpus = _js2n__-prdslib.isType '"Bool",
                  entities =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Entity!predicate"
                        ],
                  lang = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  patch = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  tagId = _js2n__-prdslib.isType '"String",
                  tagRef = _js2n__-prdslib.isType '"String",
                  tagVersion = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SwidTagMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate",
                } true _js2n__-refsenv."_js2n__-:definitions/SwidTag!predicate"
            ],
      "_js2n__-:definitions/SyftSbomCataloger!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            distributions | Bool | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            files | Bool | optional,
            formats
              | Array _js2n__-refsenv."_js2n__-:definitions/Format-3!contract"
              | optional,
            pack
              | _js2n__-refsenv."_js2n__-:definitions/Pack!contract"
              | optional,
            version | String | optional,
          },
      "_js2n__-:definitions/TarMode!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "GNU", "POSIX", "ERROR", "TRUNCATE" ]
            ],
      "_js2n__-:definitions/TeamsAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  webhook = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TelegramAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            chatId | String | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            message | String | optional,
            messageTemplate | String | optional,
            readTimeout | std.number.Integer | optional,
            token | String | optional,
          },
      "_js2n__-:definitions/Transport!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'SMTPS, 'SMTP |] ],
      "_js2n__-:definitions/Transport!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "SMTP", "SMTPS" ]
            ],
      "_js2n__-:definitions/TwitterAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessToken = _js2n__-prdslib.isType '"String",
                  accessTokenSecret = _js2n__-prdslib.isType '"String",
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  consumerKey = _js2n__-prdslib.isType '"String",
                  consumerSecret = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  status = _js2n__-prdslib.isType '"String",
                  statusTemplate = _js2n__-prdslib.isType '"String",
                  statuses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Type-1!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'THUMBNAIL, 'SOURCE |] ],
      "_js2n__-:definitions/Type-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "SOURCE", "THUMBNAIL" ]
            ],
      "_js2n__-:definitions/Type-2!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'PWA,
                'BURN,
                'WIX,
                'NULLSOFT,
                'INNO,
                'ZIP,
                'EXE,
                'APPX,
                'MSI,
                'MSIX
              |]
            ],
      "_js2n__-:definitions/Type-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "MSIX",
                  "MSI",
                  "APPX",
                  "EXE",
                  "ZIP",
                  "INNO",
                  "NULLSOFT",
                  "WIX",
                  "BURN",
                  "PWA"
                ]
            ],
      "_js2n__-:definitions/Type-3!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'CUSTOM,
                'JAVA_MODULE,
                'JAVA_RUNTIME,
                'CHRONVER,
                'CALVER,
                'SEMVER
              |]
            ],
      "_js2n__-:definitions/Unpack!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  skipRootEntry = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Update!contract" =
        {
            enabled | Bool | optional,
            sections
              | Array
                _js2n__-refsenv."_js2n__-:definitions/UpdateSection!contract"
              | optional,
          },
      "_js2n__-:definitions/UpdateSection!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'ASSETS, 'BODY, 'TITLE |] ],
      "_js2n__-:definitions/UpgradeBehavior!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'UNINSTALL_PREVIOUS, 'INSTALL |] ],
      "_js2n__-:definitions/UpgradeBehavior!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "INSTALL", "UNINSTALL_PREVIOUS" ]
            ],
      "_js2n__-:definitions/Upload!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            artifactory
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ArtifactoryUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/ArtifactoryUploader!predicate"
                      ]
                  ])
              | optional,
            ftp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/FtpUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/FtpUploader!predicate"
                      ]
                  ])
              | optional,
            gitea
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GiteaUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/GiteaUploader!predicate"
                      ]
                  ])
              | optional,
            gitlab
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/GitlabUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/GitlabUploader!predicate"
                      ]
                  ])
              | optional,
            http
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/HttpUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/HttpUploader!predicate"
                      ]
                  ])
              | optional,
            s3
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/S3UploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/S3Uploader!predicate"
                      ]
                  ])
              | optional,
            scp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ScpUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/ScpUploader!predicate"
                      ]
                  ])
              | optional,
            sftp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/SftpUploaderMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/SftpUploader!predicate"
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Upx!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VersionPattern!contract" =
        {
            format | String | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/Type-3!contract"
              | optional,
          },
      "_js2n__-:definitions/WebhookAnnouncer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  connectTimeout = _js2n__-prdslib.isType 'Integer,
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  message = _js2n__-prdslib.isType '"String",
                  messageProperty = _js2n__-prdslib.isType '"String",
                  messageTemplate = _js2n__-prdslib.isType '"String",
                  readTimeout = _js2n__-prdslib.isType 'Integer,
                  structuredMessage = _js2n__-prdslib.isType '"Bool",
                  webhook = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WebhookAnnouncerMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]?$" =
                    _js2n__-refsenv."_js2n__-:definitions/WebhookAnnouncer!predicate",
                } true
                _js2n__-refsenv."_js2n__-:definitions/WebhookAnnouncer!predicate"
            ],
      "_js2n__-:definitions/WebhooksAnnouncer!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            readTimeout | std.number.Integer | optional,
            webhooks
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/WebhookAnnouncerMap!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/WebhookAnnouncer!predicate"
                      ]
                  ])
              | optional,
          },
      "_js2n__-:definitions/Windows!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appName = _js2n__-prdslib.isType '"String",
                  console = _js2n__-prdslib.isType '"Bool",
                  dirChooser = _js2n__-prdslib.isType '"Bool",
                  icon = _js2n__-prdslib.isType '"String",
                  installDir = _js2n__-prdslib.isType '"String",
                  jdk =
                    _js2n__-refsenv."_js2n__-:definitions/Artifact!predicate",
                  menu = _js2n__-prdslib.isType '"Bool",
                  menuGroup = _js2n__-prdslib.isType '"String",
                  perUserInstall = _js2n__-prdslib.isType '"Bool",
                  platform = _js2n__-prdslib.isType '"String",
                  resourceDir = _js2n__-prdslib.isType '"String",
                  shortcut = _js2n__-prdslib.isType '"Bool",
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  upgradeUuid = _js2n__-prdslib.isType '"String",
                  validTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WindowsX86!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WingetPackager!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            author | String | optional,
            commitAuthor
              | _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!contract"
              | optional,
            continueOnError | Bool | optional,
            defaultLocale | String | optional,
            downloadUrl | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            installer
              | _js2n__-refsenv."_js2n__-:definitions/Installer!contract"
              | optional,
            minimumOsVersion | String | optional,
            moniker | String | optional,
            package
              | _js2n__-refsenv."_js2n__-:definitions/Package!contract"
              | optional,
            productCode | String | optional,
            publisher
              | _js2n__-refsenv."_js2n__-:definitions/Publisher!contract"
              | optional,
            repository
              | _js2n__-refsenv."_js2n__-:definitions/WingetRepository!contract"
              | optional,
            skipTemplates | Array (String) | optional,
            tags | Array (String) | optional,
            templateDirectory | String | optional,
          },
      "_js2n__-:definitions/WingetPackager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  author = _js2n__-prdslib.isType '"String",
                  commitAuthor =
                    _js2n__-refsenv."_js2n__-:definitions/CommitAuthor!predicate",
                  continueOnError = _js2n__-prdslib.isType '"Bool",
                  defaultLocale = _js2n__-prdslib.isType '"String",
                  downloadUrl = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  installer =
                    _js2n__-refsenv."_js2n__-:definitions/Installer!predicate",
                  minimumOsVersion = _js2n__-prdslib.isType '"String",
                  moniker = _js2n__-prdslib.isType '"String",
                  package =
                    _js2n__-refsenv."_js2n__-:definitions/Package!predicate",
                  productCode = _js2n__-prdslib.isType '"String",
                  publisher =
                    _js2n__-refsenv."_js2n__-:definitions/Publisher!predicate",
                  repository =
                    _js2n__-refsenv."_js2n__-:definitions/WingetRepository!predicate",
                  skipTemplates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  templateDirectory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WingetRepository!contract" =
        {
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            branch | String | optional,
            branchPush | String | optional,
            commitMessage | String | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            name | String | optional,
            owner | String | optional,
            tagName | String | optional,
            token | String | optional,
            username | String | optional,
          },
      "_js2n__-:definitions/WingetRepository!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/Active!predicate",
                  branch = _js2n__-prdslib.isType '"String",
                  branchPush = _js2n__-prdslib.isType '"String",
                  commitMessage = _js2n__-prdslib.isType '"String",
                  extraProperties =
                    _js2n__-refsenv."_js2n__-:definitions/Properties!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  owner = _js2n__-prdslib.isType '"String",
                  tagName = _js2n__-prdslib.isType '"String",
                  token = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ZulipAnnouncer!contract" =
        {
            account | String | optional,
            active
              | _js2n__-refsenv."_js2n__-:definitions/Active!contract"
              | optional,
            apiHost | String | optional,
            apiKey | String | optional,
            channel | String | optional,
            connectTimeout | std.number.Integer | optional,
            extraProperties
              | _js2n__-refsenv."_js2n__-:definitions/Properties!contract"
              | optional,
            message | String | optional,
            messageTemplate | String | optional,
            readTimeout | std.number.Integer | optional,
            subject | String | optional,
          },
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/JReleaserModel!contract"