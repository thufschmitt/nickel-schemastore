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
      "_js2n__-:definitions/anidb-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "password", "username" ],
              _js2n__-prdslib.records.record
                {
                  cache_expiration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  client = _js2n__-prdslib.isType '"String",
                  language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.enum
                            [
                              "aa",
                              "ab",
                              "ae",
                              "af",
                              "ak",
                              "am",
                              "an",
                              "ar",
                              "as",
                              "av",
                              "ay",
                              "az",
                              "ba",
                              "be",
                              "bg",
                              "bh",
                              "bi",
                              "bm",
                              "bn",
                              "bo",
                              "br",
                              "bs",
                              "ca",
                              "ce",
                              "ch",
                              "co",
                              "cr",
                              "cs",
                              "cu",
                              "cv",
                              "cy",
                              "da",
                              "de",
                              "dz",
                              "ee",
                              "el",
                              "en",
                              "eo",
                              "es",
                              "et",
                              "eu",
                              "fa",
                              "fi",
                              "fj",
                              "fo",
                              "fr",
                              "fy",
                              "ga",
                              "gd",
                              "gl",
                              "gv",
                              "ha",
                              "he",
                              "hi",
                              "ho",
                              "hr",
                              "ht",
                              "hu",
                              "hy",
                              "hz",
                              "ia",
                              "id",
                              "ie",
                              "ig",
                              "ii",
                              "ik",
                              "io",
                              "is",
                              "it",
                              "iu",
                              "ja",
                              "jv",
                              "ka",
                              "kg",
                              "ki",
                              "kj",
                              "kk",
                              "kl",
                              "km",
                              "kn",
                              "ko",
                              "kr",
                              "ks",
                              "ku",
                              "kv",
                              "kw",
                              "ky",
                              "la",
                              "lb",
                              "lg",
                              "li",
                              "ln",
                              "lo",
                              "lt",
                              "lu",
                              "lv",
                              "mg",
                              "mh",
                              "mi",
                              "mk",
                              "ml",
                              "mn",
                              "mo",
                              "mr",
                              "ms",
                              "mt",
                              "nb",
                              "nd",
                              "ne",
                              "nl",
                              "nn",
                              "no",
                              "oc",
                              "oj",
                              "om",
                              "or",
                              "os",
                              "pa",
                              "pi",
                              "pl",
                              "ps",
                              "pt",
                              "qu",
                              "rm",
                              "rn",
                              "ro",
                              "ru",
                              "rw",
                              "se",
                              "sg",
                              "si",
                              "sk",
                              "sl",
                              "sm",
                              "sn",
                              "so",
                              "sq",
                              "sr",
                              "ss",
                              "st",
                              "su",
                              "sv",
                              "sw",
                              "ta",
                              "te",
                              "tg",
                              "th",
                              "ti",
                              "tk",
                              "tl",
                              "tn",
                              "to",
                              "tr",
                              "ts",
                              "tt",
                              "tw",
                              "ug",
                              "uk",
                              "ur",
                              "uz",
                              "vi",
                              "vo",
                              "wa",
                              "wo",
                              "xh",
                              "yi",
                              "yo",
                              "za",
                              "zh",
                              "zu"
                            ]
                        ],
                  password = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/collection-files!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/legacy-default-collection-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/kometa-default-collection-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path-collection-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/folder-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path-collection-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path-collection-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path-collection-with-template-variables!predicate"
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/file-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  file = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/file-path-collection-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  file = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-collections!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/file-path-overlay-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  file = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-overlays!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/folder-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "folder" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  folder = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/git-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "git" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  git = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/git-path-collection-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "git" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  git = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-collections!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/git-path-overlay-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "git" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  git = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-overlays!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/gotify-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "token", "url" ],
              _js2n__-prdslib.records.record
                {
                  token = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/kometa-default-collection-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "default" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  "default" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "actor",
                              "anilist",
                              "aspect",
                              "audio_language",
                              "bafta",
                              "based",
                              "basic",
                              "berlinale",
                              "cannes",
                              "cesar",
                              "choice",
                              "collectionless",
                              "content_rating_au",
                              "content_rating_cs",
                              "content_rating_de",
                              "content_rating_nz",
                              "content_rating_mal",
                              "content_rating_uk",
                              "content_rating_us",
                              "continent",
                              "country",
                              "decade",
                              "director",
                              "emmy",
                              "flixpatrol",
                              "franchise",
                              "genre",
                              "golden",
                              "imdb",
                              "myanimelist",
                              "network",
                              "nfr",
                              "oscars",
                              "other_chart",
                              "pca",
                              "producer",
                              "razzie",
                              "region",
                              "resolution",
                              "sag",
                              "seasonal",
                              "separator_award",
                              "separator_chart",
                              "spirit",
                              "streaming",
                              "studio",
                              "subtitle_language",
                              "sundance",
                              "tautulli",
                              "tiff",
                              "tmdb",
                              "trakt",
                              "universe",
                              "venice",
                              "writer",
                              "year"
                            ]
                        ],
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-collections!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/kometa-default-overlay-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  "default" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "aspect",
                              "audio_codec",
                              "commonsense",
                              "content_rating_au",
                              "content_rating_de",
                              "content_rating_nz",
                              "content_rating_uk",
                              "content_rating_us_movie",
                              "content_rating_us_show",
                              "direct_play",
                              "episode_info",
                              "language_count",
                              "flixpatrol",
                              "languages",
                              "mediastinger",
                              "network",
                              "ratings",
                              "resolution",
                              "ribbon",
                              "runtimes",
                              "status",
                              "streaming",
                              "studio",
                              "versions",
                              "video_format"
                            ]
                        ],
                  reapply_overlay = _js2n__-prdslib.isType '"Bool",
                  reapply_overlays = _js2n__-prdslib.isType '"Bool",
                  remove_overlays = _js2n__-prdslib.isType '"Bool",
                  reset_overlays =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tmdb", "plex" ]
                        ],
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-overlays!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/legacy-default-collection-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pmm" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  pmm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "actor",
                              "anilist",
                              "aspect",
                              "audio_language",
                              "bafta",
                              "based",
                              "basic",
                              "berlinale",
                              "cannes",
                              "cesar",
                              "choice",
                              "collectionless",
                              "content_rating_au",
                              "content_rating_cs",
                              "content_rating_de",
                              "content_rating_nz",
                              "content_rating_mal",
                              "content_rating_uk",
                              "content_rating_us",
                              "continent",
                              "country",
                              "decade",
                              "director",
                              "emmy",
                              "flixpatrol",
                              "franchise",
                              "genre",
                              "golden",
                              "imdb",
                              "myanimelist",
                              "network",
                              "nfr",
                              "oscars",
                              "other_chart",
                              "pca",
                              "producer",
                              "razzie",
                              "region",
                              "resolution",
                              "sag",
                              "seasonal",
                              "separator_award",
                              "separator_chart",
                              "spirit",
                              "streaming",
                              "studio",
                              "subtitle_language",
                              "sundance",
                              "tautulli",
                              "tiff",
                              "tmdb",
                              "trakt",
                              "universe",
                              "venice",
                              "writer",
                              "year"
                            ]
                        ],
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-collections!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/legacy-default-overlay-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "pmm" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  pmm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "aspect",
                              "audio_codec",
                              "commonsense",
                              "content_rating_au",
                              "content_rating_de",
                              "content_rating_nz",
                              "content_rating_uk",
                              "content_rating_us_movie",
                              "content_rating_us_show",
                              "direct_play",
                              "episode_info",
                              "language_count",
                              "flixpatrol",
                              "languages",
                              "mediastinger",
                              "network",
                              "ratings",
                              "resolution",
                              "ribbon",
                              "runtimes",
                              "status",
                              "streaming",
                              "studio",
                              "versions",
                              "video_format"
                            ]
                        ],
                  reapply_overlay = _js2n__-prdslib.isType '"Bool",
                  reapply_overlays = _js2n__-prdslib.isType '"Bool",
                  remove_overlays = _js2n__-prdslib.isType '"Bool",
                  reset_overlays =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tmdb", "plex" ]
                        ],
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-overlays!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/library-section!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^(?!plex|tmdb|tautulli|webhooks|omdb|mdblist|notifiarr|gotify|anidb|radarr|sonarr|trakt|mal).+$" =
                    _js2n__-prdslib.records.record
                        {
                          collection_files =
                            _js2n__-refsenv."_js2n__-:definitions/collection-files!predicate",
                          library_name = _js2n__-prdslib.isType '"String",
                          metadata_files =
                            _js2n__-refsenv."_js2n__-:definitions/metadata-files!predicate",
                          metadata_path =
                            _js2n__-refsenv."_js2n__-:definitions/metadata-path!predicate",
                          operations =
                            _js2n__-refsenv."_js2n__-:definitions/operations!predicate",
                          overlay_files =
                            _js2n__-refsenv."_js2n__-:definitions/overlay-files!predicate",
                          overlay_path =
                            _js2n__-refsenv."_js2n__-:definitions/overlay-path!predicate",
                          plex =
                            _js2n__-refsenv."_js2n__-:definitions/plex-server-lib!predicate",
                          radarr =
                            _js2n__-refsenv."_js2n__-:definitions/radarr-api-lib!predicate",
                          reapply_overlays = _js2n__-prdslib.isType '"Bool",
                          remove_overlays = _js2n__-prdslib.isType '"Bool",
                          report_path = _js2n__-prdslib.isType '"String",
                          reset_overlays =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "tmdb", "plex" ]
                                ],
                          run_order =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "collections",
                                            "metadata",
                                            "operations",
                                            "overlays"
                                          ]
                                      ]),
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          schedule = _js2n__-prdslib.isType '"String",
                          settings =
                            _js2n__-refsenv."_js2n__-:definitions/settings!predicate",
                          sonarr =
                            _js2n__-refsenv."_js2n__-:definitions/sonarr-api-lib!predicate",
                          tautulli =
                            _js2n__-refsenv."_js2n__-:definitions/tautulli-api!predicate",
                          template_variables =
                            _js2n__-refsenv."_js2n__-:definitions/template-variables-library!predicate",
                        } {} false _js2n__-prdslib.never,
                  "^schedule_.*$" = _js2n__-prdslib.isType '"String",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/mal-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "client_id", "client_secret" ],
              _js2n__-prdslib.records.record
                {
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mdblist-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apikey", "cache_expiration" ],
              _js2n__-prdslib.records.record
                {
                  apikey = _js2n__-prdslib.isType '"String",
                  cache_expiration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/metadata-files!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/file-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/folder-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path!predicate"
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/metadata-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/legacy-default-collection-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/kometa-default-collection-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path-collection-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/folder-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path-collection-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path-collection-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path-collection-with-template-variables!predicate"
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/notifiarr-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apikey" ],
              _js2n__-prdslib.records.record
                { apikey = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/omdb-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apikey", "cache_expiration" ],
              _js2n__-prdslib.records.record
                {
                  apikey = _js2n__-prdslib.isType '"String",
                  cache_expiration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/operations!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  assets_for_all = _js2n__-prdslib.isType '"Bool",
                  content_rating_mapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^.*$" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.strings.pattern "^.*$"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  delete_collections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              configured = _js2n__-prdslib.isType '"Bool",
                              less = _js2n__-prdslib.isType 'Integer,
                              managed = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  genre_mapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^.*$" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.strings.pattern "^.*$"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  mass_added_at_update =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "tmdb",
                              "tvdb",
                              "omdb",
                              "mdb",
                              "anidb",
                              "mal",
                              "lock",
                              "unlock",
                              "remove",
                              "reset"
                            ]
                        ],
                  mass_audience_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "imdb",
                                  "trakt_user",
                                  "omdb",
                                  "mdb",
                                  "mdb_average",
                                  "mdb_imdb",
                                  "mdb_metacritic",
                                  "mdb_metacriticuser",
                                  "mdb_trakt",
                                  "mdb_tomatoes",
                                  "mdb_tomatoesaudience",
                                  "mdb_tmdb",
                                  "mdb_letterboxd",
                                  "mdb_myanimelist",
                                  "anidb_rating",
                                  "anidb_average",
                                  "anidb_score",
                                  "mal",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "tmdb",
                                        "imdb",
                                        "trakt_user",
                                        "omdb",
                                        "mdb",
                                        "mdb_average",
                                        "mdb_imdb",
                                        "mdb_metacritic",
                                        "mdb_metacriticuser",
                                        "mdb_trakt",
                                        "mdb_tomatoes",
                                        "mdb_tomatoesaudience",
                                        "mdb_tmdb",
                                        "mdb_letterboxd",
                                        "mdb_myanimelist",
                                        "anidb_rating",
                                        "anidb_average",
                                        "anidb_score",
                                        "mal",
                                        "lock",
                                        "unlock",
                                        "remove",
                                        "reset"
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_background_update =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "tmdb", "plex", "lock", "unlock" ]
                        ],
                  mass_collection_mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "default", "hide", "hide_items", "show_items" ]
                        ],
                  mass_content_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "mdb",
                                  "mdb_commonsense",
                                  "mdb_commonsense0",
                                  "omdb",
                                  "mal",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum
                                  [
                                    "mdb",
                                    "mdb_commonsense",
                                    "mdb_commonsense0",
                                    "omdb",
                                    "mal",
                                    "lock",
                                    "unlock",
                                    "remove",
                                    "reset"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_critic_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "imdb",
                                  "trakt_user",
                                  "omdb",
                                  "mdb",
                                  "mdb_average",
                                  "mdb_imdb",
                                  "mdb_metacritic",
                                  "mdb_metacriticuser",
                                  "mdb_trakt",
                                  "mdb_tomatoes",
                                  "mdb_tomatoesaudience",
                                  "mdb_tmdb",
                                  "mdb_letterboxd",
                                  "mdb_myanimelist",
                                  "anidb_rating",
                                  "anidb_average",
                                  "anidb_score",
                                  "mal",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "tmdb",
                                        "imdb",
                                        "trakt_user",
                                        "omdb",
                                        "mdb",
                                        "mdb_average",
                                        "mdb_imdb",
                                        "mdb_metacritic",
                                        "mdb_metacriticuser",
                                        "mdb_trakt",
                                        "mdb_tomatoes",
                                        "mdb_tomatoesaudience",
                                        "mdb_tmdb",
                                        "mdb_letterboxd",
                                        "mdb_myanimelist",
                                        "anidb_rating",
                                        "anidb_average",
                                        "anidb_score",
                                        "mal",
                                        "lock",
                                        "unlock",
                                        "remove",
                                        "reset"
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_episode_audience_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "imdb",
                                  "lock",
                                  "remove",
                                  "reset",
                                  "unlock"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "tmdb",
                                        "imdb",
                                        "lock",
                                        "remove",
                                        "reset",
                                        "unlock"
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_episode_critic_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "imdb",
                                  "lock",
                                  "remove",
                                  "reset",
                                  "unlock"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "tmdb",
                                        "imdb",
                                        "lock",
                                        "remove",
                                        "reset",
                                        "unlock"
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_episode_user_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "imdb",
                                  "lock",
                                  "remove",
                                  "reset",
                                  "unlock"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "tmdb",
                                        "imdb",
                                        "lock",
                                        "remove",
                                        "reset",
                                        "unlock"
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_genre_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "tvdb",
                                  "imdb",
                                  "omdb",
                                  "anidb",
                                  "anidb_3_0",
                                  "anidb_2_5",
                                  "anidb_2_0",
                                  "anidb_1_5",
                                  "anidb_1_0",
                                  "anidb_0_5",
                                  "mal",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum
                                  [
                                    "tmdb",
                                    "tvdb",
                                    "imdb",
                                    "omdb",
                                    "anidb",
                                    "anidb_3_0",
                                    "anidb_2_5",
                                    "anidb_2_0",
                                    "anidb_1_5",
                                    "anidb_1_0",
                                    "anidb_0_5",
                                    "mal",
                                    "lock",
                                    "unlock",
                                    "remove",
                                    "reset"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_imdb_parental_labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "none", "mild", "moderate", "severe" ]
                        ],
                  mass_original_title_update =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "anidb",
                              "anidb_official",
                              "mal",
                              "mal_english",
                              "mal_japanese",
                              "lock",
                              "unlock",
                              "remove",
                              "reset"
                            ]
                        ],
                  mass_originally_available_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "tvdb",
                                  "omdb",
                                  "mdb",
                                  "anidb",
                                  "mal",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum
                                  [
                                    "tmdb",
                                    "tvdb",
                                    "omdb",
                                    "mdb",
                                    "anidb",
                                    "mal",
                                    "lock",
                                    "unlock",
                                    "remove",
                                    "reset"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_poster_update =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "tmdb", "plex", "lock", "unlock" ]
                        ],
                  mass_studio_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "anidb",
                                  "mal",
                                  "tmdb",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum
                                  [
                                    "anidb",
                                    "mal",
                                    "tmdb",
                                    "lock",
                                    "unlock",
                                    "remove",
                                    "reset"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  mass_user_rating_update =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "tmdb",
                                  "imdb",
                                  "trakt_user",
                                  "omdb",
                                  "mdb",
                                  "mdb_average",
                                  "mdb_imdb",
                                  "mdb_metacritic",
                                  "mdb_metacriticuser",
                                  "mdb_trakt",
                                  "mdb_tomatoes",
                                  "mdb_tomatoesaudience",
                                  "mdb_tmdb",
                                  "mdb_letterboxd",
                                  "mdb_myanimelist",
                                  "anidb_rating",
                                  "anidb_average",
                                  "anidb_score",
                                  "mal",
                                  "lock",
                                  "unlock",
                                  "remove",
                                  "reset"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.enum
                                      [
                                        "tmdb",
                                        "imdb",
                                        "trakt_user",
                                        "omdb",
                                        "mdb",
                                        "mdb_average",
                                        "mdb_imdb",
                                        "mdb_metacritic",
                                        "mdb_metacriticuser",
                                        "mdb_trakt",
                                        "mdb_tomatoes",
                                        "mdb_tomatoesaudience",
                                        "mdb_tmdb",
                                        "mdb_letterboxd",
                                        "mdb_myanimelist",
                                        "anidb_rating",
                                        "anidb_average",
                                        "anidb_score",
                                        "mal",
                                        "lock",
                                        "unlock",
                                        "remove",
                                        "reset"
                                      ],
                                    _js2n__-prdslib.isType '"Number"
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  metadata_backup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              add_blank_entries =
                                _js2n__-prdslib.isType '"Bool",
                              exclude =
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
                              path = _js2n__-prdslib.isType '"String",
                              sync_tags = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  radarr_add_all = _js2n__-prdslib.isType '"Bool",
                  radarr_remove_by_tag = _js2n__-prdslib.isType '"String",
                  remove_title_parentheses = _js2n__-prdslib.isType '"Bool",
                  sonarr_add_all = _js2n__-prdslib.isType '"Bool",
                  sonarr_remove_by_tag = _js2n__-prdslib.isType '"String",
                  split_duplicates = _js2n__-prdslib.isType '"Bool",
                  update_blank_track_titles = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/overlay-files!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/legacy-default-overlay-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/kometa-default-overlay-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path-overlay-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/folder-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path-overlay-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path-overlay-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path-overlay-with-template-variables!predicate"
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/overlay-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/legacy-default-overlay-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/kometa-default-overlay-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/file-path-overlay-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/folder-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/url-path-overlay-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/git-path-overlay-with-template-variables!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/repo-path-overlay-with-template-variables!predicate"
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/plex-server!predicate"
        | doc m%"
          Describes the primary Plex server to which Kometa can connect.
          This attribute is REQUIRED.  It can be overridden at the library level.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "token", "url" ],
              _js2n__-prdslib.records.record
                {
                  clean_bundles = _js2n__-prdslib.isType '"Bool",
                  db_cache =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "^$"
                            ]
                        ],
                  empty_trash = _js2n__-prdslib.isType '"Bool",
                  optimize = _js2n__-prdslib.isType '"Bool",
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  token = _js2n__-prdslib.isType '"String",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                  verify_ssl = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/plex-server-lib!predicate"
        | doc "Describes the Plex server where this library is found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clean_bundles = _js2n__-prdslib.isType '"Bool",
                  db_cache =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "^$"
                            ]
                        ],
                  empty_trash = _js2n__-prdslib.isType '"Bool",
                  optimize = _js2n__-prdslib.isType '"Bool",
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  token = _js2n__-prdslib.isType '"String",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/radarr-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "availability", "root_folder_path", "token", "url" ],
              _js2n__-prdslib.records.record
                {
                  add_existing = _js2n__-prdslib.isType '"Bool",
                  add_missing = _js2n__-prdslib.isType '"Bool",
                  availability =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "announced", "cinemas", "released", "db" ]
                        ],
                  ignore_cache = _js2n__-prdslib.isType '"Bool",
                  monitor = _js2n__-prdslib.isType '"Bool",
                  monitor_existing = _js2n__-prdslib.isType '"Bool",
                  plex_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quality_profile = _js2n__-prdslib.isType '"String",
                  radarr_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  root_folder_path = _js2n__-prdslib.isType '"String",
                  search = _js2n__-prdslib.isType '"Bool",
                  tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  token = _js2n__-prdslib.isType '"String",
                  upgrade_existing = _js2n__-prdslib.isType '"Bool",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/radarr-api-lib!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  add_existing = _js2n__-prdslib.isType '"Bool",
                  add_missing = _js2n__-prdslib.isType '"Bool",
                  availability =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "announced", "cinemas", "released", "db" ]
                        ],
                  ignore_cache = _js2n__-prdslib.isType '"Bool",
                  monitor = _js2n__-prdslib.isType '"Bool",
                  monitor_existing = _js2n__-prdslib.isType '"Bool",
                  plex_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quality_profile = _js2n__-prdslib.isType '"String",
                  radarr_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  root_folder_path = _js2n__-prdslib.isType '"String",
                  search = _js2n__-prdslib.isType '"Bool",
                  tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  token = _js2n__-prdslib.isType '"String",
                  upgrade_existing = _js2n__-prdslib.isType '"Bool",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/repo-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  repo = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/repo-path-collection-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  repo = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-collections!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/repo-path-overlay-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  repo = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-overlays!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/settings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asset_depth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  asset_directory =
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
                  asset_folders = _js2n__-prdslib.isType '"Bool",
                  cache = _js2n__-prdslib.isType '"Bool",
                  cache_expiration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  create_asset_folders = _js2n__-prdslib.isType '"Bool",
                  custom_repo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String"
                        ],
                  default_collection_order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.enum
                            [
                              "added.asc",
                              "added.desc",
                              "alpha",
                              "audience_rating.asc",
                              "audience_rating.desc",
                              "bitrate.asc",
                              "bitrate.desc",
                              "content_rating.asc",
                              "content_rating.desc",
                              "critic_rating.asc",
                              "critic_rating.desc",
                              "custom",
                              "duration.asc",
                              "duration.desc",
                              "originally_available.asc",
                              "originally_available.desc",
                              "plays.asc",
                              "plays.desc",
                              "progress.asc",
                              "progress.desc",
                              "random",
                              "release",
                              "release.asc",
                              "release.desc",
                              "resolution.asc",
                              "resolution.desc",
                              "title.asc",
                              "title.desc",
                              "user_rating.asc",
                              "user_rating.desc",
                              "viewed.asc",
                              "viewed.desc",
                              "year.asc",
                              "year.desc",
                              null
                            ]
                        ],
                  delete_below_minimum = _js2n__-prdslib.isType '"Bool",
                  delete_not_scheduled = _js2n__-prdslib.isType '"Bool",
                  dimensional_asset_rename = _js2n__-prdslib.isType '"Bool",
                  download_url_assets = _js2n__-prdslib.isType '"Bool",
                  ignore_ids =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^(\\d+)(,(\\d+))*$"
                            ],
                          _js2n__-prdslib.isType 'Integer
                        ],
                  ignore_imdb_ids =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^(tt\\d{7})(,(tt\\d{7}))*$"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern "^tt\\d{7}$"
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                  item_refresh_delay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minimum_items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  missing_only_released = _js2n__-prdslib.isType '"Bool",
                  only_filter_missing = _js2n__-prdslib.isType '"Bool",
                  overlay_artwork_filetype =
                    _js2n__-prdslib.enum
                        [ "jpg", "png", "webp_lossy", "webp_lossless" ],
                  overlay_artwork_quality =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  playlist_exclude_users =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^([^,]+)(,[^,]+)*$"
                            ]
                        ],
                  playlist_report = _js2n__-prdslib.isType '"Bool",
                  playlist_sync_to_users =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "all" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^([^,]+)(,[^,]+)*$"
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                  prioritize_assets = _js2n__-prdslib.isType '"Bool",
                  run_again_delay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  run_order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.enum
                              [
                                "operations",
                                "metadata",
                                "collections",
                                "overlays"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  save_report = _js2n__-prdslib.isType '"Bool",
                  show_asset_not_needed = _js2n__-prdslib.isType '"Bool",
                  show_filtered = _js2n__-prdslib.isType '"Bool",
                  show_missing = _js2n__-prdslib.isType '"Bool",
                  show_missing_assets = _js2n__-prdslib.isType '"Bool",
                  show_missing_episode_assets = _js2n__-prdslib.isType '"Bool",
                  show_missing_season_assets = _js2n__-prdslib.isType '"Bool",
                  show_options = _js2n__-prdslib.isType '"Bool",
                  show_unconfigured = _js2n__-prdslib.isType '"Bool",
                  show_unmanaged = _js2n__-prdslib.isType '"Bool",
                  sync_mode = _js2n__-prdslib.enum [ "sync", "append" ],
                  tvdb_language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.enum
                            [
                              "aar",
                              "abk",
                              "afr",
                              "aka",
                              "alb",
                              "amh",
                              "ara",
                              "arg",
                              "arm",
                              "asm",
                              "ava",
                              "ave",
                              "aym",
                              "aze",
                              "bak",
                              "bam",
                              "bel",
                              "ben",
                              "bih",
                              "bis",
                              "bod",
                              "bos",
                              "bre",
                              "bul",
                              "cat",
                              "cha",
                              "che",
                              "chi",
                              "chu",
                              "chv",
                              "cor",
                              "cos",
                              "cre",
                              "ces",
                              "dan",
                              "deu",
                              "div",
                              "dzo",
                              "ell",
                              "eng",
                              "epo",
                              "est",
                              "eus",
                              "ewe",
                              "fao",
                              "fas",
                              "fij",
                              "fin",
                              "fra",
                              "fry",
                              "ful",
                              "gla",
                              "gle",
                              "glg",
                              "glv",
                              "grn",
                              "guj",
                              "hat",
                              "hau",
                              "heb",
                              "her",
                              "hin",
                              "hmo",
                              "hrv",
                              "hun",
                              "hye",
                              "ibo",
                              "ido",
                              "iii",
                              "iku",
                              "ile",
                              "ina",
                              "ind",
                              "ipk",
                              "isl",
                              "ita",
                              "jav",
                              "jpn",
                              "kal",
                              "kan",
                              "kas",
                              "kat",
                              "kau",
                              "kaz",
                              "khm",
                              "kik",
                              "kin",
                              "kir",
                              "kom",
                              "kon",
                              "kor",
                              "kua",
                              "kur",
                              "lao",
                              "lat",
                              "lav",
                              "lim",
                              "lin",
                              "lit",
                              "ltz",
                              "lub",
                              "lug",
                              "mah",
                              "mal",
                              "mar",
                              "mkd",
                              "mlg",
                              "mlt",
                              "mon",
                              "mri",
                              "msa",
                              "mya",
                              "nau",
                              "nav",
                              "nbl",
                              "nde",
                              "ndo",
                              "nep",
                              "nld",
                              "nno",
                              "nob",
                              "nor",
                              "nya",
                              "oci",
                              "oji",
                              "ori",
                              "orm",
                              "oss",
                              "pan",
                              "pli",
                              "pol",
                              "por",
                              "pus",
                              "que",
                              "roh",
                              "ron",
                              "run",
                              "rus",
                              "sag",
                              "san",
                              "sin",
                              "slk",
                              "slv",
                              "sme",
                              "smo",
                              "sna",
                              "snd",
                              "som",
                              "sot",
                              "spa",
                              "srd",
                              "srp",
                              "ssw",
                              "sun",
                              "swa",
                              "swe",
                              "tah",
                              "tam",
                              "tat",
                              "tel",
                              "tgk",
                              "tgl",
                              "tha",
                              "tir",
                              "ton",
                              "tsn",
                              "tso",
                              "tuk",
                              "tur",
                              "twi",
                              "uig",
                              "ukr",
                              "urd",
                              "uzb",
                              "ven",
                              "vie",
                              "vol",
                              "wln",
                              "wol",
                              "xho",
                              "yid",
                              "yor",
                              "zha",
                              "zho",
                              "zul"
                            ]
                        ],
                  verify_ssl = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sonarr-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "quality_profile", "root_folder_path", "token", "url" ],
              _js2n__-prdslib.records.record
                {
                  add_existing = _js2n__-prdslib.isType '"Bool",
                  add_missing = _js2n__-prdslib.isType '"Bool",
                  cutoff_search = _js2n__-prdslib.isType '"Bool",
                  ignore_cache = _js2n__-prdslib.isType '"Bool",
                  language_profile = _js2n__-prdslib.isType '"String",
                  monitor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "all",
                              "future",
                              "missing",
                              "existing",
                              "pilot",
                              "first",
                              "latest",
                              "none"
                            ]
                        ],
                  monitor_existing = _js2n__-prdslib.isType '"Bool",
                  plex_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quality_profile = _js2n__-prdslib.isType '"String",
                  root_folder_path = _js2n__-prdslib.isType '"String",
                  search = _js2n__-prdslib.isType '"Bool",
                  season_folder = _js2n__-prdslib.isType '"Bool",
                  series_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "standard", "daily", "anime" ]
                        ],
                  sonarr_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  token = _js2n__-prdslib.isType '"String",
                  upgrade_existing = _js2n__-prdslib.isType '"Bool",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sonarr-api-lib!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  add_existing = _js2n__-prdslib.isType '"Bool",
                  add_missing = _js2n__-prdslib.isType '"Bool",
                  cutoff_search = _js2n__-prdslib.isType '"Bool",
                  ignore_cache = _js2n__-prdslib.isType '"Bool",
                  language_profile = _js2n__-prdslib.isType '"String",
                  monitor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "all",
                              "future",
                              "missing",
                              "existing",
                              "pilot",
                              "first",
                              "latest",
                              "none"
                            ]
                        ],
                  monitor_existing = _js2n__-prdslib.isType '"Bool",
                  plex_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quality_profile = _js2n__-prdslib.isType '"String",
                  root_folder_path = _js2n__-prdslib.isType '"String",
                  search = _js2n__-prdslib.isType '"Bool",
                  season_folder = _js2n__-prdslib.isType '"Bool",
                  series_type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "standard", "daily", "anime" ]
                        ],
                  sonarr_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  token = _js2n__-prdslib.isType '"String",
                  upgrade_existing = _js2n__-prdslib.isType '"Bool",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tautulli-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apikey", "url" ],
              _js2n__-prdslib.records.record
                {
                  apikey = _js2n__-prdslib.isType '"String",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/template-variables-collections!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              depth =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              ending =
                                _js2n__-prdslib.oneOf
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
                                            "^(current_year(\\s*-\\s*\\d+)?)$|^(first(\\s*\\+\\s*\\d+)?)$|^(latest(\\s*-\\s*\\d+)?)$"
                                        ]
                                    ],
                              increment =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              limit =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              starting =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^(current_year(\\s*-\\s*\\d+)?)$|^(first(\\s*\\+\\s*\\d+)?)$|^(latest(\\s*-\\s*\\d+)?)$"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "color",
                              "white",
                              "bw",
                              "diiivoy",
                              "diiivoycolor",
                              "rainier",
                              "signature",
                              "orig",
                              "transparent",
                              "default",
                              "standards"
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/template-variables-library!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  collection_mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "default", "hide", "hide_items", "show_items" ]
                        ],
                  language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "en",
                              "fr",
                              "ar",
                              "da",
                              "nl",
                              "de",
                              "it",
                              "pt-br",
                              "nb-no",
                              "es",
                              "sv"
                            ]
                        ],
                  placeholder_imdb_id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^tt\\d{7}$"
                        ],
                  sep_style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "amethyst",
                              "aqua",
                              "blue",
                              "forest",
                              "fuchsia",
                              "gold",
                              "gray",
                              "green",
                              "navy",
                              "ocean",
                              "olive",
                              "orchid",
                              "orig",
                              "pink",
                              "plum",
                              "purple",
                              "red",
                              "rust",
                              "salmon",
                              "sand",
                              "stb",
                              "tan"
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/template-variables-overlays!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addon_offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  addon_position =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "left", "top", "bottom", "right" ]
                        ],
                  back_align =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "left", "right", "center", "top", "bottom" ]
                        ],
                  back_color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  back_height =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  back_line_color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  back_line_width =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  back_padding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  back_radius =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  back_width =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  builder_level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "show", "season", "episode" ]
                        ],
                  file = _js2n__-prdslib.isType '"String",
                  final_name = _js2n__-prdslib.isType '"String",
                  flag_alignment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "left", "right" ]
                        ],
                  font = _js2n__-prdslib.isType '"String",
                  font_color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  font_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  font_style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Any", "Italic", "Normal", "Oblique" ]
                        ],
                  git = _js2n__-prdslib.isType '"String",
                  group_alignment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "horizontal", "vertical" ]
                        ],
                  horizontal_align =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "left", "center", "right" ]
                        ],
                  horizontal_offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  horizontal_position =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "left",
                              "left2",
                              "center",
                              "center_left",
                              "center_right",
                              "right",
                              "right2"
                            ]
                        ],
                  languages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern "^[a-z]{2}$"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  last =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  location =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "world",
                              "albania",
                              "argentina",
                              "armenia",
                              "australia",
                              "austria",
                              "azerbaijan",
                              "bahamas",
                              "bahrain",
                              "bangladesh",
                              "belarus",
                              "belgium",
                              "belize",
                              "benin",
                              "bolivia",
                              "bosnia_and_herzegovina",
                              "botswana",
                              "brazil",
                              "bulgaria",
                              "burkina_faso",
                              "cambodia",
                              "canada",
                              "chile",
                              "colombia",
                              "costa_rica",
                              "croatia",
                              "cyprus",
                              "czech_republic",
                              "denmark",
                              "dominican_republic",
                              "ecuador",
                              "egypt",
                              "estonia",
                              "finland",
                              "france",
                              "gabon",
                              "germany",
                              "ghana",
                              "greece",
                              "guatemala",
                              "guinea_bissau",
                              "haiti",
                              "honduras",
                              "hong_kong",
                              "hungary",
                              "iceland",
                              "india",
                              "indonesia",
                              "ireland",
                              "israel",
                              "italy",
                              "ivory_coast",
                              "jamaica",
                              "japan",
                              "jordan",
                              "kazakhstan",
                              "kenya",
                              "kuwait",
                              "kyrgyzstan",
                              "laos",
                              "latvia",
                              "lebanon",
                              "lithuania",
                              "luxembourg",
                              "malaysia",
                              "maldives",
                              "mali",
                              "malta",
                              "mexico",
                              "moldova",
                              "mongolia",
                              "montenegro",
                              "morocco",
                              "mozambique",
                              "namibia",
                              "netherlands",
                              "new_zealand",
                              "nicaragua",
                              "niger",
                              "nigeria",
                              "north_macedonia",
                              "norway",
                              "oman",
                              "pakistan",
                              "panama",
                              "papua_new_guinea",
                              "paraguay",
                              "peru",
                              "philippines",
                              "poland",
                              "portugal",
                              "qatar",
                              "romania",
                              "russia",
                              "rwanda",
                              "salvador",
                              "saudi_arabia",
                              "senegal",
                              "serbia",
                              "singapore",
                              "slovakia",
                              "slovenia",
                              "south_africa",
                              "south_korea",
                              "spain",
                              "sri_lanka",
                              "sweden",
                              "switzerland",
                              "taiwan",
                              "tajikistan",
                              "tanzania",
                              "thailand",
                              "togo",
                              "trinidad_and_tobago",
                              "turkey",
                              "turkmenistan",
                              "uganda",
                              "ukraine",
                              "united_arab_emirates",
                              "united_kingdom",
                              "united_states",
                              "uruguay",
                              "uzbekistan",
                              "venezuela",
                              "vietnam",
                              "zambia",
                              "zimbabwe"
                            ]
                        ],
                  minimum = _js2n__-prdslib.isType 'Integer,
                  offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  originals_only = _js2n__-prdslib.isType '"Bool",
                  overlay_limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 5,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  position =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "left", "right" ]
                        ],
                  post_nr_text = _js2n__-prdslib.isType '"String",
                  post_text = _js2n__-prdslib.isType '"String",
                  pre_nr_text = _js2n__-prdslib.isType '"String",
                  pre_text = _js2n__-prdslib.isType '"String",
                  rating1 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "critic", "audience", "user" ]
                        ],
                  rating1_font = _js2n__-prdslib.isType '"String",
                  rating1_font_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  rating1_image =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "anidb",
                              "imdb",
                              "letterboxd",
                              "tmdb",
                              "metacritic",
                              "rt_popcorn",
                              "rt_tomato",
                              "trakt",
                              "mal",
                              "mdb",
                              "star"
                            ]
                        ],
                  rating2 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "critic", "audience", "user" ]
                        ],
                  rating2_font = _js2n__-prdslib.isType '"String",
                  rating2_font_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  rating2_image =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "anidb",
                              "imdb",
                              "letterboxd",
                              "tmdb",
                              "metacritic",
                              "rt_popcorn",
                              "rt_tomato",
                              "trakt",
                              "mal",
                              "mdb",
                              "star"
                            ]
                        ],
                  rating3 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "critic", "audience", "user" ]
                        ],
                  rating3_font = _js2n__-prdslib.isType '"String",
                  rating3_font_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  rating3_image =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "anidb",
                              "imdb",
                              "letterboxd",
                              "tmdb",
                              "metacritic",
                              "rt_popcorn",
                              "rt_tomato",
                              "trakt",
                              "mal",
                              "mdb",
                              "star"
                            ]
                        ],
                  rating_alignment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "vertical", "horizontal" ]
                        ],
                  reapply_overlays = _js2n__-prdslib.isType '"Bool",
                  region =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "us",
                              "uk",
                              "ca",
                              "da",
                              "de",
                              "es",
                              "fr",
                              "it",
                              "pt-br"
                            ]
                        ],
                  remove_overlays = _js2n__-prdslib.isType '"Bool",
                  repo = _js2n__-prdslib.isType '"String",
                  reset_overlays =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "tmdb", "plex" ]
                        ],
                  stroke_color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  stroke_width =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  style =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "compact",
                              "standard",
                              "bigger",
                              "round",
                              "square",
                              "half",
                              "red",
                              "black",
                              "yellow",
                              "gray",
                              "color",
                              "white"
                            ]
                        ],
                  text = _js2n__-prdslib.isType '"String",
                  time_window =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "today",
                              "yesterday",
                              "this_week",
                              "last_week",
                              "this_month",
                              "last_month",
                              "this_year",
                              "last_year"
                            ]
                        ],
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                  use_edition = _js2n__-prdslib.isType '"Bool",
                  use_lowercase = _js2n__-prdslib.isType '"Bool",
                  use_resolution = _js2n__-prdslib.isType '"Bool",
                  use_subtitles = _js2n__-prdslib.isType '"Bool",
                  vertical_align =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "top", "center", "bottom" ]
                        ],
                  vertical_offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  vertical_position =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "top",
                              "top2",
                              "top3",
                              "center",
                              "center_top",
                              "center_bottom",
                              "bottom",
                              "bottom2",
                              "bottom3"
                            ]
                        ],
                }
                {
                  "^back_align_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "left", "right", "center", "top", "bottom" ]
                        ],
                  "^back_color_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  "^back_height_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^back_line_color_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  "^back_line_width_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^back_padding_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^back_radius_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^back_width_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^country_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[A-Z]{2}$"
                        ],
                  "^file_.*$" = _js2n__-prdslib.isType '"String",
                  "^font_.*$" = _js2n__-prdslib.isType '"String",
                  "^font_color_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  "^font_size_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^font_style_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Any", "Italic", "Normal", "Oblique" ]
                        ],
                  "^git_.*$" = _js2n__-prdslib.isType '"String",
                  "^horizontal_align_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "left", "center", "right" ]
                        ],
                  "^horizontal_offset_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  "^limit_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^location_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "world",
                              "albania",
                              "argentina",
                              "armenia",
                              "australia",
                              "austria",
                              "azerbaijan",
                              "bahamas",
                              "bahrain",
                              "bangladesh",
                              "belarus",
                              "belgium",
                              "belize",
                              "benin",
                              "bolivia",
                              "bosnia_and_herzegovina",
                              "botswana",
                              "brazil",
                              "bulgaria",
                              "burkina_faso",
                              "cambodia",
                              "canada",
                              "chile",
                              "colombia",
                              "costa_rica",
                              "croatia",
                              "cyprus",
                              "czech_republic",
                              "denmark",
                              "dominican_republic",
                              "ecuador",
                              "egypt",
                              "estonia",
                              "finland",
                              "france",
                              "gabon",
                              "germany",
                              "ghana",
                              "greece",
                              "guatemala",
                              "guinea_bissau",
                              "haiti",
                              "honduras",
                              "hong_kong",
                              "hungary",
                              "iceland",
                              "india",
                              "indonesia",
                              "ireland",
                              "israel",
                              "italy",
                              "ivory_coast",
                              "jamaica",
                              "japan",
                              "jordan",
                              "kazakhstan",
                              "kenya",
                              "kuwait",
                              "kyrgyzstan",
                              "laos",
                              "latvia",
                              "lebanon",
                              "lithuania",
                              "luxembourg",
                              "malaysia",
                              "maldives",
                              "mali",
                              "malta",
                              "mexico",
                              "moldova",
                              "mongolia",
                              "montenegro",
                              "morocco",
                              "mozambique",
                              "namibia",
                              "netherlands",
                              "new_zealand",
                              "nicaragua",
                              "niger",
                              "nigeria",
                              "north_macedonia",
                              "norway",
                              "oman",
                              "pakistan",
                              "panama",
                              "papua_new_guinea",
                              "paraguay",
                              "peru",
                              "philippines",
                              "poland",
                              "portugal",
                              "qatar",
                              "romania",
                              "russia",
                              "rwanda",
                              "salvador",
                              "saudi_arabia",
                              "senegal",
                              "serbia",
                              "singapore",
                              "slovakia",
                              "slovenia",
                              "south_africa",
                              "south_korea",
                              "spain",
                              "sri_lanka",
                              "sweden",
                              "switzerland",
                              "taiwan",
                              "tajikistan",
                              "tanzania",
                              "thailand",
                              "togo",
                              "trinidad_and_tobago",
                              "turkey",
                              "turkmenistan",
                              "uganda",
                              "ukraine",
                              "united_arab_emirates",
                              "united_kingdom",
                              "united_states",
                              "uruguay",
                              "uzbekistan",
                              "venezuela",
                              "vietnam",
                              "zambia",
                              "zimbabwe"
                            ]
                        ],
                  "^rating\\d+_.*$" = _js2n__-prdslib.isType '"String",
                  "^regex_.*$" = _js2n__-prdslib.isType '"String",
                  "^repo_.*$" = _js2n__-prdslib.isType '"String",
                  "^stroke_color_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"
                        ],
                  "^stroke_width_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  "^text_.*$" = _js2n__-prdslib.isType '"String",
                  "^time_window_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "today",
                              "yesterday",
                              "this_week",
                              "last_week",
                              "this_month",
                              "last_month",
                              "this_year",
                              "last_year"
                            ]
                        ],
                  "^url_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                  "^use_.*$" = _js2n__-prdslib.isType '"Bool",
                  "^vertical_align_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "top", "center", "bottom" ]
                        ],
                  "^vertical_offset_.*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  "^weight_.*$" = _js2n__-prdslib.isType 'Integer,
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tmdb-api!predicate"
        | doc "API Information to connect to TMDB; REQUIRED for the script to run"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "apikey" ],
              _js2n__-prdslib.records.record
                {
                  apikey = _js2n__-prdslib.isType '"String",
                  cache_expiration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.enum
                            [
                              "aa",
                              "ab",
                              "ae",
                              "af",
                              "ak",
                              "am",
                              "an",
                              "ar",
                              "as",
                              "av",
                              "ay",
                              "az",
                              "ba",
                              "be",
                              "bg",
                              "bh",
                              "bi",
                              "bm",
                              "bn",
                              "bo",
                              "br",
                              "bs",
                              "ca",
                              "ce",
                              "ch",
                              "co",
                              "cr",
                              "cs",
                              "cu",
                              "cv",
                              "cy",
                              "da",
                              "de",
                              "dz",
                              "ee",
                              "el",
                              "en",
                              "eo",
                              "es",
                              "et",
                              "eu",
                              "fa",
                              "fi",
                              "fj",
                              "fo",
                              "fr",
                              "fy",
                              "ga",
                              "gd",
                              "gl",
                              "gv",
                              "ha",
                              "he",
                              "hi",
                              "ho",
                              "hr",
                              "ht",
                              "hu",
                              "hy",
                              "hz",
                              "ia",
                              "id",
                              "ie",
                              "ig",
                              "ii",
                              "ik",
                              "io",
                              "is",
                              "it",
                              "iu",
                              "ja",
                              "jv",
                              "ka",
                              "kg",
                              "ki",
                              "kj",
                              "kk",
                              "kl",
                              "km",
                              "kn",
                              "ko",
                              "kr",
                              "ks",
                              "ku",
                              "kv",
                              "kw",
                              "ky",
                              "la",
                              "lb",
                              "lg",
                              "li",
                              "ln",
                              "lo",
                              "lt",
                              "lu",
                              "lv",
                              "mg",
                              "mh",
                              "mi",
                              "mk",
                              "ml",
                              "mn",
                              "mo",
                              "mr",
                              "ms",
                              "mt",
                              "nb",
                              "nd",
                              "ne",
                              "nl",
                              "nn",
                              "no",
                              "oc",
                              "oj",
                              "om",
                              "or",
                              "os",
                              "pa",
                              "pi",
                              "pl",
                              "ps",
                              "pt",
                              "qu",
                              "rm",
                              "rn",
                              "ro",
                              "ru",
                              "rw",
                              "se",
                              "sg",
                              "si",
                              "sk",
                              "sl",
                              "sm",
                              "sn",
                              "so",
                              "sq",
                              "sr",
                              "ss",
                              "st",
                              "su",
                              "sv",
                              "sw",
                              "ta",
                              "te",
                              "tg",
                              "th",
                              "ti",
                              "tk",
                              "tl",
                              "tn",
                              "to",
                              "tr",
                              "ts",
                              "tt",
                              "tw",
                              "ug",
                              "uk",
                              "ur",
                              "uz",
                              "vi",
                              "vo",
                              "wa",
                              "wo",
                              "xh",
                              "yi",
                              "yo",
                              "za",
                              "zh",
                              "zu"
                            ]
                        ],
                  region =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "",
                              "AD",
                              "AE",
                              "AF",
                              "AG",
                              "AI",
                              "AL",
                              "AM",
                              "AN",
                              "AO",
                              "AQ",
                              "AR",
                              "AS",
                              "AT",
                              "AU",
                              "AW",
                              "AZ",
                              "BA",
                              "BB",
                              "BD",
                              "BE",
                              "BF",
                              "BG",
                              "BH",
                              "BI",
                              "BJ",
                              "BM",
                              "BN",
                              "BO",
                              "BR",
                              "BS",
                              "BT",
                              "BU",
                              "BV",
                              "BW",
                              "BY",
                              "BZ",
                              "CA",
                              "CC",
                              "CD",
                              "CF",
                              "CG",
                              "CH",
                              "CI",
                              "CK",
                              "CL",
                              "CM",
                              "CN",
                              "CO",
                              "CR",
                              "CS",
                              "CU",
                              "CV",
                              "CX",
                              "CY",
                              "CZ",
                              "DE",
                              "DJ",
                              "DK",
                              "DM",
                              "DO",
                              "DZ",
                              "EC",
                              "EE",
                              "EG",
                              "EH",
                              "ER",
                              "ES",
                              "ET",
                              "FI",
                              "FJ",
                              "FK",
                              "FM",
                              "FO",
                              "FR",
                              "GA",
                              "GB",
                              "GD",
                              "GE",
                              "GF",
                              "GH",
                              "GI",
                              "GL",
                              "GM",
                              "GN",
                              "GP",
                              "GQ",
                              "GR",
                              "GS",
                              "GT",
                              "GU",
                              "GW",
                              "GY",
                              "HK",
                              "HM",
                              "HN",
                              "HR",
                              "HT",
                              "HU",
                              "ID",
                              "IE",
                              "IL",
                              "IN",
                              "IO",
                              "IQ",
                              "IR",
                              "IS",
                              "IT",
                              "JM",
                              "JO",
                              "JP",
                              "KE",
                              "KG",
                              "KH",
                              "KI",
                              "KM",
                              "KN",
                              "KP",
                              "KR",
                              "KW",
                              "KY",
                              "KZ",
                              "LA",
                              "LB",
                              "LC",
                              "LI",
                              "LK",
                              "LR",
                              "LS",
                              "LT",
                              "LU",
                              "LV",
                              "LY",
                              "MA",
                              "MC",
                              "MD",
                              "ME",
                              "MG",
                              "MH",
                              "MK",
                              "ML",
                              "MM",
                              "MN",
                              "MO",
                              "MP",
                              "MQ",
                              "MR",
                              "MS",
                              "MT",
                              "MU",
                              "MV",
                              "MW",
                              "MX",
                              "MY",
                              "MZ",
                              "NA",
                              "NC",
                              "NE",
                              "NF",
                              "NG",
                              "NI",
                              "NL",
                              "NO",
                              "NP",
                              "NR",
                              "NU",
                              "NZ",
                              "OM",
                              "PA",
                              "PE",
                              "PF",
                              "PG",
                              "PH",
                              "PK",
                              "PL",
                              "PM",
                              "PN",
                              "PR",
                              "PS",
                              "PT",
                              "PW",
                              "PY",
                              "QA",
                              "RE",
                              "RO",
                              "RS",
                              "RU",
                              "RW",
                              "SA",
                              "SB",
                              "SC",
                              "SD",
                              "SE",
                              "SG",
                              "SH",
                              "SI",
                              "SJ",
                              "SK",
                              "SL",
                              "SM",
                              "SN",
                              "SO",
                              "SR",
                              "SS",
                              "ST",
                              "SU",
                              "SV",
                              "SY",
                              "SZ",
                              "TC",
                              "TD",
                              "TF",
                              "TG",
                              "TH",
                              "TJ",
                              "TK",
                              "TL",
                              "TM",
                              "TN",
                              "TO",
                              "TP",
                              "TR",
                              "TT",
                              "TV",
                              "TW",
                              "TZ",
                              "UA",
                              "UG",
                              "UM",
                              "US",
                              "UY",
                              "UZ",
                              "VA",
                              "VC",
                              "VE",
                              "VG",
                              "VI",
                              "VN",
                              "VU",
                              "WF",
                              "WS",
                              "XC",
                              "XG",
                              "XI",
                              "XK",
                              "YE",
                              "YT",
                              "YU",
                              "ZA",
                              "ZM",
                              "ZR",
                              "ZW"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/trakt-api!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "client_id", "client_secret" ],
              _js2n__-prdslib.records.record
                {
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  pin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/url-path!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  schedule = _js2n__-prdslib.isType '"String",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/url-path-collection-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-collections!predicate",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/url-path-overlay-with-template-variables!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  asset_directory =
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
                  schedule = _js2n__-prdslib.isType '"String",
                  template_variables =
                    _js2n__-refsenv."_js2n__-:definitions/template-variables-overlays!predicate",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^(https?)://"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/webhooks!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  changes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  delete =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  error =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  run_end =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  run_start =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  version =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.records.required [ "plex", "tmdb" ],
          _js2n__-prdslib.records.record
            {
              anidb =
                _js2n__-refsenv."_js2n__-:definitions/anidb-api!predicate",
              gotify =
                _js2n__-refsenv."_js2n__-:definitions/gotify-api!predicate",
              libraries =
                _js2n__-refsenv."_js2n__-:definitions/library-section!predicate",
              mal = _js2n__-refsenv."_js2n__-:definitions/mal-api!predicate",
              mdblist =
                _js2n__-refsenv."_js2n__-:definitions/mdblist-api!predicate",
              notifiarr =
                _js2n__-refsenv."_js2n__-:definitions/notifiarr-api!predicate",
              omdb = _js2n__-refsenv."_js2n__-:definitions/omdb-api!predicate",
              plex =
                _js2n__-refsenv."_js2n__-:definitions/plex-server!predicate",
              radarr =
                _js2n__-refsenv."_js2n__-:definitions/radarr-api!predicate",
              settings =
                _js2n__-refsenv."_js2n__-:definitions/settings!predicate",
              sonarr =
                _js2n__-refsenv."_js2n__-:definitions/sonarr-api!predicate",
              tautulli =
                _js2n__-refsenv."_js2n__-:definitions/tautulli-api!predicate",
              tmdb = _js2n__-refsenv."_js2n__-:definitions/tmdb-api!predicate",
              trakt =
                _js2n__-refsenv."_js2n__-:definitions/trakt-api!predicate",
              webhooks =
                _js2n__-refsenv."_js2n__-:definitions/webhooks!predicate",
            } {} true _js2n__-prdslib.always
        ])