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
              GLOBAL =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          allow_deprecated_macos_versions =
                            _js2n__-prdslib.isType '"Array",
                          backend_packages = _js2n__-prdslib.isType '"Array",
                          build_file_prelude_globs =
                            _js2n__-prdslib.isType '"Array",
                          build_ignore = _js2n__-prdslib.isType '"Array",
                          build_patterns = _js2n__-prdslib.isType '"Array",
                          ca_certs_path = _js2n__-prdslib.isType '"String",
                          cache_content_behavior =
                            _js2n__-prdslib.enum
                                [ "fetch", "validate", "defer" ],
                          colors = _js2n__-prdslib.isType '"Bool",
                          concurrent = _js2n__-prdslib.isType '"Bool",
                          docker_execution = _js2n__-prdslib.isType '"Bool",
                          dynamic_ui = _js2n__-prdslib.isType '"Bool",
                          dynamic_ui_renderer =
                            _js2n__-prdslib.enum
                                [ "indicatif-spinner", "experimental-prodash" ],
                          enable_target_origin_sources_blocks =
                            _js2n__-prdslib.isType '"Bool",
                          engine_visualize_to = _js2n__-prdslib.always,
                          file_downloads_max_attempts =
                            _js2n__-prdslib.isType '"Number",
                          file_downloads_retry_delay =
                            _js2n__-prdslib.isType '"Number",
                          ignore_warnings = _js2n__-prdslib.isType '"Array",
                          keep_sandboxes =
                            _js2n__-prdslib.enum
                                [ "always", "on_failure", "never" ],
                          level =
                            _js2n__-prdslib.enum
                                [ "trace", "debug", "info", "warn", "error" ],
                          local_cache = _js2n__-prdslib.isType '"Bool",
                          local_execution_root_dir =
                            _js2n__-prdslib.isType '"String",
                          local_store_dir = _js2n__-prdslib.isType '"String",
                          local_store_directories_max_size_bytes =
                            _js2n__-prdslib.isType '"Number",
                          local_store_files_max_size_bytes =
                            _js2n__-prdslib.isType '"Number",
                          local_store_processes_max_size_bytes =
                            _js2n__-prdslib.isType '"Number",
                          local_store_shard_count =
                            _js2n__-prdslib.isType '"Number",
                          log_levels_by_target = _js2n__-prdslib.isType 'Record,
                          log_show_rust_3rdparty =
                            _js2n__-prdslib.isType '"Bool",
                          logdir = _js2n__-prdslib.isType '"String",
                          loop = _js2n__-prdslib.isType '"Bool",
                          loop_max = _js2n__-prdslib.isType '"Number",
                          named_caches_dir = _js2n__-prdslib.isType '"String",
                          native_options_validation =
                            _js2n__-prdslib.enum
                                [ "ignore", "warning", "error" ],
                          pants_bin_name = _js2n__-prdslib.isType '"String",
                          pants_config_files = _js2n__-prdslib.isType '"Array",
                          pants_distdir = _js2n__-prdslib.isType '"String",
                          pants_ignore = _js2n__-prdslib.isType '"Array",
                          pants_ignore_use_gitignore =
                            _js2n__-prdslib.isType '"Bool",
                          pants_physical_workdir_base =
                            _js2n__-prdslib.isType '"String",
                          pants_subprocessdir =
                            _js2n__-prdslib.isType '"String",
                          pants_version = _js2n__-prdslib.isType '"String",
                          pants_workdir = _js2n__-prdslib.isType '"String",
                          pantsd = _js2n__-prdslib.isType '"Bool",
                          pantsd_invalidation_globs =
                            _js2n__-prdslib.isType '"Array",
                          pantsd_max_memory_usage = _js2n__-prdslib.always,
                          pantsd_pailgun_port =
                            _js2n__-prdslib.isType '"Number",
                          pantsd_timeout_when_multiple_invocations =
                            _js2n__-prdslib.isType '"Number",
                          pantsrc = _js2n__-prdslib.isType '"Bool",
                          pantsrc_files = _js2n__-prdslib.isType '"Array",
                          plugins = _js2n__-prdslib.isType '"Array",
                          plugins_force_resolve =
                            _js2n__-prdslib.isType '"Bool",
                          print_stacktrace = _js2n__-prdslib.isType '"Bool",
                          process_execution_cache_namespace =
                            _js2n__-prdslib.isType '"String",
                          process_execution_graceful_shutdown_timeout =
                            _js2n__-prdslib.isType '"Number",
                          process_execution_local_enable_nailgun =
                            _js2n__-prdslib.isType '"Bool",
                          process_execution_local_parallelism =
                            _js2n__-prdslib.isType '"Number",
                          process_execution_remote_parallelism =
                            _js2n__-prdslib.isType '"Number",
                          process_per_child_memory_usage =
                            _js2n__-prdslib.always,
                          process_total_child_memory_usage =
                            _js2n__-prdslib.always,
                          pythonpath = _js2n__-prdslib.isType '"Array",
                          remote_ca_certs_path =
                            _js2n__-prdslib.isType '"String",
                          remote_cache_read = _js2n__-prdslib.isType '"Bool",
                          remote_cache_rpc_concurrency =
                            _js2n__-prdslib.isType '"Number",
                          remote_cache_rpc_timeout_millis =
                            _js2n__-prdslib.isType '"Number",
                          remote_cache_warnings =
                            _js2n__-prdslib.enum
                                [ "ignore", "first_only", "backoff", "always" ],
                          remote_cache_write = _js2n__-prdslib.isType '"Bool",
                          remote_client_certs_path =
                            _js2n__-prdslib.isType '"String",
                          remote_client_key_path =
                            _js2n__-prdslib.isType '"String",
                          remote_execution = _js2n__-prdslib.isType '"Bool",
                          remote_execution_address =
                            _js2n__-prdslib.isType '"String",
                          remote_execution_append_only_caches_base_path =
                            _js2n__-prdslib.isType '"String",
                          remote_execution_extra_platform_properties =
                            _js2n__-prdslib.isType '"Array",
                          remote_execution_headers =
                            _js2n__-prdslib.isType 'Record,
                          remote_execution_overall_deadline_secs =
                            _js2n__-prdslib.isType '"Number",
                          remote_execution_rpc_concurrency =
                            _js2n__-prdslib.isType '"Number",
                          remote_instance_name =
                            _js2n__-prdslib.isType '"String",
                          remote_oauth_bearer_token =
                            _js2n__-prdslib.isType '"String",
                          remote_provider =
                            _js2n__-prdslib.enum
                                [
                                  "reapi",
                                  "experimental-file",
                                  "experimental-github-actions-cache"
                                ],
                          remote_store_address =
                            _js2n__-prdslib.isType '"String",
                          remote_store_batch_api_size_limit =
                            _js2n__-prdslib.isType '"Number",
                          remote_store_chunk_bytes =
                            _js2n__-prdslib.isType '"Number",
                          remote_store_headers = _js2n__-prdslib.isType 'Record,
                          remote_store_rpc_concurrency =
                            _js2n__-prdslib.isType '"Number",
                          remote_store_rpc_retries =
                            _js2n__-prdslib.isType '"Number",
                          remote_store_rpc_timeout_millis =
                            _js2n__-prdslib.isType '"Number",
                          rule_threads_core = _js2n__-prdslib.isType '"Number",
                          rule_threads_max = _js2n__-prdslib.isType '"Number",
                          session_end_tasks_timeout =
                            _js2n__-prdslib.isType '"Number",
                          show_log_target = _js2n__-prdslib.isType '"Bool",
                          spec_files = _js2n__-prdslib.isType '"Array",
                          stats_record_option_scopes =
                            _js2n__-prdslib.isType '"Array",
                          streaming_workunits_complete_async =
                            _js2n__-prdslib.isType '"Bool",
                          streaming_workunits_level =
                            _js2n__-prdslib.enum
                                [ "trace", "debug", "info", "warn", "error" ],
                          streaming_workunits_report_interval =
                            _js2n__-prdslib.isType '"Number",
                          subproject_roots = _js2n__-prdslib.isType '"Array",
                          tag = _js2n__-prdslib.isType '"Array",
                          unmatched_build_file_globs =
                            _js2n__-prdslib.enum [ "ignore", "warn", "error" ],
                          unmatched_cli_globs =
                            _js2n__-prdslib.enum [ "ignore", "warn", "error" ],
                          verify_config = _js2n__-prdslib.isType '"Bool",
                          watch_filesystem = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              anonymous-telemetry =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          enabled = _js2n__-prdslib.isType '"Bool",
                          repo_id = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              autoflake =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              black =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              build-deprecations-fixer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { skip = _js2n__-prdslib.isType '"Bool", } {} true
                        _js2n__-prdslib.always
                    ],
              buildifier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              changed =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          dependents =
                            _js2n__-prdslib.enum
                                [ "none", "direct", "transitive" ],
                          diffspec = _js2n__-prdslib.isType '"String",
                          since = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              check =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { only = _js2n__-prdslib.isType '"Array", } {} true
                        _js2n__-prdslib.always
                    ],
              check-default-tools = _js2n__-prdslib.isType 'Record,
              cli =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { alias = _js2n__-prdslib.isType 'Record, } {} true
                        _js2n__-prdslib.always
                    ],
              complete =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { shell = _js2n__-prdslib.enum [ "bash", "zsh" ], } {}
                        true _js2n__-prdslib.always
                    ],
              count-loc = _js2n__-prdslib.isType 'Record,
              coursier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          jvm_index = _js2n__-prdslib.isType '"String",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          repos = _js2n__-prdslib.isType '"Array",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              coverage-py =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          fail_under = _js2n__-prdslib.isType '"Number",
                          filter = _js2n__-prdslib.isType '"Array",
                          global_report = _js2n__-prdslib.isType '"Bool",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          output_dir = _js2n__-prdslib.isType '"String",
                          report =
                            _js2n__-prdslib.enum
                                [
                                  "console",
                                  "xml",
                                  "html",
                                  "raw",
                                  "json",
                                  "lcov"
                                ],
                          requirements = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              debug-adapter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          host = _js2n__-prdslib.isType '"String",
                          port = _js2n__-prdslib.isType '"Number",
                        } {} true _js2n__-prdslib.always
                    ],
              debugpy =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              dependencies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          closed = _js2n__-prdslib.isType '"Bool",
                          format = _js2n__-prdslib.enum [ "text", "json" ],
                          output_file = _js2n__-prdslib.isType '"String",
                          sep = _js2n__-prdslib.isType '"String",
                          transitive = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              dependents =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          closed = _js2n__-prdslib.isType '"Bool",
                          format = _js2n__-prdslib.enum [ "text", "json" ],
                          output_file = _js2n__-prdslib.isType '"String",
                          sep = _js2n__-prdslib.isType '"String",
                          transitive = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              docformatter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              docker =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          build_args = _js2n__-prdslib.isType '"Array",
                          build_hosts = _js2n__-prdslib.isType 'Record,
                          build_no_cache = _js2n__-prdslib.isType '"Bool",
                          build_target_stage = _js2n__-prdslib.isType '"String",
                          build_verbose = _js2n__-prdslib.isType '"Bool",
                          default_context_root = _js2n__-prdslib.always,
                          default_repository = _js2n__-prdslib.isType '"String",
                          env_vars = _js2n__-prdslib.isType '"Array",
                          executable_search_paths =
                            _js2n__-prdslib.isType '"Array",
                          optional_tools = _js2n__-prdslib.isType '"Array",
                          registries =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType '"String"
                                ],
                          run_args = _js2n__-prdslib.isType '"Array",
                          tailor = _js2n__-prdslib.isType '"Bool",
                          tools = _js2n__-prdslib.isType '"Array",
                          use_buildx = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              dockerfile-parser =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          use_rust_parser = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              environments-preview =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { names = _js2n__-prdslib.isType 'Record, } {} true
                        _js2n__-prdslib.always
                    ],
              experimental-deploy =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          dry_run = _js2n__-prdslib.isType '"Bool",
                          publish_dependencies = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              experimental-explorer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          address = _js2n__-prdslib.isType '"String",
                          port = _js2n__-prdslib.isType '"Number",
                        } {} true _js2n__-prdslib.always
                    ],
              export =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          bin = _js2n__-prdslib.isType '"Array",
                          py_editable_in_resolve =
                            _js2n__-prdslib.isType '"Array",
                          py_generated_sources_in_resolve =
                            _js2n__-prdslib.isType '"Array",
                          py_non_hermetic_scripts_in_resolve =
                            _js2n__-prdslib.isType '"Array",
                          py_resolve_format =
                            _js2n__-prdslib.enum
                                [
                                  "mutable_virtualenv",
                                  "symlinked_immutable_virtualenv"
                                ],
                          resolve = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              export-codegen = _js2n__-prdslib.isType 'Record,
              filedeps =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          absolute = _js2n__-prdslib.isType '"Bool",
                          globs = _js2n__-prdslib.isType '"Bool",
                          output_file = _js2n__-prdslib.isType '"String",
                          sep = _js2n__-prdslib.isType '"String",
                          transitive = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              filter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          address_regex = _js2n__-prdslib.isType '"Array",
                          granularity =
                            _js2n__-prdslib.enum [ "all", "file", "BUILD" ],
                          output_file = _js2n__-prdslib.isType '"String",
                          sep = _js2n__-prdslib.isType '"String",
                          tag_regex = _js2n__-prdslib.isType '"Array",
                          target_type = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              fix =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          batch_size = _js2n__-prdslib.isType '"Number",
                          only = _js2n__-prdslib.isType '"Array",
                          skip_formatters = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              flake8 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          extra_files = _js2n__-prdslib.isType '"Array",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          source_plugins = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              fmt =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          batch_size = _js2n__-prdslib.isType '"Number",
                          only = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              generate-lockfiles =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          custom_command = _js2n__-prdslib.isType '"String",
                          diff = _js2n__-prdslib.isType '"Bool",
                          diff_include_unchanged =
                            _js2n__-prdslib.isType '"Bool",
                          resolve = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              generate-snapshots = _js2n__-prdslib.isType 'Record,
              go-generate =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { env_vars = _js2n__-prdslib.isType '"Array", } {} true
                        _js2n__-prdslib.always
                    ],
              go-test =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          block_profile = _js2n__-prdslib.isType '"Bool",
                          cover_mode =
                            _js2n__-prdslib.enum [ "set", "count", "atomic" ],
                          coverage_html = _js2n__-prdslib.isType '"Bool",
                          coverage_output_dir =
                            _js2n__-prdslib.isType '"String",
                          coverage_packages = _js2n__-prdslib.isType '"Array",
                          cpu_profile = _js2n__-prdslib.isType '"Bool",
                          force_asan = _js2n__-prdslib.isType '"Bool",
                          force_msan = _js2n__-prdslib.isType '"Bool",
                          force_race = _js2n__-prdslib.isType '"Bool",
                          mem_profile = _js2n__-prdslib.isType '"Bool",
                          mutex_profile = _js2n__-prdslib.isType '"Bool",
                          output_test_binary = _js2n__-prdslib.isType '"Bool",
                          skip = _js2n__-prdslib.isType '"Bool",
                          trace = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              gofmt =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              golang =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          asdf_bin_relpath = _js2n__-prdslib.isType '"String",
                          asdf_tool_name = _js2n__-prdslib.isType '"String",
                          cgo_c_flags = _js2n__-prdslib.isType '"Array",
                          cgo_cxx_flags = _js2n__-prdslib.isType '"Array",
                          cgo_enabled = _js2n__-prdslib.isType '"Bool",
                          cgo_fortran_binary_name =
                            _js2n__-prdslib.isType '"String",
                          cgo_fortran_flags = _js2n__-prdslib.isType '"Array",
                          cgo_gcc_binary_name =
                            _js2n__-prdslib.isType '"String",
                          cgo_gxx_binary_name =
                            _js2n__-prdslib.isType '"String",
                          cgo_linker_flags = _js2n__-prdslib.isType '"Array",
                          cgo_tool_search_paths =
                            _js2n__-prdslib.isType '"Array",
                          external_linker_binary_name =
                            _js2n__-prdslib.isType '"String",
                          extra_tools = _js2n__-prdslib.isType '"Array",
                          go_search_paths = _js2n__-prdslib.isType '"Array",
                          minimum_expected_version =
                            _js2n__-prdslib.isType '"String",
                          subprocess_env_vars = _js2n__-prdslib.isType '"Array",
                          tailor_binary_targets =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_go_mod_targets =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_package_targets =
                            _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              google-java-format =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          aosp = _js2n__-prdslib.isType '"Bool",
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          skip = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              graphql =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { open_graphiql = _js2n__-prdslib.isType '"Bool", } {}
                        true _js2n__-prdslib.always
                    ],
              hadolint =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              help = _js2n__-prdslib.isType 'Record,
              help-advanced = _js2n__-prdslib.isType 'Record,
              help-all = _js2n__-prdslib.isType 'Record,
              internal-generate-test-lockfile-fixtures =
                _js2n__-prdslib.isType 'Record,
              ipython =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          ignore_cwd = _js2n__-prdslib.isType '"Bool",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          requirements = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              isort =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.isType '"Array",
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              jar_tool =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              jarjar =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          misplaced_class_strategy =
                            _js2n__-prdslib.enum
                                [ "fatal", "skip", "omit", "move" ],
                          skip_manifest = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              java-dump-source-analysis = _js2n__-prdslib.isType 'Record,
              java-infer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          consumed_types = _js2n__-prdslib.isType '"Bool",
                          imports = _js2n__-prdslib.isType '"Bool",
                          third_party_import_mapping =
                            _js2n__-prdslib.isType 'Record,
                        } {} true _js2n__-prdslib.always
                    ],
              java-parser =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              javac =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          tailor_source_targets =
                            _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              junit =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          skip = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              jvm =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          debug_args = _js2n__-prdslib.isType '"Array",
                          default_resolve = _js2n__-prdslib.isType '"String",
                          deploy_jar_exclude_files =
                            _js2n__-prdslib.isType '"Array",
                          global_options = _js2n__-prdslib.isType '"Array",
                          jdk = _js2n__-prdslib.isType '"String",
                          nailgun_remote_cache_speculation_delay =
                            _js2n__-prdslib.isType '"Number",
                          reproducible_jars = _js2n__-prdslib.isType '"Bool",
                          resolves = _js2n__-prdslib.isType 'Record,
                          tool_jdk = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              jvm-symbol-map = _js2n__-prdslib.isType 'Record,
              lint =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          batch_size = _js2n__-prdslib.isType '"Number",
                          only = _js2n__-prdslib.isType '"Array",
                          skip_fixers = _js2n__-prdslib.isType '"Bool",
                          skip_formatters = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              list =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          documented = _js2n__-prdslib.isType '"Bool",
                          output_file = _js2n__-prdslib.isType '"String",
                          sep = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              migrate-call-by-name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { json = _js2n__-prdslib.isType '"Bool", } {} true
                        _js2n__-prdslib.always
                    ],
              mypy =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          source_plugins = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              nodejs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          corepack_env_vars = _js2n__-prdslib.isType '"Array",
                          executable_search_paths =
                            _js2n__-prdslib.isType '"Array",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          package_manager = _js2n__-prdslib.isType '"String",
                          package_managers = _js2n__-prdslib.isType 'Record,
                          resolves = _js2n__-prdslib.isType 'Record,
                          search_path = _js2n__-prdslib.isType '"Array",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              nodejs-infer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          imports = _js2n__-prdslib.isType '"Bool",
                          package_json_entry_points =
                            _js2n__-prdslib.isType '"Bool",
                          unowned_dependency_behavior =
                            _js2n__-prdslib.enum
                                [ "error", "warning", "ignore" ],
                        } {} true _js2n__-prdslib.always
                    ],
              nodejs-test =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          coverage_output_dir =
                            _js2n__-prdslib.isType '"String",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              package = _js2n__-prdslib.isType 'Record,
              paths =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          from = _js2n__-prdslib.isType '"String",
                          output_file = _js2n__-prdslib.isType '"String",
                          to = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              peek =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          exclude_defaults = _js2n__-prdslib.isType '"Bool",
                          include_additional_info =
                            _js2n__-prdslib.isType '"Bool",
                          include_dep_rules = _js2n__-prdslib.isType '"Bool",
                          output_file = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              pex =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          emit_warnings = _js2n__-prdslib.isType '"Bool",
                          executable_search_paths =
                            _js2n__-prdslib.isType '"Array",
                          venv_use_symlinks = _js2n__-prdslib.isType '"Bool",
                          verbosity = _js2n__-prdslib.isType '"Number",
                        } {} true _js2n__-prdslib.always
                    ],
              pex-binary-defaults =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { emit_warnings = _js2n__-prdslib.isType '"Bool", } {}
                        true _js2n__-prdslib.always
                    ],
              pex-cli =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          global_args = _js2n__-prdslib.isType '"Array",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              preamble =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          skip = _js2n__-prdslib.isType '"Bool",
                          template_by_globs =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType '"String"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              prettier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          skip = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              publish =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { output = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
              py-constraints =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          output_file = _js2n__-prdslib.isType '"String",
                          summary = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              pyoxidizer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              pytest =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          execution_slot_var = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          junit_family = _js2n__-prdslib.isType '"String",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          xdist_enabled = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              python =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          default_resolve = _js2n__-prdslib.isType '"String",
                          default_run_goal_use_sandbox =
                            _js2n__-prdslib.isType '"Bool",
                          enable_lockfile_targets =
                            _js2n__-prdslib.isType '"Bool",
                          enable_resolves = _js2n__-prdslib.isType '"Bool",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          interpreter_versions_universe =
                            _js2n__-prdslib.isType '"Array",
                          invalid_lockfile_behavior =
                            _js2n__-prdslib.enum [ "error", "ignore", "warn" ],
                          macos_big_sur_compatibility =
                            _js2n__-prdslib.isType '"Bool",
                          pip_version = _js2n__-prdslib.isType '"String",
                          repl_history = _js2n__-prdslib.isType '"Bool",
                          resolver_manylinux = _js2n__-prdslib.isType '"String",
                          resolves = _js2n__-prdslib.isType 'Record,
                          resolves_generate_lockfiles =
                            _js2n__-prdslib.isType '"Bool",
                          resolves_to_constraints_file =
                            _js2n__-prdslib.isType 'Record,
                          resolves_to_interpreter_constraints =
                            _js2n__-prdslib.isType 'Record,
                          resolves_to_no_binary =
                            _js2n__-prdslib.isType 'Record,
                          resolves_to_only_binary =
                            _js2n__-prdslib.isType 'Record,
                          run_against_entire_lockfile =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_ignore_empty_init_files =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_pex_binary_targets =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_py_typed_targets =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_requirements_targets =
                            _js2n__-prdslib.isType '"Bool",
                          tailor_source_targets =
                            _js2n__-prdslib.isType '"Bool",
                          warn_on_python2_usage =
                            _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              python-bootstrap =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          internal_python_build_standalone_info =
                            _js2n__-prdslib.isType 'Record,
                          names = _js2n__-prdslib.isType '"Array",
                          search_path = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              python-dump-source-analysis =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          analysis_flavor =
                            _js2n__-prdslib.enum
                                [
                                  "raw_dependency_inference",
                                  "dependency_inference"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              python-infer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          ambiguity_resolution =
                            _js2n__-prdslib.enum [ "none", "by_source_root" ],
                          assets = _js2n__-prdslib.isType '"Bool",
                          assets_min_slashes = _js2n__-prdslib.isType '"Number",
                          conftests = _js2n__-prdslib.isType '"Bool",
                          entry_points = _js2n__-prdslib.isType '"Bool",
                          ignored_unowned_imports =
                            _js2n__-prdslib.isType '"Array",
                          imports = _js2n__-prdslib.isType '"Bool",
                          init_files =
                            _js2n__-prdslib.enum
                                [ "always", "content_only", "never" ],
                          string_imports = _js2n__-prdslib.isType '"Bool",
                          string_imports_min_dots =
                            _js2n__-prdslib.isType '"Number",
                          unowned_dependency_behavior =
                            _js2n__-prdslib.enum
                                [ "error", "warning", "ignore" ],
                          use_rust_parser = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              python-native-code =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          cpp_flags = _js2n__-prdslib.isType '"Array",
                          ld_flags = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              python-repos =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          find_links = _js2n__-prdslib.isType '"Array",
                          indexes = _js2n__-prdslib.isType '"Array",
                          path_mappings = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              pyupgrade =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              regex-lint =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          config =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType '"String"
                                ],
                          detail_level =
                            _js2n__-prdslib.enum
                                [
                                  "none",
                                  "summary",
                                  "nonmatching",
                                  "names",
                                  "all"
                                ],
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              repl =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          restartable = _js2n__-prdslib.isType '"Bool",
                          shell = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              roots =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          output_file = _js2n__-prdslib.isType '"String",
                          sep = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              ruff =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              run =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          debug_adapter = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              scala =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          tailor_source_targets =
                            _js2n__-prdslib.isType '"Bool",
                          version_for_resolve = _js2n__-prdslib.isType 'Record,
                        } {} true _js2n__-prdslib.always
                    ],
              scala-dump-source-analysis = _js2n__-prdslib.isType 'Record,
              scala-infer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          consumed_types = _js2n__-prdslib.isType '"Bool",
                          force_add_siblings_as_dependencies =
                            _js2n__-prdslib.isType '"Bool",
                          imports = _js2n__-prdslib.isType '"Bool",
                          package_objects = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              scala-parser =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              scalac =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          plugins_for_resolve = _js2n__-prdslib.isType 'Record,
                        } {} true _js2n__-prdslib.always
                    ],
              scalafix =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          config_file_name = _js2n__-prdslib.isType '"String",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          orphan_files_behavior =
                            _js2n__-prdslib.enum [ "ignore", "error", "warn" ],
                          rule_targets = _js2n__-prdslib.isType '"Array",
                          semantic_rules = _js2n__-prdslib.isType '"Bool",
                          skip = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              scalafmt =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          config_file_name = _js2n__-prdslib.isType '"String",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          orphan_files_behavior =
                            _js2n__-prdslib.enum [ "ignore", "error", "warn" ],
                          skip = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              scalatest =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          skip = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              scc =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              setup-py-generation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          first_party_dependency_version_scheme =
                            _js2n__-prdslib.enum
                                [ "exact", "compatible", "any" ],
                          generate_setup_default =
                            _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              setuptools =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          requirements = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              setuptools-scm =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              shell-setup =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          dependency_inference = _js2n__-prdslib.isType '"Bool",
                          executable_search_paths =
                            _js2n__-prdslib.isType '"Array",
                          tailor_shunit2_tests = _js2n__-prdslib.isType '"Bool",
                          tailor_sources = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              shell-test =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { skip = _js2n__-prdslib.isType '"Bool", } {} true
                        _js2n__-prdslib.always
                    ],
              shellcheck =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              shfmt =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              shunit2 =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              source =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          marker_filenames = _js2n__-prdslib.isType '"Array",
                          root_patterns = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              stats =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          format = _js2n__-prdslib.enum [ "text", "jsonlines" ],
                          log = _js2n__-prdslib.isType '"Bool",
                          memory_summary = _js2n__-prdslib.isType '"Bool",
                          output_file = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              strip-jar =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          artifacts = _js2n__-prdslib.isType '"Array",
                          jvm_options = _js2n__-prdslib.isType '"Array",
                          lockfile = _js2n__-prdslib.isType '"String",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              subprocess-environment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { env_vars = _js2n__-prdslib.isType '"Array", } {} true
                        _js2n__-prdslib.always
                    ],
              system-binaries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          system_binary_paths = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              tailor =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          alias_mapping = _js2n__-prdslib.isType 'Record,
                          build_file_header = _js2n__-prdslib.isType '"String",
                          build_file_indent = _js2n__-prdslib.isType '"String",
                          build_file_name = _js2n__-prdslib.isType '"String",
                          check = _js2n__-prdslib.isType '"Bool",
                          ignore_adding_targets =
                            _js2n__-prdslib.isType '"Array",
                          ignore_paths = _js2n__-prdslib.isType '"Array",
                        } {} true _js2n__-prdslib.always
                    ],
              taplo =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          glob_pattern = _js2n__-prdslib.isType '"Array",
                          known_versions = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                          url_platform_mapping = _js2n__-prdslib.isType 'Record,
                          url_template = _js2n__-prdslib.isType '"String",
                          use_unsupported_version =
                            _js2n__-prdslib.enum [ "error", "warning" ],
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              test =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          attempts_default = _js2n__-prdslib.isType '"Number",
                          batch_size = _js2n__-prdslib.isType '"Number",
                          debug = _js2n__-prdslib.isType '"Bool",
                          debug_adapter = _js2n__-prdslib.isType '"Bool",
                          experimental_report_test_result_info =
                            _js2n__-prdslib.isType '"Bool",
                          extra_env_vars = _js2n__-prdslib.isType '"Array",
                          "force" = _js2n__-prdslib.isType '"Bool",
                          open_coverage = _js2n__-prdslib.isType '"Bool",
                          output =
                            _js2n__-prdslib.enum [ "all", "failed", "none" ],
                          report = _js2n__-prdslib.isType '"Bool",
                          report_dir = _js2n__-prdslib.isType '"String",
                          shard = _js2n__-prdslib.isType '"String",
                          show_rerun_command = _js2n__-prdslib.isType '"Bool",
                          timeout_default = _js2n__-prdslib.isType '"Number",
                          timeout_maximum = _js2n__-prdslib.isType '"Number",
                          timeouts = _js2n__-prdslib.isType '"Bool",
                          use_coverage = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              twine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          ca_certs_path = _js2n__-prdslib.isType '"String",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              update-build-files =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          check = _js2n__-prdslib.isType '"Bool",
                          fix_safe_deprecations =
                            _js2n__-prdslib.isType '"Bool",
                          fmt = _js2n__-prdslib.isType '"Bool",
                          formatter =
                            _js2n__-prdslib.enum
                                [ "yapf", "black", "ruff", "buildifier" ],
                        } {} true _js2n__-prdslib.always
                    ],
              version = _js2n__-prdslib.isType 'Record,
              visibility =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          enforce = _js2n__-prdslib.isType '"Bool",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              workunit-logger =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          enabled = _js2n__-prdslib.isType '"Bool",
                          logdir = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              yapf =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          args = _js2n__-prdslib.isType '"Array",
                          config = _js2n__-prdslib.always,
                          config_discovery = _js2n__-prdslib.isType '"Bool",
                          console_script = _js2n__-prdslib.isType '"String",
                          entry_point = _js2n__-prdslib.isType '"String",
                          install_from_resolve =
                            _js2n__-prdslib.isType '"String",
                          interpreter_constraints =
                            _js2n__-prdslib.isType '"Array",
                          requirements = _js2n__-prdslib.isType '"Array",
                          skip = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
            } {} true _js2n__-prdslib.always
        ])