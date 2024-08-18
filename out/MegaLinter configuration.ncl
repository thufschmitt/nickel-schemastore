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
      "_js2n__-:definitions/command_info!contract"
        | doc "Command information"
        = {
            command | String | optional,
            continue_if_failed
              | Bool
              | doc "If command fails, continue MegaLinter process or not"
              | optional,
            cwd | std.enum.TagOrString | [| 'workspace, 'root |] | optional,
            output_variables
              | Array (String)
              | doc "ENV variables to get from output after running the commands, and store in MegaLinter ENV context"
              | optional,
            secured_env
              | Bool
              | doc "Apply filter of secured env variables before calling the command (default true). Be careful if you disable it."
              | optional,
            venv | String | optional,
            ..
          },
      "_js2n__-:definitions/enum_descriptor_keys!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'YAML,
                'XML,
                'VBDOTNET,
                'TYPESCRIPT,
                'TSX,
                'TERRAFORM,
                'TEKTON,
                'SWIFT,
                'SQL,
                'SPELL,
                'SNAKEMAKE,
                'SCALA,
                'SALESFORCE,
                'RUST,
                'RUBY,
                'RST,
                'REPOSITORY,
                'RAKU,
                'R,
                'PYTHON,
                'PUPPET,
                'PROTOBUF,
                'POWERSHELL,
                'PHP,
                'PERL,
                'MARKDOWN,
                'MAKEFILE,
                'LUA,
                'LATEX,
                'KUBERNETES,
                'KOTLIN,
                'JSX,
                'JSON,
                'JAVASCRIPT,
                'JAVA,
                'HTML,
                'GROOVY,
                'GRAPHQL,
                'GO,
                'GIT,
                'GHERKIN,
                'ENV,
                'EDITORCONFIG,
                'DOCKERFILE,
                'DART,
                'CSS,
                'CSHARP,
                'CREDENTIALS,
                'CPP,
                'COPYPASTE,
                'COFFEE,
                'CLOUDFORMATION,
                'CLOJURE,
                'C,
                'BICEP,
                'BASH,
                'ARM,
                'API,
                'ANSIBLE,
                'ACTION
              |]
            ],
      "_js2n__-:definitions/enum_linter_keys!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'YAML_YAMLLINT,
                'YAML_V8R,
                'YAML_PRETTIER,
                'XML_XMLLINT,
                'VBDOTNET_DOTNET_FORMAT,
                'TYPESCRIPT_STANDARD,
                'TYPESCRIPT_PRETTIER,
                'TYPESCRIPT_ES,
                'TSX_ESLINT,
                'TERRAFORM_TFLINT,
                'TERRAFORM_TERRASCAN,
                'TERRAFORM_TERRAGRUNT,
                'TERRAFORM_TERRAFORM_FMT,
                'TERRAFORM_KICS,
                'TERRAFORM_CHECKOV,
                'TEKTON_TEKTON_LINT,
                'SWIFT_SWIFTLINT,
                'SQL_TSQLLINT,
                'SQL_SQLFLUFF,
                'SPELL_VALE,
                'SPELL_PROSELINT,
                'SPELL_MISSPELL,
                'SPELL_LYCHEE,
                'SPELL_CSPELL,
                'SNAKEMAKE_SNAKEFMT,
                'SNAKEMAKE_LINT,
                'SCALA_SCALAFIX,
                'SALESFORCE_SFDX_SCANNER_LWC,
                'SALESFORCE_SFDX_SCANNER_AURA,
                'SALESFORCE_SFDX_SCANNER_APEX,
                'SALESFORCE_LIGHTNING_FLOW_SCANNER,
                'R_LINTR,
                'RUST_CLIPPY,
                'RUBY_RUBOCOP,
                'RST_RST_LINT,
                'RST_RSTFMT,
                'RST_RSTCHECK,
                'REPOSITORY_TRUFFLEHOG,
                'REPOSITORY_TRIVY_SBOM,
                'REPOSITORY_TRIVY,
                'REPOSITORY_SYFT,
                'REPOSITORY_SEMGREP,
                'REPOSITORY_SECRETLINT,
                'REPOSITORY_LS_LINT,
                'REPOSITORY_KICS,
                'REPOSITORY_GRYPE,
                'REPOSITORY_GOODCHECK,
                'REPOSITORY_GIT_DIFF,
                'REPOSITORY_GITLEAKS,
                'REPOSITORY_DUSTILOCK,
                'REPOSITORY_DEVSKIM,
                'REPOSITORY_CHECKOV,
                'RAKU_RAKU,
                'PYTHON_RUFF,
                'PYTHON_PYRIGHT,
                'PYTHON_PYLINT,
                'PYTHON_MYPY,
                'PYTHON_ISORT,
                'PYTHON_FLAKE8,
                'PYTHON_BLACK,
                'PYTHON_BANDIT,
                'PUPPET_PUPPET_LINT,
                'PROTOBUF_PROTOLINT,
                'POWERSHELL_POWERSHELL_FORMATTER,
                'POWERSHELL_POWERSHELL,
                'PHP_PSALM,
                'PHP_PHPSTAN,
                'PHP_PHPLINT,
                'PHP_PHPCSFIXER,
                'PHP_PHPCS,
                'PHP_BUILTIN,
                'PERL_PERLCRITIC,
                'MARKDOWN_REMARK_LINT,
                'MARKDOWN_MARKDOWN_TABLE_FORMATTER,
                'MARKDOWN_MARKDOWN_LINK_CHECK,
                'MARKDOWN_MARKDOWNLINT,
                'MAKEFILE_CHECKMAKE,
                'LUA_LUACHECK,
                'LATEX_CHKTEX,
                'KUBERNETES_KUBEVAL,
                'KUBERNETES_KUBESCAPE,
                'KUBERNETES_KUBECONFORM,
                'KUBERNETES_HELM,
                'KOTLIN_KTLINT,
                'KOTLIN_DETEKT,
                'JSX_ESLINT,
                'JSON_V8R,
                'JSON_PRETTIER,
                'JSON_NPM_PACKAGE_JSON_LINT,
                'JSON_JSONLINT,
                'JSON_ESLINT_PLUGIN_JSONC,
                'JAVA_PMD,
                'JAVA_CHECKSTYLE,
                'JAVASCRIPT_STANDARD,
                'JAVASCRIPT_PRETTIER,
                'JAVASCRIPT_ES,
                'HTML_HTMLHINT,
                'HTML_DJLINT,
                'GROOVY_NPM_GROOVY_LINT,
                'GRAPHQL_GRAPHQL_SCHEMA_LINTER,
                'GO_REVIVE,
                'GO_GOLANGCI_LINT,
                'GIT_GIT_DIFF,
                'GHERKIN_GHERKIN_LINT,
                'ENV_DOTENV_LINTER,
                'EDITORCONFIG_EDITORCONFIG_CHECKER,
                'DOCKERFILE_HADOLINT,
                'DOCKERFILE_DOCKERFILELINT,
                'DART_DARTANALYZER,
                'C_CPPLINT,
                'C_CLANG_FORMAT,
                'CSS_STYLELINT,
                'CSHARP_ROSLYNATOR,
                'CSHARP_DOTNET_FORMAT,
                'CSHARP_CSHARPIER,
                'CREDENTIALS_SECRETLINT,
                'CPP_CPPLINT,
                'CPP_CLANG_FORMAT,
                'COPYPASTE_JSCPD,
                'COFFEE_COFFEELINT,
                'CLOUDFORMATION_CFN_LINT,
                'CLOJURE_CLJ_KONDO,
                'CLOJURE_CLJSTYLE,
                'BICEP_BICEP_LINTER,
                'BASH_SHFMT,
                'BASH_SHELLCHECK,
                'BASH_EXEC,
                'ARM_ARM_TTK,
                'API_SPECTRAL,
                'ANSIBLE_ANSIBLE_LINT,
                'ACTION_ACTIONLINT
              |]
            ],
    }
    in
  {
      ACTION_ACTIONLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ACTION_ACTIONLINT: User custom arguments to add in linter CLI call"
        | optional,
      ACTION_ACTIONLINT_CLI_EXECUTABLE | Array (String) | optional,
      ACTION_ACTIONLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      ACTION_ACTIONLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ACTION_ACTIONLINT: User custom arguments to remove before calling linter"
        | optional,
      ACTION_ACTIONLINT_CONFIG_FILE
        | String
        | doc "ACTION_ACTIONLINT: User custom config file name if different from default"
        | optional,
      ACTION_ACTIONLINT_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      ACTION_ACTIONLINT_DISABLE_ERRORS | Bool | optional,
      ACTION_ACTIONLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      ACTION_ACTIONLINT_FILE_EXTENSIONS | Array (String) | optional,
      ACTION_ACTIONLINT_FILE_NAMES_REGEX | Array (String) | optional,
      ACTION_ACTIONLINT_FILTER_REGEX_EXCLUDE | String | optional,
      ACTION_ACTIONLINT_FILTER_REGEX_INCLUDE | String | optional,
      ACTION_ACTIONLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ACTION_ACTIONLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ACTION_ACTIONLINT_RULES_PATH
        | String
        | doc "ACTION_ACTIONLINT: Path where to find linter configuration file"
        | optional,
      ACTION_ACTIONLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling ACTION_ACTIONLINT and its pre/post commands"
        | optional,
      ACTION_FILTER_REGEX_EXCLUDE | String | optional,
      ACTION_FILTER_REGEX_INCLUDE | String | optional,
      ACTION_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ACTION_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ADDITIONAL_EXCLUDED_DIRECTORIES
        | Array (String)
        | doc "List of additional excluded directory basenames to add to MegaLinter default excluded directories. They are excluded at any nested level."
        | optional,
      ANSIBLE_ANSIBLE_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ANSIBLE_ANSIBLE_LINT: User custom arguments to add in linter CLI call"
        | optional,
      ANSIBLE_ANSIBLE_LINT_CLI_EXECUTABLE | Array (String) | optional,
      ANSIBLE_ANSIBLE_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      ANSIBLE_ANSIBLE_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ANSIBLE_ANSIBLE_LINT: User custom arguments to remove before calling linter"
        | optional,
      ANSIBLE_ANSIBLE_LINT_CONFIG_FILE
        | String
        | doc "ANSIBLE_ANSIBLE_LINT: User custom config file name if different from default"
        | optional,
      ANSIBLE_ANSIBLE_LINT_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      ANSIBLE_ANSIBLE_LINT_DISABLE_ERRORS | Bool | optional,
      ANSIBLE_ANSIBLE_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      ANSIBLE_ANSIBLE_LINT_FILE_EXTENSIONS | Array (String) | optional,
      ANSIBLE_ANSIBLE_LINT_FILE_NAME
        | String
        | doc "ANSIBLE_ANSIBLE_LINT: User custom config file name if different from default"
        | optional,
      ANSIBLE_ANSIBLE_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      ANSIBLE_ANSIBLE_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ANSIBLE_ANSIBLE_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ANSIBLE_ANSIBLE_LINT_RULES_PATH
        | String
        | doc "ANSIBLE_ANSIBLE_LINT: Path where to find linter configuration file"
        | optional,
      ANSIBLE_ANSIBLE_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling ANSIBLE_ANSIBLE_LINT and its pre/post commands"
        | optional,
      ANSIBLE_DIRECTORY | String | optional,
      ANSIBLE_FILTER_REGEX_EXCLUDE | String | optional,
      ANSIBLE_FILTER_REGEX_INCLUDE | String | optional,
      ANSIBLE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ANSIBLE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      API_FILTER_REGEX_EXCLUDE | String | optional,
      API_FILTER_REGEX_INCLUDE | String | optional,
      API_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      API_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      API_SPECTRAL_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "API_SPECTRAL: User custom arguments to add in linter CLI call"
        | optional,
      API_SPECTRAL_CLI_EXECUTABLE | Array (String) | optional,
      API_SPECTRAL_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      API_SPECTRAL_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "API_SPECTRAL: User custom arguments to remove before calling linter"
        | optional,
      API_SPECTRAL_CONFIG_FILE
        | String
        | doc "API_SPECTRAL: User custom config file name if different from default"
        | optional,
      API_SPECTRAL_DISABLE_ERRORS | Bool | optional,
      API_SPECTRAL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      API_SPECTRAL_FILE_EXTENSIONS | Array (String) | optional,
      API_SPECTRAL_FILE_NAMES_REGEX | Array (String) | optional,
      API_SPECTRAL_FILTER_REGEX_EXCLUDE | String | optional,
      API_SPECTRAL_FILTER_REGEX_INCLUDE | String | optional,
      API_SPECTRAL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      API_SPECTRAL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      API_SPECTRAL_RULES_PATH
        | String
        | doc "API_SPECTRAL: Path where to find linter configuration file"
        | optional,
      API_SPECTRAL_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling API_SPECTRAL and its pre/post commands"
        | optional,
      APPLY_FIXES
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.isType '"String"
            ])
        | doc "'all' to apply formatting and auto-fixes of all linters, or a list of linter keys"
        | optional,
      ARM_ARM_TTK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ARM_ARM_TTK: User custom arguments to add in linter CLI call"
        | optional,
      ARM_ARM_TTK_CLI_EXECUTABLE | Array (String) | optional,
      ARM_ARM_TTK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      ARM_ARM_TTK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ARM_ARM_TTK: User custom arguments to remove before calling linter"
        | optional,
      ARM_ARM_TTK_CONFIG_FILE
        | String
        | doc "ARM_ARM_TTK: User custom config file name if different from default"
        | optional,
      ARM_ARM_TTK_DISABLE_ERRORS | Bool | optional,
      ARM_ARM_TTK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      ARM_ARM_TTK_FILE_EXTENSIONS | Array (String) | optional,
      ARM_ARM_TTK_FILE_NAME
        | String
        | doc "ARM_ARM_TTK: User custom config file name if different from default"
        | optional,
      ARM_ARM_TTK_FILE_NAMES_REGEX | Array (String) | optional,
      ARM_ARM_TTK_FILTER_REGEX_EXCLUDE | String | optional,
      ARM_ARM_TTK_FILTER_REGEX_INCLUDE | String | optional,
      ARM_ARM_TTK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ARM_ARM_TTK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ARM_ARM_TTK_RULES_PATH
        | String
        | doc "ARM_ARM_TTK: Path where to find linter configuration file"
        | optional,
      ARM_ARM_TTK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling ARM_ARM_TTK and its pre/post commands"
        | optional,
      ARM_FILTER_REGEX_EXCLUDE | String | optional,
      ARM_FILTER_REGEX_INCLUDE | String | optional,
      ARM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ARM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      AZURE_COMMENT_REPORTER
        | Bool
        | doc "Posts MegaLinter results summary in the comments of the related pull request (if existing)"
        | optional,
      AZURE_COMMENT_REPORTER_LINKS_TYPE
        | std.enum.TagOrString
        | [| 'build, 'artifacts |]
        | optional,
      BASH_EXEC_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BASH_EXEC: User custom arguments to add in linter CLI call"
        | optional,
      BASH_EXEC_CLI_EXECUTABLE | Array (String) | optional,
      BASH_EXEC_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      BASH_EXEC_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BASH_EXEC: User custom arguments to remove before calling linter"
        | optional,
      BASH_EXEC_DISABLE_ERRORS | Bool | optional,
      BASH_EXEC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      BASH_EXEC_FILE_EXTENSIONS | Array (String) | optional,
      BASH_EXEC_FILE_NAMES_REGEX | Array (String) | optional,
      BASH_EXEC_FILTER_REGEX_EXCLUDE | String | optional,
      BASH_EXEC_FILTER_REGEX_INCLUDE | String | optional,
      BASH_EXEC_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_EXEC_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_EXEC_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling BASH_EXEC and its pre/post commands"
        | optional,
      BASH_FILTER_REGEX_EXCLUDE | String | optional,
      BASH_FILTER_REGEX_INCLUDE | String | optional,
      BASH_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_SHELLCHECK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BASH_SHELLCHECK: User custom arguments to add in linter CLI call"
        | optional,
      BASH_SHELLCHECK_CLI_EXECUTABLE | Array (String) | optional,
      BASH_SHELLCHECK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      BASH_SHELLCHECK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BASH_SHELLCHECK: User custom arguments to remove before calling linter"
        | optional,
      BASH_SHELLCHECK_DISABLE_ERRORS | Bool | optional,
      BASH_SHELLCHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      BASH_SHELLCHECK_FILE_EXTENSIONS | Array (String) | optional,
      BASH_SHELLCHECK_FILE_NAMES_REGEX | Array (String) | optional,
      BASH_SHELLCHECK_FILTER_REGEX_EXCLUDE | String | optional,
      BASH_SHELLCHECK_FILTER_REGEX_INCLUDE | String | optional,
      BASH_SHELLCHECK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_SHELLCHECK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_SHELLCHECK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling BASH_SHELLCHECK and its pre/post commands"
        | optional,
      BASH_SHFMT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BASH_SHFMT: User custom arguments to add in linter CLI call"
        | optional,
      BASH_SHFMT_CLI_EXECUTABLE | Array (String) | optional,
      BASH_SHFMT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      BASH_SHFMT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BASH_SHFMT: User custom arguments to remove before calling linter"
        | optional,
      BASH_SHFMT_DISABLE_ERRORS | Bool | optional,
      BASH_SHFMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      BASH_SHFMT_FILE_EXTENSIONS | Array (String) | optional,
      BASH_SHFMT_FILE_NAMES_REGEX | Array (String) | optional,
      BASH_SHFMT_FILTER_REGEX_EXCLUDE | String | optional,
      BASH_SHFMT_FILTER_REGEX_INCLUDE | String | optional,
      BASH_SHFMT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_SHFMT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BASH_SHFMT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling BASH_SHFMT and its pre/post commands"
        | optional,
      BICEP_BICEP_LINTER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BICEP_BICEP_LINTER: User custom arguments to add in linter CLI call"
        | optional,
      BICEP_BICEP_LINTER_CLI_EXECUTABLE | Array (String) | optional,
      BICEP_BICEP_LINTER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      BICEP_BICEP_LINTER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "BICEP_BICEP_LINTER: User custom arguments to remove before calling linter"
        | optional,
      BICEP_BICEP_LINTER_DISABLE_ERRORS | Bool | optional,
      BICEP_BICEP_LINTER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      BICEP_BICEP_LINTER_FILE_EXTENSIONS | Array (String) | optional,
      BICEP_BICEP_LINTER_FILE_NAMES_REGEX | Array (String) | optional,
      BICEP_BICEP_LINTER_FILTER_REGEX_EXCLUDE | String | optional,
      BICEP_BICEP_LINTER_FILTER_REGEX_INCLUDE | String | optional,
      BICEP_BICEP_LINTER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BICEP_BICEP_LINTER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BICEP_BICEP_LINTER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling BICEP_BICEP_LINTER and its pre/post commands"
        | optional,
      BICEP_FILTER_REGEX_EXCLUDE | String | optional,
      BICEP_FILTER_REGEX_INCLUDE | String | optional,
      BICEP_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BICEP_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      BITBUCKET_COMMENT_REPORTER
        | Bool
        | doc "Posts Mega-Linter results summary in the comments of the related pull request (if existing)"
        | optional,
      BITBUCKET_COMMENT_REPORTER_OVERWRITE_COMMENT
        | Bool
        | doc "Set to false to disable the overwrite of existing MegaLinter Pull Request comment in case of new run"
        | optional,
      CLEAR_REPORT_FOLDER
        | Bool
        | doc "Flag to clear files from report folder (usually megalinter-reports) before starting the linting process"
        | optional,
      CLOJURE_CLJSTYLE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CLOJURE_CLJSTYLE: User custom arguments to add in linter CLI call"
        | optional,
      CLOJURE_CLJSTYLE_CLI_EXECUTABLE | Array (String) | optional,
      CLOJURE_CLJSTYLE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      CLOJURE_CLJSTYLE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CLOJURE_CLJSTYLE: User custom arguments to remove before calling linter"
        | optional,
      CLOJURE_CLJSTYLE_CONFIG_FILE
        | String
        | doc "CLOJURE_CLJSTYLE: User custom config file name if different from default"
        | optional,
      CLOJURE_CLJSTYLE_DISABLE_ERRORS | Bool | optional,
      CLOJURE_CLJSTYLE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CLOJURE_CLJSTYLE_FILE_EXTENSIONS | Array (String) | optional,
      CLOJURE_CLJSTYLE_FILE_NAMES_REGEX | Array (String) | optional,
      CLOJURE_CLJSTYLE_FILTER_REGEX_EXCLUDE | String | optional,
      CLOJURE_CLJSTYLE_FILTER_REGEX_INCLUDE | String | optional,
      CLOJURE_CLJSTYLE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOJURE_CLJSTYLE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOJURE_CLJSTYLE_RULES_PATH
        | String
        | doc "CLOJURE_CLJSTYLE: Path where to find linter configuration file"
        | optional,
      CLOJURE_CLJSTYLE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CLOJURE_CLJSTYLE and its pre/post commands"
        | optional,
      CLOJURE_CLJ_KONDO_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CLOJURE_CLJ_KONDO: User custom arguments to add in linter CLI call"
        | optional,
      CLOJURE_CLJ_KONDO_CLI_EXECUTABLE | Array (String) | optional,
      CLOJURE_CLJ_KONDO_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      CLOJURE_CLJ_KONDO_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CLOJURE_CLJ_KONDO: User custom arguments to remove before calling linter"
        | optional,
      CLOJURE_CLJ_KONDO_CONFIG_FILE
        | String
        | doc "CLOJURE_CLJ_KONDO: User custom config file name if different from default"
        | optional,
      CLOJURE_CLJ_KONDO_DISABLE_ERRORS | Bool | optional,
      CLOJURE_CLJ_KONDO_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CLOJURE_CLJ_KONDO_FILE_EXTENSIONS | Array (String) | optional,
      CLOJURE_CLJ_KONDO_FILE_NAME
        | String
        | doc "CLOJURE_CLJ_KONDO: User custom config file name if different from default"
        | optional,
      CLOJURE_CLJ_KONDO_FILE_NAMES_REGEX | Array (String) | optional,
      CLOJURE_CLJ_KONDO_FILTER_REGEX_EXCLUDE | String | optional,
      CLOJURE_CLJ_KONDO_FILTER_REGEX_INCLUDE | String | optional,
      CLOJURE_CLJ_KONDO_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOJURE_CLJ_KONDO_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOJURE_CLJ_KONDO_RULES_PATH
        | String
        | doc "CLOJURE_CLJ_KONDO: Path where to find linter configuration file"
        | optional,
      CLOJURE_CLJ_KONDO_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CLOJURE_CLJ_KONDO and its pre/post commands"
        | optional,
      CLOJURE_FILTER_REGEX_EXCLUDE | String | optional,
      CLOJURE_FILTER_REGEX_INCLUDE | String | optional,
      CLOJURE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOJURE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOUDFORMATION_CFN_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CLOUDFORMATION_CFN_LINT: User custom arguments to add in linter CLI call"
        | optional,
      CLOUDFORMATION_CFN_LINT_CLI_EXECUTABLE | Array (String) | optional,
      CLOUDFORMATION_CFN_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      CLOUDFORMATION_CFN_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CLOUDFORMATION_CFN_LINT: User custom arguments to remove before calling linter"
        | optional,
      CLOUDFORMATION_CFN_LINT_CONFIG_FILE
        | String
        | doc "CLOUDFORMATION_CFN_LINT: User custom config file name if different from default"
        | optional,
      CLOUDFORMATION_CFN_LINT_DISABLE_ERRORS | Bool | optional,
      CLOUDFORMATION_CFN_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CLOUDFORMATION_CFN_LINT_FILE_EXTENSIONS | Array (String) | optional,
      CLOUDFORMATION_CFN_LINT_FILE_NAME
        | String
        | doc "CLOUDFORMATION_CFN_LINT: User custom config file name if different from default"
        | optional,
      CLOUDFORMATION_CFN_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      CLOUDFORMATION_CFN_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      CLOUDFORMATION_CFN_LINT_FILTER_REGEX_INCLUDE | String | optional,
      CLOUDFORMATION_CFN_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOUDFORMATION_CFN_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOUDFORMATION_CFN_LINT_RULES_PATH
        | String
        | doc "CLOUDFORMATION_CFN_LINT: Path where to find linter configuration file"
        | optional,
      CLOUDFORMATION_CFN_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CLOUDFORMATION_CFN_LINT and its pre/post commands"
        | optional,
      CLOUDFORMATION_FILTER_REGEX_EXCLUDE | String | optional,
      CLOUDFORMATION_FILTER_REGEX_INCLUDE | String | optional,
      CLOUDFORMATION_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CLOUDFORMATION_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COFFEE_COFFEELINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "COFFEE_COFFEELINT: User custom arguments to add in linter CLI call"
        | optional,
      COFFEE_COFFEELINT_CLI_EXECUTABLE | Array (String) | optional,
      COFFEE_COFFEELINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      COFFEE_COFFEELINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "COFFEE_COFFEELINT: User custom arguments to remove before calling linter"
        | optional,
      COFFEE_COFFEELINT_CONFIG_FILE
        | String
        | doc "COFFEE_COFFEELINT: User custom config file name if different from default"
        | optional,
      COFFEE_COFFEELINT_DISABLE_ERRORS | Bool | optional,
      COFFEE_COFFEELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      COFFEE_COFFEELINT_FILE_EXTENSIONS | Array (String) | optional,
      COFFEE_COFFEELINT_FILE_NAME
        | String
        | doc "COFFEE_COFFEELINT: User custom config file name if different from default"
        | optional,
      COFFEE_COFFEELINT_FILE_NAMES_REGEX | Array (String) | optional,
      COFFEE_COFFEELINT_FILTER_REGEX_EXCLUDE | String | optional,
      COFFEE_COFFEELINT_FILTER_REGEX_INCLUDE | String | optional,
      COFFEE_COFFEELINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COFFEE_COFFEELINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COFFEE_COFFEELINT_RULES_PATH
        | String
        | doc "COFFEE_COFFEELINT: Path where to find linter configuration file"
        | optional,
      COFFEE_COFFEELINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling COFFEE_COFFEELINT and its pre/post commands"
        | optional,
      COFFEE_FILTER_REGEX_EXCLUDE | String | optional,
      COFFEE_FILTER_REGEX_INCLUDE | String | optional,
      COFFEE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COFFEE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CONFIG_PROPERTIES_TO_APPEND
        | Array (String)
        | doc "List of configuration properties to append their values (instead of replacing them) in case of using EXTENDS."
        | optional,
      CONFIG_REPORTER
        | Bool
        | doc "Generates a folder IDE-config located in report folder, containing default MegaLinter configuration files used during the linting, and updated VSCode extensions.js config file"
        | optional,
      CONFIG_REPORTER_SUB_FOLDER | String | optional,
      CONSOLE_REPORTER | Bool | doc "" | optional,
      CONSOLE_REPORTER_SECTIONS
        | Bool
        | doc "Define to false if you do not want logs to be organized in sections"
        | optional,
      COPYPASTE_FILTER_REGEX_EXCLUDE | String | optional,
      COPYPASTE_FILTER_REGEX_INCLUDE | String | optional,
      COPYPASTE_JSCPD_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "COPYPASTE_JSCPD: User custom arguments to add in linter CLI call"
        | optional,
      COPYPASTE_JSCPD_CLI_EXECUTABLE | Array (String) | optional,
      COPYPASTE_JSCPD_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      COPYPASTE_JSCPD_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "COPYPASTE_JSCPD: User custom arguments to remove before calling linter"
        | optional,
      COPYPASTE_JSCPD_CONFIG_FILE
        | String
        | doc "COPYPASTE_JSCPD: User custom config file name if different from default"
        | optional,
      COPYPASTE_JSCPD_DISABLE_ERRORS | Bool | optional,
      COPYPASTE_JSCPD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      COPYPASTE_JSCPD_FILE_NAME
        | String
        | doc "COPYPASTE_JSCPD: User custom config file name if different from default"
        | optional,
      COPYPASTE_JSCPD_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COPYPASTE_JSCPD_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COPYPASTE_JSCPD_RULES_PATH
        | String
        | doc "COPYPASTE_JSCPD: Path where to find linter configuration file"
        | optional,
      COPYPASTE_JSCPD_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling COPYPASTE_JSCPD and its pre/post commands"
        | optional,
      COPYPASTE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      COPYPASTE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CPP_CLANG_FORMAT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CPP_CLANG_FORMAT: User custom arguments to add in linter CLI call"
        | optional,
      CPP_CLANG_FORMAT_CLI_EXECUTABLE | Array (String) | optional,
      CPP_CLANG_FORMAT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      CPP_CLANG_FORMAT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CPP_CLANG_FORMAT: User custom arguments to remove before calling linter"
        | optional,
      CPP_CLANG_FORMAT_CONFIG_FILE
        | String
        | doc "CPP_CLANG_FORMAT: User custom config file name if different from default"
        | optional,
      CPP_CLANG_FORMAT_DISABLE_ERRORS | Bool | optional,
      CPP_CLANG_FORMAT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CPP_CLANG_FORMAT_FILE_EXTENSIONS | Array (String) | optional,
      CPP_CLANG_FORMAT_FILE_NAMES_REGEX | Array (String) | optional,
      CPP_CLANG_FORMAT_FILTER_REGEX_EXCLUDE | String | optional,
      CPP_CLANG_FORMAT_FILTER_REGEX_INCLUDE | String | optional,
      CPP_CLANG_FORMAT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CPP_CLANG_FORMAT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CPP_CLANG_FORMAT_RULES_PATH
        | String
        | doc "CPP_CLANG_FORMAT: Path where to find linter configuration file"
        | optional,
      CPP_CLANG_FORMAT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CPP_CLANG_FORMAT and its pre/post commands"
        | optional,
      CPP_CPPLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CPP_CPPLINT: User custom arguments to add in linter CLI call"
        | optional,
      CPP_CPPLINT_CLI_EXECUTABLE | Array (String) | optional,
      CPP_CPPLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      CPP_CPPLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CPP_CPPLINT: User custom arguments to remove before calling linter"
        | optional,
      CPP_CPPLINT_DISABLE_ERRORS | Bool | optional,
      CPP_CPPLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CPP_CPPLINT_FILE_EXTENSIONS | Array (String) | optional,
      CPP_CPPLINT_FILE_NAMES_REGEX | Array (String) | optional,
      CPP_CPPLINT_FILTER_REGEX_EXCLUDE | String | optional,
      CPP_CPPLINT_FILTER_REGEX_INCLUDE | String | optional,
      CPP_CPPLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CPP_CPPLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CPP_CPPLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CPP_CPPLINT and its pre/post commands"
        | optional,
      CPP_FILTER_REGEX_EXCLUDE | String | optional,
      CPP_FILTER_REGEX_INCLUDE | String | optional,
      CPP_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CPP_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CREDENTIALS_FILTER_REGEX_EXCLUDE | String | optional,
      CREDENTIALS_FILTER_REGEX_INCLUDE | String | optional,
      CREDENTIALS_SECRETLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CREDENTIALS_SECRETLINT: User custom arguments to add in linter CLI call"
        | optional,
      CREDENTIALS_SECRETLINT_CONFIG_FILE
        | String
        | doc "CREDENTIALS_SECRETLINT: User custom config file name if different from default"
        | optional,
      CREDENTIALS_SECRETLINT_DISABLE_ERRORS | Bool | optional,
      CREDENTIALS_SECRETLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CREDENTIALS_SECRETLINT_FILE_EXTENSIONS | Array (String) | optional,
      CREDENTIALS_SECRETLINT_FILE_NAMES_REGEX | Array (String) | optional,
      CREDENTIALS_SECRETLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CREDENTIALS_SECRETLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CREDENTIALS_SECRETLINT_RULES_PATH
        | String
        | doc "CREDENTIALS_SECRETLINT: Path where to find linter configuration file"
        | optional,
      CSHARP_CSHARPIER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSHARP_CSHARPIER: User custom arguments to add in linter CLI call"
        | optional,
      CSHARP_CSHARPIER_CLI_EXECUTABLE | Array (String) | optional,
      CSHARP_CSHARPIER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      CSHARP_CSHARPIER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSHARP_CSHARPIER: User custom arguments to remove before calling linter"
        | optional,
      CSHARP_CSHARPIER_CONFIG_FILE
        | String
        | doc "CSHARP_CSHARPIER: User custom config file name if different from default"
        | optional,
      CSHARP_CSHARPIER_DISABLE_ERRORS | Bool | optional,
      CSHARP_CSHARPIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CSHARP_CSHARPIER_FILE_EXTENSIONS | Array (String) | optional,
      CSHARP_CSHARPIER_FILE_NAMES_REGEX | Array (String) | optional,
      CSHARP_CSHARPIER_FILTER_REGEX_EXCLUDE | String | optional,
      CSHARP_CSHARPIER_FILTER_REGEX_INCLUDE | String | optional,
      CSHARP_CSHARPIER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_CSHARPIER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_CSHARPIER_RULES_PATH
        | String
        | doc "CSHARP_CSHARPIER: Path where to find linter configuration file"
        | optional,
      CSHARP_CSHARPIER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CSHARP_CSHARPIER and its pre/post commands"
        | optional,
      CSHARP_DOTNET_FORMAT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSHARP_DOTNET_FORMAT: User custom arguments to add in linter CLI call"
        | optional,
      CSHARP_DOTNET_FORMAT_CLI_EXECUTABLE | Array (String) | optional,
      CSHARP_DOTNET_FORMAT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      CSHARP_DOTNET_FORMAT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSHARP_DOTNET_FORMAT: User custom arguments to remove before calling linter"
        | optional,
      CSHARP_DOTNET_FORMAT_DISABLE_ERRORS | Bool | optional,
      CSHARP_DOTNET_FORMAT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CSHARP_DOTNET_FORMAT_FILE_EXTENSIONS | Array (String) | optional,
      CSHARP_DOTNET_FORMAT_FILE_NAMES_REGEX | Array (String) | optional,
      CSHARP_DOTNET_FORMAT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_DOTNET_FORMAT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_DOTNET_FORMAT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CSHARP_DOTNET_FORMAT and its pre/post commands"
        | optional,
      CSHARP_FILTER_REGEX_EXCLUDE | String | optional,
      CSHARP_FILTER_REGEX_INCLUDE | String | optional,
      CSHARP_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_ROSLYNATOR_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSHARP_ROSLYNATOR: User custom arguments to add in linter CLI call"
        | optional,
      CSHARP_ROSLYNATOR_CLI_EXECUTABLE | Array (String) | optional,
      CSHARP_ROSLYNATOR_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      CSHARP_ROSLYNATOR_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSHARP_ROSLYNATOR: User custom arguments to remove before calling linter"
        | optional,
      CSHARP_ROSLYNATOR_DISABLE_ERRORS | Bool | optional,
      CSHARP_ROSLYNATOR_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CSHARP_ROSLYNATOR_FILE_EXTENSIONS | Array (String) | optional,
      CSHARP_ROSLYNATOR_FILE_NAMES_REGEX | Array (String) | optional,
      CSHARP_ROSLYNATOR_FILTER_REGEX_EXCLUDE | String | optional,
      CSHARP_ROSLYNATOR_FILTER_REGEX_INCLUDE | String | optional,
      CSHARP_ROSLYNATOR_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_ROSLYNATOR_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSHARP_ROSLYNATOR_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CSHARP_ROSLYNATOR and its pre/post commands"
        | optional,
      CSS_FILTER_REGEX_EXCLUDE | String | optional,
      CSS_FILTER_REGEX_INCLUDE | String | optional,
      CSS_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSS_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSS_SCSS_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSS_SCSS_LINT: User custom arguments to add in linter CLI call"
        | optional,
      CSS_SCSS_LINT_CLI_EXECUTABLE | Array (String) | optional,
      CSS_SCSS_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      CSS_SCSS_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSS_SCSS_LINT: User custom arguments to remove before calling linter"
        | optional,
      CSS_SCSS_LINT_CONFIG_FILE
        | String
        | doc "CSS_SCSS_LINT: User custom config file name if different from default"
        | optional,
      CSS_SCSS_LINT_DISABLE_ERRORS | Bool | optional,
      CSS_SCSS_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CSS_SCSS_LINT_FILE_EXTENSIONS | Array (String) | optional,
      CSS_SCSS_LINT_FILE_NAME
        | String
        | doc "CSS_SCSS_LINT: User custom config file name if different from default"
        | optional,
      CSS_SCSS_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      CSS_SCSS_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      CSS_SCSS_LINT_FILTER_REGEX_INCLUDE | String | optional,
      CSS_SCSS_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSS_SCSS_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSS_SCSS_LINT_RULES_PATH
        | String
        | doc "CSS_SCSS_LINT: Path where to find linter configuration file"
        | optional,
      CSS_SCSS_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CSS_SCSS_LINT and its pre/post commands"
        | optional,
      CSS_STYLELINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSS_STYLELINT: User custom arguments to add in linter CLI call"
        | optional,
      CSS_STYLELINT_CLI_EXECUTABLE | Array (String) | optional,
      CSS_STYLELINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      CSS_STYLELINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "CSS_STYLELINT: User custom arguments to remove before calling linter"
        | optional,
      CSS_STYLELINT_CONFIG_FILE
        | String
        | doc "CSS_STYLELINT: User custom config file name if different from default"
        | optional,
      CSS_STYLELINT_DISABLE_ERRORS | Bool | optional,
      CSS_STYLELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      CSS_STYLELINT_FILE_EXTENSIONS | Array (String) | optional,
      CSS_STYLELINT_FILE_NAME
        | String
        | doc "CSS_STYLELINT: User custom config file name if different from default"
        | optional,
      CSS_STYLELINT_FILE_NAMES_REGEX | Array (String) | optional,
      CSS_STYLELINT_FILTER_REGEX_EXCLUDE | String | optional,
      CSS_STYLELINT_FILTER_REGEX_INCLUDE | String | optional,
      CSS_STYLELINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSS_STYLELINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      CSS_STYLELINT_RULES_PATH
        | String
        | doc "CSS_STYLELINT: Path where to find linter configuration file"
        | optional,
      CSS_STYLELINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling CSS_STYLELINT and its pre/post commands"
        | optional,
      C_CLANG_FORMAT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "C_CLANG_FORMAT: User custom arguments to add in linter CLI call"
        | optional,
      C_CLANG_FORMAT_CLI_EXECUTABLE | Array (String) | optional,
      C_CLANG_FORMAT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      C_CLANG_FORMAT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "C_CLANG_FORMAT: User custom arguments to remove before calling linter"
        | optional,
      C_CLANG_FORMAT_CONFIG_FILE
        | String
        | doc "C_CLANG_FORMAT: User custom config file name if different from default"
        | optional,
      C_CLANG_FORMAT_DISABLE_ERRORS | Bool | optional,
      C_CLANG_FORMAT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      C_CLANG_FORMAT_FILE_EXTENSIONS | Array (String) | optional,
      C_CLANG_FORMAT_FILE_NAMES_REGEX | Array (String) | optional,
      C_CLANG_FORMAT_FILTER_REGEX_EXCLUDE | String | optional,
      C_CLANG_FORMAT_FILTER_REGEX_INCLUDE | String | optional,
      C_CLANG_FORMAT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      C_CLANG_FORMAT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      C_CLANG_FORMAT_RULES_PATH
        | String
        | doc "C_CLANG_FORMAT: Path where to find linter configuration file"
        | optional,
      C_CLANG_FORMAT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling C_CLANG_FORMAT and its pre/post commands"
        | optional,
      C_CPPLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "C_CPPLINT: User custom arguments to add in linter CLI call"
        | optional,
      C_CPPLINT_CLI_EXECUTABLE | Array (String) | optional,
      C_CPPLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      C_CPPLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "C_CPPLINT: User custom arguments to remove before calling linter"
        | optional,
      C_CPPLINT_DISABLE_ERRORS | Bool | optional,
      C_CPPLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      C_CPPLINT_FILE_EXTENSIONS | Array (String) | optional,
      C_CPPLINT_FILE_NAMES_REGEX | Array (String) | optional,
      C_CPPLINT_FILTER_REGEX_EXCLUDE | String | optional,
      C_CPPLINT_FILTER_REGEX_INCLUDE | String | optional,
      C_CPPLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      C_CPPLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      C_CPPLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling C_CPPLINT and its pre/post commands"
        | optional,
      C_FILTER_REGEX_EXCLUDE | String | optional,
      C_FILTER_REGEX_INCLUDE | String | optional,
      C_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      C_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DART_DARTANALYZER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "DART_DARTANALYZER: User custom arguments to add in linter CLI call"
        | optional,
      DART_DARTANALYZER_CLI_EXECUTABLE | Array (String) | optional,
      DART_DARTANALYZER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      DART_DARTANALYZER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "DART_DARTANALYZER: User custom arguments to remove before calling linter"
        | optional,
      DART_DARTANALYZER_CONFIG_FILE
        | String
        | doc "DART_DARTANALYZER: User custom config file name if different from default"
        | optional,
      DART_DARTANALYZER_DISABLE_ERRORS | Bool | optional,
      DART_DARTANALYZER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      DART_DARTANALYZER_FILE_EXTENSIONS | Array (String) | optional,
      DART_DARTANALYZER_FILE_NAME
        | String
        | doc "DART_DARTANALYZER: User custom config file name if different from default"
        | optional,
      DART_DARTANALYZER_FILE_NAMES_REGEX | Array (String) | optional,
      DART_DARTANALYZER_FILTER_REGEX_EXCLUDE | String | optional,
      DART_DARTANALYZER_FILTER_REGEX_INCLUDE | String | optional,
      DART_DARTANALYZER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DART_DARTANALYZER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DART_DARTANALYZER_RULES_PATH
        | String
        | doc "DART_DARTANALYZER: Path where to find linter configuration file"
        | optional,
      DART_DARTANALYZER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling DART_DARTANALYZER and its pre/post commands"
        | optional,
      DART_FILTER_REGEX_EXCLUDE | String | optional,
      DART_FILTER_REGEX_INCLUDE | String | optional,
      DART_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DART_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DEFAULT_BRANCH
        | String
        | doc "Deprecated: The name of the repository's default branch."
        | optional,
      DEFAULT_WORKSPACE
        | String
        | doc "The location containing files to lint if you are running as docker image"
        | optional,
      DISABLE
        | Array
          _js2n__-refsenv."_js2n__-:definitions/enum_descriptor_keys!contract"
        | doc "If DISABLE is set, the linters in the listed descriptors will be skipped"
        | optional,
      DISABLE_ERRORS
        | Bool
        | doc "Flag to have the MegaLinter complete with exit code 0 even if errors were detected."
        | optional,
      DISABLE_ERRORS_LINTERS
        | Array _js2n__-refsenv."_js2n__-:definitions/enum_linter_keys!contract"
        | doc "If DISABLE_ERRORS_LINTERS is set, the listed linters will be run but errors will be not blocking"
        | optional,
      DISABLE_LINTERS
        | Array _js2n__-refsenv."_js2n__-:definitions/enum_linter_keys!contract"
        | doc "If DISABLE_LINTERS is set, the listed linters will be skipped"
        | optional,
      DOCKERFILE_DOCKERFILELINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "DOCKERFILE_DOCKERFILELINT: User custom arguments to add in linter CLI call"
        | optional,
      DOCKERFILE_DOCKERFILELINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      DOCKERFILE_DOCKERFILELINT_CONFIG_FILE
        | String
        | doc "DOCKERFILE_DOCKERFILELINT: User custom config file name if different from default"
        | optional,
      DOCKERFILE_DOCKERFILELINT_DISABLE_ERRORS | Bool | optional,
      DOCKERFILE_DOCKERFILELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      DOCKERFILE_DOCKERFILELINT_FILE_EXTENSIONS | Array (String) | optional,
      DOCKERFILE_DOCKERFILELINT_FILE_NAME
        | String
        | doc "DOCKERFILE_DOCKERFILELINT: User custom config file name if different from default"
        | optional,
      DOCKERFILE_DOCKERFILELINT_FILE_NAMES_REGEX | Array (String) | optional,
      DOCKERFILE_DOCKERFILELINT_FILTER_REGEX_EXCLUDE | String | optional,
      DOCKERFILE_DOCKERFILELINT_FILTER_REGEX_INCLUDE | String | optional,
      DOCKERFILE_DOCKERFILELINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DOCKERFILE_DOCKERFILELINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DOCKERFILE_DOCKERFILELINT_RULES_PATH
        | String
        | doc "DOCKERFILE_DOCKERFILELINT: Path where to find linter configuration file"
        | optional,
      DOCKERFILE_FILTER_REGEX_EXCLUDE | String | optional,
      DOCKERFILE_FILTER_REGEX_INCLUDE | String | optional,
      DOCKERFILE_HADOLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "DOCKERFILE_HADOLINT: User custom arguments to add in linter CLI call"
        | optional,
      DOCKERFILE_HADOLINT_CLI_EXECUTABLE | Array (String) | optional,
      DOCKERFILE_HADOLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      DOCKERFILE_HADOLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "DOCKERFILE_HADOLINT: User custom arguments to remove before calling linter"
        | optional,
      DOCKERFILE_HADOLINT_CONFIG_FILE
        | String
        | doc "DOCKERFILE_HADOLINT: User custom config file name if different from default"
        | optional,
      DOCKERFILE_HADOLINT_DISABLE_ERRORS | Bool | optional,
      DOCKERFILE_HADOLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      DOCKERFILE_HADOLINT_FILE_EXTENSIONS | Array (String) | optional,
      DOCKERFILE_HADOLINT_FILE_NAME
        | String
        | doc "DOCKERFILE_HADOLINT: User custom config file name if different from default"
        | optional,
      DOCKERFILE_HADOLINT_FILE_NAMES_REGEX | Array (String) | optional,
      DOCKERFILE_HADOLINT_FILTER_REGEX_EXCLUDE | String | optional,
      DOCKERFILE_HADOLINT_FILTER_REGEX_INCLUDE | String | optional,
      DOCKERFILE_HADOLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DOCKERFILE_HADOLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DOCKERFILE_HADOLINT_RULES_PATH
        | String
        | doc "DOCKERFILE_HADOLINT: Path where to find linter configuration file"
        | optional,
      DOCKERFILE_HADOLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling DOCKERFILE_HADOLINT and its pre/post commands"
        | optional,
      DOCKERFILE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      DOCKERFILE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "EDITORCONFIG_EDITORCONFIG_CHECKER: User custom arguments to add in linter CLI call"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_CLI_EXECUTABLE
        | Array (String)
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "EDITORCONFIG_EDITORCONFIG_CHECKER: User custom arguments to remove before calling linter"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_CONFIG_FILE
        | String
        | doc "EDITORCONFIG_EDITORCONFIG_CHECKER: User custom config file name if different from default"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_DISABLE_ERRORS | Bool | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_FILE_EXTENSIONS
        | Array (String)
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_FILE_NAME
        | String
        | doc "EDITORCONFIG_EDITORCONFIG_CHECKER: User custom config file name if different from default"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_FILE_NAMES_REGEX
        | Array (String)
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_FILTER_REGEX_EXCLUDE
        | String
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_FILTER_REGEX_INCLUDE
        | String
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_RULES_PATH
        | String
        | doc "EDITORCONFIG_EDITORCONFIG_CHECKER: Path where to find linter configuration file"
        | optional,
      EDITORCONFIG_EDITORCONFIG_CHECKER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling EDITORCONFIG_EDITORCONFIG_CHECKER and its pre/post commands"
        | optional,
      EDITORCONFIG_FILTER_REGEX_EXCLUDE | String | optional,
      EDITORCONFIG_FILTER_REGEX_INCLUDE | String | optional,
      EDITORCONFIG_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      EDITORCONFIG_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      EMAIL_REPORTER
        | Bool
        | doc "MegaLinter can send email with reports to given addresses. Please set EMAIL_REPORTER_** variables if activated"
        | optional,
      EMAIL_REPORTER_EMAIL
        | String
        | doc "Comma-separated list of recipient emails, that will receive reports"
        | optional,
      EMAIL_REPORTER_SENDER | String | optional,
      EMAIL_REPORTER_SEND_SUCCESS
        | Bool
        | doc "Define to true if you want to receive reports by mail even when there is no errors or updated sources"
        | optional,
      EMAIL_REPORTER_SMTP_HOST | String | optional,
      EMAIL_REPORTER_SMTP_PASSWORD | String | optional,
      EMAIL_REPORTER_SMTP_PORT | Number | optional,
      EMAIL_REPORTER_SMTP_USERNAME | String | optional,
      ENABLE
        | Array
          _js2n__-refsenv."_js2n__-:definitions/enum_descriptor_keys!contract"
        | doc "If ENABLE is not set, all descriptors are activated by default. If set, all linters of listed descriptors will be activated by default"
        | optional,
      ENABLE_LINTERS
        | Array _js2n__-refsenv."_js2n__-:definitions/enum_linter_keys!contract"
        | doc "If ENABLE_LINTERS is set, only listed linters will be processed"
        | optional,
      ENV_DOTENV_LINTER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ENV_DOTENV_LINTER: User custom arguments to add in linter CLI call"
        | optional,
      ENV_DOTENV_LINTER_CLI_EXECUTABLE | Array (String) | optional,
      ENV_DOTENV_LINTER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      ENV_DOTENV_LINTER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "ENV_DOTENV_LINTER: User custom arguments to remove before calling linter"
        | optional,
      ENV_DOTENV_LINTER_DISABLE_ERRORS | Bool | optional,
      ENV_DOTENV_LINTER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      ENV_DOTENV_LINTER_FILE_EXTENSIONS | Array (String) | optional,
      ENV_DOTENV_LINTER_FILE_NAMES_REGEX | Array (String) | optional,
      ENV_DOTENV_LINTER_FILTER_REGEX_EXCLUDE | String | optional,
      ENV_DOTENV_LINTER_FILTER_REGEX_INCLUDE | String | optional,
      ENV_DOTENV_LINTER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ENV_DOTENV_LINTER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ENV_DOTENV_LINTER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling ENV_DOTENV_LINTER and its pre/post commands"
        | optional,
      ENV_FILTER_REGEX_EXCLUDE | String | optional,
      ENV_FILTER_REGEX_INCLUDE | String | optional,
      ENV_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ENV_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      ERROR_ON_MISSING_EXEC_BIT
        | Bool
        | doc "If set to `false`, the `bash-exec` linter will report a warning if a shell script is not executable. If set to `true`, the `bash-exec` linter will report an error instead"
        | optional,
      EXCLUDED_DIRECTORIES
        | Array (String)
        | doc "List of excluded directory basenames replacing MegaLinter default excluded directories. They are excluded at any nested level."
        | optional,
      EXTENDS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "Base mega-linter.yml config file(s) to extend local configuration from. Can be a single URL or a list of .mega-linter.yml config files URLs"
        | optional,
      FAIL_IF_MISSING_LINTER_IN_FLAVOR
        | Bool
        | doc "If set to true, MegaLinter fails if a linter is missing in the selected flavor"
        | optional,
      FAIL_IF_UPDATED_SOURCES
        | Bool
        | doc "If set to true, MegaLinter fails if a linter or formatter has auto-fixed sources, even if there are no errors"
        | optional,
      FILEIO_REPORTER
        | Bool
        | doc "If you don't use artifacts upload to read MegaLinter reports, you can access them with an hyperlink to file.io. Important: MegaLinter has no affiliation with file.io, but it's supposed to be secured, and only one download is available for a report (snapchat for files, basically)"
        | optional,
      FILEIO_REPORTER_SEND_SUCCESS
        | Bool
        | doc "Skip posting to file.io if linting is in success"
        | optional,
      FILTER_REGEX_EXCLUDE
        | String
        | doc "Regular expression defining which files will be excluded from linting"
        | optional,
      FILTER_REGEX_INCLUDE
        | String
        | doc "Regular expression defining which files will be processed by linters"
        | optional,
      FLAVOR_SUGGESTIONS
        | Bool
        | doc "Provides suggestions about different MegaLinter flavors to use to improve runtime performances"
        | optional,
      FORMATTERS_DISABLE_ERRORS
        | Bool
        | doc "Formatter errors will be reported as errors (and not warnings) if this variable is set to false"
        | optional,
      GHERKIN_FILTER_REGEX_EXCLUDE | String | optional,
      GHERKIN_FILTER_REGEX_INCLUDE | String | optional,
      GHERKIN_GHERKIN_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GHERKIN_GHERKIN_LINT: User custom arguments to add in linter CLI call"
        | optional,
      GHERKIN_GHERKIN_LINT_CLI_EXECUTABLE | Array (String) | optional,
      GHERKIN_GHERKIN_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      GHERKIN_GHERKIN_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GHERKIN_GHERKIN_LINT: User custom arguments to remove before calling linter"
        | optional,
      GHERKIN_GHERKIN_LINT_CONFIG_FILE
        | String
        | doc "GHERKIN_GHERKIN_LINT: User custom config file name if different from default"
        | optional,
      GHERKIN_GHERKIN_LINT_DISABLE_ERRORS | Bool | optional,
      GHERKIN_GHERKIN_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      GHERKIN_GHERKIN_LINT_FILE_EXTENSIONS | Array (String) | optional,
      GHERKIN_GHERKIN_LINT_FILE_NAME
        | String
        | doc "GHERKIN_GHERKIN_LINT: User custom config file name if different from default"
        | optional,
      GHERKIN_GHERKIN_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      GHERKIN_GHERKIN_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      GHERKIN_GHERKIN_LINT_FILTER_REGEX_INCLUDE | String | optional,
      GHERKIN_GHERKIN_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GHERKIN_GHERKIN_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GHERKIN_GHERKIN_LINT_RULES_PATH
        | String
        | doc "GHERKIN_GHERKIN_LINT: Path where to find linter configuration file"
        | optional,
      GHERKIN_GHERKIN_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling GHERKIN_GHERKIN_LINT and its pre/post commands"
        | optional,
      GHERKIN_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GHERKIN_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GITHUB_API_URL
        | String
        | doc "URL where the github API can be reached. Must be overridden if using GitHub Enterprise"
        | optional,
      GITHUB_COMMENT_REPORTER
        | Bool
        | doc "Posts MegaLinter results summary in the comments of the related pull request (if existing)"
        | optional,
      GITHUB_SERVER_URL
        | String
        | doc "URL of the GitHub instance. Must be overridden if using GitHub Enterprise"
        | optional,
      GITHUB_STATUS_REPORTER
        | Bool
        | doc "Posts a status on the pull request for each processed linter"
        | optional,
      GITHUB_WORKSPACE
        | String
        | doc "Base directory for REPORT_OUTPUT_FOLDER, for user-defined linter rules location, for location of linted files if DEFAULT_WORKSPACE is not set"
        | optional,
      GITLAB_ACCESS_TOKEN_MEGALINTER
        | String
        | doc "Gitlab access token with API access (can be user or project Access token)"
        | optional,
      GITLAB_CERTIFICATE_PATH
        | String
        | doc "Path to SSL certificate if necessary"
        | optional,
      GITLAB_COMMENT_REPORTER
        | Bool
        | doc "Posts Mega-Linter results summary in the comments of the related merge request (if existing)"
        | optional,
      GITLAB_COMMENT_REPORTER_OVERWRITE_COMMENT
        | Bool
        | doc "Set to false to disable the overwrite of existing MegaLinter Merge Request comment in case of new run"
        | optional,
      GITLAB_CUSTOM_CERTIFICATE
        | String
        | doc "Store your SSL certificate string value in a CI env variable named GITLAB_CUSTOM_CERTIFICATE if you want it to be copied by MegaLinter in a local certificate file that will be used by python gitlab lib"
        | optional,
      GIT_FILTER_REGEX_EXCLUDE | String | optional,
      GIT_FILTER_REGEX_INCLUDE | String | optional,
      GIT_GIT_DIFF_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GIT_GIT_DIFF: User custom arguments to add in linter CLI call"
        | optional,
      GIT_GIT_DIFF_DISABLE_ERRORS | Bool | optional,
      GIT_GIT_DIFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      GIT_GIT_DIFF_FILE_EXTENSIONS | Array (String) | optional,
      GIT_GIT_DIFF_FILE_NAMES_REGEX | Array (String) | optional,
      GIT_GIT_DIFF_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GIT_GIT_DIFF_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_FILTER_REGEX_EXCLUDE | String | optional,
      GO_FILTER_REGEX_INCLUDE | String | optional,
      GO_GOLANGCI_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GO_GOLANGCI_LINT: User custom arguments to add in linter CLI call"
        | optional,
      GO_GOLANGCI_LINT_CLI_EXECUTABLE | Array (String) | optional,
      GO_GOLANGCI_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      GO_GOLANGCI_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GO_GOLANGCI_LINT: User custom arguments to remove before calling linter"
        | optional,
      GO_GOLANGCI_LINT_CONFIG_FILE
        | String
        | doc "GO_GOLANGCI_LINT: User custom config file name if different from default"
        | optional,
      GO_GOLANGCI_LINT_DISABLE_ERRORS | Bool | optional,
      GO_GOLANGCI_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      GO_GOLANGCI_LINT_FILE_EXTENSIONS | Array (String) | optional,
      GO_GOLANGCI_LINT_FILE_NAME
        | String
        | doc "GO_GOLANGCI_LINT: User custom config file name if different from default"
        | optional,
      GO_GOLANGCI_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      GO_GOLANGCI_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_GOLANGCI_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_GOLANGCI_LINT_RULES_PATH
        | String
        | doc "GO_GOLANGCI_LINT: Path where to find linter configuration file"
        | optional,
      GO_GOLANGCI_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling GO_GOLANGCI_LINT and its pre/post commands"
        | optional,
      GO_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_REVIVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GO_REVIVE: User custom arguments to add in linter CLI call"
        | optional,
      GO_REVIVE_CLI_EXECUTABLE | Array (String) | optional,
      GO_REVIVE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      GO_REVIVE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GO_REVIVE: User custom arguments to remove before calling linter"
        | optional,
      GO_REVIVE_CONFIG_FILE
        | String
        | doc "GO_REVIVE: User custom config file name if different from default"
        | optional,
      GO_REVIVE_DISABLE_ERRORS | Bool | optional,
      GO_REVIVE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      GO_REVIVE_FILE_EXTENSIONS | Array (String) | optional,
      GO_REVIVE_FILE_NAMES_REGEX | Array (String) | optional,
      GO_REVIVE_FILTER_REGEX_EXCLUDE | String | optional,
      GO_REVIVE_FILTER_REGEX_INCLUDE | String | optional,
      GO_REVIVE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_REVIVE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GO_REVIVE_RULES_PATH
        | String
        | doc "GO_REVIVE: Path where to find linter configuration file"
        | optional,
      GO_REVIVE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling GO_REVIVE and its pre/post commands"
        | optional,
      GRAPHQL_FILTER_REGEX_EXCLUDE | String | optional,
      GRAPHQL_FILTER_REGEX_INCLUDE | String | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom arguments to add in linter CLI call"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_CLI_EXECUTABLE | Array (String) | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom arguments to remove before calling linter"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_CONFIG_FILE
        | String
        | doc "GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom config file name if different from default"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_DISABLE_ERRORS | Bool | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILE_EXTENSIONS | Array (String) | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILE_NAME
        | String
        | doc "GRAPHQL_GRAPHQL_SCHEMA_LINTER: User custom config file name if different from default"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILE_NAMES_REGEX
        | Array (String)
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILTER_REGEX_EXCLUDE | String | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_FILTER_REGEX_INCLUDE | String | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_RULES_PATH
        | String
        | doc "GRAPHQL_GRAPHQL_SCHEMA_LINTER: Path where to find linter configuration file"
        | optional,
      GRAPHQL_GRAPHQL_SCHEMA_LINTER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling GRAPHQL_GRAPHQL_SCHEMA_LINTER and its pre/post commands"
        | optional,
      GRAPHQL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GRAPHQL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GROOVY_FILTER_REGEX_EXCLUDE | String | optional,
      GROOVY_FILTER_REGEX_INCLUDE | String | optional,
      GROOVY_NPM_GROOVY_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GROOVY_NPM_GROOVY_LINT: User custom arguments to add in linter CLI call"
        | optional,
      GROOVY_NPM_GROOVY_LINT_CLI_EXECUTABLE | Array (String) | optional,
      GROOVY_NPM_GROOVY_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      GROOVY_NPM_GROOVY_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "GROOVY_NPM_GROOVY_LINT: User custom arguments to remove before calling linter"
        | optional,
      GROOVY_NPM_GROOVY_LINT_CONFIG_FILE
        | String
        | doc "GROOVY_NPM_GROOVY_LINT: User custom config file name if different from default"
        | optional,
      GROOVY_NPM_GROOVY_LINT_DISABLE_ERRORS | Bool | optional,
      GROOVY_NPM_GROOVY_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      GROOVY_NPM_GROOVY_LINT_FILE_EXTENSIONS | Array (String) | optional,
      GROOVY_NPM_GROOVY_LINT_FILE_NAME
        | String
        | doc "GROOVY_NPM_GROOVY_LINT: User custom config file name if different from default"
        | optional,
      GROOVY_NPM_GROOVY_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      GROOVY_NPM_GROOVY_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      GROOVY_NPM_GROOVY_LINT_FILTER_REGEX_INCLUDE | String | optional,
      GROOVY_NPM_GROOVY_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GROOVY_NPM_GROOVY_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GROOVY_NPM_GROOVY_LINT_RULES_PATH
        | String
        | doc "GROOVY_NPM_GROOVY_LINT: Path where to find linter configuration file"
        | optional,
      GROOVY_NPM_GROOVY_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling GROOVY_NPM_GROOVY_LINT and its pre/post commands"
        | optional,
      GROOVY_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      GROOVY_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      HTML_DJLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "HTML_DJLINT: User custom arguments to add in linter CLI call"
        | optional,
      HTML_DJLINT_CLI_EXECUTABLE | Array (String) | optional,
      HTML_DJLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      HTML_DJLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "HTML_DJLINT: User custom arguments to remove before calling linter"
        | optional,
      HTML_DJLINT_DISABLE_ERRORS | Bool | optional,
      HTML_DJLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      HTML_DJLINT_FILE_EXTENSIONS | Array (String) | optional,
      HTML_DJLINT_FILE_NAMES_REGEX | Array (String) | optional,
      HTML_DJLINT_FILTER_REGEX_EXCLUDE | String | optional,
      HTML_DJLINT_FILTER_REGEX_INCLUDE | String | optional,
      HTML_DJLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      HTML_DJLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      HTML_DJLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling HTML_DJLINT and its pre/post commands"
        | optional,
      HTML_FILTER_REGEX_EXCLUDE | String | optional,
      HTML_FILTER_REGEX_INCLUDE | String | optional,
      HTML_HTMLHINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "HTML_HTMLHINT: User custom arguments to add in linter CLI call"
        | optional,
      HTML_HTMLHINT_CLI_EXECUTABLE | Array (String) | optional,
      HTML_HTMLHINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      HTML_HTMLHINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "HTML_HTMLHINT: User custom arguments to remove before calling linter"
        | optional,
      HTML_HTMLHINT_CONFIG_FILE
        | String
        | doc "HTML_HTMLHINT: User custom config file name if different from default"
        | optional,
      HTML_HTMLHINT_DISABLE_ERRORS | Bool | optional,
      HTML_HTMLHINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      HTML_HTMLHINT_FILE_EXTENSIONS | Array (String) | optional,
      HTML_HTMLHINT_FILE_NAME
        | String
        | doc "HTML_HTMLHINT: User custom config file name if different from default"
        | optional,
      HTML_HTMLHINT_FILE_NAMES_REGEX | Array (String) | optional,
      HTML_HTMLHINT_FILTER_REGEX_EXCLUDE | String | optional,
      HTML_HTMLHINT_FILTER_REGEX_INCLUDE | String | optional,
      HTML_HTMLHINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      HTML_HTMLHINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      HTML_HTMLHINT_RULES_PATH
        | String
        | doc "HTML_HTMLHINT: Path where to find linter configuration file"
        | optional,
      HTML_HTMLHINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling HTML_HTMLHINT and its pre/post commands"
        | optional,
      HTML_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      HTML_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      IGNORE_GENERATED_FILES | Bool | optional,
      IGNORE_GITIGNORED_FILES | Bool | optional,
      JAVASCRIPT_DEFAULT_STYLE
        | std.enum.TagOrString
        | [| 'prettier, 'standard |]
        | doc "Style of javascript formatting to apply"
        | optional,
      JAVASCRIPT_ES_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVASCRIPT_ES: User custom arguments to add in linter CLI call"
        | optional,
      JAVASCRIPT_ES_CLI_EXECUTABLE | Array (String) | optional,
      JAVASCRIPT_ES_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JAVASCRIPT_ES_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVASCRIPT_ES: User custom arguments to remove before calling linter"
        | optional,
      JAVASCRIPT_ES_CONFIG_FILE
        | String
        | doc "JAVASCRIPT_ES: User custom config file name if different from default"
        | optional,
      JAVASCRIPT_ES_DISABLE_ERRORS | Bool | optional,
      JAVASCRIPT_ES_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JAVASCRIPT_ES_FILE_EXTENSIONS | Array (String) | optional,
      JAVASCRIPT_ES_FILE_NAME
        | String
        | doc "JAVASCRIPT_ES: User custom config file name if different from default"
        | optional,
      JAVASCRIPT_ES_FILE_NAMES_REGEX | Array (String) | optional,
      JAVASCRIPT_ES_FILTER_REGEX_EXCLUDE | String | optional,
      JAVASCRIPT_ES_FILTER_REGEX_INCLUDE | String | optional,
      JAVASCRIPT_ES_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_ES_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_ES_RULES_PATH
        | String
        | doc "JAVASCRIPT_ES: Path where to find linter configuration file"
        | optional,
      JAVASCRIPT_ES_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JAVASCRIPT_ES and its pre/post commands"
        | optional,
      JAVASCRIPT_FILTER_REGEX_EXCLUDE | String | optional,
      JAVASCRIPT_FILTER_REGEX_INCLUDE | String | optional,
      JAVASCRIPT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_PRETTIER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVASCRIPT_PRETTIER: User custom arguments to add in linter CLI call"
        | optional,
      JAVASCRIPT_PRETTIER_CLI_EXECUTABLE | Array (String) | optional,
      JAVASCRIPT_PRETTIER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JAVASCRIPT_PRETTIER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVASCRIPT_PRETTIER: User custom arguments to remove before calling linter"
        | optional,
      JAVASCRIPT_PRETTIER_CONFIG_FILE
        | String
        | doc "JAVASCRIPT_PRETTIER: User custom config file name if different from default"
        | optional,
      JAVASCRIPT_PRETTIER_DISABLE_ERRORS | Bool | optional,
      JAVASCRIPT_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JAVASCRIPT_PRETTIER_FILE_EXTENSIONS | Array (String) | optional,
      JAVASCRIPT_PRETTIER_FILE_NAMES_REGEX | Array (String) | optional,
      JAVASCRIPT_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
      JAVASCRIPT_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
      JAVASCRIPT_PRETTIER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_PRETTIER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_PRETTIER_RULES_PATH
        | String
        | doc "JAVASCRIPT_PRETTIER: Path where to find linter configuration file"
        | optional,
      JAVASCRIPT_PRETTIER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JAVASCRIPT_PRETTIER and its pre/post commands"
        | optional,
      JAVASCRIPT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_STANDARD_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVASCRIPT_STANDARD: User custom arguments to add in linter CLI call"
        | optional,
      JAVASCRIPT_STANDARD_CLI_EXECUTABLE | Array (String) | optional,
      JAVASCRIPT_STANDARD_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JAVASCRIPT_STANDARD_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVASCRIPT_STANDARD: User custom arguments to remove before calling linter"
        | optional,
      JAVASCRIPT_STANDARD_DISABLE_ERRORS | Bool | optional,
      JAVASCRIPT_STANDARD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JAVASCRIPT_STANDARD_FILE_EXTENSIONS | Array (String) | optional,
      JAVASCRIPT_STANDARD_FILE_NAMES_REGEX | Array (String) | optional,
      JAVASCRIPT_STANDARD_FILTER_REGEX_EXCLUDE | String | optional,
      JAVASCRIPT_STANDARD_FILTER_REGEX_INCLUDE | String | optional,
      JAVASCRIPT_STANDARD_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_STANDARD_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVASCRIPT_STANDARD_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JAVASCRIPT_STANDARD and its pre/post commands"
        | optional,
      JAVA_CHECKSTYLE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVA_CHECKSTYLE: User custom arguments to add in linter CLI call"
        | optional,
      JAVA_CHECKSTYLE_CLI_EXECUTABLE | Array (String) | optional,
      JAVA_CHECKSTYLE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JAVA_CHECKSTYLE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVA_CHECKSTYLE: User custom arguments to remove before calling linter"
        | optional,
      JAVA_CHECKSTYLE_CONFIG_FILE
        | String
        | doc "JAVA_CHECKSTYLE: User custom config file name if different from default"
        | optional,
      JAVA_CHECKSTYLE_DISABLE_ERRORS | Bool | optional,
      JAVA_CHECKSTYLE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JAVA_CHECKSTYLE_FILE_EXTENSIONS | Array (String) | optional,
      JAVA_CHECKSTYLE_FILE_NAME
        | String
        | doc "JAVA_CHECKSTYLE: User custom config file name if different from default"
        | optional,
      JAVA_CHECKSTYLE_FILE_NAMES_REGEX | Array (String) | optional,
      JAVA_CHECKSTYLE_FILTER_REGEX_EXCLUDE | String | optional,
      JAVA_CHECKSTYLE_FILTER_REGEX_INCLUDE | String | optional,
      JAVA_CHECKSTYLE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVA_CHECKSTYLE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVA_CHECKSTYLE_RULES_PATH
        | String
        | doc "JAVA_CHECKSTYLE: Path where to find linter configuration file"
        | optional,
      JAVA_CHECKSTYLE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JAVA_CHECKSTYLE and its pre/post commands"
        | optional,
      JAVA_FILTER_REGEX_EXCLUDE | String | optional,
      JAVA_FILTER_REGEX_INCLUDE | String | optional,
      JAVA_PMD_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVA_PMD: User custom arguments to add in linter CLI call"
        | optional,
      JAVA_PMD_CLI_EXECUTABLE | Array (String) | optional,
      JAVA_PMD_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JAVA_PMD_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JAVA_PMD: User custom arguments to remove before calling linter"
        | optional,
      JAVA_PMD_CONFIG_FILE
        | String
        | doc "JAVA_PMD: User custom config file name if different from default"
        | optional,
      JAVA_PMD_DISABLE_ERRORS | Bool | optional,
      JAVA_PMD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JAVA_PMD_FILE_EXTENSIONS | Array (String) | optional,
      JAVA_PMD_FILE_NAMES_REGEX | Array (String) | optional,
      JAVA_PMD_FILTER_REGEX_EXCLUDE | String | optional,
      JAVA_PMD_FILTER_REGEX_INCLUDE | String | optional,
      JAVA_PMD_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVA_PMD_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVA_PMD_RULES_PATH
        | String
        | doc "JAVA_PMD: Path where to find linter configuration file"
        | optional,
      JAVA_PMD_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JAVA_PMD and its pre/post commands"
        | optional,
      JAVA_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JAVA_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_ESLINT_PLUGIN_JSONC: User custom arguments to add in linter CLI call"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_CLI_EXECUTABLE | Array (String) | optional,
      JSON_ESLINT_PLUGIN_JSONC_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_ESLINT_PLUGIN_JSONC: User custom arguments to remove before calling linter"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_CONFIG_FILE
        | String
        | doc "JSON_ESLINT_PLUGIN_JSONC: User custom config file name if different from default"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_DISABLE_ERRORS | Bool | optional,
      JSON_ESLINT_PLUGIN_JSONC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JSON_ESLINT_PLUGIN_JSONC_FILE_EXTENSIONS | Array (String) | optional,
      JSON_ESLINT_PLUGIN_JSONC_FILE_NAME
        | String
        | doc "JSON_ESLINT_PLUGIN_JSONC: User custom config file name if different from default"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_FILE_NAMES_REGEX | Array (String) | optional,
      JSON_ESLINT_PLUGIN_JSONC_FILTER_REGEX_EXCLUDE | String | optional,
      JSON_ESLINT_PLUGIN_JSONC_FILTER_REGEX_INCLUDE | String | optional,
      JSON_ESLINT_PLUGIN_JSONC_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_RULES_PATH
        | String
        | doc "JSON_ESLINT_PLUGIN_JSONC: Path where to find linter configuration file"
        | optional,
      JSON_ESLINT_PLUGIN_JSONC_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JSON_ESLINT_PLUGIN_JSONC and its pre/post commands"
        | optional,
      JSON_FILTER_REGEX_EXCLUDE | String | optional,
      JSON_FILTER_REGEX_INCLUDE | String | optional,
      JSON_JSONLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_JSONLINT: User custom arguments to add in linter CLI call"
        | optional,
      JSON_JSONLINT_CLI_EXECUTABLE | Array (String) | optional,
      JSON_JSONLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JSON_JSONLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_JSONLINT: User custom arguments to remove before calling linter"
        | optional,
      JSON_JSONLINT_CONFIG_FILE
        | String
        | doc "JSON_JSONLINT: User custom config file name if different from default"
        | optional,
      JSON_JSONLINT_DISABLE_ERRORS | Bool | optional,
      JSON_JSONLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JSON_JSONLINT_FILE_EXTENSIONS | Array (String) | optional,
      JSON_JSONLINT_FILE_NAMES_REGEX | Array (String) | optional,
      JSON_JSONLINT_FILTER_REGEX_EXCLUDE | String | optional,
      JSON_JSONLINT_FILTER_REGEX_INCLUDE | String | optional,
      JSON_JSONLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_JSONLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_JSONLINT_RULES_PATH
        | String
        | doc "JSON_JSONLINT: Path where to find linter configuration file"
        | optional,
      JSON_JSONLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JSON_JSONLINT and its pre/post commands"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_NPM_PACKAGE_JSON_LINT: User custom arguments to add in linter CLI call"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_CLI_EXECUTABLE | Array (String) | optional,
      JSON_NPM_PACKAGE_JSON_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_NPM_PACKAGE_JSON_LINT: User custom arguments to remove before calling linter"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_CONFIG_FILE
        | String
        | doc "JSON_NPM_PACKAGE_JSON_LINT: User custom config file name if different from default"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_DISABLE_ERRORS | Bool | optional,
      JSON_NPM_PACKAGE_JSON_LINT_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_FILE_EXTENSIONS | Array (String) | optional,
      JSON_NPM_PACKAGE_JSON_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      JSON_NPM_PACKAGE_JSON_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_RULES_PATH
        | String
        | doc "JSON_NPM_PACKAGE_JSON_LINT: Path where to find linter configuration file"
        | optional,
      JSON_NPM_PACKAGE_JSON_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JSON_NPM_PACKAGE_JSON_LINT and its pre/post commands"
        | optional,
      JSON_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_PRETTIER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_PRETTIER: User custom arguments to add in linter CLI call"
        | optional,
      JSON_PRETTIER_CLI_EXECUTABLE | Array (String) | optional,
      JSON_PRETTIER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JSON_PRETTIER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_PRETTIER: User custom arguments to remove before calling linter"
        | optional,
      JSON_PRETTIER_CONFIG_FILE
        | String
        | doc "JSON_PRETTIER: User custom config file name if different from default"
        | optional,
      JSON_PRETTIER_DISABLE_ERRORS | Bool | optional,
      JSON_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JSON_PRETTIER_FILE_EXTENSIONS | Array (String) | optional,
      JSON_PRETTIER_FILE_NAMES_REGEX | Array (String) | optional,
      JSON_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
      JSON_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
      JSON_PRETTIER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_PRETTIER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_PRETTIER_RULES_PATH
        | String
        | doc "JSON_PRETTIER: Path where to find linter configuration file"
        | optional,
      JSON_PRETTIER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JSON_PRETTIER and its pre/post commands"
        | optional,
      JSON_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_REPORTER
        | Bool
        | doc "Output a large execution log in a JSON file named mega-linter-report.json"
        | optional,
      JSON_REPORTER_OUTPUT_DETAIL
        | std.enum.TagOrString
        | [| 'detailed, 'simple |]
        | doc "Defines if output contain only error files (simple) or all files (detailed)"
        | optional,
      JSON_V8R_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_V8R: User custom arguments to add in linter CLI call"
        | optional,
      JSON_V8R_CLI_EXECUTABLE | Array (String) | optional,
      JSON_V8R_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JSON_V8R_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSON_V8R: User custom arguments to remove before calling linter"
        | optional,
      JSON_V8R_DISABLE_ERRORS | Bool | optional,
      JSON_V8R_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JSON_V8R_FILE_EXTENSIONS | Array (String) | optional,
      JSON_V8R_FILE_NAMES_REGEX | Array (String) | optional,
      JSON_V8R_FILTER_REGEX_EXCLUDE | String | optional,
      JSON_V8R_FILTER_REGEX_INCLUDE | String | optional,
      JSON_V8R_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_V8R_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSON_V8R_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JSON_V8R and its pre/post commands"
        | optional,
      JSX_ESLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSX_ESLINT: User custom arguments to add in linter CLI call"
        | optional,
      JSX_ESLINT_CLI_EXECUTABLE | Array (String) | optional,
      JSX_ESLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      JSX_ESLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "JSX_ESLINT: User custom arguments to remove before calling linter"
        | optional,
      JSX_ESLINT_CONFIG_FILE
        | String
        | doc "JSX_ESLINT: User custom config file name if different from default"
        | optional,
      JSX_ESLINT_DISABLE_ERRORS | Bool | optional,
      JSX_ESLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      JSX_ESLINT_FILE_EXTENSIONS | Array (String) | optional,
      JSX_ESLINT_FILE_NAME
        | String
        | doc "JSX_ESLINT: User custom config file name if different from default"
        | optional,
      JSX_ESLINT_FILE_NAMES_REGEX | Array (String) | optional,
      JSX_ESLINT_FILTER_REGEX_EXCLUDE | String | optional,
      JSX_ESLINT_FILTER_REGEX_INCLUDE | String | optional,
      JSX_ESLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSX_ESLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSX_ESLINT_RULES_PATH
        | String
        | doc "JSX_ESLINT: Path where to find linter configuration file"
        | optional,
      JSX_ESLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling JSX_ESLINT and its pre/post commands"
        | optional,
      JSX_FILTER_REGEX_EXCLUDE | String | optional,
      JSX_FILTER_REGEX_INCLUDE | String | optional,
      JSX_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      JSX_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KOTLIN_DETEKT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KOTLIN_DETEKT: User custom arguments to add in linter CLI call"
        | optional,
      KOTLIN_DETEKT_CLI_EXECUTABLE | Array (String) | optional,
      KOTLIN_DETEKT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      KOTLIN_DETEKT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KOTLIN_DETEKT: User custom arguments to remove before calling linter"
        | optional,
      KOTLIN_DETEKT_DISABLE_ERRORS | Bool | optional,
      KOTLIN_DETEKT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      KOTLIN_DETEKT_FILE_EXTENSIONS | Array (String) | optional,
      KOTLIN_DETEKT_FILE_NAMES_REGEX | Array (String) | optional,
      KOTLIN_DETEKT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KOTLIN_DETEKT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KOTLIN_DETEKT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling KOTLIN_DETEKT and its pre/post commands"
        | optional,
      KOTLIN_FILTER_REGEX_EXCLUDE | String | optional,
      KOTLIN_FILTER_REGEX_INCLUDE | String | optional,
      KOTLIN_KTLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KOTLIN_KTLINT: User custom arguments to add in linter CLI call"
        | optional,
      KOTLIN_KTLINT_CLI_EXECUTABLE | Array (String) | optional,
      KOTLIN_KTLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      KOTLIN_KTLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KOTLIN_KTLINT: User custom arguments to remove before calling linter"
        | optional,
      KOTLIN_KTLINT_DISABLE_ERRORS | Bool | optional,
      KOTLIN_KTLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      KOTLIN_KTLINT_FILE_EXTENSIONS | Array (String) | optional,
      KOTLIN_KTLINT_FILE_NAMES_REGEX | Array (String) | optional,
      KOTLIN_KTLINT_FILTER_REGEX_EXCLUDE | String | optional,
      KOTLIN_KTLINT_FILTER_REGEX_INCLUDE | String | optional,
      KOTLIN_KTLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KOTLIN_KTLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KOTLIN_KTLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling KOTLIN_KTLINT and its pre/post commands"
        | optional,
      KOTLIN_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KOTLIN_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_DIRECTORY | String | optional,
      KUBERNETES_FILTER_REGEX_EXCLUDE | String | optional,
      KUBERNETES_FILTER_REGEX_INCLUDE | String | optional,
      KUBERNETES_HELM_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_HELM: User custom arguments to add in linter CLI call"
        | optional,
      KUBERNETES_HELM_CLI_EXECUTABLE | Array (String) | optional,
      KUBERNETES_HELM_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      KUBERNETES_HELM_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_HELM: User custom arguments to remove before calling linter"
        | optional,
      KUBERNETES_HELM_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      KUBERNETES_HELM_DISABLE_ERRORS | Bool | optional,
      KUBERNETES_HELM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      KUBERNETES_HELM_FILE_EXTENSIONS | Array (String) | optional,
      KUBERNETES_HELM_FILE_NAMES_REGEX | Array (String) | optional,
      KUBERNETES_HELM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_HELM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_HELM_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling KUBERNETES_HELM and its pre/post commands"
        | optional,
      KUBERNETES_KUBECONFORM_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_KUBECONFORM: User custom arguments to add in linter CLI call"
        | optional,
      KUBERNETES_KUBECONFORM_CLI_EXECUTABLE | Array (String) | optional,
      KUBERNETES_KUBECONFORM_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      KUBERNETES_KUBECONFORM_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_KUBECONFORM: User custom arguments to remove before calling linter"
        | optional,
      KUBERNETES_KUBECONFORM_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      KUBERNETES_KUBECONFORM_DISABLE_ERRORS | Bool | optional,
      KUBERNETES_KUBECONFORM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      KUBERNETES_KUBECONFORM_FILE_EXTENSIONS | Array (String) | optional,
      KUBERNETES_KUBECONFORM_FILE_NAMES_REGEX | Array (String) | optional,
      KUBERNETES_KUBECONFORM_FILTER_REGEX_EXCLUDE | String | optional,
      KUBERNETES_KUBECONFORM_FILTER_REGEX_INCLUDE | String | optional,
      KUBERNETES_KUBECONFORM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_KUBECONFORM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_KUBECONFORM_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling KUBERNETES_KUBECONFORM and its pre/post commands"
        | optional,
      KUBERNETES_KUBESCAPE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_KUBESCAPE: User custom arguments to add in linter CLI call"
        | optional,
      KUBERNETES_KUBESCAPE_CLI_EXECUTABLE | Array (String) | optional,
      KUBERNETES_KUBESCAPE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      KUBERNETES_KUBESCAPE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_KUBESCAPE: User custom arguments to remove before calling linter"
        | optional,
      KUBERNETES_KUBESCAPE_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      KUBERNETES_KUBESCAPE_DISABLE_ERRORS | Bool | optional,
      KUBERNETES_KUBESCAPE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      KUBERNETES_KUBESCAPE_FILE_EXTENSIONS | Array (String) | optional,
      KUBERNETES_KUBESCAPE_FILE_NAMES_REGEX | Array (String) | optional,
      KUBERNETES_KUBESCAPE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_KUBESCAPE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_KUBESCAPE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling KUBERNETES_KUBESCAPE and its pre/post commands"
        | optional,
      KUBERNETES_KUBEVAL_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "KUBERNETES_KUBEVAL: User custom arguments to add in linter CLI call"
        | optional,
      KUBERNETES_KUBEVAL_CLI_EXECUTABLE | Array (String) | optional,
      KUBERNETES_KUBEVAL_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      KUBERNETES_KUBEVAL_DIRECTORY | String | optional,
      KUBERNETES_KUBEVAL_DISABLE_ERRORS | Bool | optional,
      KUBERNETES_KUBEVAL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      KUBERNETES_KUBEVAL_FILE_EXTENSIONS | Array (String) | optional,
      KUBERNETES_KUBEVAL_FILE_NAMES_REGEX | Array (String) | optional,
      KUBERNETES_KUBEVAL_FILTER_REGEX_EXCLUDE | String | optional,
      KUBERNETES_KUBEVAL_FILTER_REGEX_INCLUDE | String | optional,
      KUBERNETES_KUBEVAL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_KUBEVAL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      KUBERNETES_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LATEX_CHKTEX_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "LATEX_CHKTEX: User custom arguments to add in linter CLI call"
        | optional,
      LATEX_CHKTEX_CLI_EXECUTABLE | Array (String) | optional,
      LATEX_CHKTEX_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      LATEX_CHKTEX_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "LATEX_CHKTEX: User custom arguments to remove before calling linter"
        | optional,
      LATEX_CHKTEX_CONFIG_FILE
        | String
        | doc "LATEX_CHKTEX: User custom config file name if different from default"
        | optional,
      LATEX_CHKTEX_DISABLE_ERRORS | Bool | optional,
      LATEX_CHKTEX_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      LATEX_CHKTEX_FILE_EXTENSIONS | Array (String) | optional,
      LATEX_CHKTEX_FILE_NAME
        | String
        | doc "LATEX_CHKTEX: User custom config file name if different from default"
        | optional,
      LATEX_CHKTEX_FILE_NAMES_REGEX | Array (String) | optional,
      LATEX_CHKTEX_FILTER_REGEX_EXCLUDE | String | optional,
      LATEX_CHKTEX_FILTER_REGEX_INCLUDE | String | optional,
      LATEX_CHKTEX_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LATEX_CHKTEX_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LATEX_CHKTEX_RULES_PATH
        | String
        | doc "LATEX_CHKTEX: Path where to find linter configuration file"
        | optional,
      LATEX_CHKTEX_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling LATEX_CHKTEX and its pre/post commands"
        | optional,
      LATEX_FILTER_REGEX_EXCLUDE | String | optional,
      LATEX_FILTER_REGEX_INCLUDE | String | optional,
      LATEX_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LATEX_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LINTER_RULES_PATH
        | String
        | doc "Directory for all linter configuration rules. Can be a local folder or a remote URL. Not necessary if your linters configuration files are at the root of your repository"
        | optional,
      LOG_FILE
        | String
        | doc "The file name for outputting logs. All output is sent to the log file regardless of LOG_LEVEL"
        | optional,
      LOG_LEVEL
        | std.enum.TagOrString
        | [| 'ERROR, 'WARNING, 'DEBUG, 'INFO |]
        | doc "How much output the script will generate to the console. One of INFO, DEBUG, WARNING or ERROR."
        | optional,
      LUA_FILTER_REGEX_EXCLUDE | String | optional,
      LUA_FILTER_REGEX_INCLUDE | String | optional,
      LUA_LUACHECK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "LUA_LUACHECK: User custom arguments to add in linter CLI call"
        | optional,
      LUA_LUACHECK_CLI_EXECUTABLE | Array (String) | optional,
      LUA_LUACHECK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      LUA_LUACHECK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "LUA_LUACHECK: User custom arguments to remove before calling linter"
        | optional,
      LUA_LUACHECK_CONFIG_FILE
        | String
        | doc "LUA_LUACHECK: User custom config file name if different from default"
        | optional,
      LUA_LUACHECK_DISABLE_ERRORS | Bool | optional,
      LUA_LUACHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      LUA_LUACHECK_FILE_EXTENSIONS | Array (String) | optional,
      LUA_LUACHECK_FILE_NAME
        | String
        | doc "LUA_LUACHECK: User custom config file name if different from default"
        | optional,
      LUA_LUACHECK_FILE_NAMES_REGEX | Array (String) | optional,
      LUA_LUACHECK_FILTER_REGEX_EXCLUDE | String | optional,
      LUA_LUACHECK_FILTER_REGEX_INCLUDE | String | optional,
      LUA_LUACHECK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LUA_LUACHECK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LUA_LUACHECK_RULES_PATH
        | String
        | doc "LUA_LUACHECK: Path where to find linter configuration file"
        | optional,
      LUA_LUACHECK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling LUA_LUACHECK and its pre/post commands"
        | optional,
      LUA_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      LUA_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MAKEFILE_CHECKMAKE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MAKEFILE_CHECKMAKE: User custom arguments to add in linter CLI call"
        | optional,
      MAKEFILE_CHECKMAKE_CLI_EXECUTABLE | Array (String) | optional,
      MAKEFILE_CHECKMAKE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      MAKEFILE_CHECKMAKE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MAKEFILE_CHECKMAKE: User custom arguments to remove before calling linter"
        | optional,
      MAKEFILE_CHECKMAKE_CONFIG_FILE
        | String
        | doc "MAKEFILE_CHECKMAKE: User custom config file name if different from default"
        | optional,
      MAKEFILE_CHECKMAKE_DISABLE_ERRORS | Bool | optional,
      MAKEFILE_CHECKMAKE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      MAKEFILE_CHECKMAKE_FILE_EXTENSIONS | Array (String) | optional,
      MAKEFILE_CHECKMAKE_FILE_NAMES_REGEX | Array (String) | optional,
      MAKEFILE_CHECKMAKE_FILTER_REGEX_EXCLUDE | String | optional,
      MAKEFILE_CHECKMAKE_FILTER_REGEX_INCLUDE | String | optional,
      MAKEFILE_CHECKMAKE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MAKEFILE_CHECKMAKE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MAKEFILE_CHECKMAKE_RULES_PATH
        | String
        | doc "MAKEFILE_CHECKMAKE: Path where to find linter configuration file"
        | optional,
      MAKEFILE_CHECKMAKE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling MAKEFILE_CHECKMAKE and its pre/post commands"
        | optional,
      MAKEFILE_FILTER_REGEX_EXCLUDE | String | optional,
      MAKEFILE_FILTER_REGEX_INCLUDE | String | optional,
      MAKEFILE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MAKEFILE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_DEFAULT_STYLE
        | std.enum.TagOrString
        | [| 'remark-lint, 'markdownlint |]
        | doc "Style of markdown formatting to apply"
        | optional,
      MARKDOWN_FILTER_REGEX_EXCLUDE | String | optional,
      MARKDOWN_FILTER_REGEX_INCLUDE | String | optional,
      MARKDOWN_MARKDOWNLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_MARKDOWNLINT: User custom arguments to add in linter CLI call"
        | optional,
      MARKDOWN_MARKDOWNLINT_CLI_EXECUTABLE | Array (String) | optional,
      MARKDOWN_MARKDOWNLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      MARKDOWN_MARKDOWNLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_MARKDOWNLINT: User custom arguments to remove before calling linter"
        | optional,
      MARKDOWN_MARKDOWNLINT_CONFIG_FILE
        | String
        | doc "MARKDOWN_MARKDOWNLINT: User custom config file name if different from default"
        | optional,
      MARKDOWN_MARKDOWNLINT_DISABLE_ERRORS | Bool | optional,
      MARKDOWN_MARKDOWNLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      MARKDOWN_MARKDOWNLINT_FILE_EXTENSIONS | Array (String) | optional,
      MARKDOWN_MARKDOWNLINT_FILE_NAME
        | String
        | doc "MARKDOWN_MARKDOWNLINT: User custom config file name if different from default"
        | optional,
      MARKDOWN_MARKDOWNLINT_FILE_NAMES_REGEX | Array (String) | optional,
      MARKDOWN_MARKDOWNLINT_FILTER_REGEX_EXCLUDE | String | optional,
      MARKDOWN_MARKDOWNLINT_FILTER_REGEX_INCLUDE | String | optional,
      MARKDOWN_MARKDOWNLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_MARKDOWNLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_MARKDOWNLINT_RULES_PATH
        | String
        | doc "MARKDOWN_MARKDOWNLINT: Path where to find linter configuration file"
        | optional,
      MARKDOWN_MARKDOWNLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling MARKDOWN_MARKDOWNLINT and its pre/post commands"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_MARKDOWN_LINK_CHECK: User custom arguments to add in linter CLI call"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_CLI_EXECUTABLE | Array (String) | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_MARKDOWN_LINK_CHECK: User custom arguments to remove before calling linter"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_CONFIG_FILE
        | String
        | doc "MARKDOWN_MARKDOWN_LINK_CHECK: User custom config file name if different from default"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_DISABLE_ERRORS | Bool | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_FILE_EXTENSIONS | Array (String) | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_FILE_NAME
        | String
        | doc "MARKDOWN_MARKDOWN_LINK_CHECK: User custom config file name if different from default"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_FILE_NAMES_REGEX | Array (String) | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_FILTER_REGEX_EXCLUDE | String | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_FILTER_REGEX_INCLUDE | String | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_RULES_PATH
        | String
        | doc "MARKDOWN_MARKDOWN_LINK_CHECK: Path where to find linter configuration file"
        | optional,
      MARKDOWN_MARKDOWN_LINK_CHECK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling MARKDOWN_MARKDOWN_LINK_CHECK and its pre/post commands"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_MARKDOWN_TABLE_FORMATTER: User custom arguments to add in linter CLI call"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_CLI_EXECUTABLE
        | Array (String)
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_MARKDOWN_TABLE_FORMATTER: User custom arguments to remove before calling linter"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_DISABLE_ERRORS | Bool | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILE_EXTENSIONS
        | Array (String)
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILE_NAMES_REGEX
        | Array (String)
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILTER_REGEX_EXCLUDE
        | String
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_FILTER_REGEX_INCLUDE
        | String
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_FORMATTER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling MARKDOWN_MARKDOWN_TABLE_FORMATTER and its pre/post commands"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_PRETTIFY_ARGUMENTS
        | Array (String)
        | doc "MARKDOWN_MARKDOWN_TABLE_PRETTIFY: User custom arguments to add in linter CLI call"
        | optional,
      MARKDOWN_MARKDOWN_TABLE_PRETTIFY_DISABLE_ERRORS | Bool | optional,
      MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILE_EXTENSIONS
        | Array (String)
        | optional,
      MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILE_NAMES_REGEX
        | Array (String)
        | optional,
      MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILTER_REGEX_EXCLUDE | String | optional,
      MARKDOWN_MARKDOWN_TABLE_PRETTIFY_FILTER_REGEX_INCLUDE | String | optional,
      MARKDOWN_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_REMARK_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_REMARK_LINT: User custom arguments to add in linter CLI call"
        | optional,
      MARKDOWN_REMARK_LINT_CLI_EXECUTABLE | Array (String) | optional,
      MARKDOWN_REMARK_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      MARKDOWN_REMARK_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "MARKDOWN_REMARK_LINT: User custom arguments to remove before calling linter"
        | optional,
      MARKDOWN_REMARK_LINT_CONFIG_FILE
        | String
        | doc "MARKDOWN_REMARK_LINT: User custom config file name if different from default"
        | optional,
      MARKDOWN_REMARK_LINT_DISABLE_ERRORS | Bool | optional,
      MARKDOWN_REMARK_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      MARKDOWN_REMARK_LINT_FILE_EXTENSIONS | Array (String) | optional,
      MARKDOWN_REMARK_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      MARKDOWN_REMARK_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      MARKDOWN_REMARK_LINT_FILTER_REGEX_INCLUDE | String | optional,
      MARKDOWN_REMARK_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_REMARK_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      MARKDOWN_REMARK_LINT_RULES_PATH
        | String
        | doc "MARKDOWN_REMARK_LINT: Path where to find linter configuration file"
        | optional,
      MARKDOWN_REMARK_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling MARKDOWN_REMARK_LINT and its pre/post commands"
        | optional,
      MARKDOWN_SUMMARY_REPORTER
        | Bool
        | doc "Generate SUMMARY reports that can be used to display issues directly in PR comment"
        | optional,
      MARKDOWN_SUMMARY_REPORTER_FILE_NAME
        | String
        | doc "Override SUMMARY output file name"
        | optional,
      MEGALINTER_FILES_TO_LINT
        | Array (String)
        | doc "Comma-separated list of files to analyze. Using this variable will bypass other file listing methods"
        | optional,
      MULTI_STATUS
        | Bool
        | doc "(DEPRECATED, use GITHUB_STATUS_REPORTER) Posts a status on the pull request for each processed linter"
        | optional,
      OPENAPI_FILTER_REGEX_EXCLUDE | String | optional,
      OPENAPI_FILTER_REGEX_INCLUDE | String | optional,
      OPENAPI_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      OPENAPI_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      OPENAPI_SPECTRAL_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "OPENAPI_SPECTRAL: User custom arguments to add in linter CLI call"
        | optional,
      OPENAPI_SPECTRAL_CLI_EXECUTABLE | Array (String) | optional,
      OPENAPI_SPECTRAL_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      OPENAPI_SPECTRAL_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "OPENAPI_SPECTRAL: User custom arguments to remove before calling linter"
        | optional,
      OPENAPI_SPECTRAL_CONFIG_FILE
        | String
        | doc "OPENAPI_SPECTRAL: User custom config file name if different from default"
        | optional,
      OPENAPI_SPECTRAL_DISABLE_ERRORS | Bool | optional,
      OPENAPI_SPECTRAL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      OPENAPI_SPECTRAL_FILE_EXTENSIONS | Array (String) | optional,
      OPENAPI_SPECTRAL_FILE_NAME
        | String
        | doc "OPENAPI_SPECTRAL: User custom config file name if different from default"
        | optional,
      OPENAPI_SPECTRAL_FILE_NAMES_REGEX | Array (String) | optional,
      OPENAPI_SPECTRAL_FILTER_REGEX_EXCLUDE | String | optional,
      OPENAPI_SPECTRAL_FILTER_REGEX_INCLUDE | String | optional,
      OPENAPI_SPECTRAL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      OPENAPI_SPECTRAL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      OPENAPI_SPECTRAL_RULES_PATH
        | String
        | doc "OPENAPI_SPECTRAL: Path where to find linter configuration file"
        | optional,
      OPENAPI_SPECTRAL_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling OPENAPI_SPECTRAL and its pre/post commands"
        | optional,
      OUTPUT_DETAIL
        | std.enum.TagOrString
        | [| 'detailed, 'simple |]
        | doc "(DEPRECATED) Output detail for text reporter: only error files (simple) or all files (detailed)"
        | optional,
      OUTPUT_FORMAT
        | std.enum.TagOrString
        | [| 'tap, 'text |]
        | doc "(DEPRECATED) Output format: text or tap"
        | optional,
      PARALLEL
        | Bool
        | doc "Process linters in parallel to improve overall MegaLinter performance. If true, linters of same language or formats are grouped in the same parallel process to avoid lock issues if fixing the same files"
        | optional,
      PARALLEL_PROCESS_NUMBER
        | Number
        | doc "All available cores are used by default. If there are too many, you need to decrease the number of used cores in order to enhance performances"
        | optional,
      PERL_FILTER_REGEX_EXCLUDE | String | optional,
      PERL_FILTER_REGEX_INCLUDE | String | optional,
      PERL_PERLCRITIC_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PERL_PERLCRITIC: User custom arguments to add in linter CLI call"
        | optional,
      PERL_PERLCRITIC_CLI_EXECUTABLE | Array (String) | optional,
      PERL_PERLCRITIC_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      PERL_PERLCRITIC_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PERL_PERLCRITIC: User custom arguments to remove before calling linter"
        | optional,
      PERL_PERLCRITIC_DISABLE_ERRORS | Bool | optional,
      PERL_PERLCRITIC_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PERL_PERLCRITIC_FILE_EXTENSIONS | Array (String) | optional,
      PERL_PERLCRITIC_FILE_NAMES_REGEX | Array (String) | optional,
      PERL_PERLCRITIC_FILTER_REGEX_EXCLUDE | String | optional,
      PERL_PERLCRITIC_FILTER_REGEX_INCLUDE | String | optional,
      PERL_PERLCRITIC_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PERL_PERLCRITIC_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PERL_PERLCRITIC_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PERL_PERLCRITIC and its pre/post commands"
        | optional,
      PERL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PERL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_BUILTIN_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_BUILTIN: User custom arguments to add in linter CLI call"
        | optional,
      PHP_BUILTIN_CLI_EXECUTABLE | String | optional,
      PHP_BUILTIN_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PHP_BUILTIN_DISABLE_ERRORS | Bool | optional,
      PHP_BUILTIN_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PHP_BUILTIN_FILE_EXTENSIONS | Array (String) | optional,
      PHP_BUILTIN_FILE_NAMES_REGEX | Array (String) | optional,
      PHP_BUILTIN_FILTER_REGEX_EXCLUDE | String | optional,
      PHP_BUILTIN_FILTER_REGEX_INCLUDE | String | optional,
      PHP_BUILTIN_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_BUILTIN_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_FILTER_REGEX_EXCLUDE | String | optional,
      PHP_FILTER_REGEX_INCLUDE | String | optional,
      PHP_PHPCSFIXER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPCSFIXER: User custom arguments to add in linter CLI call"
        | optional,
      PHP_PHPCSFIXER_CLI_EXECUTABLE | Array (String) | optional,
      PHP_PHPCSFIXER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PHP_PHPCSFIXER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPCSFIXER: User custom arguments to remove before calling linter"
        | optional,
      PHP_PHPCSFIXER_CONFIG_FILE
        | String
        | doc "PHP_PHPCSFIXER: User custom config file name if different from default"
        | optional,
      PHP_PHPCSFIXER_DISABLE_ERRORS | Bool | optional,
      PHP_PHPCSFIXER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PHP_PHPCSFIXER_FILE_EXTENSIONS | Array (String) | optional,
      PHP_PHPCSFIXER_FILE_NAMES_REGEX | Array (String) | optional,
      PHP_PHPCSFIXER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPCSFIXER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPCSFIXER_RULES_PATH
        | String
        | doc "PHP_PHPCSFIXER: Path where to find linter configuration file"
        | optional,
      PHP_PHPCSFIXER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PHP_PHPCSFIXER and its pre/post commands"
        | optional,
      PHP_PHPCS_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPCS: User custom arguments to add in linter CLI call"
        | optional,
      PHP_PHPCS_CLI_EXECUTABLE | Array (String) | optional,
      PHP_PHPCS_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PHP_PHPCS_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPCS: User custom arguments to remove before calling linter"
        | optional,
      PHP_PHPCS_CONFIG_FILE
        | String
        | doc "PHP_PHPCS: User custom config file name if different from default"
        | optional,
      PHP_PHPCS_DISABLE_ERRORS | Bool | optional,
      PHP_PHPCS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PHP_PHPCS_FILE_EXTENSIONS | Array (String) | optional,
      PHP_PHPCS_FILE_NAME
        | String
        | doc "PHP_PHPCS: User custom config file name if different from default"
        | optional,
      PHP_PHPCS_FILE_NAMES_REGEX | Array (String) | optional,
      PHP_PHPCS_FILTER_REGEX_EXCLUDE | String | optional,
      PHP_PHPCS_FILTER_REGEX_INCLUDE | String | optional,
      PHP_PHPCS_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPCS_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPCS_RULES_PATH
        | String
        | doc "PHP_PHPCS: Path where to find linter configuration file"
        | optional,
      PHP_PHPCS_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PHP_PHPCS and its pre/post commands"
        | optional,
      PHP_PHPLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPLINT: User custom arguments to add in linter CLI call"
        | optional,
      PHP_PHPLINT_CLI_EXECUTABLE | Array (String) | optional,
      PHP_PHPLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PHP_PHPLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPLINT: User custom arguments to remove before calling linter"
        | optional,
      PHP_PHPLINT_CONFIG_FILE
        | String
        | doc "PHP_PHPLINT: User custom config file name if different from default"
        | optional,
      PHP_PHPLINT_DISABLE_ERRORS | Bool | optional,
      PHP_PHPLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PHP_PHPLINT_FILE_EXTENSIONS | Array (String) | optional,
      PHP_PHPLINT_FILE_NAME
        | String
        | doc "PHP_PHPLINT: User custom config file name if different from default"
        | optional,
      PHP_PHPLINT_FILE_NAMES_REGEX | Array (String) | optional,
      PHP_PHPLINT_FILTER_REGEX_EXCLUDE | String | optional,
      PHP_PHPLINT_FILTER_REGEX_INCLUDE | String | optional,
      PHP_PHPLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPLINT_RULES_PATH
        | String
        | doc "PHP_PHPLINT: Path where to find linter configuration file"
        | optional,
      PHP_PHPLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PHP_PHPLINT and its pre/post commands"
        | optional,
      PHP_PHPSTAN_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPSTAN: User custom arguments to add in linter CLI call"
        | optional,
      PHP_PHPSTAN_CLI_EXECUTABLE | Array (String) | optional,
      PHP_PHPSTAN_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PHP_PHPSTAN_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PHPSTAN: User custom arguments to remove before calling linter"
        | optional,
      PHP_PHPSTAN_CONFIG_FILE
        | String
        | doc "PHP_PHPSTAN: User custom config file name if different from default"
        | optional,
      PHP_PHPSTAN_DISABLE_ERRORS | Bool | optional,
      PHP_PHPSTAN_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PHP_PHPSTAN_FILE_EXTENSIONS | Array (String) | optional,
      PHP_PHPSTAN_FILE_NAME
        | String
        | doc "PHP_PHPSTAN: User custom config file name if different from default"
        | optional,
      PHP_PHPSTAN_FILE_NAMES_REGEX | Array (String) | optional,
      PHP_PHPSTAN_FILTER_REGEX_EXCLUDE | String | optional,
      PHP_PHPSTAN_FILTER_REGEX_INCLUDE | String | optional,
      PHP_PHPSTAN_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPSTAN_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PHPSTAN_RULES_PATH
        | String
        | doc "PHP_PHPSTAN: Path where to find linter configuration file"
        | optional,
      PHP_PHPSTAN_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PHP_PHPSTAN and its pre/post commands"
        | optional,
      PHP_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PSALM_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PSALM: User custom arguments to add in linter CLI call"
        | optional,
      PHP_PSALM_CLI_EXECUTABLE | Array (String) | optional,
      PHP_PSALM_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PHP_PSALM_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PHP_PSALM: User custom arguments to remove before calling linter"
        | optional,
      PHP_PSALM_CONFIG_FILE
        | String
        | doc "PHP_PSALM: User custom config file name if different from default"
        | optional,
      PHP_PSALM_DISABLE_ERRORS | Bool | optional,
      PHP_PSALM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PHP_PSALM_FILE_EXTENSIONS | Array (String) | optional,
      PHP_PSALM_FILE_NAME
        | String
        | doc "PHP_PSALM: User custom config file name if different from default"
        | optional,
      PHP_PSALM_FILE_NAMES_REGEX | Array (String) | optional,
      PHP_PSALM_FILTER_REGEX_EXCLUDE | String | optional,
      PHP_PSALM_FILTER_REGEX_INCLUDE | String | optional,
      PHP_PSALM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PSALM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PHP_PSALM_RULES_PATH
        | String
        | doc "PHP_PSALM: Path where to find linter configuration file"
        | optional,
      PHP_PSALM_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PHP_PSALM and its pre/post commands"
        | optional,
      PLUGINS
        | Array (String)
        | doc "List of MegaLinter plugins. URL must follow format https://**/mega-linter-plugin-**/**.mega-linter-descriptor.yml"
        | optional,
      POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | doc "Custom bash commands to run after linters"
        | optional,
      POST_GITHUB_COMMENT
        | Bool
        | doc "(DEPRECATED, use GITHUB_COMMENT_REPORTER) Posts MegaLinter results summary in the comments of the related pull request (if existing)"
        | optional,
      POST_GITLAB_COMMENT
        | Bool
        | doc "(DEPRECATED, use GITHUB_COMMENT_REPORTER) Posts MegaLinter results summary in the comments of the related merge request (if existing)"
        | optional,
      POWERSHELL_FILTER_REGEX_EXCLUDE | String | optional,
      POWERSHELL_FILTER_REGEX_INCLUDE | String | optional,
      POWERSHELL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      POWERSHELL_POWERSHELL_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "POWERSHELL_POWERSHELL: User custom arguments to add in linter CLI call"
        | optional,
      POWERSHELL_POWERSHELL_CLI_EXECUTABLE | Array (String) | optional,
      POWERSHELL_POWERSHELL_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      POWERSHELL_POWERSHELL_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "POWERSHELL_POWERSHELL: User custom arguments to remove before calling linter"
        | optional,
      POWERSHELL_POWERSHELL_CONFIG_FILE
        | String
        | doc "POWERSHELL_POWERSHELL: User custom config file name if different from default"
        | optional,
      POWERSHELL_POWERSHELL_DISABLE_ERRORS | Bool | optional,
      POWERSHELL_POWERSHELL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      POWERSHELL_POWERSHELL_FILE_EXTENSIONS | Array (String) | optional,
      POWERSHELL_POWERSHELL_FILE_NAME
        | String
        | doc "POWERSHELL_POWERSHELL: User custom config file name if different from default"
        | optional,
      POWERSHELL_POWERSHELL_FILE_NAMES_REGEX | Array (String) | optional,
      POWERSHELL_POWERSHELL_FILTER_REGEX_EXCLUDE | String | optional,
      POWERSHELL_POWERSHELL_FILTER_REGEX_INCLUDE | String | optional,
      POWERSHELL_POWERSHELL_FORMATTER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "POWERSHELL_POWERSHELL_FORMATTER: User custom arguments to add in linter CLI call"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_CLI_EXECUTABLE
        | Array (String)
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "POWERSHELL_POWERSHELL_FORMATTER: User custom arguments to remove before calling linter"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_CONFIG_FILE
        | String
        | doc "POWERSHELL_POWERSHELL_FORMATTER: User custom config file name if different from default"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_DISABLE_ERRORS | Bool | optional,
      POWERSHELL_POWERSHELL_FORMATTER_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_FILE_EXTENSIONS
        | Array (String)
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_FILE_NAMES_REGEX
        | Array (String)
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_FILTER_REGEX_EXCLUDE | String | optional,
      POWERSHELL_POWERSHELL_FORMATTER_FILTER_REGEX_INCLUDE | String | optional,
      POWERSHELL_POWERSHELL_FORMATTER_OUTPUT_ENCODING
        | String
        | doc "POWERSHELL_POWERSHELL_FORMATTER: `-Encoding` to be used when writing content to the file"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_RULES_PATH
        | String
        | doc "POWERSHELL_POWERSHELL_FORMATTER: Path where to find linter configuration file"
        | optional,
      POWERSHELL_POWERSHELL_FORMATTER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling POWERSHELL_POWERSHELL_FORMATTER and its pre/post commands"
        | optional,
      POWERSHELL_POWERSHELL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      POWERSHELL_POWERSHELL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      POWERSHELL_POWERSHELL_RULES_PATH
        | String
        | doc "POWERSHELL_POWERSHELL: Path where to find linter configuration file"
        | optional,
      POWERSHELL_POWERSHELL_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling POWERSHELL_POWERSHELL and its pre/post commands"
        | optional,
      POWERSHELL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | doc "Custom bash commands to run before linters"
        | optional,
      PRINT_ALL_FILES
        | Bool
        | doc "If set to false, only fixed and error files are displayed in logs"
        | optional,
      PRINT_ALPACA
        | Bool
        | doc "Enable printing alpaca image to console output"
        | optional,
      PROTOBUF_FILTER_REGEX_EXCLUDE | String | optional,
      PROTOBUF_FILTER_REGEX_INCLUDE | String | optional,
      PROTOBUF_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PROTOBUF_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PROTOBUF_PROTOLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PROTOBUF_PROTOLINT: User custom arguments to add in linter CLI call"
        | optional,
      PROTOBUF_PROTOLINT_CLI_EXECUTABLE | Array (String) | optional,
      PROTOBUF_PROTOLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      PROTOBUF_PROTOLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PROTOBUF_PROTOLINT: User custom arguments to remove before calling linter"
        | optional,
      PROTOBUF_PROTOLINT_CONFIG_FILE
        | String
        | doc "PROTOBUF_PROTOLINT: User custom config file name if different from default"
        | optional,
      PROTOBUF_PROTOLINT_DISABLE_ERRORS | Bool | optional,
      PROTOBUF_PROTOLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PROTOBUF_PROTOLINT_FILE_EXTENSIONS | Array (String) | optional,
      PROTOBUF_PROTOLINT_FILE_NAME
        | String
        | doc "PROTOBUF_PROTOLINT: User custom config file name if different from default"
        | optional,
      PROTOBUF_PROTOLINT_FILE_NAMES_REGEX | Array (String) | optional,
      PROTOBUF_PROTOLINT_FILTER_REGEX_EXCLUDE | String | optional,
      PROTOBUF_PROTOLINT_FILTER_REGEX_INCLUDE | String | optional,
      PROTOBUF_PROTOLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PROTOBUF_PROTOLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PROTOBUF_PROTOLINT_RULES_PATH
        | String
        | doc "PROTOBUF_PROTOLINT: Path where to find linter configuration file"
        | optional,
      PROTOBUF_PROTOLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PROTOBUF_PROTOLINT and its pre/post commands"
        | optional,
      PUPPET_FILTER_REGEX_EXCLUDE | String | optional,
      PUPPET_FILTER_REGEX_INCLUDE | String | optional,
      PUPPET_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PUPPET_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PUPPET_PUPPET_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PUPPET_PUPPET_LINT: User custom arguments to add in linter CLI call"
        | optional,
      PUPPET_PUPPET_LINT_CLI_EXECUTABLE | Array (String) | optional,
      PUPPET_PUPPET_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      PUPPET_PUPPET_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PUPPET_PUPPET_LINT: User custom arguments to remove before calling linter"
        | optional,
      PUPPET_PUPPET_LINT_CONFIG_FILE
        | String
        | doc "PUPPET_PUPPET_LINT: User custom config file name if different from default"
        | optional,
      PUPPET_PUPPET_LINT_DISABLE_ERRORS | Bool | optional,
      PUPPET_PUPPET_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PUPPET_PUPPET_LINT_FILE_EXTENSIONS | Array (String) | optional,
      PUPPET_PUPPET_LINT_FILE_NAME
        | String
        | doc "PUPPET_PUPPET_LINT: User custom config file name if different from default"
        | optional,
      PUPPET_PUPPET_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      PUPPET_PUPPET_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      PUPPET_PUPPET_LINT_FILTER_REGEX_INCLUDE | String | optional,
      PUPPET_PUPPET_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PUPPET_PUPPET_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PUPPET_PUPPET_LINT_RULES_PATH
        | String
        | doc "PUPPET_PUPPET_LINT: Path where to find linter configuration file"
        | optional,
      PUPPET_PUPPET_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PUPPET_PUPPET_LINT and its pre/post commands"
        | optional,
      PYTHON_BANDIT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_BANDIT: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_BANDIT_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_BANDIT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_BANDIT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_BANDIT: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_BANDIT_CONFIG_FILE
        | String
        | doc "PYTHON_BANDIT: User custom config file name if different from default"
        | optional,
      PYTHON_BANDIT_DISABLE_ERRORS | Bool | optional,
      PYTHON_BANDIT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_BANDIT_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_BANDIT_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_BANDIT_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_BANDIT_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_BANDIT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_BANDIT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_BANDIT_RULES_PATH
        | String
        | doc "PYTHON_BANDIT: Path where to find linter configuration file"
        | optional,
      PYTHON_BANDIT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_BANDIT and its pre/post commands"
        | optional,
      PYTHON_BLACK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_BLACK: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_BLACK_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_BLACK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_BLACK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_BLACK: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_BLACK_CONFIG_FILE
        | String
        | doc "PYTHON_BLACK: User custom config file name if different from default"
        | optional,
      PYTHON_BLACK_DISABLE_ERRORS | Bool | optional,
      PYTHON_BLACK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_BLACK_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_BLACK_FILE_NAME
        | String
        | doc "PYTHON_BLACK: User custom config file name if different from default"
        | optional,
      PYTHON_BLACK_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_BLACK_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_BLACK_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_BLACK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_BLACK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_BLACK_RULES_PATH
        | String
        | doc "PYTHON_BLACK: Path where to find linter configuration file"
        | optional,
      PYTHON_BLACK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_BLACK and its pre/post commands"
        | optional,
      PYTHON_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_FLAKE8_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_FLAKE8: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_FLAKE8_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_FLAKE8_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_FLAKE8_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_FLAKE8: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_FLAKE8_CONFIG_FILE
        | String
        | doc "PYTHON_FLAKE8: User custom config file name if different from default"
        | optional,
      PYTHON_FLAKE8_DISABLE_ERRORS | Bool | optional,
      PYTHON_FLAKE8_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_FLAKE8_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_FLAKE8_FILE_NAME
        | String
        | doc "PYTHON_FLAKE8: User custom config file name if different from default"
        | optional,
      PYTHON_FLAKE8_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_FLAKE8_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_FLAKE8_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_FLAKE8_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_FLAKE8_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_FLAKE8_RULES_PATH
        | String
        | doc "PYTHON_FLAKE8: Path where to find linter configuration file"
        | optional,
      PYTHON_FLAKE8_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_FLAKE8 and its pre/post commands"
        | optional,
      PYTHON_ISORT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_ISORT: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_ISORT_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_ISORT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_ISORT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_ISORT: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_ISORT_CONFIG_FILE
        | String
        | doc "PYTHON_ISORT: User custom config file name if different from default"
        | optional,
      PYTHON_ISORT_DISABLE_ERRORS | Bool | optional,
      PYTHON_ISORT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_ISORT_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_ISORT_FILE_NAME
        | String
        | doc "PYTHON_ISORT: User custom config file name if different from default"
        | optional,
      PYTHON_ISORT_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_ISORT_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_ISORT_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_ISORT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_ISORT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_ISORT_RULES_PATH
        | String
        | doc "PYTHON_ISORT: Path where to find linter configuration file"
        | optional,
      PYTHON_ISORT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_ISORT and its pre/post commands"
        | optional,
      PYTHON_MYPY_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_MYPY: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_MYPY_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_MYPY_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_MYPY_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_MYPY: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_MYPY_CONFIG_FILE
        | String
        | doc "PYTHON_MYPY: User custom config file name if different from default"
        | optional,
      PYTHON_MYPY_DISABLE_ERRORS | Bool | optional,
      PYTHON_MYPY_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_MYPY_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_MYPY_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_MYPY_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_MYPY_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_MYPY_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_MYPY_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_MYPY_RULES_PATH
        | String
        | doc "PYTHON_MYPY: Path where to find linter configuration file"
        | optional,
      PYTHON_MYPY_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_MYPY and its pre/post commands"
        | optional,
      PYTHON_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_PYLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_PYLINT: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_PYLINT_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_PYLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_PYLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_PYLINT: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_PYLINT_CONFIG_FILE
        | String
        | doc "PYTHON_PYLINT: User custom config file name if different from default"
        | optional,
      PYTHON_PYLINT_DISABLE_ERRORS | Bool | optional,
      PYTHON_PYLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_PYLINT_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_PYLINT_FILE_NAME
        | String
        | doc "PYTHON_PYLINT: User custom config file name if different from default"
        | optional,
      PYTHON_PYLINT_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_PYLINT_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_PYLINT_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_PYLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_PYLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_PYLINT_RULES_PATH
        | String
        | doc "PYTHON_PYLINT: Path where to find linter configuration file"
        | optional,
      PYTHON_PYLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_PYLINT and its pre/post commands"
        | optional,
      PYTHON_PYRIGHT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_PYRIGHT: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_PYRIGHT_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_PYRIGHT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_PYRIGHT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_PYRIGHT: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_PYRIGHT_CONFIG_FILE
        | String
        | doc "PYTHON_PYRIGHT: User custom config file name if different from default"
        | optional,
      PYTHON_PYRIGHT_DISABLE_ERRORS | Bool | optional,
      PYTHON_PYRIGHT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_PYRIGHT_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_PYRIGHT_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_PYRIGHT_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_PYRIGHT_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_PYRIGHT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_PYRIGHT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_PYRIGHT_RULES_PATH
        | String
        | doc "PYTHON_PYRIGHT: Path where to find linter configuration file"
        | optional,
      PYTHON_PYRIGHT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_PYRIGHT and its pre/post commands"
        | optional,
      PYTHON_RUFF_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_RUFF: User custom arguments to add in linter CLI call"
        | optional,
      PYTHON_RUFF_CLI_EXECUTABLE | Array (String) | optional,
      PYTHON_RUFF_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      PYTHON_RUFF_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "PYTHON_RUFF: User custom arguments to remove before calling linter"
        | optional,
      PYTHON_RUFF_CONFIG_FILE
        | String
        | doc "PYTHON_RUFF: User custom config file name if different from default"
        | optional,
      PYTHON_RUFF_DISABLE_ERRORS | Bool | optional,
      PYTHON_RUFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      PYTHON_RUFF_FILE_EXTENSIONS | Array (String) | optional,
      PYTHON_RUFF_FILE_NAMES_REGEX | Array (String) | optional,
      PYTHON_RUFF_FILTER_REGEX_EXCLUDE | String | optional,
      PYTHON_RUFF_FILTER_REGEX_INCLUDE | String | optional,
      PYTHON_RUFF_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_RUFF_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      PYTHON_RUFF_RULES_PATH
        | String
        | doc "PYTHON_RUFF: Path where to find linter configuration file"
        | optional,
      PYTHON_RUFF_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling PYTHON_RUFF and its pre/post commands"
        | optional,
      RAKU_FILTER_REGEX_EXCLUDE | String | optional,
      RAKU_FILTER_REGEX_INCLUDE | String | optional,
      RAKU_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RAKU_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RAKU_RAKU_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RAKU_RAKU: User custom arguments to add in linter CLI call"
        | optional,
      RAKU_RAKU_CLI_EXECUTABLE | Array (String) | optional,
      RAKU_RAKU_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      RAKU_RAKU_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RAKU_RAKU: User custom arguments to remove before calling linter"
        | optional,
      RAKU_RAKU_CONFIG_FILE
        | String
        | doc "RAKU_RAKU: User custom config file name if different from default"
        | optional,
      RAKU_RAKU_DISABLE_ERRORS | Bool | optional,
      RAKU_RAKU_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      RAKU_RAKU_FILE_EXTENSIONS | Array (String) | optional,
      RAKU_RAKU_FILE_NAME
        | String
        | doc "RAKU_RAKU: User custom config file name if different from default"
        | optional,
      RAKU_RAKU_FILE_NAMES_REGEX | Array (String) | optional,
      RAKU_RAKU_FILTER_REGEX_EXCLUDE | String | optional,
      RAKU_RAKU_FILTER_REGEX_INCLUDE | String | optional,
      RAKU_RAKU_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RAKU_RAKU_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RAKU_RAKU_RULES_PATH
        | String
        | doc "RAKU_RAKU: Path where to find linter configuration file"
        | optional,
      RAKU_RAKU_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling RAKU_RAKU and its pre/post commands"
        | optional,
      REPORTERS_MARKDOWN_TYPE
        | std.enum.TagOrString
        | [| 'advanced, 'simple |]
        | doc "Define simple if you do not to have external images in PR/MR comments"
        | optional,
      REPORT_OUTPUT_FOLDER
        | String
        | doc "The location where the output reporting will be generated to"
        | optional,
      REPOSITORY_CHECKOV_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_CHECKOV: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_CHECKOV_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_CHECKOV_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_CHECKOV_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_CHECKOV: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_CHECKOV_CONFIG_FILE
        | String
        | doc "REPOSITORY_CHECKOV: User custom config file name if different from default"
        | optional,
      REPOSITORY_CHECKOV_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_CHECKOV_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_CHECKOV_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_CHECKOV_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_CHECKOV_RULES_PATH
        | String
        | doc "REPOSITORY_CHECKOV: Path where to find linter configuration file"
        | optional,
      REPOSITORY_CHECKOV_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_CHECKOV and its pre/post commands"
        | optional,
      REPOSITORY_DEVSKIM_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_DEVSKIM: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_DEVSKIM_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_DEVSKIM_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_DEVSKIM_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_DEVSKIM: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_DEVSKIM_CONFIG_FILE
        | String
        | doc "REPOSITORY_DEVSKIM: User custom config file name if different from default"
        | optional,
      REPOSITORY_DEVSKIM_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_DEVSKIM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_DEVSKIM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_DEVSKIM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_DEVSKIM_RULES_PATH
        | String
        | doc "REPOSITORY_DEVSKIM: Path where to find linter configuration file"
        | optional,
      REPOSITORY_DEVSKIM_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_DEVSKIM and its pre/post commands"
        | optional,
      REPOSITORY_DUSTILOCK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_DUSTILOCK: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_DUSTILOCK_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_DUSTILOCK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_DUSTILOCK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_DUSTILOCK: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_DUSTILOCK_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_DUSTILOCK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_DUSTILOCK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_DUSTILOCK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_DUSTILOCK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_DUSTILOCK and its pre/post commands"
        | optional,
      REPOSITORY_FILTER_REGEX_EXCLUDE | String | optional,
      REPOSITORY_FILTER_REGEX_INCLUDE | String | optional,
      REPOSITORY_GITLEAKS_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GITLEAKS: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_GITLEAKS_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_GITLEAKS_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_GITLEAKS_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GITLEAKS: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_GITLEAKS_CONFIG_FILE
        | String
        | doc "REPOSITORY_GITLEAKS: User custom config file name if different from default"
        | optional,
      REPOSITORY_GITLEAKS_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_GITLEAKS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_GITLEAKS_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GITLEAKS_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GITLEAKS_PR_COMMITS_SCAN | Bool | optional,
      REPOSITORY_GITLEAKS_PR_SOURCE_SHA | String | optional,
      REPOSITORY_GITLEAKS_PR_TARGET_SHA | String | optional,
      REPOSITORY_GITLEAKS_RULES_PATH
        | String
        | doc "REPOSITORY_GITLEAKS: Path where to find linter configuration file"
        | optional,
      REPOSITORY_GITLEAKS_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_GITLEAKS and its pre/post commands"
        | optional,
      REPOSITORY_GIT_DIFF_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GIT_DIFF: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_GIT_DIFF_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_GIT_DIFF_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_GIT_DIFF_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GIT_DIFF: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_GIT_DIFF_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_GIT_DIFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_GIT_DIFF_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GIT_DIFF_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GIT_DIFF_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_GIT_DIFF and its pre/post commands"
        | optional,
      REPOSITORY_GOODCHECK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GOODCHECK: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_GOODCHECK_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_GOODCHECK_CONFIG_FILE
        | String
        | doc "REPOSITORY_GOODCHECK: User custom config file name if different from default"
        | optional,
      REPOSITORY_GOODCHECK_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_GOODCHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_GOODCHECK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GOODCHECK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GOODCHECK_RULES_PATH
        | String
        | doc "REPOSITORY_GOODCHECK: Path where to find linter configuration file"
        | optional,
      REPOSITORY_GRYPE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GRYPE: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_GRYPE_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_GRYPE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_GRYPE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_GRYPE: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_GRYPE_CONFIG_FILE
        | String
        | doc "REPOSITORY_GRYPE: User custom config file name if different from default"
        | optional,
      REPOSITORY_GRYPE_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_GRYPE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_GRYPE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GRYPE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_GRYPE_RULES_PATH
        | String
        | doc "REPOSITORY_GRYPE: Path where to find linter configuration file"
        | optional,
      REPOSITORY_GRYPE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_GRYPE and its pre/post commands"
        | optional,
      REPOSITORY_KICS_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_KICS: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_KICS_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_KICS_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_KICS_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_KICS: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_KICS_CONFIG_FILE
        | String
        | doc "REPOSITORY_KICS: User custom config file name if different from default"
        | optional,
      REPOSITORY_KICS_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_KICS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_KICS_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_KICS_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_KICS_RULES_PATH
        | String
        | doc "REPOSITORY_KICS: Path where to find linter configuration file"
        | optional,
      REPOSITORY_KICS_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_KICS and its pre/post commands"
        | optional,
      REPOSITORY_LS_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_LS_LINT: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_LS_LINT_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_LS_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_LS_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_LS_LINT: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_LS_LINT_CONFIG_FILE
        | String
        | doc "REPOSITORY_LS_LINT: User custom config file name if different from default"
        | optional,
      REPOSITORY_LS_LINT_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_LS_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_LS_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_LS_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_LS_LINT_RULES_PATH
        | String
        | doc "REPOSITORY_LS_LINT: Path where to find linter configuration file"
        | optional,
      REPOSITORY_LS_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_LS_LINT and its pre/post commands"
        | optional,
      REPOSITORY_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SECRETLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SECRETLINT: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_SECRETLINT_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_SECRETLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_SECRETLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SECRETLINT: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_SECRETLINT_CONFIG_FILE
        | String
        | doc "REPOSITORY_SECRETLINT: User custom config file name if different from default"
        | optional,
      REPOSITORY_SECRETLINT_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_SECRETLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_SECRETLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SECRETLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SECRETLINT_RULES_PATH
        | String
        | doc "REPOSITORY_SECRETLINT: Path where to find linter configuration file"
        | optional,
      REPOSITORY_SECRETLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_SECRETLINT and its pre/post commands"
        | optional,
      REPOSITORY_SEMGREP_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SEMGREP: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_SEMGREP_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_SEMGREP_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_SEMGREP_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SEMGREP: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_SEMGREP_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_SEMGREP_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_SEMGREP_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SEMGREP_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SEMGREP_RULESETS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SEMGREP: Specify custom ruleset(s) for semgrep"
        | optional,
      REPOSITORY_SEMGREP_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_SEMGREP and its pre/post commands"
        | optional,
      REPOSITORY_SYFT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SYFT: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_SYFT_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_SYFT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_SYFT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_SYFT: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_SYFT_CONFIG_FILE
        | String
        | doc "REPOSITORY_SYFT: User custom config file name if different from default"
        | optional,
      REPOSITORY_SYFT_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_SYFT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_SYFT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SYFT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_SYFT_RULES_PATH
        | String
        | doc "REPOSITORY_SYFT: Path where to find linter configuration file"
        | optional,
      REPOSITORY_SYFT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_SYFT and its pre/post commands"
        | optional,
      REPOSITORY_TRIVY_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_TRIVY: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_TRIVY_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_TRIVY_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_TRIVY_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_TRIVY: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_TRIVY_CONFIG_FILE
        | String
        | doc "REPOSITORY_TRIVY: User custom config file name if different from default"
        | optional,
      REPOSITORY_TRIVY_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_TRIVY_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_TRIVY_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_TRIVY_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_TRIVY_RULES_PATH
        | String
        | doc "REPOSITORY_TRIVY: Path where to find linter configuration file"
        | optional,
      REPOSITORY_TRIVY_SBOM_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_TRIVY_SBOM: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_TRIVY_SBOM_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_TRIVY_SBOM_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_TRIVY_SBOM_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_TRIVY_SBOM: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_TRIVY_SBOM_CONFIG_FILE
        | String
        | doc "REPOSITORY_TRIVY_SBOM: User custom config file name if different from default"
        | optional,
      REPOSITORY_TRIVY_SBOM_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_TRIVY_SBOM_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_TRIVY_SBOM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_TRIVY_SBOM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_TRIVY_SBOM_RULES_PATH
        | String
        | doc "REPOSITORY_TRIVY_SBOM: Path where to find linter configuration file"
        | optional,
      REPOSITORY_TRIVY_SBOM_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_TRIVY_SBOM and its pre/post commands"
        | optional,
      REPOSITORY_TRIVY_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_TRIVY and its pre/post commands"
        | optional,
      REPOSITORY_TRUFFLEHOG_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_TRUFFLEHOG: User custom arguments to add in linter CLI call"
        | optional,
      REPOSITORY_TRUFFLEHOG_CLI_EXECUTABLE | Array (String) | optional,
      REPOSITORY_TRUFFLEHOG_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      REPOSITORY_TRUFFLEHOG_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "REPOSITORY_TRUFFLEHOG: User custom arguments to remove before calling linter"
        | optional,
      REPOSITORY_TRUFFLEHOG_CONFIG_FILE
        | String
        | doc "REPOSITORY_TRUFFLEHOG: User custom config file name if different from default"
        | optional,
      REPOSITORY_TRUFFLEHOG_DISABLE_ERRORS | Bool | optional,
      REPOSITORY_TRUFFLEHOG_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      REPOSITORY_TRUFFLEHOG_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_TRUFFLEHOG_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      REPOSITORY_TRUFFLEHOG_RULES_PATH
        | String
        | doc "REPOSITORY_TRUFFLEHOG: Path where to find linter configuration file"
        | optional,
      REPOSITORY_TRUFFLEHOG_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling REPOSITORY_TRUFFLEHOG and its pre/post commands"
        | optional,
      RST_FILTER_REGEX_EXCLUDE | String | optional,
      RST_FILTER_REGEX_INCLUDE | String | optional,
      RST_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RSTCHECK_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RST_RSTCHECK: User custom arguments to add in linter CLI call"
        | optional,
      RST_RSTCHECK_CLI_EXECUTABLE | Array (String) | optional,
      RST_RSTCHECK_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      RST_RSTCHECK_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RST_RSTCHECK: User custom arguments to remove before calling linter"
        | optional,
      RST_RSTCHECK_CONFIG_FILE
        | String
        | doc "RST_RSTCHECK: User custom config file name if different from default"
        | optional,
      RST_RSTCHECK_DISABLE_ERRORS | Bool | optional,
      RST_RSTCHECK_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      RST_RSTCHECK_FILE_EXTENSIONS | Array (String) | optional,
      RST_RSTCHECK_FILE_NAME
        | String
        | doc "RST_RSTCHECK: User custom config file name if different from default"
        | optional,
      RST_RSTCHECK_FILE_NAMES_REGEX | Array (String) | optional,
      RST_RSTCHECK_FILTER_REGEX_EXCLUDE | String | optional,
      RST_RSTCHECK_FILTER_REGEX_INCLUDE | String | optional,
      RST_RSTCHECK_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RSTCHECK_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RSTCHECK_RULES_PATH
        | String
        | doc "RST_RSTCHECK: Path where to find linter configuration file"
        | optional,
      RST_RSTCHECK_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling RST_RSTCHECK and its pre/post commands"
        | optional,
      RST_RSTFMT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RST_RSTFMT: User custom arguments to add in linter CLI call"
        | optional,
      RST_RSTFMT_CLI_EXECUTABLE | Array (String) | optional,
      RST_RSTFMT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      RST_RSTFMT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RST_RSTFMT: User custom arguments to remove before calling linter"
        | optional,
      RST_RSTFMT_DISABLE_ERRORS | Bool | optional,
      RST_RSTFMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      RST_RSTFMT_FILE_EXTENSIONS | Array (String) | optional,
      RST_RSTFMT_FILE_NAMES_REGEX | Array (String) | optional,
      RST_RSTFMT_FILTER_REGEX_EXCLUDE | String | optional,
      RST_RSTFMT_FILTER_REGEX_INCLUDE | String | optional,
      RST_RSTFMT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RSTFMT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RSTFMT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling RST_RSTFMT and its pre/post commands"
        | optional,
      RST_RST_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RST_RST_LINT: User custom arguments to add in linter CLI call"
        | optional,
      RST_RST_LINT_CLI_EXECUTABLE | Array (String) | optional,
      RST_RST_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      RST_RST_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RST_RST_LINT: User custom arguments to remove before calling linter"
        | optional,
      RST_RST_LINT_DISABLE_ERRORS | Bool | optional,
      RST_RST_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      RST_RST_LINT_FILE_EXTENSIONS | Array (String) | optional,
      RST_RST_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      RST_RST_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      RST_RST_LINT_FILTER_REGEX_INCLUDE | String | optional,
      RST_RST_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RST_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RST_RST_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling RST_RST_LINT and its pre/post commands"
        | optional,
      RUBY_FILTER_REGEX_EXCLUDE | String | optional,
      RUBY_FILTER_REGEX_INCLUDE | String | optional,
      RUBY_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUBY_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUBY_RUBOCOP_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RUBY_RUBOCOP: User custom arguments to add in linter CLI call"
        | optional,
      RUBY_RUBOCOP_CLI_EXECUTABLE | Array (String) | optional,
      RUBY_RUBOCOP_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      RUBY_RUBOCOP_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RUBY_RUBOCOP: User custom arguments to remove before calling linter"
        | optional,
      RUBY_RUBOCOP_CONFIG_FILE
        | String
        | doc "RUBY_RUBOCOP: User custom config file name if different from default"
        | optional,
      RUBY_RUBOCOP_DISABLE_ERRORS | Bool | optional,
      RUBY_RUBOCOP_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      RUBY_RUBOCOP_FILE_EXTENSIONS | Array (String) | optional,
      RUBY_RUBOCOP_FILE_NAME
        | String
        | doc "RUBY_RUBOCOP: User custom config file name if different from default"
        | optional,
      RUBY_RUBOCOP_FILE_NAMES_REGEX | Array (String) | optional,
      RUBY_RUBOCOP_FILTER_REGEX_EXCLUDE | String | optional,
      RUBY_RUBOCOP_FILTER_REGEX_INCLUDE | String | optional,
      RUBY_RUBOCOP_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUBY_RUBOCOP_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUBY_RUBOCOP_RULES_PATH
        | String
        | doc "RUBY_RUBOCOP: Path where to find linter configuration file"
        | optional,
      RUBY_RUBOCOP_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling RUBY_RUBOCOP and its pre/post commands"
        | optional,
      RUST_CLIPPY_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RUST_CLIPPY: User custom arguments to add in linter CLI call"
        | optional,
      RUST_CLIPPY_CLI_EXECUTABLE | Array (String) | optional,
      RUST_CLIPPY_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      RUST_CLIPPY_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "RUST_CLIPPY: User custom arguments to remove before calling linter"
        | optional,
      RUST_CLIPPY_CONFIG_FILE
        | String
        | doc "RUST_CLIPPY: User custom config file name if different from default"
        | optional,
      RUST_CLIPPY_DISABLE_ERRORS | Bool | optional,
      RUST_CLIPPY_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      RUST_CLIPPY_FILE_EXTENSIONS | Array (String) | optional,
      RUST_CLIPPY_FILE_NAME
        | String
        | doc "RUST_CLIPPY: User custom config file name if different from default"
        | optional,
      RUST_CLIPPY_FILE_NAMES_REGEX | Array (String) | optional,
      RUST_CLIPPY_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUST_CLIPPY_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUST_CLIPPY_RULES_PATH
        | String
        | doc "RUST_CLIPPY: Path where to find linter configuration file"
        | optional,
      RUST_CLIPPY_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling RUST_CLIPPY and its pre/post commands"
        | optional,
      RUST_FILTER_REGEX_EXCLUDE | String | optional,
      RUST_FILTER_REGEX_INCLUDE | String | optional,
      RUST_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      RUST_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      R_FILTER_REGEX_EXCLUDE | String | optional,
      R_FILTER_REGEX_INCLUDE | String | optional,
      R_LINTR_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "R_LINTR: User custom arguments to add in linter CLI call"
        | optional,
      R_LINTR_CLI_EXECUTABLE | Array (String) | optional,
      R_LINTR_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      R_LINTR_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "R_LINTR: User custom arguments to remove before calling linter"
        | optional,
      R_LINTR_CONFIG_FILE
        | String
        | doc "R_LINTR: User custom config file name if different from default"
        | optional,
      R_LINTR_DISABLE_ERRORS | Bool | optional,
      R_LINTR_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      R_LINTR_FILE_EXTENSIONS | Array (String) | optional,
      R_LINTR_FILE_NAME
        | String
        | doc "R_LINTR: User custom config file name if different from default"
        | optional,
      R_LINTR_FILE_NAMES_REGEX | Array (String) | optional,
      R_LINTR_FILTER_REGEX_EXCLUDE | String | optional,
      R_LINTR_FILTER_REGEX_INCLUDE | String | optional,
      R_LINTR_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      R_LINTR_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      R_LINTR_RULES_PATH
        | String
        | doc "R_LINTR: Path where to find linter configuration file"
        | optional,
      R_LINTR_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling R_LINTR and its pre/post commands"
        | optional,
      R_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      R_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_DIRECTORY | String | optional,
      SALESFORCE_FILTER_REGEX_EXCLUDE | String | optional,
      SALESFORCE_FILTER_REGEX_INCLUDE | String | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_LIGHTNING_FLOW_SCANNER: User custom arguments to add in linter CLI call"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_CLI_EXECUTABLE
        | Array (String)
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_LIGHTNING_FLOW_SCANNER: User custom arguments to remove before calling linter"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_CONFIG_FILE
        | String
        | doc "SALESFORCE_LIGHTNING_FLOW_SCANNER: User custom config file name if different from default"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_DISABLE_ERRORS | Bool | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_RULES_PATH
        | String
        | doc "SALESFORCE_LIGHTNING_FLOW_SCANNER: Path where to find linter configuration file"
        | optional,
      SALESFORCE_LIGHTNING_FLOW_SCANNER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SALESFORCE_LIGHTNING_FLOW_SCANNER and its pre/post commands"
        | optional,
      SALESFORCE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER_APEX: User custom arguments to add in linter CLI call"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_CLI_EXECUTABLE | Array (String) | optional,
      SALESFORCE_SFDX_SCANNER_APEX_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER_APEX: User custom arguments to remove before calling linter"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_CONFIG_FILE
        | String
        | doc "SALESFORCE_SFDX_SCANNER_APEX: User custom config file name if different from default"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_DISABLE_ERRORS | Bool | optional,
      SALESFORCE_SFDX_SCANNER_APEX_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_RULES_PATH
        | String
        | doc "SALESFORCE_SFDX_SCANNER_APEX: Path where to find linter configuration file"
        | optional,
      SALESFORCE_SFDX_SCANNER_APEX_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SALESFORCE_SFDX_SCANNER_APEX and its pre/post commands"
        | optional,
      SALESFORCE_SFDX_SCANNER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER: User custom arguments to add in linter CLI call"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER_AURA: User custom arguments to add in linter CLI call"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_CLI_EXECUTABLE | Array (String) | optional,
      SALESFORCE_SFDX_SCANNER_AURA_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER_AURA: User custom arguments to remove before calling linter"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_CONFIG_FILE
        | String
        | doc "SALESFORCE_SFDX_SCANNER_AURA: User custom config file name if different from default"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_DISABLE_ERRORS | Bool | optional,
      SALESFORCE_SFDX_SCANNER_AURA_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_RULES_PATH
        | String
        | doc "SALESFORCE_SFDX_SCANNER_AURA: Path where to find linter configuration file"
        | optional,
      SALESFORCE_SFDX_SCANNER_AURA_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SALESFORCE_SFDX_SCANNER_AURA and its pre/post commands"
        | optional,
      SALESFORCE_SFDX_SCANNER_DIRECTORY | String | optional,
      SALESFORCE_SFDX_SCANNER_DISABLE_ERRORS | Bool | optional,
      SALESFORCE_SFDX_SCANNER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SALESFORCE_SFDX_SCANNER_FILE_EXTENSIONS | Array (String) | optional,
      SALESFORCE_SFDX_SCANNER_FILE_NAMES_REGEX | Array (String) | optional,
      SALESFORCE_SFDX_SCANNER_FILTER_REGEX_EXCLUDE | String | optional,
      SALESFORCE_SFDX_SCANNER_FILTER_REGEX_INCLUDE | String | optional,
      SALESFORCE_SFDX_SCANNER_LWC_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER_LWC: User custom arguments to add in linter CLI call"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_CLI_EXECUTABLE | Array (String) | optional,
      SALESFORCE_SFDX_SCANNER_LWC_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SALESFORCE_SFDX_SCANNER_LWC: User custom arguments to remove before calling linter"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_CONFIG_FILE
        | String
        | doc "SALESFORCE_SFDX_SCANNER_LWC: User custom config file name if different from default"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_DIRECTORY
        | String
        | doc "Directory that must be found to activate linter. Use value \"any\" to always activate"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_DISABLE_ERRORS | Bool | optional,
      SALESFORCE_SFDX_SCANNER_LWC_DISABLE_ERRORS_IF_LESS_THAN
        | Number
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_RULES_PATH
        | String
        | doc "SALESFORCE_SFDX_SCANNER_LWC: Path where to find linter configuration file"
        | optional,
      SALESFORCE_SFDX_SCANNER_LWC_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SALESFORCE_SFDX_SCANNER_LWC and its pre/post commands"
        | optional,
      SARIF_REPORTER
        | Bool
        | doc "Generate SARIF reports that can be used to display issues directly in GitHub UI"
        | optional,
      SARIF_REPORTER_FILE_NAME
        | String
        | doc "Override SARIF output file name"
        | optional,
      SARIF_REPORTER_LINTERS
        | Array _js2n__-refsenv."_js2n__-:definitions/enum_linter_keys!contract"
        | doc "If SARIF_REPORTER_LINTERS is set, only the linters in the list will output SARIF"
        | optional,
      SCALA_FILTER_REGEX_EXCLUDE | String | optional,
      SCALA_FILTER_REGEX_INCLUDE | String | optional,
      SCALA_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SCALA_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SCALA_SCALAFIX_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SCALA_SCALAFIX: User custom arguments to add in linter CLI call"
        | optional,
      SCALA_SCALAFIX_CLI_EXECUTABLE | Array (String) | optional,
      SCALA_SCALAFIX_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      SCALA_SCALAFIX_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SCALA_SCALAFIX: User custom arguments to remove before calling linter"
        | optional,
      SCALA_SCALAFIX_CONFIG_FILE
        | String
        | doc "SCALA_SCALAFIX: User custom config file name if different from default"
        | optional,
      SCALA_SCALAFIX_DISABLE_ERRORS | Bool | optional,
      SCALA_SCALAFIX_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SCALA_SCALAFIX_FILE_EXTENSIONS | Array (String) | optional,
      SCALA_SCALAFIX_FILE_NAME
        | String
        | doc "SCALA_SCALAFIX: User custom config file name if different from default"
        | optional,
      SCALA_SCALAFIX_FILE_NAMES_REGEX | Array (String) | optional,
      SCALA_SCALAFIX_FILTER_REGEX_EXCLUDE | String | optional,
      SCALA_SCALAFIX_FILTER_REGEX_INCLUDE | String | optional,
      SCALA_SCALAFIX_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SCALA_SCALAFIX_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SCALA_SCALAFIX_RULES_PATH
        | String
        | doc "SCALA_SCALAFIX: Path where to find linter configuration file"
        | optional,
      SCALA_SCALAFIX_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SCALA_SCALAFIX and its pre/post commands"
        | optional,
      SECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of secured environment variables to hide when calling linters"
        | optional,
      SHOW_ELAPSED_TIME
        | Bool
        | doc "Displays elapsed time for each linter in reports"
        | optional,
      SHOW_SKIPPED_LINTERS
        | Bool
        | doc "Displays all linters that mega-linter could run but didn't"
        | optional,
      SKIP_CLI_LINT_MODES
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum [ "file", "list_of_files", "project" ])
        )
        | doc "Comma-separated list of cli_lint_modes. To use if you want to skip linters with some CLI lint modes (ex: \"file,project\"). Available values: file,cli_lint_mode,project"
        | optional,
      SNAKEMAKE_FILTER_REGEX_EXCLUDE | String | optional,
      SNAKEMAKE_FILTER_REGEX_INCLUDE | String | optional,
      SNAKEMAKE_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SNAKEMAKE_LINT: User custom arguments to add in linter CLI call"
        | optional,
      SNAKEMAKE_LINT_CLI_EXECUTABLE | Array (String) | optional,
      SNAKEMAKE_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      SNAKEMAKE_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SNAKEMAKE_LINT: User custom arguments to remove before calling linter"
        | optional,
      SNAKEMAKE_LINT_DISABLE_ERRORS | Bool | optional,
      SNAKEMAKE_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SNAKEMAKE_LINT_FILE_EXTENSIONS | Array (String) | optional,
      SNAKEMAKE_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      SNAKEMAKE_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      SNAKEMAKE_LINT_FILTER_REGEX_INCLUDE | String | optional,
      SNAKEMAKE_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SNAKEMAKE_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SNAKEMAKE_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SNAKEMAKE_LINT and its pre/post commands"
        | optional,
      SNAKEMAKE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SNAKEMAKE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SNAKEMAKE_SNAKEFMT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SNAKEMAKE_SNAKEFMT: User custom arguments to add in linter CLI call"
        | optional,
      SNAKEMAKE_SNAKEFMT_CLI_EXECUTABLE | Array (String) | optional,
      SNAKEMAKE_SNAKEFMT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      SNAKEMAKE_SNAKEFMT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SNAKEMAKE_SNAKEFMT: User custom arguments to remove before calling linter"
        | optional,
      SNAKEMAKE_SNAKEFMT_CONFIG_FILE
        | String
        | doc "SNAKEMAKE_SNAKEFMT: User custom config file name if different from default"
        | optional,
      SNAKEMAKE_SNAKEFMT_DISABLE_ERRORS | Bool | optional,
      SNAKEMAKE_SNAKEFMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SNAKEMAKE_SNAKEFMT_FILE_EXTENSIONS | Array (String) | optional,
      SNAKEMAKE_SNAKEFMT_FILE_NAME
        | String
        | doc "SNAKEMAKE_SNAKEFMT: User custom config file name if different from default"
        | optional,
      SNAKEMAKE_SNAKEFMT_FILE_NAMES_REGEX | Array (String) | optional,
      SNAKEMAKE_SNAKEFMT_FILTER_REGEX_EXCLUDE | String | optional,
      SNAKEMAKE_SNAKEFMT_FILTER_REGEX_INCLUDE | String | optional,
      SNAKEMAKE_SNAKEFMT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SNAKEMAKE_SNAKEFMT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SNAKEMAKE_SNAKEFMT_RULES_PATH
        | String
        | doc "SNAKEMAKE_SNAKEFMT: Path where to find linter configuration file"
        | optional,
      SNAKEMAKE_SNAKEFMT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SNAKEMAKE_SNAKEFMT and its pre/post commands"
        | optional,
      SPELL_CSPELL_ANALYZE_FILE_NAMES
        | Bool
        | doc "If set to true, MegaLinter will also send file names to cspell for analysis."
        | optional,
      SPELL_CSPELL_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_CSPELL: User custom arguments to add in linter CLI call"
        | optional,
      SPELL_CSPELL_CLI_EXECUTABLE | Array (String) | optional,
      SPELL_CSPELL_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SPELL_CSPELL_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_CSPELL: User custom arguments to remove before calling linter"
        | optional,
      SPELL_CSPELL_CONFIG_FILE
        | String
        | doc "SPELL_CSPELL: User custom config file name if different from default"
        | optional,
      SPELL_CSPELL_DISABLE_ERRORS | Bool | optional,
      SPELL_CSPELL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SPELL_CSPELL_FILE_EXTENSIONS | Array (String) | optional,
      SPELL_CSPELL_FILE_NAME
        | String
        | doc "SPELL_CSPELL: User custom config file name if different from default"
        | optional,
      SPELL_CSPELL_FILE_NAMES_REGEX | Array (String) | optional,
      SPELL_CSPELL_FILTER_REGEX_EXCLUDE | String | optional,
      SPELL_CSPELL_FILTER_REGEX_INCLUDE | String | optional,
      SPELL_CSPELL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_CSPELL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_CSPELL_RULES_PATH
        | String
        | doc "SPELL_CSPELL: Path where to find linter configuration file"
        | optional,
      SPELL_CSPELL_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SPELL_CSPELL and its pre/post commands"
        | optional,
      SPELL_FILTER_REGEX_EXCLUDE | String | optional,
      SPELL_FILTER_REGEX_INCLUDE | String | optional,
      SPELL_LYCHEE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_LYCHEE: User custom arguments to add in linter CLI call"
        | optional,
      SPELL_LYCHEE_CLI_EXECUTABLE | Array (String) | optional,
      SPELL_LYCHEE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SPELL_LYCHEE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_LYCHEE: User custom arguments to remove before calling linter"
        | optional,
      SPELL_LYCHEE_CONFIG_FILE
        | String
        | doc "SPELL_LYCHEE: User custom config file name if different from default"
        | optional,
      SPELL_LYCHEE_DISABLE_ERRORS | Bool | optional,
      SPELL_LYCHEE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SPELL_LYCHEE_FILE_EXTENSIONS | Array (String) | optional,
      SPELL_LYCHEE_FILE_NAMES_REGEX | Array (String) | optional,
      SPELL_LYCHEE_FILTER_REGEX_EXCLUDE | String | optional,
      SPELL_LYCHEE_FILTER_REGEX_INCLUDE | String | optional,
      SPELL_LYCHEE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_LYCHEE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_LYCHEE_RULES_PATH
        | String
        | doc "SPELL_LYCHEE: Path where to find linter configuration file"
        | optional,
      SPELL_LYCHEE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SPELL_LYCHEE and its pre/post commands"
        | optional,
      SPELL_MISSPELL_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_MISSPELL: User custom arguments to add in linter CLI call"
        | optional,
      SPELL_MISSPELL_CLI_EXECUTABLE | Array (String) | optional,
      SPELL_MISSPELL_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SPELL_MISSPELL_DISABLE_ERRORS | Bool | optional,
      SPELL_MISSPELL_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SPELL_MISSPELL_FILE_EXTENSIONS | Array (String) | optional,
      SPELL_MISSPELL_FILE_NAMES_REGEX | Array (String) | optional,
      SPELL_MISSPELL_FILTER_REGEX_EXCLUDE | String | optional,
      SPELL_MISSPELL_FILTER_REGEX_INCLUDE | String | optional,
      SPELL_MISSPELL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_MISSPELL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_PROSELINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_PROSELINT: User custom arguments to add in linter CLI call"
        | optional,
      SPELL_PROSELINT_CLI_EXECUTABLE | Array (String) | optional,
      SPELL_PROSELINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SPELL_PROSELINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_PROSELINT: User custom arguments to remove before calling linter"
        | optional,
      SPELL_PROSELINT_CONFIG_FILE
        | String
        | doc "SPELL_PROSELINT: User custom config file name if different from default"
        | optional,
      SPELL_PROSELINT_DISABLE_ERRORS | Bool | optional,
      SPELL_PROSELINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SPELL_PROSELINT_FILE_EXTENSIONS | Array (String) | optional,
      SPELL_PROSELINT_FILE_NAMES_REGEX | Array (String) | optional,
      SPELL_PROSELINT_FILTER_REGEX_EXCLUDE | String | optional,
      SPELL_PROSELINT_FILTER_REGEX_INCLUDE | String | optional,
      SPELL_PROSELINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_PROSELINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_PROSELINT_RULES_PATH
        | String
        | doc "SPELL_PROSELINT: Path where to find linter configuration file"
        | optional,
      SPELL_PROSELINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SPELL_PROSELINT and its pre/post commands"
        | optional,
      SPELL_VALE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_VALE: User custom arguments to add in linter CLI call"
        | optional,
      SPELL_VALE_CLI_EXECUTABLE | Array (String) | optional,
      SPELL_VALE_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SPELL_VALE_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SPELL_VALE: User custom arguments to remove before calling linter"
        | optional,
      SPELL_VALE_CONFIG_FILE
        | String
        | doc "SPELL_VALE: User custom config file name if different from default"
        | optional,
      SPELL_VALE_DISABLE_ERRORS | Bool | optional,
      SPELL_VALE_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SPELL_VALE_FILE_EXTENSIONS | Array (String) | optional,
      SPELL_VALE_FILE_NAMES_REGEX | Array (String) | optional,
      SPELL_VALE_FILTER_REGEX_EXCLUDE | String | optional,
      SPELL_VALE_FILTER_REGEX_INCLUDE | String | optional,
      SPELL_VALE_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_VALE_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SPELL_VALE_RULES_PATH
        | String
        | doc "SPELL_VALE: Path where to find linter configuration file"
        | optional,
      SPELL_VALE_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SPELL_VALE and its pre/post commands"
        | optional,
      SQL_FILTER_REGEX_EXCLUDE | String | optional,
      SQL_FILTER_REGEX_INCLUDE | String | optional,
      SQL_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_SQLFLUFF_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SQL_SQLFLUFF: User custom arguments to add in linter CLI call"
        | optional,
      SQL_SQLFLUFF_CLI_EXECUTABLE | Array (String) | optional,
      SQL_SQLFLUFF_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SQL_SQLFLUFF_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SQL_SQLFLUFF: User custom arguments to remove before calling linter"
        | optional,
      SQL_SQLFLUFF_CONFIG_FILE
        | String
        | doc "SQL_SQLFLUFF: User custom config file name if different from default"
        | optional,
      SQL_SQLFLUFF_DISABLE_ERRORS | Bool | optional,
      SQL_SQLFLUFF_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SQL_SQLFLUFF_FILE_EXTENSIONS | Array (String) | optional,
      SQL_SQLFLUFF_FILE_NAMES_REGEX | Array (String) | optional,
      SQL_SQLFLUFF_FILTER_REGEX_EXCLUDE | String | optional,
      SQL_SQLFLUFF_FILTER_REGEX_INCLUDE | String | optional,
      SQL_SQLFLUFF_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_SQLFLUFF_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_SQLFLUFF_RULES_PATH
        | String
        | doc "SQL_SQLFLUFF: Path where to find linter configuration file"
        | optional,
      SQL_SQLFLUFF_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SQL_SQLFLUFF and its pre/post commands"
        | optional,
      SQL_SQL_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SQL_SQL_LINT: User custom arguments to add in linter CLI call"
        | optional,
      SQL_SQL_LINT_CLI_EXECUTABLE | Array (String) | optional,
      SQL_SQL_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      SQL_SQL_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SQL_SQL_LINT: User custom arguments to remove before calling linter"
        | optional,
      SQL_SQL_LINT_CONFIG_FILE
        | String
        | doc "SQL_SQL_LINT: User custom config file name if different from default"
        | optional,
      SQL_SQL_LINT_DISABLE_ERRORS | Bool | optional,
      SQL_SQL_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SQL_SQL_LINT_FILE_EXTENSIONS | Array (String) | optional,
      SQL_SQL_LINT_FILE_NAME
        | String
        | doc "SQL_SQL_LINT: User custom config file name if different from default"
        | optional,
      SQL_SQL_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      SQL_SQL_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      SQL_SQL_LINT_FILTER_REGEX_INCLUDE | String | optional,
      SQL_SQL_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_SQL_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_SQL_LINT_RULES_PATH
        | String
        | doc "SQL_SQL_LINT: Path where to find linter configuration file"
        | optional,
      SQL_SQL_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SQL_SQL_LINT and its pre/post commands"
        | optional,
      SQL_TSQLLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SQL_TSQLLINT: User custom arguments to add in linter CLI call"
        | optional,
      SQL_TSQLLINT_CLI_EXECUTABLE | Array (String) | optional,
      SQL_TSQLLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SQL_TSQLLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SQL_TSQLLINT: User custom arguments to remove before calling linter"
        | optional,
      SQL_TSQLLINT_CONFIG_FILE
        | String
        | doc "SQL_TSQLLINT: User custom config file name if different from default"
        | optional,
      SQL_TSQLLINT_DISABLE_ERRORS | Bool | optional,
      SQL_TSQLLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SQL_TSQLLINT_FILE_EXTENSIONS | Array (String) | optional,
      SQL_TSQLLINT_FILE_NAMES_REGEX | Array (String) | optional,
      SQL_TSQLLINT_FILTER_REGEX_EXCLUDE | String | optional,
      SQL_TSQLLINT_FILTER_REGEX_INCLUDE | String | optional,
      SQL_TSQLLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_TSQLLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SQL_TSQLLINT_RULES_PATH
        | String
        | doc "SQL_TSQLLINT: Path where to find linter configuration file"
        | optional,
      SQL_TSQLLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SQL_TSQLLINT and its pre/post commands"
        | optional,
      SWIFT_FILTER_REGEX_EXCLUDE | String | optional,
      SWIFT_FILTER_REGEX_INCLUDE | String | optional,
      SWIFT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SWIFT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SWIFT_SWIFTLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SWIFT_SWIFTLINT: User custom arguments to add in linter CLI call"
        | optional,
      SWIFT_SWIFTLINT_CLI_EXECUTABLE | Array (String) | optional,
      SWIFT_SWIFTLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      SWIFT_SWIFTLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "SWIFT_SWIFTLINT: User custom arguments to remove before calling linter"
        | optional,
      SWIFT_SWIFTLINT_CONFIG_FILE
        | String
        | doc "SWIFT_SWIFTLINT: User custom config file name if different from default"
        | optional,
      SWIFT_SWIFTLINT_DISABLE_ERRORS | Bool | optional,
      SWIFT_SWIFTLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      SWIFT_SWIFTLINT_FILE_EXTENSIONS | Array (String) | optional,
      SWIFT_SWIFTLINT_FILE_NAMES_REGEX | Array (String) | optional,
      SWIFT_SWIFTLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SWIFT_SWIFTLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      SWIFT_SWIFTLINT_RULES_PATH
        | String
        | doc "SWIFT_SWIFTLINT: Path where to find linter configuration file"
        | optional,
      SWIFT_SWIFTLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling SWIFT_SWIFTLINT and its pre/post commands"
        | optional,
      TAP_REPORTER
        | Bool
        | doc "General execution log mega-linter.log (same as ConsoleReporter log) + a separate log file for each processed linter"
        | optional,
      TAP_REPORTER_SUB_FOLDER
        | String
        | doc "Sub-folder of reports folder containing TAP logs"
        | optional,
      TEKTON_FILTER_REGEX_EXCLUDE | String | optional,
      TEKTON_FILTER_REGEX_INCLUDE | String | optional,
      TEKTON_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TEKTON_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TEKTON_TEKTON_LINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TEKTON_TEKTON_LINT: User custom arguments to add in linter CLI call"
        | optional,
      TEKTON_TEKTON_LINT_CLI_EXECUTABLE | Array (String) | optional,
      TEKTON_TEKTON_LINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      TEKTON_TEKTON_LINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TEKTON_TEKTON_LINT: User custom arguments to remove before calling linter"
        | optional,
      TEKTON_TEKTON_LINT_CONFIG_FILE
        | String
        | doc "TEKTON_TEKTON_LINT: User custom config file name if different from default"
        | optional,
      TEKTON_TEKTON_LINT_DISABLE_ERRORS | Bool | optional,
      TEKTON_TEKTON_LINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TEKTON_TEKTON_LINT_FILE_EXTENSIONS | Array (String) | optional,
      TEKTON_TEKTON_LINT_FILE_NAME
        | String
        | doc "TEKTON_TEKTON_LINT: User custom config file name if different from default"
        | optional,
      TEKTON_TEKTON_LINT_FILE_NAMES_REGEX | Array (String) | optional,
      TEKTON_TEKTON_LINT_FILTER_REGEX_EXCLUDE | String | optional,
      TEKTON_TEKTON_LINT_FILTER_REGEX_INCLUDE | String | optional,
      TEKTON_TEKTON_LINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TEKTON_TEKTON_LINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TEKTON_TEKTON_LINT_RULES_PATH
        | String
        | doc "TEKTON_TEKTON_LINT: Path where to find linter configuration file"
        | optional,
      TEKTON_TEKTON_LINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TEKTON_TEKTON_LINT and its pre/post commands"
        | optional,
      TERRAFORM_CHECKOV_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_CHECKOV: User custom arguments to add in linter CLI call"
        | optional,
      TERRAFORM_CHECKOV_CLI_EXECUTABLE | Array (String) | optional,
      TERRAFORM_CHECKOV_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      TERRAFORM_CHECKOV_DISABLE_ERRORS | Bool | optional,
      TERRAFORM_CHECKOV_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TERRAFORM_CHECKOV_FILE_EXTENSIONS | Array (String) | optional,
      TERRAFORM_CHECKOV_FILE_NAMES_REGEX | Array (String) | optional,
      TERRAFORM_CHECKOV_FILTER_REGEX_EXCLUDE | String | optional,
      TERRAFORM_CHECKOV_FILTER_REGEX_INCLUDE | String | optional,
      TERRAFORM_CHECKOV_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_CHECKOV_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_FILTER_REGEX_EXCLUDE | String | optional,
      TERRAFORM_FILTER_REGEX_INCLUDE | String | optional,
      TERRAFORM_KICS_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_KICS: User custom arguments to add in linter CLI call"
        | optional,
      TERRAFORM_KICS_CLI_EXECUTABLE | Array (String) | optional,
      TERRAFORM_KICS_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      TERRAFORM_KICS_DISABLE_ERRORS | Bool | optional,
      TERRAFORM_KICS_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TERRAFORM_KICS_FILE_EXTENSIONS | Array (String) | optional,
      TERRAFORM_KICS_FILE_NAMES_REGEX | Array (String) | optional,
      TERRAFORM_KICS_FILTER_REGEX_EXCLUDE | String | optional,
      TERRAFORM_KICS_FILTER_REGEX_INCLUDE | String | optional,
      TERRAFORM_KICS_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_KICS_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRAFORM_FMT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TERRAFORM_FMT: User custom arguments to add in linter CLI call"
        | optional,
      TERRAFORM_TERRAFORM_FMT_CLI_EXECUTABLE | Array (String) | optional,
      TERRAFORM_TERRAFORM_FMT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      TERRAFORM_TERRAFORM_FMT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TERRAFORM_FMT: User custom arguments to remove before calling linter"
        | optional,
      TERRAFORM_TERRAFORM_FMT_DISABLE_ERRORS | Bool | optional,
      TERRAFORM_TERRAFORM_FMT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TERRAFORM_TERRAFORM_FMT_FILE_EXTENSIONS | Array (String) | optional,
      TERRAFORM_TERRAFORM_FMT_FILE_NAMES_REGEX | Array (String) | optional,
      TERRAFORM_TERRAFORM_FMT_FILTER_REGEX_EXCLUDE | String | optional,
      TERRAFORM_TERRAFORM_FMT_FILTER_REGEX_INCLUDE | String | optional,
      TERRAFORM_TERRAFORM_FMT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRAFORM_FMT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRAFORM_FMT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TERRAFORM_TERRAFORM_FMT and its pre/post commands"
        | optional,
      TERRAFORM_TERRAGRUNT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TERRAGRUNT: User custom arguments to add in linter CLI call"
        | optional,
      TERRAFORM_TERRAGRUNT_CLI_EXECUTABLE | Array (String) | optional,
      TERRAFORM_TERRAGRUNT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'file |]
        | optional,
      TERRAFORM_TERRAGRUNT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TERRAGRUNT: User custom arguments to remove before calling linter"
        | optional,
      TERRAFORM_TERRAGRUNT_CONFIG_FILE
        | String
        | doc "TERRAFORM_TERRAGRUNT: User custom config file name if different from default"
        | optional,
      TERRAFORM_TERRAGRUNT_DISABLE_ERRORS | Bool | optional,
      TERRAFORM_TERRAGRUNT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TERRAFORM_TERRAGRUNT_FILE_EXTENSIONS | Array (String) | optional,
      TERRAFORM_TERRAGRUNT_FILE_NAME
        | String
        | doc "TERRAFORM_TERRAGRUNT: User custom config file name if different from default"
        | optional,
      TERRAFORM_TERRAGRUNT_FILE_NAMES_REGEX | Array (String) | optional,
      TERRAFORM_TERRAGRUNT_FILTER_REGEX_EXCLUDE | String | optional,
      TERRAFORM_TERRAGRUNT_FILTER_REGEX_INCLUDE | String | optional,
      TERRAFORM_TERRAGRUNT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRAGRUNT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRAGRUNT_RULES_PATH
        | String
        | doc "TERRAFORM_TERRAGRUNT: Path where to find linter configuration file"
        | optional,
      TERRAFORM_TERRAGRUNT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TERRAFORM_TERRAGRUNT and its pre/post commands"
        | optional,
      TERRAFORM_TERRASCAN_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TERRASCAN: User custom arguments to add in linter CLI call"
        | optional,
      TERRAFORM_TERRASCAN_CLI_EXECUTABLE | Array (String) | optional,
      TERRAFORM_TERRASCAN_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      TERRAFORM_TERRASCAN_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TERRASCAN: User custom arguments to remove before calling linter"
        | optional,
      TERRAFORM_TERRASCAN_CONFIG_FILE
        | String
        | doc "TERRAFORM_TERRASCAN: User custom config file name if different from default"
        | optional,
      TERRAFORM_TERRASCAN_DISABLE_ERRORS | Bool | optional,
      TERRAFORM_TERRASCAN_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TERRAFORM_TERRASCAN_FILE_EXTENSIONS | Array (String) | optional,
      TERRAFORM_TERRASCAN_FILE_NAMES_REGEX | Array (String) | optional,
      TERRAFORM_TERRASCAN_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRASCAN_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TERRASCAN_RULES_PATH
        | String
        | doc "TERRAFORM_TERRASCAN: Path where to find linter configuration file"
        | optional,
      TERRAFORM_TERRASCAN_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TERRAFORM_TERRASCAN and its pre/post commands"
        | optional,
      TERRAFORM_TFLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TFLINT: User custom arguments to add in linter CLI call"
        | optional,
      TERRAFORM_TFLINT_CLI_EXECUTABLE | Array (String) | optional,
      TERRAFORM_TFLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      TERRAFORM_TFLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TERRAFORM_TFLINT: User custom arguments to remove before calling linter"
        | optional,
      TERRAFORM_TFLINT_CONFIG_FILE
        | String
        | doc "TERRAFORM_TFLINT: User custom config file name if different from default"
        | optional,
      TERRAFORM_TFLINT_DISABLE_ERRORS | Bool | optional,
      TERRAFORM_TFLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TERRAFORM_TFLINT_FILE_EXTENSIONS | Array (String) | optional,
      TERRAFORM_TFLINT_FILE_NAME
        | String
        | doc "TERRAFORM_TFLINT: User custom config file name if different from default"
        | optional,
      TERRAFORM_TFLINT_FILE_NAMES_REGEX | Array (String) | optional,
      TERRAFORM_TFLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TFLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TERRAFORM_TFLINT_RULES_PATH
        | String
        | doc "TERRAFORM_TFLINT: Path where to find linter configuration file"
        | optional,
      TERRAFORM_TFLINT_SECURED_ENV
        | Bool
        | doc "TERRAFORM_TFLINT: Allows to send the full env to **tflint --init**. Initialized with default value `true`. Set to `false` to allow `tflint --init` to access your env vars."
        | optional,
      TERRAFORM_TFLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TERRAFORM_TFLINT and its pre/post commands"
        | optional,
      TEXT_REPORTER
        | Bool
        | doc "General execution log mega-linter.log (same as ConsoleReporter log) + a separate log file for each processed linter"
        | optional,
      TEXT_REPORTER_SUB_FOLDER
        | String
        | doc "Sub-folder of reports folder containing text logs"
        | optional,
      TSX_ESLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TSX_ESLINT: User custom arguments to add in linter CLI call"
        | optional,
      TSX_ESLINT_CLI_EXECUTABLE | Array (String) | optional,
      TSX_ESLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      TSX_ESLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TSX_ESLINT: User custom arguments to remove before calling linter"
        | optional,
      TSX_ESLINT_CONFIG_FILE
        | String
        | doc "TSX_ESLINT: User custom config file name if different from default"
        | optional,
      TSX_ESLINT_DISABLE_ERRORS | Bool | optional,
      TSX_ESLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TSX_ESLINT_FILE_EXTENSIONS | Array (String) | optional,
      TSX_ESLINT_FILE_NAME
        | String
        | doc "TSX_ESLINT: User custom config file name if different from default"
        | optional,
      TSX_ESLINT_FILE_NAMES_REGEX | Array (String) | optional,
      TSX_ESLINT_FILTER_REGEX_EXCLUDE | String | optional,
      TSX_ESLINT_FILTER_REGEX_INCLUDE | String | optional,
      TSX_ESLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TSX_ESLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TSX_ESLINT_RULES_PATH
        | String
        | doc "TSX_ESLINT: Path where to find linter configuration file"
        | optional,
      TSX_ESLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TSX_ESLINT and its pre/post commands"
        | optional,
      TSX_FILTER_REGEX_EXCLUDE | String | optional,
      TSX_FILTER_REGEX_INCLUDE | String | optional,
      TSX_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TSX_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_DEFAULT_STYLE
        | std.enum.TagOrString
        | [| 'prettier, 'standard |]
        | doc "Style of typescript formatting to apply"
        | optional,
      TYPESCRIPT_ES_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TYPESCRIPT_ES: User custom arguments to add in linter CLI call"
        | optional,
      TYPESCRIPT_ES_CLI_EXECUTABLE | Array (String) | optional,
      TYPESCRIPT_ES_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      TYPESCRIPT_ES_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TYPESCRIPT_ES: User custom arguments to remove before calling linter"
        | optional,
      TYPESCRIPT_ES_CONFIG_FILE
        | String
        | doc "TYPESCRIPT_ES: User custom config file name if different from default"
        | optional,
      TYPESCRIPT_ES_DISABLE_ERRORS | Bool | optional,
      TYPESCRIPT_ES_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TYPESCRIPT_ES_FILE_EXTENSIONS | Array (String) | optional,
      TYPESCRIPT_ES_FILE_NAME
        | String
        | doc "TYPESCRIPT_ES: User custom config file name if different from default"
        | optional,
      TYPESCRIPT_ES_FILE_NAMES_REGEX | Array (String) | optional,
      TYPESCRIPT_ES_FILTER_REGEX_EXCLUDE | String | optional,
      TYPESCRIPT_ES_FILTER_REGEX_INCLUDE | String | optional,
      TYPESCRIPT_ES_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_ES_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_ES_RULES_PATH
        | String
        | doc "TYPESCRIPT_ES: Path where to find linter configuration file"
        | optional,
      TYPESCRIPT_ES_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TYPESCRIPT_ES and its pre/post commands"
        | optional,
      TYPESCRIPT_FILTER_REGEX_EXCLUDE | String | optional,
      TYPESCRIPT_FILTER_REGEX_INCLUDE | String | optional,
      TYPESCRIPT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_PRETTIER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TYPESCRIPT_PRETTIER: User custom arguments to add in linter CLI call"
        | optional,
      TYPESCRIPT_PRETTIER_CLI_EXECUTABLE | Array (String) | optional,
      TYPESCRIPT_PRETTIER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      TYPESCRIPT_PRETTIER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TYPESCRIPT_PRETTIER: User custom arguments to remove before calling linter"
        | optional,
      TYPESCRIPT_PRETTIER_CONFIG_FILE
        | String
        | doc "TYPESCRIPT_PRETTIER: User custom config file name if different from default"
        | optional,
      TYPESCRIPT_PRETTIER_DISABLE_ERRORS | Bool | optional,
      TYPESCRIPT_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TYPESCRIPT_PRETTIER_FILE_EXTENSIONS | Array (String) | optional,
      TYPESCRIPT_PRETTIER_FILE_NAMES_REGEX | Array (String) | optional,
      TYPESCRIPT_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
      TYPESCRIPT_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
      TYPESCRIPT_PRETTIER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_PRETTIER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_PRETTIER_RULES_PATH
        | String
        | doc "TYPESCRIPT_PRETTIER: Path where to find linter configuration file"
        | optional,
      TYPESCRIPT_PRETTIER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TYPESCRIPT_PRETTIER and its pre/post commands"
        | optional,
      TYPESCRIPT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_STANDARD_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TYPESCRIPT_STANDARD: User custom arguments to add in linter CLI call"
        | optional,
      TYPESCRIPT_STANDARD_CLI_EXECUTABLE | Array (String) | optional,
      TYPESCRIPT_STANDARD_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      TYPESCRIPT_STANDARD_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "TYPESCRIPT_STANDARD: User custom arguments to remove before calling linter"
        | optional,
      TYPESCRIPT_STANDARD_DISABLE_ERRORS | Bool | optional,
      TYPESCRIPT_STANDARD_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      TYPESCRIPT_STANDARD_FILE_EXTENSIONS | Array (String) | optional,
      TYPESCRIPT_STANDARD_FILE_NAMES_REGEX | Array (String) | optional,
      TYPESCRIPT_STANDARD_FILTER_REGEX_EXCLUDE | String | optional,
      TYPESCRIPT_STANDARD_FILTER_REGEX_INCLUDE | String | optional,
      TYPESCRIPT_STANDARD_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_STANDARD_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      TYPESCRIPT_STANDARD_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling TYPESCRIPT_STANDARD and its pre/post commands"
        | optional,
      UPDATED_SOURCES_REPORTER | Bool | optional,
      UPDATED_SOURCES_REPORTER_DIR | String | optional,
      VALIDATE_ALL_CODEBASE
        | Bool
        | doc "Will parse the entire repository and find all files to validate across all types. When set to false, only new or edited files will be parsed for validation."
        | optional,
      VBDOTNET_DOTNET_FORMAT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "VBDOTNET_DOTNET_FORMAT: User custom arguments to add in linter CLI call"
        | optional,
      VBDOTNET_DOTNET_FORMAT_CLI_EXECUTABLE | Array (String) | optional,
      VBDOTNET_DOTNET_FORMAT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      VBDOTNET_DOTNET_FORMAT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "VBDOTNET_DOTNET_FORMAT: User custom arguments to remove before calling linter"
        | optional,
      VBDOTNET_DOTNET_FORMAT_DISABLE_ERRORS | Bool | optional,
      VBDOTNET_DOTNET_FORMAT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      VBDOTNET_DOTNET_FORMAT_FILE_EXTENSIONS | Array (String) | optional,
      VBDOTNET_DOTNET_FORMAT_FILE_NAMES_REGEX | Array (String) | optional,
      VBDOTNET_DOTNET_FORMAT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      VBDOTNET_DOTNET_FORMAT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      VBDOTNET_DOTNET_FORMAT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling VBDOTNET_DOTNET_FORMAT and its pre/post commands"
        | optional,
      VBDOTNET_FILTER_REGEX_EXCLUDE | String | optional,
      VBDOTNET_FILTER_REGEX_INCLUDE | String | optional,
      VBDOTNET_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      VBDOTNET_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      XML_FILTER_REGEX_EXCLUDE | String | optional,
      XML_FILTER_REGEX_INCLUDE | String | optional,
      XML_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      XML_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      XML_XMLLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "XML_XMLLINT: User custom arguments to add in linter CLI call"
        | optional,
      XML_XMLLINT_AUTOFORMAT | Bool | optional,
      XML_XMLLINT_CLI_EXECUTABLE | Array (String) | optional,
      XML_XMLLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      XML_XMLLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "XML_XMLLINT: User custom arguments to remove before calling linter"
        | optional,
      XML_XMLLINT_DISABLE_ERRORS | Bool | optional,
      XML_XMLLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      XML_XMLLINT_FILE_EXTENSIONS | Array (String) | optional,
      XML_XMLLINT_FILE_NAMES_REGEX | Array (String) | optional,
      XML_XMLLINT_FILTER_REGEX_EXCLUDE | String | optional,
      XML_XMLLINT_FILTER_REGEX_INCLUDE | String | optional,
      XML_XMLLINT_INDENT | String | optional,
      XML_XMLLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      XML_XMLLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      XML_XMLLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling XML_XMLLINT and its pre/post commands"
        | optional,
      YAML_FILTER_REGEX_EXCLUDE | String | optional,
      YAML_FILTER_REGEX_INCLUDE | String | optional,
      YAML_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_PRETTIER_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "YAML_PRETTIER: User custom arguments to add in linter CLI call"
        | optional,
      YAML_PRETTIER_CLI_EXECUTABLE | Array (String) | optional,
      YAML_PRETTIER_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      YAML_PRETTIER_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "YAML_PRETTIER: User custom arguments to remove before calling linter"
        | optional,
      YAML_PRETTIER_CONFIG_FILE
        | String
        | doc "YAML_PRETTIER: User custom config file name if different from default"
        | optional,
      YAML_PRETTIER_DISABLE_ERRORS | Bool | optional,
      YAML_PRETTIER_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      YAML_PRETTIER_FILE_EXTENSIONS | Array (String) | optional,
      YAML_PRETTIER_FILE_NAMES_REGEX | Array (String) | optional,
      YAML_PRETTIER_FILTER_REGEX_EXCLUDE | String | optional,
      YAML_PRETTIER_FILTER_REGEX_INCLUDE | String | optional,
      YAML_PRETTIER_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_PRETTIER_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_PRETTIER_RULES_PATH
        | String
        | doc "YAML_PRETTIER: Path where to find linter configuration file"
        | optional,
      YAML_PRETTIER_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling YAML_PRETTIER and its pre/post commands"
        | optional,
      YAML_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_V8R_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "YAML_V8R: User custom arguments to add in linter CLI call"
        | optional,
      YAML_V8R_CLI_EXECUTABLE | Array (String) | optional,
      YAML_V8R_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      YAML_V8R_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "YAML_V8R: User custom arguments to remove before calling linter"
        | optional,
      YAML_V8R_CONFIG_FILE
        | String
        | doc "YAML_V8R: User custom config file name if different from default"
        | optional,
      YAML_V8R_DISABLE_ERRORS | Bool | optional,
      YAML_V8R_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      YAML_V8R_FILE_EXTENSIONS | Array (String) | optional,
      YAML_V8R_FILE_NAMES_REGEX | Array (String) | optional,
      YAML_V8R_FILTER_REGEX_EXCLUDE | String | optional,
      YAML_V8R_FILTER_REGEX_INCLUDE | String | optional,
      YAML_V8R_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_V8R_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_V8R_RULES_PATH
        | String
        | doc "YAML_V8R: Path where to find linter configuration file"
        | optional,
      YAML_V8R_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling YAML_V8R and its pre/post commands"
        | optional,
      YAML_YAMLLINT_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "YAML_YAMLLINT: User custom arguments to add in linter CLI call"
        | optional,
      YAML_YAMLLINT_CLI_EXECUTABLE | Array (String) | optional,
      YAML_YAMLLINT_CLI_LINT_MODE
        | std.enum.TagOrString
        | [| 'project, 'list_of_files, 'file |]
        | optional,
      YAML_YAMLLINT_COMMAND_REMOVE_ARGUMENTS
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String"
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "YAML_YAMLLINT: User custom arguments to remove before calling linter"
        | optional,
      YAML_YAMLLINT_CONFIG_FILE
        | String
        | doc "YAML_YAMLLINT: User custom config file name if different from default"
        | optional,
      YAML_YAMLLINT_DISABLE_ERRORS | Bool | optional,
      YAML_YAMLLINT_DISABLE_ERRORS_IF_LESS_THAN | Number | optional,
      YAML_YAMLLINT_FILE_EXTENSIONS | Array (String) | optional,
      YAML_YAMLLINT_FILE_NAME
        | String
        | doc "YAML_YAMLLINT: User custom config file name if different from default"
        | optional,
      YAML_YAMLLINT_FILE_NAMES_REGEX | Array (String) | optional,
      YAML_YAMLLINT_FILTER_REGEX_EXCLUDE | String | optional,
      YAML_YAMLLINT_FILTER_REGEX_INCLUDE | String | optional,
      YAML_YAMLLINT_POST_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_YAMLLINT_PRE_COMMANDS
        | Array _js2n__-refsenv."_js2n__-:definitions/command_info!contract"
        | optional,
      YAML_YAMLLINT_RULES_PATH
        | String
        | doc "YAML_YAMLLINT: Path where to find linter configuration file"
        | optional,
      YAML_YAMLLINT_UNSECURED_ENV_VARIABLES
        | Array (String)
        | doc "List of env variables explicitly not filtered before calling YAML_YAMLLINT and its pre/post commands"
        | optional,
    }