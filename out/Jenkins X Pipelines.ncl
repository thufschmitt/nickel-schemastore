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
      "_js2n__-:definitions/AWSElasticBlockStoreVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  partition = _js2n__-prdslib.isType 'Integer,
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  volumeID = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AddonConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Agent!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  container = _js2n__-prdslib.isType '"String",
                  dir = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AzureDiskVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cachingMode = _js2n__-prdslib.isType '"String",
                  diskName = _js2n__-prdslib.isType '"String",
                  diskURI = _js2n__-prdslib.isType '"String",
                  fsType = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AzureFileVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretName = _js2n__-prdslib.isType '"String",
                  shareName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CSIVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  driver = _js2n__-prdslib.isType '"String",
                  fsType = _js2n__-prdslib.isType '"String",
                  nodePublishSecretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  volumeAttributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".*" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CephFSVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  monitors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretFile = _js2n__-prdslib.isType '"String",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ChatConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  developerChannel = _js2n__-prdslib.isType '"String",
                  kind = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                  userChannel = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CinderVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  volumeID = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConfigMapKeySelector!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConfigMapProjection!predicate" =
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
                            _js2n__-refsenv."_js2n__-:definitions/KeyToPath!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConfigMapVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/KeyToPath!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Container!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DownwardAPIProjection!predicate" =
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
                            _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeFile!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DownwardAPIVolumeFile!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/ObjectFieldSelector!predicate",
                  mode = _js2n__-prdslib.isType 'Integer,
                  path = _js2n__-prdslib.isType '"String",
                  resourceFieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceFieldSelector!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DownwardAPIVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeFile!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EmptyDirVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  medium = _js2n__-prdslib.isType '"String",
                  sizeLimit =
                    _js2n__-refsenv."_js2n__-:definitions/Quantity!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EnvVar!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  valueFrom =
                    _js2n__-refsenv."_js2n__-:definitions/EnvVarSource!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EnvVarSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMapKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConfigMapKeySelector!predicate",
                  fieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/ObjectFieldSelector!predicate",
                  resourceFieldRef =
                    _js2n__-refsenv."_js2n__-:definitions/ResourceFieldSelector!predicate",
                  secretKeyRef =
                    _js2n__-refsenv."_js2n__-:definitions/SecretKeySelector!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FCVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  lun = _js2n__-prdslib.isType 'Integer,
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  targetWWNs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  wwids =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FlexVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  driver = _js2n__-prdslib.isType '"String",
                  fsType = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".*" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FlockerVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  datasetName = _js2n__-prdslib.isType '"String",
                  datasetUUID = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GCEPersistentDiskVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  partition = _js2n__-prdslib.isType 'Integer,
                  pdName = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitRepoVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  directory = _js2n__-prdslib.isType '"String",
                  repository = _js2n__-prdslib.isType '"String",
                  revision = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GlusterfsVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endpoints = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HostPathVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ISCSIVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  chapAuthDiscovery = _js2n__-prdslib.isType '"Bool",
                  chapAuthSession = _js2n__-prdslib.isType '"Bool",
                  fsType = _js2n__-prdslib.isType '"String",
                  initiatorName = _js2n__-prdslib.isType '"String",
                  iqn = _js2n__-prdslib.isType '"String",
                  iscsiInterface = _js2n__-prdslib.isType '"String",
                  lun = _js2n__-prdslib.isType 'Integer,
                  portals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  targetPortal = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IssueTrackerConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  kind = _js2n__-prdslib.isType '"String",
                  project = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KeyToPath!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  mode = _js2n__-prdslib.isType 'Integer,
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocalObjectReference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { name = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Loop!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Step!predicate"
                        ],
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  variable = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NFSVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  server = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ObjectFieldSelector!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiVersion = _js2n__-prdslib.isType '"String",
                  fieldPath = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ParsedPipeline!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  agent =
                    _js2n__-refsenv."_js2n__-:definitions/Agent!predicate",
                  dir = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
                        ],
                  environment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
                        ],
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/RootOptions!predicate",
                  post =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Post!predicate"
                        ],
                  stages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Stage!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PersistentVolumeClaimVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  claimName = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PhotonPersistentDiskVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  pdID = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PipelineConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  agent =
                    _js2n__-refsenv."_js2n__-:definitions/Agent!predicate",
                  containerOptions =
                    _js2n__-refsenv."_js2n__-:definitions/Container!predicate",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
                        ],
                  environment = _js2n__-prdslib.isType '"String",
                  extends =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineExtends!predicate",
                  pipelines =
                    _js2n__-refsenv."_js2n__-:definitions/Pipelines!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PipelineExtends!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file = _js2n__-prdslib.isType '"String",
                  "import" = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PipelineLifecycle!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  preSteps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Step!predicate"
                        ],
                  replace = _js2n__-prdslib.isType '"Bool",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Step!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PipelineLifecycles!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  build =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                  pipeline =
                    _js2n__-refsenv."_js2n__-:definitions/ParsedPipeline!predicate",
                  postBuild =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                  preBuild =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                  promote =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                  setVersion =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                  setup =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PipelineOverride!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  agent =
                    _js2n__-refsenv."_js2n__-:definitions/Agent!predicate",
                  containerOptions =
                    _js2n__-refsenv."_js2n__-:definitions/Container!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  pipeline = _js2n__-prdslib.isType '"String",
                  sidecars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Container!predicate"
                        ],
                  stage = _js2n__-prdslib.isType '"String",
                  step = _js2n__-refsenv."_js2n__-:definitions/Step!predicate",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Step!predicate"
                        ],
                  type = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Volume!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Pipelines!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/ParsedPipeline!predicate",
                  feature =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycles!predicate",
                  overrides =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PipelineOverride!predicate"
                        ],
                  post =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycle!predicate",
                  pullRequest =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycles!predicate",
                  release =
                    _js2n__-refsenv."_js2n__-:definitions/PipelineLifecycles!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PortworxVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  volumeID = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Post!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PostAction!predicate"
                        ],
                  condition = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PostAction!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".*" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PreviewEnvironmentConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  maximumInstances = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProjectConfig!contract" =
        {
            addons
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  _js2n__-refsenv."_js2n__-:definitions/AddonConfig!predicate"
              )
              | optional,
            buildPack | String | optional,
            buildPackGitRef | String | optional,
            buildPackGitURL | String | optional,
            chat
              | _js2n__-prdslib.contract_from_predicate
                _js2n__-refsenv."_js2n__-:definitions/ChatConfig!predicate"
              | optional,
            dockerRegistryHost | String | optional,
            dockerRegistryOwner | String | optional,
            env
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
              )
              | optional,
            issueTracker
              | _js2n__-prdslib.contract_from_predicate
                _js2n__-refsenv."_js2n__-:definitions/IssueTrackerConfig!predicate"
              | optional,
            noReleasePrepare | Bool | optional,
            pipelineConfig
              | _js2n__-prdslib.contract_from_predicate
                _js2n__-refsenv."_js2n__-:definitions/PipelineConfig!predicate"
              | optional,
            previewEnvironments
              | _js2n__-prdslib.contract_from_predicate
                _js2n__-refsenv."_js2n__-:definitions/PreviewEnvironmentConfig!predicate"
              | optional,
            wiki
              | _js2n__-prdslib.contract_from_predicate
                _js2n__-refsenv."_js2n__-:definitions/WikiConfig!predicate"
              | optional,
          },
      "_js2n__-:definitions/ProjectedVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/VolumeProjection!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Quantity!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/QuobyteVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  group = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  registry = _js2n__-prdslib.isType '"String",
                  tenant = _js2n__-prdslib.isType '"String",
                  user = _js2n__-prdslib.isType '"String",
                  volume = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RBDVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  keyring = _js2n__-prdslib.isType '"String",
                  monitors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  pool = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ResourceFieldSelector!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  containerName = _js2n__-prdslib.isType '"String",
                  divisor =
                    _js2n__-refsenv."_js2n__-:definitions/Quantity!predicate",
                  resource = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RootOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  containerOptions =
                    _js2n__-refsenv."_js2n__-:definitions/Container!predicate",
                  distributeParallelAcrossNodes =
                    _js2n__-prdslib.isType '"Bool",
                  podLabels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".*" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                  retry = _js2n__-prdslib.isType 'Integer,
                  sidecars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Container!predicate"
                        ],
                  timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Timeout!predicate",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Toleration!predicate"
                        ],
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Volume!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScaleIOVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  gateway = _js2n__-prdslib.isType '"String",
                  protectionDomain = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  sslEnabled = _js2n__-prdslib.isType '"Bool",
                  storageMode = _js2n__-prdslib.isType '"String",
                  storagePool = _js2n__-prdslib.isType '"String",
                  system = _js2n__-prdslib.isType '"String",
                  volumeName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SecretKeySelector!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SecretProjection!predicate" =
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
                            _js2n__-refsenv."_js2n__-:definitions/KeyToPath!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SecretVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultMode = _js2n__-prdslib.isType 'Integer,
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/KeyToPath!predicate"
                        ],
                  "optional" = _js2n__-prdslib.isType '"Bool",
                  secretName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ServiceAccountTokenProjection!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  audience = _js2n__-prdslib.isType '"String",
                  expirationSeconds = _js2n__-prdslib.isType 'Integer,
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Stage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  agent =
                    _js2n__-refsenv."_js2n__-:definitions/Agent!predicate",
                  dir = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
                        ],
                  environment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/StageOptions!predicate",
                  parallel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Stage!predicate"
                        ],
                  post =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Post!predicate"
                        ],
                  stages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Stage!predicate"
                        ],
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Step!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StageOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  containerOptions =
                    _js2n__-refsenv."_js2n__-:definitions/Container!predicate",
                  distributeParallelAcrossNodes =
                    _js2n__-prdslib.isType '"Bool",
                  podLabels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".*" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                  retry = _js2n__-prdslib.isType 'Integer,
                  sidecars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Container!predicate"
                        ],
                  stash =
                    _js2n__-refsenv."_js2n__-:definitions/Stash!predicate",
                  timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Timeout!predicate",
                  tolerations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Toleration!predicate"
                        ],
                  unstash =
                    _js2n__-refsenv."_js2n__-:definitions/Unstash!predicate",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Volume!predicate"
                        ],
                  workspace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Stash!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  files = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Step!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  agent =
                    _js2n__-refsenv."_js2n__-:definitions/Agent!predicate",
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  command = _js2n__-prdslib.isType '"String",
                  comment = _js2n__-prdslib.isType '"String",
                  container = _js2n__-prdslib.isType '"String",
                  dir = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/EnvVar!predicate"
                        ],
                  groovy = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  loop = _js2n__-refsenv."_js2n__-:definitions/Loop!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".*" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                  sh = _js2n__-prdslib.isType '"String",
                  step = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Step!predicate"
                        ],
                  when = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StorageOSVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  secretRef =
                    _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!predicate",
                  volumeName = _js2n__-prdslib.isType '"String",
                  volumeNamespace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Timeout!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  time = _js2n__-prdslib.isType 'Integer,
                  unit = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Toleration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  effect = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  operator = _js2n__-prdslib.isType '"String",
                  tolerationSeconds = _js2n__-prdslib.isType 'Integer,
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Unstash!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dir = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Volume!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  awsElasticBlockStore =
                    _js2n__-refsenv."_js2n__-:definitions/AWSElasticBlockStoreVolumeSource!predicate",
                  azureDisk =
                    _js2n__-refsenv."_js2n__-:definitions/AzureDiskVolumeSource!predicate",
                  azureFile =
                    _js2n__-refsenv."_js2n__-:definitions/AzureFileVolumeSource!predicate",
                  cephfs =
                    _js2n__-refsenv."_js2n__-:definitions/CephFSVolumeSource!predicate",
                  cinder =
                    _js2n__-refsenv."_js2n__-:definitions/CinderVolumeSource!predicate",
                  configMap =
                    _js2n__-refsenv."_js2n__-:definitions/ConfigMapVolumeSource!predicate",
                  csi =
                    _js2n__-refsenv."_js2n__-:definitions/CSIVolumeSource!predicate",
                  downwardAPI =
                    _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeSource!predicate",
                  emptyDir =
                    _js2n__-refsenv."_js2n__-:definitions/EmptyDirVolumeSource!predicate",
                  fc =
                    _js2n__-refsenv."_js2n__-:definitions/FCVolumeSource!predicate",
                  flexVolume =
                    _js2n__-refsenv."_js2n__-:definitions/FlexVolumeSource!predicate",
                  flocker =
                    _js2n__-refsenv."_js2n__-:definitions/FlockerVolumeSource!predicate",
                  gcePersistentDisk =
                    _js2n__-refsenv."_js2n__-:definitions/GCEPersistentDiskVolumeSource!predicate",
                  gitRepo =
                    _js2n__-refsenv."_js2n__-:definitions/GitRepoVolumeSource!predicate",
                  glusterfs =
                    _js2n__-refsenv."_js2n__-:definitions/GlusterfsVolumeSource!predicate",
                  hostPath =
                    _js2n__-refsenv."_js2n__-:definitions/HostPathVolumeSource!predicate",
                  iscsi =
                    _js2n__-refsenv."_js2n__-:definitions/ISCSIVolumeSource!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  nfs =
                    _js2n__-refsenv."_js2n__-:definitions/NFSVolumeSource!predicate",
                  persistentVolumeClaim =
                    _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimVolumeSource!predicate",
                  photonPersistentDisk =
                    _js2n__-refsenv."_js2n__-:definitions/PhotonPersistentDiskVolumeSource!predicate",
                  portworxVolume =
                    _js2n__-refsenv."_js2n__-:definitions/PortworxVolumeSource!predicate",
                  projected =
                    _js2n__-refsenv."_js2n__-:definitions/ProjectedVolumeSource!predicate",
                  quobyte =
                    _js2n__-refsenv."_js2n__-:definitions/QuobyteVolumeSource!predicate",
                  rbd =
                    _js2n__-refsenv."_js2n__-:definitions/RBDVolumeSource!predicate",
                  scaleIO =
                    _js2n__-refsenv."_js2n__-:definitions/ScaleIOVolumeSource!predicate",
                  secret =
                    _js2n__-refsenv."_js2n__-:definitions/SecretVolumeSource!predicate",
                  storageos =
                    _js2n__-refsenv."_js2n__-:definitions/StorageOSVolumeSource!predicate",
                  vsphereVolume =
                    _js2n__-refsenv."_js2n__-:definitions/VsphereVirtualDiskVolumeSource!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VolumeProjection!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configMap =
                    _js2n__-refsenv."_js2n__-:definitions/ConfigMapProjection!predicate",
                  downwardAPI =
                    _js2n__-refsenv."_js2n__-:definitions/DownwardAPIProjection!predicate",
                  secret =
                    _js2n__-refsenv."_js2n__-:definitions/SecretProjection!predicate",
                  serviceAccountToken =
                    _js2n__-refsenv."_js2n__-:definitions/ServiceAccountTokenProjection!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VsphereVirtualDiskVolumeSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fsType = _js2n__-prdslib.isType '"String",
                  storagePolicyID = _js2n__-prdslib.isType '"String",
                  storagePolicyName = _js2n__-prdslib.isType '"String",
                  volumePath = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WikiConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  kind = _js2n__-prdslib.isType '"String",
                  space = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/ProjectConfig!contract"