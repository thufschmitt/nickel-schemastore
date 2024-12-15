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
      "_js2n__-:definitions/collectPeriod!contract"
        | doc "Sets the collect period that MetricsHub uses to collects metrics from the monitored resources (Default: 2m)."
        = _js2n__-refsenv."_js2n__-:definitions/duration!contract",
      "_js2n__-:definitions/collectPeriod!predicate"
        | doc "Sets the collect period that MetricsHub uses to collects metrics from the monitored resources (Default: 2m)."
        = _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
      "_js2n__-:definitions/computes!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "add",
                                        "divide",
                                        "multiply",
                                        "subtract"
                                      ]
                                  ],
                            value =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType '"Number"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "and", "prepend", "append" ]
                                  ],
                            value = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            arraySeparator = _js2n__-prdslib.isType '"String",
                            column = _js2n__-prdslib.isType 'Integer,
                            resultSeparator = _js2n__-prdslib.isType '"String",
                            translationTable = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "arrayTranslate",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            exclude = _js2n__-prdslib.isType '"String",
                            keep = _js2n__-prdslib.isType '"String",
                            script = _js2n__-prdslib.isType '"String",
                            selectColumns = _js2n__-prdslib.isType '"String",
                            separators = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "awk",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            conversion =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "hex2Dec", "array2SimpleStatus" ]
                                  ],
                            type = _js2n__-prdslib.const "convert",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            type = _js2n__-prdslib.const "duplicateColumn",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            regExp = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "excludeOnlyMatchingLines",
                                        "keepOnlyMatchingLines"
                                      ]
                                  ],
                            valueList = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            subColumn = _js2n__-prdslib.isType 'Integer,
                            subSeparators = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "extract",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            property = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.const
                                  "extractPropertyFromWbemPath",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            entryKey = _js2n__-prdslib.isType '"String",
                            properties = _js2n__-prdslib.isType '"String",
                            separator = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "json2Csv",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            bitList = _js2n__-prdslib.isType '"String",
                            column = _js2n__-prdslib.isType 'Integer,
                            translationTable = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "perBitTranslation",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            existingValue = _js2n__-prdslib.isType '"String",
                            newValue = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "replace",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            length = _js2n__-prdslib.isType '"String",
                            start = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "substring",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            column = _js2n__-prdslib.isType 'Integer,
                            translationTable =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {} {}
                                          true
                                          (_js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.isType '"Number"
                                            ])
                                      ]
                                  ],
                            type = _js2n__-prdslib.const "translate",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            properties = _js2n__-prdslib.isType '"String",
                            recordTag = _js2n__-prdslib.isType '"String",
                            type = _js2n__-prdslib.const "xml2Csv",
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
            ],
      "_js2n__-:definitions/discoveryCycle!contract"
        | doc "Sets the cycle that MetricsHub uses to perform discoveries and detect new components in your monitored environment. By default, MetricsHub runs a discovery after 30 collects."
        = std.number.Integer,
      "_js2n__-:definitions/discoveryCycle!predicate"
        | doc "Sets the cycle that MetricsHub uses to perform discoveries and detect new components in your monitored environment. By default, MetricsHub runs a discovery after 30 collects."
        = _js2n__-prdslib.isType 'Integer,
      "_js2n__-:definitions/duration!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType 'Integer,
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^[0-9]+\\s*[years|yrs|y|weeks|wks|w|days|d|hours|hrs|h|minutes|mins|m!seconds|secs|s|milliseconds|ms]*$"
                  ]
              ]),
      "_js2n__-:definitions/duration!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^[0-9]+\\s*[years|yrs|y|weeks|wks|w|days|d|hours|hrs|h|minutes|mins|m!seconds|secs|s|milliseconds|ms]*$"
                ]
            ],
      "_js2n__-:definitions/executeForEachEntryOf!predicate"
        | doc "Execute For Each Entry"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concatMethod =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "list", "json_array", "json_array_extended" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  concatEnd = _js2n__-prdslib.isType '"String",
                                  concatStart =
                                    _js2n__-prdslib.isType '"String",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  source = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/hostname!predicate"
        | doc "The hostname to which the query is sent."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/httpMethod!predicate"
        | doc "HTTP Method"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "get", "post", "delete", "put" ]
            ],
      "_js2n__-:definitions/jobTimeout!contract"
        | doc "Sets how long until the job times out (Default: 5m)."
        = _js2n__-refsenv."_js2n__-:definitions/duration!contract",
      "_js2n__-:definitions/jobTimeout!predicate"
        | doc "Sets how long until the job times out (Default: 5m)."
        = _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
      "_js2n__-:definitions/loggerLevel!contract"
        | doc "Logger Level (Default: error)"
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'off, 'fatal, 'error, 'warn, 'info, 'debug, 'trace, 'all |]
            ],
      "_js2n__-:definitions/loggerLevel!predicate"
        | doc "Logger Level (Default: error)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "all",
                  "trace",
                  "debug",
                  "info",
                  "warn",
                  "error",
                  "fatal",
                  "off"
                ]
            ],
      "_js2n__-:definitions/monitorFilters!contract"
        | doc "Monitor inclusion or exclusion in data collection. This parameter accepts '+<monitor_name>' for inclusion and '!<monitor_name>' for exclusion."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[+!]?[a-zA-Z0-9_.-]+$"
                    ]),
                _js2n__-prdslib.arrays.minItems 1,
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/monitorFilters!predicate"
        | doc "Monitor inclusion or exclusion in data collection. This parameter accepts '+<monitor_name>' for inclusion and '!<monitor_name>' for exclusion."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[+!]?[a-zA-Z0-9_.-]+$"
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/namespace!predicate"
        | doc "Forces a specific namespace for connectors that perform namespace auto-detection (Advanced)."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/resolveHostnameToFqdn!contract"
        | doc "Resolve hostnames to FQDN (Default: false)."
        = Bool,
      "_js2n__-:definitions/resolveHostnameToFqdn!predicate"
        | doc "Resolve hostnames to FQDN (Default: false)."
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/resources!contract"
        | doc "Contains Resources"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {} {} true
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          additionalConnectors =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "^[a-zA-Z0-9_.-]+$" =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  "force" =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  uses =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  variables =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {} {} true
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } false _js2n__-prdslib.never
                                ],
                          alertingSystemConfig =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      disable = _js2n__-prdslib.isType '"Bool",
                                      problemTemplate =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          attributes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType '"Number",
                                        _js2n__-prdslib.isType '"Array"
                                      ])
                                ],
                          collectPeriod =
                            _js2n__-refsenv."_js2n__-:definitions/collectPeriod!predicate",
                          connectors =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          discoveryCycle =
                            _js2n__-refsenv."_js2n__-:definitions/discoveryCycle!predicate",
                          jobTimeout =
                            _js2n__-refsenv."_js2n__-:definitions/jobTimeout!predicate",
                          loggerLevel =
                            _js2n__-refsenv."_js2n__-:definitions/loggerLevel!predicate",
                          metrics =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType '"Number"
                                      ])
                                ],
                          monitorFilters =
                            _js2n__-refsenv."_js2n__-:definitions/monitorFilters!predicate",
                          monitors =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            collect =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        keys =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"Array",
                                                                _js2n__-prdslib.arrays.arrayOf
                                                                  (_js2n__-prdslib.isType
                                                                    '"String")
                                                              ],
                                                        mapping =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    attributes =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                id =
                                                                                  _js2n__-prdslib.isType
                                                                                      '"String",
                                                                              }
                                                                              {}
                                                                              true
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    legacyTextParameters =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                StatusInformation =
                                                                                  _js2n__-prdslib.isType
                                                                                      '"String",
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                    metrics =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {}
                                                                              {}
                                                                              true
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    source =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        sources =
                                                          _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                                        type =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "monoInstance",
                                                                    "multiInstance"
                                                                  ]
                                                              ],
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            discovery =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        mapping =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    attributes =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                id =
                                                                                  _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                name =
                                                                                  _js2n__-prdslib.isType
                                                                                      '"String",
                                                                              }
                                                                              {}
                                                                              true
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    conditionalCollection =
                                                                      _js2n__-prdslib.isType
                                                                          'Record,
                                                                    metrics =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"String",
                                                                            _js2n__-prdslib.records.record
                                                                              {}
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ],
                                                                    source =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        sources =
                                                          _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            simple =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        mapping =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    attributes =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {
                                                                                id =
                                                                                  _js2n__-prdslib.isType
                                                                                      '"String",
                                                                                name =
                                                                                  _js2n__-prdslib.isType
                                                                                      '"String",
                                                                              }
                                                                              {}
                                                                              true
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    conditionalCollection =
                                                                      _js2n__-prdslib.isType
                                                                          'Record,
                                                                    metrics =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Record,
                                                                            _js2n__-prdslib.records.record
                                                                              {}
                                                                              {}
                                                                              true
                                                                              (_js2n__-prdslib.isType
                                                                                '"String")
                                                                          ],
                                                                    source =
                                                                      _js2n__-prdslib.isType
                                                                          '"String",
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                        sources =
                                                          _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ])
                                ],
                          outputDirectory = _js2n__-prdslib.isType '"String",
                          protocols =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      http =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  https =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  port =
                                                    _js2n__-prdslib.isType
                                                        '"Number",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      ipmi =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  bmcKey =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  skipAuth =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      jdbc =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  database =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  port =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Integer,
                                                          _js2n__-prdslib.numbers.maximum
                                                            65535,
                                                          _js2n__-prdslib.numbers.minimum
                                                            1
                                                        ],
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  type =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  url =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      osCommand =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  sudoCommand =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  useSudo =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  useSudoCommands =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      ping =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      snmp =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  community =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  port =
                                                    _js2n__-prdslib.isType
                                                        '"Number",
                                                  retryIntervals =
                                                    _js2n__-refsenv."_js2n__-:definitions/retryIntervals!predicate",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  version =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [ "v1", "v2c" ]
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      snmpv3 =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  authType =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "NO_AUTH",
                                                              "MD5",
                                                              "SHA"
                                                            ]
                                                        ],
                                                  contextName =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  port =
                                                    _js2n__-prdslib.isType
                                                        '"Number",
                                                  privacy =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "DES",
                                                              "AES",
                                                              "none"
                                                            ]
                                                        ],
                                                  privacyPassword =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  retryIntervals =
                                                    _js2n__-refsenv."_js2n__-:definitions/retryIntervals!predicate",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      ssh =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  privateKey =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  sudoCommand =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  useSudo =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  useSudoCommands =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      wbem =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  namespace =
                                                    _js2n__-refsenv."_js2n__-:definitions/namespace!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  port =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                  protocol =
                                                    _js2n__-refsenv."_js2n__-:definitions/transportProtocols!predicate",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      winrm =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  authentications =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "ntlm",
                                                                    "kerberos"
                                                                  ]
                                                              ])
                                                        ],
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  namespace =
                                                    _js2n__-refsenv."_js2n__-:definitions/namespace!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  port =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                  protocol =
                                                    _js2n__-refsenv."_js2n__-:definitions/transportProtocols!predicate",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      wmi =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                  namespace =
                                                    _js2n__-refsenv."_js2n__-:definitions/namespace!predicate",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  timeout =
                                                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                  username =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          resolveHostnameToFqdn =
                            _js2n__-refsenv."_js2n__-:definitions/resolveHostnameToFqdn!predicate",
                          sequential = _js2n__-prdslib.isType '"Bool",
                          stateSetCompression =
                            _js2n__-refsenv."_js2n__-:definitions/stateSetCompression!predicate",
                        } {} true _js2n__-prdslib.always
                    ])
              ]),
      "_js2n__-:definitions/resources!predicate"
        | doc "Contains Resources"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        additionalConnectors =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {}
                                  {
                                    "^[a-zA-Z0-9_.-]+$" =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                "force" =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                uses =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                variables =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {} {} true
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} false _js2n__-prdslib.never
                                          ],
                                  } false _js2n__-prdslib.never
                              ],
                        alertingSystemConfig =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    disable = _js2n__-prdslib.isType '"Bool",
                                    problemTemplate =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        attributes =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Array"
                                    ])
                              ],
                        collectPeriod =
                          _js2n__-refsenv."_js2n__-:definitions/collectPeriod!predicate",
                        connectors =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        discoveryCycle =
                          _js2n__-refsenv."_js2n__-:definitions/discoveryCycle!predicate",
                        jobTimeout =
                          _js2n__-refsenv."_js2n__-:definitions/jobTimeout!predicate",
                        loggerLevel =
                          _js2n__-refsenv."_js2n__-:definitions/loggerLevel!predicate",
                        metrics =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ])
                              ],
                        monitorFilters =
                          _js2n__-refsenv."_js2n__-:definitions/monitorFilters!predicate",
                        monitors =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          collect =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      keys =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      mapping =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  attributes =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              id =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            true
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  legacyTextParameters =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              StatusInformation =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                  metrics =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {}
                                                                            {}
                                                                            true
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  source =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      sources =
                                                        _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                                      type =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "monoInstance",
                                                                  "multiInstance"
                                                                ]
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          discovery =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mapping =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  attributes =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              id =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              name =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            true
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  conditionalCollection =
                                                                    _js2n__-prdslib.isType
                                                                        'Record,
                                                                  metrics =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.records.record
                                                                            {}
                                                                            {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                  source =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      sources =
                                                        _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          simple =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      mapping =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  attributes =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              id =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                              name =
                                                                                _js2n__-prdslib.isType
                                                                                    '"String",
                                                                            } {}
                                                                            true
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  conditionalCollection =
                                                                    _js2n__-prdslib.isType
                                                                        'Record,
                                                                  metrics =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {}
                                                                            {}
                                                                            true
                                                                            (_js2n__-prdslib.isType
                                                                              '"String")
                                                                        ],
                                                                  source =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      sources =
                                                        _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ])
                              ],
                        outputDirectory = _js2n__-prdslib.isType '"String",
                        protocols =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    http =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                https =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                port =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    ipmi =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                bmcKey =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                skipAuth =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    jdbc =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                database =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                port =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer,
                                                        _js2n__-prdslib.numbers.maximum
                                                          65535,
                                                        _js2n__-prdslib.numbers.minimum
                                                          1
                                                      ],
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                type =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                url =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    osCommand =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                sudoCommand =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                useSudo =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                useSudoCommands =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    ping =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    snmp =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                community =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                port =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                retryIntervals =
                                                  _js2n__-refsenv."_js2n__-:definitions/retryIntervals!predicate",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                version =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [ "v1", "v2c" ]
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    snmpv3 =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                authType =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "NO_AUTH",
                                                            "MD5",
                                                            "SHA"
                                                          ]
                                                      ],
                                                contextName =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                port =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                privacy =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "DES",
                                                            "AES",
                                                            "none"
                                                          ]
                                                      ],
                                                privacyPassword =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                retryIntervals =
                                                  _js2n__-refsenv."_js2n__-:definitions/retryIntervals!predicate",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    ssh =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                privateKey =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sudoCommand =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                useSudo =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                useSudoCommands =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    wbem =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                namespace =
                                                  _js2n__-refsenv."_js2n__-:definitions/namespace!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                port =
                                                  _js2n__-prdslib.isType
                                                      'Integer,
                                                protocol =
                                                  _js2n__-refsenv."_js2n__-:definitions/transportProtocols!predicate",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    winrm =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                authentications =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "ntlm",
                                                                  "kerberos"
                                                                ]
                                                            ])
                                                      ],
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                namespace =
                                                  _js2n__-refsenv."_js2n__-:definitions/namespace!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                port =
                                                  _js2n__-prdslib.isType
                                                      'Integer,
                                                protocol =
                                                  _js2n__-refsenv."_js2n__-:definitions/transportProtocols!predicate",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    wmi =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                hostname =
                                                  _js2n__-refsenv."_js2n__-:definitions/hostname!predicate",
                                                namespace =
                                                  _js2n__-refsenv."_js2n__-:definitions/namespace!predicate",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                timeout =
                                                  _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        resolveHostnameToFqdn =
                          _js2n__-refsenv."_js2n__-:definitions/resolveHostnameToFqdn!predicate",
                        sequential = _js2n__-prdslib.isType '"Bool",
                        stateSetCompression =
                          _js2n__-refsenv."_js2n__-:definitions/stateSetCompression!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/resultContent!predicate"
        | doc "Result Content Expected"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "http_status", "header", "body", "all" ]
            ],
      "_js2n__-:definitions/retryIntervals!predicate"
        | doc "An array of retry intervals (in milliseconds) between request retries."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.minimum 0
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/sources!predicate"
        | doc "Contains Sources"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.records.record
                          {
                            authenticationToken =
                              _js2n__-prdslib.isType '"String",
                            body = _js2n__-prdslib.isType '"String",
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            header = _js2n__-prdslib.isType '"String",
                            method =
                              _js2n__-refsenv."_js2n__-:definitions/httpMethod!predicate",
                            path = _js2n__-prdslib.isType '"String",
                            resultContent =
                              _js2n__-refsenv."_js2n__-:definitions/resultContent!predicate",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "http"
                                  ],
                            url = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "ipmi"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            beginAtLineNumber = _js2n__-prdslib.isType 'Integer,
                            commandLine = _js2n__-prdslib.isType '"String",
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            endAtLineNumber = _js2n__-prdslib.isType 'Integer,
                            exclude = _js2n__-prdslib.isType '"String",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            executeLocally = _js2n__-prdslib.isType '"Bool",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            keep = _js2n__-prdslib.isType '"String",
                            selectColumns = _js2n__-prdslib.isType '"String",
                            separator = _js2n__-prdslib.isType '"String",
                            timeout =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.isType '"String"
                                  ],
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "osCommand"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            from = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "copy"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "static"
                                  ],
                            value = _js2n__-prdslib.isType '"String",
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            oid = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "snmpGet"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            oid = _js2n__-prdslib.isType '"String",
                            selectColumns = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "snmpTable"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            defaultRightLine = _js2n__-prdslib.isType '"String",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            isWbemKey = _js2n__-prdslib.isType '"Bool",
                            leftKeyColumn = _js2n__-prdslib.isType 'Integer,
                            leftTable = _js2n__-prdslib.isType '"String",
                            rightKeyColumn = _js2n__-prdslib.isType 'Integer,
                            rightTable = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "tableJoin"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            tables =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "tableUnion"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            namespace = _js2n__-prdslib.isType '"String",
                            query = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "wbem"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            namespace = _js2n__-prdslib.isType '"String",
                            query = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "wmi"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            executeForEachEntryOf =
                              _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            query = _js2n__-prdslib.isType '"String",
                            tables =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              alias =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              columns =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                name =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                number =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                type =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ])
                                                    ],
                                              source =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ])
                                  ],
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "internalDbQuery"
                                  ],
                          } {} true _js2n__-prdslib.always,
                        _js2n__-prdslib.records.record
                          {
                            computes =
                              _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                            forceSerialization = _js2n__-prdslib.isType '"Bool",
                            query = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "sql"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
            ],
      "_js2n__-:definitions/stateSetCompression!contract"
        | doc "Represents the possible compression methods for the state set metrics."
        = std.contract.Sequence
            [ std.enum.TagOrString, [| 'suppressZeros, 'none |] ],
      "_js2n__-:definitions/stateSetCompression!predicate"
        | doc "Represents the possible compression methods for the state set metrics."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "none", "suppressZeros" ]
            ],
      "_js2n__-:definitions/transportProtocols!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "http", "https" ]
            ],
    }
    in
  {
      alertingSystemConfig
        | {
          disable
            | Bool
            | doc "If true, disables the alerting system"
            | optional,
          problemTemplate | String | doc "Problem alerts template" | optional,
          ..
        }
        | doc "Alerting System Configuration"
        | optional,
      attributes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
            ])
        | doc "Top level attributes"
        | optional,
      collectPeriod
        | _js2n__-refsenv."_js2n__-:definitions/collectPeriod!contract"
        | optional,
      discoveryCycle
        | _js2n__-refsenv."_js2n__-:definitions/discoveryCycle!contract"
        | optional,
      jobPoolSize | std.number.Integer | doc "Job Pool Size" | optional,
      jobTimeout
        | _js2n__-refsenv."_js2n__-:definitions/jobTimeout!contract"
        | optional,
      license
        | {
          expiresOn
            | String
            | doc "The expiration date of the license in the format yyyy-MM-dd."
            | optional,
          key | String | doc "The license key" | optional,
          organization
            | String
            | doc "The name of the organization the license is for."
            | optional,
          product
            | String
            | doc "The name of the product the license is for."
            | optional,
          resources
            | std.number.Integer
            | doc "The maximum number of resources the license covers."
            | optional,
          ..
        }
        | doc "MetricsHub License"
        | optional,
      loggerLevel
        | _js2n__-refsenv."_js2n__-:definitions/loggerLevel!contract"
        | optional,
      metrics
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
            ])
        | doc "Top level metrics"
        | optional,
      monitorFilters
        | _js2n__-refsenv."_js2n__-:definitions/monitorFilters!contract"
        | optional,
      otel
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "otel.exporter.otlp.certificate" =
                    _js2n__-prdslib.isType '"String",
                  "otel.exporter.otlp.endpoint" =
                    _js2n__-prdslib.isType '"String",
                  "otel.exporter.otlp.logs.certificate" =
                    _js2n__-prdslib.isType '"String",
                  "otel.exporter.otlp.logs.endpoint" =
                    _js2n__-prdslib.isType '"String",
                  "otel.exporter.otlp.logs.protocol" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "grpc", "http/protobuf" ]
                        ],
                  "otel.exporter.otlp.metrics.certificate" =
                    _js2n__-prdslib.isType '"String",
                  "otel.exporter.otlp.metrics.endpoint" =
                    _js2n__-prdslib.isType '"String",
                  "otel.exporter.otlp.metrics.protocol" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "grpc", "http/protobuf" ]
                        ],
                  "otel.exporter.otlp.protocol" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "grpc", "http/protobuf" ]
                        ],
                  "otel.logs.exporter" = _js2n__-prdslib.isType '"String",
                  "otel.metrics.exporter" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "otlp"
                        ],
                } {} true (_js2n__-prdslib.isType '"String")
            ])
        | doc "Internal OpenTelemetry SDK configuration"
        | optional,
      otelCollector
        | {
          commandLine
            | Array (String)
            | doc "Overrides the OpenTelemetry Collector command line."
            | optional,
          disabled
            | Bool
            | doc "Disables the OpenTelemetry Collector (Default: false)."
            | optional,
          environment
            | {  .. }
            | doc "Configures the OpenTelemetry Collector environment variables."
            | optional,
          output
            | std.enum.TagOrString
            | [| 'silent, 'console, 'log |]
            | doc "Configures where to print the OpenTelemetry Collector's output (Default: log)."
            | optional,
          workingDir
            | String
            | doc "Configures the working directory of the OpenTelemetry Collector."
            | optional,
          ..
        }
        | doc "Customizes the OpenTelemetry Collector sub-process."
        | optional,
      outputDirectory | String | doc "Output directory" | optional,
      patchDirectory
        | String
        | doc "The path of the custom connectors directory, connectors will also be loaded from the default directory."
        | optional,
      resolveHostnameToFqdn
        | _js2n__-refsenv."_js2n__-:definitions/resolveHostnameToFqdn!contract"
        | optional,
      resourceGroups
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        alertingSystemConfig =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    disable = _js2n__-prdslib.isType '"Bool",
                                    problemTemplate =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ],
                        attributes =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Array"
                                    ])
                              ],
                        collectPeriod =
                          _js2n__-refsenv."_js2n__-:definitions/collectPeriod!predicate",
                        discoveryCycle =
                          _js2n__-refsenv."_js2n__-:definitions/discoveryCycle!predicate",
                        jobTimeout =
                          _js2n__-refsenv."_js2n__-:definitions/jobTimeout!predicate",
                        loggerLevel =
                          _js2n__-refsenv."_js2n__-:definitions/loggerLevel!predicate",
                        metrics =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {} {} true
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ])
                              ],
                        monitorFilters =
                          _js2n__-refsenv."_js2n__-:definitions/monitorFilters!predicate",
                        outputDirectory = _js2n__-prdslib.isType '"String",
                        resolveHostnameToFqdn =
                          _js2n__-refsenv."_js2n__-:definitions/resolveHostnameToFqdn!predicate",
                        resources =
                          _js2n__-refsenv."_js2n__-:definitions/resources!predicate",
                        sequential = _js2n__-prdslib.isType '"Bool",
                        stateSetCompression =
                          _js2n__-refsenv."_js2n__-:definitions/stateSetCompression!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Contains Resource Groups"
        | optional,
      resources
        | _js2n__-refsenv."_js2n__-:definitions/resources!contract"
        | optional,
      sequential
        | Bool
        | doc "Sequential mode. This forces all network calls to be ordered in a sequential order."
        | optional,
      stateSetCompression
        | _js2n__-refsenv."_js2n__-:definitions/stateSetCompression!contract"
        | optional,
      ..
    }