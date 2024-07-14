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
      "_js2n__-:definitions/AlbListenerProtocolEnum!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'HTTPS, 'HTTP |] ],
      "_js2n__-:definitions/AlbListenerTypeEnum!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'redirect, 'forward, 'fixed-response |]
            ],
      "_js2n__-:definitions/AlbRoutingHttpConfigMitigationModeEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'strictest, 'defensive, 'monitor |] ],
      "_js2n__-:definitions/AlbSchemeEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'internal, 'internet-facing |] ],
      "_js2n__-:definitions/AlpnPolicyEnum!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'None,
                'HTTP2Preferred,
                'HTTP2Optional,
                'HTTP2Only,
                'HTTP1Only
              |]
            ],
      "_js2n__-:definitions/AutoScalingHealthCheckTypeEnum!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'ELB, 'EC2 |] ],
      "_js2n__-:definitions/IAlbAttributesConfig!contract"
        | doc "Application Load Balancer attributes config."
        = {
            deletionProtection
              | Bool
              | doc "Enable or disable deletion protection."
              | optional,
            http2Enabled
              | Bool
              | doc "Indicates whether HTTP/2 is enabled. The possible values are true and false. The default is true. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens."
              | optional,
            idleTimeout
              | Number
              | doc "The idle timeout value, in seconds. The valid range is 1-4000 seconds. The default is 60 seconds."
              | optional,
            routingHttpDesyncMitigationMode
              | _js2n__-refsenv."_js2n__-:definitions/AlbRoutingHttpConfigMitigationModeEnum!contract"
              | doc "Determines how the load balancer handles requests that might pose a security risk to your application. The possible values are `monitor` , `defensive` , and `strictest` . The default is `defensive`."
              | optional,
            routingHttpDropInvalidHeader
              | Bool
              | doc "Indicates whether HTTP headers with invalid header fields are removed by the load balancer ( true ) or routed to targets ( false ). The default is false."
              | optional,
            routingHttpXAmznTlsCipherEnable
              | Bool
              | doc "Indicates whether the two headers ( x-amzn-tls-version and x-amzn-tls-cipher-suite ), which contain information about the negotiated TLS version and cipher suite, are added to the client request before sending it to the target. The x-amzn-tls-version header has information about the TLS protocol version negotiated with the client, and the x-amzn-tls-cipher-suite header has information about the cipher suite negotiated with the client. Both headers are in OpenSSL format. The possible values for the attribute are true and false . The default is false."
              | optional,
            routingHttpXffClientPort
              | Bool
              | doc "Indicates whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer. The possible values are true and false . The default is false."
              | optional,
            routingHttpXffHeaderProcessingMode
              | _js2n__-refsenv."_js2n__-:definitions/RoutingHttpXffHeaderProcessingModeEnum!contract"
              | doc "Enables you to modify, preserve, or remove the X-Forwarded-For header in the HTTP request before the Application Load Balancer sends the request to the target. The possible values are append, preserve, and remove. The default is append."
              | optional,
            wafFailOpen
              | Bool
              | doc "Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. The possible values are true and false. The default is false."
              | optional,
          },
      "_js2n__-:definitions/IAlbListenerConfig!contract"
        | doc "Application Load Balancer listener config. Currently only action type of `forward`,  `redirect` and `fixed-response` is allowed."
        = {
            certificate
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Applies to HTTPS listeners. The default certificate for the listener. You must provide exactly one certificate arn or a certificate name which was created by LZA"
              | optional,
            fixedResponseConfig
              | _js2n__-refsenv."_js2n__-:definitions/IAlbListenerFixedResponseConfig!contract"
              | doc "Information for creating an action that returns a custom HTTP response. Specify only when type is `fixed-response`."
              | optional,
            forwardConfig
              | _js2n__-refsenv."_js2n__-:definitions/IAlbListenerForwardConfig!contract"
              | doc "Information for creating an action that distributes requests to targetGroup. Stickiness for targetGroup can be set here."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the application load balancer listener",
            order
              | Number
              | doc "The order for the action. This value is required for rules with multiple actions. The action with the lowest value for order is performed first"
              | optional,
            port
              | Number
              | doc "Port of the application load balancer listener",
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/AlbListenerProtocolEnum!contract"
              | doc "Protocol of the application load balancer listener. The supported protocols are HTTP and HTTPS",
            redirectConfig
              | _js2n__-refsenv."_js2n__-:definitions/IAlbListenerRedirectConfig!contract"
              | doc "Information for creating a redirect action. Specify only when type is `redirect`."
              | optional,
            sslPolicy
              | _js2n__-refsenv."_js2n__-:definitions/SslPolicyAlbEnum!contract"
              | doc "The security policy that defines which protocols and ciphers are supported."
              | optional,
            targetGroup
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Target Group name to which traffic will be forwarded to. This name should be same as  {@link  ApplicationLoadBalancerTargetGroupConfig targetGroup }  name.",
            type
              | _js2n__-refsenv."_js2n__-:definitions/AlbListenerTypeEnum!contract"
              | doc "Type of the application load balancer listener",
          },
      "_js2n__-:definitions/IAlbListenerFixedResponseConfig!contract"
        | doc m%"
          Application load balancer listener fixed response config
          It returns a custom HTTP response.
          Applicable only when `type` under {@link ApplicationLoadBalancerListenerConfig listener} is `fixed-response`.
        "%
        = {
            contentType
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The message to send back."
              | optional,
            messageBody
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The HTTP response code (2XX, 4XX, or 5XX)."
              | optional,
            statusCode
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The content type. Valid Values: text/plain | text/css | text/html | application/javascript | application/json",
          },
      "_js2n__-:definitions/IAlbListenerForwardConfig!contract"
        | doc m%"
          Application Load balancer listener forward config. Used to define forward action.
          Applicable only when `type` under {@link ApplicationLoadBalancerListenerConfig listener} is `forward`.
        "%
        = {
            targetGroupStickinessConfig
              | _js2n__-refsenv."_js2n__-:definitions/IAlbListenerTargetGroupStickinessConfig!contract"
              | optional,
          },
      "_js2n__-:definitions/IAlbListenerRedirectConfig!contract"
        | doc m%"
          Application Load balancer listener redirect config. Used to define redirect action.
          Applicable only when `type` under {@link ApplicationLoadBalancerListenerConfig listener} is `redirect`.
        "%
        = {
            host
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
            path
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
            port | Number | optional,
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
            query
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
            statusCode
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
          },
      "_js2n__-:definitions/IAlbListenerTargetGroupStickinessConfig!contract"
        | doc m%"
          Application Load balancer listener forward config target group stickiness config
          Applicable only when `type` under {@link ApplicationLoadBalancerListenerConfig listener} is `forward`.
        "%
        = {
            durationSeconds
              | Number
              | doc "The time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days)."
              | optional,
            enabled
              | Bool
              | doc "Indicates whether target group stickiness is enabled."
              | optional,
          },
      "_js2n__-:definitions/IAppConfigItem!contract"
        | doc m%"
          Application configuration.
          Used to define two tier application configurations for the accelerator.
        "%
        = {
            applicationLoadBalancer
              | _js2n__-refsenv."_js2n__-:definitions/IApplicationLoadBalancerConfig!contract"
              | doc "Application Load Balancer for the application"
              | optional,
            autoscaling
              | _js2n__-refsenv."_js2n__-:definitions/IAutoScalingConfig!contract"
              | doc "AutoScalingGroup for the application"
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "The location where the application will be deployed.",
            launchTemplate
              | _js2n__-refsenv."_js2n__-:definitions/ILaunchTemplateConfig!contract"
              | doc "Launch Template for the application"
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the application. This should be unique per application.",
            networkLoadBalancer
              | _js2n__-refsenv."_js2n__-:definitions/INetworkLoadBalancerConfig!contract"
              | doc "Network Load Balancer for the application"
              | optional,
            targetGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITargetGroupItem!contract"
              | doc "Target groups for the application"
              | optional,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "VPC where the application will be deployed. The value should be a reference to the vpc in the network config under `vpcs:`.",
          },
      "_js2n__-:definitions/IApplicationLoadBalancerConfig!contract"
        | doc "Used to define Application Load Balancer configurations for the accelerator."
        = {
            attributes
              | _js2n__-refsenv."_js2n__-:definitions/IAlbAttributesConfig!contract"
              | doc "Attributes for Application Load Balancer."
              | optional,
            listeners
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IAlbListenerConfig!contract"
              | doc "Listeners for Application Load Balancer."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the application load balancer",
            scheme
              | _js2n__-refsenv."_js2n__-:definitions/AlbSchemeEnum!contract"
              | doc "Internal or internet facing scheme for Application Load Balancer."
              | optional,
            securityGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Security Groups to attach to the Application Load Balancer.",
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc m%"
                The location where the Application Load Balancer(s) will be deployed to.
                *
              "%
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Subnets to launch the Application Load Balancer in.",
          },
      "_js2n__-:definitions/IAutoScalingConfig!contract"
        | doc "Autoscaling group configuration for the application."
        = {
            desiredSize
              | Number
              | doc "The desired capacity is the initial capacity of the Auto Scaling group at the time of its creation and the capacity it attempts to maintain. It can scale beyond this capacity if you configure auto scaling. This number must be greater than or equal to the minimum size of the group and less than or equal to the maximum size of the group.",
            healthCheckGracePeriod
              | Number
              | doc "The amount of time, in seconds, that Amazon EC2 Auto Scaling waits before checking the health status of an EC2 instance that has come into service and marking it unhealthy due to a failed Elastic Load Balancing or custom health check. This is useful if your instances do not immediately pass these health checks after they enter the `InService` state. Defaults to 0 if unspecified."
              | optional,
            healthCheckType
              | _js2n__-refsenv."_js2n__-:definitions/AutoScalingHealthCheckTypeEnum!contract"
              | doc "The service to use for the health checks. The valid values are EC2 (default) and ELB. If you configure an Auto Scaling group to use load balancer (ELB) health checks, it considers the instance unhealthy if it fails either the EC2 status checks or the load balancer health checks."
              | optional,
            launchTemplate
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Information used to specify the launch template and version to use to launch instances.",
            maxInstanceLifetime
              | Number
              | doc "The maximum instance lifetime specifies the maximum amount of time (in seconds) that an instance can be in service before it is terminated and replaced. A common use case might be a requirement to replace your instances on a schedule because of internal security policies or external compliance controls. You must specify a value of at least 86,400 seconds (one day). To clear a previously set value, specify a new value of 0. This setting applies to all current and future instances in your Auto Scaling group"
              | optional,
            maxSize | Number | doc "The maximum size of the group.",
            minSize | Number | doc "The minimum size of the group.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The name of the Auto Scaling group. This name must be unique per Region per account. The name can contain any ASCII character 33 to 126 including most punctuation characters, digits, and upper and lowercased letters.
                *Note* You cannot use a colon (:) in the name.
              "%,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "List of subnet names for a virtual private cloud (VPC) where instances in the Auto Scaling group can be created. These subnets should  be created under the VPC in network-config.yaml.",
            targetGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Target group name array to associate with the Auto Scaling group. These names are from the  {@link  TargetGroupItemConfig target group }  set in the application. Instances are registered as targets with the target groups. The target groups receive incoming traffic and route requests to one or more registered targets."
              | optional,
          },
      "_js2n__-:definitions/IBlockDeviceMappingItem!contract"
        | doc "The parameters for a block device mapping in launch template."
        = {
            deviceName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The device name (for example, /dev/sdh or xvdh).",
            ebs
              | _js2n__-refsenv."_js2n__-:definitions/IEbsItem!contract"
              | doc "Parameters used to automatically set up EBS volumes when the instance is launched."
              | optional,
          },
      "_js2n__-:definitions/ICfnParameter!contract" =
        { name | String, value | String, },
      "_js2n__-:definitions/ICloudFormationStack!contract"
        | doc "Defines a custom CloudFormation Stack to be deployed to the environment."
        = {
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "CloudFormation Stack deployment targets",
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The description is to used to provide more information about the stack."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name that will be used as a base for the created CloudFormation Stack Name. The name should not contain any spaces as this isn't supported by the Accelerator.",
            parameters
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ICfnParameter!contract"
              | doc "The parameters to pass to the stack."
              | optional,
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "A list of AWS regions to deploy the stack to.",
            runOrder
              | Number
              | doc "The order to deploy the stack relative to the other stacks. Must be a positive integer. To deploy stacks in parallel, set runOrder of each stack to 1.",
            template
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The file path to the template file defining the stack.",
            terminationProtection
              | Bool
              | doc "This determines whether to enable termination protection for the stack.",
          },
      "_js2n__-:definitions/ICloudFormationStackSet!contract"
        | doc "Defines a custom CloudFormation StackSet to be deployed to the environment."
        = {
            capabilities
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
                              "CAPABILITY_IAM",
                              "CAPABILITY_NAMED_IAM",
                              "CAPABILITY_AUTO_EXPAND"
                            ]
                        ])
                  ])
              | doc "The CloudFormation capabilities enabled to deploy the stackset."
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "CloudFormation StackSet deployment targets",
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The description is to used to provide more information about the stackset."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name that will be used as a base for the created CloudFormation StackSet Name. The name should not contain any spaces as this isn't supported by the Accelerator.",
            parameters
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ICfnParameter!contract"
              | doc "The parameters to be passed to the stackset."
              | optional,
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "A list of regions to deploy the stackset.",
            template
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The file path to the template file used for deployment.",
          },
      "_js2n__-:definitions/ICustomizationConfig!contract"
        | doc m%"
          Defines CloudFormation Stacks and StackSets to be deployed to the environment.
          This feature supports the deployment of customer-provided CloudFormation templates to AWS
          accounts and/or organizational units. These deployments can leverage independent CloudFormation stacks
          or CloudFormation StackSets depending on the customer's deployment preference.
        "%
        = {
            cloudFormationStackSets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ICloudFormationStackSet!contract"
              | optional,
            cloudFormationStacks
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ICloudFormationStack!contract"
              | optional,
            serviceCatalogPortfolios
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IPortfolioConfig!contract"
              | optional,
          },
      "_js2n__-:definitions/ICustomizationsConfig!contract"
        | doc m%"
          Defines custom CloudFormation and external web and application tier resources. We recommend creating resources
          with native LZA features where possible.
        "%
        = {
            applications
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IAppConfigItem!contract"
              | optional,
            customizations
              | _js2n__-refsenv."_js2n__-:definitions/ICustomizationConfig!contract"
              | optional,
            firewalls
              | _js2n__-refsenv."_js2n__-:definitions/IEc2FirewallConfig!contract"
              | optional,
          },
      "_js2n__-:definitions/IDeploymentTargets!contract" =
        {
            accounts | Array (String) | optional,
            excludedAccounts | Array (String) | optional,
            excludedRegions | Array (String) | optional,
            organizationalUnits | Array (String) | optional,
          },
      "_js2n__-:definitions/IEbsItem!contract"
        | doc "The parameters for a block device for an EBS volume."
        = {
            deleteOnTermination
              | Bool
              | doc "Indicates whether the EBS volume is deleted on instance termination."
              | optional,
            encrypted
              | Bool
              | doc "Indicates whether the EBS volume is encrypted. Encrypted volumes can only be attached to instances that support Amazon EBS encryption. If you are creating a volume from a snapshot, you can't specify an encryption value. If encrypted is `true` and kmsKeyId is not provided, then accelerator checks for  {@link  EbsDefaultVolumeEncryptionConfig default ebs encryption }  in the config."
              | optional,
            iops
              | Number
              | doc "The number of I/O operations per second (IOPS). For gp3, io1, and io2 volumes, this represents the number of IOPS that are provisioned for the volume. For gp2 volumes, this represents the baseline performance of the volume and the rate at which the volume accumulates I/O credits for bursting. This parameter is supported for io1, io2, and gp3 volumes only. This parameter is not supported for gp2, st1, sc1, or standard volumes."
              | optional,
            kmsKeyId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The ARN of the symmetric AWS Key Management Service (AWS KMS) CMK used for encryption."
              | optional,
            snapshotId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The ID of the snapshot."
              | optional,
            throughput
              | Number
              | doc "The throughput to provision for a gp3 volume, with a maximum of 1,000 MiB/s. Valid Range: Minimum value of 125. Maximum value of 1000."
              | optional,
            volumeSize
              | Number
              | doc m%"
                The size of the volume, in GiBs. You must specify either a snapshot ID or a volume size. The following are the supported volumes sizes for each volume type:
                - gp2 and gp3: 1-16,384
                - io1 and io2: 4-16,384
                - st1 and sc1: 125-16,384
                - standard: 1-1,024
              "%
              | optional,
            volumeType
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The volume type. Valid Values: `standard | io1 | io2 | gp2 | sc1 | st1 | gp3`"
              | optional,
          },
      "_js2n__-:definitions/IEc2FirewallAutoScalingGroupConfig!contract"
        | doc m%"
          EC2 firewall autoscaling group configuration.
          Used to define EC2-based firewall instances to be deployed in an autoscaling group.
          
          ```
          - name: accelerator-firewall-asg
            autoscaling:
              name: firewall-asg
              maxSize: 4
              minSize: 1
              desiredSize: 2
              launchTemplate: firewall-lt
              healthCheckGracePeriod: 300
              healthCheckType: ELB
              targetGroups:
                - firewall-gwlb-tg
              subnets:
                - firewall-subnet-a
                - firewall-subnet-b
              maxInstanceLifetime: 86400
            launchTemplate:
              name: firewall-lt
              blockDeviceMappings:
                - deviceName: /dev/xvda
                  ebs:
                    deleteOnTermination: true
                    encrypted: true
                    volumeSize: 20
              enforceImdsv2: true
              iamInstanceProfile: firewall-profile
              imageId: ami-123xyz
              instanceType: c6i.xlarge
              networkInterfaces:
                - deleteOnTermination: true
                  description: Primary interface
                  deviceIndex: 0
                  groups:
                    - firewall-data-sg
                - deleteOnTermination: true
                  description: Management interface
                  deviceIndex: 1
                  groups:
                    - firewall-mgmt-sg
              userData: path/to/userdata.txt
            vpc: Network-Inspection
            tags: []
          ```
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The logical name of the account to deploy the firewall autoscaling group to"
              | optional,
            autoscaling
              | _js2n__-refsenv."_js2n__-:definitions/IAutoScalingConfig!contract"
              | doc "An AutoScaling Group configuration",
            configDir
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) Specify a relative S3 directory path to pull a firewall configuration directory.
                
                Either configFile or configDir can be set but not both.
                
                For example, if your S3 folder path is `s3://path/to/config`, specify `path/to/config` for this property.
                
                **NOTE:** The custom resource backing this feature does not force update on every core pipeline run. To update the resource, update the name of the configuration directory.
              "%
              | optional,
            configFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) Specify a relative S3 object path to pull a firewall configuration file from.
                
                For example, if your S3 object path is `s3://path/to/config.txt`, specify `path/to/config.txt` for this property.
                
                **NOTE:** The custom resource backing this feature does not force update on every core pipeline run. To update the resource, update the name of the configuration file.
              "%
              | optional,
            launchTemplate
              | _js2n__-refsenv."_js2n__-:definitions/ILaunchTemplateConfig!contract"
              | doc "The launch template for the firewall instance",
            licenseFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) Specify a relative S3 object path to pull a firewall license file from.
                
                For example, if your S3 object path is `s3://path/to/license.lic`, specify `path/to/license.lic` for this property.
                
                **NOTE:** The custom resource backing this feature does not force update on every core pipeline run. To update the resource, update the name of the license file.
              "%
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the firewall instance",
            staticReplacements
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IFirewallStaticReplacementsConfig!contract"
              | doc "(OPTIONAL) Static firewall configuration replacements definition."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags"
              | optional,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the VPC to deploy the firewall instance to",
          },
      "_js2n__-:definitions/IEc2FirewallConfig!contract"
        | doc m%"
          EC2 firewall configuration.
          Used to define EC2-based firewall and management appliances
        "%
        = {
            autoscalingGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IEc2FirewallAutoScalingGroupConfig!contract"
              | doc "Define EC2-based firewall instances in autoscaling groups"
              | optional,
            instances
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IEc2FirewallInstanceConfig!contract"
              | doc "Define EC2-based firewall standalone instances"
              | optional,
            managerInstances
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IEc2FirewallInstanceConfig!contract"
              | doc "Define EC2-based firewall management instances"
              | optional,
            targetGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITargetGroupItem!contract"
              | doc "Define target groups for EC2-based firewalls"
              | optional,
          },
      "_js2n__-:definitions/IEc2FirewallInstanceConfig!contract"
        | doc m%"
          EC2 firewall instance configuration.
          Use to define an array of standalone firewall instances
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The logical name of the account to deploy the firewall instance to"
              | optional,
            configDir
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) Specify a relative S3 directory path to pull a firewall configuration directory.
                
                Either configFile or configDir can be set but not both.
                
                For example, if your S3 folder path is `s3://path/to/config`, specify `path/to/config` for this property.
                
                **NOTE:** The custom resource backing this feature does not force update on every core pipeline run. To update the resource, update the name of the configuration directory.
              "%
              | optional,
            configFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) Specify a relative S3 object path to pull a firewall configuration file from.
                
                For example, if your S3 object path is `s3://path/to/config.txt`, specify `path/to/config.txt` for this property.
                
                **NOTE:** The custom resource backing this feature does not force update on every core pipeline run. To update the resource, update the name of the configuration file.
              "%
              | optional,
            detailedMonitoring
              | Bool
              | doc "(OPTIONAL) Specify true to enable detailed monitoring. Otherwise, basic monitoring is enabled."
              | optional,
            launchTemplate
              | _js2n__-refsenv."_js2n__-:definitions/ILaunchTemplateConfig!contract"
              | doc "The launch template for the firewall instance",
            licenseFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) Specify a relative S3 object path to pull a firewall license file from.
                
                For example, if your S3 object path is `s3://path/to/license.lic`, specify `path/to/license.lic` for this property.
                
                **NOTE:** The custom resource backing this feature does not force update on every core pipeline run. To update the resource, update the name of the license file.
              "%
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the firewall instance",
            staticReplacements
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IFirewallStaticReplacementsConfig!contract"
              | doc "(OPTIONAL) Static firewall configuration replacements definition."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags"
              | optional,
            terminationProtection
              | Bool
              | doc m%"
                (OPTIONAL) If you set this parameter to true , you can't terminate the instance using the Amazon EC2 console, CLI, or API.
                
                More information: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingDisableAPITermination
              "%
              | optional,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the VPC to deploy the firewall instance to",
          },
      "_js2n__-:definitions/IFirewallStaticReplacementsConfig!contract"
        | doc "Firewall Static Replacements Config"
        = {
            key
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The key name for the static replacement",
            value
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The value of the static replacement",
          },
      "_js2n__-:definitions/ILaunchTemplateConfig!contract"
        | doc "Configure a launch template for the application."
        = {
            blockDeviceMappings
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IBlockDeviceMappingItem!contract"
              | optional,
            enforceImdsv2
              | Bool
              | doc "By default,  {@link  https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html IMDSv2 }   is enabled. Disable it by setting this to false."
              | optional,
            iamInstanceProfile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the instance profile created by accelerator in iam-config.yaml under roleSets"
              | optional,
            imageId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                Valid AMI ID or a reference to ssm parameter store to get AMI ID. If ssm parameter is referenced it should follow the pattern ${ACCEL_LOOKUP::ImageId:/path/to/ssm/parameter/for/ami}
                
                For example to get the latest x86_64 amazon linux 2 ami, the value would be `${ACCEL_LOOKUP::ImageId:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2}`
              "%,
            instanceType
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Valid instance type which can be launched in the target account and region.",
            keyPair
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the key pair. LZA does not create keypair. This should exist in the account/region or else deployment will fail."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
            networkInterfaces
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INetworkInterfaceItem!contract"
              | doc "One or more network interfaces. If you specify a network interface, you must specify any security groups and subnets as part of the network interface."
              | optional,
            securityGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "One or more security group names. These should be created under the VPC in network-config.yaml"
              | optional,
            userData
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Path to user data. The path is relative to the config repository and the content should be in regular text. It is encoded in base64 before passing in to Launch Template"
              | optional,
          },
      "_js2n__-:definitions/INetworkInterfaceItem!contract"
        | doc "The parameters for a network interface."
        = {
            associateCarrierIpAddress
              | Bool
              | doc "Associates a Carrier IP address with eth0 for a new network interface. Use this option when you launch an instance in a Wavelength Zone and want to associate a Carrier IP address with the network interface."
              | optional,
            associateElasticIp
              | Bool
              | doc "Associate an elastic IP with the interface"
              | optional,
            associatePublicIpAddress
              | Bool
              | doc "Associates a public IPv4 address with eth0 for a new network interface."
              | optional,
            deleteOnTermination
              | Bool
              | doc "Indicates whether the network interface is deleted when the instance is terminated."
              | optional,
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A description for the network interface."
              | optional,
            deviceIndex
              | Number
              | doc "The device index for the network interface attachment."
              | optional,
            groups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Security group names to associate with this network interface."
              | optional,
            interfaceType
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The type of network interface. To create an Elastic Fabric Adapter (EFA), specify efa. If you are not creating an EFA, specify interface or omit this parameter. Valid values: `interface | efa`"
              | optional,
            networkCardIndex
              | Number
              | doc "The index of the network card. Some instance types support multiple network cards. The primary network interface must be assigned to network card index 0. The default is network card index 0."
              | optional,
            networkInterfaceId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The ID of the network interface."
              | optional,
            privateIpAddress
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The primary private IPv4 address of the network interface."
              | optional,
            privateIpAddresses
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IPrivateIpAddressItem!contract"
              | doc "One or more private IPv4 addresses."
              | optional,
            secondaryPrivateIpAddressCount
              | Number
              | doc "The number of secondary private IPv4 addresses to assign to a network interface."
              | optional,
            sourceDestCheck
              | Bool
              | doc "If the value is true , source/destination checks are enabled; otherwise, they are disabled. The default value is true. You must disable source/destination checks if the instance runs services such as network address translation, routing, or firewalls."
              | optional,
            subnetId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Valid subnet name from network-config.yaml under the same vpc"
              | optional,
          },
      "_js2n__-:definitions/INetworkLoadBalancerConfig!contract"
        | doc "Network Load Balancer configuration."
        = {
            crossZoneLoadBalancing
              | Bool
              | doc "Cross Zone load balancing for Network Load Balancer."
              | optional,
            deletionProtection
              | Bool
              | doc "Deletion protection for Network Load Balancer."
              | optional,
            listeners
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INlbListenerConfig!contract"
              | doc "Listeners for Network Load Balancer."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name for Network Load Balancer.",
            scheme
              | _js2n__-refsenv."_js2n__-:definitions/LoadBalancerSchemeEnum!contract"
              | doc "Load Balancer scheme. If undefined, the default of  {@link  https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateLoadBalancer.html ELBv2 CreateLoadBalancer API }  is used."
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Subnets to launch the Network Load Balancer in.",
          },
      "_js2n__-:definitions/INlbListenerConfig!contract"
        | doc "Application Load Balancer listener config. Currently only action type of `forward`,  `redirect` and `fixed-response` is allowed."
        = {
            alpnPolicy
              | _js2n__-refsenv."_js2n__-:definitions/AlpnPolicyEnum!contract"
              | doc "Application-Layer Protocol Negotiation (ALPN) policy} for TLS encrypted traffic"
              | optional,
            certificate
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "ACM ARN of the certificate to be associated with the listener."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name for Listener.",
            port
              | Number
              | doc "Port where the traffic is directed to."
              | optional,
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/NlbProtocolEnum!contract"
              | doc "Protocol used for the traffic. The supported protocols are TCP, TLS, UDP, or TCP_UDP."
              | optional,
            sslPolicy
              | _js2n__-refsenv."_js2n__-:definitions/SslPolicyNlbEnum!contract"
              | doc "SSL policy for TLS encrypted traffic"
              | optional,
            targetGroup
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Target Group to direct the traffic to.",
          },
      "_js2n__-:definitions/INlbTargetType!predicate"
        | doc "The codes to use when checking for a successful response from a target. If the protocol version is gRPC, these are gRPC codes. Otherwise, these are HTTP codes."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "account", "nlbName", "region" ],
              _js2n__-prdslib.records.record
                {
                  account =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                  nlbName =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IPortfolioAssociatoinConfig!contract"
        | doc "Portfolio Associations configuration"
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Indicates the name of the principal to associate the portfolio with.",
            propagateAssociation
              | Bool
              | doc "Indicates whether the principal association should be created in accounts the portfolio is shared with. Verify the IAM principal exists in all accounts the portfolio is shared with before enabling."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/PortfolioAssociationType!contract"
              | doc "Indicates the type of portfolio association, valid values are: Group, User, and Role.",
          },
      "_js2n__-:definitions/IPortfolioConfig!contract"
        | doc "Service Catalog Portfolios configuration"
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the account to deploy the portfolio.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the portfolio",
            portfolioAssociations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IPortfolioAssociatoinConfig!contract"
              | doc "Configuration of portfolio associations to give access to IAM principals."
              | optional,
            products
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IProductConfig!contract"
              | doc "Product Configuration"
              | optional,
            provider
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The provider of the portfolio",
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The region names to deploy the portfolio.",
            shareTagOptions
              | Bool
              | doc "Whether or not to share TagOptions with other account(s)/OU(s)"
              | optional,
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "Portfolio share target. Sharing portfolios to Organizational Units is only supported for portfolios in the Management account."
              | optional,
            tagOptions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITagOptionsConfig!contract"
              | doc "Portfolio TagOptions configuration"
              | optional,
          },
      "_js2n__-:definitions/IPrivateIpAddressItem!contract"
        | doc "Configure a secondary private IPv4 address for a network interface."
        = {
            primary
              | Bool
              | doc "Indicates whether the private IPv4 address is the primary private IPv4 address. Only one IPv4 address can be designated as primary."
              | optional,
            privateIpAddress
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The private IPv4 address."
              | optional,
          },
      "_js2n__-:definitions/IProductConfig!contract"
        | doc "Service Catalog Products configuration"
        = {
            constraints
              | _js2n__-refsenv."_js2n__-:definitions/IProductConstraintConfig!contract"
              | doc "Product Constraint configuration"
              | optional,
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Product description"
              | optional,
            distributor
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the product's publisher."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the product",
            owner
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The owner of the product",
            support
              | _js2n__-refsenv."_js2n__-:definitions/IProductSupportConfig!contract"
              | doc "Product support details."
              | optional,
            tagOptions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITagOptionsConfig!contract"
              | doc "Product TagOptions configuration"
              | optional,
            versions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IProductVersionConfig!contract"
              | doc "Product version configuration",
          },
      "_js2n__-:definitions/IProductConstraintConfig!contract"
        | doc "Service Catalog Product Constraint configuration. For more information see https://docs.aws.amazon.com/servicecatalog/latest/adminguide/constraints.html"
        = {
            launch
              | _js2n__-refsenv."_js2n__-:definitions/IProductLaunchConstraintConfig!contract"
              | doc "Launch constraint role name and type, supports LocalRole or Role."
              | optional,
            notifications
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A list of SNS topic names to stream product notifications to"
              | optional,
            tagUpdate
              | Bool
              | doc "Determines if Service Catalog Tag Update constraint is enabled"
              | optional,
          },
      "_js2n__-:definitions/IProductLaunchConstraintConfig!contract"
        | doc "Service Catalog Product Constraint configuration. For more information see https://docs.aws.amazon.com/servicecatalog/latest/adminguide/constraints.html"
        = {
            role
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the IAM Role.",
            type
              | _js2n__-refsenv."_js2n__-:definitions/ProductLaunchConstraintType!contract"
              | doc "The type of launch constraint, either Role or LocalRole. For more information, see https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-servicecatalog-launchroleconstraint.html",
          },
      "_js2n__-:definitions/IProductSupportConfig!contract"
        | doc "Product Support configuration"
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Support description of how users should use email contact and support link."
              | optional,
            email
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The email address to report issues with the product"
              | optional,
            url
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The url to the site where users can find support information or file tickets."
              | optional,
          },
      "_js2n__-:definitions/IProductVersionConfig!contract"
        | doc "Product Versions configuration"
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The version description"
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the version of the product",
            template
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The product template.",
          },
      "_js2n__-:definitions/IShareTargets!contract" =
        {
            accounts | Array (String) | optional,
            organizationalUnits | Array (String) | optional,
          },
      "_js2n__-:definitions/ITag!contract" = { key | String, value | String, },
      "_js2n__-:definitions/ITagOptionsConfig!contract"
        | doc "Service Catalog TagOptions configuration."
        = {
            key
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The tag key",
            values
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of values that can be used for the tag key",
          },
      "_js2n__-:definitions/ITargetGroupAttributeTypes!contract"
        | doc "Set attributes for target group."
        = {
            algorithm
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupAttributeAlgorithm!contract"
              | doc "The load balancing algorithm determines how the load balancer selects targets when routing requests. The value is round_robin or least_outstanding_requests. The default is round_robin. The following attribute is supported only if the load balancer is an Application Load Balancer and the target is an instance or an IP address."
              | optional,
            appCookieDuration
              | Number
              | doc "The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the application-based cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds). The following attribute is supported only if the load balancer is an Application Load Balancer and the target is an instance or an IP address."
              | optional,
            appCookieName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Indicates the name of the application-based cookie. Names that start with the following prefixes are not allowed: AWSALB, AWSALBAPP, and AWSALBTG; they're reserved for use by the load balancer. The following attribute is supported only if the load balancer is an Application Load Balancer and the target is an instance or an IP address."
              | optional,
            connectionTermination
              | Bool
              | doc "Indicates whether the load balancer terminates connections at the end of the deregistration timeout. The value is true or false. The default is false. The following attribute is supported only by Network Load Balancers."
              | optional,
            deregistrationDelay
              | Number
              | doc "The amount of time, in seconds, for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
              | optional,
            lbCookieDuration
              | Number
              | doc "The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). The default value is 1 day (86400 seconds). The following attribute is supported only if the load balancer is an Application Load Balancer and the target is an instance or an IP address."
              | optional,
            preserveClientIp
              | Bool
              | doc "Indicates whether client IP preservation is enabled. The value is true or false. The default is disabled if the target group type is IP address and the target group protocol is TCP or TLS. Otherwise, the default is enabled. Client IP preservation cannot be disabled for UDP and TCP_UDP target groups. The following attribute is supported only by Network Load Balancers."
              | optional,
            proxyProtocolV2
              | Bool
              | doc "Indicates whether Proxy Protocol version 2 is enabled. The value is true or false. The default is false. The following attribute is supported only by Network Load Balancers."
              | optional,
            slowStart
              | Number
              | doc "The time period, in seconds, during which a newly registered target receives an increasing share of the traffic to the target group. After this time period ends, the target receives its full share of traffic. The range is 30-900 seconds (15 minutes). The default is 0 seconds (disabled). The following attribute is supported only if the load balancer is an Application Load Balancer and the target is an instance or an IP address."
              | optional,
            stickiness
              | Bool
              | doc "Indicates whether target stickiness is enabled. The value is true or false. The default is false."
              | optional,
            stickinessType
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupAttributeStickinessType!contract"
              | doc "Indicates the type of stickiness. The possible values are:  - lb_cookie and app_cookie for Application Load Balancers.  - source_ip for Network Load Balancers.  - source_ip_dest_ip and source_ip_dest_ip_proto for Gateway Load Balancers"
              | optional,
            targetFailover
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupTargetFailoverType!contract"
              | doc "Indicates how the Gateway Load Balancer handles existing flows when a target is deregistered or becomes unhealthy. The possible values are rebalance and no_rebalance. The default is no_rebalance"
              | optional,
          },
      "_js2n__-:definitions/ITargetGroupHealthCheckType!contract"
        | doc "Configure health check for target group."
        = {
            interval
              | Number
              | doc "The approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300. If the target group protocol is TCP, TLS, UDP, TCP_UDP, HTTP or HTTPS, the default is 30 seconds. If the target group protocol is GENEVE, the default is 10 seconds."
              | optional,
            path
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "[HTTP/HTTPS health checks] The destination for health checks on the targets. [HTTP1 or HTTP2 protocol version] The ping path. The default is /. [GRPC protocol version] The path of a custom health check method with the format /package.service/method. The default is /AWS.ALB/healthcheck."
              | optional,
            port
              | Number
              | doc "The port the load balancer uses when performing health checks on targets. If the protocol is HTTP, HTTPS, TCP, TLS, UDP, or TCP_UDP, the default is `traffic-port`, which is the port on which each target receives traffic from the load balancer. If the protocol is GENEVE, the default is port 80."
              | optional,
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupHealthCheckProtocolType!contract"
              | doc "The protocol the load balancer uses when performing health checks on targets. For Application Load Balancers, the default is HTTP. For Network Load Balancers and Gateway Load Balancers, the default is TCP. The TCP protocol is not supported for health checks if the protocol of the target group is HTTP or HTTPS. GENEVE, TLS, UDP, and TCP_UDP protocols are not supported for health checks."
              | optional,
            timeout
              | Number
              | doc "The amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds. For target groups with a protocol of HTTP, the default is 6 seconds. For target groups with a protocol of TCP, TLS or HTTPS, the default is 10 seconds. For target groups with a protocol of GENEVE, the default is 5 seconds."
              | optional,
          },
      "_js2n__-:definitions/ITargetGroupItem!contract"
        | doc "Target Group Configuration"
        = {
            attributes
              | _js2n__-refsenv."_js2n__-:definitions/ITargetGroupAttributeTypes!contract"
              | doc "Target Group Attributes."
              | optional,
            healthCheck
              | _js2n__-refsenv."_js2n__-:definitions/ITargetGroupHealthCheckType!contract"
              | doc "Target Group HealthCheck."
              | optional,
            matcher
              | _js2n__-refsenv."_js2n__-:definitions/ITargetGroupMatcherType!contract"
              | doc "The HTTP or gRPC codes to use when checking for a successful response from a target. For target groups with a protocol of TCP, TCP_UDP, UDP or TLS the range is 200-599. For target groups with a protocol of HTTP or HTTPS, the range is 200-499."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the target group. This value is used in  {@link  ApplicationLoadBalancerListenerConfig Application Load Balancer listeners } ,  {@link  NetworkLoadBalancerListenerConfig Network Load Balancer listeners } , and  {@link  AutoScalingConfig Autoscaling config } .",
            port
              | Number
              | doc "The port on which the targets receive traffic.",
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupProtocolType!contract"
              | doc "Target group protocol version. Should be one of HTTP, HTTPS, GENEVE, TCP, UDP, TCP_UDP or TLS The protocol to use for routing traffic to the targets. For Application Load Balancers, the supported protocols are HTTP and HTTPS. For Network Load Balancers, the supported protocols are TCP, TLS, UDP, or TCP_UDP. A TCP_UDP listener must be associated with a TCP_UDP target group. For Gateway Load Balancers, the supported protocol is GENEVE.",
            protocolVersion
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupProtocolVersionType!contract"
              | doc "The protocol version. Should be one of 'GRPC', 'HTTP1', 'HTTP2'. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1."
              | optional,
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "The accounts/OUs location where the Target Group will be deployed to."
              | optional,
            targets
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/INlbTargetType!predicate"
                    ])
              )
              | doc "Target group targets. These targets should be the friendly names assigned to firewall instances."
              | optional,
            threshold
              | _js2n__-refsenv."_js2n__-:definitions/ITargetGroupThresholdType!contract"
              | doc "Target Group Threshold."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/TargetGroupType!contract"
              | doc m%"
                The type of target that you must specify when registering targets with this target group. You can't specify targets for a target group using more than one target type.
                - `instance` - Register targets by instance ID. This is the default value.
                - `ip` - Register targets by IP address. You can specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses. `alb` - Register a single Application Load Balancer as a target.
              "%,
          },
      "_js2n__-:definitions/ITargetGroupMatcherType!contract"
        | doc "Add the ability to target an NLB created by the Landing Zone Accelerator"
        = {
            grpcCode
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "You can specify values between 0 and 99. You can specify multiple values (for example, \"0,1\") or a range of values (for example, \"0-5\"). The default value is 12."
              | optional,
            httpCode
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "For Application Load Balancers, you can specify values between 200 and 499, with the default value being 200. You can specify multiple values (for example, \"200,202\") or a range of values (for example, \"200-299\"). For Network Load Balancers, you can specify values between 200 and 599, with the default value being 200-399. You can specify multiple values (for example, \"200,202\") or a range of values (for example, \"200-299\"). Note that when using shorthand syntax, some values such as commas need to be escaped."
              | optional,
          },
      "_js2n__-:definitions/ITargetGroupThresholdType!contract"
        | doc "Configure health check threshold for target group."
        = {
            healthy
              | Number
              | doc "The number of consecutive health check successes required before considering a target healthy. The range is 2-10. If the target group protocol is TCP, TCP_UDP, UDP, TLS, HTTP or HTTPS, the default is 5. For target groups with a protocol of GENEVE, the default is 3."
              | optional,
            unhealthy
              | Number
              | doc "The number of consecutive health check failures required before considering a target unhealthy. The range is 2-10. If the target group protocol is TCP, TCP_UDP, UDP, TLS, HTTP or HTTPS, the default is 2. For target groups with a protocol of GENEVE, the default is 3."
              | optional,
          },
      "_js2n__-:definitions/LoadBalancerSchemeEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'internal, 'internet-facing |] ],
      "_js2n__-:definitions/NlbProtocolEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'TCP_UDP, 'TLS, 'UDP, 'TCP |] ],
      "_js2n__-:definitions/NonEmptyString!contract"
        | doc "A string that has at least 1 character"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.minLength 1
              ]),
      "_js2n__-:definitions/NonEmptyString!predicate"
        | doc "A string that has at least 1 character"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/PortfolioAssociationType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'PermissionSet, 'Role, 'Group, 'User |]
            ],
      "_js2n__-:definitions/ProductLaunchConstraintType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'LocalRole, 'Role |] ],
      "_js2n__-:definitions/Region!contract"
        | doc "AWS Region"
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'us-west-2,
                'us-west-1,
                'us-iso-west-1,
                'us-isob-east-1,
                'us-iso-east-1,
                'us-gov-east-1,
                'us-gov-west-1,
                'us-east-2,
                'us-east-1,
                'sa-east-1,
                'me-south-1,
                'me-central-1,
                'il-central-1,
                'eu-west-3,
                'eu-west-2,
                'eu-west-1,
                'eu-south-2,
                'eu-south-1,
                'eu-north-1,
                'eu-central-2,
                'eu-central-1,
                'cn-northwest-1,
                'cn-north-1,
                'ca-west-1,
                'ca-central-1,
                'ap-southeast-4,
                'ap-southeast-3,
                'ap-southeast-2,
                'ap-southeast-1,
                'ap-south-2,
                'ap-south-1,
                'ap-northeast-3,
                'ap-northeast-2,
                'ap-northeast-1,
                'ap-east-1,
                'af-south-1
              |]
            ],
      "_js2n__-:definitions/RoutingHttpXffHeaderProcessingModeEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'remove, 'preserve, 'append |] ],
      "_js2n__-:definitions/SslPolicyAlbEnum!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'ELBSecurityPolicy-2016-08,
                'ELBSecurityPolicy-FS-1-2-Res-2020-10,
                'ELBSecurityPolicy-2015-05,
                'ELBSecurityPolicy-FS-1-2-Res-2019-08,
                'ELBSecurityPolicy-FS-1-2-2019-08,
                'ELBSecurityPolicy-FS-1-1-2019-08,
                'ELBSecurityPolicy-FS-2018-06,
                'ELBSecurityPolicy-TLS-1-2-Ext-2018-06,
                'ELBSecurityPolicy-TLS-1-2-2017-01,
                'ELBSecurityPolicy-TLS-1-1-2017-01,
                'ELBSecurityPolicy-TLS-1-0-2015-04
              |]
            ],
      "_js2n__-:definitions/SslPolicyNlbEnum!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'ELBSecurityPolicy-2016-08,
                'ELBSecurityPolicy-TLS13-1-3-2021-06,
                'ELBSecurityPolicy-TLS13-1-0-2021-06,
                'ELBSecurityPolicy-TLS13-1-1-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Ext2-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Ext1-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Res-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-2021-06,
                'ELBSecurityPolicy-FS-1-2-Res-2020-10,
                'ELBSecurityPolicy-2015-05,
                'ELBSecurityPolicy-FS-1-2-Res-2019-08,
                'ELBSecurityPolicy-FS-1-2-2019-08,
                'ELBSecurityPolicy-FS-1-1-2019-08,
                'ELBSecurityPolicy-FS-2018-06,
                'ELBSecurityPolicy-TLS-1-2-Ext-2018-06,
                'ELBSecurityPolicy-TLS-1-2-2017-01,
                'ELBSecurityPolicy-TLS-1-1-2017-01,
                'ELBSecurityPolicy-TLS-1-0-2015-04
              |]
            ],
      "_js2n__-:definitions/TargetGroupAttributeAlgorithm!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'least_outstanding_requests, 'round_robin |]
            ],
      "_js2n__-:definitions/TargetGroupAttributeStickinessType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'source_ip_dest_ip_proto,
                'source_ip_dest_ip,
                'source_ip,
                'app_cookie,
                'lb_cookie
              |]
            ],
      "_js2n__-:definitions/TargetGroupHealthCheckProtocolType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'TCP, 'HTTPS, 'HTTP |] ],
      "_js2n__-:definitions/TargetGroupProtocolType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'GENEVE, 'HTTPS, 'HTTP, 'TCP_UDP, 'UDP, 'TLS, 'TCP |]
            ],
      "_js2n__-:definitions/TargetGroupProtocolVersionType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'HTTP2, 'HTTP1, 'GRPC |] ],
      "_js2n__-:definitions/TargetGroupTargetFailoverType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'rebalance, 'no_rebalance |] ],
      "_js2n__-:definitions/TargetGroupType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'lambda, 'alb, 'ip, 'instance |] ],
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/ICustomizationsConfig!contract"