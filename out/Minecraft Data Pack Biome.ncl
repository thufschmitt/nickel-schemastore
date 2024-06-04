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
      "_js2n__-:definitions/spawner-options!contract"
        | doc m%"
          Spawner options for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          maxCount =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          minCount =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          type = _js2n__-prdslib.isType '"String",
                          weight =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} false _js2n__-prdslib.never
                    ]),
                _js2n__-prdslib.arrays.uniqueItems
              ]),
    }
    in
  {
      carvers
        | {
          air
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              Carvers used during air generation step for the current biome
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          liquid
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc m%"
              Carvers used during liquid generation step for the current biome
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
        }
        | doc m%"
          Carvers to use for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      category
        | std.enum.TagOrString
        | [|
          'nether,
          'mushroom,
          'swamp,
          'river,
          'desert,
          'ocean,
          'forest,
          'beach,
          'the_end,
          'icy,
          'savanna,
          'plains,
          'mesa,
          'jungle,
          'extreme_hills,
          'taiga,
          'none
        |]
        | optional,
      creature_spawn_friendly
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 1,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          Spawns passive mobs as long as random value is less than this
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      creature_spawn_probability
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.exclusiveMaximum 1,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          A creature spawn probability for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      depth
        | Number
        | doc m%"
          Used for terrain noise generation. Biomes with positive depth are considered land, biomes with negative depth are oceans
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      downfall
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 1,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc m%"
          A grass and foliage color for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      effects
        | {
          additions_sound
            | {
              sound
                | String
                | doc m%"
                  Sound event to use
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
              tick_chance | std.number.Integer | optional,
              ..
            }
            | doc m%"
              Settings for additions sound
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          ambient_sound
            | String
            | doc m%"
              Sound event to use for ambient sound
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          fog_color
            | std.number.Integer
            | doc m%"
              A fog color
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          foliage_color
            | std.number.Integer
            | doc m%"
              Decimal value converted from Hex color to use for tree leaves and vines. If not present, the value depends on humidity and temperature
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          grass_color
            | std.number.Integer
            | doc m%"
              A grass color
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          grass_color_modifier
            | std.enum.TagOrString
            | [| 'swamp, 'dark_forest, 'none |]
            | doc m%"
              A grass color modifier
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          mood_sound
            | {
              block_search_context
                | std.number.Integer
                | doc m%"
                  Determines the cubic range of possible positions to play the mood sound. The player is at the center of the cubic range, and the edge length is 2 * block_search_extent + 1
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
              offset | std.number.Integer | optional,
              sound
                | String
                | doc m%"
                  Sound event to use
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
              tick_delay | std.number.Integer | optional,
              ..
            }
            | doc m%"
              Settings for mood sound
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          music
            | {
              max_delay | std.number.Integer | optional,
              min_delay | std.number.Integer | optional,
              replace_current_music
                | Bool
                | doc m%"
                  Whether or not to replace music which is already playing
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
              sound
                | String
                | doc m%"
                  Sound event to use
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
              ..
            }
            | doc m%"
              Specific music that should be played in the biome
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          particle
            | {
              options
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "item", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                Count =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                id =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.minLength 1
                                      ],
                                tag =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.minLength 1
                                      ],
                                type = _js2n__-prdslib.isType '"String",
                                value =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            Name =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "dust", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                color =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.maximum 1,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ]),
                                        _js2n__-prdslib.arrays.maxItems 3,
                                        _js2n__-prdslib.arrays.minItems 3
                                      ],
                                scale = _js2n__-prdslib.isType '"Number",
                                type = _js2n__-prdslib.isType '"String",
                                value =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            Name =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              {
                                type =
                                  _js2n__-prdslib.const "dust_color_transition",
                              } {} true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                fromColor =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.maximum 1,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ]),
                                        _js2n__-prdslib.arrays.maxItems 3,
                                        _js2n__-prdslib.arrays.minItems 3
                                      ],
                                scale = _js2n__-prdslib.isType '"Number",
                                toColor =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.maximum 1,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ]),
                                        _js2n__-prdslib.arrays.maxItems 3,
                                        _js2n__-prdslib.arrays.minItems 3
                                      ],
                                type = _js2n__-prdslib.isType '"String",
                                value =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            Name =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "sculk_charge", }
                              {} true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                roll = _js2n__-prdslib.isType '"Number",
                                type = _js2n__-prdslib.isType '"String",
                                value =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            Name =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "vibration", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                arrival_in_ticks =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                destination =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.ifThenElse
                                              (_js2n__-prdslib.records.record
                                                {
                                                  type =
                                                    _js2n__-prdslib.const
                                                        "block",
                                                } {} true
                                                _js2n__-prdslib.always)
                                              (_js2n__-prdslib.records.record
                                                {
                                                  pos =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              'Integer),
                                                          _js2n__-prdslib.arrays.maxItems
                                                            3,
                                                          _js2n__-prdslib.arrays.minItems
                                                            3
                                                        ],
                                                  type = _js2n__-prdslib.always,
                                                  y_offset =
                                                    _js2n__-prdslib.isType
                                                        '"Number",
                                                } {} false
                                                _js2n__-prdslib.never)
                                              _js2n__-prdslib.always,
                                            _js2n__-prdslib.ifThenElse
                                              (_js2n__-prdslib.records.record
                                                {
                                                  type =
                                                    _js2n__-prdslib.const
                                                        "entity",
                                                } {} true
                                                _js2n__-prdslib.always)
                                              (_js2n__-prdslib.records.record
                                                {
                                                  source_entity =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              'Integer),
                                                          _js2n__-prdslib.arrays.maxItems
                                                            4,
                                                          _js2n__-prdslib.arrays.minItems
                                                            4
                                                        ],
                                                  type = _js2n__-prdslib.always,
                                                  y_offset =
                                                    _js2n__-prdslib.isType
                                                        '"Number",
                                                } {} false
                                                _js2n__-prdslib.never)
                                              _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.always,
                                            y_offset =
                                              _js2n__-prdslib.isType '"Number",
                                          } {} true _js2n__-prdslib.always
                                      ],
                                type = _js2n__-prdslib.isType '"String",
                                value =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            Name =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "shriek", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                delay = _js2n__-prdslib.isType 'Integer,
                                type = _js2n__-prdslib.isType '"String",
                                value =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            Name =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ],
                                          } {} true _js2n__-prdslib.always
                                      ],
                              } {} false _js2n__-prdslib.never)
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.records.record
                        {
                          type = _js2n__-prdslib.isType '"String",
                          value =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      Name =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                1
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ])
                | doc m%"
                  A particle type for the current biome
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
              probability
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.numbers.maximum 1,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc m%"
                  A particle spawning frequency for the current biome
                  https://minecraft.wiki/w/Custom_biome
                "%
                | optional,
            }
            | doc m%"
              Particle options for the current biome
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          sky_color
            | std.number.Integer
            | doc m%"
              A sky color
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          water_color
            | std.number.Integer
            | doc m%"
              A water color
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
          water_fog_color
            | std.number.Integer
            | doc m%"
              Decimal value converted from Hex color to use for fog
              https://minecraft.wiki/w/Custom_biome
            "%
            | optional,
        }
        | doc m%"
          Effect options for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      features
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Array"
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Features for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      has_precipitation
        | Bool
        | doc "Controls if the current biome has precipitation"
        | optional,
      player_spawn_friendly | Bool | optional,
      scale
        | Number
        | doc m%"
          Used for terrain noise generation. Vertically stretches the terrain. Lower values produce flatter terrain
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      spawn_costs
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
                        charge =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.numbers.minimum 0
                              ],
                        energy_budget =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.numbers.minimum 0
                              ],
                      } {} false _js2n__-prdslib.never
                  ])
            ])
        | doc m%"
          Entity identifiers for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      spawners
        | {
          ambient
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          axolotls
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          creature
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          misc
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          monster
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          underground_water_creature
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          water_ambient
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
          water_creature
            | _js2n__-refsenv."_js2n__-:definitions/spawner-options!contract"
            | optional,
        }
        | doc m%"
          Entity spawning options for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      starts
        | Array (String)
        | doc m%"
          The structures to generate in this biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      surface_builder
        | String
        | doc m%"
          The namespaced id of the configured surface builder to use
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      temperature
        | Number
        | doc m%"
          A temperature for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      temperature_modifier
        | std.enum.TagOrString
        | [| 'frozen, 'none |]
        | doc m%"
          A temperature modifier for the current biome
          https://minecraft.wiki/w/Custom_biome
        "%
        | optional,
      ..
    }