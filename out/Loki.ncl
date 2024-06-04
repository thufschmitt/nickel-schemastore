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
      "_js2n__-:definitions/alibabacloud_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access_key_id = _js2n__-prdslib.isType '"String",
                  bucket = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  secret_access_key = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/analytics!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  reporting_enabled = _js2n__-prdslib.isType '"Bool",
                  usage_stats_url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/attributes_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  action = _js2n__-prdslib.isType '"String",
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  regex = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/aws_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access_key_id = _js2n__-prdslib.isType '"String",
                  backoff_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max_period = _js2n__-prdslib.isType '"String",
                              max_retries = _js2n__-prdslib.isType 'Integer,
                              min_period = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  bucketnames = _js2n__-prdslib.isType '"String",
                  dynamodb =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              api_limit = _js2n__-prdslib.isType '"Number",
                              backoff_config =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          max_period =
                                            _js2n__-prdslib.isType '"String",
                                          max_retries =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_period =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              chunk_gang_size = _js2n__-prdslib.isType 'Integer,
                              chunk_get_max_parallelism =
                                _js2n__-prdslib.isType 'Integer,
                              dynamodb_url = _js2n__-prdslib.isType '"String",
                              kms_key_id = _js2n__-prdslib.isType '"String",
                              metrics =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          ignore_throttle_below =
                                            _js2n__-prdslib.isType '"Number",
                                          queue_length_query =
                                            _js2n__-prdslib.isType '"String",
                                          read_error_query =
                                            _js2n__-prdslib.isType '"String",
                                          read_usage_query =
                                            _js2n__-prdslib.isType '"String",
                                          scale_up_factor =
                                            _js2n__-prdslib.isType '"Number",
                                          target_queue_length =
                                            _js2n__-prdslib.isType 'Integer,
                                          url =
                                            _js2n__-prdslib.isType '"String",
                                          write_throttle_query =
                                            _js2n__-prdslib.isType '"String",
                                          write_usage_query =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              throttle_limit = _js2n__-prdslib.isType '"Number",
                            } {} true _js2n__-prdslib.always
                        ],
                  endpoint = _js2n__-prdslib.isType '"String",
                  http_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ca_file = _js2n__-prdslib.isType '"String",
                              idle_conn_timeout =
                                _js2n__-prdslib.isType '"String",
                              insecure_skip_verify =
                                _js2n__-prdslib.isType '"Bool",
                              response_header_timeout =
                                _js2n__-prdslib.isType '"String",
                              timeout = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  insecure = _js2n__-prdslib.isType '"Bool",
                  region = _js2n__-prdslib.isType '"String",
                  s3 = _js2n__-prdslib.isType '"String",
                  s3forcepathstyle = _js2n__-prdslib.isType '"Bool",
                  secret_access_key = _js2n__-prdslib.isType '"String",
                  session_token = _js2n__-prdslib.isType '"String",
                  signature_version = _js2n__-prdslib.isType '"String",
                  sse =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              kms_encryption_context =
                                _js2n__-prdslib.isType '"String",
                              kms_key_id = _js2n__-prdslib.isType '"String",
                              type = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  storage_class = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/azure_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  account_key = _js2n__-prdslib.isType '"String",
                  account_name = _js2n__-prdslib.isType '"String",
                  chunk_delimiter = _js2n__-prdslib.isType '"String",
                  client_id = _js2n__-prdslib.isType '"String",
                  client_secret = _js2n__-prdslib.isType '"String",
                  connection_string = _js2n__-prdslib.isType '"String",
                  container_name = _js2n__-prdslib.isType '"String",
                  download_buffer_size = _js2n__-prdslib.isType 'Integer,
                  endpoint_suffix = _js2n__-prdslib.isType '"String",
                  environment = _js2n__-prdslib.isType '"String",
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  max_retry_delay = _js2n__-prdslib.isType '"String",
                  min_retry_delay = _js2n__-prdslib.isType '"String",
                  request_timeout = _js2n__-prdslib.isType '"String",
                  tenant_id = _js2n__-prdslib.isType '"String",
                  upload_buffer_count = _js2n__-prdslib.isType 'Integer,
                  upload_buffer_size = _js2n__-prdslib.isType 'Integer,
                  use_federated_token = _js2n__-prdslib.isType '"Bool",
                  use_managed_identity = _js2n__-prdslib.isType '"Bool",
                  use_service_principal = _js2n__-prdslib.isType '"Bool",
                  user_assigned_id = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/bloom_compactor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compaction_interval = _js2n__-prdslib.isType '"String",
                  compaction_retries = _js2n__-prdslib.isType 'Integer,
                  compaction_retries_max_backoff =
                    _js2n__-prdslib.isType '"String",
                  compaction_retries_min_backoff =
                    _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  max_compaction_parallelism = _js2n__-prdslib.isType 'Integer,
                  max_table_offset = _js2n__-prdslib.isType 'Integer,
                  min_table_offset = _js2n__-prdslib.isType 'Integer,
                  retention =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enabled = _js2n__-prdslib.isType '"Bool",
                              max_lookback_days =
                                _js2n__-prdslib.isType 'Integer,
                            } {} true _js2n__-prdslib.always
                        ],
                  ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_addr = _js2n__-prdslib.isType '"String",
                              instance_availability_zone =
                                _js2n__-prdslib.isType '"String",
                              instance_enable_ipv6 =
                                _js2n__-prdslib.isType '"Bool",
                              instance_id = _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              instance_port = _js2n__-prdslib.isType 'Integer,
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              num_tokens = _js2n__-prdslib.isType 'Integer,
                              replication_factor = _js2n__-prdslib.always,
                              tokens_file_path =
                                _js2n__-prdslib.isType '"String",
                              zone_awareness_enabled =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  worker_parallelism = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/bloom_gateway!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  block_query_concurrency = _js2n__-prdslib.isType 'Integer,
                  client =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              addresses = _js2n__-prdslib.isType '"String",
                              cache_results = _js2n__-prdslib.isType '"Bool",
                              grpc_client_config =
                                _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                              pool_config =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          check_interval =
                                            _js2n__-prdslib.isType '"String",
                                          enable_health_check =
                                            _js2n__-prdslib.isType '"Bool",
                                          health_check_timeout =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              results_cache =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          cache =
                                            _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                                          compression =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  max_outstanding_per_tenant = _js2n__-prdslib.isType 'Integer,
                  num_multiplex_tasks = _js2n__-prdslib.isType 'Integer,
                  worker_concurrency = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/bos_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access_key_id = _js2n__-prdslib.isType '"String",
                  bucket_name = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  secret_access_key = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cache_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  background =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              writeback_buffer =
                                _js2n__-prdslib.isType 'Integer,
                              writeback_goroutines =
                                _js2n__-prdslib.isType 'Integer,
                              writeback_size_limit =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  default_validity = _js2n__-prdslib.isType '"String",
                  embedded_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enabled = _js2n__-prdslib.isType '"Bool",
                              max_size_items = _js2n__-prdslib.isType 'Integer,
                              max_size_mb = _js2n__-prdslib.isType 'Integer,
                              ttl = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  memcached =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              batch_size = _js2n__-prdslib.isType 'Integer,
                              expiration = _js2n__-prdslib.isType '"String",
                              parallelism = _js2n__-prdslib.isType 'Integer,
                            } {} true _js2n__-prdslib.always
                        ],
                  memcached_client =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              addresses = _js2n__-prdslib.isType '"String",
                              circuit_breaker_consecutive_failures =
                                _js2n__-prdslib.isType 'Integer,
                              circuit_breaker_interval =
                                _js2n__-prdslib.isType '"String",
                              circuit_breaker_timeout =
                                _js2n__-prdslib.isType '"String",
                              consistent_hash = _js2n__-prdslib.isType '"Bool",
                              host = _js2n__-prdslib.isType '"String",
                              max_idle_conns = _js2n__-prdslib.isType 'Integer,
                              max_item_size = _js2n__-prdslib.isType 'Integer,
                              service = _js2n__-prdslib.isType '"String",
                              timeout = _js2n__-prdslib.isType '"String",
                              tls_ca_path = _js2n__-prdslib.isType '"String",
                              tls_cert_path = _js2n__-prdslib.isType '"String",
                              tls_cipher_suites =
                                _js2n__-prdslib.isType '"String",
                              tls_enabled = _js2n__-prdslib.isType '"Bool",
                              tls_insecure_skip_verify =
                                _js2n__-prdslib.isType '"Bool",
                              tls_key_path = _js2n__-prdslib.isType '"String",
                              tls_min_version =
                                _js2n__-prdslib.isType '"String",
                              tls_server_name =
                                _js2n__-prdslib.isType '"String",
                              update_interval =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  redis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              db = _js2n__-prdslib.isType 'Integer,
                              endpoint = _js2n__-prdslib.isType '"String",
                              expiration = _js2n__-prdslib.isType '"String",
                              idle_timeout = _js2n__-prdslib.isType '"String",
                              master_name = _js2n__-prdslib.isType '"String",
                              max_connection_age =
                                _js2n__-prdslib.isType '"String",
                              password = _js2n__-prdslib.isType '"String",
                              pool_size = _js2n__-prdslib.isType 'Integer,
                              route_randomly = _js2n__-prdslib.isType '"Bool",
                              timeout = _js2n__-prdslib.isType '"String",
                              tls_enabled = _js2n__-prdslib.isType '"Bool",
                              tls_insecure_skip_verify =
                                _js2n__-prdslib.isType '"Bool",
                              username = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/chunk_store_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cache_lookups_older_than = _js2n__-prdslib.isType '"String",
                  chunk_cache_config =
                    _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                  chunk_cache_config_l2 =
                    _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                  l2_chunk_cache_handoff = _js2n__-prdslib.isType '"String",
                  write_dedupe_cache_config =
                    _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/common!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compactor_address = _js2n__-prdslib.isType '"String",
                  compactor_grpc_address = _js2n__-prdslib.isType '"String",
                  instance_addr = _js2n__-prdslib.isType '"String",
                  instance_interface_names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path_prefix = _js2n__-prdslib.isType '"String",
                  persist_tokens = _js2n__-prdslib.isType '"Bool",
                  replication_factor = _js2n__-prdslib.isType 'Integer,
                  ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_addr = _js2n__-prdslib.isType '"String",
                              instance_availability_zone =
                                _js2n__-prdslib.isType '"String",
                              instance_enable_ipv6 =
                                _js2n__-prdslib.isType '"Bool",
                              instance_id = _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              instance_port = _js2n__-prdslib.isType 'Integer,
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              num_tokens = _js2n__-prdslib.isType 'Integer,
                              replication_factor =
                                _js2n__-prdslib.isType 'Integer,
                              tokens_file_path =
                                _js2n__-prdslib.isType '"String",
                              zone_awareness_enabled =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  storage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              alibabacloud =
                                _js2n__-refsenv."_js2n__-:definitions/alibabacloud_storage_config!predicate",
                              azure =
                                _js2n__-refsenv."_js2n__-:definitions/azure_storage_config!predicate",
                              bos =
                                _js2n__-refsenv."_js2n__-:definitions/bos_storage_config!predicate",
                              congestion_control =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          controller =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      aimd =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  backoff_factor =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  start =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  upper_bound =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      strategy =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          hedging =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      config =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  at =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  max_per_second =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  up_to =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      strategy =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          retry =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      limit =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      strategy =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              cos =
                                _js2n__-refsenv."_js2n__-:definitions/cos_storage_config!predicate",
                              filesystem =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          chunks_directory =
                                            _js2n__-prdslib.isType '"String",
                                          rules_directory =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              gcs =
                                _js2n__-refsenv."_js2n__-:definitions/gcs_storage_config!predicate",
                              hedging =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          at = _js2n__-prdslib.isType '"String",
                                          max_per_second =
                                            _js2n__-prdslib.isType 'Integer,
                                          up_to =
                                            _js2n__-prdslib.isType 'Integer,
                                        } {} true _js2n__-prdslib.always
                                    ],
                              s3 =
                                _js2n__-refsenv."_js2n__-:definitions/s3_storage_config!predicate",
                              swift =
                                _js2n__-refsenv."_js2n__-:definitions/swift_storage_config!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/compactor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apply_retention_interval = _js2n__-prdslib.isType '"String",
                  compaction_interval = _js2n__-prdslib.isType '"String",
                  compactor_ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_addr = _js2n__-prdslib.isType '"String",
                              instance_availability_zone =
                                _js2n__-prdslib.isType '"String",
                              instance_enable_ipv6 =
                                _js2n__-prdslib.isType '"Bool",
                              instance_id = _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              instance_port = _js2n__-prdslib.isType 'Integer,
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              num_tokens = _js2n__-prdslib.always,
                              replication_factor = _js2n__-prdslib.always,
                              tokens_file_path =
                                _js2n__-prdslib.isType '"String",
                              zone_awareness_enabled =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  delete_batch_size = _js2n__-prdslib.isType 'Integer,
                  delete_max_interval = _js2n__-prdslib.isType '"String",
                  delete_request_cancel_period =
                    _js2n__-prdslib.isType '"String",
                  delete_request_store = _js2n__-prdslib.isType '"String",
                  delete_request_store_key_prefix =
                    _js2n__-prdslib.isType '"String",
                  max_compaction_parallelism = _js2n__-prdslib.isType 'Integer,
                  retention_delete_delay = _js2n__-prdslib.isType '"String",
                  retention_delete_worker_count =
                    _js2n__-prdslib.isType 'Integer,
                  retention_enabled = _js2n__-prdslib.isType '"Bool",
                  retention_table_timeout = _js2n__-prdslib.isType '"String",
                  skip_latest_n_tables = _js2n__-prdslib.isType 'Integer,
                  tables_to_compact = _js2n__-prdslib.isType 'Integer,
                  upload_parallelism = _js2n__-prdslib.isType 'Integer,
                  working_directory = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/consul!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  acl_token = _js2n__-prdslib.isType '"String",
                  cas_retry_delay = _js2n__-prdslib.isType '"String",
                  consistent_reads = _js2n__-prdslib.isType '"Bool",
                  host = _js2n__-prdslib.isType '"String",
                  http_client_timeout = _js2n__-prdslib.isType '"String",
                  watch_burst_size = _js2n__-prdslib.isType 'Integer,
                  watch_rate_limit = _js2n__-prdslib.isType '"Number",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cos_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access_key_id = _js2n__-prdslib.isType '"String",
                  api_key = _js2n__-prdslib.isType '"String",
                  auth_endpoint = _js2n__-prdslib.isType '"String",
                  backoff_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max_period = _js2n__-prdslib.isType '"String",
                              max_retries = _js2n__-prdslib.isType 'Integer,
                              min_period = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  bucketnames = _js2n__-prdslib.isType '"String",
                  cr_token_file_path = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  forcepathstyle = _js2n__-prdslib.isType '"Bool",
                  http_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              idle_conn_timeout =
                                _js2n__-prdslib.isType '"String",
                              response_header_timeout =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  region = _js2n__-prdslib.isType '"String",
                  secret_access_key = _js2n__-prdslib.isType '"String",
                  service_instance_id = _js2n__-prdslib.isType '"String",
                  trusted_profile_id = _js2n__-prdslib.isType '"String",
                  trusted_profile_name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/distributor!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  otlp_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              default_resource_attributes_as_index_labels =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  rate_store =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              debug = _js2n__-prdslib.isType '"Bool",
                              ingester_request_timeout =
                                _js2n__-prdslib.isType '"String",
                              max_request_parallelism =
                                _js2n__-prdslib.isType 'Integer,
                              stream_rate_update_interval =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  write_failures_logging =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              add_insights_label =
                                _js2n__-prdslib.isType '"Bool",
                              rate = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/etcd!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dial_timeout = _js2n__-prdslib.isType '"String",
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  password = _js2n__-prdslib.isType '"String",
                  tls_ca_path = _js2n__-prdslib.isType '"String",
                  tls_cert_path = _js2n__-prdslib.isType '"String",
                  tls_cipher_suites = _js2n__-prdslib.isType '"String",
                  tls_enabled = _js2n__-prdslib.isType '"Bool",
                  tls_insecure_skip_verify = _js2n__-prdslib.isType '"Bool",
                  tls_key_path = _js2n__-prdslib.isType '"String",
                  tls_min_version = _js2n__-prdslib.isType '"String",
                  tls_server_name = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/frontend!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compress_responses = _js2n__-prdslib.isType '"Bool",
                  downstream_url = _js2n__-prdslib.isType '"String",
                  encoding = _js2n__-prdslib.isType '"String",
                  graceful_shutdown_timeout = _js2n__-prdslib.isType '"String",
                  grpc_client_config =
                    _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                  instance_interface_names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  log_queries_longer_than = _js2n__-prdslib.isType '"String",
                  log_query_request_headers = _js2n__-prdslib.isType '"String",
                  max_body_size = _js2n__-prdslib.isType 'Integer,
                  max_outstanding_per_tenant = _js2n__-prdslib.isType 'Integer,
                  querier_forget_delay = _js2n__-prdslib.isType '"String",
                  query_stats_enabled = _js2n__-prdslib.isType '"Bool",
                  scheduler_address = _js2n__-prdslib.isType '"String",
                  scheduler_dns_lookup_period =
                    _js2n__-prdslib.isType '"String",
                  scheduler_worker_concurrency =
                    _js2n__-prdslib.isType 'Integer,
                  tail_proxy_url = _js2n__-prdslib.isType '"String",
                  tail_tls_config =
                    _js2n__-refsenv."_js2n__-:definitions/tls_config!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/frontend_worker!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dns_lookup_duration = _js2n__-prdslib.isType '"String",
                  frontend_address = _js2n__-prdslib.isType '"String",
                  grpc_client_config =
                    _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  scheduler_address = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/gcs_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bucket_name = _js2n__-prdslib.isType '"String",
                  chunk_buffer_size = _js2n__-prdslib.isType 'Integer,
                  enable_http2 = _js2n__-prdslib.isType '"Bool",
                  enable_opencensus = _js2n__-prdslib.isType '"Bool",
                  enable_retries = _js2n__-prdslib.isType '"Bool",
                  request_timeout = _js2n__-prdslib.isType '"String",
                  service_account = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/grpc_client!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  backoff_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max_period = _js2n__-prdslib.isType '"String",
                              max_retries = _js2n__-prdslib.isType 'Integer,
                              min_period = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  backoff_on_ratelimits = _js2n__-prdslib.isType '"Bool",
                  connect_backoff_base_delay = _js2n__-prdslib.isType '"String",
                  connect_backoff_max_delay = _js2n__-prdslib.isType '"String",
                  connect_timeout = _js2n__-prdslib.isType '"String",
                  grpc_compression = _js2n__-prdslib.isType '"String",
                  initial_connection_window_size =
                    _js2n__-prdslib.isType '"String",
                  initial_stream_window_size = _js2n__-prdslib.isType '"String",
                  max_recv_msg_size = _js2n__-prdslib.isType 'Integer,
                  max_send_msg_size = _js2n__-prdslib.isType 'Integer,
                  rate_limit = _js2n__-prdslib.isType '"Number",
                  rate_limit_burst = _js2n__-prdslib.isType 'Integer,
                  tls_ca_path = _js2n__-prdslib.isType '"String",
                  tls_cert_path = _js2n__-prdslib.isType '"String",
                  tls_cipher_suites = _js2n__-prdslib.isType '"String",
                  tls_enabled = _js2n__-prdslib.isType '"Bool",
                  tls_insecure_skip_verify = _js2n__-prdslib.isType '"Bool",
                  tls_key_path = _js2n__-prdslib.isType '"String",
                  tls_min_version = _js2n__-prdslib.isType '"String",
                  tls_server_name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/index_gateway!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  mode = _js2n__-prdslib.isType '"String",
                  ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_addr = _js2n__-prdslib.isType '"String",
                              instance_availability_zone =
                                _js2n__-prdslib.isType '"String",
                              instance_enable_ipv6 =
                                _js2n__-prdslib.isType '"Bool",
                              instance_id = _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              instance_port = _js2n__-prdslib.isType 'Integer,
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              num_tokens = _js2n__-prdslib.always,
                              replication_factor =
                                _js2n__-prdslib.isType 'Integer,
                              tokens_file_path =
                                _js2n__-prdslib.isType '"String",
                              zone_awareness_enabled =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ingester!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  autoforget_unhealthy = _js2n__-prdslib.isType '"Bool",
                  chunk_block_size = _js2n__-prdslib.isType 'Integer,
                  chunk_encoding = _js2n__-prdslib.isType '"String",
                  chunk_idle_period = _js2n__-prdslib.isType '"String",
                  chunk_retain_period = _js2n__-prdslib.isType '"String",
                  chunk_target_size = _js2n__-prdslib.isType 'Integer,
                  concurrent_flushes = _js2n__-prdslib.isType 'Integer,
                  flush_check_period = _js2n__-prdslib.isType '"String",
                  flush_op_timeout = _js2n__-prdslib.isType '"String",
                  index_shards = _js2n__-prdslib.isType 'Integer,
                  lifecycler =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              address = _js2n__-prdslib.isType '"String",
                              availability_zone =
                                _js2n__-prdslib.isType '"String",
                              enable_inet6 = _js2n__-prdslib.isType '"Bool",
                              final_sleep = _js2n__-prdslib.isType '"String",
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              id = _js2n__-prdslib.isType '"String",
                              interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              join_after = _js2n__-prdslib.isType '"String",
                              min_ready_duration =
                                _js2n__-prdslib.isType '"String",
                              num_tokens = _js2n__-prdslib.isType 'Integer,
                              observe_period = _js2n__-prdslib.isType '"String",
                              port = _js2n__-prdslib.isType 'Integer,
                              readiness_check_ring_health =
                                _js2n__-prdslib.isType '"Bool",
                              ring =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          excluded_zones =
                                            _js2n__-prdslib.isType '"String",
                                          heartbeat_timeout =
                                            _js2n__-prdslib.isType '"String",
                                          kvstore =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      consul =
                                                        _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                                      etcd =
                                                        _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                                      multi =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  mirror_enabled =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  mirror_timeout =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  primary =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  secondary =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      prefix =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      store =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          replication_factor =
                                            _js2n__-prdslib.isType 'Integer,
                                          zone_awareness_enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              tokens_file_path =
                                _js2n__-prdslib.isType '"String",
                              unregister_on_shutdown =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  max_chunk_age = _js2n__-prdslib.isType '"String",
                  max_dropped_streams = _js2n__-prdslib.isType 'Integer,
                  max_returned_stream_errors = _js2n__-prdslib.isType 'Integer,
                  query_store_max_look_back_period =
                    _js2n__-prdslib.isType '"String",
                  shutdown_marker_path = _js2n__-prdslib.isType '"String",
                  sync_min_utilization = _js2n__-prdslib.isType '"Number",
                  sync_period = _js2n__-prdslib.isType '"String",
                  wal =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              checkpoint_duration =
                                _js2n__-prdslib.isType '"String",
                              dir = _js2n__-prdslib.isType '"String",
                              enabled = _js2n__-prdslib.isType '"Bool",
                              flush_on_shutdown =
                                _js2n__-prdslib.isType '"Bool",
                              replay_memory_ceiling =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ingester_client!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  grpc_client_config =
                    _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                  pool_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              client_cleanup_period =
                                _js2n__-prdslib.isType '"String",
                              health_check_ingesters =
                                _js2n__-prdslib.isType '"Bool",
                              remote_timeout = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  remote_timeout = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/limits_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_deletes = _js2n__-prdslib.isType '"Bool",
                  allow_structured_metadata = _js2n__-prdslib.isType '"Bool",
                  blocked_queries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Record)
                        ],
                  bloom_block_encoding = _js2n__-prdslib.isType '"String",
                  bloom_compactor_enable_compaction =
                    _js2n__-prdslib.isType '"Bool",
                  bloom_compactor_max_block_size =
                    _js2n__-prdslib.isType '"String",
                  bloom_compactor_max_bloom_size =
                    _js2n__-prdslib.isType '"String",
                  bloom_compactor_shard_size = _js2n__-prdslib.isType 'Integer,
                  bloom_false_positive_rate = _js2n__-prdslib.isType '"Number",
                  bloom_gateway_cache_key_interval =
                    _js2n__-prdslib.isType '"String",
                  bloom_gateway_enable_filtering =
                    _js2n__-prdslib.isType '"Bool",
                  bloom_gateway_shard_size = _js2n__-prdslib.isType 'Integer,
                  bloom_ngram_length = _js2n__-prdslib.isType 'Integer,
                  bloom_ngram_skip = _js2n__-prdslib.isType 'Integer,
                  cardinality_limit = _js2n__-prdslib.isType 'Integer,
                  creation_grace_period = _js2n__-prdslib.isType '"String",
                  deletion_mode = _js2n__-prdslib.isType '"String",
                  discover_log_levels = _js2n__-prdslib.isType '"Bool",
                  discover_service_name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  increment_duplicate_timestamp =
                    _js2n__-prdslib.isType '"Bool",
                  index_gateway_shard_size = _js2n__-prdslib.isType 'Integer,
                  ingestion_burst_size_mb = _js2n__-prdslib.isType '"Number",
                  ingestion_rate_mb = _js2n__-prdslib.isType '"Number",
                  ingestion_rate_strategy = _js2n__-prdslib.isType '"String",
                  max_cache_freshness_per_query =
                    _js2n__-prdslib.isType '"String",
                  max_chunks_per_query = _js2n__-prdslib.isType 'Integer,
                  max_concurrent_tail_requests =
                    _js2n__-prdslib.isType 'Integer,
                  max_entries_limit_per_query = _js2n__-prdslib.isType 'Integer,
                  max_global_streams_per_user = _js2n__-prdslib.isType 'Integer,
                  max_label_name_length = _js2n__-prdslib.isType 'Integer,
                  max_label_names_per_series = _js2n__-prdslib.isType 'Integer,
                  max_label_value_length = _js2n__-prdslib.isType 'Integer,
                  max_line_size = _js2n__-prdslib.isType '"String",
                  max_line_size_truncate = _js2n__-prdslib.isType '"Bool",
                  max_metadata_cache_freshness =
                    _js2n__-prdslib.isType '"String",
                  max_querier_bytes_read = _js2n__-prdslib.isType '"String",
                  max_queriers_per_tenant = _js2n__-prdslib.isType 'Integer,
                  max_query_bytes_read = _js2n__-prdslib.isType '"String",
                  max_query_capacity = _js2n__-prdslib.isType '"Number",
                  max_query_length = _js2n__-prdslib.isType '"String",
                  max_query_lookback = _js2n__-prdslib.isType '"String",
                  max_query_parallelism = _js2n__-prdslib.isType 'Integer,
                  max_query_range = _js2n__-prdslib.isType '"String",
                  max_query_series = _js2n__-prdslib.isType 'Integer,
                  max_stats_cache_freshness = _js2n__-prdslib.isType '"String",
                  max_streams_matchers_per_query =
                    _js2n__-prdslib.isType 'Integer,
                  max_streams_per_user = _js2n__-prdslib.isType 'Integer,
                  max_structured_metadata_entries_count =
                    _js2n__-prdslib.isType 'Integer,
                  max_structured_metadata_size =
                    _js2n__-prdslib.isType '"String",
                  min_sharding_lookback = _js2n__-prdslib.isType '"String",
                  minimum_labels_number = _js2n__-prdslib.isType 'Integer,
                  otlp_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              log_attributes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/attributes_config!predicate"
                                    ],
                              resource_attributes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          attributes_config =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.isType
                                                        'Null
                                                    ],
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    _js2n__-refsenv."_js2n__-:definitions/attributes_config!predicate"
                                                ],
                                          ignore_defaults =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              scope_attributes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/attributes_config!predicate"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  per_stream_rate_limit = _js2n__-prdslib.isType '"String",
                  per_stream_rate_limit_burst =
                    _js2n__-prdslib.isType '"String",
                  per_tenant_override_config = _js2n__-prdslib.isType '"String",
                  per_tenant_override_period = _js2n__-prdslib.isType '"String",
                  query_ready_index_num_days = _js2n__-prdslib.isType 'Integer,
                  query_timeout = _js2n__-prdslib.isType '"String",
                  recent_metadata_query_window =
                    _js2n__-prdslib.isType '"String",
                  reject_old_samples = _js2n__-prdslib.isType '"Bool",
                  reject_old_samples_max_age = _js2n__-prdslib.isType '"String",
                  required_labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  retention_period = _js2n__-prdslib.isType '"String",
                  retention_stream =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Record)
                        ],
                  ruler_max_rule_groups_per_tenant =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_max_rules_per_rule_group =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_remote_evaluation_max_response_size =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_remote_evaluation_timeout =
                    _js2n__-prdslib.isType '"String",
                  ruler_remote_write_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ruler/properties/remote_write!predicate"
                        ],
                  ruler_remote_write_disabled = _js2n__-prdslib.isType '"Bool",
                  ruler_remote_write_headers = _js2n__-prdslib.isType 'Record,
                  ruler_remote_write_queue_batch_send_deadline =
                    _js2n__-prdslib.isType '"String",
                  ruler_remote_write_queue_capacity =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_remote_write_queue_max_backoff =
                    _js2n__-prdslib.isType '"String",
                  ruler_remote_write_queue_max_samples_per_send =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_remote_write_queue_max_shards =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_remote_write_queue_min_backoff =
                    _js2n__-prdslib.isType '"String",
                  ruler_remote_write_queue_min_shards =
                    _js2n__-prdslib.isType 'Integer,
                  ruler_remote_write_queue_retry_on_ratelimit =
                    _js2n__-prdslib.isType '"Bool",
                  ruler_remote_write_relabel_configs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Record)
                        ],
                  ruler_remote_write_sigv4_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              access_key = _js2n__-prdslib.isType '"String",
                              profile = _js2n__-prdslib.isType '"String",
                              region = _js2n__-prdslib.isType '"String",
                              role_arn = _js2n__-prdslib.isType '"String",
                              secret_key = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  ruler_remote_write_timeout = _js2n__-prdslib.isType '"String",
                  ruler_remote_write_url = _js2n__-prdslib.isType '"String",
                  ruler_tenant_shard_size = _js2n__-prdslib.isType 'Integer,
                  shard_streams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              desired_rate = _js2n__-prdslib.isType 'Integer,
                              enabled = _js2n__-prdslib.isType '"Bool",
                              logging_enabled = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  split_ingester_queries_by_interval =
                    _js2n__-prdslib.isType '"String",
                  split_instant_metric_queries_by_interval =
                    _js2n__-prdslib.isType '"String",
                  split_metadata_queries_by_interval =
                    _js2n__-prdslib.isType '"String",
                  split_queries_by_interval = _js2n__-prdslib.isType '"String",
                  split_recent_metadata_queries_by_interval =
                    _js2n__-prdslib.isType '"String",
                  tsdb_max_bytes_per_shard = _js2n__-prdslib.isType '"String",
                  tsdb_max_query_parallelism = _js2n__-prdslib.isType 'Integer,
                  tsdb_sharding_strategy = _js2n__-prdslib.isType '"String",
                  unordered_writes = _js2n__-prdslib.isType '"Bool",
                  volume_enabled = _js2n__-prdslib.isType '"Bool",
                  volume_max_series = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/local_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { directory = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/memberlist!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  abort_if_cluster_join_fails = _js2n__-prdslib.isType '"Bool",
                  advertise_addr = _js2n__-prdslib.isType '"String",
                  advertise_port = _js2n__-prdslib.isType 'Integer,
                  bind_addr =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  bind_port = _js2n__-prdslib.isType 'Integer,
                  cluster_label = _js2n__-prdslib.isType '"String",
                  cluster_label_verification_disabled =
                    _js2n__-prdslib.isType '"Bool",
                  compression_enabled = _js2n__-prdslib.isType '"Bool",
                  dead_node_reclaim_time = _js2n__-prdslib.isType '"String",
                  gossip_interval = _js2n__-prdslib.isType '"String",
                  gossip_nodes = _js2n__-prdslib.isType 'Integer,
                  gossip_to_dead_nodes_time = _js2n__-prdslib.isType '"String",
                  join_members =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  leave_timeout = _js2n__-prdslib.isType '"String",
                  left_ingesters_timeout = _js2n__-prdslib.isType '"String",
                  max_join_backoff = _js2n__-prdslib.isType '"String",
                  max_join_retries = _js2n__-prdslib.isType 'Integer,
                  message_history_buffer_bytes =
                    _js2n__-prdslib.isType 'Integer,
                  min_join_backoff = _js2n__-prdslib.isType '"String",
                  node_name = _js2n__-prdslib.isType '"String",
                  packet_dial_timeout = _js2n__-prdslib.isType '"String",
                  packet_write_timeout = _js2n__-prdslib.isType '"String",
                  pull_push_interval = _js2n__-prdslib.isType '"String",
                  randomize_node_name = _js2n__-prdslib.isType '"Bool",
                  rejoin_interval = _js2n__-prdslib.isType '"String",
                  retransmit_factor = _js2n__-prdslib.isType 'Integer,
                  stream_timeout = _js2n__-prdslib.isType '"String",
                  tls_ca_path = _js2n__-prdslib.isType '"String",
                  tls_cert_path = _js2n__-prdslib.isType '"String",
                  tls_cipher_suites = _js2n__-prdslib.isType '"String",
                  tls_enabled = _js2n__-prdslib.isType '"Bool",
                  tls_insecure_skip_verify = _js2n__-prdslib.isType '"Bool",
                  tls_key_path = _js2n__-prdslib.isType '"String",
                  tls_min_version = _js2n__-prdslib.isType '"String",
                  tls_server_name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/named_stores_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alibabacloud =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/alibabacloud_storage_config!predicate"
                        ],
                  aws =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/aws_storage_config!predicate"
                        ],
                  azure =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/azure_storage_config!predicate"
                        ],
                  bos =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/bos_storage_config!predicate"
                        ],
                  cos =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/cos_storage_config!predicate"
                        ],
                  filesystem =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/local_storage_config!predicate"
                        ],
                  gcs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/gcs_storage_config!predicate"
                        ],
                  swift =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/swift_storage_config!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/operational_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  limited_log_push_errors = _js2n__-prdslib.isType '"Bool",
                  log_push_request = _js2n__-prdslib.isType '"Bool",
                  log_push_request_streams = _js2n__-prdslib.isType '"Bool",
                  log_stream_creation = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/period_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  chunks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              period = _js2n__-prdslib.isType '"String",
                              prefix = _js2n__-prdslib.isType '"String",
                              tags =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  from = _js2n__-prdslib.isType '"String",
                  index =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              path_prefix = _js2n__-prdslib.isType '"String",
                              period = _js2n__-prdslib.isType '"String",
                              prefix = _js2n__-prdslib.isType '"String",
                              tags =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  object_store = _js2n__-prdslib.isType '"String",
                  row_shards = _js2n__-prdslib.isType 'Integer,
                  schema = _js2n__-prdslib.isType '"String",
                  store = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/querier!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  engine =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max_look_back_period =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  extra_query_delay = _js2n__-prdslib.isType '"String",
                  max_concurrent = _js2n__-prdslib.isType 'Integer,
                  multi_tenant_queries_enabled = _js2n__-prdslib.isType '"Bool",
                  per_request_limits_enabled = _js2n__-prdslib.isType '"Bool",
                  query_ingester_only = _js2n__-prdslib.isType '"Bool",
                  query_ingesters_within = _js2n__-prdslib.isType '"String",
                  query_store_only = _js2n__-prdslib.isType '"Bool",
                  tail_max_duration = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/query_range!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  align_queries_with_step = _js2n__-prdslib.isType '"Bool",
                  cache_index_stats_results = _js2n__-prdslib.isType '"Bool",
                  cache_instant_metric_results = _js2n__-prdslib.isType '"Bool",
                  cache_label_results = _js2n__-prdslib.isType '"Bool",
                  cache_results = _js2n__-prdslib.isType '"Bool",
                  cache_series_results = _js2n__-prdslib.isType '"Bool",
                  cache_volume_results = _js2n__-prdslib.isType '"Bool",
                  index_stats_results_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              compression = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  instant_metric_query_split_align =
                    _js2n__-prdslib.isType '"Bool",
                  instant_metric_results_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              compression = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  label_results_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              compression = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  parallelise_shardable_queries =
                    _js2n__-prdslib.isType '"Bool",
                  results_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              compression = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  series_results_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              compression = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  shard_aggregations = _js2n__-prdslib.isType '"String",
                  volume_results_cache =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              compression = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/query_scheduler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  grpc_client_config =
                    _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                  max_outstanding_requests_per_tenant =
                    _js2n__-prdslib.isType 'Integer,
                  max_queue_hierarchy_levels = _js2n__-prdslib.isType 'Integer,
                  querier_forget_delay = _js2n__-prdslib.isType '"String",
                  scheduler_ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_addr = _js2n__-prdslib.isType '"String",
                              instance_availability_zone =
                                _js2n__-prdslib.isType '"String",
                              instance_enable_ipv6 =
                                _js2n__-prdslib.isType '"Bool",
                              instance_id = _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              instance_port = _js2n__-prdslib.isType 'Integer,
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              num_tokens = _js2n__-prdslib.always,
                              replication_factor = _js2n__-prdslib.always,
                              tokens_file_path =
                                _js2n__-prdslib.isType '"String",
                              zone_awareness_enabled =
                                _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  use_scheduler_ring = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ruler!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alert_relabel_configs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Record)
                        ],
                  alertmanager_client =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              basic_auth_password =
                                _js2n__-prdslib.isType '"String",
                              basic_auth_username =
                                _js2n__-prdslib.isType '"String",
                              credentials = _js2n__-prdslib.isType '"String",
                              credentials_file =
                                _js2n__-prdslib.isType '"String",
                              tls_ca_path = _js2n__-prdslib.isType '"String",
                              tls_cert_path = _js2n__-prdslib.isType '"String",
                              tls_cipher_suites =
                                _js2n__-prdslib.isType '"String",
                              tls_insecure_skip_verify =
                                _js2n__-prdslib.isType '"Bool",
                              tls_key_path = _js2n__-prdslib.isType '"String",
                              tls_min_version =
                                _js2n__-prdslib.isType '"String",
                              tls_server_name =
                                _js2n__-prdslib.isType '"String",
                              type = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  alertmanager_refresh_interval =
                    _js2n__-prdslib.isType '"String",
                  alertmanager_url = _js2n__-prdslib.isType '"String",
                  datasource_uid = _js2n__-prdslib.isType '"String",
                  disable_rule_group_label = _js2n__-prdslib.isType '"Bool",
                  disabled_tenants = _js2n__-prdslib.isType '"String",
                  enable_alertmanager_discovery =
                    _js2n__-prdslib.isType '"Bool",
                  enable_alertmanager_v2 = _js2n__-prdslib.isType '"Bool",
                  enable_api = _js2n__-prdslib.isType '"Bool",
                  enable_sharding = _js2n__-prdslib.isType '"Bool",
                  enabled_tenants = _js2n__-prdslib.isType '"String",
                  evaluation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max_jitter = _js2n__-prdslib.isType '"String",
                              mode = _js2n__-prdslib.isType '"String",
                              query_frontend =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          address =
                                            _js2n__-prdslib.isType '"String",
                                          tls_ca_path =
                                            _js2n__-prdslib.isType '"String",
                                          tls_cert_path =
                                            _js2n__-prdslib.isType '"String",
                                          tls_cipher_suites =
                                            _js2n__-prdslib.isType '"String",
                                          tls_enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          tls_insecure_skip_verify =
                                            _js2n__-prdslib.isType '"Bool",
                                          tls_key_path =
                                            _js2n__-prdslib.isType '"String",
                                          tls_min_version =
                                            _js2n__-prdslib.isType '"String",
                                          tls_server_name =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  evaluation_interval = _js2n__-prdslib.isType '"String",
                  external_labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  external_url = _js2n__-prdslib.isType '"String",
                  flush_period = _js2n__-prdslib.isType '"String",
                  for_grace_period = _js2n__-prdslib.isType '"String",
                  for_outage_tolerance = _js2n__-prdslib.isType '"String",
                  notification_queue_capacity = _js2n__-prdslib.isType 'Integer,
                  notification_timeout = _js2n__-prdslib.isType '"String",
                  poll_interval = _js2n__-prdslib.isType '"String",
                  query_stats_enabled = _js2n__-prdslib.isType '"Bool",
                  remote_write =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              add_org_id_header =
                                _js2n__-prdslib.isType '"Bool",
                              client =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-refsenv."_js2n__-:definitions/ruler/properties/remote_write!predicate"
                                    ],
                              clients =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-refsenv."_js2n__-:definitions/ruler/properties/remote_write!predicate"
                                    ],
                              config_refresh_period =
                                _js2n__-prdslib.isType '"String",
                              enabled = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  resend_delay = _js2n__-prdslib.isType '"String",
                  ring =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              heartbeat_period =
                                _js2n__-prdslib.isType '"String",
                              heartbeat_timeout =
                                _js2n__-prdslib.isType '"String",
                              instance_interface_names =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              kvstore =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          consul =
                                            _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                          etcd =
                                            _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                          multi =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mirror_enabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      mirror_timeout =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      primary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      secondary =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          store =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              num_tokens = _js2n__-prdslib.isType 'Integer,
                            } {} true _js2n__-prdslib.always
                        ],
                  rule_path = _js2n__-prdslib.isType '"String",
                  ruler_client =
                    _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                  search_pending_for = _js2n__-prdslib.isType '"String",
                  sharding_algo = _js2n__-prdslib.isType '"String",
                  sharding_strategy = _js2n__-prdslib.isType '"String",
                  storage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              alibabacloud =
                                _js2n__-refsenv."_js2n__-:definitions/alibabacloud_storage_config!predicate",
                              azure =
                                _js2n__-refsenv."_js2n__-:definitions/azure_storage_config!predicate",
                              bos =
                                _js2n__-refsenv."_js2n__-:definitions/bos_storage_config!predicate",
                              cos =
                                _js2n__-refsenv."_js2n__-:definitions/cos_storage_config!predicate",
                              gcs =
                                _js2n__-refsenv."_js2n__-:definitions/gcs_storage_config!predicate",
                              local =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          directory =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              s3 =
                                _js2n__-refsenv."_js2n__-:definitions/s3_storage_config!predicate",
                              swift =
                                _js2n__-refsenv."_js2n__-:definitions/swift_storage_config!predicate",
                              type = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  wal =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dir = _js2n__-prdslib.isType '"String",
                              max_age = _js2n__-prdslib.isType '"String",
                              min_age = _js2n__-prdslib.isType '"String",
                              truncate_frequency =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  wal_cleaner =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              min_age = _js2n__-prdslib.isType '"String",
                              period = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ruler/properties/remote_write!predicate"
        | doc "Remote-write configuration to send rule samples to a Prometheus remote-write endpoint."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  add_org_id_header = _js2n__-prdslib.isType '"Bool",
                  client =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/ruler/properties/remote_write!predicate"
                        ],
                  clients =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ruler/properties/remote_write!predicate"
                        ],
                  config_refresh_period = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/runtime_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file = _js2n__-prdslib.isType '"String",
                  period = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/s3_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  access_key_id = _js2n__-prdslib.isType '"String",
                  backoff_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max_period = _js2n__-prdslib.isType '"String",
                              max_retries = _js2n__-prdslib.isType 'Integer,
                              min_period = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  bucketnames = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  http_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ca_file = _js2n__-prdslib.isType '"String",
                              idle_conn_timeout =
                                _js2n__-prdslib.isType '"String",
                              insecure_skip_verify =
                                _js2n__-prdslib.isType '"Bool",
                              response_header_timeout =
                                _js2n__-prdslib.isType '"String",
                              timeout = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  insecure = _js2n__-prdslib.isType '"Bool",
                  region = _js2n__-prdslib.isType '"String",
                  s3 = _js2n__-prdslib.isType '"String",
                  s3forcepathstyle = _js2n__-prdslib.isType '"Bool",
                  secret_access_key = _js2n__-prdslib.isType '"String",
                  session_token = _js2n__-prdslib.isType '"String",
                  signature_version = _js2n__-prdslib.isType '"String",
                  sse =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              kms_encryption_context =
                                _js2n__-prdslib.isType '"String",
                              kms_key_id = _js2n__-prdslib.isType '"String",
                              type = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  storage_class = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/schema_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/period_config!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/server!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  graceful_shutdown_timeout = _js2n__-prdslib.isType '"String",
                  grpc_listen_address = _js2n__-prdslib.isType '"String",
                  grpc_listen_conn_limit = _js2n__-prdslib.isType 'Integer,
                  grpc_listen_network = _js2n__-prdslib.isType '"String",
                  grpc_listen_port = _js2n__-prdslib.isType 'Integer,
                  grpc_server_keepalive_time = _js2n__-prdslib.isType '"String",
                  grpc_server_keepalive_timeout =
                    _js2n__-prdslib.isType '"String",
                  grpc_server_max_concurrent_streams =
                    _js2n__-prdslib.isType 'Integer,
                  grpc_server_max_connection_age =
                    _js2n__-prdslib.isType '"String",
                  grpc_server_max_connection_age_grace =
                    _js2n__-prdslib.isType '"String",
                  grpc_server_max_connection_idle =
                    _js2n__-prdslib.isType '"String",
                  grpc_server_max_recv_msg_size =
                    _js2n__-prdslib.isType 'Integer,
                  grpc_server_max_send_msg_size =
                    _js2n__-prdslib.isType 'Integer,
                  grpc_server_min_time_between_pings =
                    _js2n__-prdslib.isType '"String",
                  grpc_server_num_workers = _js2n__-prdslib.isType 'Integer,
                  grpc_server_ping_without_stream_allowed =
                    _js2n__-prdslib.isType '"Bool",
                  grpc_tls_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cert = _js2n__-prdslib.isType '"String",
                              cert_file = _js2n__-prdslib.isType '"String",
                              client_auth_type =
                                _js2n__-prdslib.isType '"String",
                              client_ca = _js2n__-prdslib.isType '"String",
                              client_ca_file = _js2n__-prdslib.isType '"String",
                              key = _js2n__-prdslib.isType '"String",
                              key_file = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  http_listen_address = _js2n__-prdslib.isType '"String",
                  http_listen_conn_limit = _js2n__-prdslib.isType 'Integer,
                  http_listen_network = _js2n__-prdslib.isType '"String",
                  http_listen_port = _js2n__-prdslib.isType 'Integer,
                  http_log_closed_connections_without_response_enabled =
                    _js2n__-prdslib.isType '"Bool",
                  http_path_prefix = _js2n__-prdslib.isType '"String",
                  http_server_idle_timeout = _js2n__-prdslib.isType '"String",
                  http_server_read_header_timeout =
                    _js2n__-prdslib.isType '"String",
                  http_server_read_timeout = _js2n__-prdslib.isType '"String",
                  http_server_write_timeout = _js2n__-prdslib.isType '"String",
                  http_tls_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cert = _js2n__-prdslib.isType '"String",
                              cert_file = _js2n__-prdslib.isType '"String",
                              client_auth_type =
                                _js2n__-prdslib.isType '"String",
                              client_ca = _js2n__-prdslib.isType '"String",
                              client_ca_file = _js2n__-prdslib.isType '"String",
                              key = _js2n__-prdslib.isType '"String",
                              key_file = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  log_format = _js2n__-prdslib.isType '"String",
                  log_level = _js2n__-prdslib.isType '"String",
                  log_request_at_info_level_enabled =
                    _js2n__-prdslib.isType '"Bool",
                  log_request_exclude_headers_list =
                    _js2n__-prdslib.isType '"String",
                  log_request_headers = _js2n__-prdslib.isType '"Bool",
                  log_source_ips_enabled = _js2n__-prdslib.isType '"Bool",
                  log_source_ips_header = _js2n__-prdslib.isType '"String",
                  log_source_ips_regex = _js2n__-prdslib.isType '"String",
                  register_instrumentation = _js2n__-prdslib.isType '"Bool",
                  report_grpc_codes_in_instrumentation_label_enabled =
                    _js2n__-prdslib.isType '"Bool",
                  tls_cipher_suites = _js2n__-prdslib.isType '"String",
                  tls_min_version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alibabacloud =
                    _js2n__-refsenv."_js2n__-:definitions/alibabacloud_storage_config!predicate",
                  aws =
                    _js2n__-refsenv."_js2n__-:definitions/aws_storage_config!predicate",
                  azure =
                    _js2n__-refsenv."_js2n__-:definitions/azure_storage_config!predicate",
                  bigtable =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              grpc_client_config =
                                _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                              instance = _js2n__-prdslib.isType '"String",
                              project = _js2n__-prdslib.isType '"String",
                              table_cache_enabled =
                                _js2n__-prdslib.isType '"Bool",
                              table_cache_expiration =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  bloom_shipper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              blocks_cache =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          hard_limit =
                                            _js2n__-prdslib.isType '"String",
                                          soft_limit =
                                            _js2n__-prdslib.isType '"String",
                                          ttl =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              download_parallelism =
                                _js2n__-prdslib.isType 'Integer,
                              max_query_page_size =
                                _js2n__-prdslib.isType '"String",
                              metas_cache =
                                _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                              working_directory =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  boltdb =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { directory = _js2n__-prdslib.isType '"String", } {}
                            true _js2n__-prdslib.always
                        ],
                  boltdb_shipper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              active_index_directory =
                                _js2n__-prdslib.isType '"String",
                              build_per_tenant_index =
                                _js2n__-prdslib.isType '"Bool",
                              cache_location = _js2n__-prdslib.isType '"String",
                              cache_ttl = _js2n__-prdslib.isType '"String",
                              index_gateway_client =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          grpc_client_config =
                                            _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                                          log_gateway_requests =
                                            _js2n__-prdslib.isType '"Bool",
                                          server_address =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              ingesterdbretainperiod =
                                _js2n__-prdslib.isType '"String",
                              ingestername = _js2n__-prdslib.isType '"String",
                              mode = _js2n__-prdslib.isType '"String",
                              query_ready_num_days =
                                _js2n__-prdslib.isType 'Integer,
                              resync_interval =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  bos =
                    _js2n__-refsenv."_js2n__-:definitions/bos_storage_config!predicate",
                  cassandra =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              CA_path = _js2n__-prdslib.isType '"String",
                              SSL = _js2n__-prdslib.isType '"Bool",
                              addresses = _js2n__-prdslib.isType '"String",
                              auth = _js2n__-prdslib.isType '"Bool",
                              connect_timeout =
                                _js2n__-prdslib.isType '"String",
                              consistency = _js2n__-prdslib.isType '"String",
                              convict_hosts_on_failure =
                                _js2n__-prdslib.isType '"Bool",
                              custom_authenticators =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              disable_initial_host_lookup =
                                _js2n__-prdslib.isType '"Bool",
                              host_selection_policy =
                                _js2n__-prdslib.isType '"String",
                              host_verification =
                                _js2n__-prdslib.isType '"Bool",
                              keyspace = _js2n__-prdslib.isType '"String",
                              max_retries = _js2n__-prdslib.isType 'Integer,
                              num_connections = _js2n__-prdslib.isType 'Integer,
                              password = _js2n__-prdslib.isType '"String",
                              password_file = _js2n__-prdslib.isType '"String",
                              port = _js2n__-prdslib.isType 'Integer,
                              query_concurrency =
                                _js2n__-prdslib.isType 'Integer,
                              reconnect_interval =
                                _js2n__-prdslib.isType '"String",
                              replication_factor =
                                _js2n__-prdslib.isType 'Integer,
                              retry_max_backoff =
                                _js2n__-prdslib.isType '"String",
                              retry_min_backoff =
                                _js2n__-prdslib.isType '"String",
                              table_options = _js2n__-prdslib.isType '"String",
                              timeout = _js2n__-prdslib.isType '"String",
                              tls_cert_path = _js2n__-prdslib.isType '"String",
                              tls_key_path = _js2n__-prdslib.isType '"String",
                              username = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  congestion_control =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              controller =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          aimd =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      backoff_factor =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      start =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      upper_bound =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          strategy =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              enabled = _js2n__-prdslib.isType '"Bool",
                              hedging =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          config =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      at =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      max_per_second =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      up_to =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          strategy =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              retry =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          limit =
                                            _js2n__-prdslib.isType 'Integer,
                                          strategy =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  cos =
                    _js2n__-refsenv."_js2n__-:definitions/cos_storage_config!predicate",
                  disable_broad_index_queries = _js2n__-prdslib.isType '"Bool",
                  filesystem =
                    _js2n__-refsenv."_js2n__-:definitions/local_storage_config!predicate",
                  gcs =
                    _js2n__-refsenv."_js2n__-:definitions/gcs_storage_config!predicate",
                  grpc_store =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              server_address = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  hedging =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              at = _js2n__-prdslib.isType '"String",
                              max_per_second = _js2n__-prdslib.isType 'Integer,
                              up_to = _js2n__-prdslib.isType 'Integer,
                            } {} true _js2n__-prdslib.always
                        ],
                  index_cache_validity = _js2n__-prdslib.isType '"String",
                  index_queries_cache_config =
                    _js2n__-refsenv."_js2n__-:definitions/cache_config!predicate",
                  max_chunk_batch_size = _js2n__-prdslib.isType 'Integer,
                  max_parallel_get_chunk = _js2n__-prdslib.isType 'Integer,
                  named_stores =
                    _js2n__-refsenv."_js2n__-:definitions/named_stores_config!predicate",
                  object_prefix = _js2n__-prdslib.isType '"String",
                  swift =
                    _js2n__-refsenv."_js2n__-:definitions/swift_storage_config!predicate",
                  tsdb_shipper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              active_index_directory =
                                _js2n__-prdslib.isType '"String",
                              cache_location = _js2n__-prdslib.isType '"String",
                              cache_ttl = _js2n__-prdslib.isType '"String",
                              index_gateway_client =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          grpc_client_config =
                                            _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                                          log_gateway_requests =
                                            _js2n__-prdslib.isType '"Bool",
                                          server_address =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              ingesterdbretainperiod =
                                _js2n__-prdslib.isType '"String",
                              ingestername = _js2n__-prdslib.isType '"String",
                              mode = _js2n__-prdslib.isType '"String",
                              query_ready_num_days =
                                _js2n__-prdslib.isType 'Integer,
                              resync_interval =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/swift_storage_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auth_url = _js2n__-prdslib.isType '"String",
                  auth_version = _js2n__-prdslib.isType 'Integer,
                  connect_timeout = _js2n__-prdslib.isType '"String",
                  container_name = _js2n__-prdslib.isType '"String",
                  domain_id = _js2n__-prdslib.isType '"String",
                  domain_name = _js2n__-prdslib.isType '"String",
                  internal = _js2n__-prdslib.isType '"Bool",
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  password = _js2n__-prdslib.isType '"String",
                  project_domain_id = _js2n__-prdslib.isType '"String",
                  project_domain_name = _js2n__-prdslib.isType '"String",
                  project_id = _js2n__-prdslib.isType '"String",
                  project_name = _js2n__-prdslib.isType '"String",
                  region_name = _js2n__-prdslib.isType '"String",
                  request_timeout = _js2n__-prdslib.isType '"String",
                  user_domain_id = _js2n__-prdslib.isType '"String",
                  user_domain_name = _js2n__-prdslib.isType '"String",
                  user_id = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/table_manager!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  chunk_tables_provisioning =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enable_inactive_throughput_on_demand_mode =
                                _js2n__-prdslib.isType '"Bool",
                              enable_ondemand_throughput_mode =
                                _js2n__-prdslib.isType '"Bool",
                              inactive_read_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              inactive_read_scale_lastn =
                                _js2n__-prdslib.isType 'Integer,
                              inactive_read_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              inactive_write_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              inactive_write_scale_lastn =
                                _js2n__-prdslib.isType 'Integer,
                              inactive_write_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              provisioned_read_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              provisioned_write_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              read_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              write_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  creation_grace_period = _js2n__-prdslib.isType '"String",
                  index_tables_provisioning =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enable_inactive_throughput_on_demand_mode =
                                _js2n__-prdslib.isType '"Bool",
                              enable_ondemand_throughput_mode =
                                _js2n__-prdslib.isType '"Bool",
                              inactive_read_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              inactive_read_scale_lastn =
                                _js2n__-prdslib.isType 'Integer,
                              inactive_read_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              inactive_write_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              inactive_write_scale_lastn =
                                _js2n__-prdslib.isType 'Integer,
                              inactive_write_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              provisioned_read_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              provisioned_write_throughput =
                                _js2n__-prdslib.isType 'Integer,
                              read_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              write_scale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          max_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          min_capacity =
                                            _js2n__-prdslib.isType 'Integer,
                                          out_cooldown =
                                            _js2n__-prdslib.isType 'Integer,
                                          role_arn =
                                            _js2n__-prdslib.isType '"String",
                                          target =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  poll_interval = _js2n__-prdslib.isType '"String",
                  retention_deletes_enabled = _js2n__-prdslib.isType '"Bool",
                  retention_period = _js2n__-prdslib.isType '"String",
                  throughput_updates_disabled = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tls_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  tls_ca_path = _js2n__-prdslib.isType '"String",
                  tls_cert_path = _js2n__-prdslib.isType '"String",
                  tls_cipher_suites = _js2n__-prdslib.isType '"String",
                  tls_insecure_skip_verify = _js2n__-prdslib.isType '"Bool",
                  tls_key_path = _js2n__-prdslib.isType '"String",
                  tls_min_version = _js2n__-prdslib.isType '"String",
                  tls_server_name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tracing!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { enabled = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.isType 'Null ],
          _js2n__-prdslib.records.record
            {
              analytics =
                _js2n__-refsenv."_js2n__-:definitions/analytics!predicate",
              auth_enabled = _js2n__-prdslib.isType '"Bool",
              ballast_bytes = _js2n__-prdslib.isType 'Integer,
              bloom_compactor =
                _js2n__-refsenv."_js2n__-:definitions/bloom_compactor!predicate",
              bloom_gateway =
                _js2n__-refsenv."_js2n__-:definitions/bloom_gateway!predicate",
              chunk_store_config =
                _js2n__-refsenv."_js2n__-:definitions/chunk_store_config!predicate",
              common = _js2n__-refsenv."_js2n__-:definitions/common!predicate",
              compactor =
                _js2n__-refsenv."_js2n__-:definitions/compactor!predicate",
              compactor_grpc_client =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          backoff_config =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      max_period =
                                        _js2n__-prdslib.isType '"String",
                                      max_retries =
                                        _js2n__-prdslib.isType 'Integer,
                                      min_period =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          backoff_on_ratelimits =
                            _js2n__-prdslib.isType '"Bool",
                          connect_backoff_base_delay =
                            _js2n__-prdslib.isType '"String",
                          connect_backoff_max_delay =
                            _js2n__-prdslib.isType '"String",
                          connect_timeout = _js2n__-prdslib.isType '"String",
                          grpc_compression = _js2n__-prdslib.isType '"String",
                          initial_connection_window_size =
                            _js2n__-prdslib.isType '"String",
                          initial_stream_window_size =
                            _js2n__-prdslib.isType '"String",
                          max_recv_msg_size = _js2n__-prdslib.isType 'Integer,
                          max_send_msg_size = _js2n__-prdslib.isType 'Integer,
                          rate_limit = _js2n__-prdslib.isType '"Number",
                          rate_limit_burst = _js2n__-prdslib.isType 'Integer,
                          tls_ca_path = _js2n__-prdslib.isType '"String",
                          tls_cert_path = _js2n__-prdslib.isType '"String",
                          tls_cipher_suites = _js2n__-prdslib.isType '"String",
                          tls_enabled = _js2n__-prdslib.isType '"Bool",
                          tls_insecure_skip_verify =
                            _js2n__-prdslib.isType '"Bool",
                          tls_key_path = _js2n__-prdslib.isType '"String",
                          tls_min_version = _js2n__-prdslib.isType '"String",
                          tls_server_name = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              distributor =
                _js2n__-refsenv."_js2n__-:definitions/distributor!predicate",
              frontend =
                _js2n__-refsenv."_js2n__-:definitions/frontend!predicate",
              frontend_worker =
                _js2n__-refsenv."_js2n__-:definitions/frontend_worker!predicate",
              index_gateway =
                _js2n__-refsenv."_js2n__-:definitions/index_gateway!predicate",
              ingester =
                _js2n__-refsenv."_js2n__-:definitions/ingester!predicate",
              ingester_client =
                _js2n__-refsenv."_js2n__-:definitions/ingester_client!predicate",
              limits_config =
                _js2n__-refsenv."_js2n__-:definitions/limits_config!predicate",
              memberlist =
                _js2n__-refsenv."_js2n__-:definitions/memberlist!predicate",
              metrics_namespace = _js2n__-prdslib.isType '"String",
              operational_config =
                _js2n__-refsenv."_js2n__-:definitions/operational_config!predicate",
              pattern_ingester =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          client_config =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      grpc_client_config =
                                        _js2n__-refsenv."_js2n__-:definitions/grpc_client!predicate",
                                      pool_config =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  client_cleanup_period =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  health_check_ingesters =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  remote_timeout =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      remote_timeout =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          concurrent_flushes = _js2n__-prdslib.isType 'Integer,
                          enabled = _js2n__-prdslib.isType '"Bool",
                          flush_check_period = _js2n__-prdslib.isType '"String",
                          lifecycler =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                      availability_zone =
                                        _js2n__-prdslib.isType '"String",
                                      enable_inet6 =
                                        _js2n__-prdslib.isType '"Bool",
                                      final_sleep =
                                        _js2n__-prdslib.isType '"String",
                                      heartbeat_period =
                                        _js2n__-prdslib.isType '"String",
                                      heartbeat_timeout =
                                        _js2n__-prdslib.isType '"String",
                                      id = _js2n__-prdslib.isType '"String",
                                      interface_names =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      join_after =
                                        _js2n__-prdslib.isType '"String",
                                      min_ready_duration =
                                        _js2n__-prdslib.isType '"String",
                                      num_tokens =
                                        _js2n__-prdslib.isType 'Integer,
                                      observe_period =
                                        _js2n__-prdslib.isType '"String",
                                      port = _js2n__-prdslib.isType 'Integer,
                                      readiness_check_ring_health =
                                        _js2n__-prdslib.isType '"Bool",
                                      ring =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  excluded_zones =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  heartbeat_timeout =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  kvstore =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              consul =
                                                                _js2n__-refsenv."_js2n__-:definitions/consul!predicate",
                                                              etcd =
                                                                _js2n__-refsenv."_js2n__-:definitions/etcd!predicate",
                                                              multi =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          mirror_enabled =
                                                                            _js2n__-prdslib.isType
                                                                                '"Bool",
                                                                          mirror_timeout =
                                                                            _js2n__-prdslib.isType
                                                                                '"String",
                                                                          primary =
                                                                            _js2n__-prdslib.isType
                                                                                '"String",
                                                                          secondary =
                                                                            _js2n__-prdslib.isType
                                                                                '"String",
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                              prefix =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              store =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  replication_factor =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                  zone_awareness_enabled =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      tokens_file_path =
                                        _js2n__-prdslib.isType '"String",
                                      unregister_on_shutdown =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              querier =
                _js2n__-refsenv."_js2n__-:definitions/querier!predicate",
              query_range =
                _js2n__-refsenv."_js2n__-:definitions/query_range!predicate",
              query_scheduler =
                _js2n__-refsenv."_js2n__-:definitions/query_scheduler!predicate",
              ruler = _js2n__-refsenv."_js2n__-:definitions/ruler!predicate",
              runtime_config =
                _js2n__-refsenv."_js2n__-:definitions/runtime_config!predicate",
              schema_config =
                _js2n__-refsenv."_js2n__-:definitions/schema_config!predicate",
              server = _js2n__-refsenv."_js2n__-:definitions/server!predicate",
              shutdown_delay = _js2n__-prdslib.isType '"String",
              storage_config =
                _js2n__-refsenv."_js2n__-:definitions/storage_config!predicate",
              table_manager =
                _js2n__-refsenv."_js2n__-:definitions/table_manager!predicate",
              target = _js2n__-prdslib.isType '"String",
              tracing =
                _js2n__-refsenv."_js2n__-:definitions/tracing!predicate",
            } {} false _js2n__-prdslib.never
        ])