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
                                        "excludeMatchingLines",
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
                            columnNumbers = _js2n__-prdslib.isType '"String",
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "keepColumns"
                                  ],
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
                            translationTable = _js2n__-prdslib.isType '"String",
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
      "_js2n__-:definitions/deviceKind!contract"
        | doc "Device Types"
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'other,
                'oob,
                'vms,
                'storage,
                'rs6000,
                'sunos,
                'solaris,
                'osf1,
                'linux,
                'nt,
                'hp
              |]
            ],
      "_js2n__-:definitions/deviceKind!predicate"
        | doc "Device Types"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "hp",
                  "nt",
                  "linux",
                  "osf1",
                  "solaris",
                  "sunos",
                  "rs6000",
                  "storage",
                  "vms",
                  "oob",
                  "other"
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
      "_js2n__-:definitions/httpMethod!predicate"
        | doc "HTTP Method"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "get", "post", "delete", "put" ]
            ],
      "_js2n__-:definitions/resultContent!predicate"
        | doc "Result Content Expected"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "http_status", "header", "body", "all" ]
            ],
      "_js2n__-:definitions/sources!contract"
        | doc "Contains Sources"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.const "ipmi"
                                    ],
                            } {} true _js2n__-prdslib.always,
                          _js2n__-prdslib.records.record
                            {
                              beginAtLineNumber =
                                _js2n__-prdslib.isType 'Integer,
                              commandLine = _js2n__-prdslib.isType '"String",
                              computes =
                                _js2n__-refsenv."_js2n__-:definitions/computes!predicate",
                              endAtLineNumber = _js2n__-prdslib.isType 'Integer,
                              exclude = _js2n__-prdslib.isType '"String",
                              executeForEachEntryOf =
                                _js2n__-refsenv."_js2n__-:definitions/executeForEachEntryOf!predicate",
                              executeLocally = _js2n__-prdslib.isType '"Bool",
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
                              keep = _js2n__-prdslib.isType '"String",
                              selectColumns = _js2n__-prdslib.isType '"String",
                              separator = _js2n__-prdslib.isType '"String",
                              timeout = _js2n__-prdslib.isType 'Integer,
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.const "commandLine"
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              defaultRightLine =
                                _js2n__-prdslib.isType '"String",
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                              forceSerialization =
                                _js2n__-prdslib.isType '"Bool",
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
                                      _js2n__-prdslib.const "sql"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ]
                    ])
              ]),
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
                            timeout = _js2n__-prdslib.isType 'Integer,
                            type =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.const "commandLine"
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
                                    _js2n__-prdslib.const "sql"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]
                  ])
            ],
    }
    in
  {
      connector
        | {
          detection
            | {
              appliesTo
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/deviceKind!contract"
                | doc "Connector OS Compatibility List (Comma-separated)"
                | optional,
              connectionTypes
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum [ "remote", "local" ]
                          ])
                    ])
                | optional,
              criteria
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.records.record
                              {
                                exclude =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          _js2n__-refsenv."_js2n__-:definitions/deviceKind!predicate"
                                      ],
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                keep =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          _js2n__-refsenv."_js2n__-:definitions/deviceKind!predicate"
                                      ],
                                type = _js2n__-prdslib.const "deviceType",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                authenticationToken =
                                  _js2n__-prdslib.isType '"String",
                                body = _js2n__-prdslib.isType '"String",
                                errorMessage = _js2n__-prdslib.isType '"String",
                                expectedResult =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                header = _js2n__-prdslib.isType '"String",
                                method =
                                  _js2n__-refsenv."_js2n__-:definitions/httpMethod!predicate",
                                path = _js2n__-prdslib.isType '"String",
                                resultContent =
                                  _js2n__-refsenv."_js2n__-:definitions/resultContent!predicate",
                                type = _js2n__-prdslib.const "http",
                                url = _js2n__-prdslib.isType '"String",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                type = _js2n__-prdslib.const "ipmi",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                commandLine = _js2n__-prdslib.isType '"String",
                                errorMessage = _js2n__-prdslib.isType '"String",
                                executeLocally = _js2n__-prdslib.isType '"Bool",
                                expectedResult =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                timeout = _js2n__-prdslib.isType 'Integer,
                                type = _js2n__-prdslib.const "commandLine",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                commandLine = _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                type = _js2n__-prdslib.const "process",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                engineVersion =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                kmVersion = _js2n__-prdslib.isType '"String",
                                type =
                                  _js2n__-prdslib.const "productRequirements",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                name = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.const "service",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                expectedResult =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                oid = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.const "snmpGet",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                expectedResult =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                oid = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.const "snmpGetNext",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                errorMessage = _js2n__-prdslib.isType '"String",
                                expectedResult =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                namespace = _js2n__-prdslib.isType '"String",
                                query = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.const "wbem",
                              } {} true _js2n__-prdslib.always,
                            _js2n__-prdslib.records.record
                              {
                                errorMessage = _js2n__-prdslib.isType '"String",
                                expectedResult =
                                  _js2n__-prdslib.isType '"String",
                                forceSerialization =
                                  _js2n__-prdslib.isType '"Bool",
                                namespace = _js2n__-prdslib.isType '"String",
                                query = _js2n__-prdslib.isType '"String",
                                type = _js2n__-prdslib.const "wmi",
                              } {} true _js2n__-prdslib.always
                          ]
                      ])
                )
                | optional,
              disableAutoDetection
                | Bool
                | doc "Disable Auto Detection"
                | optional,
              onLastResort
                | String
                | doc "Last Resort Only (Activates if no connector contains specified monitor type)"
                | optional,
              supersedes
                | Array (String)
                | doc "Superseded Connector List"
                | optional,
              ..
            }
            | optional,
          displayName | String | doc "Connector Display Name" | optional,
          information | String | doc "Connector Short Description" | optional,
          platforms
            | String
            | doc "Connector Typical Platform Description"
            | optional,
          projectVersion
            | String
            | doc "Connector Library Project Version"
            | optional,
          reliesOn | String | doc "Connector Prerequisites" | optional,
          version | String | doc "Connector Current Version" | optional,
          ..
        }
        | doc "Connector Identity Properties"
        | optional,
      constants
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "Declared Connector Constants"
        | optional,
      extends | Array (String) | doc "Connectors Extended" | optional,
      metrics
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
                        description = _js2n__-prdslib.isType '"String",
                        type =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "Gauge", "Counter", "UpDownCounter" ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        output =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "Gauge",
                                                    "Counter",
                                                    "UpDownCounter"
                                                  ]
                                              ],
                                        stateSet =
                                          _js2n__-prdslib.isType '"Array",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ],
                        unit = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "OpenTelemetry Metrics Collected"
        | optional,
      monitors
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  battery =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.battery.charge" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.battery.time_left" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"battery\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  chemistry =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      conditionalCollection =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      executionOrder =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  chemistry =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.battery.charge" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.battery.time_left" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"battery\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  blade =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.power_state{hw.type=\"blade\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"blade\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  blade_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      conditionalCollection =
                                                        _js2n__-prdslib.isType
                                                            'Record,
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.power_state{hw.type=\"blade\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"blade\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  blade_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  cpu =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.cpu.speed" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.energy{hw.type=\"cpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"cpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"cpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"cpu\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"cpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.cpu.speed.limit{limit_type=\"max\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"cpu\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"cpu\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  disk_controller =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
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
                                                                {} {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      executionOrder =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.status{hw.type=\"disk_controller\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  bios_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  controller_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  driver_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  firmware_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.status{hw.type=\"disk_controller\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  bios_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  controller_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  driver_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  firmware_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  enclosure =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.enclosure.energy" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.enclosure.power" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power_state{hw.type=\"enclosure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"enclosure\", state=\"open\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"enclosure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  bios_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  device_hostname =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  bios_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  device_hostname =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.enclosure.energy" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.enclosure.power" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power_state{hw.type=\"enclosure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"enclosure\", state=\"open\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"enclosure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  fan =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.fan.speed" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed_ratio" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"fan\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sensor_location =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.fan.speed" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed.limit{limit_type=\"low.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed.limit{limit_type=\"low.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed_ratio" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed_ratio.limit{limit_type=\"low.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed_ratio.limit{limit_type=\"low.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"fan\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sensor_location =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.fan.speed.limit{limit_type=\"low.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed.limit{limit_type=\"low.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed_ratio.limit{limit_type=\"low.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.fan.speed_ratio.limit{limit_type=\"low.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  gpu =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.energy{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"gpu\", hw.error.type=\"corrected\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.io{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.io{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"decoder\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"encoder\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"general\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"gpu\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  driver_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  firmware_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.gpu.memory.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  driver_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  firmware_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.energy{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"gpu\", hw.error.type=\"corrected\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.io{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.io{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"decoder\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"encoder\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"general\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"gpu\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  led =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.led.indicator" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"led\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __blinking_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __off_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __on_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  color =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __blinking_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __off_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __on_status =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  color =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.energy{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"gpu\", hw.error.type=\"corrected\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.io{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.io{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.memory.utilization.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"decoder\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"encoder\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.gpu.utilization{task=\"general\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.led.indicator" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"gpu\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"gpu\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"led\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  logical_disk =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors{hw.type=\"logical_disk\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.logical_disk.usage{state=\"free\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"logical_disk\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __use_for_capacity_report =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  raid_level =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      conditionalCollection =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      executionOrder =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.logical_disk.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  __use_for_capacity_report =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  raid_level =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors{hw.type=\"logical_disk\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.logical_disk.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.logical_disk.usage{state=\"free\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"logical_disk\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  lun =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                  AvailablePathInformation =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  StatusInformation =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.lun." =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.lun.paths" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"lun\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  array_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  local_device_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  remote_device_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  wwn =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.lun.paths.limit{limit_type=\"low.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  array_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  local_device_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  remote_device_name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  wwn =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.lun." =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.lun.paths" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.lun.paths.limit{limit_type=\"low.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"lun\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  memory =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors{hw.type=\"memory\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.status{hw.type=\"memory\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.status{hw.type=\"memory\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      conditionalCollection =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      executionOrder =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"Array",
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                (_js2n__-prdslib.isType
                                                                  '"String")
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors.limit{hw.type=\"memory\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"memory\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.memory.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors.limit{hw.type=\"memory\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"memory\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"memory\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.memory.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"memory\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.status{hw.type=\"memory\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  network =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors{hw.type=\"network\", hw.error.type=\"zero_buffer_credit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"network\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.bandwidth.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.full_duplex" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.io{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.io{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.packets{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.packets{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.up" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"network\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  bandwidth =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  device_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  logical_address =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  logical_address_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  physical_address =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  physical_address_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  bandwidth =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  device_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  logical_address =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  logical_address_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  physical_address =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  physical_address_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors{hw.type=\"network\", hw.error.type=\"zero_buffer_credit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"network\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.bandwidth.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.full_duplex" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.io{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.io{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.packets{direction=\"receive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.packets{direction=\"transmit\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.network.up" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"network\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  other_device =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.energy{hw.type=\"other_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.uses" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.value" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"other_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"other_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  additional_label =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.other_device.uses.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.uses.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.value.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.value.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  additional_label =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.energy{hw.type=\"other_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.uses" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.uses.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.uses.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.value" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.value.limit{limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.other_device.value.limit{limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"other_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"other_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  physical_disk =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"device_not_ready\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"hard\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"illegal_request\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"media\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"no_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"recoverable\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"transport\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.physical_disk.endurance_utilization{state=\"remaining\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"physical_disk\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"physical_disk\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  firmware_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  firmware_version =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"device_not_ready\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"hard\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"illegal_request\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"media\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"no_device\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"recoverable\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"physical_disk\", hw.error.type=\"transport\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.physical_disk.endurance_utilization{state=\"remaining\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"physical_disk\", state=\"predicted_failure\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"physical_disk\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  power_supply =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.power_supply.power" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power_supply.utilization" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"power_supply\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  power_supply_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.power_supply.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  power_supply_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.power_supply.limit" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power_supply.power" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power_supply.utilization" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"power_supply\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  robotics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors{hw.type=\"robotics\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.robotics.moves" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"robotics\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  robotics_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors.limit{hw.type=\"robotics\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"robotics\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  robotics_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors.limit{hw.type=\"robotics\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"robotics\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"robotics\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"Number",
                                                                  "hw.robotics.moves" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"robotics\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  tape_drive =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.errors{hw.type=\"tape_drive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"tape_drive\", state=\"needs_cleaning\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"tape_drive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.tape_drive.operations{type=\"mount\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.tape_drive.operations{type=\"unmount\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors.limit{hw.type=\"tape_drive\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"tape_drive\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  model =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  serial_number =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  vendor =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.errors.limit{hw.type=\"tape_drive\", limit_type=\"critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors.limit{hw.type=\"tape_drive\", limit_type=\"degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.errors{hw.type=\"tape_drive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"tape_drive\", state=\"needs_cleaning\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.status{hw.type=\"tape_drive\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.tape_drive.operations{type=\"mount\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.tape_drive.operations{type=\"unmount\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  temperature =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.status{hw.type=\"temperature\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.temperature" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sensor_location =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.temperature.limit{limit_type=\"high.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.temperature.limit{limit_type=\"high.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sensor_location =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.status{hw.type=\"temperature\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.temperature" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.temperature.limit{limit_type=\"high.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.temperature.limit{limit_type=\"high.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  vm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.power_state{hw.type=\"vm\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"vm\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.vm.power_ratio" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  additionalProperties =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "vm.host.name" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
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
                                                                {} {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  additionalProperties =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "vm.host.name" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
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
                                                                {
                                                                  "hw.power_state{hw.type=\"vm\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.power{hw.type=\"vm\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.vm.power_ratio" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  voltage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              collect =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
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
                                                                {} {} true
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
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                      metrics =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  "hw.status{hw.type=\"voltage\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.voltage" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              discovery =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sensor_location =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.voltage.limit{limit_type=\"high.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.voltage.limit{limit_type=\"low.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                              simple =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          executionOrder =
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
                                                                  __display_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.id" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.parent.type" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  info =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sensor_location =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                                                {
                                                                  "hw.status{hw.type=\"voltage\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.voltage" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.voltage.limit{limit_type=\"high.degraded\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  "hw.voltage.limit{limit_type=\"low.critical\"}" =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
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
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        collect =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    executionOrder =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    keys =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    mapping =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
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
                                                          } {} true
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
                                                          } {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                metrics =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {} {} true
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                source =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    sources =
                                      _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                    type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "monoInstance",
                                                "multiInstance"
                                              ]
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                        discovery =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    executionOrder =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    mapping =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
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
                                                          } {} true
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
                                                          {} {} true
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                source =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    sources =
                                      _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                  } {} true _js2n__-prdslib.always
                              ],
                        simple =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    executionOrder =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    mapping =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
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
                                                          } {} true
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
                                                          {} {} true
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                source =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    sources =
                                      _js2n__-refsenv."_js2n__-:definitions/sources!predicate",
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            ])
        | doc "Monitor Identity Properties"
        | optional,
      pre | _js2n__-refsenv."_js2n__-:definitions/sources!contract" | optional,
      sudoCommands | Array (String) | doc "Sudo-able Commands" | optional,
      translations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
            ])
        | doc "Contains Translation Tables"
        | optional,
      ..
    }