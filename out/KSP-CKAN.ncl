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
      "_js2n__-:definitions/identifier!predicate"
        | doc "Unique identifier for this mod."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z0-9][A-Za-z0-9-]+$"
            ],
      "_js2n__-:definitions/install_to!predicate"
        | doc "Where file should be installed to. As of v1.2, GameData may take a path"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [ "GameData", "Ships", "GameRoot", "Tutorial", "Scenarios" ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^GameData/"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^Ships/(SPH|VAB|Script)$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^Ships/@thumbs/(SPH|VAB)$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^Missions"
                ],
              _js2n__-prdslib.enum [ "GameData/Mods" ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^GameData/Mods/"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^BepInEx/plugins$"
                ]
            ],
      "_js2n__-:definitions/ksp_version!predicate"
        | doc "A game version"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(any|[0-9]+(\\.[0-9]+(\\.[0-9]+)?)?)$"
            ],
      "_js2n__-:definitions/license!predicate"
        | doc "A license."
        = _js2n__-prdslib.enum
            [
              "public-domain",
              "AFL-3.0",
              "AGPL-3.0",
              "Apache",
              "Apache-1.0",
              "Apache-2.0",
              "APSL-2.0",
              "Artistic",
              "Artistic-1.0",
              "Artistic-2.0",
              "BSD-2-clause",
              "BSD-3-clause",
              "BSD-4-clause",
              "ISC",
              "CC-BY",
              "CC-BY-1.0",
              "CC-BY-2.0",
              "CC-BY-2.5",
              "CC-BY-3.0",
              "CC-BY-4.0",
              "CC-BY-SA",
              "CC-BY-SA-1.0",
              "CC-BY-SA-2.0",
              "CC-BY-SA-2.5",
              "CC-BY-SA-3.0",
              "CC-BY-SA-4.0",
              "CC-BY-NC",
              "CC-BY-NC-1.0",
              "CC-BY-NC-2.0",
              "CC-BY-NC-2.5",
              "CC-BY-NC-3.0",
              "CC-BY-NC-4.0",
              "CC-BY-NC-SA",
              "CC-BY-NC-SA-1.0",
              "CC-BY-NC-SA-2.0",
              "CC-BY-NC-SA-2.5",
              "CC-BY-NC-SA-3.0",
              "CC-BY-NC-SA-4.0",
              "CC-BY-NC-ND",
              "CC-BY-NC-ND-1.0",
              "CC-BY-NC-ND-2.0",
              "CC-BY-NC-ND-2.5",
              "CC-BY-NC-ND-3.0",
              "CC-BY-NC-ND-4.0",
              "CC-BY-ND",
              "CC-BY-ND-1.0",
              "CC-BY-ND-2.0",
              "CC-BY-ND-2.5",
              "CC-BY-ND-3.0",
              "CC-BY-ND-4.0",
              "CC0",
              "CDDL",
              "CPL",
              "EFL-1.0",
              "EFL-2.0",
              "Expat",
              "MIT",
              "GPL-1.0",
              "GPL-2.0",
              "GPL-3.0",
              "LGPL-2.0",
              "LGPL-2.1",
              "LGPL-3.0",
              "GFDL-1.0",
              "GFDL-1.1",
              "GFDL-1.2",
              "GFDL-1.3",
              "GFDL-NIV-1.0",
              "GFDL-NIV-1.1",
              "GFDL-NIV-1.2",
              "GFDL-NIV-1.3",
              "LPPL-1.0",
              "LPPL-1.1",
              "LPPL-1.2",
              "LPPL-1.3c",
              "MPL-1.0",
              "MPL-1.1",
              "MPL-2.0",
              "Ms-PL",
              "Ms-RL",
              "Perl",
              "Python-2.0",
              "QPL-1.0",
              "Unlicense",
              "W3C",
              "WTFPL",
              "Zlib",
              "Zope",
              "open-source",
              "restricted",
              "unrestricted",
              "unknown"
            ],
      "_js2n__-:definitions/licenses!predicate"
        | doc "A license, or array of licenses"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/license!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ],
      "_js2n__-:definitions/one_or_more_strings!predicate"
        | doc "One or more strings"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ],
      "_js2n__-:definitions/relationship!predicate"
        | doc "A relationship to a list of mods"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "name" ],
                        _js2n__-prdslib.records.record
                          {
                            choice_help_text = _js2n__-prdslib.isType '"String",
                            max_version =
                              _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                            min_version =
                              _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                            name =
                              _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                            suppress_recommendations =
                              _js2n__-prdslib.isType '"Bool",
                            version =
                              _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                          } {} true _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "any_of" ],
                        _js2n__-prdslib.records.record
                          {
                            any_of =
                              _js2n__-refsenv."_js2n__-:definitions/relationship!predicate",
                            choice_help_text = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
            ],
      "_js2n__-:definitions/version!predicate"
        | doc "A version string"
        = _js2n__-prdslib.isType '"String",
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required [ "download" ],
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "download" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ]),
                  _js2n__-prdslib.records.required [ "kind" ],
                  _js2n__-prdslib.records.record
                    { kind = _js2n__-prdslib.enum [ "metapackage", "dlc" ], } {}
                    true _js2n__-prdslib.always
                ]
            ],
          _js2n__-prdslib.records.required
            [
              "abstract",
              "author",
              "identifier",
              "license",
              "name",
              "spec_version",
              "version"
            ],
          _js2n__-prdslib.records.record
            {
              abstract = _js2n__-prdslib.isType '"String",
              author =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ]
                    ],
              comment = _js2n__-prdslib.isType '"String",
              conflicts =
                _js2n__-refsenv."_js2n__-:definitions/relationship!predicate",
              depends =
                _js2n__-refsenv."_js2n__-:definitions/relationship!predicate",
              description = _js2n__-prdslib.isType '"String",
              download =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ]
                    ],
              download_content_type = _js2n__-prdslib.isType '"String",
              download_hash =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          sha1 = _js2n__-prdslib.isType '"String",
                          sha256 = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              download_size = _js2n__-prdslib.isType 'Integer,
              identifier =
                _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
              install =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "file" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "find" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "find_regexp" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ]
                              ],
                            _js2n__-prdslib.not
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "filter", "include_only" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "filter", "include_only_regexp" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "filter_regexp", "include_only" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [
                                          "filter_regexp",
                                          "include_only_regexp"
                                        ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ]
                                ]),
                            _js2n__-prdslib.records.required [ "install_to" ],
                            _js2n__-prdslib.records.record
                              {
                                as =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.pattern
                                          "^[^\\\\/]+$"
                                      ],
                                file = _js2n__-prdslib.isType '"String",
                                filter =
                                  _js2n__-refsenv."_js2n__-:definitions/one_or_more_strings!predicate",
                                filter_regexp =
                                  _js2n__-refsenv."_js2n__-:definitions/one_or_more_strings!predicate",
                                find = _js2n__-prdslib.isType '"String",
                                find_matches_files =
                                  _js2n__-prdslib.isType '"Bool",
                                find_regexp = _js2n__-prdslib.isType '"String",
                                include_only =
                                  _js2n__-refsenv."_js2n__-:definitions/one_or_more_strings!predicate",
                                include_only_regexp =
                                  _js2n__-refsenv."_js2n__-:definitions/one_or_more_strings!predicate",
                                install_to =
                                  _js2n__-refsenv."_js2n__-:definitions/install_to!predicate",
                              } {} true _js2n__-prdslib.always
                          ])
                    ],
              install_size = _js2n__-prdslib.isType 'Integer,
              kind = _js2n__-prdslib.enum [ "package", "metapackage", "dlc" ],
              ksp_version =
                _js2n__-refsenv."_js2n__-:definitions/ksp_version!predicate",
              ksp_version_max =
                _js2n__-refsenv."_js2n__-:definitions/ksp_version!predicate",
              ksp_version_min =
                _js2n__-refsenv."_js2n__-:definitions/ksp_version!predicate",
              ksp_version_strict = _js2n__-prdslib.isType '"Bool",
              license =
                _js2n__-refsenv."_js2n__-:definitions/licenses!predicate",
              localizations =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              name = _js2n__-prdslib.isType '"String",
              provides =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              recommends =
                _js2n__-refsenv."_js2n__-:definitions/relationship!predicate",
              release_date = _js2n__-prdslib.isType '"String",
              release_status =
                _js2n__-prdslib.enum [ "stable", "testing", "development" ],
              replaced_by =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "name" ],
                      _js2n__-prdslib.records.record
                        {
                          min_version =
                            _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                          name =
                            _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                          version =
                            _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
              resources =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          bugtracker = _js2n__-prdslib.isType '"String",
                          ci = _js2n__-prdslib.isType '"String",
                          curse = _js2n__-prdslib.isType '"String",
                          discussions = _js2n__-prdslib.isType '"String",
                          homepage = _js2n__-prdslib.isType '"String",
                          license = _js2n__-prdslib.isType '"String",
                          manual = _js2n__-prdslib.isType '"String",
                          metanetkan = _js2n__-prdslib.isType '"String",
                          remote-avc = _js2n__-prdslib.isType '"String",
                          remote-swinfo = _js2n__-prdslib.isType '"String",
                          repository = _js2n__-prdslib.isType '"String",
                          spacedock = _js2n__-prdslib.isType '"String",
                          steamstore = _js2n__-prdslib.isType '"String",
                          store = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              spec_version =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 1,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^v[0-9]+\\.[0-9]+$"
                        ]
                    ],
              suggests =
                _js2n__-refsenv."_js2n__-:definitions/relationship!predicate",
              supports =
                _js2n__-refsenv."_js2n__-:definitions/relationship!predicate",
              tags =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern "^[a-z0-9-]+$"
                          ])
                    ],
              version =
                _js2n__-refsenv."_js2n__-:definitions/version!predicate",
            } {} true _js2n__-prdslib.always
        ])