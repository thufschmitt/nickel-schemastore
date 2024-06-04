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
      "_js2n__-:definitions/addressConfigDef!predicate"
        | doc "Datapoint address configuration object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "dataType",
                  "originAccessType",
                  "originAddress",
                  "originDataType",
                  "originType",
                  "pollingGroup",
                  "receiveMode"
                ],
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/dataTypeDef!predicate",
                  originAccessType =
                    _js2n__-refsenv."_js2n__-:definitions/originAccessTypeDef!predicate",
                  originAddress =
                    _js2n__-refsenv."_js2n__-:definitions/originAddressDef!predicate",
                  originDataType =
                    _js2n__-refsenv."_js2n__-:definitions/originDataTypeDef!predicate",
                  originType =
                    _js2n__-refsenv."_js2n__-:definitions/originTypeDef!predicate",
                  pollingGroup =
                    _js2n__-refsenv."_js2n__-:definitions/pollingGroupDef!predicate",
                  receiveMode =
                    _js2n__-refsenv."_js2n__-:definitions/receiveModeDef!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/alertConfigDef!predicate"
        | doc "Allows to configure trigger of alarms and events depending on the datapoint values"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "evaluations" ],
              _js2n__-prdslib.records.record
                {
                  evaluations =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/evaluationForLogsDef!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/evaluationForAlarmsDef!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/auditedDef!predicate"
        | doc "Flag indication for audit process"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/broadcastDef!predicate"
        | doc "Flag to indicate that the alarm/datapointSet will be broadcasted to NetinHUB channels"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/calcConfig!predicate"
        | doc "Allows to create new datapoints based on an expression"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record
                {
                  expression =
                    _js2n__-refsenv."_js2n__-:definitions/expressionDef!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/commonConfigDef!predicate"
        | doc "Datapoint common configuration object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "datapointId", "datapointType" ],
              _js2n__-prdslib.records.record
                {
                  additionalProperties = _js2n__-prdslib.never,
                  alias =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 80,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  datapointId =
                    _js2n__-refsenv."_js2n__-:definitions/datapointIdDef!predicate",
                  datapointType =
                    _js2n__-refsenv."_js2n__-:definitions/datapointTypeDef!predicate",
                  description =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 1200,
                          _js2n__-prdslib.strings.minLength 0
                        ],
                  syntaxInfo =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 1200,
                          _js2n__-prdslib.strings.minLength 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/convConfigDef!predicate"
        | doc "Allows to apply enrichment expressions on the value field"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression" ],
              _js2n__-prdslib.records.record
                {
                  expression =
                    _js2n__-refsenv."_js2n__-:definitions/expressionDef!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dataTypeDef!predicate"
        | doc "Define the type of the data in the NetinDS context, this means how NetinDS will manage the data before the conversions"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "BYTE",
                  "INTEGER",
                  "LONG",
                  "FLOAT",
                  "DOUBLE",
                  "STRING",
                  "BOOLEAN",
                  "DATE",
                  "ARRAY",
                  "INTEGER_ARRAY",
                  "STRING_ARRAY",
                  "DOUBLE_ARRAY",
                  "BOOLEAN_ARRAY",
                  "FLOAT_ARRAY",
                  "LONG_ARRAY",
                  "OBJECT"
                ]
            ],
      "_js2n__-:definitions/datapointConfigDef!predicate"
        | doc "Object that define a complete datapoint configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "commonConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        datapointType =
                                          _js2n__-prdslib.const "#TIMEPOINT",
                                      } {} true _js2n__-prdslib.always
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "addressConfig", "commonConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            addressConfig =
                              _js2n__-refsenv."_js2n__-:definitions/addressConfigDef!predicate",
                            commonConfig =
                              _js2n__-refsenv."_js2n__-:definitions/commonConfigDef!predicate",
                          } {} false _js2n__-prdslib.never
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "calcConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.records.required
                            [ "addressConfig", "commonConfig" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "addressConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.records.required
                            [ "calcConfig", "commonConfig" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "addressConfig", "calcConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.records.required
                            [ "commonConfig", "defaultValueConfig" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "calcConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.records.required
                            [
                              "commonConfig",
                              "defaultValueConfig, addressConfig"
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "addressConfig" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.records.required
                            [
                              "calcConfig",
                              "commonConfig",
                              "defaultValueConfig"
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  addressConfig =
                    _js2n__-refsenv."_js2n__-:definitions/addressConfigDef!predicate",
                  alertConfig =
                    _js2n__-refsenv."_js2n__-:definitions/alertConfigDef!predicate",
                  calcConfig =
                    _js2n__-refsenv."_js2n__-:definitions/calcConfig!predicate",
                  commonConfig =
                    _js2n__-refsenv."_js2n__-:definitions/commonConfigDef!predicate",
                  convConfig =
                    _js2n__-refsenv."_js2n__-:definitions/convConfigDef!predicate",
                  defaultValueConfig =
                    _js2n__-refsenv."_js2n__-:definitions/defaultValueConfigDef!predicate",
                  rowFilterConfig =
                    _js2n__-refsenv."_js2n__-:definitions/rowFilterConfigDef!predicate",
                  unitsConfig =
                    _js2n__-refsenv."_js2n__-:definitions/unitsConfigDef!predicate",
                  valueMapConfig =
                    _js2n__-refsenv."_js2n__-:definitions/valueMapConfigDef!predicate",
                } {} true (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/datapointIdDef!predicate"
        | doc "Datapoint identification string"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9#&_-]{1,80}$"
            ],
      "_js2n__-:definitions/datapointSetConfigDef!predicate"
        | doc "DatapointSet configuration object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  {
                    datapointSetType =
                      _js2n__-prdslib.enum [ "tableStatic", "tableDynamic" ],
                  } {} true _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "tableAddress" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.records.required
                [
                  "alias",
                  "datapointSetId",
                  "datapointSetType",
                  "datapoints",
                  "description"
                ],
              _js2n__-prdslib.records.record
                {
                  alias =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 80,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  broadcast =
                    _js2n__-refsenv."_js2n__-:definitions/broadcastDef!predicate",
                  datapointSetId =
                    _js2n__-refsenv."_js2n__-:definitions/datapointSetIdDef!predicate",
                  datapointSetType =
                    _js2n__-refsenv."_js2n__-:definitions/datapointSetTypeDef!predicate",
                  datapoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/datapointConfigDef!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  description =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 1200,
                          _js2n__-prdslib.strings.minLength 0
                        ],
                  routing =
                    _js2n__-refsenv."_js2n__-:definitions/routingDef!predicate",
                  tableAddress =
                    _js2n__-refsenv."_js2n__-:definitions/tableAddressDef!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/datapointSetIdDef!predicate"
        | doc "DatapointSet identification string"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_-]{1,40}$"
            ],
      "_js2n__-:definitions/datapointSetTypeDef!predicate"
        | doc "Define the data structure of this datapointSet, check the documentation for more information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "map", "tableStatic", "tableDynamic" ]
            ],
      "_js2n__-:definitions/datapointTypeDef!predicate"
        | doc "Define the kind of information types, within NetinDS context, that the driver/zavod instances will generate for this datapoint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "SIMPLE",
                  "TIMEPOINT",
                  "DATAPOINT",
                  "@DATAPOINT",
                  "@TIMEPOINT",
                  "#DATAPOINT",
                  "#TIMEPOINT"
                ]
            ],
      "_js2n__-:definitions/defaultValueConfigDef!predicate"
        | doc "Allows to apply default values to a datapoint when the value or rawValue is null"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "isDefault", "rawValue", "value" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "isDefault", "value" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "isDefault", "rawValue" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  isDefault = _js2n__-prdslib.isType '"Bool",
                  rawValue =
                    _js2n__-refsenv."_js2n__-:definitions/valueDef!predicate",
                  value =
                    _js2n__-refsenv."_js2n__-:definitions/valueDef!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/descriptionDef!predicate"
        | doc "Detailed information about the device or system to be monitored by this device"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 800,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/evaluationForAlarmsDef!predicate"
        | doc "Array with all the evaluations that will be checked"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "audited",
                  "broadcast",
                  "expressions",
                  "facility",
                  "hidden",
                  "logic",
                  "onStartup",
                  "severity",
                  "text",
                  "textHelp"
                ],
              _js2n__-prdslib.records.record
                {
                  audited =
                    _js2n__-refsenv."_js2n__-:definitions/auditedDef!predicate",
                  broadcast =
                    _js2n__-refsenv."_js2n__-:definitions/broadcastDef!predicate",
                  expressions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/expressionLogicObjectDef!predicate"
                        ],
                  facility =
                    _js2n__-refsenv."_js2n__-:definitions/facilityDef!predicate",
                  hidden =
                    _js2n__-refsenv."_js2n__-:definitions/hiddenDef!predicate",
                  logic =
                    _js2n__-refsenv."_js2n__-:definitions/logicDef!predicate",
                  onStartup = _js2n__-prdslib.isType '"Bool",
                  routing =
                    _js2n__-refsenv."_js2n__-:definitions/routingDef!predicate",
                  severity =
                    _js2n__-refsenv."_js2n__-:definitions/severityForAlarmsDef!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/textDef!predicate",
                  textHelp =
                    _js2n__-refsenv."_js2n__-:definitions/textDef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/evaluationForLogsDef!predicate"
        | doc "Array with all the evaluations that will be checked"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "audited",
                  "broadcast",
                  "expressions",
                  "facility",
                  "hidden",
                  "logic",
                  "onStartup",
                  "severity",
                  "text",
                  "textHelp"
                ],
              _js2n__-prdslib.records.record
                {
                  audited =
                    _js2n__-refsenv."_js2n__-:definitions/auditedDef!predicate",
                  broadcast =
                    _js2n__-refsenv."_js2n__-:definitions/broadcastDef!predicate",
                  expressions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/expressionLogicObjectDef!predicate"
                        ],
                  facility =
                    _js2n__-refsenv."_js2n__-:definitions/facilityDef!predicate",
                  hidden =
                    _js2n__-refsenv."_js2n__-:definitions/hiddenDef!predicate",
                  logic =
                    _js2n__-refsenv."_js2n__-:definitions/logicDef!predicate",
                  onStartup = _js2n__-prdslib.isType '"Bool",
                  routing =
                    _js2n__-refsenv."_js2n__-:definitions/routingDef!predicate",
                  severity =
                    _js2n__-refsenv."_js2n__-:definitions/severityForLogsDef!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/textDef!predicate",
                  textHelp =
                    _js2n__-refsenv."_js2n__-:definitions/textDef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/expressionDef!predicate"
        | doc "Expression to be evaluated by NetinDS-Zavod"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 800,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/expressionLogicObjectDef!predicate"
        | doc "Expressions that will be checked in this evaluation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression", "symbol" ],
              _js2n__-prdslib.records.record
                {
                  expression =
                    _js2n__-refsenv."_js2n__-:definitions/expressionDef!predicate",
                  symbol =
                    _js2n__-refsenv."_js2n__-:definitions/symbolDef!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/facilityDef!predicate"
        | doc "Ident number for the resource group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 255,
              _js2n__-prdslib.numbers.minimum (-1)
            ],
      "_js2n__-:definitions/hiddenDef!predicate"
        | doc "Flag to indicate that the alarm is hidden by user request"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/logicDef!predicate"
        | doc "Logic operation to be applied between all the expressions"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 80,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/originAccessTypeDef!predicate"
        | doc "Access level to the datapoint. This is specific for each driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "read-only", "write-only", "read-write", "not-accessible" ]
            ],
      "_js2n__-:definitions/originAddressDef!predicate"
        | doc "Define the address of this datapoint. This is specific for each driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[\\w\\d_&#:$.-]{1,80}$"
            ],
      "_js2n__-:definitions/originDataTypeDef!predicate"
        | doc "Define the type of the data in the driver context, this means how the type of data that driver expect to collect"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9-_]{1,80}$"
            ],
      "_js2n__-:definitions/originDef!predicate"
        | doc "Monitored system, subsystem, device or ... source of the datapoint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^\\/\\{[a-zA-Z0-9-_.]{1,80}\\}\\/$|^[a-zA-Z0-9-_.]{1,80}$"
            ],
      "_js2n__-:definitions/originTypeConfigDef!predicate"
        | doc "Driver (Origin type) configuration object. Check the specific documentation for each driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "originType" ],
              _js2n__-prdslib.records.record
                {
                  originType =
                    _js2n__-refsenv."_js2n__-:definitions/originTypeDef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/originTypeDef!predicate"
        | doc "Driver (Origin type) identification string for the driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9-]{1,80}$"
            ],
      "_js2n__-:definitions/pollingGroupDef!predicate"
        | doc "Frequency in which the driver should update the value of this datapoint. This is specific for each driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "5s",
                  "10s",
                  "30s",
                  "1m",
                  "5m",
                  "10m",
                  "15m",
                  "30m",
                  "1h",
                  "4h",
                  "6h",
                  "12h",
                  "1d"
                ]
            ],
      "_js2n__-:definitions/rangerFilterDef!predicate"
        | doc "Tags used by Ranger to match discoverd devices with their respective templates"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 800,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  deviceID = _js2n__-prdslib.isType '"String",
                  vendorID = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/receiveModeDef!predicate"
        | doc "Define how the driver should get the value of this datapoint. This is specific for each driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "polling", "singleQuery", "subscription" ]
            ],
      "_js2n__-:definitions/representationCommonConfigDef!predicate"
        | doc "Common fields for grid representation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "firstColumn",
                  "firstRow",
                  "widgetHeight",
                  "widgetTitle",
                  "widgetType",
                  "widgetWidth"
                ],
              _js2n__-prdslib.records.record
                {
                  firstColumn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 8,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  firstRow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  widgetHeight =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  widgetTitle =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 800,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  widgetType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "map", "table", "metric", "gauge" ]
                        ],
                  widgetWidth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 8,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/representationDataDef!predicate"
        | doc "Datapoints that widget will use for representation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^device\\[[a-zA-Z0-9_-]{1,40}((\\.[0-9]+)?\\.[a-zA-Z0-9#&_-]{1,80})?\\]$"
            ],
      "_js2n__-:definitions/representationDef!predicate"
        | doc "What, where and how information show in device view"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "commonConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        widgetType =
                                          _js2n__-prdslib.const "map",
                                      } {} true _js2n__-prdslib.always
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "commonConfig", "data", "specificConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationCommonConfigDef!predicate",
                            data =
                              _js2n__-refsenv."_js2n__-:definitions/representationDataDef!predicate",
                            specificConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationMapConfigDef!predicate",
                          } {} true _js2n__-prdslib.always
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        commonConfig =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    widgetType = _js2n__-prdslib.const "table",
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "commonConfig", "data", "specificConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationCommonConfigDef!predicate",
                            data =
                              _js2n__-refsenv."_js2n__-:definitions/representationDataDef!predicate",
                            specificConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationTableConfigDef!predicate",
                          } {} true _js2n__-prdslib.always
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      {
                        commonConfig =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    widgetType = _js2n__-prdslib.const "metric",
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "commonConfig", "data", "specificConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationCommonConfigDef!predicate",
                            data =
                              _js2n__-refsenv."_js2n__-:definitions/representationDataDef!predicate",
                            specificConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationMetricConfigDef!predicate",
                          } {} true _js2n__-prdslib.always
                      ]) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "commonConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        widgetType =
                                          _js2n__-prdslib.const "gauge",
                                      } {} true _js2n__-prdslib.always
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required
                          [ "commonConfig", "data", "specificConfig" ],
                        _js2n__-prdslib.records.record
                          {
                            commonConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationCommonConfigDef!predicate",
                            data =
                              _js2n__-refsenv."_js2n__-:definitions/representationDataDef!predicate",
                            specificConfig =
                              _js2n__-refsenv."_js2n__-:definitions/representationGaugeConfigDef!predicate",
                          } {} true _js2n__-prdslib.always
                      ]) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.record
                {
                  commonConfig =
                    _js2n__-refsenv."_js2n__-:definitions/representationCommonConfigDef!predicate",
                  data =
                    _js2n__-refsenv."_js2n__-:definitions/representationDataDef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/representationGaugeConfigDef!predicate"
        | doc "Specific configuration for gauge widget representation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "format", "maxValue", "minValue" ],
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "datapoint" ],
                                _js2n__-prdslib.records.record
                                  {
                                    color = _js2n__-prdslib.isType '"String",
                                    datapoint =
                                      _js2n__-refsenv."_js2n__-:definitions/datapointIdDef!predicate",
                                    units = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  maxValue = _js2n__-prdslib.isType '"Number",
                  minValue = _js2n__-prdslib.isType '"Number",
                  ranges =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "from", "severity", "to" ],
                                _js2n__-prdslib.records.record
                                  {
                                    from = _js2n__-prdslib.isType 'Integer,
                                    severity = _js2n__-prdslib.isType 'Integer,
                                    to = _js2n__-prdslib.isType 'Integer,
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/representationMapConfigDef!predicate"
        | doc "Specific configuration for map widget representation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "format" ],
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "alias", "datapoint", "order" ],
                                _js2n__-prdslib.records.record
                                  {
                                    alias =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              80,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                    datapoint =
                                      _js2n__-refsenv."_js2n__-:definitions/datapointIdDef!predicate",
                                    fieldType =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "string",
                                                "boolean",
                                                "numeric",
                                                "date",
                                                "severity"
                                              ]
                                          ],
                                    order =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    utc = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/representationMetricConfigDef!predicate"
        | doc "Specific configuration for metric widget representation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  lastUpdateEnabled = _js2n__-prdslib.isType '"Bool",
                  titleEnabled = _js2n__-prdslib.isType '"Bool",
                  url = _js2n__-prdslib.isType '"String",
                  urlEnabled = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/representationTableConfigDef!predicate"
        | doc "Specific configuration for Table widget representation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "format" ],
              _js2n__-prdslib.records.record
                {
                  filterable = _js2n__-prdslib.isType '"Bool",
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "alias", "datapoint", "order" ],
                                _js2n__-prdslib.records.record
                                  {
                                    alias =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.maxLength
                                              80,
                                            _js2n__-prdslib.strings.minLength 1
                                          ],
                                    datapoint =
                                      _js2n__-refsenv."_js2n__-:definitions/datapointIdDef!predicate",
                                    fieldGroup =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "basic", "advanced" ]
                                          ],
                                    fieldType =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "string",
                                                "boolean",
                                                "numeric",
                                                "date",
                                                "severity"
                                              ]
                                          ],
                                    filterType =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "string",
                                                "boolean",
                                                "numeric",
                                                "date",
                                                "severity"
                                              ]
                                          ],
                                    filterable = _js2n__-prdslib.isType '"Bool",
                                    minScreenSize =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "xs", "s", "m", "l" ]
                                          ],
                                    order =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                    utc = _js2n__-prdslib.isType '"Bool",
                                    width =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.numbers.minimum 1
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  pageSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 10,
                          _js2n__-prdslib.numbers.minimum 2
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/routingDef!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "topic" ],
              _js2n__-prdslib.records.record
                {
                  service =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 80
                        ],
                  serviceConfig =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  topic =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 80
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/rowFilterConfigDef!predicate"
        | doc "Allows row filtering in table based datapointSets"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  expressions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/expressionLogicObjectDef!predicate"
                        ],
                  logic =
                    _js2n__-refsenv."_js2n__-:definitions/logicDef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/schemaVersionDef!predicate"
        | doc "Fixed value designating the version of the template schema"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "(?<=^v?|\\sv?)(?:(?:0|[1-9][0-9]*).){2}(?:0|[1-9][0-9]*)(?:-(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*)(?:.(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*))*)?(?:\\+[0-9a-z-]+(?:.[0-9a-z-]+)*)?\\b"
            ],
      "_js2n__-:definitions/severityForAlarmsDef!predicate"
        | doc "Level of criticality of the alarm"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 1000,
              _js2n__-prdslib.numbers.minimum 201
            ],
      "_js2n__-:definitions/severityForLogsDef!predicate"
        | doc "Level of criticality of the log"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 200,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/symbolDef!predicate"
        | doc "Identification string for logic expression"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/tableAddressDef!predicate"
        | doc "Specific configuration for tabled based datapointSets"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  indexes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^[a-zA-Z0-9#&_-]{1,80}$"
                              ])
                        ],
                  rootAddress =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 240
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/templateIdDef!predicate"
        | doc "Template identification string"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9-_ ]{1,80}$"
            ],
      "_js2n__-:definitions/templateVersionDef!predicate"
        | doc "SemVer style template version"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "(?<=^v?|\\sv?)(?:(?:0|[1-9][0-9]*).){2}(?:0|[1-9][0-9]*)(?:-(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*)(?:.(?:0|[1-9][0-9]*|[0-9a-z-]*[a-z-][0-9a-z-]*))*)?(?:\\+[0-9a-z-]+(?:.[0-9a-z-]+)*)?\\b"
            ],
      "_js2n__-:definitions/textDef!predicate"
        | doc "Alarm/event descriptive text"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 800,
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/unitsConfigDef!predicate"
        | doc "Allows converts between measure units"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "exclude", "toBest" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]),
                      _js2n__-prdslib.records.required [ "from", "to" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "to" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]),
                      _js2n__-prdslib.records.required [ "from", "toBest" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  from = _js2n__-prdslib.isType '"String",
                  to = _js2n__-prdslib.isType '"String",
                  toBest = _js2n__-prdslib.isType '"Bool",
                  units = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/valueDef!predicate"
        | doc "Value or rawValue of a datapoint"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.isType 'Record
            ],
      "_js2n__-:definitions/valueMapConfigDef!predicate"
        | doc "Allows converts rawValue to value based in a key/value map"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "map" ],
              _js2n__-prdslib.records.record
                {
                  map =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    key =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.isType '"Bool"
                                          ],
                                    value =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.isType 'Integer
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required
            [
              "datapointSets",
              "description",
              "origin",
              "templateId",
              "templateVersion"
            ],
          _js2n__-prdslib.records.record
            {
              alias =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 80,
                      _js2n__-prdslib.strings.minLength 1
                    ],
              datapointSets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/datapointSetConfigDef!predicate",
                      _js2n__-prdslib.arrays.minItems 1
                    ],
              description =
                _js2n__-refsenv."_js2n__-:definitions/descriptionDef!predicate",
              origin =
                _js2n__-refsenv."_js2n__-:definitions/originDef!predicate",
              originTypes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/originTypeConfigDef!predicate",
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              rangerFilter =
                _js2n__-refsenv."_js2n__-:definitions/rangerFilterDef!predicate",
              representation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/representationDef!predicate",
                      _js2n__-prdslib.arrays.minItems 1
                    ],
              schemaVersion =
                _js2n__-refsenv."_js2n__-:definitions/schemaVersionDef!predicate",
              templateId =
                _js2n__-refsenv."_js2n__-:definitions/templateIdDef!predicate",
              templateVersion =
                _js2n__-refsenv."_js2n__-:definitions/templateVersionDef!predicate",
            } {} false _js2n__-prdslib.never
        ])