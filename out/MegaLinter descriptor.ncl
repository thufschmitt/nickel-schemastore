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
      "_js2n__-:definitions/command_info!predicate"
        | doc "Command information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  continue_if_failed = _js2n__-prdslib.isType '"Bool",
                  cwd =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "root", "workspace" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/enum_flavors!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'terraform,
                'swift,
                'security,
                'salesforce,
                'rust,
                'ruby,
                'python,
                'php,
                'javascript,
                'java,
                'go,
                'formatters,
                'dotnetweb,
                'dotnet,
                'documentation,
                'cupcake,
                'ci_light,
                'c_cpp,
                'all,
                'all_flavors
              |]
            ],
      "_js2n__-:definitions/linter_command_info!contract"
        | doc "Command information"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    run_after_linters = _js2n__-prdslib.isType '"Bool",
                    run_before_linters = _js2n__-prdslib.isType '"Bool",
                  } {} true _js2n__-prdslib.always,
                _js2n__-refsenv."_js2n__-:definitions/command_info!predicate"
              ]),
    }
    in
  {
      active_only_if_file_found
        | Array (String)
        | doc "Names of the config files to be found (at least one), else descriptor will be deactivated. Search in workspace, linter rules path, and files_sub_directory"
        | optional,
      descriptor_flavors
        | Array _js2n__-refsenv."_js2n__-:definitions/enum_flavors!contract"
        | doc "MegaLinter flavors matching this descriptor"
        | optional,
      descriptor_flavors_exclude
        | Array _js2n__-refsenv."_js2n__-:definitions/enum_flavors!contract"
        | doc "MegaLinter flavors that must not contain this descriptor"
        | optional,
      descriptor_id
        | String
        | doc "Uppercase unique identifier for the language, tooling format or identifier",
      descriptor_label
        | String
        | doc "Label for descriptor documentation, if different from Id. Ex: C++ for CPP"
        | optional,
      descriptor_type
        | std.enum.TagOrString
        | [| 'other, 'tooling_format, 'format, 'language |]
        | doc "Descriptor type: language, format or tooling format",
      file_contains_regex
        | Array (String)
        | doc "Regular expression list for filtering files by their content"
        | optional,
      file_contains_regex_extensions
        | Array (String)
        | doc "If file_contains_regex is set, use this property to filter extensions of the files that will be checked"
        | optional,
      file_extensions
        | Array (String)
        | doc "File extension filters. Empty list excludes all files. Can be overridden at linter level"
        | optional,
      file_names_not_ends_with
        | Array (String)
        | doc "List of strings to filter the files according to their end of file name"
        | optional,
      file_names_regex
        | Array (String)
        | doc "Regular expression list for filtering files by their base names using regex full match. Empty list includes all files. Can be overridden at linter level"
        | optional,
      files_sub_directory
        | String
        | doc "Set when a linter only lints a sub-directory"
        | optional,
      install
        | {
          apk
            | Array (String)
            | doc "APK packages identifiers (with or without version)"
            | optional,
          cargo
            | Array (String)
            | doc "Cargo packages identifiers (with or without version)"
            | optional,
          dockerfile
            | Array (String)
            | doc "Will be automatically integrated in generated Dockerfile"
            | optional,
          gem
            | Array (String)
            | doc "GEM packages identifiers (with or without version)"
            | optional,
          npm
            | Array (String)
            | doc "NPM packages identifiers (with or without version)"
            | optional,
          pip
            | Array (String)
            | doc "PIP packages identifiers (with or without version)"
            | optional,
          ..
        }
        | doc "List of apk, dockerfile instructions, npm/pip/gem packages required to use the descriptor linters"
        | optional,
      lint_all_files
        | Bool
        | doc "If set to true, this descriptor linters will always lint all files, undepending their name/extensions/content"
        | optional,
      lint_all_other_linters_files
        | Bool
        | doc "If set to true, this descriptor linters will lint one by one all files collected by all other linters"
        | optional,
      linters
        | Array
          {
            activation_rules
              | Array {  .. }
              | doc "List of rules to check to activate linter"
              | optional,
            active_only_if_file_found
              | Array (String)
              | doc "Names of the config files to be found (at least one), else descriptor will be deactivated"
              | optional,
            can_output_sarif
              | Bool
              | doc "Shows if the linter is capable of output SARIF report within MegaLinter"
              | optional,
            class
              | String
              | doc "If MegaLinter core is not enough, use a custom class inheriting from Linter class"
              | optional,
            cli_config_arg_name | String | optional,
            cli_config_default_value | String | optional,
            cli_config_extra_args
              | Array (String)
              | doc "When a configuration file is used with the linter CLI, send these additional arguments"
              | optional,
            cli_docker_args
              | Array (String)
              | doc "Arguments for docker run before image name"
              | optional,
            cli_docker_image | String | optional,
            cli_docker_image_version
              | String
              | doc "Version of the docker image to use for linting"
              | optional,
            cli_executable
              | String
              | doc "Override if different from linter_name"
              | optional,
            cli_executable_help
              | String
              | doc "Override if different from cli executable used for linting"
              | optional,
            cli_executable_version
              | String
              | doc "Override if different from cli executable used for linting"
              | optional,
            cli_help_arg_name | String | optional,
            cli_help_extra_args
              | Array (String)
              | doc "When linter CLI is call for help, send these additional arguments"
              | optional,
            cli_help_extra_commands
              | Array (String)
              | doc "When linter CLI is call for help, send these additional commands"
              | optional,
            cli_lint_errors_count
              | std.enum.TagOrString
              | [|
                'sarif,
                'total_lines,
                'regex_sum,
                'regex_count,
                'regex_number
              |]
              | doc "Defines how to count errors from log file. regex_number, regex_count, regex_sum, or total_lines"
              | optional,
            cli_lint_errors_regex
              | String
              | doc "Regex allowing to extract the number of errors from linter output logs"
              | optional,
            cli_lint_extra_args
              | Array (String)
              | doc "When linter CLI is call for linting, send these additional arguments before config args"
              | optional,
            cli_lint_extra_args_after
              | Array (String)
              | doc "When linter CLI is call for linting, send these additional arguments after config args"
              | optional,
            cli_lint_fix_arg_name | String | optional,
            cli_lint_fix_remove_args
              | Array (String)
              | doc "When linter CLI is call for fixing, remove these arguments"
              | optional,
            cli_lint_ignore_arg_name
              | String
              | doc "If the linter can use an ignore file, input here the related argument"
              | optional,
            cli_lint_mode
              | std.enum.TagOrString
              | [| 'list_of_files, 'project, 'file |]
              | doc "Defines how the linter is called: file,  list_of_files, project"
              | optional,
            cli_lint_warnings_count
              | std.enum.TagOrString
              | [| 'total_lines, 'regex_sum, 'regex_count, 'regex_number |]
              | doc "Defines how to count warnings from log file. regex_number, regex_count, regex_sum, or total_lines"
              | optional,
            cli_lint_warnings_regex
              | String
              | doc "Regex allowing to extract the number of warnings from linter output logs"
              | optional,
            cli_sarif_args
              | Array (String)
              | doc "Arguments to generate SARIF output"
              | optional,
            cli_version_arg_name | String | optional,
            cli_version_extra_args
              | Array (String)
              | doc "When linter CLI is call for version, send these additional arguments"
              | optional,
            config_file_name
              | String
              | doc "An explanation about the purpose of this instance."
              | optional,
            deprecated
              | Bool
              | doc "Shows if the linter is deprecated."
              | optional,
            deprecated_description
              | String
              | doc "Displays information on why it is deprecated and whether an alternative is available."
              | optional,
            descriptor_flavors
              | Array
                _js2n__-refsenv."_js2n__-:definitions/enum_flavors!contract"
              | doc "MegaLinter flavors matching this linter"
              | optional,
            descriptor_flavors_exclude
              | Array
                _js2n__-refsenv."_js2n__-:definitions/enum_flavors!contract"
              | doc "MegaLinter flavors that must not contain this descriptor"
              | optional,
            disabled
              | Bool
              | doc "Disable linter in MegaLinter next builds"
              | optional,
            disabled_reason
              | String
              | doc "Explanation about why the linter is disabled"
              | optional,
            downgraded_reason
              | String
              | doc "Explanation about why the linter is downgraded"
              | optional,
            downgraded_version
              | Bool
              | doc "Indicates that installation instructions does not use the latest release of the linter"
              | optional,
            examples
              | Array (String)
              | doc "Please add an example with and without configuration file in the command. They will appear in documentation",
            file_extensions
              | Array (String)
              | doc "File extension filters if different from the ones defined on parent descriptor"
              | optional,
            file_names_not_ends_with
              | Array (String)
              | doc "List of strings to filter the files according to their end of file name"
              | optional,
            file_names_regex
              | Array (String)
              | doc "Regular expression list for filtering files by their base names using regex full match. Empty list includes all files. Can be overridden at linter level"
              | optional,
            files_sub_directory
              | String
              | doc "Set when a linter only lints a sub-directory"
              | optional,
            help_command_return_code | Number | optional,
            ide | {  .. } | doc "List of IDE supporting the linter" | optional,
            ignore_file_name
              | String
              | doc "An explanation about the purpose of this instance."
              | optional,
            ignore_for_flavor_suggestions
              | Bool
              | doc "If this property is set to true, this linter will be ignored for flavor suggestions"
              | optional,
            install
              | {
                apk
                  | Array (String)
                  | doc "APK packages identifiers (with or without version)"
                  | optional,
                cargo
                  | Array (String)
                  | doc "Cargo packages identifiers (with or without version)"
                  | optional,
                dockerfile
                  | Array (String)
                  | doc "Will be automatically integrated in generated Dockerfile"
                  | optional,
                gem
                  | Array (String)
                  | doc "GEM packages identifiers (with or without version)"
                  | optional,
                npm
                  | Array (String)
                  | doc "NPM packages identifiers (with or without version)"
                  | optional,
                pip
                  | Array (String)
                  | doc "PIP packages identifiers (with or without version)"
                  | optional,
                ..
              }
              | doc "List of apk, dockerfile instructions, npm/pip/gem packages required to install the linter"
              | optional,
            is_formatter
              | Bool
              | doc "If the linter is just a formatter, set to true so errors will count as warnings"
              | optional,
            is_sbom
              | Bool
              | doc "If the linter is SBOM, set to true so extra properties will be returned"
              | optional,
            lint_all_files
              | Bool
              | doc "If set to true, this linter will always lint all files, undepending their name/extensions/content"
              | optional,
            lint_all_other_linters_files
              | Bool
              | doc "If set to true, this descriptor linters will lint one by one all files collected by all other linters"
              | optional,
            linter_banner_image_url
              | String
              | doc "URL of an image used to build header of linter Markdown documentation"
              | optional,
            linter_help_cache
              | String
              | doc "If the linter is unable to return help content, hardcode it here"
              | optional,
            linter_icon_png_url
              | String
              | doc "URL of a PNG image representing the icon of the linter"
              | optional,
            linter_image_url
              | String
              | doc "URL of an image used in linter Markdown documentation"
              | optional,
            linter_megalinter_ref_url
              | String
              | doc "URL to linter documentation referring to MegaLinter"
              | optional,
            linter_name
              | String
              | doc "Name of the linter (same as cli command if possible)",
            linter_repo
              | String
              | doc "URL of the linter repository home page"
              | optional,
            linter_rules_configuration_url
              | String
              | doc "URL to linter documentation explaining how to configure the linter"
              | optional,
            linter_rules_ignore_config_url
              | String
              | doc "URL to linter documentation explaining how to ignore files"
              | optional,
            linter_rules_inline_disable_url
              | String
              | doc "URL to linter documentation explaining how to disable rules directly with comments in files"
              | optional,
            linter_rules_url
              | String
              | doc "URL to linter documentation listing all the rules that can be detected"
              | optional,
            linter_spdx_license
              | String
              | doc "spdx license id of the linter"
              | optional,
            linter_speed
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.enum [ 1, 2, 3, 4, 5 ]
                  ])
              | doc "Average speed of the linter (performances indicator). For 1 (very slow) to 5 (very fast)"
              | optional,
            linter_text | String | optional,
            linter_url | String | doc "URL of the linter home page",
            linter_version_cache
              | String
              | doc "If the linter is unable to return a version number, hardcode it here"
              | optional,
            name
              | String
              | doc "When several linters in a descriptor, set a different name that will be used for configuration"
              | optional,
            post_commands
              | Array
                _js2n__-refsenv."_js2n__-:definitions/linter_command_info!contract"
              | doc "Custom bash commands to run after linter"
              | optional,
            pre_commands
              | Array
                _js2n__-refsenv."_js2n__-:definitions/linter_command_info!contract"
              | doc "Custom bash commands to run before linter"
              | optional,
            sarif_default_output_file
              | String
              | doc "Path to find default SARIF output file when generated by linter"
              | optional,
            test_folder
              | String
              | doc "Test folder containing _good_ and _bad_ files, if different from parent descriptor test_folder"
              | optional,
            test_format_fix_file_extensions
              | Array (String)
              | doc "Format / Fix test file extension filters."
              | optional,
            test_format_fix_regex_exclude
              | String
              | doc "Format / Fix test exclusions"
              | optional,
            test_variables
              | {  .. }
              | doc "List of variables to set before running tests"
              | optional,
            variables
              | Array Dyn
              | doc "Try to not use this property except if you really have no choice"
              | optional,
            version_command_return_code | Number | optional,
            version_extract_regex
              | String
              | doc "If default regex to extract version from linter -v call, override it here"
              | optional,
          }
        | doc "List of linter definitions associated to the descriptor",
      processing_order
        | Number
        | doc "If descriptor linters may be slow, put a negative processing order. If it is fast, put a positive one. If you don't know, do not set"
        | optional,
      test_folder
        | String
        | doc "Test folder containing _good_ and _bad_ files. Default: lowercase(descriptor_id)"
        | optional,
    }