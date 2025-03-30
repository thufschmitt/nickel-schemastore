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
      "_js2n__-:definitions/datatableColumns!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[^\\s]*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              {
                                type =
                                  _js2n__-prdslib.enum
                                      [ "dropdown", "autocomplete" ],
                              } {} true _js2n__-prdslib.always)
                            (_js2n__-prdslib.records.record
                              {
                                options =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {}
                                          {
                                            ".+" =
                                              _js2n__-prdslib.isType '"String",
                                          } true _js2n__-prdslib.always
                                      ],
                              } {} true _js2n__-prdslib.always)
                            _js2n__-prdslib.always,
                          _js2n__-prdslib.records.record
                            {
                              readOnly = _js2n__-prdslib.isType '"Bool",
                              title = _js2n__-prdslib.isType '"String",
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "string",
                                          "checkbox",
                                          "dropdown",
                                          "autocomplete"
                                        ]
                                    ],
                              validation =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          float =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      allowNegative =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      message =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          integer =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      allowNegative =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      message =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          length =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      max =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      message =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      min =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          regex =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      message =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      pattern =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          required =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      message =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              width = _js2n__-prdslib.isType 'Integer,
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/fields!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "^[^\\s]*$" =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type = _js2n__-prdslib.enum [ "number" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      max = _js2n__-prdslib.isType 'Integer,
                                      min = _js2n__-prdslib.isType 'Integer,
                                      step = _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "dropdown" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      emptyOption =
                                        _js2n__-prdslib.isType '"String",
                                      options =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {}
                                                    {
                                                      ".+" =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                      placeholder =
                                        _js2n__-prdslib.isType '"String",
                                      showSearch =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum
                                            [
                                              "radio",
                                              "balloon-selector",
                                              "checkboxlist"
                                            ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      options =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {}
                                                    {
                                                      ".+" =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type = _js2n__-prdslib.enum [ "switch" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      off = _js2n__-prdslib.isType '"String",
                                      on = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum
                                            [ "partial", "hint" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    { path = _js2n__-prdslib.isType '"String", }
                                    {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "codeeditor" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      fontSize =
                                        _js2n__-prdslib.isType '"Number",
                                      language =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "php",
                                                      "css",
                                                      "js",
                                                      "html"
                                                    ]
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                      showGutter =
                                        _js2n__-prdslib.isType '"Bool",
                                      wrapWords =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "colorpicker" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      allowEmpty =
                                        _js2n__-prdslib.isType '"Bool",
                                      availableColors =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "datatable" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      adding = _js2n__-prdslib.isType '"Bool",
                                      btnAddRowBelowLabel =
                                        _js2n__-prdslib.isType '"String",
                                      btnAddRowLabel =
                                        _js2n__-prdslib.isType '"String",
                                      btnDeleteRowLabel =
                                        _js2n__-prdslib.isType '"String",
                                      columns =
                                        _js2n__-refsenv."_js2n__-:definitions/datatableColumns!predicate",
                                      deleting = _js2n__-prdslib.isType '"Bool",
                                      dynamicHeight =
                                        _js2n__-prdslib.isType '"String",
                                      fieldName =
                                        _js2n__-prdslib.isType '"String",
                                      height =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.isType '"Bool"
                                            ],
                                      keyFrom =
                                        _js2n__-prdslib.isType '"String",
                                      postbackHandlerName =
                                        _js2n__-prdslib.isType '"String",
                                      recordsPerPage =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.isType '"Bool"
                                            ],
                                      searching = _js2n__-prdslib.always,
                                      toolbar = _js2n__-prdslib.isType '"Array",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "datepicker" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      firstDay =
                                        _js2n__-prdslib.isType 'Integer,
                                      format = _js2n__-prdslib.isType '"String",
                                      ignoreTimezone =
                                        _js2n__-prdslib.isType '"Bool",
                                      maxDate =
                                        _js2n__-prdslib.isType '"String",
                                      minDate =
                                        _js2n__-prdslib.isType '"String",
                                      mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "date", "datetime", "time" ]
                                            ],
                                      showWeekNumber =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "fileupload" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      attachOnUpload =
                                        _js2n__-prdslib.isType '"Bool",
                                      fileTypes =
                                        _js2n__-prdslib.isType '"String",
                                      maxFilesize =
                                        _js2n__-prdslib.isType '"Number",
                                      mimeTypes =
                                        _js2n__-prdslib.isType '"String",
                                      mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "file", "image" ]
                                            ],
                                      useCaption =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      mode = _js2n__-prdslib.enum [ "image" ],
                                      type =
                                        _js2n__-prdslib.enum [ "fileupload" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      imageHeight =
                                        _js2n__-prdslib.isType '"Number",
                                      imageWidth =
                                        _js2n__-prdslib.isType '"Number",
                                      thumbOptions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  extension =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "auto",
                                                              "jpg",
                                                              "png",
                                                              "gif"
                                                            ]
                                                        ],
                                                  interlace =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  mode =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "auto",
                                                              "exact",
                                                              "portrait",
                                                              "landscape",
                                                              "crop",
                                                              "fit"
                                                            ]
                                                        ],
                                                  quality =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Integer,
                                                          _js2n__-prdslib.numbers.maximum
                                                            100,
                                                          _js2n__-prdslib.numbers.minimum
                                                            0
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      mode = _js2n__-prdslib.enum [ "file" ],
                                      type =
                                        _js2n__-prdslib.enum [ "fileupload" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      prompt = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "markdown" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "tab", "split" ]
                                            ],
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "mediafinder" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      imageWidth =
                                        _js2n__-prdslib.isType '"String",
                                      mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "file", "image" ]
                                            ],
                                      prompt = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      mode = _js2n__-prdslib.enum [ "image" ],
                                      type =
                                        _js2n__-prdslib.enum [ "mediafinder" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      imageHeight =
                                        _js2n__-prdslib.isType '"Number",
                                      imageWidth =
                                        _js2n__-prdslib.isType '"Number",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "nestedform" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      form =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  fields =
                                                    _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                                                  secondaryTabs =
                                                    _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                                  tabs =
                                                    _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      usePanelStyles =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "recordfinder" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      conditions =
                                        _js2n__-prdslib.isType '"String",
                                      descriptionFrom =
                                        _js2n__-prdslib.isType '"String",
                                      keyFrom =
                                        _js2n__-prdslib.isType '"String",
                                      list =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.isType '"Array"
                                            ],
                                      nameFrom =
                                        _js2n__-prdslib.isType '"String",
                                      prompt = _js2n__-prdslib.isType '"String",
                                      recordsPerPage =
                                        _js2n__-prdslib.isType 'Integer,
                                      scope = _js2n__-prdslib.isType '"String",
                                      searchMode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "all", "any", "exact" ]
                                            ],
                                      searchScope =
                                        _js2n__-prdslib.isType '"String",
                                      title = _js2n__-prdslib.isType '"String",
                                      useRelation =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "recordfinder" ],
                                      useRelation =
                                        _js2n__-prdslib.enum [ false ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      modelClass =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "relation" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      emptyOption =
                                        _js2n__-prdslib.isType '"String",
                                      nameFrom =
                                        _js2n__-prdslib.isType '"String",
                                      order = _js2n__-prdslib.isType '"String",
                                      scope = _js2n__-prdslib.isType '"String",
                                      select = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "repeater" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      form =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  fields =
                                                    _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                                                  secondaryTabs =
                                                    _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                                  tabs =
                                                    _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      groups =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {}
                                                    {
                                                      "^[^\\s]*$" =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [ "fields" ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  description =
                                                                    _js2n__-prdslib.always,
                                                                  fields =
                                                                    _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                                                                  icon =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.strings.pattern
                                                                            "^icon-"
                                                                        ],
                                                                  name =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                    } true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ],
                                      maxItems =
                                        _js2n__-prdslib.isType 'Integer,
                                      minItems =
                                        _js2n__-prdslib.isType 'Integer,
                                      prompt = _js2n__-prdslib.isType '"String",
                                      titleFrom =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.enum [ "richeditor" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      toolbarButtons =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      type = _js2n__-prdslib.enum [ "taglist" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      customTags =
                                        _js2n__-prdslib.isType '"Bool",
                                      mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "string",
                                                  "array",
                                                  "relation"
                                                ]
                                            ],
                                      options =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.isType '"Bool"
                                            ],
                                      separator =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "comma", "space" ]
                                            ],
                                      useKey = _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      mode =
                                        _js2n__-prdslib.enum [ "relation" ],
                                      type = _js2n__-prdslib.enum [ "taglist" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      nameFrom =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always)
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.records.record
                              {
                                attributes =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {}
                                          {
                                            ".+" =
                                              _js2n__-prdslib.isType '"String",
                                          } true _js2n__-prdslib.always
                                      ],
                                comment = _js2n__-prdslib.isType '"String",
                                commentAbove = _js2n__-prdslib.isType '"String",
                                commentHtml = _js2n__-prdslib.isType '"Bool",
                                containerAttributes =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {}
                                          {
                                            ".+" =
                                              _js2n__-prdslib.isType '"String",
                                          } true _js2n__-prdslib.always
                                      ],
                                context =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "create",
                                                      "update",
                                                      "preview"
                                                    ]
                                                ],
                                              _js2n__-prdslib.isType '"String"
                                            ]),
                                        _js2n__-prdslib.arrays.uniqueItems
                                      ],
                                cssClass = _js2n__-prdslib.isType '"String",
                                "default" = _js2n__-prdslib.always,
                                defaultFrom = _js2n__-prdslib.isType '"String",
                                dependsOn =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                disabled = _js2n__-prdslib.isType '"Bool",
                                hidden = _js2n__-prdslib.isType '"Bool",
                                label = _js2n__-prdslib.isType '"String",
                                permissions =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                placeholder = _js2n__-prdslib.isType '"String",
                                preset =
                                  _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                field =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                prefixInput =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                type =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "exact",
                                                            "slug",
                                                            "url",
                                                            "camel",
                                                            "file"
                                                          ]
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.isType '"String"
                                      ],
                                readOnly = _js2n__-prdslib.isType '"Bool",
                                required = _js2n__-prdslib.isType '"Bool",
                                size =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "tiny",
                                            "small",
                                            "large",
                                            "huge",
                                            "giant"
                                          ]
                                      ],
                                span =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "auto",
                                            "left",
                                            "right",
                                            "row",
                                            "full"
                                          ]
                                      ],
                                stretch = _js2n__-prdslib.isType '"Bool",
                                tab = _js2n__-prdslib.isType '"String",
                                trigger =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            action =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "show",
                                                        "hide",
                                                        "enable",
                                                        "disable",
                                                        "empty"
                                                      ]
                                                  ],
                                            condition =
                                              _js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "checked",
                                                            "unchecked",
                                                            "value[somevalue]"
                                                          ]
                                                      ],
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.strings.pattern
                                                          "^value\\[.*\\]$"
                                                      ]
                                                  ],
                                            field =
                                              _js2n__-prdslib.isType '"String",
                                          } {} true _js2n__-prdslib.always
                                      ],
                                type =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "text",
                                                "number",
                                                "password",
                                                "email",
                                                "textarea",
                                                "dropdown",
                                                "radio",
                                                "balloon-selector",
                                                "checkbox",
                                                "checkboxlist",
                                                "switch",
                                                "section",
                                                "partial",
                                                "hint"
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "codeeditor",
                                                "colorpicker",
                                                "datatable",
                                                "datepicker",
                                                "fileupload",
                                                "markdown",
                                                "mediafinder",
                                                "nestedform",
                                                "recordfinder",
                                                "relation",
                                                "repeater",
                                                "richeditor",
                                                "taglist"
                                              ]
                                          ],
                                        _js2n__-prdslib.isType '"String"
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                  } true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/fields!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[^\\s]*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.enum [ "number" ], }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    max = _js2n__-prdslib.isType 'Integer,
                                    min = _js2n__-prdslib.isType 'Integer,
                                    step = _js2n__-prdslib.isType 'Integer,
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.enum [ "dropdown" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    emptyOption =
                                      _js2n__-prdslib.isType '"String",
                                    options =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {}
                                                  {
                                                    ".+" =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } true _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    placeholder =
                                      _js2n__-prdslib.isType '"String",
                                    showSearch = _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum
                                          [
                                            "radio",
                                            "balloon-selector",
                                            "checkboxlist"
                                          ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    options =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {}
                                                  {
                                                    ".+" =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } true _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.enum [ "switch" ], }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    off = _js2n__-prdslib.isType '"String",
                                    on = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum
                                          [ "partial", "hint" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  { path = _js2n__-prdslib.isType '"String", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "codeeditor" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    fontSize = _js2n__-prdslib.isType '"Number",
                                    language =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "php", "css", "js", "html" ]
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    showGutter = _js2n__-prdslib.isType '"Bool",
                                    wrapWords = _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "colorpicker" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    allowEmpty = _js2n__-prdslib.isType '"Bool",
                                    availableColors =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.enum [ "datatable" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    adding = _js2n__-prdslib.isType '"Bool",
                                    btnAddRowBelowLabel =
                                      _js2n__-prdslib.isType '"String",
                                    btnAddRowLabel =
                                      _js2n__-prdslib.isType '"String",
                                    btnDeleteRowLabel =
                                      _js2n__-prdslib.isType '"String",
                                    columns =
                                      _js2n__-refsenv."_js2n__-:definitions/datatableColumns!predicate",
                                    deleting = _js2n__-prdslib.isType '"Bool",
                                    dynamicHeight =
                                      _js2n__-prdslib.isType '"String",
                                    fieldName =
                                      _js2n__-prdslib.isType '"String",
                                    height =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"Bool"
                                          ],
                                    keyFrom = _js2n__-prdslib.isType '"String",
                                    postbackHandlerName =
                                      _js2n__-prdslib.isType '"String",
                                    recordsPerPage =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.isType '"Bool"
                                          ],
                                    searching = _js2n__-prdslib.always,
                                    toolbar = _js2n__-prdslib.isType '"Array",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "datepicker" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    firstDay = _js2n__-prdslib.isType 'Integer,
                                    format = _js2n__-prdslib.isType '"String",
                                    ignoreTimezone =
                                      _js2n__-prdslib.isType '"Bool",
                                    maxDate = _js2n__-prdslib.isType '"String",
                                    minDate = _js2n__-prdslib.isType '"String",
                                    mode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "date", "datetime", "time" ]
                                          ],
                                    showWeekNumber =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "fileupload" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    attachOnUpload =
                                      _js2n__-prdslib.isType '"Bool",
                                    fileTypes =
                                      _js2n__-prdslib.isType '"String",
                                    maxFilesize =
                                      _js2n__-prdslib.isType '"Number",
                                    mimeTypes =
                                      _js2n__-prdslib.isType '"String",
                                    mode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "file", "image" ]
                                          ],
                                    useCaption = _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    mode = _js2n__-prdslib.enum [ "image" ],
                                    type =
                                      _js2n__-prdslib.enum [ "fileupload" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    imageHeight =
                                      _js2n__-prdslib.isType '"Number",
                                    imageWidth =
                                      _js2n__-prdslib.isType '"Number",
                                    thumbOptions =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                extension =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "auto",
                                                            "jpg",
                                                            "png",
                                                            "gif"
                                                          ]
                                                      ],
                                                interlace =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                mode =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "auto",
                                                            "exact",
                                                            "portrait",
                                                            "landscape",
                                                            "crop",
                                                            "fit"
                                                          ]
                                                      ],
                                                quality =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer,
                                                        _js2n__-prdslib.numbers.maximum
                                                          100,
                                                        _js2n__-prdslib.numbers.minimum
                                                          0
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ],
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    mode = _js2n__-prdslib.enum [ "file" ],
                                    type =
                                      _js2n__-prdslib.enum [ "fileupload" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  { prompt = _js2n__-prdslib.isType '"String", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.enum [ "markdown" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    mode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "tab", "split" ]
                                          ],
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "mediafinder" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    imageWidth =
                                      _js2n__-prdslib.isType '"String",
                                    mode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "file", "image" ]
                                          ],
                                    prompt = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    mode = _js2n__-prdslib.enum [ "image" ],
                                    type =
                                      _js2n__-prdslib.enum [ "mediafinder" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    imageHeight =
                                      _js2n__-prdslib.isType '"Number",
                                    imageWidth =
                                      _js2n__-prdslib.isType '"Number",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "nestedform" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    form =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                fields =
                                                  _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                                                secondaryTabs =
                                                  _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                                tabs =
                                                  _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    usePanelStyles =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "recordfinder" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    conditions =
                                      _js2n__-prdslib.isType '"String",
                                    descriptionFrom =
                                      _js2n__-prdslib.isType '"String",
                                    keyFrom = _js2n__-prdslib.isType '"String",
                                    list =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType '"Array"
                                          ],
                                    nameFrom = _js2n__-prdslib.isType '"String",
                                    prompt = _js2n__-prdslib.isType '"String",
                                    recordsPerPage =
                                      _js2n__-prdslib.isType 'Integer,
                                    scope = _js2n__-prdslib.isType '"String",
                                    searchMode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "all", "any", "exact" ]
                                          ],
                                    searchScope =
                                      _js2n__-prdslib.isType '"String",
                                    title = _js2n__-prdslib.isType '"String",
                                    useRelation =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "recordfinder" ],
                                    useRelation =
                                      _js2n__-prdslib.enum [ false ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    modelClass =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.enum [ "relation" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    emptyOption =
                                      _js2n__-prdslib.isType '"String",
                                    nameFrom = _js2n__-prdslib.isType '"String",
                                    order = _js2n__-prdslib.isType '"String",
                                    scope = _js2n__-prdslib.isType '"String",
                                    select = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.enum [ "repeater" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    form =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                fields =
                                                  _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                                                secondaryTabs =
                                                  _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                                tabs =
                                                  _js2n__-refsenv."_js2n__-:definitions/tabs!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ],
                                    groups =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {}
                                                  {
                                                    "^[^\\s]*$" =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [ "fields" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                description =
                                                                  _js2n__-prdslib.always,
                                                                fields =
                                                                  _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                                                                icon =
                                                                  _js2n__-prdslib.allOf
                                                                      [
                                                                        _js2n__-prdslib.isType
                                                                          '"String",
                                                                        _js2n__-prdslib.strings.pattern
                                                                          "^icon-"
                                                                      ],
                                                                name =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} true
                                                              _js2n__-prdslib.always
                                                          ],
                                                  } true _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    maxItems = _js2n__-prdslib.isType 'Integer,
                                    minItems = _js2n__-prdslib.isType 'Integer,
                                    prompt = _js2n__-prdslib.isType '"String",
                                    titleFrom =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "richeditor" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    toolbarButtons =
                                      _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.enum [ "taglist" ], }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    customTags = _js2n__-prdslib.isType '"Bool",
                                    mode =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "string", "array", "relation" ]
                                          ],
                                    options =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.isType '"Bool"
                                          ],
                                    separator =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "comma", "space" ]
                                          ],
                                    useKey = _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    mode = _js2n__-prdslib.enum [ "relation" ],
                                    type = _js2n__-prdslib.enum [ "taglist" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    nameFrom = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.records.record
                            {
                              attributes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          ".+" =
                                            _js2n__-prdslib.isType '"String",
                                        } true _js2n__-prdslib.always
                                    ],
                              comment = _js2n__-prdslib.isType '"String",
                              commentAbove = _js2n__-prdslib.isType '"String",
                              commentHtml = _js2n__-prdslib.isType '"Bool",
                              containerAttributes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          ".+" =
                                            _js2n__-prdslib.isType '"String",
                                        } true _js2n__-prdslib.always
                                    ],
                              context =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "create",
                                                    "update",
                                                    "preview"
                                                  ]
                                              ],
                                            _js2n__-prdslib.isType '"String"
                                          ]),
                                      _js2n__-prdslib.arrays.uniqueItems
                                    ],
                              cssClass = _js2n__-prdslib.isType '"String",
                              "default" = _js2n__-prdslib.always,
                              defaultFrom = _js2n__-prdslib.isType '"String",
                              dependsOn =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              disabled = _js2n__-prdslib.isType '"Bool",
                              hidden = _js2n__-prdslib.isType '"Bool",
                              label = _js2n__-prdslib.isType '"String",
                              permissions =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              placeholder = _js2n__-prdslib.isType '"String",
                              preset =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              field =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              prefixInput =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              type =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "exact",
                                                          "slug",
                                                          "url",
                                                          "camel",
                                                          "file"
                                                        ]
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              readOnly = _js2n__-prdslib.isType '"Bool",
                              required = _js2n__-prdslib.isType '"Bool",
                              size =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "tiny",
                                          "small",
                                          "large",
                                          "huge",
                                          "giant"
                                        ]
                                    ],
                              span =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "auto",
                                          "left",
                                          "right",
                                          "row",
                                          "full"
                                        ]
                                    ],
                              stretch = _js2n__-prdslib.isType '"Bool",
                              tab = _js2n__-prdslib.isType '"String",
                              trigger =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          action =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "show",
                                                      "hide",
                                                      "enable",
                                                      "disable",
                                                      "empty"
                                                    ]
                                                ],
                                          condition =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "checked",
                                                          "unchecked",
                                                          "value[somevalue]"
                                                        ]
                                                    ],
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.pattern
                                                        "^value\\[.*\\]$"
                                                    ]
                                                ],
                                          field =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              type =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "text",
                                              "number",
                                              "password",
                                              "email",
                                              "textarea",
                                              "dropdown",
                                              "radio",
                                              "balloon-selector",
                                              "checkbox",
                                              "checkboxlist",
                                              "switch",
                                              "section",
                                              "partial",
                                              "hint"
                                            ]
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "codeeditor",
                                              "colorpicker",
                                              "datatable",
                                              "datepicker",
                                              "fileupload",
                                              "markdown",
                                              "mediafinder",
                                              "nestedform",
                                              "recordfinder",
                                              "relation",
                                              "repeater",
                                              "richeditor",
                                              "taglist"
                                            ]
                                        ],
                                      _js2n__-prdslib.isType '"String"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tabs!contract"
        | doc ""
        = {
            cssClass
              | String
              | doc "assigns a CSS class to the tab container"
              | optional,
            defaultTab
              | String
              | doc "the default tab to assign fields to"
              | optional,
            fields | _js2n__-refsenv."_js2n__-:definitions/fields!contract",
            icons
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".+" =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern "^icon-"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "assign icons to tabs using tab names as the key"
              | optional,
            lazy
              | Array (String)
              | doc "array of tabs to be loaded dynamically when clicked"
              | optional,
            paneCssClass
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType '"String"
                      ],
                    _js2n__-prdslib.records.record {}
                      { ".+" = _js2n__-prdslib.isType '"String", } true
                      _js2n__-prdslib.always
                  ])
              | doc "assigns a CSS class to an individual tab pane. Value is an array, key is tab index or label, value is the CSS class. It can also be specified as a string, in which case the value will be applied to all tabs."
              | optional,
            stretch
              | Bool
              | doc "specifies if this tab stretches to fit the parent height"
              | optional,
            ..
          },
      "_js2n__-:definitions/tabs!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fields" ],
              _js2n__-prdslib.records.record
                {
                  cssClass = _js2n__-prdslib.isType '"String",
                  defaultTab = _js2n__-prdslib.isType '"String",
                  fields =
                    _js2n__-refsenv."_js2n__-:definitions/fields!predicate",
                  icons =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern "^icon-"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  lazy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paneCssClass =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.records.record {}
                            { ".+" = _js2n__-prdslib.isType '"String", } true
                            _js2n__-prdslib.always
                        ],
                  stretch = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      fields
        | _js2n__-refsenv."_js2n__-:definitions/fields!contract"
        | optional,
      secondaryTabs
        | _js2n__-refsenv."_js2n__-:definitions/tabs!contract"
        | doc "secondary tabs"
        | optional,
      tabs
        | _js2n__-refsenv."_js2n__-:definitions/tabs!contract"
        | doc "Primary tabs"
        | optional,
      ..
    }