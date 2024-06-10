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
      "_js2n__-:definitions/Actions!contract"
        | doc "action"
        = {
            assign
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        add_users =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/Template!predicate"
                              ],
                        remove_users =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/Template!predicate"
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            backport
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        assignees =
                          _js2n__-refsenv."_js2n__-:definitions/TemplateArray!predicate",
                        body =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        branches =
                          _js2n__-refsenv."_js2n__-:definitions/BranchArray!predicate",
                        ignore_conflicts = _js2n__-prdslib.isType '"Bool",
                        label_conflicts = _js2n__-prdslib.isType '"String",
                        labels =
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                        merge_conflict_style =
                          _js2n__-refsenv."_js2n__-:definitions/MergeConflictStyle!predicate",
                        regexes =
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                        report_mode =
                          _js2n__-refsenv."_js2n__-:definitions/ReportModeArray!predicate",
                        title =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            close
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        message =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            comment
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        message =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            copy
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        assignees =
                          _js2n__-refsenv."_js2n__-:definitions/TemplateArray!predicate",
                        body =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        branches =
                          _js2n__-refsenv."_js2n__-:definitions/BranchArray!predicate",
                        ignore_conflicts = _js2n__-prdslib.isType '"Bool",
                        label_conflicts = _js2n__-prdslib.isType '"String",
                        labels =
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                        merge_conflict_style =
                          _js2n__-refsenv."_js2n__-:definitions/MergeConflictStyle!predicate",
                        regexes =
                          _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                        report_mode =
                          _js2n__-refsenv."_js2n__-:definitions/ReportModeArray!predicate",
                        title =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            delete_head_branch
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      { "force" = _js2n__-prdslib.isType '"Bool", } {} false
                      _js2n__-prdslib.never
                  ])
              | optional,
            dismiss_reviews
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        approved =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "from_requested_reviewers" ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      _js2n__-refsenv."_js2n__-:definitions/GitHubLogin!predicate"
                                  ]
                              ],
                        changes_requested =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "from_requested_reviewers" ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      _js2n__-refsenv."_js2n__-:definitions/GitHubLogin!predicate"
                                  ]
                              ],
                        message =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        when =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "synchronize", "always" ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            edit
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      { draft = _js2n__-prdslib.isType '"Bool", } {} false
                      _js2n__-prdslib.never
                  ])
              | optional,
            github_actions
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf [ _js2n__-prdslib.isType 'Record ],
                    _js2n__-prdslib.records.record
                      {
                        workflow =
                          _js2n__-refsenv."_js2n__-:definitions/GitHubActionsWorkflow!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            label
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        add =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/Template!predicate"
                              ],
                        remove =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/Template!predicate"
                              ],
                        remove_all = _js2n__-prdslib.isType '"Bool",
                        toggle =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/Template!predicate"
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            "merge"
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        commit_message_template =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        merge_bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        method =
                          _js2n__-refsenv."_js2n__-:definitions/MergeMethod!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            post_check
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        neutral_conditions =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/RuleCondition!predicate"
                              ],
                        success_conditions =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/RuleCondition!predicate"
                              ],
                        summary =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        title =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            queue
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        autosquash = _js2n__-prdslib.isType '"Bool",
                        commit_message_template =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        merge_bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        merge_method =
                          _js2n__-refsenv."_js2n__-:definitions/MergeMethod!predicate",
                        name = _js2n__-prdslib.isType '"String",
                        "priority" =
                          _js2n__-refsenv."_js2n__-:definitions/Priority!predicate",
                        update_bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        update_method =
                          _js2n__-prdslib.enum [ "merge", "rebase" ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            rebase
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        autosquash = _js2n__-prdslib.isType '"Bool",
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            request_reviews
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        random_count =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.numbers.maximum 15,
                                _js2n__-prdslib.numbers.minimum 1
                              ],
                        teams =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              login =
                                                _js2n__-refsenv."_js2n__-:definitions/GitHubLogin!predicate",
                                              weight =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ]
                              ],
                        users =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              login =
                                                _js2n__-refsenv."_js2n__-:definitions/GitHubLogin!predicate",
                                              weight =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ]
                              ],
                        users_from_teams =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/StringSet!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              login =
                                                _js2n__-refsenv."_js2n__-:definitions/GitHubLogin!predicate",
                                              weight =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                            } {} false _js2n__-prdslib.never
                                        ])
                                  ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            review
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        message =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        type =
                          _js2n__-prdslib.enum
                              [ "APPROVE", "REQUEST_CHANGES", "COMMENT" ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            squash
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                        commit_message =
                          _js2n__-prdslib.enum
                              [ "all-commits", "first-commit", "title+body" ],
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
            update
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ],
                    _js2n__-prdslib.records.record
                      {
                        bot_account =
                          _js2n__-refsenv."_js2n__-:definitions/Template!predicate",
                      } {} false _js2n__-prdslib.never
                  ])
              | optional,
          },
      "_js2n__-:definitions/BranchArray!predicate"
        | doc "list of branch names"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/BranchName!predicate"
            ],
      "_js2n__-:definitions/BranchName!predicate"
        | doc "branch name"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/CommandRestriction!contract"
        | doc "Command restriction"
        = {
            conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | optional,
          },
      "_js2n__-:definitions/ConditionString!contract" = String,
      "_js2n__-:definitions/ConditionString!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Duration!contract" | doc "duration" = String,
      "_js2n__-:definitions/Duration!predicate"
        | doc "duration"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/GitHubActionsWorkflow!predicate"
        | doc "A GitHub Actions workflow action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dispatch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/GitHubActionsWorkflowDispatch!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitHubActionsWorkflowDispatch!predicate"
        | doc "A GitHub Actions workflow dispatch"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  inputs = _js2n__-prdslib.isType 'Record,
                  workflow = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitHubLogin!predicate"
        | doc "GitHub login"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/MergeConflictStyle!predicate"
        | doc "`merge` or `diff3`"
        = _js2n__-prdslib.enum [ "merge", "diff3" ],
      "_js2n__-:definitions/MergeMethod!contract"
        | doc "merge method: `merge`, `squash`, `rebase` or `fast-forward`"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.enum
              [ "merge", "squash", "rebase", "fast-forward" ]),
      "_js2n__-:definitions/MergeMethod!predicate"
        | doc "merge method: `merge`, `squash`, `rebase` or `fast-forward`"
        = _js2n__-prdslib.enum [ "merge", "squash", "rebase", "fast-forward" ],
      "_js2n__-:definitions/MergeProtection!contract" =
        {
            description
              | String
              | doc "The description of the protection."
              | optional,
            "if"
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | doc "A list of conditions that must match against the pull request for the protection to be applied.",
            name
              | String
              | doc "The name of the protection. It's not possible to have two protections with the same name.",
            success_conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | doc "A list of conditions that must match against the pull request for the protection to be considered successful.",
          },
      "_js2n__-:definitions/PartitionRule!contract" =
        {
            conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | doc "List of conditions to determine the partition(s) in which the pull request will be queued. If a pull request matches no partition, it is added to the fallback partition if defined, otherwise it is added to every partition."
              | optional,
            fallback_partition
              | Bool
              | doc "Allow the partition to work as the fallback partition."
              | optional,
            name | String | doc "The name of the partition.",
          },
      "_js2n__-:definitions/Priority!contract"
        | doc "priority: `low`, `medium`, `high` or a value between 1 and 10000"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.maximum 10000,
                    _js2n__-prdslib.numbers.minimum 1
                  ],
                _js2n__-prdslib.enum [ "low", "medium", "high" ]
              ]),
      "_js2n__-:definitions/Priority!predicate"
        | doc "priority: `low`, `medium`, `high` or a value between 1 and 10000"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.maximum 10000,
                  _js2n__-prdslib.numbers.minimum 1
                ],
              _js2n__-prdslib.enum [ "low", "medium", "high" ]
            ],
      "_js2n__-:definitions/PriorityRule!contract"
        | doc "priority rule"
        = {
            conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ConditionString!contract"
              | doc "The list of conditions that needs to match to assign priority to the pull request."
              | optional,
            name | String | doc "Name of the rule." | optional,
            "priority"
              | _js2n__-refsenv."_js2n__-:definitions/Priority!contract"
              | doc "The priority of the pull request."
              | optional,
          },
      "_js2n__-:definitions/PullRequestRule!contract" =
        {
            actions
              | _js2n__-refsenv."_js2n__-:definitions/Actions!contract"
              | doc "A dictionary made of actions that will be executed on the matching pull requests.",
            conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | doc "A list of conditions that must match against the pull request for the rule to be applied.",
            description
              | String
              | doc "The description of the rule. This is not used directly by Mergify."
              | optional,
            name
              | String
              | doc "The name of the rule. This is used when reporting information about a rule. It's not possible to have two rules with the same name.",
          },
      "_js2n__-:definitions/QueueRule!contract" =
        {
            allow_checks_interruption
              | Bool
              | doc "Allow interrupting the ongoing checks when a pull request with higher priority enters in the queue. If false, pull request with higher priority will be inserted just after the pull requests that have checks running."
              | optional,
            allow_inplace_checks
              | Bool
              | doc "Allow to update/rebase the original pull request to check its mergeability when first in the queue and not part of a batch or speculative check."
              | optional,
            allow_queue_branch_edit
              | Bool
              | doc "When creating a branch for a queue, if the code of this branch is edited by an entity external to Mergify, Mergify un-queues all pull requests embarked in the branch and report the issue as a failure. If set to true, Mergify will allow such modifications and trust the content of the branch. Make sure only Mergify and your external application are allowed to edit these branches."
              | optional,
            batch_max_failure_resolution_attempts
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType 'Null
                  ])
              | doc "The number of attempts to resolve a batch failure before dequeueing pull requests. By default, Mergify will attempt to resolve a batch failure by splitting the batch multiple times until it finds the root cause of the failure. You can stop this process earlier by limiting the number of resolution attempts. Setting this to 0 will dequeue all the pull requests from a batch when a batch fails."
              | optional,
            batch_max_wait_time
              | _js2n__-refsenv."_js2n__-:definitions/Duration!contract"
              | doc "The maximum amount of time to wait before creating a batch when the batch is not full."
              | optional,
            batch_size
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.maximum 128,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "The maximum number of pull requests per speculative check in the queue. Must be between 1 and 20."
              | optional,
            branch_protection_injection_mode
              | std.enum.TagOrString
              | [| 'none, '"merge", 'queue |]
              | doc m%"
                Branch protections conditions injection mode to use.
                - `queue` will inject branch protections conditions as required conditions for queuing and merging pull requests.
                - `merge` will inject branch protections conditions as required conditions only for merging pull requests.
                - `none` will disable branch protections. This mode is supported only on queues using a `merge_bot_account` with admin rights.
              "%
              | optional,
            checks_timeout
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                    _js2n__-prdslib.isType 'Null
                  ])
              | doc "The amount of time Mergify waits for pending checks to return before dequeueing pull requests. This cannot be less than 60 seconds."
              | optional,
            commit_message_template
              | _js2n__-refsenv."_js2n__-:definitions/Template!contract"
              | doc "Template to use as the commit message when using the `merge` or `squash` merge method."
              | optional,
            disallow_checks_interruption_from_queues
              | _js2n__-refsenv."_js2n__-:definitions/StringSet!contract"
              | doc "The list of higher priorities queue that are not allowed to interrupt the ongoing checks of this queue."
              | optional,
            draft_bot_account
              | String
              | doc "Mergify can impersonate a GitHub user to create its draft pull requests. If no `draft_bot_account` is set, Mergify creates the draft pull request itself. The user account must have already been logged in Mergify dashboard once and have admin, write or maintain permission."
              | optional,
            merge_bot_account
              | _js2n__-refsenv."_js2n__-:definitions/Template!contract"
              | doc "Mergify can impersonate a GitHub user to merge pull requests. If no `merge_bot_account` is set, Mergify will merge the pull request itself. The user account must have already been logged in Mergify dashboard once and have write or maintain permission."
              | optional,
            merge_conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | doc "The list of conditions to match to get the queued pull request merged. This automatically includes the `queue_conditions`. In case of speculative merge pull request, the merge conditions starting by `check-` are evaluated against the temporary pull request instead of the original one."
              | optional,
            merge_method
              | _js2n__-refsenv."_js2n__-:definitions/MergeMethod!contract"
              | doc "Merge method to use. `fast-forward` is not supported on queues with `speculative_checks > 1`, `batch_size > 1`, or with `allow_inplace_checks` set to false."
              | optional,
            name | String | doc "The name of the merge queue.",
            priority_rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PriorityRule!contract"
              | doc "The list of priority rules a pull request can match in order to be prioritized when added to a queue. The rule with the highest priority value wins."
              | optional,
            queue_branch_merge_method
              | std.enum.TagOrString
              | [| 'fast-forward, 'none |]
              | doc "If set to `fast-forward`, Mergify will merge the draft pull request instead of merging the original pull request that has been checked. This only works when the queue action `merge_method` is set to its default `merge`."
              | optional,
            queue_branch_prefix
              | String
              | doc "The prefix used to name the branch of draft pull requests."
              | optional,
            queue_conditions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RuleCondition!contract"
              | doc "The list of conditions that needs to match to queue the pull request."
              | optional,
            speculative_checks
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.numbers.maximum 128,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "The maximum number of checks to run in parallel in the queue. Must be between 1 and 20."
              | optional,
            update_bot_account
              | _js2n__-refsenv."_js2n__-:definitions/Template!contract"
              | doc m%"
                For rebasing branches, Mergify might have to impersonate a GitHub user. You can specify the account to use with this option. If no `update_bot_account` is set, Mergify uses the author of the PR. The user account must have already been logged in Mergify dashboard once.
                For `update_method: merge` this option will be ignored in order for Mergify to not reset the merge queue, because of the merge commit done has a person instead of a bot.
              "%
              | optional,
            update_method
              | std.enum.TagOrString
              | [| 'rebase, '"merge" |]
              | doc m%"
                Method to use to update the pull request with its base branch when the speculative check is done in-place. Possible values:
                - `merge` to merge the base branch into the pull request.
                - `rebase` to rebase the pull request against its base branch.
              "%
              | optional,
          },
      "_js2n__-:definitions/ReportModeArray!predicate"
        | doc "list of report modes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "check", "comment" ]
                  ])
            ],
      "_js2n__-:definitions/RuleCondition!contract"
        | doc "condition"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.propertyNames
                                (_js2n__-prdslib.enum [ "or", "and", "not" ]),
                              _js2n__-prdslib.records.record {}
                                {
                                  "" =
                                    _js2n__-refsenv."_js2n__-:definitions/RuleCondition!predicate",
                                } false _js2n__-prdslib.never
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/ConditionString!predicate"
                        ])
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.propertyNames
                      (_js2n__-prdslib.enum [ "or", "and", "not" ]),
                    _js2n__-prdslib.records.record {}
                      {
                        "" =
                          _js2n__-refsenv."_js2n__-:definitions/RuleCondition!predicate",
                      } false _js2n__-prdslib.never
                  ],
                _js2n__-refsenv."_js2n__-:definitions/ConditionString!predicate"
              ]),
      "_js2n__-:definitions/RuleCondition!predicate"
        | doc "condition"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.propertyNames
                              (_js2n__-prdslib.enum [ "or", "and", "not" ]),
                            _js2n__-prdslib.records.record {}
                              {
                                "" =
                                  _js2n__-refsenv."_js2n__-:definitions/RuleCondition!predicate",
                              } false _js2n__-prdslib.never
                          ],
                        _js2n__-refsenv."_js2n__-:definitions/ConditionString!predicate"
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.enum [ "or", "and", "not" ]),
                  _js2n__-prdslib.records.record {}
                    {
                      "" =
                        _js2n__-refsenv."_js2n__-:definitions/RuleCondition!predicate",
                    } false _js2n__-prdslib.never
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConditionString!predicate"
            ],
      "_js2n__-:definitions/StringSet!contract"
        | doc "list of string"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.isType '"String"),
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/StringSet!predicate"
        | doc "list of string"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/Template!contract"
        | doc "template"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.isType 'Null
              ]),
      "_js2n__-:definitions/Template!predicate"
        | doc "template"
        = _js2n__-prdslib.oneOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ],
      "_js2n__-:definitions/TemplateArray!predicate"
        | doc "list of template"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Template!predicate"
            ],
    }
    in
  {
      commands_restrictions
        | {
          backport
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          copy
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          dequeue
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          queue
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          rebase
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          refresh
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          requeue
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          squash
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
          update
            | _js2n__-refsenv."_js2n__-:definitions/CommandRestriction!contract"
            | optional,
        }
        | doc "Commands restriction"
        | optional,
      defaults
        | {
          actions
            | _js2n__-refsenv."_js2n__-:definitions/Actions!contract"
            | optional,
          ..
        }
        | optional,
      extends | String | optional,
      merge_protections
        | Array _js2n__-refsenv."_js2n__-:definitions/MergeProtection!contract"
        | optional,
      partition_rules
        | Array _js2n__-refsenv."_js2n__-:definitions/PartitionRule!contract"
        | optional,
      pull_request_rules
        | Array _js2n__-refsenv."_js2n__-:definitions/PullRequestRule!contract"
        | optional,
      queue_rules
        | Array _js2n__-refsenv."_js2n__-:definitions/QueueRule!contract"
        | optional,
      shared
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.isType '"String"
            ])
        | optional,
    }