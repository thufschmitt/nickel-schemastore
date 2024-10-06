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
      "_js2n__-:definitions/collection-permalink!predicate"
        | doc m%"
          The collection permalink format
          https://jekyllrb.com/docs/permalinks/#collections
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/global-permalink!contract"
        | doc m%"
          The global permalink format
          https://jekyllrb.com/docs/permalinks/#global
        "%
        = String,
      "_js2n__-:definitions/global-permalink!predicate"
        | doc m%"
          The global permalink format
          https://jekyllrb.com/docs/permalinks/#global
        "%
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/nullable-boolean!contract"
        | doc "Copy of definition from https://json.schemastore.org/base.json#/definitions/nullable-boolean"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ]),
      "_js2n__-:definitions/nullable-timezone!contract"
        | doc "Copy of definition from https://json.schemastore.org/base.json#/definitions/nullable-timezone"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [ _js2n__-prdslib.always, _js2n__-prdslib.isType 'Null ]),
    }
    in
  {
      baseurl
        | String
        | doc m%"
          A base URL for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      collections
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
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
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "." =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  order =
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
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                  output = _js2n__-prdslib.isType '"Bool",
                                  permalink =
                                    _js2n__-refsenv."_js2n__-:definitions/collection-permalink!predicate",
                                  sort_by = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ],
                    } true _js2n__-prdslib.always
                ]
            ])
        | doc m%"
          The collections to group several site pages
          https://jekyllrb.com/docs/collections/
        "%
        | optional,
      collections_dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A directory where to store collections for the current site
          https://jekyllrb.com/docs/collections/#setup
        "%
        | optional,
      data_dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A directory to store data files for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      defaults
        | Array
          {
            scope
              | {
                path
                  | String
                  | doc m%"
                    The file path for this scope
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%,
                type
                  | String
                  | doc m%"
                    The page type for this scope
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%
                  | optional,
              }
              | doc m%"
                The scope
                https://jekyllrb.com/docs/configuration/front-matter-defaults/
              "%
              | optional,
            values
              | {
                categories
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
                    The categories for pages
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%
                  | optional,
                date
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern
                          "^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}( [-+]\\d{4})?$"
                      ])
                  | doc m%"
                    The date for pages
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%
                  | optional,
                layout
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ])
                  | doc m%"
                    The layout to use
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%
                  | optional,
                output
                  | Bool
                  | doc m%"
                    Enable/disable output
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%
                  | optional,
                permalink
                  | _js2n__-refsenv."_js2n__-:definitions/global-permalink!contract"
                  | optional,
                tags
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
                    The tags for pages
                    https://jekyllrb.com/docs/configuration/front-matter-defaults/
                  "%
                  | optional,
                ..
              }
              | doc m%"
                The front matter default values
                https://jekyllrb.com/docs/configuration/front-matter-defaults/
              "%
              | optional,
            ..
          }
        | doc m%"
          The front matter defaults
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      destination
        | String
        | doc m%"
          A directory to write files to for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      detach
        | Bool
        | doc m%"
          Whether to detach a server from a terminal for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      disable_disk_cache
        | Bool
        | doc m%"
          Whether to disable caching to disk for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      encoding
        | std.enum.TagOrString
        | [|
          'SJIS-SoftBank,
          'UTF8-SoftBank,
          'stateless-ISO-2022-JP-KDDI,
          'ISO-2022-JP-KDDI,
          'SJIS-KDDI,
          'UTF8-KDDI,
          'SJIS-DoCoMo,
          'UTF8-DoCoMo,
          'UTF-7,
          'MacJapanese,
          'Windows-874,
          'TIS-620,
          'Windows-1255,
          'Windows-1256,
          'CP50221,
          'CP50220,
          'ISO-2022-JP-2,
          'ISO-2022-JP,
          'GB12345,
          'GB2312,
          'EUC-JIS-2004,
          'CP51932,
          'eucJP-ms,
          'stateless-ISO-2022-JP,
          'IBM037,
          'CP951,
          'CP950,
          'macUkraine,
          'macTurkish,
          'macThai,
          'macRomania,
          'macRoman,
          'macIceland,
          'macGreek,
          'macCyrillic,
          'macCroatian,
          'macCentEuro,
          'GB1988,
          'Windows-1258,
          'IBM869,
          'IBM866,
          'IBM865,
          'IBM864,
          'IBM863,
          'IBM862,
          'IBM861,
          'IBM860,
          'IBM857,
          'CP855,
          'IBM855,
          'CP852,
          'IBM852,
          'CP850,
          'IBM775,
          'IBM737,
          'IBM437,
          'Windows-1257,
          'Windows-1254,
          'Windows-1253,
          'Windows-1252,
          'Windows-1251,
          'Windows-1250,
          'Shift_JIS,
          'KOI8-U,
          'KOI8-R,
          'ISO-8859-16,
          'ISO-8859-15,
          'ISO-8859-14,
          'ISO-8859-13,
          'ISO-8859-11,
          'ISO-8859-10,
          'ISO-8859-9,
          'ISO-8859-8,
          'ISO-8859-7,
          'ISO-8859-6,
          'ISO-8859-5,
          'ISO-8859-4,
          'ISO-8859-3,
          'ISO-8859-2,
          'ISO-8859-1,
          'GBK,
          'GB18030,
          'EUC-TW,
          'EUC-KR,
          'Emacs-Mule,
          'CP949,
          'CESU-8,
          'Big5-UAO,
          'Big5-HKSCS,
          'Big5,
          'Windows-31J,
          'EUC-JP,
          'UTF8-MAC,
          'UTF-32,
          'UTF-16,
          'UTF-32LE,
          'UTF-32BE,
          'UTF-16LE,
          'UTF-16BE,
          'US-ASCII,
          'utf-8,
          'UTF-8,
          'ASCII-8BIT
        |]
        | doc m%"
          An encoding for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      excerpt_separator
        | String
        | doc m%"
          A post excerpt separator for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      exclude
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
          Excluded directories and files from the conversion for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      force_polling
        | Bool
        | doc m%"
          Whether to use polling for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      future
        | Bool
        | doc m%"
          Whether to publish posts or collection documents with a future date for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      highlighter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A syntax highlighter for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      host
        | String
        | doc m%"
          A hostname to listen on for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      ignore_theme_config
        | Bool
        | doc m%"
          Whether to ignore a theme configuration for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      include
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
          Included directories and files in the conversion for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      includes_dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          An includes directory for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      incremental
        | Bool
        | doc m%"
          Whether to enable the experimental incremental build feature for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      keep_files
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
          Keeped files when clobbering for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      kramdown
        | {
          auto_id_prefix
            | String
            | doc m%"
              The prefix used for automatically generated header IDs
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          auto_id_stripping
            | Bool
            | doc m%"
              Strip/leave all formatting from header text for automatic ID generation
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          auto_ids
            | Bool
            | doc m%"
              Enable/disable automatic header ID generation
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          entity_output
            | std.enum.TagOrString
            | [| 'symbolic, 'numeric, 'as_input, 'as_char |]
            | doc m%"
              The entity output
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          footnote_backlink
            | String
            | doc m%"
              The text that should be used for the footnote backlinks
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          footnote_backlink_inline
            | String
            | doc m%"
              Enable/disable inlining of the footnote backlink
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          footnote_nr
            | std.number.Integer
            | doc m%"
              The number of the first footnote
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          footnote_prefix
            | String
            | doc m%"
              The prefix for footnote IDs
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          forbidden_inline_options
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
              The options that may not be set using the {::options} extension
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          gfm_emoji_opts
            | {
              asset_path
                | String
                | doc "Remote location of emoji assets"
                | optional,
            }
            | doc m%"
              Configuration for rendering emoji amidst GFM
              https://github.com/kramdown/parser-gfm#options
            "%
            | optional,
          gfm_emojis
            | Bool
            | doc m%"
              Enable/disable rendering emoji amidst GFM
              https://github.com/kramdown/parser-gfm#options
            "%
            | optional,
          gfm_quirks
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [ "paragraph_end", "no_auto_typographic" ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              Enabled GFM quirks
              https://github.com/kramdown/parser-gfm#options
            "%
            | optional,
          hard_wrap
            | Bool
            | doc m%"
              Enable/disable interpreting line breaks literally
              https://github.com/kramdown/parser-gfm#options
            "%
            | optional,
          header_offset
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              The output offset for headers
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          html_to_native
            | Bool
            | doc m%"
              Enable/disable HTML elements to native elements conversion
              https://kramdown.gettalong.org/parser/kramdown.html
            "%
            | optional,
          input
            | String
            | doc m%"
              The selected kramdown processor
              https://jekyllrb.com/docs/configuration/markdown/
            "%
            | optional,
          latex_headers
            | String
            | doc m%"
              The LaTeX commands for different header levels
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          line_width
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              The line width when outputting the document
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          link_defs
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "." =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.items
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/global-permalink!predicate",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                                  _js2n__-prdslib.arrays.maxItems 2,
                                  _js2n__-prdslib.arrays.minItems 2
                                ],
                        } true _js2n__-prdslib.always
                    ]
                ])
            | doc "The pre-defined link definitions"
            | optional,
          math_engine
            | String
            | doc m%"
              The math engine
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          math_engine_opts
            | {  .. }
            | doc m%"
              The math engine options
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          parse_block_html
            | Bool
            | doc m%"
              Enable/disable processing kramdown syntax in block HTML tags
              https://kramdown.gettalong.org/parser/kramdown.html
            "%
            | optional,
          parse_span_html
            | Bool
            | doc m%"
              Enable/disable processing kramdown syntax in span HTML tags
              https://kramdown.gettalong.org/parser/kramdown.html
            "%
            | optional,
          remove_block_html_tags
            | Bool
            | doc m%"
              Enable/disable removing block HTML tags
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          remove_line_breaks_for_cjk
            | Bool
            | doc m%"
              Leave/remove line breaks between CJK characters
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          remove_span_html_tags
            | Bool
            | doc m%"
              Enable/disable removing span HTML tags
              https://kramdown.gettalong.org/options.html
            "%
            | optional,
          smart_quotes
            | String
            | doc m%"
              The HTML entity names or code points for smart quote output
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          syntax_highlighter
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Null
                    ],
                  _js2n__-prdslib.strings.minLength 1
                ])
            | doc m%"
              The syntax highlighter
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          syntax_highlighter_opts
            | {  .. }
            | doc m%"
              The syntax highlighter options
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          template
            | String
            | doc m%"
              The name of an ERB template file that should be used to wrap the output or the ERB template itself
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          toc_levels
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ])
            | doc m%"
              The levels that are used for the table of contents
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          transliterated_header_ids
            | Bool
            | doc m%"
              Enable/disable transliterating header text before generating the ID
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          typographic_symbols
            | {
              hellip
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              laquo
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              laquo_space
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              mdash
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              ndash
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              raquo
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              raquo_space
                | String
                | doc m%"
                  Typographical symbol
                  https://kramdown.gettalong.org/converter/html.html
                "%
                | optional,
              ..
            }
            | doc m%"
              The mapping from typographical symbol to output characters
              https://kramdown.gettalong.org/converter/html.html
            "%
            | optional,
          ..
        }
        | doc m%"
          kramdown options
          https://kramdown.gettalong.org/documentation.html
        "%
        | optional,
      layouts_dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
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
                ]
            ])
        | doc m%"
          Layout directories for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      limit_posts
        | std.number.Integer
        | doc m%"
          A number of posts to publish for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      liquid
        | {
          error_mode
            | std.enum.TagOrString
            | [| 'strict, 'warn, 'lax |]
            | doc m%"
              The response to errors
              https://jekyllrb.com/docs/configuration/liquid/
            "%
            | optional,
          strict_filters
            | Bool
            | doc m%"
              Enable/disable non-existing filters catch
              https://jekyllrb.com/docs/configuration/liquid/
            "%
            | optional,
          strict_variables
            | Bool
            | doc m%"
              Enable/disable non-assigned variables catch
              https://jekyllrb.com/docs/configuration/liquid/
            "%
            | optional,
        }
        | doc m%"
          Liquid options
          https://jekyllrb.com/docs/configuration/liquid/
        "%
        | optional,
      livereload
        | Bool
        | doc m%"
          Whether to reload pages on the browser when its content was changed for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      livereload_ignore
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
          File glob patterns for LiveReload to ignore for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      livereload_max_delay
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          A maximum delay before automatically reloading page for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      livereload_min_delay
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          A minimum delay before automatically reloading page for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      lsi
        | Bool
        | doc m%"
          Whether to produce an index for related posts for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      markdown
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A markdown processor for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      markdown_ext
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          Markdown extensions for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      open_url
        | Bool
        | doc m%"
          Whether to open a site's URL in the browser for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      paginate_path
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ])
        | doc m%"
          A destination of the pagination pages for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      permalink
        | _js2n__-refsenv."_js2n__-:definitions/global-permalink!contract"
        | optional,
      plugins
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
          Enabled plugins for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      plugins_dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
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
                ]
            ])
        | doc m%"
          Plugin directories for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      port
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 65535,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          A port to listen on for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      profile
        | Bool
        | doc m%"
          Whether to render profile generation to help identify performance bottlenecks for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      quiet
        | Bool
        | doc m%"
          Whether to hide a normal output while building for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      rdiscount
        | {
          extensions
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
                            "autolink",
                            "filter_html",
                            "filter_styles",
                            "fold_lines",
                            "footnotes",
                            "generate_toc",
                            "no_image",
                            "no_links",
                            "no_pseudo_protocols",
                            "no_strikethrough",
                            "no_superscript",
                            "no_tables",
                            "safelink",
                            "smart",
                            "strict"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              The enabled extensions
              https://rdoc.info/github/davidfstr/rdiscount/RDiscount
            "%
            | optional,
        }
        | doc m%"
          RDiscount options
          https://rdoc.info/github/davidfstr/rdiscount/RDiscount
        "%
        | optional,
      redcarpet
        | {
          extensions
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
                            "no_intra_emphasis",
                            "tables",
                            "fenced_code_blocks",
                            "autolink",
                            "disable_indented_code_blocks",
                            "strikethrough",
                            "lax_spacing",
                            "space_after_headers",
                            "superscript",
                            "underline",
                            "highlight",
                            "quote",
                            "footnotes"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              The enabled extensions
              https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
            "%
            | optional,
        }
        | doc m%"
          Redcarpet options
          https://github.com/vmg/redcarpet
        "%
        | optional,
      safe
        | Bool
        | doc m%"
          Whether to enable non-whitelisted plugins and symbolic links for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      sass
        | {
          load_paths
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
              The additional paths with Sass partials
              https://github.com/jekyll/jekyll-sass-converter#configuration-options
            "%
            | optional,
          quiet_deps
            | Bool
            | doc m%"
              If true, Sass does not print warnings that are caused by dependencies
              https://github.com/jekyll/jekyll-sass-converter#configuration-options
            "%
            | optional,
          sass_dir
            | String
            | doc m%"
              The path with Sass partials
              https://github.com/jekyll/jekyll-sass-converter#configuration-options
            "%
            | optional,
          sourcemap
            | std.enum.TagOrString
            | [| 'development, 'always, 'never |]
            | doc m%"
              Control when source maps shall be generated
              https://github.com/jekyll/jekyll-sass-converter#configuration-options
            "%
            | optional,
          style
            | std.enum.TagOrString
            | [| 'expanded, 'compressed |]
            | doc m%"
              The style of CSS-output
              https://github.com/jekyll/jekyll-sass-converter#configuration-options
            "%
            | optional,
          verbose
            | Bool
            | doc m%"
              If true, Sass prints every deprecation warning it encounters
              https://github.com/jekyll/jekyll-sass-converter#configuration-options
            "%
            | optional,
        }
        | doc m%"
          Sass options
          https://github.com/jekyll/jekyll-sass-converter#configuration-options
        "%
        | optional,
      show_dir_listing
        | Bool
        | doc m%"
          Whether to show directory listing instead of an index file for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      show_drafts
        | _js2n__-refsenv."_js2n__-:definitions/nullable-boolean!contract"
        | doc m%"
          Whether to process and render draft posts for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      skip_initial_build
        | Bool
        | doc m%"
          Whether to skip an initial site build which occurs before the server is started for the current site
          https://jekyllrb.com/docs/configuration/options/#serve-command-options
        "%
        | optional,
      source
        | String
        | doc m%"
          A directory to read files from for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      strict_front_matter
        | Bool
        | doc m%"
          Whether to fail build if there is a YAML syntax error in a page's front matter for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      timezone
        | _js2n__-refsenv."_js2n__-:definitions/nullable-timezone!contract"
        | doc m%"
          A time zone for the current site
          https://jekyllrb.com/docs/configuration/options/#global-configuration
        "%
        | optional,
      unpublished
        | Bool
        | doc m%"
          Whether to publish posts that were marked as unpublished for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      verbose
        | Bool
        | doc m%"
          Whether to write a verbose output while building for the current site
          https://jekyllrb.com/docs/configuration/options/#build-command-options
        "%
        | optional,
      webrick
        | {
          headers
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    { "." = _js2n__-prdslib.isType '"String", } true
                    _js2n__-prdslib.always
                ])
            | doc m%"
              The custom headers for this site
              https://docs.ruby-lang.org/en/2.4.0/WEBrick.html
            "%
            | optional,
        }
        | doc m%"
          WEBrick options
          https://docs.ruby-lang.org/en/2.4.0/WEBrick.html
        "%
        | optional,
      whitelist
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
          Whitelisted plugins for the current site
          https://jekyllrb.com/docs/configuration/default/
        "%
        | optional,
      ..
    }