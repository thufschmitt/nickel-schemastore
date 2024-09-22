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
    = {}
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              "$schema" = _js2n__-prdslib.isType '"String",
              MD001 = _js2n__-prdslib.isType '"Bool",
              MD003 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "consistent",
                                      "atx",
                                      "atx_closed",
                                      "setext",
                                      "setext_with_atx",
                                      "setext_with_atx_closed"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD004 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "consistent",
                                      "asterisk",
                                      "plus",
                                      "dash",
                                      "sublist"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD005 = _js2n__-prdslib.isType '"Bool",
              MD007 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          indent =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          start_indent =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          start_indented = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              MD009 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          br_spaces =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          list_item_empty_lines =
                            _js2n__-prdslib.isType '"Bool",
                          strict = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              MD010 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          code_blocks = _js2n__-prdslib.isType '"Bool",
                          ignore_code_languages =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          spaces_per_tab =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD011 = _js2n__-prdslib.isType '"Bool",
              MD012 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          maximum =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD013 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          code_block_line_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          code_blocks = _js2n__-prdslib.isType '"Bool",
                          heading_line_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          headings = _js2n__-prdslib.isType '"Bool",
                          line_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          stern = _js2n__-prdslib.isType '"Bool",
                          strict = _js2n__-prdslib.isType '"Bool",
                          tables = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              MD014 = _js2n__-prdslib.isType '"Bool",
              MD018 = _js2n__-prdslib.isType '"Bool",
              MD019 = _js2n__-prdslib.isType '"Bool",
              MD020 = _js2n__-prdslib.isType '"Bool",
              MD021 = _js2n__-prdslib.isType '"Bool",
              MD022 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          lines_above =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"Array"
                                    ],
                                  _js2n__-prdslib.numbers.minimum (-1),
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType 'Integer)
                                ],
                          lines_below =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"Array"
                                    ],
                                  _js2n__-prdslib.numbers.minimum (-1),
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType 'Integer)
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD023 = _js2n__-prdslib.isType '"Bool",
              MD024 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { siblings_only = _js2n__-prdslib.isType '"Bool", } {}
                        false _js2n__-prdslib.never
                    ],
              MD025 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          front_matter_title = _js2n__-prdslib.isType '"String",
                          level =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum 6,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD026 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { punctuation = _js2n__-prdslib.isType '"String", } {}
                        false _js2n__-prdslib.never
                    ],
              MD027 = _js2n__-prdslib.isType '"Bool",
              MD028 = _js2n__-prdslib.isType '"Bool",
              MD029 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "one",
                                      "ordered",
                                      "one_or_ordered",
                                      "zero"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD030 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          ol_multi =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          ol_single =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          ul_multi =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          ul_single =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD031 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { list_items = _js2n__-prdslib.isType '"Bool", } {}
                        false _js2n__-prdslib.never
                    ],
              MD032 = _js2n__-prdslib.isType '"Bool",
              MD033 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          allowed_elements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD034 = _js2n__-prdslib.isType '"Bool",
              MD035 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { style = _js2n__-prdslib.isType '"String", } {} false
                        _js2n__-prdslib.never
                    ],
              MD036 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { punctuation = _js2n__-prdslib.isType '"String", } {}
                        false _js2n__-prdslib.never
                    ],
              MD037 = _js2n__-prdslib.isType '"Bool",
              MD038 = _js2n__-prdslib.isType '"Bool",
              MD039 = _js2n__-prdslib.isType '"Bool",
              MD040 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          allowed_languages =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          language_only = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              MD041 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          front_matter_title = _js2n__-prdslib.isType '"String",
                          level =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum 6,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD042 = _js2n__-prdslib.isType '"Bool",
              MD043 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          headings =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.pattern
                                          "^(\\*|\\+|#{1,6} .*)$"
                                      ])
                                ],
                          match_case = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              MD044 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          code_blocks = _js2n__-prdslib.isType '"Bool",
                          html_elements = _js2n__-prdslib.isType '"Bool",
                          names =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD045 = _js2n__-prdslib.isType '"Bool",
              MD046 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "fenced", "indented" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD047 = _js2n__-prdslib.isType '"Bool",
              MD048 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "backtick", "tilde" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD049 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "asterisk", "underscore" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD050 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "asterisk", "underscore" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD051 = _js2n__-prdslib.isType '"Bool",
              MD052 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { shortcut_syntax = _js2n__-prdslib.isType '"Bool", } {}
                        false _js2n__-prdslib.never
                    ],
              MD053 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          ignored_definitions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD054 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          autolink = _js2n__-prdslib.isType '"Bool",
                          collapsed = _js2n__-prdslib.isType '"Bool",
                          full = _js2n__-prdslib.isType '"Bool",
                          inline = _js2n__-prdslib.isType '"Bool",
                          shortcut = _js2n__-prdslib.isType '"Bool",
                          url_inline = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              MD055 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "consistent",
                                      "leading_only",
                                      "trailing_only",
                                      "leading_and_trailing",
                                      "no_leading_or_trailing"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              MD056 = _js2n__-prdslib.isType '"Bool",
              MD058 = _js2n__-prdslib.isType '"Bool",
              accessibility = _js2n__-prdslib.isType '"Bool",
              atx = _js2n__-prdslib.isType '"Bool",
              atx_closed = _js2n__-prdslib.isType '"Bool",
              blank_lines = _js2n__-prdslib.isType '"Bool",
              blanks-around-fences =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { list_items = _js2n__-prdslib.isType '"Bool", } {}
                        false _js2n__-prdslib.never
                    ],
              blanks-around-headings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          lines_above =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"Array"
                                    ],
                                  _js2n__-prdslib.numbers.minimum (-1),
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType 'Integer)
                                ],
                          lines_below =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"Array"
                                    ],
                                  _js2n__-prdslib.numbers.minimum (-1),
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType 'Integer)
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              blanks-around-lists = _js2n__-prdslib.isType '"Bool",
              blanks-around-tables = _js2n__-prdslib.isType '"Bool",
              blockquote = _js2n__-prdslib.isType '"Bool",
              bullet = _js2n__-prdslib.isType '"Bool",
              code = _js2n__-prdslib.isType '"Bool",
              code-block-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "fenced", "indented" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              code-fence-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "backtick", "tilde" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              commands-show-output = _js2n__-prdslib.isType '"Bool",
              "default" = _js2n__-prdslib.isType '"Bool",
              emphasis = _js2n__-prdslib.isType '"Bool",
              emphasis-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "asterisk", "underscore" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              extends =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Null
                    ],
              fenced-code-language =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          allowed_languages =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          language_only = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              first-line-h1 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          front_matter_title = _js2n__-prdslib.isType '"String",
                          level =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum 6,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              first-line-heading =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          front_matter_title = _js2n__-prdslib.isType '"String",
                          level =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum 6,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              hard_tab = _js2n__-prdslib.isType '"Bool",
              heading-increment = _js2n__-prdslib.isType '"Bool",
              heading-start-left = _js2n__-prdslib.isType '"Bool",
              heading-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "consistent",
                                      "atx",
                                      "atx_closed",
                                      "setext",
                                      "setext_with_atx",
                                      "setext_with_atx_closed"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              headings = _js2n__-prdslib.isType '"Bool",
              hr = _js2n__-prdslib.isType '"Bool",
              hr-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { style = _js2n__-prdslib.isType '"String", } {} false
                        _js2n__-prdslib.never
                    ],
              html = _js2n__-prdslib.isType '"Bool",
              images = _js2n__-prdslib.isType '"Bool",
              indentation = _js2n__-prdslib.isType '"Bool",
              language = _js2n__-prdslib.isType '"Bool",
              line-length =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          code_block_line_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          code_blocks = _js2n__-prdslib.isType '"Bool",
                          heading_line_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          headings = _js2n__-prdslib.isType '"Bool",
                          line_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          stern = _js2n__-prdslib.isType '"Bool",
                          strict = _js2n__-prdslib.isType '"Bool",
                          tables = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              line_length = _js2n__-prdslib.isType '"Bool",
              link-fragments = _js2n__-prdslib.isType '"Bool",
              link-image-reference-definitions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          ignored_definitions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              link-image-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          autolink = _js2n__-prdslib.isType '"Bool",
                          collapsed = _js2n__-prdslib.isType '"Bool",
                          full = _js2n__-prdslib.isType '"Bool",
                          inline = _js2n__-prdslib.isType '"Bool",
                          shortcut = _js2n__-prdslib.isType '"Bool",
                          url_inline = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              links = _js2n__-prdslib.isType '"Bool",
              list-indent = _js2n__-prdslib.isType '"Bool",
              list-marker-space =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          ol_multi =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          ol_single =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          ul_multi =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          ul_single =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              no-alt-text = _js2n__-prdslib.isType '"Bool",
              no-bare-urls = _js2n__-prdslib.isType '"Bool",
              no-blanks-blockquote = _js2n__-prdslib.isType '"Bool",
              no-duplicate-heading =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { siblings_only = _js2n__-prdslib.isType '"Bool", } {}
                        false _js2n__-prdslib.never
                    ],
              no-emphasis-as-heading =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { punctuation = _js2n__-prdslib.isType '"String", } {}
                        false _js2n__-prdslib.never
                    ],
              no-empty-links = _js2n__-prdslib.isType '"Bool",
              no-hard-tabs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          code_blocks = _js2n__-prdslib.isType '"Bool",
                          ignore_code_languages =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          spaces_per_tab =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              no-inline-html =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          allowed_elements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              no-missing-space-atx = _js2n__-prdslib.isType '"Bool",
              no-missing-space-closed-atx = _js2n__-prdslib.isType '"Bool",
              no-multiple-blanks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          maximum =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              no-multiple-space-atx = _js2n__-prdslib.isType '"Bool",
              no-multiple-space-blockquote = _js2n__-prdslib.isType '"Bool",
              no-multiple-space-closed-atx = _js2n__-prdslib.isType '"Bool",
              no-reversed-links = _js2n__-prdslib.isType '"Bool",
              no-space-in-code = _js2n__-prdslib.isType '"Bool",
              no-space-in-emphasis = _js2n__-prdslib.isType '"Bool",
              no-space-in-links = _js2n__-prdslib.isType '"Bool",
              no-trailing-punctuation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { punctuation = _js2n__-prdslib.isType '"String", } {}
                        false _js2n__-prdslib.never
                    ],
              no-trailing-spaces =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          br_spaces =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          list_item_empty_lines =
                            _js2n__-prdslib.isType '"Bool",
                          strict = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              ol = _js2n__-prdslib.isType '"Bool",
              ol-prefix =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "one",
                                      "ordered",
                                      "one_or_ordered",
                                      "zero"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              proper-names =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          code_blocks = _js2n__-prdslib.isType '"Bool",
                          html_elements = _js2n__-prdslib.isType '"Bool",
                          names =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              reference-links-images =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        { shortcut_syntax = _js2n__-prdslib.isType '"Bool", } {}
                        false _js2n__-prdslib.never
                    ],
              required-headings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          headings =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.pattern
                                          "^(\\*|\\+|#{1,6} .*)$"
                                      ])
                                ],
                          match_case = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              single-h1 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          front_matter_title = _js2n__-prdslib.isType '"String",
                          level =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum 6,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              single-title =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          front_matter_title = _js2n__-prdslib.isType '"String",
                          level =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum 6,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              single-trailing-newline = _js2n__-prdslib.isType '"Bool",
              spaces = _js2n__-prdslib.isType '"Bool",
              spelling = _js2n__-prdslib.isType '"Bool",
              strong-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "consistent", "asterisk", "underscore" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              table = _js2n__-prdslib.isType '"Bool",
              table-column-count = _js2n__-prdslib.isType '"Bool",
              table-pipe-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "consistent",
                                      "leading_only",
                                      "trailing_only",
                                      "leading_and_trailing",
                                      "no_leading_or_trailing"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              ul = _js2n__-prdslib.isType '"Bool",
              ul-indent =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          indent =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          start_indent =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 1
                                ],
                          start_indented = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              ul-style =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record
                        ],
                      _js2n__-prdslib.records.record
                        {
                          style =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "consistent",
                                      "asterisk",
                                      "plus",
                                      "dash",
                                      "sublist"
                                    ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              url = _js2n__-prdslib.isType '"Bool",
              whitespace = _js2n__-prdslib.isType '"Bool",
            } {} true
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.isType '"Bool",
                _js2n__-prdslib.isType 'Record
              ])
        ])