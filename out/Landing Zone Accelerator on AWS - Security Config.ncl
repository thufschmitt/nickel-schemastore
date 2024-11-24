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
      "_js2n__-:definitions/IAccessAnalyzerConfig!contract"
        | doc "AWS AccessAnalyzer configuration"
        = {
            enable
              | Bool
              | doc "Indicates whether AWS AccessAnalyzer enabled in your organization.",
          },
      "_js2n__-:definitions/IAlarmConfig!contract"
        | doc "AWS CloudWatch Alarm configuration"
        = {
            alarmDescription
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Description for the alarm",
            alarmName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the alarm",
            comparisonOperator
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Comparison to use to check if metric is breaching",
            evaluationPeriods
              | Number
              | doc "The number of periods over which data is compared to the specified threshold.",
            metricName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the metric.",
            namespace
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Namespace of the metric.",
            period
              | Number
              | doc "The period over which the specified statistic is applied.",
            snsAlertLevel
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Alert SNS notification level Deprecated"
              | optional,
            snsTopicName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) SNS Topic Name SNS Topic Name from global config"
              | optional,
            statistic
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                What functions to use for aggregating.
                
                Can be one of the following:
                -  “Minimum” | “min”
                -  “Maximum” | “max”
                -  “Average” | “avg”
                -  “Sum” | “sum”
                -  “SampleCount | “n”
                -  “pNN.NN”
              "%,
            threshold
              | Number
              | doc "The value against which the specified statistic is compared.",
            treatMissingData
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Sets how this alarm is to handle missing data points.",
          },
      "_js2n__-:definitions/IAlarmSetConfig!contract"
        | doc "AWS CloudWatch Alarm sets"
        = {
            alarms
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IAlarmConfig!contract"
              | doc m%"
                List of AWS CloudWatch Alarms
                
                Following example will create CIS-1.1-RootAccountUsage alarm for RootAccountUsage metric with notification level low
              "%,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "Deployment targets for CloudWatch Alarms configuration",
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "AWS region names to configure CloudWatch Alarms"
              | optional,
          },
      "_js2n__-:definitions/IAuditManagerConfig!contract"
        | doc "Use this configuration to enable AWS Audit Manager for an AWS Organization."
        = {
            defaultReportsConfiguration
              | _js2n__-refsenv."_js2n__-:definitions/IAuditManagerDefaultReportsDestinationConfig!contract"
              | doc "AWS Audit Manager Default Reports configuration.",
            enable | Bool | doc "Indicates whether AWS Audit Manager enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring AWS Audit Manager. Please ensure any regions enabled in the global configuration that do not support Audit Manager are added to the excluded regions list.  {@link  https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/ Supported services by region } ."
              | optional,
            lifecycleRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ILifecycleRule!contract"
              | doc "(OPTIONAL) Declaration of a S3 Lifecycle rule."
              | optional,
          },
      "_js2n__-:definitions/IAuditManagerDefaultReportsDestinationConfig!contract"
        | doc m%"
          AWS Audit Manager Default Reports Destination configuration.
          Use this configuration to enable a destination for reports generated by AWS Audit Manager.
        "%
        = {
            destinationType
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.const "S3"
                  ])
              | doc "The type of resource for the publishing destination. Currently only Amazon S3 buckets are supported.",
            enable
              | Bool
              | doc "Indicates whether AWS Audit Manager Default Reports enabled.",
          },
      "_js2n__-:definitions/IAwsConfig!contract"
        | doc "AWS Config Recorder and Rules"
        = {
            aggregation
              | _js2n__-refsenv."_js2n__-:definitions/IAwsConfigAggregation!contract"
              | doc "Config Recorder Aggregation configuration"
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc m%"
                (OPTIONAL) AWS Config deployment target.
                
                Leaving `deploymentTargets` undefined will enable AWS Config across all accounts and enabled regions.
                
                We highly recommend enabling AWS Config across all accounts and enabled regions within your organization. `deploymentTargets` should only be used when more granular control is required, not as a default configuration.
                
                To enable AWS Config into Infrastructure organizational unit, you need to provide below value for this parameter.
                
                Note: The delegated admin account defined in centralSecurityServices will always have AwsConfig enabled
              "%
              | optional,
            enableConfigurationRecorder
              | Bool
              | doc m%"
                Indicates whether AWS Config recorder enabled.
                
                To enable AWS Config, you must create a configuration recorder
                
                ConfigurationRecorder resource describes the AWS resource types for which AWS Config records configuration changes. The configuration recorder stores the configurations of the supported resources in your account as configuration items.
              "%,
            enableDeliveryChannel
              | Bool
              | doc m%"
                Indicates whether delivery channel enabled.
                
                AWS Config uses the delivery channel to deliver the configuration changes to your Amazon S3 bucket. DEPRECATED
              "%
              | optional,
            overrideExisting
              | Bool
              | doc m%"
                Indicates whether or not to override existing config recorder settings Must be enabled if any account and region combination has an existing config recorder, even if config recording is turned off The Landing Zone Accelerator will override the settings in all configured accounts and regions
                ** Do not enable this setting if you have deployed LZA
                ** successfully with enableConfigurationRecorder set to true
                ** and overrideExisting either unset or set to false
                ** Doing so will cause a resource conflict When the overrideExisting property is enabled ensure that any scp's are not blocking the passRole iam permission for the iam role name {acceleratorPrefix}Config
              "%
              | optional,
            ruleSets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IAwsConfigRuleSet!contract"
              | doc "AWS Config rule sets"
              | optional,
          },
      "_js2n__-:definitions/IAwsConfigAggregation!contract"
        | doc m%"
          AWS Config Aggregation Configuration
          Not used in Control Tower environment
          Aggregation will be configured in all enabled regions
          unless specifically excluded
          If the delegatedAdmin account is not provided
          config will be aggregated to the management account
        "%
        = {
            delegatedAdminAccount
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | optional,
            enable | Bool,
          },
      "_js2n__-:definitions/IAwsConfigRuleSet!contract"
        | doc "List of AWS Config rules"
        = {
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc m%"
                Config ruleset deployment target.
                
                To configure AWS Config rules into Root and Infrastructure organizational units, you need to provide below value for this parameter.
              "%,
            rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IConfigRule!contract"
              | doc m%"
                AWS Config rule set
                
                Following example will create a custom rule named accelerator-attach-ec2-instance-profile with remediation and a managed rule named accelerator-iam-user-group-membership-check without remediation
              "%,
          },
      "_js2n__-:definitions/ICentralSecurityServicesConfig!contract"
        | doc "AWS Accelerator central security services configuration"
        = {
            auditManager
              | _js2n__-refsenv."_js2n__-:definitions/IAuditManagerConfig!contract"
              | doc "(OPTIONAL) Amazon Audit Manager Configuration"
              | optional,
            delegatedAdminAccount
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Designated administrator account name for accelerator security services. AWS organizations designate a member account as a delegated administrator for the organization users and roles from that account can perform administrative actions for security services like Macie, GuardDuty, Detective and Security Hub. Without designated administrator account administrative tasks for security services are performed only by users or roles in the organization's management account. This helps you to separate management of the organization from management of these security services. Accelerator use Audit account as designated administrator account.",
            detective
              | _js2n__-refsenv."_js2n__-:definitions/IDetectiveConfig!contract"
              | doc "(OPTIONAL) Amazon Detective Configuration"
              | optional,
            ebsDefaultVolumeEncryption
              | _js2n__-refsenv."_js2n__-:definitions/IEbsDefaultVolumeEncryptionConfig!contract"
              | doc m%"
                AWS Elastic Block Store default encryption configuration
                
                Accelerator use this parameter to configure EBS default encryption. Accelerator will create KMS key for every AWS environment (account and region), which will be used as default EBS encryption key.
                
                To enable EBS default encryption in every region accelerator implemented, you need to provide below value for this parameter.
              "%,
            guardduty
              | _js2n__-refsenv."_js2n__-:definitions/IGuardDutyConfig!contract"
              | doc "Amazon GuardDuty Configuration",
            macie
              | _js2n__-refsenv."_js2n__-:definitions/IMacieConfig!contract"
              | doc m%"
                Amazon Macie Configuration
                
                Accelerator use this parameter to define AWS Macie configuration.
                
                To enable Macie in every region accelerator implemented and set fifteen minutes of frequency to publish updates to policy findings for the account with publishing sensitive data findings to Security Hub. you need to provide below value for this parameter.
              "%,
            s3PublicAccessBlock
              | _js2n__-refsenv."_js2n__-:definitions/IS3PublicAccessBlockConfig!contract"
              | doc m%"
                AWS S3 public access block configuration
                
                Accelerator use this parameter to block AWS S3 public access
                
                To enable S3 public access blocking in every region accelerator implemented, you need to provide below value for this parameter.
              "%,
            scpRevertChangesConfig
              | _js2n__-refsenv."_js2n__-:definitions/IScpRevertChangesConfig!contract"
              | doc "(OPTIONAL) AWS Service Control Policies Revert Manual Changes configuration"
              | optional,
            securityHub
              | _js2n__-refsenv."_js2n__-:definitions/ISecurityHubConfig!contract"
              | doc m%"
                AWS Security Hub configuration
                
                Accelerator use this parameter to define AWS Security Hub configuration.
                
                To enable AWS Security Hub for all regions and enable "AWS Foundational Security Best Practices v1.0.0" security standard, deployment targets and disable controls you need provide below value for this parameter.
              "%,
            snsSubscriptions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISnsSubscriptionConfig!contract"
              | doc m%"
                AWS SNS subscription configuration Deprecated
                
                NOTICE: The configuration of SNS topics is being moved to the Global Config. This block is deprecated and will be removed in a future release
                
                Accelerator use this parameter to define AWS SNS notification configuration.
                
                To enable high, medium and low SNS notifications, you need to provide below value for this parameter.
              "%
              | optional,
            ssmAutomation
              | _js2n__-refsenv."_js2n__-:definitions/ISsmAutomationConfig!contract"
              | doc m%"
                AWS Systems Manager Document configuration
                
                Accelerator use this parameter to define AWS Systems Manager documents configuration. SSM documents are created in designated administrator account for security services, i.e. Audit account.
                
                To create a SSM document named as "SSM-ELB-Enable-Logging" in every region accelerator implemented and share this document with Root organizational unit(OU), you need to provide below value for this parameter. To share document to specific account uncomment accounts list. A valid SSM document template file ssm-documents/ssm-elb-enable-logging.yaml must be present in Accelerator config repository. Accelerator will use this template file to create the document.
              "%,
          },
      "_js2n__-:definitions/ICloudWatchConfig!contract"
        | doc "AWS CloudWatch configuration"
        = {
            alarmSets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IAlarmSetConfig!contract"
              | doc m%"
                List AWS CloudWatch Alarms configuration
                
                Following example will create CIS-1.1-RootAccountUsage alarm for RootAccountUsage metric with notification level low
              "%,
            logGroups
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ILogGroupsConfig!contract"
              | doc m%"
                (OPTIONAL) List CloudWatch Logs configuration
                
                The Following is an example of deploying CloudWatch Logs to multiple regions
              "%
              | optional,
            metricSets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IMetricSetConfig!contract"
              | doc m%"
                List AWS CloudWatch Metrics configuration
                
                Following example will create metric filter RootAccountMetricFilter for aws-controltower/CloudTrailLogs log group
              "%,
          },
      "_js2n__-:definitions/IConfigRule!contract"
        | doc "AWS ConfigRule configuration"
        = {
            complianceResourceTypes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Defines which resources trigger an evaluation for an AWS Config rule."
              | optional,
            customRule
              | _js2n__-refsenv."_js2n__-:definitions/ICustomRuleConfigType!contract"
              | doc "(OPTIONAL) A custom config rule is backed by AWS Lambda function. This is required when creating custom config rule."
              | optional,
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description about this AWS Config rule."
              | optional,
            identifier
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The identifier of the AWS managed rule."
              | optional,
            inputParameters
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!predicate"
                      ],
                    _js2n__-prdslib.isType 'Null
                  ])
              | doc "(OPTIONAL) Input parameter values that are passed to the AWS Config rule."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "A name for the AWS Config rule.",
            remediation
              | _js2n__-refsenv."_js2n__-:definitions/IConfigRuleRemediationType!contract"
              | doc "A remediation for the config rule, auto remediation to automatically remediate noncompliant resources."
              | optional,
            tags
              | Array _js2n__-refsenv."_js2n__-:definitions/ITag!contract"
              | doc "(OPTIONAL) Tags for the config rule"
              | optional,
            type
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Config rule type Managed or Custom. For custom config rule, this parameter value is Custom, when creating managed config rule this parameter value can be undefined or empty string"
              | optional,
          },
      "_js2n__-:definitions/IConfigRuleRemediationType!contract" =
        {
            automatic
              | Bool
              | doc "The remediation is triggered automatically.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "List of AWS Region names to be excluded from applying remediation"
              | optional,
            maximumAutomaticAttempts
              | Number
              | doc m%"
                The maximum number of failed attempts for auto-remediation. If you do not select a number, the default is 5.
                
                For example, if you specify MaximumAutomaticAttempts as 5 with RetryAttemptSeconds as 50 seconds, AWS Config will put a RemediationException on your behalf for the failing resource after the 5th failed attempt within 50 seconds.
              "%
              | optional,
            parameters
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IRemediationParametersConfigType!contract"
              | doc "List of remediation parameters"
              | optional,
            retryAttemptSeconds
              | Number
              | doc m%"
                Maximum time in seconds that AWS Config runs auto-remediation. If you do not select a number, the default is 60 seconds.
                
                For example, if you specify RetryAttemptSeconds as 50 seconds and MaximumAutomaticAttempts as 5, AWS Config will run auto-remediations 5 times within 50 seconds before throwing an exception.
              "%
              | optional,
            rolePolicyFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                Remediation assume role policy definition json file. This file must be present in config repository.
                
                Create your own custom remediation actions using AWS Systems Manager Automation documents. When a role needed to be created to perform custom remediation actions, role permission needs to be defined in this file.
              "%,
            targetAccountName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the account owning the public document to perform custom remediation actions. Accelerator creates these documents in Audit account and shared with other accounts."
              | optional,
            targetDocumentLambda
              | _js2n__-refsenv."_js2n__-:definitions/ICustomRuleLambdaType!contract"
              | doc "Target SSM document remediation lambda function"
              | optional,
            targetId
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                Target ID is the name of the public document.
                
                The name of the AWS SSM document to perform custom remediation actions.
              "%,
            targetVersion
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                Version of the target. For example, version of the SSM document.
                
                If you make backward incompatible changes to the SSM document, you must call PutRemediationConfiguration API again to ensure the remediations can run.
              "%
              | optional,
          },
      "_js2n__-:definitions/ICustomRuleConfigType!contract" =
        {
            configurationChanges
              | Bool
              | doc m%"
                Whether to run the rule on configuration changes.
                
                Default: false
              "%
              | optional,
            lambda
              | _js2n__-refsenv."_js2n__-:definitions/ICustomRuleLambdaType!contract"
              | doc "The Lambda function to run.",
            maximumExecutionFrequency
              | String
              | doc m%"
                The maximum frequency at which the AWS Config rule runs evaluations.
                
                Default: MaximumExecutionFrequency.TWENTY_FOUR_HOURS
              "%,
            periodic
              | Bool
              | doc "Whether to run the rule on a fixed frequency."
              | optional,
            triggeringResources
              | _js2n__-refsenv."_js2n__-:definitions/ITriggeringResourceType!contract"
              | doc "Defines which resources trigger an evaluation for an AWS Config rule.",
          },
      "_js2n__-:definitions/ICustomRuleLambdaType!contract" =
        {
            handler
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the method within your code that Lambda calls to execute your function. The format includes the file name. It can also include namespaces and other qualifiers, depending on the runtime. For more information, see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-features.html#gettingstarted-features-programmingmodel.",
            rolePolicyFile
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Lambda execution role policy definition file",
            runtime
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The runtime environment for the Lambda function that you are uploading. For valid values, see the Runtime property in the AWS Lambda Developer Guide.",
            sourceFilePath
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The source code file path of your Lambda function. This is a zip file containing lambda function, this file must be available in config repository.",
            timeout
              | Number
              | doc "Lambda function execution timeout in seconds"
              | optional,
          },
      "_js2n__-:definitions/IDeploymentTargets!contract" =
        {
            accounts | Array (String) | optional,
            excludedAccounts | Array (String) | optional,
            excludedRegions | Array (String) | optional,
            organizationalUnits | Array (String) | optional,
          },
      "_js2n__-:definitions/IDetectiveConfig!contract"
        | doc m%"
          Use this configuration to enable Amazon Detective for an AWS Organization that allows users to analyze, investigate, and
          quickly identify the root cause of security findings or suspicious activities.
        "%
        = {
            enable
              | Bool
              | doc "Indicates whether Amazon Detective is enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring Amazon Detective. Please ensure any regions enabled in the global configuration that do not support Amazon Detective are added to the excluded regions list.  {@link  https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/ Supported services by region } ."
              | optional,
          },
      "_js2n__-:definitions/IDocumentConfig!contract"
        | doc m%"
          Use this configuration to define AWS System Manager documents (SSM documents) that can be used on managed instances in an
          environment.
        "%
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of document to be created",
            targetType
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Specify a target type to define the kinds of resources the document can run on. For example, to run a document on EC2 instances, specify the following value: /AWS::EC2::Instance. If you specify a value of '/' the document can run on all types of resources. If you don't specify a value, the document can't run on any resources. For a list of valid resource types, see AWS resource and property types reference in the AWS CloudFormation User Guide. Ref: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html Length Constraints: Maximum length of 200. Pattern: ^\\/[\\w\\.\\-\\:\\/]*$"
              | optional,
            template
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Document template file path. This file must be available in accelerator config repository.",
          },
      "_js2n__-:definitions/IDocumentSetConfig!contract"
        | doc "AWS Systems Manager document sharing configuration"
        = {
            documents
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDocumentConfig!contract"
              | doc "List of the documents to be shared",
            shareTargets
              | _js2n__-refsenv."_js2n__-:definitions/IShareTargets!contract"
              | doc "Document share target, valid value should be any organizational unit. Document will be shared with every account within the given OU",
          },
      "_js2n__-:definitions/IEbsDefaultVolumeEncryptionConfig!contract"
        | doc "Use this configuration to enable enforced encryption of new EBS volumes and snapshots created in an AWS environment."
        = {
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "(OPTIONAL) Deployment targets for EBS default volume encryption"
              | optional,
            enable
              | Bool
              | doc "Indicates whether AWS EBS volume have default encryption enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring AWS EBS volume default encryption"
              | optional,
            kmsKey
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) KMS key to encrypt EBS volume."
              | optional,
          },
      "_js2n__-:definitions/IEncryptionConfig!contract"
        | doc "Use this configuration to enable encryption for a log group."
        = {
            kmsKeyArn
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Reference the KMS Key Arn that is used to encrypt the AWS CloudWatch Logs Group. This should be a KMS Key that is not managed by Landing Zone Accelerator."
              | optional,
            kmsKeyName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Use this property to reference a KMS Key Name that is created by Landing Zone Accelerator."
              | optional,
            useLzaManagedKey
              | Bool
              | doc "(OPTIONAL) Set this property to `true` if you would like to use the default CloudWatch Logs KMS CMK that is deployed by Landing Zone Accelerator."
              | optional,
          },
      "_js2n__-:definitions/IGuardDutyConfig!contract"
        | doc m%"
          AWS GuardDuty configuration
          Use this configuration to enable Amazon GuardDuty for an AWS Organization, as well as other modular
          feature protections.
        "%
        = {
            autoEnableOrgMembers
              | Bool
              | doc m%"
                (OPTIONAL) Enables/disables the auto enabling of GuardDuty for any account including the new accounts joining the organization
                
                It is recommended to set the value to `false` when using the `deploymentTargets` property to enable GuardDuty only on targeted accounts mentioned in the deploymentTargets. If you do not define or do not set it to `false` any new accounts joining the organization will automatically be enabled with GuardDuty.
              "%
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc m%"
                (OPTIONAL) Deployment targets for GuardDuty
                
                We highly recommend enabling GuardDuty across all accounts and enabled regions within your organization. `deploymentTargets` should only be used when more granular control is required, not as a default configuration Please only specify one of the `deploymentTargets` or `excludeRegions` properties.
                
                Note: The delegated admin account defined in centralSecurityServices will always have GuardDuty enabled
              "%
              | optional,
            eksProtection
              | _js2n__-refsenv."_js2n__-:definitions/IGuardDutyEksProtectionConfig!contract"
              | doc "(OPTIONAL) AWS GuardDuty EKS Protection configuration."
              | optional,
            enable | Bool | doc "Indicates whether AWS GuardDuty enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc m%"
                (OPTIONAL) List of AWS Region names to be excluded from configuring Amazon GuardDuty
                
                Please only specify one of the `excludeRegions` or `deploymentTargets` properties.
              "%
              | optional,
            exportConfiguration
              | _js2n__-refsenv."_js2n__-:definitions/IGuardDutyExportFindingsConfig!contract"
              | doc "AWS GuardDuty Export Findings configuration.",
            lifecycleRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ILifecycleRule!contract"
              | doc "(OPTIONAL) Declaration of a S3 Lifecycle rule."
              | optional,
            s3Protection
              | _js2n__-refsenv."_js2n__-:definitions/IGuardDutyS3ProtectionConfig!contract"
              | doc "AWS GuardDuty S3 Protection configuration.",
          },
      "_js2n__-:definitions/IGuardDutyEksProtectionConfig!contract"
        | doc "AWS GuardDuty EKS Protection configuration."
        = {
            enable
              | Bool
              | doc "Indicates whether AWS GuardDuty EKS Protection enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring Amazon GuardDuty EKS Protection"
              | optional,
          },
      "_js2n__-:definitions/IGuardDutyExportFindingsConfig!contract"
        | doc "Use this configuration to export Amazon GuardDuty findings to Amazon CloudWatch Events, and, optionally, to an Amazon S3 bucket."
        = {
            destinationType
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.const "S3"
                  ])
              | doc "The type of resource for the publishing destination. Currently only Amazon S3 buckets are supported.",
            enable
              | Bool
              | doc "Indicates whether AWS GuardDuty Export Findings enabled.",
            exportFrequency
              | std.enum.TagOrString
              | [| 'SIX_HOURS, 'ONE_HOUR, 'FIFTEEN_MINUTES |]
              | doc "An enum value that specifies how frequently findings are exported, such as to CloudWatch Events. Possible values FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS",
            overrideExisting
              | Bool
              | doc "(OPTIONAL) Indicates whether AWS GuardDuty Export Findings can be overwritten."
              | optional,
            overrideGuardDutyPrefix
              | _js2n__-refsenv."_js2n__-:definitions/IPrefixConfig!contract"
              | doc "(OPTIONAL) AWS GuardDuty Prefix for centralized logging path."
              | optional,
          },
      "_js2n__-:definitions/IGuardDutyS3ProtectionConfig!contract"
        | doc m%"
          Use this configuration to enable S3 Protection with Amazon GuardDuty to monitor object-level API operations for potential
          security risks for data within Amazon S3 buckets.
        "%
        = {
            enable
              | Bool
              | doc "Indicates whether AWS GuardDuty S3 Protection enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring Amazon GuardDuty S3 Protection"
              | optional,
          },
      "_js2n__-:definitions/IIamPasswordPolicyConfig!contract"
        | doc "IAM password policy configuration"
        = {
            allowUsersToChangePassword
              | Bool
              | doc "Allows all IAM users in your account to use the AWS Management Console to change their own passwords.",
            hardExpiry
              | Bool
              | doc "Prevents IAM users who are accessing the account via the AWS Management Console from setting a new console password after their password has expired. The IAM user cannot access the console until an administrator resets the password.",
            maxPasswordAge
              | Number
              | doc m%"
                The number of days that an IAM user password is valid.
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of 0. The result is that IAM user passwords never expire.
              "%,
            minimumPasswordLength
              | Number
              | doc m%"
                The minimum number of characters allowed in an IAM user password.
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of 6.
              "%,
            passwordReusePrevention
              | Number
              | doc m%"
                Specifies the number of previous passwords that IAM users are prevented from reusing.
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of 0. The result is that IAM users are not prevented from reusing previous passwords.
              "%,
            requireLowercaseCharacters
              | Bool
              | doc m%"
                Specifies whether IAM user passwords must contain at least one lowercase character from the ISO basic Latin alphabet (a to z).
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of false. The result is that passwords do not require at least one lowercase character.
              "%,
            requireNumbers
              | Bool
              | doc m%"
                Specifies whether IAM user passwords must contain at least one numeric character (0 to 9).
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of false. The result is that passwords do not require at least one numeric character.
              "%,
            requireSymbols
              | Bool
              | doc m%"
                Specifies whether IAM user passwords must contain at least one of the following non-alphanumeric characters:
                
                ! @ # $ % ^ & * ( ) _ + - = [ ] { } | '
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of false. The result is that passwords do not require at least one symbol character.
              "%,
            requireUppercaseCharacters
              | Bool
              | doc m%"
                Specifies whether IAM user passwords must contain at least one uppercase character from the ISO basic Latin alphabet (A to Z).
                
                Note: If you do not specify a value for this parameter, then the operation uses the default value of false. The result is that passwords do not require at least one uppercase character.
              "%,
          },
      "_js2n__-:definitions/IKeyConfig!contract"
        | doc m%"
          Use this configuration to define your customer managed key (CMK) and where it's deployed to along with
          it's management properties.
        "%
        = {
            alias
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) Initial alias to add to the key"
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc m%"
                This configuration determines which accounts and/or OUs the CMK is deployed to.
                
                To deploy KMS key into Root and Infrastructure organizational units, you need to provide below value for this parameter.
              "%,
            description
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) A description of the key."
              | optional,
            enableKeyRotation
              | Bool
              | doc "(OPTIONAL) Indicates whether AWS KMS rotates the key."
              | optional,
            enabled
              | Bool
              | doc "(OPTIONAL) Indicates whether the key is available for use."
              | optional,
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Unique Key name for logical reference",
            policy
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL)Key policy file path. This file must be available in accelerator config repository."
              | optional,
            removalPolicy
              | std.enum.TagOrString
              | [| 'snapshot, 'retain, 'destroy |]
              | doc "(OPTIONAL) Whether the encryption key should be retained when it is removed from the Stack."
              | optional,
          },
      "_js2n__-:definitions/IKeyManagementServiceConfig!contract"
        | doc " KMS key management service configuration"
        = {
            keySets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IKeyConfig!contract",
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
      "_js2n__-:definitions/ILogGroupsConfig!contract"
        | doc m%"
          Use this configuration to deploy CloudWatch log groups to your environment.
          You can also import existing log groups into your accelerator configuration.
          Log groups define groups of log streams that share the same retention, monitoring, and access control settings.
        "%
        = {
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "Deployment targets for CloudWatch Logs",
            encryption
              | _js2n__-refsenv."_js2n__-:definitions/IEncryptionConfig!contract"
              | doc "(OPTIONAL) The encryption configuration of the AWS CloudWatch Logs Group."
              | optional,
            logGroupName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the CloudWatch log group",
            logRetentionInDays
              | Number
              | doc m%"
                (OPTIONAL) How long, in days, the log contents will be retained.
                
                To retain all logs, set this value to undefined.
              "%,
            terminationProtected
              | Bool
              | doc "(OPTIONAL) Set this property to `false` if you would like the log group to be deleted if it is removed from the solution configuration file."
              | optional,
          },
      "_js2n__-:definitions/IMacieConfig!contract"
        | doc m%"
          Amazon Macie Configuration
          Use this configuration to enable Amazon Macie within your AWS Organization along with it's reporting configuration.
        "%
        = {
            enable | Bool | doc "Indicates whether AWS Macie enabled.",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "List of AWS Region names to be excluded from configuring Amazon Macie"
              | optional,
            lifecycleRules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ILifecycleRule!contract"
              | doc "(OPTIONAL) Declaration of a S3 Lifecycle rule."
              | optional,
            policyFindingsPublishingFrequency
              | std.enum.TagOrString
              | [| 'SIX_HOURS, 'ONE_HOUR, 'FIFTEEN_MINUTES |]
              | doc "(OPTIONAL) Specifies how often to publish updates to policy findings for the account. This includes publishing updates to Security Hub and Amazon EventBridge (formerly called Amazon CloudWatch Events). An enum value that specifies how frequently findings are published Possible values FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS"
              | optional,
            publishSensitiveDataFindings
              | Bool
              | doc "Specifies whether to publish sensitive data findings to Security Hub. If you set this value to true, Amazon Macie automatically publishes all sensitive data findings that weren't suppressed by a findings filter. The default value is false.",
          },
      "_js2n__-:definitions/IMetricConfig!contract"
        | doc "AWS CloudWatch Metric configuration"
        = {
            filterName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Metric filter name",
            filterPattern
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Pattern to search for log events.",
            logGroupName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The log group to create the filter on.",
            metricName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The name of the metric to emit.",
            metricNamespace
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "The namespace of the metric to emit.",
            metricValue
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc m%"
                The value to emit for the metric.
                
                Can either be a literal number (typically “1”), or the name of a field in the structure to take the value from the matched event. If you are using a field value, the field value must have been matched using the pattern.
              "%,
            treatMissingData
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Sets how this alarm is to handle missing data points."
              | optional,
          },
      "_js2n__-:definitions/IMetricSetConfig!contract"
        | doc "AWS CloudWatch Metric set configuration"
        = {
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "Deployment targets for CloudWatch Metrics configuration"
              | optional,
            metrics
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IMetricConfig!contract"
              | doc m%"
                AWS CloudWatch Metric list
                
                Following example will create metric filter RootAccountMetricFilter for aws-controltower/CloudTrailLogs log group
              "%,
            regions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) AWS region names to configure CloudWatch Metrics"
              | optional,
          },
      "_js2n__-:definitions/INetworkPerimeterConfig!contract"
        | doc m%"
          Network Perimeter Config.
          
          If managedVpcOnly is true, all the VPCs in accounts will be included while parameter `ACCEL_LOOKUP:VPC|VPC_ID:XX` is used.
          If managedVpcOnly is false, only the VPC  created by LZA will be included while parameter `ACCEL_LOOKUP:VPC|VPC_ID:XX` is used.
        "%
        = { managedVpcOnly | Bool | optional, },
      "_js2n__-:definitions/IPrefixConfig!contract" =
        {
            customOverride
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(Optional) Prefix to be used for Centralized Logging Path"
              | optional,
            useCustomPrefix
              | Bool
              | doc "Indicates whether or not to add a custom prefix to LZA Default Centralized Logging location. If useCustomPrefix is set to true, logs will be stored in the Centralized Logging Bucket prefix.",
          },
      "_js2n__-:definitions/IRemediationParametersConfigType!contract"
        | doc "Config rule remediation input parameter configuration type"
        = {
            name
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Name of the parameter",
            type
              | std.enum.TagOrString
              | [| 'StringList, '"String" |]
              | doc "Data type of the parameter, allowed value (StringList or String)",
            value
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Parameter value",
          },
      "_js2n__-:definitions/IResourcePolicyConfig!contract" =
        {
            document
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract",
            resourceType
              | std.enum.TagOrString
              | [|
                'LAMBDA_FUNCTION,
                'CERTIFICATE_AUTHORITY,
                'CODEARTIFACT_REPOSITORY,
                'BACKUP_VAULT,
                'EVENTBRIDGE_EVENTBUS,
                'EFS_FILE_SYSTEM,
                'LEX_BOT,
                'APIGATEWAY_REST_API,
                'SQS_QUEUE,
                'SNS_TOPIC,
                'OPENSEARCH_DOMAIN,
                'ECR_REPOSITORY,
                'SECRETS_MANAGER_SECRET,
                'IAM_ROLE,
                'KMS_KEY,
                'S3_BUCKET
              |],
          },
      "_js2n__-:definitions/IResourcePolicyEnforcementConfig!contract"
        | doc m%"
          Resource Policy Enforcement Config. The configuration allows you to deploy AWS Config rules to
          automatically apply resource-based policies to AWS resources including S3 buckets, IAM roles, and KMS keys etc.
          AWS Organization is required to support it.
          
          Here are a list of supported service {@link SecurityConfigTypes.resourceTypeEnum }
        "%
        = {
            enable | Bool,
            networkPerimeter
              | _js2n__-refsenv."_js2n__-:definitions/INetworkPerimeterConfig!contract"
              | optional,
            policySets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IResourcePolicySetConfig!contract",
            remediation
              | _js2n__-refsenv."_js2n__-:definitions/IResourcePolicyRemediation!contract",
          },
      "_js2n__-:definitions/IResourcePolicyRemediation!contract" =
        {
            automatic
              | Bool
              | doc "The remediation is triggered automatically.",
            maximumAutomaticAttempts
              | Number
              | doc "The maximum number of failed attempts for auto-remediation. If you do not select a number, the default is 5."
              | optional,
            retryAttemptSeconds
              | Number
              | doc "Maximum time in seconds that AWS Config runs auto-remediation. If you do not select a number, the default is 60 seconds."
              | optional,
          },
      "_js2n__-:definitions/IResourcePolicySetConfig!contract" =
        {
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "The deployment targets - accounts/OUs where the config rule and remediation action will be deployed to",
            inputParameters
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc m%"
                The input parameters which will be set as environment variable in Custom Config Rule Lambda and Remediation lambda
                
                Meanwhile, 'SourceAccount' is a reserved parameters for allow-only resource policy -- Lambda_Function and CERTIFICATE_AUTHORITY. For example, 'SourceAccount: 123456789012,987654321098' means requests from these two accounts can be allowed. Apart from these two, No other external accounts can access a lambda function or Certificate Authority.
              "%
              | optional,
            resourcePolicies
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IResourcePolicyConfig!contract"
              | doc "A list of resource policy templates for different types of resources",
          },
      "_js2n__-:definitions/IS3PublicAccessBlockConfig!contract"
        | doc "This will create the Public Access Block configuration for the AWS account."
        = {
            enable
              | Bool
              | doc "Indicates whether AWS S3 block public access is enabled.",
            excludeAccounts
              | Array (String)
              | doc "List of AWS Account names to be excluded from configuring S3 PublicAccessBlock"
              | optional,
          },
      "_js2n__-:definitions/IScpRevertChangesConfig!contract"
        | doc "AWS Service Control Policies Revert Manual Changes configuration"
        = {
            enable
              | Bool
              | doc "Indicates whether manual changes to Service Control Policies are automatically reverted.",
            snsTopicName
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) The name of the SNS Topic to send alerts to when SCPs are changed manually"
              | optional,
          },
      "_js2n__-:definitions/ISecurityConfig!contract"
        | doc "Accelerator security configuration"
        = {
            accessAnalyzer
              | _js2n__-refsenv."_js2n__-:definitions/IAccessAnalyzerConfig!contract",
            awsConfig
              | _js2n__-refsenv."_js2n__-:definitions/IAwsConfig!contract",
            centralSecurityServices
              | _js2n__-refsenv."_js2n__-:definitions/ICentralSecurityServicesConfig!contract"
              | doc "Central security configuration",
            cloudWatch
              | _js2n__-refsenv."_js2n__-:definitions/ICloudWatchConfig!contract",
            homeRegion
              | _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "Accelerator home region name."
              | optional,
            iamPasswordPolicy
              | _js2n__-refsenv."_js2n__-:definitions/IIamPasswordPolicyConfig!contract",
            keyManagementService
              | _js2n__-refsenv."_js2n__-:definitions/IKeyManagementServiceConfig!contract"
              | optional,
            resourcePolicyEnforcement
              | _js2n__-refsenv."_js2n__-:definitions/IResourcePolicyEnforcementConfig!contract"
              | optional,
          },
      "_js2n__-:definitions/ISecurityHubConfig!contract"
        | doc "Use this configuration to enable Amazon Security Hub for an AWS Organization along with it's auditing configuration."
        = {
            autoEnableOrgMembers
              | Bool
              | doc m%"
                (OPTIONAL) Enables/disables the auto enabling of SecurityHub for any account including the new accounts joining the organization
                
                It is recommended to set the value to `false` when using the `deploymentTargets` property to enable SecurityHub only on targeted accounts mentioned in the deploymentTargets. If you do not define or do not set it to `false` any new accounts joining the organization will automatically be enabled with SecurityHub.
              "%
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc m%"
                (OPTIONAL) Deployment targets for SecurityHub
                
                We highly recommend enabling SecurityHub across all accounts and enabled regions within your organization. `deploymentTargets` should only be used when more granular control is required, not as a default configuration Please only specify one of the `deploymentTargets` or `excludeRegions` properties.
                
                Note: The delegated admin account defined in centralSecurityServices will always have SecurityHub enabled.
              "%
              | optional,
            enable
              | Bool
              | doc "Indicates whether AWS Security Hub is enabled (AWSConfig is required for enabling SecurityHub)",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring Security Hub"
              | optional,
            logging
              | _js2n__-refsenv."_js2n__-:definitions/ISecurityHubLoggingConfig!contract"
              | doc "(OPTIONAL) Security Hub logs are sent to CloudWatch logs by default. This option can enable or disable the logging."
              | optional,
            notificationLevel
              | String
              | doc "(OPTIONAL) Security Hub notification level"
              | optional,
            regionAggregation
              | Bool
              | doc "(OPTIONAL) Indicates whether Security Hub results are aggregated in the Home Region."
              | optional,
            snsTopicName
              | String
              | doc "(OPTIONAL) SNS Topic for Security Hub notifications."
              | optional,
            standards
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ISecurityHubStandardConfig!contract"
              | doc "Security Hub standards configuration",
          },
      "_js2n__-:definitions/ISecurityHubLoggingCloudwatchConfig!contract"
        | doc "Security Hub Logging CloudWatch Config"
        = {
            enable
              | Bool
              | doc "Security hub to cloudwatch logging is enabled by default.",
            logGroupName
              | String
              | doc "(OPTIONAL) CloudWatch Log Group Name"
              | optional,
            logLevel
              | _js2n__-refsenv."_js2n__-:definitions/SecurityHubSeverityLevel!contract"
              | doc "(OPTIONAL) Security Hub logging level"
              | optional,
          },
      "_js2n__-:definitions/ISecurityHubLoggingConfig!contract"
        | doc "Security Hub Logging Config"
        = {
            cloudWatch
              | _js2n__-refsenv."_js2n__-:definitions/ISecurityHubLoggingCloudwatchConfig!contract"
              | doc "Data store to ship the Security Hub logs to."
              | optional,
          },
      "_js2n__-:definitions/ISecurityHubStandardConfig!contract"
        | doc m%"
          Use this configuration to define the security standard(s) that are enabled through Amazon Security Hub and which accounts and/or
          organization units that the controls are deployed to.
        "%
        = {
            controlsToDisable
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "(OPTIONAL) An array of control names to be disabled for the given security standards"
              | optional,
            deploymentTargets
              | _js2n__-refsenv."_js2n__-:definitions/IDeploymentTargets!contract"
              | doc "(OPTIONAL) Deployment targets for AWS Security Hub standard."
              | optional,
            enable
              | Bool
              | doc "Indicates whether given AWS Security Hub standard enabled.",
            name
              | std.enum.TagOrString
              | [|
                '"",
                '"PCI DSS v3.2.1",
                '"NIST Special Publication 800-53 Revision 5",
                '"CIS AWS Foundations Benchmark v3.0.0",
                '"CIS AWS Foundations Benchmark v1.4.0",
                '"CIS AWS Foundations Benchmark v1.2.0",
                '"AWS Foundational Security Best Practices v1.0.0"
              |]
              | doc "An enum value that specifies one of three security standards supported by Security Hub Possible values are 'AWS Foundational Security Best Practices v1.0.0', 'CIS AWS Foundations Benchmark v1.2.0', 'CIS AWS Foundations Benchmark v1.4.0', 'CIS AWS Foundations Benchmark v3.0.0', 'NIST Special Publication 800-53 Revision 5, and 'PCI DSS v3.2.1'",
          },
      "_js2n__-:definitions/IShareTargets!contract" =
        {
            accounts | Array (String) | optional,
            organizationalUnits | Array (String) | optional,
          },
      "_js2n__-:definitions/ISnsSubscriptionConfig!contract"
        | doc m%"
          AWS SNS Notification subscription configuration
          ***Deprecated***
          Replaced by snsTopics in global config
        "%
        = {
            email
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Subscribing email address",
            level
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Notification level high, medium or low",
          },
      "_js2n__-:definitions/ISsmAutomationConfig!contract"
        | doc "AWS Systems Manager automation configuration"
        = {
            documentSets
              | Array
                _js2n__-refsenv."_js2n__-:definitions/IDocumentSetConfig!contract"
              | doc "List of documents for automation",
            excludeRegions
              | Array _js2n__-refsenv."_js2n__-:definitions/Region!contract"
              | doc "(OPTIONAL) List of AWS Region names to be excluded from configuring block S3 public access"
              | optional,
          },
      "_js2n__-:definitions/ITag!contract" = { key | String, value | String, },
      "_js2n__-:definitions/ITransition!contract" =
        {
            storageClass
              | _js2n__-refsenv."_js2n__-:definitions/StorageClass!contract",
            transitionAfter | Number,
          },
      "_js2n__-:definitions/ITriggeringResourceType!contract" =
        {
            lookupKey
              | _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Resource lookup type, resource can be lookup by tag or types. When resource needs to lookup by tag, this field will have tag name.",
            lookupType
              | String
              | doc m%"
                An enum to identify triggering resource types. Possible values ResourceId, Tag, or ResourceTypes
                
                Triggering resource can be lookup by resource id, tags or resource types.
              "%,
            lookupValue
              | Array
                _js2n__-refsenv."_js2n__-:definitions/NonEmptyString!contract"
              | doc "Resource lookup value, when resource lookup using tag, this field will have tag value to search resource.",
          },
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
      "_js2n__-:definitions/SecurityHubSeverityLevel!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'INFORMATIONAL, 'LOW, 'MEDIUM, 'HIGH, 'CRITICAL |]
            ],
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
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/ISecurityConfig!contract"