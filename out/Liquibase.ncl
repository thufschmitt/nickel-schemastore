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
      "_js2n__-:definitions/addAutoIncrement!predicate"
        | doc "Converts an existing column to be an auto-increment (a.k.a 'identity') column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnDataType = _js2n__-prdslib.isType '"String",
                  columnName = _js2n__-prdslib.isType '"String",
                  defaultOnNull = _js2n__-prdslib.isType '"Bool",
                  generationType =
                    _js2n__-prdslib.enum [ "ALWAYS", "BY DEFAULT" ],
                  incrementBy = _js2n__-prdslib.isType 'Integer,
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  startWith = _js2n__-prdslib.isType 'Integer,
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addColumn!predicate"
        | doc "You can typically use the addColumn Change Type when you want to add a new column and deploy it to the table in your database."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columns", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addDefaultValue!predicate"
        | doc "The addDefaultValue Change Type adds a default value to the database definition for the specified column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnDataType = _js2n__-prdslib.isType '"String",
                  columnName = _js2n__-prdslib.isType '"String",
                  defaultValue = _js2n__-prdslib.isType '"String",
                  defaultValueBoolean = _js2n__-prdslib.isType '"Bool",
                  defaultValueComputed = _js2n__-prdslib.isType '"String",
                  defaultValueConstraintName = _js2n__-prdslib.isType '"String",
                  defaultValueDate = _js2n__-prdslib.isType '"String",
                  defaultValueNumeric = _js2n__-prdslib.isType '"Number",
                  defaultValueSequenceNext = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addForeignKeyConstraint!predicate"
        | doc "Adds a foreign key constraint to an existing column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "baseColumnNames",
                  "baseTableName",
                  "constraintName",
                  "referencedColumnNames",
                  "referencedTableName"
                ],
              _js2n__-prdslib.records.record
                {
                  baseColumnNames = _js2n__-prdslib.isType '"String",
                  baseTableCatalogName = _js2n__-prdslib.isType '"String",
                  baseTableName = _js2n__-prdslib.isType '"String",
                  baseTableSchemaName = _js2n__-prdslib.isType '"String",
                  constraintName = _js2n__-prdslib.isType '"String",
                  deferrable = _js2n__-prdslib.isType '"Bool",
                  deleteCascade = _js2n__-prdslib.isType '"Bool",
                  initiallyDeferred = _js2n__-prdslib.isType '"Bool",
                  onDelete = _js2n__-prdslib.isType '"String",
                  onUpdate = _js2n__-prdslib.isType '"String",
                  referencedColumnNames = _js2n__-prdslib.isType '"String",
                  referencedTableCatalogName = _js2n__-prdslib.isType '"String",
                  referencedTableName = _js2n__-prdslib.isType '"String",
                  referencedTableSchemaName = _js2n__-prdslib.isType '"String",
                  referencesUniqueColumn = _js2n__-prdslib.isType '"Bool",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addLookupTable!predicate"
        | doc "Creates a lookup table containing values stored in a column and creates a foreign key to the new table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "existingColumnName",
                  "existingTableName",
                  "newColumnName",
                  "newTableName"
                ],
              _js2n__-prdslib.records.record
                {
                  constraintName = _js2n__-prdslib.isType '"String",
                  existingColumnName = _js2n__-prdslib.isType '"String",
                  existingTableCatalogName = _js2n__-prdslib.isType '"String",
                  existingTableName = _js2n__-prdslib.isType '"String",
                  existingTableSchemaName = _js2n__-prdslib.isType '"String",
                  newColumnDataType = _js2n__-prdslib.isType '"String",
                  newColumnName = _js2n__-prdslib.isType '"String",
                  newTableCatalogName = _js2n__-prdslib.isType '"String",
                  newTableName = _js2n__-prdslib.isType '"String",
                  newTableSchemaName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addNotNullConstraint!predicate"
        | doc "The addNotNullConstraint Change Type adds a NOT NULL constraint to an existing table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnDataType = _js2n__-prdslib.isType '"String",
                  columnName = _js2n__-prdslib.isType '"String",
                  constraintName = _js2n__-prdslib.isType '"String",
                  defaultNullValue = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addPrimaryKey!predicate"
        | doc "Adds a primary key out of an existing column or set of columns."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnNames", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  clustered = _js2n__-prdslib.isType '"Bool",
                  columnNames = _js2n__-prdslib.isType '"String",
                  constraintName = _js2n__-prdslib.isType '"String",
                  forIndexCatalogName = _js2n__-prdslib.isType '"String",
                  forIndexName = _js2n__-prdslib.isType '"String",
                  forIndexSchemaName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  tablespace = _js2n__-prdslib.isType '"String",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/addUniqueConstraint!predicate"
        | doc "Adds a unique constraint to an existing column or set of columns."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnNames", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  clustered = _js2n__-prdslib.isType '"Bool",
                  columnNames = _js2n__-prdslib.isType '"String",
                  constraintName = _js2n__-prdslib.isType '"String",
                  deferrable = _js2n__-prdslib.isType '"Bool",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  forIndexCatalogName = _js2n__-prdslib.isType '"String",
                  forIndexName = _js2n__-prdslib.isType '"String",
                  forIndexSchemaName = _js2n__-prdslib.isType '"String",
                  initiallyDeferred = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  tablespace = _js2n__-prdslib.isType '"String",
                  validate = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/alterSequence!predicate"
        | doc "Alters properties of an existing sequence."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "sequenceName" ],
              _js2n__-prdslib.records.record
                {
                  cacheSize = _js2n__-prdslib.isType 'Integer,
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  cycle = _js2n__-prdslib.isType '"Bool",
                  dataType = _js2n__-prdslib.isType '"String",
                  incrementBy = _js2n__-prdslib.isType 'Integer,
                  maxValue = _js2n__-prdslib.isType 'Integer,
                  minValue = _js2n__-prdslib.isType 'Integer,
                  ordered = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  sequenceName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/catalogName!predicate"
        | doc "The name of the catalog"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/changes!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        addAutoIncrement =
                          _js2n__-refsenv."_js2n__-:definitions/addAutoIncrement!predicate",
                        addColumn =
                          _js2n__-refsenv."_js2n__-:definitions/addColumn!predicate",
                        addDefaultValue =
                          _js2n__-refsenv."_js2n__-:definitions/addDefaultValue!predicate",
                        addForeignKeyConstraint =
                          _js2n__-refsenv."_js2n__-:definitions/addForeignKeyConstraint!predicate",
                        addLookupTable =
                          _js2n__-refsenv."_js2n__-:definitions/addLookupTable!predicate",
                        addNotNullConstraint =
                          _js2n__-refsenv."_js2n__-:definitions/addNotNullConstraint!predicate",
                        addPrimaryKey =
                          _js2n__-refsenv."_js2n__-:definitions/addPrimaryKey!predicate",
                        addUniqueConstraint =
                          _js2n__-refsenv."_js2n__-:definitions/addUniqueConstraint!predicate",
                        alterSequence =
                          _js2n__-refsenv."_js2n__-:definitions/alterSequence!predicate",
                        createIndex =
                          _js2n__-refsenv."_js2n__-:definitions/createIndex!predicate",
                        createProcedure =
                          _js2n__-refsenv."_js2n__-:definitions/createProcedure!predicate",
                        createSequence =
                          _js2n__-refsenv."_js2n__-:definitions/createSequence!predicate",
                        createTable =
                          _js2n__-refsenv."_js2n__-:definitions/createTable!predicate",
                        createView =
                          _js2n__-refsenv."_js2n__-:definitions/createView!predicate",
                        customChange =
                          _js2n__-refsenv."_js2n__-:definitions/customChange!predicate",
                        delete =
                          _js2n__-refsenv."_js2n__-:definitions/delete!predicate",
                        dropAllForeignKeyConstraints =
                          _js2n__-refsenv."_js2n__-:definitions/dropAllForeignKeyConstraints!predicate",
                        dropColumn =
                          _js2n__-refsenv."_js2n__-:definitions/dropColumn!predicate",
                        dropDefaultValue =
                          _js2n__-refsenv."_js2n__-:definitions/dropDefaultValue!predicate",
                        dropForeignKeyConstraint =
                          _js2n__-refsenv."_js2n__-:definitions/dropForeignKeyConstraint!predicate",
                        dropIndex =
                          _js2n__-refsenv."_js2n__-:definitions/dropIndex!predicate",
                        dropNotNullConstraint =
                          _js2n__-refsenv."_js2n__-:definitions/dropNotNullConstraint!predicate",
                        dropPrimaryKey =
                          _js2n__-refsenv."_js2n__-:definitions/dropPrimaryKey!predicate",
                        dropProcedure =
                          _js2n__-refsenv."_js2n__-:definitions/dropProcedure!predicate",
                        dropSequence =
                          _js2n__-refsenv."_js2n__-:definitions/dropSequence!predicate",
                        dropTable =
                          _js2n__-refsenv."_js2n__-:definitions/dropTable!predicate",
                        dropUniqueConstraint =
                          _js2n__-refsenv."_js2n__-:definitions/dropUniqueConstraint!predicate",
                        dropView =
                          _js2n__-refsenv."_js2n__-:definitions/dropView!predicate",
                        empty =
                          _js2n__-refsenv."_js2n__-:definitions/empty!predicate",
                        executeCommand =
                          _js2n__-refsenv."_js2n__-:definitions/executeCommand!predicate",
                        insert =
                          _js2n__-refsenv."_js2n__-:definitions/insert!predicate",
                        loadData =
                          _js2n__-refsenv."_js2n__-:definitions/loadData!predicate",
                        loadUpdateData =
                          _js2n__-refsenv."_js2n__-:definitions/loadUpdateData!predicate",
                        mergeColumns =
                          _js2n__-refsenv."_js2n__-:definitions/mergeColumns!predicate",
                        modifyDataType =
                          _js2n__-refsenv."_js2n__-:definitions/modifyDataType!predicate",
                        modifySql =
                          _js2n__-refsenv."_js2n__-:definitions/modifySql!predicate",
                        output =
                          _js2n__-refsenv."_js2n__-:definitions/output!predicate",
                        renameColumn =
                          _js2n__-refsenv."_js2n__-:definitions/renameColumn!predicate",
                        renameSequence =
                          _js2n__-refsenv."_js2n__-:definitions/renameSequence!predicate",
                        renameTable =
                          _js2n__-refsenv."_js2n__-:definitions/renameTable!predicate",
                        renameView =
                          _js2n__-refsenv."_js2n__-:definitions/renameView!predicate",
                        setColumnRemarks =
                          _js2n__-refsenv."_js2n__-:definitions/setColumnRemarks!predicate",
                        setTableRemarks =
                          _js2n__-refsenv."_js2n__-:definitions/setTableRemarks!predicate",
                        sql =
                          _js2n__-refsenv."_js2n__-:definitions/sql!predicate",
                        sqlFile =
                          _js2n__-refsenv."_js2n__-:definitions/sqlFile!predicate",
                        stop =
                          _js2n__-refsenv."_js2n__-:definitions/stop!predicate",
                        tagDatabase =
                          _js2n__-refsenv."_js2n__-:definitions/tagDatabase!predicate",
                        update =
                          _js2n__-refsenv."_js2n__-:definitions/update!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/column!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  afterColumn = _js2n__-prdslib.isType '"String",
                  autoIncrement = _js2n__-prdslib.isType '"Bool",
                  beforeColumn = _js2n__-prdslib.isType '"String",
                  computed = _js2n__-prdslib.isType '"Bool",
                  constraints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              checkConstraint =
                                _js2n__-prdslib.isType '"String",
                              deferrable = _js2n__-prdslib.isType '"Bool",
                              deleteCascade = _js2n__-prdslib.isType '"Bool",
                              foreignKeyName = _js2n__-prdslib.isType '"String",
                              initiallyDeferred =
                                _js2n__-prdslib.isType '"Bool",
                              notNullConstraintName =
                                _js2n__-prdslib.isType '"String",
                              nullable = _js2n__-prdslib.isType '"Bool",
                              primaryKey = _js2n__-prdslib.isType '"Bool",
                              primaryKeyName = _js2n__-prdslib.isType '"String",
                              primaryKeyTablespace =
                                _js2n__-prdslib.isType '"String",
                              referencedColumnNames =
                                _js2n__-prdslib.isType '"String",
                              referencedTableCatalogName =
                                _js2n__-prdslib.isType '"String",
                              referencedTableName =
                                _js2n__-prdslib.isType '"String",
                              referencedTableSchemaName =
                                _js2n__-prdslib.isType '"String",
                              references = _js2n__-prdslib.isType '"String",
                              unique = _js2n__-prdslib.isType '"Bool",
                              uniqueConstraintName =
                                _js2n__-prdslib.isType '"String",
                              validateForeignKey =
                                _js2n__-prdslib.isType '"Bool",
                              validateNullable = _js2n__-prdslib.isType '"Bool",
                              validatePrimaryKey =
                                _js2n__-prdslib.isType '"Bool",
                              validateUnique = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  defaultOnNull = _js2n__-prdslib.isType '"Bool",
                  defaultValue = _js2n__-prdslib.isType '"String",
                  defaultValueBoolean = _js2n__-prdslib.isType '"Bool",
                  defaultValueComputed = _js2n__-prdslib.isType '"String",
                  defaultValueConstraintName = _js2n__-prdslib.isType '"String",
                  defaultValueDate = _js2n__-prdslib.isType '"String",
                  defaultValueNumeric = _js2n__-prdslib.isType '"Number",
                  defaultValueSequenceCurrent =
                    _js2n__-prdslib.isType '"String",
                  defaultValueSequenceNext = _js2n__-prdslib.isType '"String",
                  descending = _js2n__-prdslib.isType '"Bool",
                  encoding = _js2n__-prdslib.isType '"String",
                  generationType = _js2n__-prdslib.isType '"String",
                  header = _js2n__-prdslib.isType '"String",
                  incrementBy = _js2n__-prdslib.isType 'Integer,
                  index = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  position = _js2n__-prdslib.isType '"Number",
                  remarks = _js2n__-prdslib.isType '"String",
                  startWith = _js2n__-prdslib.isType 'Integer,
                  type = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  valueBlobFile = _js2n__-prdslib.isType '"String",
                  valueBoolean = _js2n__-prdslib.isType '"Bool",
                  valueClobFile = _js2n__-prdslib.isType '"String",
                  valueComputed = _js2n__-prdslib.isType '"String",
                  valueDate = _js2n__-prdslib.isType '"String",
                  valueNumeric = _js2n__-prdslib.isType '"Number",
                  valueSequenceCurrent = _js2n__-prdslib.isType '"String",
                  valueSequenceNext = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/columns!predicate"
        | doc m%"
          The column constraint and foreign key information. Setting the defaultValue attribute will specify a default value for the column. Setting the value attribute will set all rows existing to the specified value without modifying the column default.
          See Information about the <column> tag section for more information.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        column =
                          _js2n__-refsenv."_js2n__-:definitions/column!predicate",
                        modifySql =
                          _js2n__-refsenv."_js2n__-:definitions/modifySql!predicate",
                      } {} true _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/createIndex!predicate"
        | doc "The createIndex Change Type creates an index on an existing column or a set of columns."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tableName" ],
              _js2n__-prdslib.records.record
                {
                  associatedWith = _js2n__-prdslib.isType '"String",
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  clustered = _js2n__-prdslib.isType '"Bool",
                  column =
                    _js2n__-refsenv."_js2n__-:definitions/column!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  indexName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  tablespace = _js2n__-prdslib.isType '"String",
                  unique = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/createProcedure!predicate"
        | doc m%"
          The createProcedure Change Type defines the definition for a stored procedure. This Change Type is better to use for creating procedures than the raw SQL command because it will not attempt to strip comments or break up lines.
          
          Often times it is best to use the CREATE OR REPLACE syntax along with setting runOnChange='true' on the enclosing changeset tag. That way if you need to make a change to your procedure, you can change your existing code rather than creating a new REPLACE PROCEDURE call. The advantage to this approach is that it keeps your changelog smaller and allows you to more easily see what has changed in your procedure code through your source control system's diff command.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path", "procedureText" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  comments = _js2n__-prdslib.isType '"String",
                  dbms = _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                  encoding = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  procedureName = _js2n__-prdslib.isType '"String",
                  procedureText = _js2n__-prdslib.isType '"String",
                  relativeToChangelogFile = _js2n__-prdslib.isType '"Bool",
                  replaceIfExists = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/createSequence!predicate"
        | doc "Creates a new database sequence."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "sequenceName" ],
              _js2n__-prdslib.records.record
                {
                  cacheSize = _js2n__-prdslib.isType 'Integer,
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  cycle = _js2n__-prdslib.isType '"Bool",
                  dataType = _js2n__-prdslib.isType '"String",
                  incrementBy = _js2n__-prdslib.isType 'Integer,
                  maxValue = _js2n__-prdslib.isType 'Integer,
                  minValue = _js2n__-prdslib.isType 'Integer,
                  ordered = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  sequenceName = _js2n__-prdslib.isType '"String",
                  startValue = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/createTable!predicate"
        | doc "You can typically use the createTable Change Type when you want to create a table in your changelog file and then deploy it to your database. It can include columns and another values listed in this documentation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columns", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  remarks =
                    _js2n__-refsenv."_js2n__-:definitions/remarks!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  tablespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/createView!predicate"
        | doc "Creates a new database view."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  encoding = _js2n__-prdslib.isType '"String",
                  fullDefinition = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  relativeToChangelogFile = _js2n__-prdslib.isType '"Bool",
                  remarks =
                    _js2n__-refsenv."_js2n__-:definitions/remarks!predicate",
                  replaceIfExists = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  selectQuery = _js2n__-prdslib.isType '"String",
                  viewName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/customChange!predicate"
        | doc "The customChange type creates a custom Change Type class."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class" ],
              _js2n__-prdslib.records.record
                { class = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dbms!predicate"
        | doc "Specifies logical expression of database type(s) on which the change must be applied. Valid database type names are listed on the supported databases page. It can be a comma-separated list of multiple databases or you can also specify that a change is not applicable to a particular database type by prefixing with !. The keywords all and none are also available."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/delete!predicate"
        | doc "Deletes data from an existing table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  where =
                    _js2n__-refsenv."_js2n__-:definitions/where!predicate",
                  whereParams =
                    _js2n__-refsenv."_js2n__-:definitions/whereParams!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropAllForeignKeyConstraints!predicate"
        | doc "Drops all foreign key constraints for a table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "baseTableName" ],
              _js2n__-prdslib.records.record
                {
                  baseTableCatalogName = _js2n__-prdslib.isType '"String",
                  baseTableName = _js2n__-prdslib.isType '"String",
                  baseTableSchemaName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropColumn!predicate"
        | doc m%"
          Drops an existing column(s).
          
          To drop a single column, use the simple form of this element where the tableName and columnName are specified as attributes. To drop several columns, specify the tableName as an attribute, and then specify a set of nested <column> tags. If nested <column> tags are present, the columnName attribute will be ignored.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnName = _js2n__-prdslib.isType '"String",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropDefaultValue!predicate"
        | doc "Removes the database default value for a column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnDataType = _js2n__-prdslib.isType '"String",
                  columnName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropForeignKeyConstraint!predicate"
        | doc "Drops an existing foreign key."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "baseTableName", "constraintName" ],
              _js2n__-prdslib.records.record
                {
                  baseTableCatalogName = _js2n__-prdslib.isType '"String",
                  baseTableName = _js2n__-prdslib.isType '"String",
                  baseTableSchemaName = _js2n__-prdslib.isType '"String",
                  constraintName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropIndex!predicate"
        | doc "The dropIndex Change Type drops an existing index on a column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "indexName" ],
              _js2n__-prdslib.records.record
                {
                  associatedWith = _js2n__-prdslib.isType '"String",
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  indexName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropNotNullConstraint!predicate"
        | doc "Makes a column nullable."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columnName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnDataType = _js2n__-prdslib.isType '"String",
                  columnName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropPrimaryKey!predicate"
        | doc "The dropPrimaryKey Change Type drops an existing primary key in the table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  constraintName = _js2n__-prdslib.isType '"String",
                  dropIndex = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropProcedure!predicate"
        | doc "Drops an existing procedure"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "procedureName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  procedureName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropSequence!predicate"
        | doc "Drops an existing sequence."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "sequenceName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  sequenceName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropTable!predicate"
        | doc "Drops an existing table from your database."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tableName" ],
              _js2n__-prdslib.records.record
                {
                  cascadeConstraints = _js2n__-prdslib.isType '"Bool",
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropUniqueConstraint!predicate"
        | doc "Drops an existing unique constraint."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "constraintName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  constraintName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  uniqueColumns = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dropView!predicate"
        | doc "Drops an existing view."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "viewName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  viewName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/empty!predicate"
        | doc "empty"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/executeCommand!predicate"
        | doc "The executeCommand Change Type executes a system command."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "executable" ],
              _js2n__-prdslib.records.record
                {
                  arg =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { value = _js2n__-prdslib.isType '"String", } {}
                            true _js2n__-prdslib.always
                        ],
                  args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  { value = _js2n__-prdslib.isType '"String", }
                                  {} true _js2n__-prdslib.always
                              ])
                        ],
                  executable = _js2n__-prdslib.isType '"String",
                  os = _js2n__-prdslib.isType '"String",
                  timeout = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/insert!predicate"
        | doc "You can typically use the insert Change Type when you want to add and deploy the specific data or values to the existing table in your database. It can include columns and another attributes listed in this documentation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  dbms = _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/loadData!predicate"
        | doc "Loads data from a CSV file into an existing table when you add it to your changelog."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  column =
                    _js2n__-refsenv."_js2n__-:definitions/column!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  commentLineStartsWith = _js2n__-prdslib.isType '"String",
                  encoding = _js2n__-prdslib.isType '"String",
                  file = _js2n__-prdslib.isType '"String",
                  quotchar = _js2n__-prdslib.isType '"String",
                  relativeToChangelogFile = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  separator = _js2n__-prdslib.isType '"String",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  usePreparedStatements = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/loadUpdateData!predicate"
        | doc m%"
          Loads or updates data from a CSV file into an existing table. Differs from loadData by issuing a SQL batch that checks for the existence of a record. If found, the record is UPDATEd, else the record is INSERTed. Also, generates DELETE statements for a rollback.
          
          A value of NULL in a cell will be converted to a database NULL rather than the string 'NULL'
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "file", "primaryKey", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  column =
                    _js2n__-refsenv."_js2n__-:definitions/column!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  commentLineStartsWith = _js2n__-prdslib.isType '"String",
                  encoding = _js2n__-prdslib.isType '"String",
                  file = _js2n__-prdslib.isType '"String",
                  onlyUpdate = _js2n__-prdslib.isType '"Bool",
                  primaryKey = _js2n__-prdslib.isType '"String",
                  quotchar = _js2n__-prdslib.isType '"String",
                  relativeToChangelogFile = _js2n__-prdslib.isType '"Bool",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  separator = _js2n__-prdslib.isType '"String",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  usePreparedStatements = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/mergeColumns!predicate"
        | doc m%"
          The mergeColumns Change Type concatenates the values in two columns and joins them with a string. The Change Type stores the resulting value in a new column.
          You can typically use the mergeColumns Change Type when you want to combine the values from two columns into one.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "column1Name",
                  "column2Name",
                  "finalColumnName",
                  "finalColumnType",
                  "tableName"
                ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  column1Name = _js2n__-prdslib.isType '"String",
                  column2Name = _js2n__-prdslib.isType '"String",
                  finalColumnName = _js2n__-prdslib.isType '"String",
                  finalColumnType = _js2n__-prdslib.isType '"String",
                  joinString = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/modifyDataType!predicate"
        | doc "Allows you to modify data types."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "columnName", "newDataType", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnName = _js2n__-prdslib.isType '"String",
                  newDataType = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/modifySql!predicate"
        | doc "Although Liquibase supports most standard SQL statements with its Change Types, there are times when you need the generated SQL to be different. The following examples show how to change data types or add additional vendor-specific clauses such as ENGINE INNODB to CREATE TABLE statements. Since 1.9"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  append =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { value = _js2n__-prdslib.isType '"String", } {}
                            true _js2n__-prdslib.always
                        ],
                  applyToRollback = _js2n__-prdslib.isType '"Bool",
                  context = _js2n__-prdslib.isType '"String",
                  dbms = _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                  labels = _js2n__-prdslib.isType '"String",
                  prepend =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { value = _js2n__-prdslib.isType '"String", } {}
                            true _js2n__-prdslib.always
                        ],
                  regExpReplace =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              replace = _js2n__-prdslib.isType '"String",
                              with = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  replace =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              replace = _js2n__-prdslib.isType '"String",
                              with = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/output!predicate"
        | doc "Logs a message and continues execution."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  message = _js2n__-prdslib.isType '"String",
                  target =
                    _js2n__-prdslib.enum
                        [
                          "STDOUT",
                          "STDERR",
                          "FATAL",
                          "WARN",
                          "INFO",
                          "DEBUG"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/preConditions!predicate"
        | doc "Preconditions are changelog or changeset tags which control the execution of an update based on the state of the database."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        and =
                          _js2n__-refsenv."_js2n__-:definitions/preConditions!predicate",
                        changeLogPropertyDefined =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "property" ],
                                _js2n__-prdslib.records.record
                                  {
                                    property = _js2n__-prdslib.isType '"String",
                                    value = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        changeSetExecuted =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "author", "changeLogFile", "id" ],
                                _js2n__-prdslib.records.record
                                  {
                                    author = _js2n__-prdslib.isType '"String",
                                    changeLogFile =
                                      _js2n__-prdslib.isType '"String",
                                    id = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        columnExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "columnName", "tableName" ],
                                _js2n__-prdslib.records.record
                                  {
                                    columnName =
                                      _js2n__-prdslib.isType '"String",
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                    tableName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        customPrecondition =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "className" ],
                                _js2n__-prdslib.records.record
                                  {
                                    className =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        dbms =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "type" ],
                                _js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.isType '"String", }
                                  {} true _js2n__-prdslib.always
                              ],
                        foreignKeyConstraintExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "foreignKeyName" ],
                                _js2n__-prdslib.records.record
                                  {
                                    foreignKeyName =
                                      _js2n__-prdslib.isType '"String",
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        indexExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    columnName =
                                      _js2n__-prdslib.isType '"String",
                                    indexName =
                                      _js2n__-prdslib.isType '"String",
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                    tableName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        not =
                          _js2n__-refsenv."_js2n__-:definitions/preConditions!predicate",
                        onError =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.const "HALT",
                                    _js2n__-prdslib.const "CONTINUE",
                                    _js2n__-prdslib.const "MARK_RAN",
                                    _js2n__-prdslib.const "WARN"
                                  ]
                              ],
                        onErrorMessage = _js2n__-prdslib.isType '"String",
                        onFail =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.const "HALT",
                                    _js2n__-prdslib.const "CONTINUE",
                                    _js2n__-prdslib.const "MARK_RAN",
                                    _js2n__-prdslib.const "WARN"
                                  ]
                              ],
                        onFailMessage = _js2n__-prdslib.isType '"String",
                        onSqlOutput =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.const "TEST",
                                    _js2n__-prdslib.const "FAIL",
                                    _js2n__-prdslib.const "IGNORE"
                                  ]
                              ],
                        or =
                          _js2n__-refsenv."_js2n__-:definitions/preConditions!predicate",
                        primaryKeyExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    primaryKeyName =
                                      _js2n__-prdslib.isType '"String",
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                    tableName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        runningAs =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "username" ],
                                _js2n__-prdslib.records.record
                                  {
                                    username = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        sequenceExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "sequenceName" ],
                                _js2n__-prdslib.records.record
                                  {
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                    sequenceName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        sqlCheck =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "expectedResult" ],
                                _js2n__-prdslib.records.record
                                  {
                                    expectedResult =
                                      _js2n__-prdslib.isType 'Integer,
                                    sql = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        tableExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "tableName" ],
                                _js2n__-prdslib.records.record
                                  {
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                    tableName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        viewExists =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "viewName" ],
                                _js2n__-prdslib.records.record
                                  {
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                    viewName = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/remarks!predicate"
        | doc "The comments stored for the table/view/column"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/renameColumn!predicate"
        | doc "Renames an existing column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "newColumnName", "oldColumnName", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnDataType = _js2n__-prdslib.isType '"String",
                  newColumnName = _js2n__-prdslib.isType '"String",
                  oldColumnName = _js2n__-prdslib.isType '"String",
                  remarks = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/renameSequence!predicate"
        | doc "Renames an existing sequence."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "newSequenceName", "oldSequenceName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  newSequenceName = _js2n__-prdslib.isType '"String",
                  oldSequenceName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/renameTable!predicate"
        | doc "Renames an existing table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "newTableName", "oldTableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  newTableName = _js2n__-prdslib.isType '"String",
                  oldTableName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/renameView!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "newViewName", "oldViewName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  newViewName = _js2n__-prdslib.isType '"String",
                  oldViewName = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/schemaName!predicate"
        | doc "The name of the schema"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/setColumnRemarks!predicate"
        | doc "The setColumnRemarks Change Type sets remarks on a column."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "columnName", "remarks", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columnName = _js2n__-prdslib.isType '"String",
                  remarks = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/setTableRemarks!predicate"
        | doc "Sets remarks on a table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "remarks", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  remarks = _js2n__-prdslib.isType '"String",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sql!predicate"
        | doc "It is useful for complex changes that aren't supported through Liquibase's automated Change Types and to work around bugs and limitations of Liquibase. The SQL contained in the <SQL> Change Type can be multi-line."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "sql" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  dbms = _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                  endDelimiter = _js2n__-prdslib.isType '"String",
                  splitStatements = _js2n__-prdslib.isType '"Bool",
                  sql = _js2n__-prdslib.isType '"String",
                  stripComments = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sqlFile!predicate"
        | doc "The <sqlFile> Change Type is useful for complex changes that are not supported through Liquibase automated Change Types such as stored procedures. The SQL contained in the <sqlFile> Change Type can be multi-line."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  comment = _js2n__-prdslib.isType '"String",
                  dbms = _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                  encoding = _js2n__-prdslib.isType '"String",
                  endDelimiter = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  relativeToChangelogFile = _js2n__-prdslib.isType '"Bool",
                  splitStatements = _js2n__-prdslib.isType '"Bool",
                  stripComments = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stop!predicate"
        | doc "Stops Liquibase execution with a message. Mainly useful for debugging and stepping through a changelog"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { message = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tableName!predicate"
        | doc "The name of the table"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/tagDatabase!predicate"
        | doc "The tagDatabase Change Type applies a tag to the database for future update or rollback."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tag" ],
              _js2n__-prdslib.records.record
                { tag = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/update!predicate"
        | doc "You can typically use the update Change Type when you want to update a table in your changelog file and then deploy this update to your database. It can include columns and another values listed in this documentation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "columns", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  catalogName =
                    _js2n__-refsenv."_js2n__-:definitions/catalogName!predicate",
                  columns =
                    _js2n__-refsenv."_js2n__-:definitions/columns!predicate",
                  schemaName =
                    _js2n__-refsenv."_js2n__-:definitions/schemaName!predicate",
                  tableName =
                    _js2n__-refsenv."_js2n__-:definitions/tableName!predicate",
                  where =
                    _js2n__-refsenv."_js2n__-:definitions/where!predicate",
                  whereParams =
                    _js2n__-refsenv."_js2n__-:definitions/whereParams!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/where!predicate"
        | doc "Allows to define the 'where' condition(s) string"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/whereParams!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        param =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    name = _js2n__-prdslib.isType '"String",
                                    value = _js2n__-prdslib.isType '"String",
                                    valueBoolean =
                                      _js2n__-prdslib.isType '"Bool",
                                    valueComputed =
                                      _js2n__-prdslib.isType '"String",
                                    valueDate =
                                      _js2n__-prdslib.isType '"String",
                                    valueNumeric =
                                      _js2n__-prdslib.isType '"Number",
                                    valueSequenceCurrent =
                                      _js2n__-prdslib.isType '"String",
                                    valueSequenceNext =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ],
    }
    in
  {
      databaseChangeLog
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    changeSet =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "author", "id" ],
                            _js2n__-prdslib.records.record
                              {
                                author = _js2n__-prdslib.isType '"String",
                                changes =
                                  _js2n__-refsenv."_js2n__-:definitions/changes!predicate",
                                comment = _js2n__-prdslib.isType '"String",
                                context = _js2n__-prdslib.isType '"String",
                                created = _js2n__-prdslib.isType '"String",
                                dbms =
                                  _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                                failOnError = _js2n__-prdslib.isType '"Bool",
                                id = _js2n__-prdslib.isType '"String",
                                ignore = _js2n__-prdslib.isType '"Bool",
                                labels = _js2n__-prdslib.isType '"String",
                                logicalFilePath =
                                  _js2n__-prdslib.isType '"String",
                                modifySql =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          _js2n__-refsenv."_js2n__-:definitions/modifySql!predicate"
                                      ],
                                objectQuotingStrategy =
                                  _js2n__-prdslib.isType '"String",
                                onValidationFail =
                                  _js2n__-prdslib.isType '"String",
                                preConditions =
                                  _js2n__-refsenv."_js2n__-:definitions/preConditions!predicate",
                                rollback =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              false _js2n__-prdslib.never
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/changes!predicate",
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [
                                                "changeSetAuthor",
                                                "changeSetId"
                                              ],
                                            _js2n__-prdslib.records.record
                                              {
                                                changeSetAuthor =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                changeSetId =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                changeSetPath =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ],
                                runAlways = _js2n__-prdslib.isType '"Bool",
                                runInTransaction =
                                  _js2n__-prdslib.isType '"Bool",
                                runOnChange = _js2n__-prdslib.isType '"Bool",
                                runOrder = _js2n__-prdslib.isType '"String",
                                runWith = _js2n__-prdslib.isType '"String",
                                validCheckSum =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                    context = _js2n__-prdslib.isType '"String",
                    include =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                author = _js2n__-prdslib.isType '"String",
                                context = _js2n__-prdslib.isType '"String",
                                created = _js2n__-prdslib.isType '"String",
                                file = _js2n__-prdslib.isType '"String",
                                id = _js2n__-prdslib.isType '"String",
                                ignore = _js2n__-prdslib.isType '"String",
                                labels = _js2n__-prdslib.isType '"String",
                                relativeToChangelogFile =
                                  _js2n__-prdslib.isType '"Bool",
                              } {} true _js2n__-prdslib.always
                          ],
                    includeAll =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                context = _js2n__-prdslib.isType '"String",
                                errorIfMissingOrEmpty =
                                  _js2n__-prdslib.isType '"Bool",
                                filter = _js2n__-prdslib.isType '"String",
                                path = _js2n__-prdslib.isType '"String",
                                relativeToChangelogFile =
                                  _js2n__-prdslib.isType '"Bool",
                                resourceComparator =
                                  _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always
                          ],
                    logicalFilePath = _js2n__-prdslib.isType '"String",
                    objectQuotingStrategy = _js2n__-prdslib.isType '"String",
                    preConditions =
                      _js2n__-refsenv."_js2n__-:definitions/preConditions!predicate",
                    property =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                context = _js2n__-prdslib.isType '"String",
                                dbms =
                                  _js2n__-refsenv."_js2n__-:definitions/dbms!predicate",
                                file = _js2n__-prdslib.isType '"String",
                                global = _js2n__-prdslib.isType '"Bool",
                                labels = _js2n__-prdslib.isType '"String",
                                name = _js2n__-prdslib.isType '"String",
                                target = _js2n__-prdslib.isType '"String",
                                value = _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always
                          ],
                  } {} true _js2n__-prdslib.always
              ])
        )
        | doc "The root of all Liquibase changes is the changelog file. Liquibase uses a changelog to sequentially list all changes made to your database. Think of it as a ledger. It is a file that contains a record of all your database changes (changesets). Liquibase uses this changelog record to audit your database and execute any changes that are not yet applied to your database.",
      ..
    }