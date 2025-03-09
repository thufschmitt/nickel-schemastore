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
      "_js2n__-:definitions/AllowDeny!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'deny, 'allow |] ],
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
      "_js2n__-:definitions/CertificateConfigType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'request, '"import" |] ],
      "_js2n__-:definitions/CertificateValidationType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'DNS, 'EMAIL |] ],
      "_js2n__-:definitions/DnsFirewallBlockResponseType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'OVERRIDE, 'NXDOMAIN, 'NODATA |] ],
      "_js2n__-:definitions/DnsFirewallManagedDomainListsType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'AWSManagedDomainsMalwareDomainList,
                'AWSManagedDomainsBotnetCommandandControl,
                'AWSManagedDomainsAggregateThreatList
              |]
            ],
      "_js2n__-:definitions/DnsFirewallRuleActionType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'BLOCK, 'ALERT, 'ALLOW |] ],
      "_js2n__-:definitions/DpdTimeoutActionType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'restart, 'none, 'clear |] ],
      "_js2n__-:definitions/DxVirtualInterfaceType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'transit, 'private |] ],
      "_js2n__-:definitions/EnableDisable!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'disable, 'enable |] ],
      "_js2n__-:definitions/EncryptionAlgorithmType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'AES256-GCM-16, 'AES128-GCM-16, 'AES256, 'AES128 |]
            ],
      "_js2n__-:definitions/GatewayEndpointType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'dynamodb, 's3 |] ],
      "_js2n__-:definitions/GatewayRouteTableType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'virtualPrivateGateway, 'internetGateway |]
            ],
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
      "_js2n__-:definitions/ICentralNetworkServicesConfig!contract"
        | doc m%"
          Central network services configuration.
          Use this configuration to define centralized networking services for your environment.
          Central network services enables you to easily designate a central account that owns your
          core network infrastructure. These network resources can be shared with other
          accounts in your organization so that workload accounts can consume them.
        "%
        = {
            delegatedAdminAccount
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the delegated administrator account for network services. Resources configured under `centralNetworkServices` will be created in this account.",
            gatewayLoadBalancers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IGwlbConfig!contract"
              | doc "An array of Gateway Load Balancer configurations."
              | optional,
            ipams
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IIpamConfig!contract"
              | doc "An array of IPAM configurations."
              | optional,
            networkFirewall
              | _js2n__-refsenv."_js2n__-:definitions/INfwConfig!contract"
              | doc "A Network Firewall configuration."
              | optional,
            route53Resolver
              | _js2n__-refsenv."_js2n__-:definitions/IResolverConfig!contract"
              | doc "A Route 53 resolver configuration."
              | optional,
          },
      "_js2n__-:definitions/ICertificateConfig!contract"
        | doc m%"
          Amazon Certificate Manager (ACM) Configuration
          
          {@link https://docs.aws.amazon.com/acm/latest/userguide/import-certificate.html Import certificate}  or {@link https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html Request certificate} from ACM
        "%
        = {
            cert
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Path to certificate in S3 assets bucket. The bucket value is in the outputs of Pipeline stack in home region. Path should be given relative to the bucket. The certificate to import. This value should be provided when type is set to import or else validation fails."
              | optional,
            chain
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Path to the PEM encoded certificate chain in S3 assets bucket. The bucket value is in the outputs of Pipeline stack in home region. Path should be given relative to the bucket. This value is optional when type is set to import."
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "ACM deployment target. This should be provided to deploy ACM into OUs or account."
              | optional,
            domain
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Fully qualified domain name (FQDN), such as www.example.com, that you want to secure with an ACM certificate. Use an asterisk (*) to create a wildcard certificate that protects several sites in the same domain. For example, *.example.com protects www.example.com, site.example.com, and images.example.com. In compliance with RFC 5280, the length of the domain name (technically, the Common Name) that you provide cannot exceed 64 octets (characters), including periods. To add a longer domain name, specify it in the Subject Alternative Name field, which supports names up to 253 octets in length. This value should be provided when type is set to request or else validation fails."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the certificate. This should be unique in the certificates array. Duplicate names will fail the validation.",
            privKey
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Path to the private key in S3 assets bucket. The bucket value is in the outputs of Pipeline stack in home region. Path should be given relative to the bucket. The private key that matches the public key in the certificate. This value should be provided when type is set to import or else validation fails."
              | optional,
            san
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Additional FQDNs to be included in the Subject Alternative Name extension of the ACM certificate. For example, add the name www.example.net to a certificate for which the DomainName field is www.example.com if users can reach your site by using either name."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/CertificateConfigType!contract"
              | doc "Type of ACM cert. Valid values are `import` or `request`",
            validation
              | _js2n__-refsenv."_js2n__-:definitions/CertificateValidationType!contract"
              | doc "The method you want to use if you are requesting a public certificate to validate that you own or control domain. You can validate with DNS or validate with email. Valid values are 'DNS' or 'EMAIL'. This value should be provided when type is set to request or else validation fails."
              | optional,
          },
      "_js2n__-:definitions/ICustomerGatewayConfig!contract"
        | doc m%"
          Use this configuration to define Customer Gateways and site-to-site VPN connections.
          A customer gateway device is a physical or software appliance that you own or manage in
          your on-premises network (on your side of a Site-to-Site VPN connection).
          A VPN connection refers to the connection between your VPC and your own on-premises network.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The logical name of the account to deploy the Customer Gateway to. This value should match the name of the account recorded in the accounts-config.yaml file.",
            asn | Number | doc "Define the ASN used for the Customer Gateway",
            ipAddress
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Defines the IP address of the Customer Gateway",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The name of the CGW.
                
                The value of this property will be utilized as the logical id for this resource. Any references to this object should specify this value.
              "%,
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The AWS region to provision the customer gateway in",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "Define tags for the Customer Gateway"
              | optional,
            vpnConnections
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpnConnectionConfig!contract"
              | doc "Define the optional VPN Connection configuration"
              | optional,
          },
      "_js2n__-:definitions/IDefaultVpcsConfig!contract"
        | doc "Use this configuration to delete default VPCs in your environment."
        = {
            delete | Bool | doc "Enable to delete default VPCs.",
            excludeAccounts
              | Array (String)
              | doc "(OPTIONAL) Include an array of friendly account names to exclude from default VPC deletion."
              | optional,
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) Include an array of AWS regions to exclude from default VPC deletion."
              | optional,
          },
      "_js2n__-:definitions/IDeploymentTargets!contract" =
        {
            accounts | Array (String) | optional,
            excludedAccounts | Array (String) | optional,
            excludedRegions | Array (String) | optional,
            organizationalUnits | Array (String) | optional,
          },
      "_js2n__-:definitions/IDhcpOptsConfig!contract"
        | doc m%"
          Use this configuration to define custom DHCP options sets for your VPCs.
          Custom DHCP option sets give you control over the DNS servers, domain names,
          or Network Time Protocol (NTP) servers used by the devices in your VPC.
          
          The following example creates a DHCP option set named `accelerator-dhcp-opts`
          in the `Network` account in the `us-east-1` region. The options set assigns
          a domain name of `example.com` to hosts in the VPC and configures the DNS
          server to `1.1.1.1`.
        "%
        = {
            accounts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of friendly account names to deploy the options set.",
            domainName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A domain name to assign to hosts using the options set."
              | optional,
            domainNameServers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of IP addresses for domain name servers."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the DHCP options set.",
            netbiosNameServers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL An array of IP addresses for NetBIOS servers."
              | optional,
            netbiosNodeType
              | _js2n__-refsenv."_js2n__-:definitions/NetbiosNodeType!contract"
              | doc "(OPTIONAL) The NetBIOS node type number."
              | optional,
            ntpServers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of IP addresses for NTP servers."
              | optional,
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "An array of regions to deploy the options set.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the options set."
              | optional,
          },
      "_js2n__-:definitions/IDnsFirewallRuleGroupConfig!contract"
        | doc m%"
          Use this configuration to define a group of rules for your DNS firewall.
          Rule groups contain one to many rules that can be associated with VPCs in your environment.
          These rules allow you to define the behavior of your DNS firewall.
          
          The following example creates a rule group that contains one rule entry.
          The rule blocks a list of custom domains contained in a file in the accelerator
          configuration repository. The rule group is shared to the entire organization.
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the DNS firewall rule group.",
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The regions to deploy the rule group to.",
            rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDnsFirewallRulesConfig!contract"
              | doc "An array of DNS firewall rule configurations.",
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "An array of tags for the rule group."
              | optional,
          },
      "_js2n__-:definitions/IDnsFirewallRulesConfig!contract"
        | doc m%"
          Use this configuration to define individual rules for your DNS firewall.
          This allows you to define the DNS firewall behavior for your VPCs.
        "%
        = {
            action
              | _js2n__-refsenv."_js2n__-:definitions/DnsFirewallRuleActionType!contract"
              | doc "An action for the DNS firewall rule to take on matching requests.",
            blockOverrideDomain
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Configure an override domain for BLOCK actions. This is a custom DNS record to send back in response to the query."
              | optional,
            blockOverrideTtl
              | Number
              | doc "(OPTIONAL) Configure a time-to-live (TTL) for the override domain. This is the recommended amount of time for the DNS resolver or web browser to cache the override record and use it in response to this query, if it is received again. By default, this is zero, and the record isn't cached."
              | optional,
            blockResponse
              | _js2n__-refsenv."_js2n__-:definitions/DnsFirewallBlockResponseType!contract"
              | doc "Configure a specific response type for BLOCK actions. Block response types are defined here:  {@link  https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-rule-actions.html }"
              | optional,
            customDomainList
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A file containing a custom domain list in TXT format."
              | optional,
            managedDomainList
              | _js2n__-refsenv."_js2n__-:definitions/DnsFirewallManagedDomainListsType!contract"
              | doc "Configure a rule that uses an AWS-managed domain list. AWS-managed domain lists are defined here:  {@link  https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resolver-dns-firewall-managed-domain-lists.html } ."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the DNS firewall rule.",
            "priority" | Number | doc "The priority of the DNS firewall rule.",
          },
      "_js2n__-:definitions/IDnsQueryLogsConfig!contract"
        | doc m%"
          Use this configuration to define a centralized query logging configuration that can
          be associated with VPCs in your environment.
          You can use this configuration to log queries that originate from your VPCs,
          queries to your inbound and outbound resolver endpoints,
          and queries that use Route 53 Resolver DNS firewall to allow, block, or monitor
          domain lists.
          
          The following example creates a query logging configuration that logs to both
          S3 and a CloudWatch Logs log group. It is shared with the entire organization.
        "%
        = {
            destinations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/LogDestinationType!contract"
              | doc "An array of destination services used to store the logs.",
            excludedRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the query logging config.",
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "Resource Access Manager (RAM) share targets."
              | optional,
          },
      "_js2n__-:definitions/IDxGatewayConfig!contract"
        | doc "A DXGW is a globally-available resource than can be used to connect your VPCs to your on-premise infrastructure."
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account to deploy the DX Gateway.",
            asn
              | Number
              | doc "A Border Gateway Protocol (BGP) Autonomous System Number (ASN).",
            gatewayName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the Direct Connect Gateway. This name will show as the name of the resource in the AWS console and API.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the DX Gateway. This name is used as a logical reference for the resource in the accelerator.",
            transitGatewayAssociations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDxTransitGatewayAssociationConfig!contract"
              | doc "(OPTIONAL) An array of transit gateway association configurations. Creates transit gateway attachments for this DX gateway."
              | optional,
            virtualInterfaces
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDxVirtualInterfaceConfig!contract"
              | doc "(OPTIONAL) An array of virtual interface configurations. Creates virtual interfaces on the DX gateway."
              | optional,
          },
      "_js2n__-:definitions/IDxTransitGatewayAssociationConfig!contract"
        | doc "Use this configuration to define transit gateway attachments for a DX gateway."
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account the transit gateway is deployed to.",
            allowedPrefixes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of CIDR prefixes that are allowed to advertise over this transit gateway association.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the transit gateway to associate.",
            routeTableAssociations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of TGW route table(s) to associate with this attachment."
              | optional,
            routeTablePropagations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of TGW route table(s) to propagate routes from this attachment."
              | optional,
          },
      "_js2n__-:definitions/IDxVirtualInterfaceConfig!contract"
        | doc m%"
          Use this configuration to create a virtual interface to a DX Gateway. Virtual interfaces
          enable access to your AWS services from your on-premises environment.
          
          The following example creates a transit VIF called Accelerator-VIF in the Network account
          on a DX connection with resource ID dxcon-example:
        "%
        = {
            addressFamily
              | _js2n__-refsenv."_js2n__-:definitions/IpVersionType!contract"
              | doc m%"
                (OPTIONAL) The address family to use for this virtual interface.
                
                Default - ipv4
              "%
              | optional,
            amazonAddress
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) The peer IP address to use for Amazon's side of the virtual interface.
                
                Default - randomly-generated by Amazon
              "%
              | optional,
            connectionId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The resource ID of the  {@link  https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html#overview-components DX connection }  the virtual interface will be created on",
            customerAddress
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) The peer IP address to use for customer's side of the virtual interface.
                
                Default - randomly-generated by Amazon
              "%
              | optional,
            customerAsn
              | Number
              | doc "A Border Gateway Protocol (BGP) Autonomous System Number (ASN) for the customer side of the connection.",
            enableSiteLink
              | Bool
              | doc m%"
                (OPTIONAL) Enable SiteLink for this virtual interface.
                
                Default - false
              "%
              | optional,
            interfaceName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the virtual interface. This name will show as the name of the resource in the AWS console and API.",
            jumboFrames
              | Bool
              | doc m%"
                (OPTIONAL) Enable jumbo frames for the virtual interface.
                
                Default - standard 1500 MTU frame size
              "%
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the virtual interface. This name is used as a logical reference for the resource in the accelerator.",
            ownerAccount
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the owning account of the DX connection.",
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The region of the virtual interface.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags to apply to the virtual interface."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/DxVirtualInterfaceType!contract"
              | doc "The type of the virtual interface",
            vlan
              | Number
              | doc "The virtual local area network (VLAN) tag to use for this virtual interface.",
          },
      "_js2n__-:definitions/IElbAccountIdsConfig!contract"
        | doc "An optional ELB root account ID"
        = {
            accountId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
            region
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
          },
      "_js2n__-:definitions/IEndpointPolicyConfig!contract"
        | doc m%"
          Use this configuration to define VPC endpoint policies for your VPC gateway and interface endpoints.
          The endpoint policy is a JSON policy document that controls which AWS principals can use the VPC
          endpoint to access the endpoint service.
          
          The following example defines an endpoint policy named `Default` and references a path
          where a JSON policy document is stored:
        "%
        = {
            document
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A file path for a JSON-formatted policy document.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the endpoint policy.",
          },
      "_js2n__-:definitions/IFirewallManagerNotificationChannelConfig!contract"
        | doc "An optional Firewall Manager Service Config"
        = {
            region
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Enables the FMS notification channel. Defaults to enabled.",
            snsTopic
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The SNS Topic Name to publish to.",
          },
      "_js2n__-:definitions/IFirewallManagerServiceConfig!contract"
        | doc "An optional Firewall Manager Service Config"
        = {
            delegatedAdminAccount
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly account name to deploy the FMS configuration",
            notificationChannels
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IFirewallManagerNotificationChannelConfig!contract"
              | doc "The FMS Notification Channel Configuration"
              | optional,
          },
      "_js2n__-:definitions/IGatewayEndpointConfig!contract"
        | doc m%"
          Use this configuration to define gateway endpoints for your VPC.
          A gateway endpoint targets specific IP routes in an Amazon VPC route table,
          in the form of a prefix-list, used for traffic destined to Amazon DynamoDB
          or Amazon Simple Storage Service (Amazon S3).
        "%
        = {
            defaultPolicy
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the default policy for the gateway endpoints.",
            endpoints
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IGatewayEndpointServiceConfig!contract"
              | doc "An array of endpoints to create.",
          },
      "_js2n__-:definitions/IGatewayEndpointServiceConfig!contract"
        | doc "Use this configuration to define the service and endpoint policy for gateway endpoints."
        = {
            applyPolicy
              | Bool
              | doc "(OPTIONAL) Specify whether or not a policy is applied to the endpoint. By default, if no policy is specified in the `policy` property, a default policy is applied. Specifying this option as `false` will ensure no policy is applied to the endpoint. This property defaults to `true` if not specified."
              | optional,
            policy
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of a policy for the gateway endpoint. If left undefined, the default policy will be used."
              | optional,
            service
              | _js2n__-refsenv."_js2n__-:definitions/GatewayEndpointType!contract"
              | doc "The name of the service to create the endpoint for",
            serviceName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The full name of the service to create the endpoint for."
              | optional,
          },
      "_js2n__-:definitions/IGwlbConfig!contract"
        | doc m%"
          Use to define Gateway Load Balancer configurations for the accelerator.
          Gateway Load Balancers enable you to deploy, scale, and manage virtual appliances,
          such as firewalls, intrusion detection and prevention systems, and deep packet inspection
          systems. It combines a transparent network gateway (that is, a single entry and exit point
          for all traffic) and distributes traffic while scaling your virtual appliances with the demand.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Set an override for the account the Gateway Load Balancer is deployed to."
              | optional,
            crossZoneLoadBalancing
              | Bool
              | doc "(OPTIONAL) Whether to enable cross-zone load balancing."
              | optional,
            deletionProtection
              | Bool
              | doc "(OPTIONAL) Whether to enable deletion protection."
              | optional,
            endpoints
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IGwlbEndpointConfig!contract"
              | doc "An array of Gateway Load Balancer endpoint configurations.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the Gateway Load Balancer.",
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of friendly names of subnets to deploy the Gateway Load Balancer to.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of CloudFormation tag objects."
              | optional,
            targetGroup
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of a target group to forward traffic to"
              | optional,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the VPC to deploy the Gateway Load Balancer to.",
          },
      "_js2n__-:definitions/IGwlbEndpointConfig!contract"
        | doc m%"
          Use this configuration to define endpoints for your Gateway Load Balancer.
          Gateway Load Balancers use Gateway Load Balancer endpoints to securely exchange
          traffic across VPC boundaries. A Gateway Load Balancer endpoint is a VPC endpoint
          that provides private connectivity between virtual appliances in the service provider
          VPC and application servers in the service consumer VPC.
          
          The following example creates two Gateway Load Balancer endpoints,
          `Endpoint-A` and `Endpoint-B`. The endpoints are created in subnets named
          `Network-Inspection-A` and `Network-Inspection-B`, respectively, in the VPC named
          `Network-Inspection`.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account to deploy the endpoint to.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the Gateway Load Balancer endpoint.",
            subnet
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the subnet to deploy the Gateway Load Balancer endpoint to.",
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the VPC to deploy the Gateway Load Balancer endpoint to.",
          },
      "_js2n__-:definitions/IInterfaceEndpointConfig!contract"
        | doc m%"
          Use this configuration to define interface endpoints for your VPC.
          Interface endpoints powered by AWS PrivateLink to connect your VPC to AWS services as if they were in your VPC, without the use of an internet gateway.
        "%
        = {
            allowedCidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of source CIDRs allowed to communicate with the endpoints."
              | optional,
            central
              | Bool
              | doc "(OPTIONAL) Enable to define interface endpoints as centralized endpoints."
              | optional,
            defaultPolicy
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the default policy for the interface endpoints.",
            endpoints
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IInterfaceEndpointServiceConfig!contract"
              | doc "An array of VPC interface endpoint services to be deployed.",
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of the friendly names of VPC subnets for the endpoints to be deployed.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the private hosted zones associated with the VPC Interface endpoints."
              | optional,
          },
      "_js2n__-:definitions/IInterfaceEndpointServiceConfig!contract"
        | doc "Use this configuration to define the service and endpoint policy for gateway endpoints."
        = {
            applyPolicy
              | Bool
              | doc "(OPTIONAL) Specify whether or not a policy is applied to the endpoint. By default, if no policy is specified in the `policy` property, a default policy is applied. Specifying this option as `false` will ensure no policy is applied to the endpoint. This property defaults to `true` if not specified."
              | optional,
            policy
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of a policy for the interface endpoint. If left undefined, the default policy will be used."
              | optional,
            securityGroup
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Apply the provided security group for this interface endpoint."
              | optional,
            service
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the service to create the endpoint for.",
            serviceName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The full name of the service to create the endpoint for."
              | optional,
          },
      "_js2n__-:definitions/IIpamAllocationConfig!contract"
        | doc "Use this configuration to dynamically assign a VPC or subnet CIDR from an IPAM pool."
        = {
            ipamPoolName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The IPAM pool name to request the allocation from.",
            netmaskLength | Number | doc "The subnet mask length to request.",
          },
      "_js2n__-:definitions/IIpamConfig!contract"
        | doc m%"
          Use this configuration to define an AWS-managed VPC IPAM.
          IPAM is a feature that makes it easier for you to plan, track, and monitor IP addresses for your AWS workloads.
          
          The following example defines an IPAM that is capable of operating in the us-east-1 and us-west-2 regions:
        "%
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description for the IPAM."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the IPAM.",
            operatingRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) An array of regions that the IPAM will manage."
              | optional,
            pools
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IIpamPoolConfig!contract"
              | doc "An optional array of IPAM pool configurations to create under the IPAM."
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The region to deploy the IPAM.",
            scopes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IIpamScopeConfig!contract"
              | doc "(OPTIONAL) An array of IPAM scope configurations to create under the IPAM."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the IPAM."
              | optional,
          },
      "_js2n__-:definitions/IIpamPoolConfig!contract"
        | doc m%"
          Use this configuration to define custom IPAM pools for your VPCs. A pool is a collection of contiguous
          IP address ranges. IPAM pools enable you to organize your IP addresses according to your routing and security needs.
        "%
        = {
            addressFamily
              | _js2n__-refsenv."_js2n__-:definitions/IpVersionType!contract"
              | doc "The address family for the IPAM pool."
              | optional,
            allocationDefaultNetmaskLength
              | Number
              | doc "(OPTIONAL) The default netmask length of IPAM allocations for this pool."
              | optional,
            allocationMaxNetmaskLength
              | Number
              | doc "(OPTIONAL) The maximum netmask length of IPAM allocations for this pool."
              | optional,
            allocationMinNetmaskLength
              | Number
              | doc "(OPTIONAL) The minimum netmask length of IPAM allocations for this pool."
              | optional,
            allocationResourceTags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags that are required for resources that use CIDRs from this IPAM pool."
              | optional,
            autoImport
              | Bool
              | doc "(OPTIONAL) If set to `true`, IPAM will continuously look for resources within the CIDR range of this pool and automatically import them as allocations into your IPAM."
              | optional,
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description for the IPAM pool."
              | optional,
            locale
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) The AWS Region where you want to make an IPAM pool available for allocations."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the IPAM pool.",
            provisionedCidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of CIDR ranges to provision for the IPAM pool."
              | optional,
            publiclyAdvertisable
              | Bool
              | doc "(OPTIONAL) Determines if a pool is publicly advertisable."
              | optional,
            scope
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of the IPAM scope to assign the IPAM pool to."
              | optional,
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            sourceIpamPool
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of the source IPAM pool to create this IPAM pool from."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the IPAM pool."
              | optional,
          },
      "_js2n__-:definitions/IIpamScopeConfig!contract"
        | doc m%"
          Use this configuration to define custom private IPAM scopes for your VPCs.
          An IPAM scope is the highest-level container for an IPAM. Within scopes, pools can be created.
          Custom IPAM scopes can be used to create pools and manage resources that use the same IP space.
        "%
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Description for the IPAM scope."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the IPAM scope.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the IPAM scope."
              | optional,
          },
      "_js2n__-:definitions/ILifecycleRule!contract"
        | doc "S3 bucket life cycle rules object."
        = {
            abortIncompleteMultipartUpload
              | Number
              | doc "Specifies a lifecycle rule that aborts incomplete multipart uploads to an Amazon S3 bucket."
              | optional,
            enabled | Bool | doc "Whether this rule is enabled." | optional,
            expiration
              | Number
              | doc "Indicates the number of days after creation when objects are deleted from Amazon S3 and Amazon Glacier."
              | optional,
            expiredObjectDeleteMarker
              | Bool
              | doc "Indicates whether Amazon S3 will remove a delete marker with no noncurrent versions. If set to true, the delete marker will be expired."
              | optional,
            id
              | String
              | doc "Friendly name for the rule. Rule name must be unique."
              | optional,
            noncurrentVersionExpiration
              | Number
              | doc "Time between when a new version of the object is uploaded to the bucket and when old versions of the object expire."
              | optional,
            noncurrentVersionTransitions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransition!contract"
              | doc "One or more transition rules that specify when non-current objects transition to a specified storage class."
              | optional,
            prefix
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Object key prefix that identifies one or more objects to which this rule applies."
              | optional,
            transitions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransition!contract"
              | doc "One or more transition rules that specify when an object transitions to a specified storage class."
              | optional,
          },
      "_js2n__-:definitions/ILoadBalancersConfig!contract"
        | doc m%"
          Use this configuration to define Application Load Balancers (ALBs) or
          Network Load Balancers (NLBs) to be deployed in the specified VPC subnets.
        "%
        = {
            applicationLoadBalancers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IApplicationLoadBalancerConfig!contract"
              | doc "(OPTIONAL) An array of Application Load Balancer (ALB) configurations. Use this property to define ALBs to be deployed in the specified VPC subnets."
              | optional,
            networkLoadBalancers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INetworkLoadBalancerConfig!contract"
              | doc "(OPTIONAL) An array of Network Load Balancer (NLB) configurations. Use this property to define NLBs to be deployed in the specified VPC subnets."
              | optional,
          },
      "_js2n__-:definitions/ILocalGatewayConfig!contract"
        | doc m%"
          Use this configuration to reference existing local gateways for your Outposts.
          The local gateway for your Outpost rack enables connectivity from your Outpost subnets to
          all AWS services that are available in the parent Region, in the same way that you access them from an Availability Zone subnet.
        "%
        = {
            id
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The id for the Local Gateway",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Local Gateway",
            routeTables
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ILocalGatewayRouteTableConfig!contract"
              | doc "The route tables for the Local Gateway",
          },
      "_js2n__-:definitions/ILocalGatewayRouteTableConfig!contract"
        | doc m%"
          Use this configuration to reference route tables for your Outposts local gateway.
          Outpost subnet route tables on a rack can include a route to your on-premises network.
          The local gateway routes this traffic for low latency routing to the on-premises network.
        "%
        = {
            id
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The id for the Route Table",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Route Table",
          },
      "_js2n__-:definitions/INatGatewayConfig!contract"
        | doc m%"
          Use this configuration to define AWS-managed NAT Gateways for your VPC.
          You can use a NAT gateway so that instances in a private subnet can connect to services outside your VPCs.
        "%
        = {
            allocationId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The allocation ID of the Elastic IP address that's associated with the NAT gateway. This allocation ID must exist in the target account the NAT gateway is deployed to."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the NAT Gateway.",
            private
              | Bool
              | doc "(OPTIONAL) Set `true` to define a NAT gateway with private connectivity type"
              | optional,
            subnet
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the subnet for the NAT Gateway to be deployed.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the NAT Gateway."
              | optional,
          },
      "_js2n__-:definitions/INetworkAclConfig!contract"
        | doc m%"
          Use this configuration to define custom network ACLs for your VPC.
          A network ACL allows or denies specific inbound or outbound traffic at the subnet level.
          Network ACLs are stateless, which means that responses to allowed inbound traffic are subject
          to the rules for outbound traffic (and vice versa).
          
          The following example shows an inbound and outbound rule that would allow
          inbound SSH traffic from the CIDR range 10.0.0.0/16.
        "%
        = {
            inboundRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INetworkAclInboundRuleConfig!contract"
              | doc "(OPTIONAL) A list of inbound rules to define for the Network ACL"
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the Network ACL.",
            outboundRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INetworkAclOutboundRuleConfig!contract"
              | doc "(OPTIONAL) A list of outbound rules to define for the Network ACL"
              | optional,
            subnetAssociations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A list of subnets to associate with the Network ACL",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) A list of tags to attach to the Network ACL"
              | optional,
          },
      "_js2n__-:definitions/INetworkAclInboundRuleConfig!contract"
        | doc m%"
          Use this configuration to define inbound rules for your network ACLs.
          An inbound rule allows or denies specific inbound traffic at the subnet level.
          
          The following example allows inbound SSH traffic from source CIDR 10.0.0.0/16:
        "%
        = {
            action
              | _js2n__-refsenv."_js2n__-:definitions/AllowDeny!contract"
              | doc "The action for the network ACL rule.",
            fromPort
              | Number
              | doc "The port to start from in the network ACL rule.",
            protocol
              | Number
              | doc "The  {@link  https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml IANA protocol number }  for the network ACL rule. You may also specify -1 for all protocols.",
            rule | Number | doc "The rule ID number for the rule.",
            source
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/INetworkAclSubnetSelection!predicate"
                  ])
              | doc "The source of the network ACL rule.",
            toPort
              | Number
              | doc "The port to end with in the network ACL rule.",
          },
      "_js2n__-:definitions/INetworkAclOutboundRuleConfig!contract"
        | doc m%"
          Use this configuration to define outbound rules for your network ACLs.
          An outbound rule allows or denies specific outbound traffic at the subnet level.
          
          The following example allows outbound TCP traffic in the ephemeral port ranges to destination CIDR 10.0.0.0/16:
        "%
        = {
            action
              | _js2n__-refsenv."_js2n__-:definitions/AllowDeny!contract"
              | doc "The action for the network ACL rule.",
            destination
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/INetworkAclSubnetSelection!predicate"
                  ])
              | doc "The destination of the network ACL rule.",
            fromPort
              | Number
              | doc "The port to start from in the network ACL rule.",
            protocol
              | Number
              | doc "The  {@link  https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml IANA protocol number }  for the network ACL rule. You may also specify -1 for all protocols.",
            rule | Number | doc "The rule ID number for the rule.",
            toPort
              | Number
              | doc "The port to end with in the network ACL rule.",
          },
      "_js2n__-:definitions/INetworkAclSubnetSelection!predicate"
        | doc m%"
          Network ACL subnet selection configuration.
          Use this configuration to dynamically reference a subnet as a source/destination for a network ACL.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "subnet", "vpc" ],
              _js2n__-prdslib.records.record
                {
                  account =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                  ipv6 = _js2n__-prdslib.isType '"Bool",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/Region!predicate",
                  subnet =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                  vpc =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/INetworkConfig!contract"
        | doc "Network Configuration. Used to define a network configuration for the accelerator."
        = {
            accountVpcEndpointIds
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                        ])
                  ])
              | doc m%"
                A map between account Id and all the VPC Endpoint IDs in the account.
                
                Currently, the dynamic values will only be loaded in FinalizeStack for SCP finalization. Only the account VPC Endpoints referred by ACCEL_LOOKUP in SCPs will be loaded.
              "%
              | optional,
            accountVpcIds
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                        ])
                  ])
              | doc m%"
                A map between account Id and all the VPC IDs in the account.
                
                Currently, the dynamic values will only be loaded in FinalizeStack for SCP finalization. Only the account VPCs referred in SCPs by ACCEL_LOOKUP will be loaded.
              "%
              | optional,
            centralNetworkServices
              | _js2n__-refsenv."_js2n__-:definitions/ICentralNetworkServicesConfig!contract"
              | doc "An optional Central Network services configuration."
              | optional,
            certificates
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ICertificateConfig!contract"
              | doc "Certificate manager configuration"
              | optional,
            customerGateways
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ICustomerGatewayConfig!contract"
              | doc "An array of Customer Gateway configurations."
              | optional,
            defaultVpc
              | _js2n__-refsenv."_js2n__-:definitions/IDefaultVpcsConfig!contract"
              | doc "A default VPC configuration.",
            dhcpOptions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDhcpOptsConfig!contract"
              | doc "An optional list of DHCP options set configurations."
              | optional,
            directConnectGateways
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDxGatewayConfig!contract"
              | doc "An optional array of Direct Connect Gateway configurations."
              | optional,
            elbAccountIds
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IElbAccountIdsConfig!contract"
              | doc "An optional ELB root account ID"
              | optional,
            endpointPolicies
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IEndpointPolicyConfig!contract"
              | doc "A list of VPC configurations. An array of VPC endpoint policies.",
            firewallManagerService
              | _js2n__-refsenv."_js2n__-:definitions/IFirewallManagerServiceConfig!contract"
              | doc "Firewall manager service configuration"
              | optional,
            homeRegion
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "Accelerator home region name."
              | optional,
            prefixLists
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IPrefixListConfig!contract"
              | doc "An optional list of prefix list set configurations."
              | optional,
            transitGatewayConnects
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayConnectConfig!contract"
              | doc "An array of Transit Gateway Connect configurations."
              | optional,
            transitGatewayPeering
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayPeeringConfig!contract"
              | doc "Transit Gateway peering configuration."
              | optional,
            transitGateways
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayConfig!contract"
              | doc "An array of Transit Gateway configurations.",
            vpcFlowLogs
              | _js2n__-refsenv."_js2n__-:definitions/IVpcFlowLogsConfig!contract"
              | doc "A VPC flow logs configuration."
              | optional,
            vpcPeering
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpcPeeringConfig!contract"
              | doc "An optional list of VPC peering configurations"
              | optional,
            vpcTemplates
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpcTemplatesConfig!contract"
              | doc "An optional list of VPC template configurations"
              | optional,
            vpcs
              | Array _js2n__-refsenv."_js2n__-:definitions/IVpcConfig!contract"
              | doc "An array of VPC configurations.",
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
      "_js2n__-:definitions/INfwConfig!contract"
        | doc m%"
          Use this configuration to define Network Firewalls in your environment.
          AWS Network Firewall is a stateful, managed, network firewall and intrusion
          detection and prevention service for your virtual private cloud (VPC) that
          you create in Amazon Virtual Private Cloud (Amazon VPC).
          With Network Firewall, you can filter traffic at the perimeter of your VPC.
          This includes filtering traffic going to and coming from an internet gateway,
          NAT gateway, or over VPN or AWS Direct Connect.
          
          The following example creates a simple Network Firewall rule group, policy,
          and firewall. The policy and rule group are shared with the entire organization.
          The firewall endpoints are created in subnets named `Subnet-A` and `Subnet-B`
          in the VPC named `Network-Inspection`.
        "%
        = {
            firewalls
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwFirewallConfig!contract"
              | doc "An array of Network Firewall firewall configurations.",
            policies
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwFirewallPolicyConfig!contract"
              | doc "An array of Network Firewall policy configurations.",
            rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleGroupConfig!contract"
              | doc "An array of Network Firewall rule group configurations.",
          },
      "_js2n__-:definitions/INfwFirewallConfig!contract"
        | doc m%"
          Use this configuration to define a Network Firewall firewall.
          An AWS Network Firewall firewall connects a firewall policy,
          which defines network traffic monitoring and filtering behavior,
          to the VPC that you want to protect. The firewall configuration
          includes specifications for the Availability Zones and subnets
          where the firewall endpoints are placed. It also defines high-level
          settings like the firewall logging configuration and tagging on the AWS firewall resource.
        "%
        = {
            deleteProtection
              | Bool
              | doc "(OPTIONAL) Enable for deletion protection on the firewall."
              | optional,
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description for the firewall."
              | optional,
            firewallPolicy
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the Network Firewall policy or ARN for an existing network firewall policy.",
            firewallPolicyChangeProtection
              | Bool
              | doc "(OPTIONAL) Enable to disallow firewall policy changes."
              | optional,
            loggingConfiguration
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwLoggingConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall logging configurations."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the firewall.",
            subnetChangeProtection
              | Bool
              | doc "(OPTIONAL) Enable to disallow firewall subnet changes."
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of the friendly names of subnets to deploy Network Firewall to.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the firewall."
              | optional,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the VPC to deploy Network Firewall to.",
          },
      "_js2n__-:definitions/INfwFirewallPolicyConfig!contract"
        | doc m%"
          Use this configuration to define a Network Firewall policy.
          An AWS Network Firewall firewall policy defines the monitoring and protection behavior
          for a firewall. The details of the behavior are defined in the rule groups that you add
          to your policy, and in some policy default settings.
        "%
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description for the policy."
              | optional,
            firewallPolicy
              | _js2n__-refsenv."_js2n__-:definitions/INfwFirewallPolicyPolicyConfig!contract"
              | doc "Use this property to define specific behaviors and rule groups to associate with the policy.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the policy.",
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The regions to deploy the policy to.",
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the policy."
              | optional,
          },
      "_js2n__-:definitions/INfwFirewallPolicyPolicyConfig!contract"
        | doc m%"
          Use this configuration to define how the Network Firewall policy will behave.
          An AWS Network Firewall firewall policy defines the monitoring and protection behavior
          for a firewall. The details of the behavior are defined in the rule groups that you add
          to your policy, and in some policy default settings.
        "%
        = {
            statefulDefaultActions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NfwStatefulDefaultActionType!contract"
              | doc "(OPTIONAL) An array of default actions to take on packets evaluated by the stateful engine."
              | optional,
            statefulEngineOptions
              | _js2n__-refsenv."_js2n__-:definitions/NfwStatefulRuleOptionsType!contract"
              | doc "(OPTIONAL) Define how the stateful engine will evaluate packets."
              | optional,
            statefulRuleGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwStatefulRuleGroupReferenceConfig!contract"
              | doc "{OPTIONAL) An array of Network Firewall stateful rule group reference configurations."
              | optional,
            statelessCustomActions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceCustomActionConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall custom action configurations."
              | optional,
            statelessDefaultActions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/NfwStatelessRuleActionType!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                    ])
              )
              | doc "An array of default actions to take on packets evaluated by the stateless engine.",
            statelessFragmentDefaultActions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/NfwStatelessRuleActionType!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                    ])
              )
              | doc "An array of default actions to take on fragmented packets.",
            statelessRuleGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwStatelessRuleGroupReferenceConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall stateless rule group reference configurations."
              | optional,
          },
      "_js2n__-:definitions/INfwLoggingConfig!contract"
        | doc m%"
          Use this configuration to define logging destinations for Network Firewall.
          You can configure AWS Network Firewall logging for your firewall's stateful engine.
          Logging gives you detailed information about network traffic, including the time that
          the stateful engine received a packet, detailed information about the packet, and any
          stateful rule action taken against the packet. The logs are published to the log destination
          that you've configured, where you can retrieve and view them.
        "%
        = {
            destination
              | _js2n__-refsenv."_js2n__-:definitions/LogDestinationType!contract"
              | doc "The destination service to log to.",
            type
              | _js2n__-refsenv."_js2n__-:definitions/NfwLogType!contract"
              | doc "The type of actions to log.",
          },
      "_js2n__-:definitions/INfwRuleGroupConfig!contract"
        | doc m%"
          Use this configuration to define stateful and stateless rule groups for Network Firewall.
          An AWS Network Firewall rule group is a reusable set of criteria for inspecting and handling network traffic.
          You add one or more rule groups to a firewall policy as part of policy configuration.
        "%
        = {
            capacity | Number | doc "The capacity of the rule group.",
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description for the rule group."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the rule group.",
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The regions to deploy the rule group to.",
            ruleGroup
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleGroupRuleConfig!contract"
              | doc "(OPTIONAL) A Network Firewall rule configuration."
              | optional,
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the rule group."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/NfwRuleType!contract"
              | doc "The type of rules in the rule group.",
          },
      "_js2n__-:definitions/INfwRuleGroupRuleConfig!contract"
        | doc m%"
          Network Firewall rule group rule configuration.
          Used to define rules for a Network Firewall rule group.
        "%
        = {
            ruleVariables
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleVariableConfig!contract"
              | doc "A Network Firewall rule variable configuration."
              | optional,
            rulesSource
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceConfig!contract"
              | doc "A Network Firewall rule source configuration.",
            statefulRuleOptions
              | _js2n__-refsenv."_js2n__-:definitions/NfwStatefulRuleOptionsType!contract"
              | doc "A stateful rule option for the rule group."
              | optional,
          },
      "_js2n__-:definitions/INfwRuleSourceConfig!contract"
        | doc m%"
          Network Firewall rule source configuration.
          Use this configuration to define stateful and/or stateless rules for your Network Firewall.
          The following rules sources are supported:
          - File with list of Suricata-compatible rules
          - Domain list
          - Single Suricata-compatible rule
          - Stateful rule in IP header format
          - Stateless rules and custom actions
        "%
        = {
            rulesFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Suricata rules file. Use this property to define a Suricata-compatible rules file for Network Firewall."
              | optional,
            rulesSourceList
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceListConfig!contract"
              | doc "(OPTIONAL) A Network Firewall rule source list configuration. Use this property to define a domain list for Network Firewall."
              | optional,
            rulesString
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A Suricata-compatible stateful rule string. Use this property to define a single Suricata-compatible rule for Network Firewall."
              | optional,
            statefulRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatefulRuleConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall stateful rule IP header configurations. Use this property to define a stateful rule in IP header format for Network Firewall."
              | optional,
            statelessRulesAndCustomActions
              | _js2n__-refsenv."_js2n__-:definitions/INfwStatelessRulesAndCustomActionsConfig!contract"
              | doc "(OPTIONAL) A Network Firewall stateless rules and custom action configuration. Use this property to define stateless rules and custom actions for Network Firewall."
              | optional,
          },
      "_js2n__-:definitions/INfwRuleSourceCustomActionConfig!contract"
        | doc m%"
          Use this configuration to define to define custom actions for Network Firewall.
          You can optionally specify a named custom action to apply.
          For this action, Network Firewall assigns a dimension to Amazon CloudWatch metrics
          with the name set to CustomAction and a value that you specify.
        "%
        = {
            actionDefinition
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceCustomActionDefinitionConfig!contract"
              | doc "A Network Firewall custom action definition configuration.",
            actionName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the custom action.",
          },
      "_js2n__-:definitions/INfwRuleSourceCustomActionDefinitionConfig!contract"
        | doc m%"
          Use this configuration to define custom CloudWatch metrics for Network Firewall.
          You can optionally specify a named custom action to apply.
          For this action, Network Firewall assigns a dimension to Amazon CloudWatch metrics
          with the name set to CustomAction and a value that you specify.
        "%
        = {
            publishMetricAction
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceCustomActionDimensionConfig!contract"
              | doc "A Network Firewall custom action dimensions configuration.",
          },
      "_js2n__-:definitions/INfwRuleSourceCustomActionDimensionConfig!contract"
        | doc m%"
          Use this configuration to define custom action dimensions to log in CloudWatch metrics.
          You can optionally specify a named custom action to apply.
          For this action, Network Firewall assigns a dimension to Amazon CloudWatch metrics
          with the name set to CustomAction and a value that you specify.
        "%
        = {
            dimensions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of values of the custom metric dimensions to log.",
          },
      "_js2n__-:definitions/INfwRuleSourceListConfig!contract"
        | doc m%"
          Use this configuration to define DNS domain allow and deny lists for Network Firewall.
          Domain lists allow you to configure domain name filtering for your Network Firewall.
        "%
        = {
            generatedRulesType
              | _js2n__-refsenv."_js2n__-:definitions/NfwGeneratedRulesType!contract"
              | doc "The type of rules to generate from the source list.",
            targetTypes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NfwTargetType!contract"
              | doc "An array of protocol types to inspect.",
            targets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of target domain names.",
          },
      "_js2n__-:definitions/INfwRuleSourceStatefulRuleConfig!contract"
        | doc m%"
          Use this configuration to define stateful rules for Network Firewall in an IP packet header format.
          This header format can be used instead of Suricata-compatible rules to define your stateful firewall
          filtering behavior.
        "%
        = {
            action
              | _js2n__-refsenv."_js2n__-:definitions/NfwStatefulRuleActionType!contract"
              | doc "The action type for the stateful rule.",
            header
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatefulRuleHeaderConfig!contract"
              | doc "A Network Firewall stateful rule header configuration.",
            ruleOptions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatefulRuleOptionsConfig!contract"
              | doc "An array of Network Firewall stateful rule options configurations.",
          },
      "_js2n__-:definitions/INfwRuleSourceStatefulRuleHeaderConfig!contract"
        | doc m%"
          Use this configuration to define stateful rules for Network Firewall in an IP packet header format.
          This header format can be used instead of Suricata-compatible rules to define your stateful firewall
          filtering behavior.
        "%
        = {
            destination
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The destination CIDR range to inspect for.",
            destinationPort
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The destination port or port range to inspect.",
            direction
              | _js2n__-refsenv."_js2n__-:definitions/NfwStatefulRuleDirectionType!contract"
              | doc "The direction of the traffic flow to inspect.",
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/NfwStatefulRuleProtocolType!contract"
              | doc "The protocol to inspect.",
            source
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The source CIDR range to inspect for.",
            sourcePort
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The source port or port range to inspect.",
          },
      "_js2n__-:definitions/INfwRuleSourceStatefulRuleOptionsConfig!contract"
        | doc m%"
          Network Firewall stateful rule options configuration.
          Use this configuration to specify keywords and setting metadata for stateful rules.
        "%
        = {
            keyword
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A Suricata-compatible keyword.",
            settings
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of values for the keyword."
              | optional,
          },
      "_js2n__-:definitions/INfwRuleSourceStatelessMatchAttributesConfig!contract"
        | doc m%"
          Use this configuration to define stateless rule match attributes for Network Firewall.
          To be a match, a packet must satisfy all of the match settings in the rule.
        "%
        = {
            destinationPorts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatelessPortRangeConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall stateless port range configurations."
              | optional,
            destinations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of destination CIDR ranges to inspect for."
              | optional,
            protocols
              | Array (Number)
              | doc "(OPTIONAL) An array of IP protocol numbers to inspect for."
              | optional,
            sourcePorts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatelessPortRangeConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall stateless port range configurations."
              | optional,
            sources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of source CIDR ranges to inspect for."
              | optional,
            tcpFlags
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatelessTcpFlagsConfig!contract"
              | doc "(OPTIONAL) An array of Network Firewall stateless TCP flag configurations."
              | optional,
          },
      "_js2n__-:definitions/INfwRuleSourceStatelessPortRangeConfig!contract"
        | doc "Use this configuration to define a port range in stateless rules."
        = {
            fromPort | Number | doc "The port to start from in the range.",
            toPort | Number | doc "The port to end with in the range.",
          },
      "_js2n__-:definitions/INfwRuleSourceStatelessRuleConfig!contract"
        | doc m%"
          Use this configuration to define stateless rule for your  Network Firewall.
          Network Firewall supports the standard stateless 5-tuple rule specification
          for network traffic inspection. When Network Firewall finds a match between
           a rule's inspection criteria and a packet, we say that the packet matches
          the rule and its rule group, and Network Firewall applies the rule's specified action to the packet.
        "%
        = {
            "priority" | Number | doc "The priority number for the rule.",
            ruleDefinition
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatelessRuleDefinitionConfig!contract"
              | doc "A Network Firewall stateless rule definition configuration.",
          },
      "_js2n__-:definitions/INfwRuleSourceStatelessRuleDefinitionConfig!contract"
        | doc "Use this configuration to define a stateless rule definition for your Network Firewall."
        = {
            actions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/NfwStatelessRuleActionType!predicate"
                    ])
              )
              | doc "An array of actions to take using the stateless rule engine.",
            matchAttributes
              | _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatelessMatchAttributesConfig!contract"
              | doc "A Network Firewall stateless rule match attributes configuration.",
          },
      "_js2n__-:definitions/INfwRuleSourceStatelessTcpFlagsConfig!contract"
        | doc m%"
          Use this configuration to define TCP flags to inspect in stateless rules.
          Optional, standard TCP flag settings, which indicate which flags to inspect and the values to inspect for.
        "%
        = {
            flags
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NfwStatelessRuleTcpFlagType!contract"
              | doc "An array of TCP flags.",
            masks
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NfwStatelessRuleTcpFlagType!contract"
              | doc "The set of flags to consider in the inspection.",
          },
      "_js2n__-:definitions/INfwRuleVariableConfig!contract"
        | doc m%"
          Use this configuration to define rule variable definitions for Network Firewall.
          Rule variables can be used in Suricata-compatible and domain list rule definitions.
          They are not supported in stateful rule IP header definitions.
        "%
        = {
            ipSets
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/INfwRuleVariableDefinitionConfig!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          _js2n__-refsenv."_js2n__-:definitions/INfwRuleVariableDefinitionConfig!predicate"
                      ]
                  ])
              | doc "A Network Firewall rule variable definition configuration.",
            portSets
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/INfwRuleVariableDefinitionConfig!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          _js2n__-refsenv."_js2n__-:definitions/INfwRuleVariableDefinitionConfig!predicate"
                      ]
                  ])
              | doc "A Network Firewall rule variable definition configuration.",
          },
      "_js2n__-:definitions/INfwRuleVariableDefinitionConfig!predicate"
        | doc m%"
          Use this configuration to define rule variable definitions for Network Firewall.
          Rule variables can be used in Suricata-compatible and domain list rule definitions.
          They are not supported in stateful rule IP header definitions.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "definition", "name" ],
              _js2n__-prdslib.records.record
                {
                  definition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/INfwStatefulRuleGroupReferenceConfig!contract"
        | doc m%"
          Network Firewall stateful rule group reference configuration.
          Use this configuration to reference a stateful rule group in a Network Firewall policy.
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the rule group.",
            "priority"
              | Number
              | doc "(OPTIONAL) If using strict ordering, a priority number for the rule."
              | optional,
          },
      "_js2n__-:definitions/INfwStatelessRuleGroupReferenceConfig!contract"
        | doc m%"
          Network Firewall stateless rule group reference configuration.
          Use this configuration to reference a stateless rule group in a Network Firewall policy.
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the rule group.",
            "priority" | Number | doc "A priority number for the rule.",
          },
      "_js2n__-:definitions/INfwStatelessRulesAndCustomActionsConfig!contract"
        | doc "Use this configuration to define stateless rules and custom actions for Network Firewall."
        = {
            customActions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceCustomActionConfig!contract"
              | doc "An array of Network Firewall custom action configurations."
              | optional,
            statelessRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INfwRuleSourceStatelessRuleConfig!contract"
              | doc "An array of Network Firewall stateless rule configurations.",
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
      "_js2n__-:definitions/IOutpostsConfig!contract"
        | doc m%"
          Use this configuration to reference Outposts that exist in your environment.
          AWS Outposts enables customers to build and run applications on premises using the same
          programming interfaces as in AWS Regions, while using local compute and storage resources
          for lower latency and local data processing needs.
        "%
        = {
            arn
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The ARN for the Outpost",
            availabilityZone
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "The availability zone where the Outpost resides",
            localGateway
              | _js2n__-refsenv."_js2n__-:definitions/ILocalGatewayConfig!contract"
              | doc "The Local Gateway configuration for the Outpost"
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Outpost",
          },
      "_js2n__-:definitions/IPhase1Config!contract"
        | doc m%"
          Internet Key Exchange (IKE) Phase 1 tunnel options configuration.
          Use this configuration to restrict the permitted Diffie-Hellman group numbers, encryption algorithms, and integrity algorithms for IKE Phase 1 negotiations.
          You may also modify the Phase 1 lifetime for the VPN tunnel.
        "%
        = {
            dhGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/Phase1DhGroupType!contract"
              | doc m%"
                (OPTIONAL) An array of permitted Diffie-Hellman group numbers used in the IKE Phase 1 for initial authentication.
                
                Default - `[2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]`
              "%
              | optional,
            encryptionAlgorithms
              | Array
                _js2n__-refsenv."_js2n__-:definitions/EncryptionAlgorithmType!contract"
              | doc m%"
                (OPTIONAL) An array of encryption algorithms permitted for IKE Phase 1 negotiations.
                
                Default - `[AES128, AES256, AES128-GCM-16, AES256-GCM-16]`
              "%
              | optional,
            integrityAlgorithms
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IntegrityAlgorithmType!contract"
              | doc m%"
                (OPTIONAL) An array of integrity algorithms permitted for IKE Phase 1 negotiations.
                
                Default - `[SHA1, SHA2-256, SHA2-384, SHA2-512]`
              "%
              | optional,
            lifetimeSeconds
              | Number
              | doc m%"
                (OPTIONAL) The IKE Phase 1 lifetime (in seconds) for the VPN tunnel.
                
                Default: `28800` (8 hours)
              "%
              | optional,
          },
      "_js2n__-:definitions/IPhase2Config!contract"
        | doc m%"
          Internet Key Exchange (IKE) Phase 2 tunnel options configuration.
          Use this configuration to restrict the permitted Diffie-Hellman group numbers, encryption algorithms, and integrity algorithms for IKE Phase 2 negotiations.
          You may also modify the Phase 2 lifetime for the VPN tunnel.
        "%
        = {
            dhGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/Phase2DhGroupType!contract"
              | doc m%"
                (OPTIONAL) An array of permitted Diffie-Hellman group numbers used in the IKE Phase 2 negotiations.
                
                Default - `[2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]`
              "%
              | optional,
            encryptionAlgorithms
              | Array
                _js2n__-refsenv."_js2n__-:definitions/EncryptionAlgorithmType!contract"
              | doc m%"
                (OPTIONAL) An array of encryption algorithms permitted for IKE Phase 2 negotiations.
                
                Default - `[AES128, AES256, AES128-GCM-16, AES256-GCM-16]`
              "%
              | optional,
            integrityAlgorithms
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IntegrityAlgorithmType!contract"
              | doc m%"
                (OPTIONAL) An array of integrity algorithms permitted for IKE Phase 2 negotiations.
                
                Default - `[SHA1, SHA2-256, SHA2-384, SHA2-512]`
              "%
              | optional,
            lifetimeSeconds
              | Number
              | doc m%"
                (OPTIONAL) The IKE Phase 2 lifetime (in seconds) for the VPN tunnel.
                
                Default: `3600` (1 hour)
              "%
              | optional,
          },
      "_js2n__-:definitions/IPrefixListConfig!contract"
        | doc m%"
          Use this configuration to define custom prefix lists for your environment.
          A managed prefix list is a set of one or more CIDR blocks.
          You can use prefix lists to make it easier to configure and maintain your security groups and route tables.
          
          The following example creates a prefix list named `accelerator-pl` that may contain up to 10 entries.
          The prefix list is deployed to all accounts in the organization.
        "%
        = {
            accounts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(DEPRECATED) An array of friendly names for the accounts the prefix list is deployed."
              | optional,
            addressFamily
              | _js2n__-refsenv."_js2n__-:definitions/IpAddressFamilyType!contract"
              | doc "The IP address family of the prefix list.",
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "Prefix List deployment targets"
              | optional,
            entries
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of CIDR entries for the prefix list.",
            maxEntries
              | Number
              | doc "The maximum allowed entries in the prefix list.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the prefix list.",
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(DEPRECATED) An array of region names for the prefix list to be deployed."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the prefix list."
              | optional,
          },
      "_js2n__-:definitions/IPrefixListSourceConfig!predicate"
        | doc m%"
          Prefix list security group source configuration.
          Use this configuration to define a custom prefix list as a source in a security group rule.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "prefixLists" ],
              _js2n__-prdslib.records.record
                {
                  prefixLists =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IResolverConfig!contract"
        | doc m%"
          Use this configuration to define several features of Route 53 resolver, including resolver endpoints,
          DNS firewall rule groups, and DNS query logs.
          Amazon Route 53 Resolver responds recursively to DNS queries from AWS resources for public records,
          Amazon VPC-specific DNS names, and Amazon Route 53 private hosted zones, and is available by default in all VPCs.
        "%
        = {
            endpoints
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IResolverEndpointConfig!contract"
              | doc "(OPTIONAL) An array of Route 53 resolver endpoint configurations."
              | optional,
            firewallRuleGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDnsFirewallRuleGroupConfig!contract"
              | doc "(OPTIONAL) An array of Route 53 DNS firewall rule group configurations."
              | optional,
            queryLogs
              | _js2n__-refsenv."_js2n__-:definitions/IDnsQueryLogsConfig!contract"
              | doc "(OPTIONAL) A Route 53 resolver DNS query logging configuration."
              | optional,
            rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IResolverRuleConfig!contract"
              | doc "(OPTIONAL) An array of Route 53 resolver rules."
              | optional,
          },
      "_js2n__-:definitions/IResolverEndpointConfig!contract"
        | doc m%"
          Use this configuration to define inbound and outbound resolver endpoints.
          Route 53 Resolver contains endpoints that you configure to answer DNS queries to
          and from your on-premises environment.
        "%
        = {
            allowedCidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The allowed ingress/egress CIDRs for the resolver endpoint security group."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the resolver endpoint.",
            rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IResolverRuleConfig!contract"
              | doc "(OPTIONAL) An array of resolver rule configurations for the endpoint."
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of friendly names for subnets to deploy the resolver endpoint to.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the resolver endpoint."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/ResolverEndpointType!contract"
              | doc m%"
                The type of resolver endpoint to deploy.
                
                INBOUND: allows DNS queries to your VPC from your network
                
                OUTBOUND: allows DNS queries from your VPC to your network
              "%,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the VPC to deploy the resolver endpoint to.",
          },
      "_js2n__-:definitions/IResolverRuleConfig!contract"
        | doc m%"
          Use this configuration to define resolver SYSTEM and FORWARD rules for your resolver.
          If you want Resolver to forward queries for specified domain names to your network,
          you create one forwarding rule for each domain name and specify the name of the
          domain for which you want to forward queries.
        "%
        = {
            domainName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The domain name for the resolver rule.",
            excludedRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) Regions to exclude from SYSTEM rule deployment."
              | optional,
            inboundEndpointTarget
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of an inbound endpoint to target."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the resolver rule.",
            ruleType
              | _js2n__-refsenv."_js2n__-:definitions/RuleType!contract"
              | doc "(OPTIONAL) The type of rule to create."
              | optional,
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the resolver rule."
              | optional,
            targetIps
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IRuleTargetIps!contract"
              | doc "(OPTIONAL) An array of target IP configurations for the resolver rule."
              | optional,
          },
      "_js2n__-:definitions/IRouteTableConfig!contract"
        | doc m%"
          Use this configuration to define custom route tables for your VPC.
          Route tables contain a set of rules, called routes, to determine where network traffic from a subnet or gateway is directed.
        "%
        = {
            gatewayAssociation
              | _js2n__-refsenv."_js2n__-:definitions/GatewayRouteTableType!contract"
              | doc "Designate a gateway to associate this route table with."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the VPC route table.",
            routes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IRouteTableEntryConfig!contract"
              | doc "An array of VPC route table entry configuration objects."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the VPC route table."
              | optional,
          },
      "_js2n__-:definitions/IRouteTableEntryConfig!contract"
        | doc m%"
          Use this configuration to define static route entries in a VPC subnet or gateway route table.
          Static routes are used determine traffic flow from your subnet to a defined destination address and target.
        "%
        = {
            destination
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The destination IPv4 CIDR block or dynamic subnet reference for the route table entry."
              | optional,
            destinationPrefixList
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the destination prefix list for the route table entry."
              | optional,
            ipv6Destination
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The destination IPv6 CIDR block or dynamic subnet reference for the route table entry."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the route table.",
            target
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the destination target."
              | optional,
            targetAvailabilityZone
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "The Availability Zone (AZ) the target resides in."
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/RouteTableEntryType!contract"
              | doc "The destination type of route table entry."
              | optional,
          },
      "_js2n__-:definitions/IRuleTargetIps!contract" =
        {
            ip | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
            port
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
          },
      "_js2n__-:definitions/ISecurityGroupConfig!contract"
        | doc m%"
          Use this configuration to define security groups in your VPC.
          A security group acts as a firewall that controls the traffic
          allowed to and from the resources in your VPC.
          You can choose the ports and protocols to allow for inbound and outbound traffic.
          
          The following example creates a security group that allows inbound RDP and SSH traffic from source CIDR 10.0.0.0/16.
          It also allows all outbound traffic.
        "%
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description for the security group."
              | optional,
            inboundRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISecurityGroupRuleConfig!contract"
              | doc "An array of security group rule configurations for ingress rules.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the security group.",
            outboundRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISecurityGroupRuleConfig!contract"
              | doc "An array of security group rule configurations for egress rules.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the security group."
              | optional,
          },
      "_js2n__-:definitions/ISecurityGroupRuleConfig!contract"
        | doc m%"
          Use this configuration to define ingress and egress rules for your security groups.
          The rules of a security group control the inbound traffic that's allowed to reach the resources
          that are associated with the security group. The rules also control the outbound traffic that's
          allowed to leave them.
        "%
        = {
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A description for the security group rule.",
            fromPort
              | Number
              | doc "(OPTIONAL) The port to start from in the security group rule."
              | optional,
            ipProtocols
              | Array (String)
              | doc "(OPTIONAL) An array of custom IP Protocols for the security group rule"
              | optional,
            sources
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ISubnetSourceConfig!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ISecurityGroupSourceConfig!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/IPrefixListSourceConfig!predicate"
                    ])
              )
              | doc "An array of sources for the security group rule.",
            tcpPorts
              | Array (Number)
              | doc "(OPTIONAL) An array of TCP ports to include in the security group rule."
              | optional,
            toPort
              | Number
              | doc "(OPTIONAL) The port to end with in the security group rule."
              | optional,
            types
              | Array
                _js2n__-refsenv."_js2n__-:definitions/SecurityGroupRuleType!contract"
              | doc "(OPTIONAL) An array of port/protocol types to include in the security group rule."
              | optional,
            udpPorts
              | Array (Number)
              | doc "(OPTIONAL) An array of UDP ports to include in the security group rule."
              | optional,
          },
      "_js2n__-:definitions/ISecurityGroupSourceConfig!predicate"
        | doc m%"
          Security group source configuration.
          Use this configuration to define a security group as a source of a security group rule.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "securityGroups" ],
              _js2n__-prdslib.records.record
                {
                  securityGroups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IShareTargets!contract" =
        {
            accounts | Array (String) | optional,
            organizationalUnits | Array (String) | optional,
          },
      "_js2n__-:definitions/ISubnetConfig!contract"
        | doc m%"
          Use this configuration to define subnets for your VPC.
          A subnet is a range of IP addresses in your VPC that can be used to create AWS resources, such as EC2 instances.
        "%
        = {
            assignIpv6OnCreation
              | Bool
              | doc "(OPTIONAL) Indicates whether a network interface created in this subnet receives an IPv6 address on creation."
              | optional,
            availabilityZone
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "The Availability Zone (AZ) the subnet resides in."
              | optional,
            enableDns64
              | Bool
              | doc m%"
                (OPTIONAL) Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations.
                
                For more information, see  {@link  https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html#nat-gateway-nat64-dns64 DNS64 and NAT64 }  in the Amazon Virtual Private Cloud User Guide.
              "%
              | optional,
            ipamAllocation
              | _js2n__-refsenv."_js2n__-:definitions/IIpamAllocationConfig!contract"
              | doc "The IPAM pool configuration for the subnet."
              | optional,
            ipv4CidrBlock
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The IPv4 CIDR block to associate with the subnet."
              | optional,
            ipv6CidrBlock
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The IPv6 CIDR block to associate with the subnet."
              | optional,
            localZone
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The Zone ID of the local zone."
              | optional,
            mapPublicIpOnLaunch
              | Bool
              | doc "(OPTIONAL) Configure automatic mapping of public IPs."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the VPC subnet.",
            outpost
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name for the outpost to attach to the subnet"
              | optional,
            privateDnsOptions
              | _js2n__-refsenv."_js2n__-:definitions/ISubnetPrivateDnsConfig!contract"
              | doc "(OPTIONAL) Private DNS name options for the subnet."
              | optional,
            routeTable
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the route table to associate with the subnet."
              | optional,
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the VPC subnet."
              | optional,
          },
      "_js2n__-:definitions/ISubnetPrivateDnsConfig!contract"
        | doc "Use this configuration to define custom DNS name settings for your VPC subnets."
        = {
            enableDnsAAAARecord
              | Bool
              | doc "(OPTIONAL) Indicates whether to respond to DNS queries for instance hostname with DNS AAAA records."
              | optional,
            enableDnsARecord
              | Bool
              | doc "(OPTIONAL) Indicates whether to respond to DNS queries for instance hostnames with DNS A records."
              | optional,
            hostnameType
              | std.enum.TagOrString
              | [| 'resource-name, 'ip-name |]
              | doc "The type of hostname for EC2 instances."
              | optional,
          },
      "_js2n__-:definitions/ISubnetSourceConfig!predicate"
        | doc m%"
          VPC subnet security group source configuration.
          Use this configuration to dynamically reference subnet CIDRs in a security group rule.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "account", "subnets", "vpc" ],
              _js2n__-prdslib.records.record
                {
                  account =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                  ipv6 = _js2n__-prdslib.isType '"Bool",
                  subnets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                        ],
                  vpc =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ITag!contract" = { key | String, value | String, },
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
      "_js2n__-:definitions/ITransitGatewayAttachmentConfig!contract"
        | doc m%"
          Use this configuration to define a Transit Gateway attachment to your VPC.
          Transit Gateway attachments allow you to interconnect your virtual private clouds (VPCs) and on-premises networks.
          Defining a VPC attachment deploys an elastic network interface within VPC subnets,
          which is then used by the transit gateway to route traffic to and from the chosen subnets.
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Transit Gateway attachment.",
            options
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayAttachmentOptionsConfig!contract"
              | doc "(OPTIONAL) A Transit Gateway attachment options configuration."
              | optional,
            routeTableAssociations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of a Transit Gateway route table to associate the attachment to."
              | optional,
            routeTablePropagations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of friendly names of Transit Gateway route tables to propagate the attachment."
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "An array of the friendly names of VPC subnets for the attachment to be deployed.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the Transit Gateway attachment."
              | optional,
            transitGateway
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayAttachmentTargetConfig!contract"
              | doc "A Transit Gateway attachment target configuration object.",
          },
      "_js2n__-:definitions/ITransitGatewayAttachmentOptionsConfig!contract"
        | doc "Used to specify advanced options for the VPC attachment."
        = {
            applianceModeSupport
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "(OPTIONAL) Enable to configure appliance mode for the attachment. This option is disabled by default."
              | optional,
            dnsSupport
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "(OPTIONAL) Enable to configure DNS support for the attachment. This option is enabled by default."
              | optional,
            ipv6Support
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "(OPTIONAL) Enable to configure IPv6 support for the attachment. This option is disabled by default."
              | optional,
          },
      "_js2n__-:definitions/ITransitGatewayAttachmentTargetConfig!contract"
        | doc "Use this configuration to target a Transit Gateway when defining an attachment for your VPC."
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account for the attachment target Transit Gateway.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the attachment target Transit Gateway.",
          },
      "_js2n__-:definitions/ITransitGatewayConfig!contract"
        | doc m%"
          Use this configuration to define Transit Gateways for your environment.
          A transit gateway acts as a virtual router for traffic flowing between your virtual private clouds (VPCs) and on-premises networks.
          
          The following example creates a TGW called Network-Main in the Network account in the us-east-1 region.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account to deploy the Transit Gateway.",
            asn
              | Number
              | doc "A Border Gateway Protocol (BGP) Autonomous System Number (ASN).",
            autoAcceptSharingAttachments
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "Enable this option to automatically accept cross-account attachments.",
            defaultRouteTableAssociation
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "Configure default route table association.",
            defaultRouteTablePropagation
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "Configure default route table propagation.",
            dnsSupport
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "Configure DNS support between VPCs.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Transit Gateway.",
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The region name to deploy the Transit Gateway.",
            routeTables
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayRouteTableConfig!contract"
              | doc "An array of Transit Gateway route table configuration objects.",
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "(OPTIONAL) Resource Access Manager (RAM) share targets."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the Transit Gateway."
              | optional,
            transitGatewayCidrBlocks
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of transit gateway IPv4 CIDR blocks."
              | optional,
            transitGatewayIpv6CidrBlocks
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of transit gateway IPv6 CIDR blocks."
              | optional,
            vpnEcmpSupport
              | _js2n__-refsenv."_js2n__-:definitions/EnableDisable!contract"
              | doc "Equal Cost Multipath (ECMP) routing support between VPN tunnels.",
          },
      "_js2n__-:definitions/ITransitGatewayConnectConfig!contract"
        | doc "Use this configuration to define a Transit Gateway Connect attachment to your Direct Connect Gateway."
        = {
            directConnect
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The Direct Connect Gateway Attachment that belongs to the Transit Gateway that a Transit Gateway Connect Attachment is being made for."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Transit Gateway Connect attachment.",
            options
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayConnectOptionsConfig!contract"
              | doc "(OPTIONAL) Options around the Transit Gateway Connect"
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The AWS Region for the attachment.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the Transit Gateway attachment."
              | optional,
            transitGateway
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayAttachmentTargetConfig!contract"
              | doc "The Transit Gateway configuration object to set the Transit Gateway Connect.",
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayConnectVpcConfig!contract"
              | doc "The VPC Attachment that belongs to the Transit Gateway that a Transit Gateway Connect Attachment is being made for."
              | optional,
          },
      "_js2n__-:definitions/ITransitGatewayConnectOptionsConfig!contract" =
        {
            protocol
              | _js2n__-refsenv."_js2n__-:definitions/TransitGatewayConnectProtocol!contract"
              | doc "The tunnel protocl for the Transit Gateway Connect",
          },
      "_js2n__-:definitions/ITransitGatewayConnectVpcConfig!contract" =
        {
            vpcAttachment
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the VPC attachment",
            vpcName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the VPC",
          },
      "_js2n__-:definitions/ITransitGatewayPeeringAccepterConfig!contract"
        | doc m%"
          Transit Gateway (TGW) peering accepter configuration.
          Use this configuration to define the accepter side of the peering attachment.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account of the accepter transit gateway",
            applyTags
              | Bool
              | doc "(OPTIONAL) Peering request apply tags flag. Note: When this flag is set to `true`, the requester attachment tags are replicated to the accepter attachment."
              | optional,
            autoAccept
              | Bool
              | doc "(OPTIONAL) Peering request auto accept flag. Note: When this flag is set to `true`, the peering request will be automatically accepted by the accelerator."
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The name of the region the accepter transit gateway resides in",
            routeTableAssociations
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of TGW route table to associate with this peering attachment.",
            transitGatewayName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the accepter transit gateway",
          },
      "_js2n__-:definitions/ITransitGatewayPeeringConfig!contract"
        | doc "Use this configuration to define a peering attachment between two TGWs."
        = {
            accepter
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayPeeringAccepterConfig!contract"
              | doc "Peering attachment accepter configuration",
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of TGW peering.",
            requester
              | _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayPeeringRequesterConfig!contract"
              | doc "Peering attachment requester configuration.",
          },
      "_js2n__-:definitions/ITransitGatewayPeeringRequesterConfig!contract"
        | doc m%"
          Transit Gateway (TGW) peering requester configuration.
          Use this configuration to define the requester side of the peering attachment.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the account of the requester transit gateway",
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The name of the region the accepter transit gateway resides in",
            routeTableAssociations
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of TGW route table to associate with this peering attachment.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the Transit Gateway Peering."
              | optional,
            transitGatewayName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of the requester transit gateway",
          },
      "_js2n__-:definitions/ITransitGatewayRouteEntryConfig!contract"
        | doc "Use this configuration to define static route entries in a Transit Gateway route table."
        = {
            attachment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayRouteTableVpcEntryConfig!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayRouteTableDxGatewayEntryConfig!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayRouteTableVpnEntryConfig!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayRouteTableTgwPeeringEntryConfig!predicate"
                  ])
              | doc m%"
                The target  {@link  https://docs.aws.amazon.com/vpc/latest/tgw/working-with-transit-gateways.html Transit Gateway attachment }  for the route table entry. Supported attachment types include:
                
                - VPC
                - Direct Connect Gateway
                - VPN
                - Transit Gateway Peering
              "%
              | optional,
            blackhole
              | Bool
              | doc "(OPTIONAL) Enable to create a blackhole for the destination CIDR. Leave undefined if specifying a VPC destination."
              | optional,
            destinationCidrBlock
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The destination IPv4/v6 CIDR block for the route table entry."
              | optional,
            destinationPrefixList
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The friendly name of a prefix list for the route table entry."
              | optional,
          },
      "_js2n__-:definitions/ITransitGatewayRouteTableConfig!contract"
        | doc m%"
          Use this configuration define route tables for your Transit Gateway. Route tables are used to configure
          routing behaviors for your Transit Gateway.
          
          The following example creates a TGW route table called Network-Main-Shared with no static route entries:
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the Transit Gateway route table.",
            routes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayRouteEntryConfig!contract"
              | doc "An array of Transit Gateway route entry configuration objects.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tag objects for the Transit Gateway route table."
              | optional,
          },
      "_js2n__-:definitions/ITransitGatewayRouteTableDxGatewayEntryConfig!predicate"
        | doc m%"
          Transit Gateway Direct Connect Gateway static route entry configuration.
          Use this configuration to define a Direct Connect Gateway attachment as a target for Transit
          Gateway static routes.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "directConnectGatewayName" ],
              _js2n__-prdslib.records.record
                {
                  directConnectGatewayName =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ITransitGatewayRouteTableTgwPeeringEntryConfig!predicate"
        | doc m%"
          Transit Gateway peering static route entry configuration.
          Used to define a peering attachment as a target for Transit
          Gateway static routes.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "transitGatewayPeeringName" ],
              _js2n__-prdslib.records.record
                {
                  transitGatewayPeeringName =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ITransitGatewayRouteTableVpcEntryConfig!predicate"
        | doc m%"
          Transit Gateway VPC static route entry configuration.
          Use this configuration to define an account and VPC name as a target for Transit Gateway static route entries.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "account", "vpcName" ],
              _js2n__-prdslib.records.record
                {
                  account =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                  vpcName =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ITransitGatewayRouteTableVpnEntryConfig!predicate"
        | doc m%"
          Transit Gateway VPN static route entry configuration.
          Use this configuration to define a VPN attachment as a target for Transit
          Gateway static routes.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "vpnConnectionName" ],
              _js2n__-prdslib.records.record
                {
                  vpnConnectionName =
                    _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ITransition!contract" =
        {
            storageClass
              | _js2n__-refsenv."_js2n__-:definitions/StorageClass!contract",
            transitionAfter | Number,
          },
      "_js2n__-:definitions/IVirtualPrivateGatewayConfig!contract"
        | doc m%"
          Used to define Virtual Private Gateways that are attached to a VPC.
          You can create an IPsec VPN connection between your VPC and your remote network.
          On the AWS side of the Site-to-Site VPN connection, a virtual private gateway or transit
          gateway provides two VPN endpoints (tunnels) for automatic failover.
        "%
        = {
            asn
              | Number
              | doc "Define the ASN (Amazon Side) used for the Virtual Private Gateway",
          },
      "_js2n__-:definitions/IVpcConfig!contract"
        | doc m%"
          Use this configuration to define a VPC that is deployed to a single account and region.
          With Amazon Virtual Private Cloud (Amazon VPC), you can launch AWS resources in a logically
          isolated virtual network that you've defined. This virtual network closely resembles a traditional
          network that you'd operate in your own data center, with the benefits of using the scalable infrastructure of AWS.
        "%
        = {
            account
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The logical name of the account to deploy the VPC to",
            cidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of IPv4 CIDRs to associate with the VPC."
              | optional,
            defaultSecurityGroupRulesDeletion
              | Bool
              | doc "(OPTIONAL) Determine if the all traffic ingress and egress rules are deleted in the default security group of a VPC."
              | optional,
            dhcpOptions
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of a custom DHCP options set."
              | optional,
            dnsFirewallRuleGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpcDnsFirewallAssociationConfig!contract"
              | doc "(OPTIONAL) An array of DNS firewall VPC association configurations. Use this property to associate Route 53 resolver DNS firewall rule groups with the VPC."
              | optional,
            egressOnlyIgw
              | Bool
              | doc "(OPTIONAL) Create an  {@link  https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html Egress-only internet gateway (EIGW) }  for the VPC"
              | optional,
            enableDnsHostnames
              | Bool
              | doc "Enable DNS hostname support for the VPC."
              | optional,
            enableDnsSupport
              | Bool
              | doc "Enable DNS support for the VPC."
              | optional,
            gatewayEndpoints
              | _js2n__-refsenv."_js2n__-:definitions/IGatewayEndpointConfig!contract"
              | doc "(OPTIONAL) An array of gateway endpoints for the VPC. Use this property to define S3 or DynamoDB gateway endpoints for the VPC."
              | optional,
            instanceTenancy
              | _js2n__-refsenv."_js2n__-:definitions/InstanceTenancyType!contract"
              | doc "(OPTIONAL) Define instance tenancy for the VPC. The default value is `default`."
              | optional,
            interfaceEndpoints
              | _js2n__-refsenv."_js2n__-:definitions/IInterfaceEndpointConfig!contract"
              | doc "(OPTIONAL) A list of VPC interface endpoints. Use this property to define VPC interface endpoints for the VPC."
              | optional,
            internetGateway
              | Bool
              | doc "Defines if an  {@link  https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html internet gateway }  should be added to the VPC"
              | optional,
            ipamAllocations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IIpamAllocationConfig!contract"
              | doc "(OPTIONAL) An array of IPAM allocation configurations."
              | optional,
            ipv6Cidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpcIpv6Config!contract"
              | doc "(OPTIONAL) An array of IPv6 CIDR block configurations."
              | optional,
            loadBalancers
              | _js2n__-refsenv."_js2n__-:definitions/ILoadBalancersConfig!contract"
              | doc "Elastic Load Balancing configuration. Use this property to define Elastic Load Balancers for this VPC."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The friendly name of the VPC.
                
                The value of this property will be utilized as the logical id for this resource. Any references to this object should specify this value.
              "%,
            natGateways
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INatGatewayConfig!contract"
              | doc "(OPTIONAL) An array of NAT gateway configurations for the VPC. Use this property to configure the NAT gateways for the VPC."
              | optional,
            networkAcls
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INetworkAclConfig!contract"
              | doc "(OPTIONAL) A list of Network Access Control Lists (ACLs) to deploy for this VPC"
              | optional,
            outposts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IOutpostsConfig!contract"
              | doc "(OPTIONAL) An array of Local Gateway Route table configurations. Use this configuration to associate Outposts Local Gateway Route tables with the VPC."
              | optional,
            queryLogs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of DNS query log configuration names."
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The AWS region to deploy the VPC to",
            resolverRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of Route 53 resolver rule names."
              | optional,
            routeTables
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IRouteTableConfig!contract"
              | doc "(OPTIONAL) An array of route table configurations for the VPC. Use this property to configure the route tables for the VPC."
              | optional,
            securityGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISecurityGroupConfig!contract"
              | doc "(OPTIONAL) A list of Security Groups to deploy for this VPC"
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISubnetConfig!contract"
              | doc "(OPTIONAL) An array of subnet configurations for the VPC. Use this property to configure the subnets for the VPC."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) A list of tags to apply to this VPC"
              | optional,
            targetGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITargetGroupItem!contract"
              | doc "Target group configuration. Use this property to define target groups for this VPC."
              | optional,
            transitGatewayAttachments
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayAttachmentConfig!contract"
              | doc "(OPTIONAL) An array of Transit Gateway attachment configurations. Use this property to configure the Transit Gateway attachments for the VPC."
              | optional,
            useCentralEndpoints
              | Bool
              | doc "(OPTIONAL) When set to true, this VPC will be configured to utilize centralized endpoints. This includes having the Route 53 Private Hosted Zone associated with this VPC. Centralized endpoints are configured per region, and can span to spoke accounts"
              | optional,
            virtualPrivateGateway
              | _js2n__-refsenv."_js2n__-:definitions/IVirtualPrivateGatewayConfig!contract"
              | doc "(OPTIONAL) Virtual Private Gateway configuration. Use this property to configure a Virtual Private Gateway for the VPC."
              | optional,
            vpcFlowLogs
              | _js2n__-refsenv."_js2n__-:definitions/IVpcFlowLogsConfig!contract"
              | doc "VPC flog log configuration. Use this property to define a VPC-specific VPC flow logs configuration."
              | optional,
            vpcRoute53Resolver
              | _js2n__-refsenv."_js2n__-:definitions/IResolverConfig!contract"
              | doc "A Route 53 resolver configuration local to the VPC."
              | optional,
          },
      "_js2n__-:definitions/IVpcDnsFirewallAssociationConfig!contract" =
        {
            mutationProtection
              | _js2n__-refsenv."_js2n__-:definitions/MutationProtectionType!contract"
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
            "priority" | Number,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | optional,
          },
      "_js2n__-:definitions/IVpcFlowLogsCloudWatchLogsConfig!contract" =
        {
            kms
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
            retentionInDays | Number | optional,
          },
      "_js2n__-:definitions/IVpcFlowLogsConfig!contract" =
        {
            customFields
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
            defaultFormat | Bool,
            destinations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/LogDestinationType!contract",
            destinationsConfig
              | _js2n__-refsenv."_js2n__-:definitions/IVpcFlowLogsDestinationConfig!contract"
              | optional,
            maxAggregationInterval | Number,
            trafficType
              | _js2n__-refsenv."_js2n__-:definitions/TrafficType!contract",
          },
      "_js2n__-:definitions/IVpcFlowLogsDestinationConfig!contract" =
        {
            cloudWatchLogs
              | _js2n__-refsenv."_js2n__-:definitions/IVpcFlowLogsCloudWatchLogsConfig!contract"
              | optional,
            s3
              | _js2n__-refsenv."_js2n__-:definitions/IVpcFlowLogsS3BucketConfig!contract"
              | optional,
          },
      "_js2n__-:definitions/IVpcFlowLogsS3BucketConfig!contract" =
        {
            lifecycleRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ILifecycleRule!contract"
              | optional,
            overrideS3LogPath
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
          },
      "_js2n__-:definitions/IVpcIpv6Config!contract"
        | doc "VPC IPv6 static CIDR configuration. Use this to associate a static IPv6 CIDR block to your VPC."
        = {
            amazonProvided
              | Bool
              | doc "(OPTIONAL) Indicates whether Amazon automatically provisions a /56 IPv6 CIDR block for the VPC."
              | optional,
            byoipPoolId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Used to define the Bring-Your-Own-IP (BYOIP) address pool ID to use for the IPv6 CIDR block."
              | optional,
            cidrBlock
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Associate an IPv6 CIDR block with your VPC."
              | optional,
          },
      "_js2n__-:definitions/IVpcPeeringConfig!contract"
        | doc m%"
          VPC peering configuration.
          Used to define VPC peering connections.
          
          VPC can be from vpc or vpcTemplates configuration.
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A friendly name for the peering connection.",
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "An array of tags for the peering connection."
              | optional,
            vpcs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The VPCs to peer.
                
                VPC can be from vpc or vpcTemplates configuration.
              "%,
          },
      "_js2n__-:definitions/IVpcTemplatesConfig!contract"
        | doc m%"
          Use this configuration to define a VPC using a standard configuration that is deployed to multiple account(s)/OU(s) defined using a `deploymentTargets` property.
          With Amazon Virtual Private Cloud (Amazon VPC), you can launch AWS resources in a logically
          isolated virtual network that you've defined. This virtual network closely resembles a traditional
          network that you'd operate in your own data center, with the benefits of using the scalable infrastructure of AWS.
          
          Static CIDR:
          ```
          vpcTemplates:
            - name: Accelerator-Template
              deploymentTargets:
                organizationalUnits:
                  - Infrastructure
              region: us-east-1
              cidrs:
                - 10.0.0.0/24
              enableDnsHostnames: true
              enableDnsSupport: true
              instanceTenancy: default
              routeTables: []
              subnets: []
              natGateways: []
              transitGatewayAttachments: []
              tags: []
          ```
          IPAM allocation:
          ```
          vpcTemplates:
            - name: Accelerator-Template
              deploymentTargets:
                organizationalUnits:
                  - Infrastructure
              region: us-east-1
              ipamAllocations:
                - ipamPoolName: accelerator-regional-pool
                  netmaskLength: 24
              enableDnsHostnames: true
              enableDnsSupport: true
              instanceTenancy: default
              routeTables: []
              subnets: []
              natGateways: []
              transitGatewayAttachments: []
              tags: []
          ```
          Static IPv6 CIDR:
          ```
          vpcTemplates:
            - name: Accelerator-Template
              deploymentTargets:
                organizationalUnits:
                  - Infrastructure
              region: us-east-1
              cidrs:
                - 10.0.0.0/24
              ipv6Cidrs:
                - amazonProvided: true
              enableDnsHostnames: true
              enableDnsSupport: true
              instanceTenancy: default
              routeTables: []
              subnets: []
              natGateways: []
              transitGatewayAttachments: []
              tags: []
          ```
        "%
        = {
            cidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of IPv4 CIDRs to associate with the VPC."
              | optional,
            defaultSecurityGroupRulesDeletion
              | Bool
              | doc "(OPTIONAL) Determine if the all traffic ingress and egress rules are deleted in the default security group of a VPC."
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "VPC deployment targets.",
            dhcpOptions
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The friendly name of a custom DHCP options set."
              | optional,
            dnsFirewallRuleGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpcDnsFirewallAssociationConfig!contract"
              | doc "(OPTIONAL) An array of DNS firewall VPC association configurations. Use this property to associate Route 53 resolver DNS firewall rule groups with the VPC."
              | optional,
            egressOnlyIgw
              | Bool
              | doc "(OPTIONAL) Create an  {@link  https://docs.aws.amazon.com/vpc/latest/userguide/egress-only-internet-gateway.html Egress-only internet gateway (EIGW) }  for the VPC"
              | optional,
            enableDnsHostnames
              | Bool
              | doc "Enable DNS hostname support for the VPC."
              | optional,
            enableDnsSupport
              | Bool
              | doc "Enable DNS support for the VPC."
              | optional,
            gatewayEndpoints
              | _js2n__-refsenv."_js2n__-:definitions/IGatewayEndpointConfig!contract"
              | doc "(OPTIONAL) An array of gateway endpoints for the VPC. Use this property to define S3 or DynamoDB gateway endpoints for the VPC."
              | optional,
            instanceTenancy
              | _js2n__-refsenv."_js2n__-:definitions/InstanceTenancyType!contract"
              | doc "(OPTIONAL) Define instance tenancy for the VPC. The default value is `default`."
              | optional,
            interfaceEndpoints
              | _js2n__-refsenv."_js2n__-:definitions/IInterfaceEndpointConfig!contract"
              | doc "(OPTIONAL) A list of VPC interface endpoints. Use this property to define VPC interface endpoints for the VPC."
              | optional,
            internetGateway
              | Bool
              | doc "Defines if an  {@link  https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html internet gateway }  should be added to the VPC"
              | optional,
            ipamAllocations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IIpamAllocationConfig!contract"
              | doc "(OPTIONAL) An array of IPAM allocation configurations."
              | optional,
            ipv6Cidrs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpcIpv6Config!contract"
              | doc "(OPTIONAL) An array of IPv6 CIDR block configurations."
              | optional,
            loadBalancers
              | _js2n__-refsenv."_js2n__-:definitions/ILoadBalancersConfig!contract"
              | doc "Elastic Load Balancing configuration. Use this property to define Elastic Load Balancers for this VPC."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The friendly name of the VPC.
                
                The value of this property will be utilized as the logical id for this resource. Any references to this object should specify this value.
              "%,
            natGateways
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INatGatewayConfig!contract"
              | doc "(OPTIONAL) An array of NAT gateway configurations for the VPC. Use this property to configure the NAT gateways for the VPC."
              | optional,
            networkAcls
              | Array
                _js2n__-refsenv."_js2n__-:definitions/INetworkAclConfig!contract"
              | doc "(OPTIONAL) A list of Network Access Control Lists (ACLs) to deploy for this VPC"
              | optional,
            queryLogs
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of DNS query log configuration names."
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "The AWS region to deploy the VPCs to",
            resolverRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A list of Route 53 resolver rule names."
              | optional,
            routeTables
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IRouteTableConfig!contract"
              | doc "(OPTIONAL) An array of route table configurations for the VPC. Use this property to configure the route tables for the VPC."
              | optional,
            securityGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISecurityGroupConfig!contract"
              | doc "(OPTIONAL) A list of Security Groups to deploy for this VPC"
              | optional,
            subnets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISubnetConfig!contract"
              | doc "(OPTIONAL) An array of subnet configurations for the VPC. Use this property to configure the subnets for the VPC."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) A list of tags to apply to this VPC"
              | optional,
            targetGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITargetGroupItem!contract"
              | doc "Target group configuration. Use this property to define target groups for this VPC."
              | optional,
            transitGatewayAttachments
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ITransitGatewayAttachmentConfig!contract"
              | doc "(OPTIONAL) An array of Transit Gateway attachment configurations. Use this property to configure the Transit Gateway attachments for the VPC."
              | optional,
            useCentralEndpoints
              | Bool
              | doc "(OPTIONAL) When set to true, this VPC will be configured to utilize centralized endpoints. This includes having the Route 53 Private Hosted Zone associated with this VPC. Centralized endpoints are configured per region, and can span to spoke accounts"
              | optional,
            virtualPrivateGateway
              | _js2n__-refsenv."_js2n__-:definitions/IVirtualPrivateGatewayConfig!contract"
              | doc "(OPTIONAL) Virtual Private Gateway configuration. Use this property to configure a Virtual Private Gateway for the VPC."
              | optional,
            vpcFlowLogs
              | _js2n__-refsenv."_js2n__-:definitions/IVpcFlowLogsConfig!contract"
              | doc "VPC flog log configuration. Use this property to define a VPC-specific VPC flow logs configuration."
              | optional,
          },
      "_js2n__-:definitions/IVpnConnectionConfig!contract"
        | doc m%"
          Use this configuration to define the VPN connections that
          terminate either on a Transit Gateway or virtual private gateway.
          A VPN connection refers to the connection between your VPC and your own on-premises network.
          You can enable access to your remote network from your VPC by creating an
          AWS Site-to-Site VPN (Site-to-Site VPN) connection, and configuring routing
          to pass traffic through the connection.
          
          **IMPORTANT**: After initial deployment of your VPN connection with any of the v1.5.0+ options noted below, you can make property changes in one of {@link VpnConnectionConfig } or {@link VpnTunnelOptionsSpecificationsConfig }, but not both.
          You may make multiple property changes in one of those configurations if necessary. Trying to modify properties in both configurations will result in a pipeline failure. This is due to the fact that
          only a single mutating API call can be made at a time for AWS Site-to-Site VPN connections.
          
          Note: you may manually roll back the resulting CloudFormation stack should you encounter this failure. More details on how to skip failed resources in the following reference:
          https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-continueupdaterollback.html
        "%
        = {
            amazonIpv4NetworkCidr
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) The Amazon-side IPv4 CIDR range that is allowed through the site-to-site VPN tunnel. Configuring this option restricts the Amazon-side CIDR range that can communicate with your local network.
                
                Default - `0.0.0.0/0`
              "%
              | optional,
            customerIpv4NetworkCidr
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) The customer-side IPv4 CIDR range that is allowed through the site-to-site VPN tunnel. Configuring this option restricts the local CIDR range that can communicate with your AWS environment.
                
                Default - `0.0.0.0/0`
              "%
              | optional,
            enableVpnAcceleration
              | Bool
              | doc "(OPTIONAL) Enable Site-to-Site VPN Acceleration. For more information, see  {@link  https://docs.aws.amazon.com/vpn/latest/s2svpn/accelerated-vpn.html Accelerated Site-to-Site VPN connections } ."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The name of the VPN Connection.
                
                The value of this property will be utilized as the logical id for this resource. Any references to this object should specify this value.
              "%,
            routeTableAssociations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of Transit Gateway route table names to associate the VPN attachment to"
              | optional,
            routeTablePropagations
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of Transit Gateway route table names to propagate the VPN attachment to"
              | optional,
            staticRoutesOnly
              | Bool
              | doc "(OPTIONAL) If creating a VPN connection for a device that doesn't support Border Gateway Protocol (BGP) declare true as a value, otherwise, use false."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) An array of tags for the VPN Connection."
              | optional,
            transitGateway
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The logical name of the Transit Gateway that the customer Gateway is attached to so that a VPN connection is established."
              | optional,
            tunnelSpecifications
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IVpnTunnelOptionsSpecificationsConfig!contract"
              | doc "(OPTIONAL) Define the optional VPN Tunnel configuration"
              | optional,
            vpc
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The logical name of the Virtual Private Cloud that a Virtual Private Gateway is attached to."
              | optional,
          },
      "_js2n__-:definitions/IVpnLoggingConfig!contract"
        | doc m%"
          Use this configuration to define CloudWatch log groups for your Site-to-Site VPN connections.
          AWS Site-to-Site VPN logs provide you with deeper visibility into your Site-to-Site VPN deployments.
          With this feature, you have access to Site-to-Site VPN connection logs that provide details on IP Security (IPsec) tunnel establishment,
          Internet Key Exchange (IKE) negotiations, and dead peer detection (DPD) protocol messages.
        "%
        = {
            enable
              | Bool
              | doc "(OPTIONAL) Enable site-to-site VPN tunnel logging to CloudWatch Logs."
              | optional,
            logGroupName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                (OPTIONAL) The name of the CloudWatch Logs log group that you would like tunnel logs to be sent to.
                
                Default - Randomly generated name based on CDK stack and VPN resource name.
              "%
              | optional,
            outputFormat
              | _js2n__-refsenv."_js2n__-:definitions/VpnLoggingOutputFormatType!contract"
              | doc m%"
                (OPTIONAL) The output format of the VPN tunnel logs.
                
                Default - `json`
              "%
              | optional,
          },
      "_js2n__-:definitions/IVpnTunnelOptionsSpecificationsConfig!contract"
        | doc m%"
          Use this configuration to define optional tunnel configurations for a site-to-site VPN connection.
          
          **IMPORTANT**: After initial deployment of your VPN connection with any of the v1.5.0+ options noted below, you can only make property changes to one VPN tunnel per core pipeline run.
          You may make multiple property changes in that one VPN tunnel if necessary. Trying to modify properties in both tunnels will result in a pipeline failure. This is due to the fact that
          only a single mutating API call can be made at a time for AWS Site-to-Site VPN connections.
          
          Note: you may manually roll back the resulting CloudFormation stack should you encounter this failure. More details on how to skip failed resources in the following reference:
          https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-continueupdaterollback.html
        "%
        = {
            dpdTimeoutAction
              | _js2n__-refsenv."_js2n__-:definitions/DpdTimeoutActionType!contract"
              | doc m%"
                (OPTIONAL) Dead Peer Detection (DPD) timeout action. You can specify the action to take after DPD timeout occurs.
                
                Default - `clear`
              "%
              | optional,
            dpdTimeoutSeconds
              | Number
              | doc m%"
                (OPTIONAL) The duration, in seconds, after which Dead Peer Detection (DPD) timeout occurs.
                
                Default - `30`
              "%
              | optional,
            ikeVersions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IkeVersionType!contract"
              | doc m%"
                (OPTIONAL) The Internet Key Exchange (IKE) versions that are permitted on the tunnel.
                
                Default - `ikev1`,`ikev2`
              "%
              | optional,
            logging
              | _js2n__-refsenv."_js2n__-:definitions/IVpnLoggingConfig!contract"
              | doc "(OPTIONAL) Site-to-Site VPN CloudWatch logging configuration."
              | optional,
            phase1
              | _js2n__-refsenv."_js2n__-:definitions/IPhase1Config!contract"
              | doc "(OPTIONAL) Internet Key Exchange (IKE) phase 1 configuration."
              | optional,
            phase2
              | _js2n__-refsenv."_js2n__-:definitions/IPhase2Config!contract"
              | doc "(OPTIONAL) Internet Key Exchange (IKE) phase 2 configuration."
              | optional,
            preSharedKey
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL): The Secrets Manager name that stores the pre-shared key (PSK), that exists in the same account and region that the VPN Connection will be created in."
              | optional,
            rekeyFuzzPercentage
              | Number
              | doc m%"
                (OPTIONAL) The percentage of the rekey window (determined by the rekey margin time) within which the rekey time is randomly selected.
                
                Default - `100`
              "%
              | optional,
            rekeyMarginTimeSeconds
              | Number
              | doc m%"
                (OPTIONAL) The margin time in seconds before the phase 1 and phase 2 lifetime expires, during which the AWS side of the VPN connection performs an IKE rekey.
                
                Default - `270` (4.5 minutes)
              "%
              | optional,
            replayWindowSize
              | Number
              | doc m%"
                (OPTIONAL) The number of packets in an IKE replay window.
                
                Default - `1024`
              "%
              | optional,
            startupAction
              | _js2n__-refsenv."_js2n__-:definitions/StartupActionType!contract"
              | doc m%"
                (OPTIONAL) The action to take when the establishing the tunnel for the VPN connection. By default, your customer gateway device must initiate the IKE negotiation and bring up the tunnel. Specify `start` for Amazon Web Services to initiate the IKE negotiation.
                
                Default - `add`
              "%
              | optional,
            tunnelInsideCidr
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL): The range of inside IP addresses for the tunnel. Any specified CIDR blocks must be unique across all VPN connections that use the same virtual private gateway."
              | optional,
            tunnelLifecycleControl
              | Bool
              | doc "(OPTIONAL) Enable tunnel endpoint lifecycle control. This feature provides control over the schedule of endpoint replacements. For more information, see  {@link  https://docs.aws.amazon.com/vpn/latest/s2svpn/tunnel-endpoint-lifecycle.html Tunnel Endpoint Lifecycle Control } ."
              | optional,
          },
      "_js2n__-:definitions/IkeVersionType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.enum [ 1, 2 ]
              ]),
      "_js2n__-:definitions/InstanceTenancyType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'dedicated, '"default" |] ],
      "_js2n__-:definitions/IntegrityAlgorithmType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'SHA2-512, 'SHA2-384, 'SHA2-256, 'SHA1 |]
            ],
      "_js2n__-:definitions/IpAddressFamilyType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'IPv6, 'IPv4 |] ],
      "_js2n__-:definitions/IpVersionType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'ipv6, 'ipv4 |] ],
      "_js2n__-:definitions/LoadBalancerSchemeEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'internal, 'internet-facing |] ],
      "_js2n__-:definitions/LogDestinationType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'cloud-watch-logs, 's3 |] ],
      "_js2n__-:definitions/MutationProtectionType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'DISABLED, 'ENABLED |] ],
      "_js2n__-:definitions/NetbiosNodeType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.enum [ 1, 2, 4, 8 ]
              ]),
      "_js2n__-:definitions/NfwGeneratedRulesType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'DENYLIST, 'ALLOWLIST |] ],
      "_js2n__-:definitions/NfwLogType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'FLOW, 'ALERT |] ],
      "_js2n__-:definitions/NfwRuleType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'STATELESS, 'STATEFUL |] ],
      "_js2n__-:definitions/NfwStatefulDefaultActionType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                '"aws:alert_established",
                '"aws:alert_strict",
                '"aws:drop_established",
                '"aws:drop_strict"
              |]
            ],
      "_js2n__-:definitions/NfwStatefulRuleActionType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'PASS, 'DROP, 'ALERT |] ],
      "_js2n__-:definitions/NfwStatefulRuleDirectionType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'FORWARD, 'ANY |] ],
      "_js2n__-:definitions/NfwStatefulRuleOptionsType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'STRICT_ORDER, 'DEFAULT_ACTION_ORDER |]
            ],
      "_js2n__-:definitions/NfwStatefulRuleProtocolType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'UDP,
                'TLS,
                'TFTP,
                'TCP,
                'SSH,
                'SMTP,
                'SMB,
                'NTP,
                'MSN,
                'KRB5,
                'IP,
                'IMAP,
                'IKEV2,
                'ICMP,
                'HTTP,
                'FTP,
                'DNS,
                'DHCP,
                'DCERPC
              |]
            ],
      "_js2n__-:definitions/NfwStatelessRuleActionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "aws:pass", "aws:drop", "aws:forward_to_sfe" ]
            ],
      "_js2n__-:definitions/NfwStatelessRuleTcpFlagType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'CWR, 'ECE, 'URG, 'ACK, 'PSH, 'RST, 'SYN, 'FIN |]
            ],
      "_js2n__-:definitions/NfwTargetType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'HTTP_HOST, 'TLS_SNI |] ],
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
      "_js2n__-:definitions/Phase1DhGroupType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.enum
                  [ 2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 ]
              ]),
      "_js2n__-:definitions/Phase2DhGroupType!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.enum
                  [ 2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 ]
              ]),
      "_js2n__-:definitions/Region!contract"
        | doc "AWS Region"
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'us-west-2,
                'us-west-1,
                'us-isof-east-1,
                'us-isof-south-1,
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
                'eu-isoe-west-1,
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
                'ap-southeast-5,
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
      "_js2n__-:definitions/Region!predicate"
        | doc "AWS Region"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "af-south-1",
                  "ap-east-1",
                  "ap-northeast-1",
                  "ap-northeast-2",
                  "ap-northeast-3",
                  "ap-south-1",
                  "ap-south-2",
                  "ap-southeast-1",
                  "ap-southeast-2",
                  "ap-southeast-3",
                  "ap-southeast-4",
                  "ap-southeast-5",
                  "ca-central-1",
                  "ca-west-1",
                  "cn-north-1",
                  "cn-northwest-1",
                  "eu-central-1",
                  "eu-central-2",
                  "eu-north-1",
                  "eu-south-1",
                  "eu-south-2",
                  "eu-west-1",
                  "eu-west-2",
                  "eu-west-3",
                  "eu-isoe-west-1",
                  "il-central-1",
                  "me-central-1",
                  "me-south-1",
                  "sa-east-1",
                  "us-east-1",
                  "us-east-2",
                  "us-gov-west-1",
                  "us-gov-east-1",
                  "us-iso-east-1",
                  "us-isob-east-1",
                  "us-iso-west-1",
                  "us-isof-south-1",
                  "us-isof-east-1",
                  "us-west-1",
                  "us-west-2"
                ]
            ],
      "_js2n__-:definitions/ResolverEndpointType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'OUTBOUND, 'INBOUND |] ],
      "_js2n__-:definitions/RouteTableEntryType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'vpcPeering,
                'virtualPrivateGateway,
                'networkInterface,
                'networkFirewall,
                'gatewayLoadBalancerEndpoint,
                'gatewayEndpoint,
                'localGateway,
                'local,
                'egressOnlyIgw,
                'internetGateway,
                'natGateway,
                'transitGateway
              |]
            ],
      "_js2n__-:definitions/RoutingHttpXffHeaderProcessingModeEnum!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'remove, 'preserve, 'append |] ],
      "_js2n__-:definitions/RuleType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'SYSTEM, 'RECURSIVE, 'FORWARD |] ],
      "_js2n__-:definitions/SecurityGroupRuleType!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'ALL,
                'ICMP,
                'UDP,
                'TCP,
                'ORACLE-RDS,
                'POSTGRESQL,
                'REDSHIFT,
                '"MYSQL/AURORA",
                'MSSQL,
                'HTTPS,
                'HTTP,
                'SSH,
                'RDP
              |]
            ],
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
                'ELBSecurityPolicy-TLS-1-0-2015-04,
                'ELBSecurityPolicy-TLS13-1-3-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-0-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-1-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Ext2-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Ext1-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Ext0-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Res-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-3-2021-06,
                'ELBSecurityPolicy-TLS13-1-0-2021-06,
                'ELBSecurityPolicy-TLS13-1-1-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Ext2-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Ext1-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Res-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-2021-06
              |]
            ],
      "_js2n__-:definitions/SslPolicyNlbEnum!contract" =
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
                'ELBSecurityPolicy-TLS-1-0-2015-04,
                'ELBSecurityPolicy-TLS13-1-3-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-0-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-1-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Ext2-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Ext1-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Ext0-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-Res-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-2-FIPS-2023-04,
                'ELBSecurityPolicy-TLS13-1-3-2021-06,
                'ELBSecurityPolicy-TLS13-1-0-2021-06,
                'ELBSecurityPolicy-TLS13-1-1-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Ext2-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Ext1-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-Res-2021-06,
                'ELBSecurityPolicy-TLS13-1-2-2021-06
              |]
            ],
      "_js2n__-:definitions/StartupActionType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'start, 'add |] ],
      "_js2n__-:definitions/StorageClass!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'ONEZONE_IA,
                'INTELLIGENT_TIERING,
                'STANDARD_IA,
                'GLACIER_IR,
                'GLACIER,
                'DEEP_ARCHIVE
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
      "_js2n__-:definitions/TrafficType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'REJECT, 'ACCEPT, 'ALL |] ],
      "_js2n__-:definitions/TransitGatewayConnectProtocol!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.const "gre"
              ]),
      "_js2n__-:definitions/VpnLoggingOutputFormatType!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'text, 'json |] ],
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/INetworkConfig!contract"