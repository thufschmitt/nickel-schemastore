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
      "_js2n__-:definitions/components:bin!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "^[a-zA-Z0-9_\\-\\.]+$" = _js2n__-prdslib.isType '"String",
                  } false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/components:deprecation!contract" =
        {
            message
              | String
              | doc "Deprecation message shown to users. Should include alternative installation methods if available.",
            since
              | String
              | doc "The version number when the deprecation was made.",
          },
      "_js2n__-:definitions/components:opt!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "^[a-zA-Z0-9_\\-\\./]+$" = _js2n__-prdslib.isType '"String",
                  } false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/components:schemas!contract" =
        {
            lsp
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^(vscode:)?https://"
                  ])
              | doc "A URL to where the LSP JSON schema can be downloaded from. If the provided URL is a VSCode package.json you MUST prefix the url with vscode:"
              | optional,
          },
      "_js2n__-:definitions/components:share!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "^[a-zA-Z0-9_\\-\\./]+$" = _js2n__-prdslib.isType '"String",
                  } false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/components:source!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        version_overrides =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "constraint" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  constraint =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.strings.pattern
                                                            "^semver:(<=)?v?\\d+\\.\\d+\\.\\d+"
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-refsenv."_js2n__-:definitions/components:source/definitions/Source!predicate"
                                        ]
                                    ])
                              ],
                      } {} true _js2n__-prdslib.always
                  ],
                _js2n__-refsenv."_js2n__-:definitions/components:source/definitions/Source!predicate"
              ]),
      "_js2n__-:definitions/components:source/definitions/Source!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/components:sources:cargo!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:composer!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:gem!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:generic!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:github!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:golang!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:luarocks!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:npm!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:nuget!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:opam!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:openvsx!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:pypi!predicate"
            ],
      "_js2n__-:definitions/components:sources:build!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "run" ],
              _js2n__-prdslib.records.record
                {
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[A-Z0-9_]+$" = _js2n__-prdslib.isType '"String",
                            } false _js2n__-prdslib.never
                        ],
                  run = _js2n__-prdslib.isType '"String",
                  staged = _js2n__-prdslib.isType '"Bool",
                  target =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:cargo!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:cargo/.+@.+"
                        ],
                  supported_platforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:composer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^pkg:composer/.+/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:gem!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  extra_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:gem/.+@.+"
                        ],
                  supported_platforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:generic!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/components:sources:generic:download!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:generic:build!predicate"
            ],
      "_js2n__-:definitions/components:sources:generic:build!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "build", "id" ],
              _js2n__-prdslib.records.record
                {
                  build =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/components:sources:build!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/components:sources:build!predicate"
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:generic/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:generic:download!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "download", "id" ],
              _js2n__-prdslib.records.record
                {
                  download =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/components:sources:generic:download/definitions/Download!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/components:sources:generic:download/definitions/Download!predicate"
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:generic/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:generic:download/definitions/Download!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "files" ],
              _js2n__-prdslib.records.record
                {
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[a-zA-Z0-9_\\-\\.]+$" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^https?://"
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                  target =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:github!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/components:sources:github:release!predicate",
              _js2n__-refsenv."_js2n__-:definitions/components:sources:github:build!predicate"
            ],
      "_js2n__-:definitions/components:sources:github:build!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "build", "id" ],
              _js2n__-prdslib.records.record
                {
                  build =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/components:sources:build!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/components:sources:build!predicate"
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:github/.+/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:github:release!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "asset", "id" ],
              _js2n__-prdslib.records.record
                {
                  asset =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "file", "target" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        file =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        target =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                                                  ],
                                                _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                                              ],
                                      } {} true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "file" ],
                              _js2n__-prdslib.records.record
                                {
                                  file =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:github/.+/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:golang!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  extra_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:golang/.+/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:luarocks!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:luarocks/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:npm!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  extra_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:npm/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:nuget!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:nuget/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:opam!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:opam/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:openvsx!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "download", "id" ],
              _js2n__-prdslib.records.record
                {
                  download =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "file", "target" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        file =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        target =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                                                  ],
                                                _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                                              ],
                                        target_platform =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "in32-x64",
                                                    "win32-ia32",
                                                    "win32-arm64",
                                                    "linux-x64",
                                                    "linux-arm64",
                                                    "linux-armhf",
                                                    "alpine-x64",
                                                    "alpine-arm64",
                                                    "darwin-x64",
                                                    "darwin-arm64",
                                                    "web",
                                                    "universal"
                                                  ]
                                              ],
                                      } {} true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "file" ],
                              _js2n__-prdslib.records.record
                                {
                                  file =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^pkg:openvsx/.+/.+@.+"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/components:sources:pypi!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  extra_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^pkg:pypi/.+@.+"
                        ],
                  supported_platforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/enums:category!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'Runtime, 'Linter, 'LSP, 'Formatter, 'DAP, 'Compiler |]
            ],
      "_js2n__-:definitions/enums:platform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "unix",
                  "darwin",
                  "darwin_arm64",
                  "darwin_x64",
                  "linux",
                  "linux_arm",
                  "linux_arm64",
                  "linux_arm64_gnu",
                  "linux_arm64_musl",
                  "linux_arm64_openbsd",
                  "linux_arm_gnu",
                  "linux_armv6_gnu",
                  "linux_armv6l",
                  "linux_armv7_gnu",
                  "linux_armv7l",
                  "linux_x64",
                  "linux_x64_gnu",
                  "linux_x64_musl",
                  "linux_x64_openbsd",
                  "linux_x86",
                  "linux_x86_gnu",
                  "linux_x86_musl",
                  "linux_x86_openbsd",
                  "win",
                  "win_arm",
                  "win_arm64",
                  "win_armv6l",
                  "win_armv7l",
                  "win_x64",
                  "win_x86"
                ]
            ],
      "_js2n__-:definitions/enums:spdx-license!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "proprietary",
                  "0BSD",
                  "AAL",
                  "Abstyles",
                  "Adobe-2006",
                  "Adobe-Glyph",
                  "ADSL",
                  "AFL-1.1",
                  "AFL-1.2",
                  "AFL-2.0",
                  "AFL-2.1",
                  "AFL-3.0",
                  "Afmparse",
                  "AGPL-1.0",
                  "AGPL-1.0-only",
                  "AGPL-1.0-or-later",
                  "AGPL-3.0",
                  "AGPL-3.0-only",
                  "AGPL-3.0-or-later",
                  "Aladdin",
                  "AMDPLPA",
                  "AML",
                  "AMPAS",
                  "ANTLR-PD",
                  "ANTLR-PD-fallback",
                  "Apache-1.0",
                  "Apache-1.1",
                  "Apache-2.0",
                  "APAFML",
                  "APL-1.0",
                  "App-s2p",
                  "APSL-1.0",
                  "APSL-1.1",
                  "APSL-1.2",
                  "APSL-2.0",
                  "Arphic-1999",
                  "Artistic-1.0",
                  "Artistic-1.0-cl8",
                  "Artistic-1.0-Perl",
                  "Artistic-2.0",
                  "Baekmuk",
                  "Bahyph",
                  "Barr",
                  "Beerware",
                  "Bitstream-Vera",
                  "BitTorrent-1.0",
                  "BitTorrent-1.1",
                  "blessing",
                  "BlueOak-1.0.0",
                  "Borceux",
                  "BSD-1-Clause",
                  "BSD-2-Clause",
                  "BSD-2-Clause-FreeBSD",
                  "BSD-2-Clause-NetBSD",
                  "BSD-2-Clause-Patent",
                  "BSD-2-Clause-Views",
                  "BSD-3-Clause",
                  "BSD-3-Clause-Attribution",
                  "BSD-3-Clause-Clear",
                  "BSD-3-Clause-LBNL",
                  "BSD-3-Clause-Modification",
                  "BSD-3-Clause-No-Military-License",
                  "BSD-3-Clause-No-Nuclear-License",
                  "BSD-3-Clause-No-Nuclear-License-2014",
                  "BSD-3-Clause-No-Nuclear-Warranty",
                  "BSD-3-Clause-Open-MPI",
                  "BSD-4-Clause",
                  "BSD-4-Clause-Shortened",
                  "BSD-4-Clause-UC",
                  "BSD-Protection",
                  "BSD-Source-Code",
                  "BSL-1.0",
                  "BUSL-1.1",
                  "bzip2-1.0.5",
                  "bzip2-1.0.6",
                  "C-UDA-1.0",
                  "CAL-1.0",
                  "CAL-1.0-Combined-Work-Exception",
                  "Caldera",
                  "CATOSL-1.1",
                  "CC-BY-1.0",
                  "CC-BY-2.0",
                  "CC-BY-2.5",
                  "CC-BY-2.5-AU",
                  "CC-BY-3.0",
                  "CC-BY-3.0-AT",
                  "CC-BY-3.0-DE",
                  "CC-BY-3.0-IGO",
                  "CC-BY-3.0-NL",
                  "CC-BY-3.0-US",
                  "CC-BY-4.0",
                  "CC-BY-NC-1.0",
                  "CC-BY-NC-2.0",
                  "CC-BY-NC-2.5",
                  "CC-BY-NC-3.0",
                  "CC-BY-NC-3.0-DE",
                  "CC-BY-NC-4.0",
                  "CC-BY-NC-ND-1.0",
                  "CC-BY-NC-ND-2.0",
                  "CC-BY-NC-ND-2.5",
                  "CC-BY-NC-ND-3.0",
                  "CC-BY-NC-ND-3.0-DE",
                  "CC-BY-NC-ND-3.0-IGO",
                  "CC-BY-NC-ND-4.0",
                  "CC-BY-NC-SA-1.0",
                  "CC-BY-NC-SA-2.0",
                  "CC-BY-NC-SA-2.0-FR",
                  "CC-BY-NC-SA-2.0-UK",
                  "CC-BY-NC-SA-2.5",
                  "CC-BY-NC-SA-3.0",
                  "CC-BY-NC-SA-3.0-DE",
                  "CC-BY-NC-SA-3.0-IGO",
                  "CC-BY-NC-SA-4.0",
                  "CC-BY-ND-1.0",
                  "CC-BY-ND-2.0",
                  "CC-BY-ND-2.5",
                  "CC-BY-ND-3.0",
                  "CC-BY-ND-3.0-DE",
                  "CC-BY-ND-4.0",
                  "CC-BY-SA-1.0",
                  "CC-BY-SA-2.0",
                  "CC-BY-SA-2.0-UK",
                  "CC-BY-SA-2.1-JP",
                  "CC-BY-SA-2.5",
                  "CC-BY-SA-3.0",
                  "CC-BY-SA-3.0-AT",
                  "CC-BY-SA-3.0-DE",
                  "CC-BY-SA-4.0",
                  "CC-PDDC",
                  "CC0-1.0",
                  "CDDL-1.0",
                  "CDDL-1.1",
                  "CDL-1.0",
                  "CDLA-Permissive-1.0",
                  "CDLA-Permissive-2.0",
                  "CDLA-Sharing-1.0",
                  "CECILL-1.0",
                  "CECILL-1.1",
                  "CECILL-2.0",
                  "CECILL-2.1",
                  "CECILL-B",
                  "CECILL-C",
                  "CERN-OHL-1.1",
                  "CERN-OHL-1.2",
                  "CERN-OHL-P-2.0",
                  "CERN-OHL-S-2.0",
                  "CERN-OHL-W-2.0",
                  "checkmk",
                  "ClArtistic",
                  "CNRI-Jython",
                  "CNRI-Python",
                  "CNRI-Python-GPL-Compatible",
                  "COIL-1.0",
                  "Community-Spec-1.0",
                  "Condor-1.1",
                  "copyleft-next-0.3.0",
                  "copyleft-next-0.3.1",
                  "CPAL-1.0",
                  "CPL-1.0",
                  "CPOL-1.02",
                  "Crossword",
                  "CrystalStacker",
                  "CUA-OPL-1.0",
                  "Cube",
                  "curl",
                  "D-FSL-1.0",
                  "diffmark",
                  "DL-DE-BY-2.0",
                  "DOC",
                  "Dotseqn",
                  "DRL-1.0",
                  "DSDP",
                  "dvipdfm",
                  "ECL-1.0",
                  "ECL-2.0",
                  "eCos-2.0",
                  "EFL-1.0",
                  "EFL-2.0",
                  "eGenix",
                  "Elastic-2.0",
                  "Entessa",
                  "EPICS",
                  "EPL-1.0",
                  "EPL-2.0",
                  "ErlPL-1.1",
                  "etalab-2.0",
                  "EUDatagrid",
                  "EUPL-1.0",
                  "EUPL-1.1",
                  "EUPL-1.2",
                  "Eurosym",
                  "Fair",
                  "FDK-AAC",
                  "Frameworx-1.0",
                  "FreeBSD-DOC",
                  "FreeImage",
                  "FSFAP",
                  "FSFUL",
                  "FSFULLR",
                  "FSFULLRWD",
                  "FTL",
                  "GD",
                  "GFDL-1.1",
                  "GFDL-1.1-invariants-only",
                  "GFDL-1.1-invariants-or-later",
                  "GFDL-1.1-no-invariants-only",
                  "GFDL-1.1-no-invariants-or-later",
                  "GFDL-1.1-only",
                  "GFDL-1.1-or-later",
                  "GFDL-1.2",
                  "GFDL-1.2-invariants-only",
                  "GFDL-1.2-invariants-or-later",
                  "GFDL-1.2-no-invariants-only",
                  "GFDL-1.2-no-invariants-or-later",
                  "GFDL-1.2-only",
                  "GFDL-1.2-or-later",
                  "GFDL-1.3",
                  "GFDL-1.3-invariants-only",
                  "GFDL-1.3-invariants-or-later",
                  "GFDL-1.3-no-invariants-only",
                  "GFDL-1.3-no-invariants-or-later",
                  "GFDL-1.3-only",
                  "GFDL-1.3-or-later",
                  "Giftware",
                  "GL2PS",
                  "Glide",
                  "Glulxe",
                  "GLWTPL",
                  "gnuplot",
                  "GPL-1.0",
                  "GPL-1.0-only",
                  "GPL-1.0-or-later",
                  "GPL-1.0+",
                  "GPL-2.0",
                  "GPL-2.0-only",
                  "GPL-2.0-or-later",
                  "GPL-2.0-with-autoconf-exception",
                  "GPL-2.0-with-bison-exception",
                  "GPL-2.0-with-classpath-exception",
                  "GPL-2.0-with-font-exception",
                  "GPL-2.0-with-GCC-exception",
                  "GPL-2.0+",
                  "GPL-3.0",
                  "GPL-3.0-only",
                  "GPL-3.0-or-later",
                  "GPL-3.0-with-autoconf-exception",
                  "GPL-3.0-with-GCC-exception",
                  "GPL-3.0+",
                  "gSOAP-1.3b",
                  "HaskellReport",
                  "Hippocratic-2.1",
                  "HPND",
                  "HPND-sell-variant",
                  "HTMLTIDY",
                  "IBM-pibs",
                  "ICU",
                  "IJG",
                  "ImageMagick",
                  "iMatix",
                  "Imlib2",
                  "Info-ZIP",
                  "Intel",
                  "Intel-ACPI",
                  "Interbase-1.0",
                  "IPA",
                  "IPL-1.0",
                  "ISC",
                  "Jam",
                  "JasPer-2.0",
                  "JPNIC",
                  "JSON",
                  "Knuth-CTAN",
                  "LAL-1.2",
                  "LAL-1.3",
                  "Latex2e",
                  "Leptonica",
                  "LGPL-2.0",
                  "LGPL-2.0-only",
                  "LGPL-2.0-or-later",
                  "LGPL-2.0+",
                  "LGPL-2.1",
                  "LGPL-2.1-only",
                  "LGPL-2.1-or-later",
                  "LGPL-2.1+",
                  "LGPL-3.0",
                  "LGPL-3.0-only",
                  "LGPL-3.0-or-later",
                  "LGPL-3.0+",
                  "LGPLLR",
                  "Libpng",
                  "libpng-2.0",
                  "libselinux-1.0",
                  "libtiff",
                  "libutil-David-Nugent",
                  "LiLiQ-P-1.1",
                  "LiLiQ-R-1.1",
                  "LiLiQ-Rplus-1.1",
                  "Linux-man-pages-copyleft",
                  "Linux-OpenIB",
                  "LOOP",
                  "LPL-1.0",
                  "LPL-1.02",
                  "LPPL-1.0",
                  "LPPL-1.1",
                  "LPPL-1.2",
                  "LPPL-1.3a",
                  "LPPL-1.3c",
                  "LZMA-SDK-9.11-to-9.20",
                  "LZMA-SDK-9.22",
                  "MakeIndex",
                  "Minpack",
                  "MirOS",
                  "MIT",
                  "MIT-0",
                  "MIT-advertising",
                  "MIT-CMU",
                  "MIT-enna",
                  "MIT-feh",
                  "MIT-Modern-Variant",
                  "MIT-open-group",
                  "MITNFA",
                  "Motosoto",
                  "mpi-permissive",
                  "mpich2",
                  "MPL-1.0",
                  "MPL-1.1",
                  "MPL-2.0",
                  "MPL-2.0-no-copyleft-exception",
                  "mplus",
                  "MS-LPL",
                  "MS-PL",
                  "MS-RL",
                  "MTLL",
                  "MulanPSL-1.0",
                  "MulanPSL-2.0",
                  "Multics",
                  "Mup",
                  "NAIST-2003",
                  "NASA-1.3",
                  "Naumen",
                  "NBPL-1.0",
                  "NCGL-UK-2.0",
                  "NCSA",
                  "Net-SNMP",
                  "NetCDF",
                  "Newsletr",
                  "NGPL",
                  "NICTA-1.0",
                  "NIST-PD",
                  "NIST-PD-fallback",
                  "NLOD-1.0",
                  "NLOD-2.0",
                  "NLPL",
                  "Nokia",
                  "NOSL",
                  "Noweb",
                  "NPL-1.0",
                  "NPL-1.1",
                  "NPOSL-3.0",
                  "NRL",
                  "NTP",
                  "NTP-0",
                  "Nunit",
                  "O-UDA-1.0",
                  "OCCT-PL",
                  "OCLC-2.0",
                  "ODbL-1.0",
                  "ODC-By-1.0",
                  "OFL-1.0",
                  "OFL-1.0-no-RFN",
                  "OFL-1.0-RFN",
                  "OFL-1.1",
                  "OFL-1.1-no-RFN",
                  "OFL-1.1-RFN",
                  "OGC-1.0",
                  "OGDL-Taiwan-1.0",
                  "OGL-Canada-2.0",
                  "OGL-UK-1.0",
                  "OGL-UK-2.0",
                  "OGL-UK-3.0",
                  "OGTSL",
                  "OLDAP-1.1",
                  "OLDAP-1.2",
                  "OLDAP-1.3",
                  "OLDAP-1.4",
                  "OLDAP-2.0",
                  "OLDAP-2.0.1",
                  "OLDAP-2.1",
                  "OLDAP-2.2",
                  "OLDAP-2.2.1",
                  "OLDAP-2.2.2",
                  "OLDAP-2.3",
                  "OLDAP-2.4",
                  "OLDAP-2.5",
                  "OLDAP-2.6",
                  "OLDAP-2.7",
                  "OLDAP-2.8",
                  "OML",
                  "OpenSSL",
                  "OPL-1.0",
                  "OPUBL-1.0",
                  "OSET-PL-2.1",
                  "OSL-1.0",
                  "OSL-1.1",
                  "OSL-2.0",
                  "OSL-2.1",
                  "OSL-3.0",
                  "Parity-6.0.0",
                  "Parity-7.0.0",
                  "PDDL-1.0",
                  "PHP-3.0",
                  "PHP-3.01",
                  "Plexus",
                  "PolyForm-Noncommercial-1.0.0",
                  "PolyForm-Small-Business-1.0.0",
                  "PostgreSQL",
                  "PSF-2.0",
                  "psfrag",
                  "psutils",
                  "Python-2.0",
                  "Python-2.0.1",
                  "Qhull",
                  "QPL-1.0",
                  "Rdisc",
                  "RHeCos-1.1",
                  "RPL-1.1",
                  "RPL-1.5",
                  "RPSL-1.0",
                  "RSA-MD",
                  "RSCPL",
                  "Ruby",
                  "SAX-PD",
                  "Saxpath",
                  "SCEA",
                  "SchemeReport",
                  "Sendmail",
                  "Sendmail-8.23",
                  "SGI-B-1.0",
                  "SGI-B-1.1",
                  "SGI-B-2.0",
                  "SHL-0.5",
                  "SHL-0.51",
                  "SimPL-2.0",
                  "SISSL",
                  "SISSL-1.2",
                  "Sleepycat",
                  "SMLNJ",
                  "SMPPL",
                  "SNIA",
                  "Spencer-86",
                  "Spencer-94",
                  "Spencer-99",
                  "SPL-1.0",
                  "SSH-OpenSSH",
                  "SSH-short",
                  "SSPL-1.0",
                  "StandardML-NJ",
                  "SugarCRM-1.1.3",
                  "SWL",
                  "Symlinks",
                  "TAPR-OHL-1.0",
                  "TCL",
                  "TCP-wrappers",
                  "TMate",
                  "TORQUE-1.1",
                  "TOSL",
                  "TU-Berlin-1.0",
                  "TU-Berlin-2.0",
                  "UCL-1.0",
                  "Unicode-DFS-2015",
                  "Unicode-DFS-2016",
                  "Unicode-TOU",
                  "Unlicense",
                  "UPL-1.0",
                  "Vim",
                  "VOSTROM",
                  "VSL-1.0",
                  "W3C",
                  "W3C-19980720",
                  "W3C-20150513",
                  "Watcom-1.0",
                  "Wsuipa",
                  "WTFPL",
                  "wxWindows",
                  "X11",
                  "X11-distribute-modifications-variant",
                  "Xerox",
                  "XFree86-1.1",
                  "xinetd",
                  "Xnet",
                  "xpp",
                  "XSkat",
                  "YPL-1.0",
                  "YPL-1.1",
                  "Zed",
                  "Zend-2.0",
                  "Zimbra-1.3",
                  "Zimbra-1.4",
                  "Zlib",
                  "zlib-acknowledgement",
                  "ZPL-1.1",
                  "ZPL-2.0",
                  "ZPL-2.1"
                ]
            ],
    }
    in
  {
      bin
        | _js2n__-refsenv."_js2n__-:definitions/components:bin!contract"
        | optional,
      categories
        | Array _js2n__-refsenv."_js2n__-:definitions/enums:category!contract",
      ci_skip
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/enums:platform!predicate"
                ]
            ])
        | optional,
      deprecation
        | _js2n__-refsenv."_js2n__-:definitions/components:deprecation!contract"
        | optional,
      description
        | String
        | doc "The description of the package. Usually sourced upstream.",
      homepage
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^https?://"
            ])
        | doc "A URL to the package's homepage.",
      languages | Array (String),
      licenses
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/enums:spdx-license!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ]),
      name
        | String
        | doc "The package name. MUST be unique within the registry it belongs to.",
      opt
        | _js2n__-refsenv."_js2n__-:definitions/components:opt!contract"
        | optional,
      schemas
        | _js2n__-refsenv."_js2n__-:definitions/components:schemas!contract"
        | optional,
      share
        | _js2n__-refsenv."_js2n__-:definitions/components:share!contract"
        | optional,
      source
        | _js2n__-refsenv."_js2n__-:definitions/components:source!contract",
    }