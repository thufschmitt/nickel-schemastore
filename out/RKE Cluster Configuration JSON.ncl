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
      "_js2n__-:definitions/AESConfiguration!contract" =
        { keys | Array _js2n__-refsenv."_js2n__-:definitions/Key!contract", },
      "_js2n__-:definitions/AWSCloudProvider!contract" =
        {
            global
              | _js2n__-refsenv."_js2n__-:definitions/GlobalAwsOpts!contract",
            serviceOverride
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-refsenv."_js2n__-:definitions/ServiceOverride!predicate",
                      } true _js2n__-prdslib.always
                  ])
              | optional,
          },
      "_js2n__-:definitions/AWSElasticBlockStoreVolumeSource!contract" =
        {
            fsType | String | optional,
            partition | std.number.Integer | optional,
            readOnly | Bool | optional,
            volumeID | String,
          },
      "_js2n__-:definitions/AciNetworkProvider!contract" =
        {
            aep | String | optional,
            apicHosts | Array (String) | optional,
            apicRefreshTime | String | optional,
            apicUserCrt | String | optional,
            apicUserKey | String | optional,
            apicUserName | String | optional,
            capic | String | optional,
            controllerLogLevel | String | optional,
            dropLogEnable | String | optional,
            enableEndpointSlice | String | optional,
            encapType | String | optional,
            epRegistry | String | optional,
            externDynamic | String | optional,
            externStatic | String | optional,
            gbpPodSubnet | String | optional,
            hostAgentLogLevel | String | optional,
            imagePullPolicy | String | optional,
            imagePullSecret | String | optional,
            infraVlan | String | optional,
            installIstio | String | optional,
            istioProfile | String | optional,
            kafkaBrokers | Array (String) | optional,
            kafkaClientCrt | String | optional,
            kafkaClientKey | String | optional,
            kubeApiVlan | String | optional,
            l3out | String | optional,
            l3outExternalNetworks | Array (String) | optional,
            maxNodesSvcGraph | String | optional,
            mcastRangeEnd | String | optional,
            mcastRangeStart | String | optional,
            noPriorityClass | String | optional,
            nodeSubnet | String | optional,
            nodeSvcSubnet | String | optional,
            opflexClientSsl | String | optional,
            opflexLogLevel | String | optional,
            opflexMode | String | optional,
            opflexServerPort
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            overlayVrfName | String | optional,
            ovsMemoryLimit | String | optional,
            pbrTrackingNonSnat | String | optional,
            podSubnetChunkSize | String | optional,
            runGbpContainer | String | optional,
            runOpflexServerContainer | String | optional,
            serviceMonitorInterval | String | optional,
            serviceVlan | String | optional,
            snatContractScope | String | optional,
            snatNamespace | String | optional,
            snatPortRangeEnd
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            snatPortRangeStart
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            snatPortsPerNode
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            subnetDomainName | String | optional,
            systemId | String | optional,
            tenant | String | optional,
            token | String | optional,
            useAciAnywhereCrd | String | optional,
            useAciCniPriorityClass | String | optional,
            useHostNetnsVolume | String | optional,
            useOpflexServerVolume | String | optional,
            usePrivilegedContainer | String | optional,
            vmmController | String | optional,
            vmmDomain | String | optional,
            vrfName | String | optional,
            vrfTenant | String | optional,
          },
      "_js2n__-:definitions/AdmissionConfiguration!contract" =
        {
            TypeMeta | _js2n__-refsenv."_js2n__-:definitions/TypeMeta!contract",
            plugins
              | Array
                _js2n__-refsenv."_js2n__-:definitions/AdmissionPluginConfiguration!contract",
          },
      "_js2n__-:definitions/AdmissionPluginConfiguration!contract" =
        {
            configuration
              | _js2n__-refsenv."_js2n__-:definitions/Unknown!contract",
            name | String,
            path | String,
          },
      "_js2n__-:definitions/AuditLog!contract" =
        {
            configuration
              | _js2n__-refsenv."_js2n__-:definitions/AuditLogConfig!contract"
              | optional,
            enabled | Bool | optional,
          },
      "_js2n__-:definitions/AuditLogConfig!contract" =
        {
            format | String | optional,
            maxAge | std.number.Integer | optional,
            maxBackup | std.number.Integer | optional,
            maxSize | std.number.Integer | optional,
            path | String | optional,
            policy
              | _js2n__-refsenv."_js2n__-:definitions/Policy!contract"
              | optional,
          },
      "_js2n__-:definitions/AuthWebhookConfig!contract" =
        {
            cacheTimeout
              | String
              | doc "CacheTimeout controls how long to cache authentication decisions"
              | optional,
            configFile
              | String
              | doc "ConfigFile is a multiline string that represent a custom webhook config file"
              | optional,
          },
      "_js2n__-:definitions/AuthnConfig!contract" =
        {
            sans
              | Array (String)
              | doc "List of additional hostnames and IPs to include in the api server PKI cert"
              | optional,
            strategy
              | String
              | doc "Authentication strategy that will be used in kubernetes cluster"
              | optional,
            webhook
              | _js2n__-refsenv."_js2n__-:definitions/AuthWebhookConfig!contract"
              | doc "Webhook configuration options"
              | optional,
          },
      "_js2n__-:definitions/AuthzConfig!contract" =
        {
            mode
              | String
              | doc "Authorization mode used by kubernetes"
              | optional,
            options
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "Authorization mode options"
              | optional,
          },
      "_js2n__-:definitions/AzureCloudProvider!contract" =
        {
            aadClientCertPassword
              | String
              | doc m%"
                The password of the client certificate for an AAD application with RBAC access to talk to Azure RM APIs
                This's used for client certificate authentication: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-protocols-oauth-service-to-service
              "%,
            aadClientCertPath
              | String
              | doc m%"
                The path of a client certificate for an AAD application with RBAC access to talk to Azure RM APIs
                This's used for client certificate authentication: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-protocols-oauth-service-to-service
              "%,
            aadClientId
              | String
              | doc m%"
                The ClientID for an AAD application with RBAC access to talk to Azure RM APIs
                This's used for service principal authentication: https://github.com/Azure/aks-engine/blob/master/docs/topics/service-principals.md
              "%,
            aadClientSecret
              | String
              | doc m%"
                The ClientSecret for an AAD application with RBAC access to talk to Azure RM APIs
                This's used for service principal authentication: https://github.com/Azure/aks-engine/blob/master/docs/topics/service-principals.md
              "%,
            cloud
              | String
              | doc "The cloud environment identifier. Takes values from https://github.com/Azure/go-autorest/blob/ec5f4903f77ed9927ac95b19ab8e44ada64c1356/autorest/azure/environments.go#L13",
            cloudProviderBackoff
              | Bool
              | doc "Enable exponential backoff to manage resource request retries",
            cloudProviderBackoffDuration
              | std.number.Integer
              | doc "Backoff duration",
            cloudProviderBackoffExponent
              | std.number.Integer
              | doc "Backoff exponent",
            cloudProviderBackoffJitter
              | std.number.Integer
              | doc "Backoff jitter",
            cloudProviderBackoffRetries
              | std.number.Integer
              | doc "Backoff retry limit",
            cloudProviderRateLimit | Bool | doc "Enable rate limiting",
            cloudProviderRateLimitBucket
              | std.number.Integer
              | doc "Rate limit Bucket Size",
            cloudProviderRateLimitQPS
              | std.number.Integer
              | doc "Rate limit QPS",
            excludeMasterFromStandardLB
              | Bool
              | doc m%"
                Excludes master nodes (labeled with `node-role.kubernetes.io/master`) from the backend pool of Azure standard loadbalancer, default(nil) to `true`
                If want adding the master nodes to ALB, this should be set to `false` and remove the `node-role.kubernetes.io/master` label from master nodes
              "%
              | optional,
            loadBalancerSku
              | String
              | doc "Sku of Load Balancer and Public IP: `basic` or `standard`, default(blank) to `basic`"
              | optional,
            location
              | String
              | doc "The location of the resource group that the cluster is deployed in",
            maximumLoadBalancerRuleCount
              | std.number.Integer
              | doc "Maximum allowed LoadBalancer Rule Count is the limit enforced by Azure Load balancer, default(0) to 148",
            primaryAvailabilitySetName
              | String
              | doc m%"
                (Optional) The name of the availability set that should be used as the load balancer backend
                If this is set, the Azure cloudprovider will only add nodes from that availability set to the load
                balancer backend pool. If this is not set, and multiple agent pools (availability sets) are used, then
                the cloudprovider will try to add all nodes to a single backend pool which is forbidden.
                In other words, if you use multiple agent pools (availability sets), you MUST set this field.
              "%,
            primaryScaleSetName
              | String
              | doc m%"
                The name of the scale set that should be used as the load balancer backend.
                If this is set, the Azure cloudprovider will only add nodes from that scale set to the load
                balancer backend pool. If this is not set, and multiple agent pools (scale sets) are used, then
                the cloudprovider will try to add all nodes to a single backend pool which is forbidden.
                In other words, if you use multiple agent pools (scale sets), you MUST set this field.
              "%,
            resourceGroup
              | String
              | doc "The name of the resource group that the cluster is deployed in",
            routeTableName
              | String
              | doc "(Optional in 1.6) The name of the route table attached to the subnet that the cluster is deployed in",
            securityGroupName
              | String
              | doc "The name of the security group attached to the cluster's subnet",
            subnetName
              | String
              | doc "The name of the subnet that the cluster is deployed in",
            subscriptionId
              | String
              | doc "The ID of the Azure Subscription that the cluster is deployed in",
            tenantId
              | String
              | doc "The AAD Tenant ID for the Subscription that the cluster is deployed in",
            useInstanceMetadata
              | Bool
              | doc "Use instance metadata service where possible",
            useManagedIdentityExtension
              | Bool
              | doc m%"
                Use managed service identity for the virtual machine to access Azure ARM APIs
                This's used for managed identity authentication: https://docs.microsoft.com/en-us/azure/active-directory/managed-service-identity/overview
                For user-assigned managed identity, need to set the below UserAssignedIdentityID
              "%,
            userAssignedIdentityID
              | String
              | doc m%"
                The Client ID of the user assigned MSI which is assigned to the underlying VMs
                This's used for managed identity authentication: https://docs.microsoft.com/en-us/azure/active-directory/managed-service-identity/overview
              "%
              | optional,
            vmType
              | String
              | doc m%"
                The type of azure nodes. Candidate valudes are: vmss and standard.
                If not set, it will be default to standard.
              "%,
            vnetName
              | String
              | doc "The name of the VNet that the cluster is deployed in",
            vnetResourceGroup
              | String
              | doc "The name of the resource group that the Vnet is deployed in",
          },
      "_js2n__-:definitions/AzureDiskVolumeSource!contract" =
        {
            cachingMode | String | optional,
            diskName | String,
            diskURI | String,
            fsType | String | optional,
            kind | String | optional,
            readOnly | Bool | optional,
          },
      "_js2n__-:definitions/AzureFileVolumeSource!contract" =
        {
            readOnly | Bool | optional,
            secretName | String,
            shareName | String,
          },
      "_js2n__-:definitions/BackupConfig!contract" =
        {
            enabled | Bool | optional,
            intervalHours | std.number.Integer | optional,
            retention | std.number.Integer | optional,
            s3BackupConfig
              | _js2n__-refsenv."_js2n__-:definitions/S3BackupConfig!contract",
            safeTimestamp | Bool | optional,
            timeout | std.number.Integer | optional,
          },
      "_js2n__-:definitions/BastionHost!contract" =
        {
            address | String | doc "Address of Bastion Host" | optional,
            ignoreProxyEnvVars
              | Bool
              | doc "Ignore proxy environment variables"
              | optional,
            port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "SSH Port of Bastion Host"
              | optional,
            sshAgentAuth | Bool | doc "SSH Agent Auth enable" | optional,
            sshCert | String | doc "SSH Certificate" | optional,
            sshCertPath | String | doc "SSH Certificate Path" | optional,
            sshKey | String | doc "SSH Private Key" | optional,
            sshKeyPath | String | doc "SSH Private Key Path" | optional,
            user | String | doc "ssh User to Bastion Host" | optional,
          },
      "_js2n__-:definitions/BlockStorageOpenstackOpts!contract" =
        {
            bs-version
              | String
              | doc "overrides autodetection. v1 or v2. Defaults to auto",
            ignore-volume-az | Bool,
            trust-device-path | Bool | doc "See Issue #33128",
          },
      "_js2n__-:definitions/CSIVolumeSource!contract" =
        {
            driver | String,
            fsType | String | optional,
            nodePublishSecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
            readOnly | Bool | optional,
            volumeAttributes
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
          },
      "_js2n__-:definitions/CalicoNetworkProvider!contract" =
        {
            cloudProvider | String | doc "Cloud provider type used with calico",
          },
      "_js2n__-:definitions/CanalNetworkProvider!contract" =
        { iface | String, },
      "_js2n__-:definitions/CephFSVolumeSource!contract" =
        {
            monitors | Array (String),
            path | String | optional,
            readOnly | Bool | optional,
            secretFile | String | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
            user | String | optional,
          },
      "_js2n__-:definitions/CinderVolumeSource!contract" =
        {
            fsType | String | optional,
            readOnly | Bool | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
            volumeID | String,
          },
      "_js2n__-:definitions/CloudProvider!contract" =
        {
            awsCloudProvider
              | _js2n__-refsenv."_js2n__-:definitions/AWSCloudProvider!contract"
              | doc "AWSCloudProvider"
              | optional,
            azureCloudProvider
              | _js2n__-refsenv."_js2n__-:definitions/AzureCloudProvider!contract"
              | doc "AzureCloudProvider"
              | optional,
            customCloudProvider
              | String
              | doc "CustomCloudProvider is a multiline string that represent a custom cloud config file"
              | optional,
            name | String | doc "Name of the Cloud Provider" | optional,
            openstackCloudProvider
              | _js2n__-refsenv."_js2n__-:definitions/OpenstackCloudProvider!contract"
              | doc "OpenstackCloudProvider"
              | optional,
            vsphereCloudProvider
              | _js2n__-refsenv."_js2n__-:definitions/VsphereCloudProvider!contract"
              | doc "VsphereCloudProvider"
              | optional,
          },
      "_js2n__-:definitions/ConfigMapKeySelector!contract" =
        {
            LocalObjectReference
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            key | String,
            "optional" | Bool | optional,
          },
      "_js2n__-:definitions/ConfigMapProjection!contract" =
        {
            LocalObjectReference
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract"
              | optional,
            "optional" | Bool | optional,
          },
      "_js2n__-:definitions/ConfigMapVolumeSource!contract" =
        {
            LocalObjectReference
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            defaultMode | std.number.Integer | optional,
            items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract"
              | optional,
            "optional" | Bool | optional,
          },
      "_js2n__-:definitions/Configuration!contract" =
        {
            TypeMeta | _js2n__-refsenv."_js2n__-:definitions/TypeMeta!contract",
            limits
              | Array _js2n__-refsenv."_js2n__-:definitions/Limit!contract",
          },
      "_js2n__-:definitions/DNSConfig!contract" =
        {
            linearAutoscalerParams
              | _js2n__-refsenv."_js2n__-:definitions/LinearAutoscalerParams!contract"
              | doc "Autoscaler fields to determine number of dns replicas"
              | optional,
            nodeSelector
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "NodeSelector key pair"
              | optional,
            nodelocal
              | _js2n__-refsenv."_js2n__-:definitions/Nodelocal!contract"
              | doc "Nodelocal DNS"
              | optional,
            options
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "DNS config options"
              | optional,
            provider | String | doc "DNS provider" | optional,
            reversecidrs | Array (String) | doc "ReverseCIDRs" | optional,
            stubdomains
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "Stubdomains"
              | optional,
            tolerations
              | Array _js2n__-refsenv."_js2n__-:definitions/Toleration!contract"
              | doc "Tolerations for Deployments"
              | optional,
            updateStrategy
              | _js2n__-refsenv."_js2n__-:definitions/DeploymentStrategy!contract"
              | doc "Update strategy"
              | optional,
            upstreamnameservers
              | Array (String)
              | doc "Upstream nameservers"
              | optional,
          },
      "_js2n__-:definitions/DaemonSetUpdateStrategy!contract" =
        {
            rollingUpdate
              | _js2n__-refsenv."_js2n__-:definitions/RollingUpdateDaemonSet!contract"
              | optional,
            strategy | String | optional,
          },
      "_js2n__-:definitions/DeploymentStrategy!contract" =
        {
            rollingUpdate
              | _js2n__-refsenv."_js2n__-:definitions/RollingUpdateDeployment!contract"
              | optional,
            strategy | String | optional,
          },
      "_js2n__-:definitions/DiskVsphereOpts!contract" =
        { scsicontrollertype | String | optional, },
      "_js2n__-:definitions/DownwardAPIProjection!contract" =
        {
            items
              | Array
                _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeFile!contract"
              | optional,
          },
      "_js2n__-:definitions/DownwardAPIVolumeFile!contract" =
        {
            fieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ObjectFieldSelector!contract"
              | optional,
            mode | std.number.Integer | optional,
            path | String,
            resourceFieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ResourceFieldSelector!contract"
              | optional,
          },
      "_js2n__-:definitions/DownwardAPIVolumeSource!contract" =
        {
            defaultMode | std.number.Integer | optional,
            items
              | Array
                _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeFile!contract"
              | optional,
          },
      "_js2n__-:definitions/Duration!contract" = {},
      "_js2n__-:definitions/ECRCredentialPlugin!contract" =
        {
            awsAccessKeyId | String | optional,
            awsAccessToken | String | optional,
            awsSecretAccessKey | String | optional,
          },
      "_js2n__-:definitions/ETCDService!contract" =
        {
            backupConfig
              | _js2n__-refsenv."_js2n__-:definitions/BackupConfig!contract"
              | doc "Backup backend for etcd snapshots"
              | optional,
            caCert | String | doc "External CA certificate" | optional,
            cert | String | doc "External Client certificate" | optional,
            creation | String | doc "Etcd snapshot Creation period" | optional,
            externalUrls | Array (String) | doc "List of etcd urls" | optional,
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            extraBinds | Array (String) | optional,
            extraEnv | Array (String) | optional,
            gid
              | std.number.Integer
              | doc "GID to run etcd container as"
              | optional,
            image | String | optional,
            key | String | doc "External Client key" | optional,
            path | String | doc "External etcd prefix" | optional,
            retention
              | String
              | doc "Etcd snapshot Retention period"
              | optional,
            snapshot
              | Bool
              | doc "Etcd Recurring snapshot Service, used by rke only"
              | optional,
            uid
              | std.number.Integer
              | doc "UID to run etcd container as"
              | optional,
            winExtraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            winExtraBinds | Array (String) | optional,
            winExtraEnv | Array (String) | optional,
          },
      "_js2n__-:definitions/EmptyDirVolumeSource!contract" =
        {
            medium | String | optional,
            sizeLimit
              | _js2n__-refsenv."_js2n__-:definitions/Quantity!contract"
              | optional,
          },
      "_js2n__-:definitions/EncryptionConfiguration!contract" =
        {
            apiVersion | String | optional,
            kind | String | optional,
            resources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ResourceConfiguration!contract",
          },
      "_js2n__-:definitions/EnvVarSource!contract" =
        {
            configMapKeyRef
              | _js2n__-refsenv."_js2n__-:definitions/ConfigMapKeySelector!contract"
              | optional,
            fieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ObjectFieldSelector!contract"
              | optional,
            resourceFieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ResourceFieldSelector!contract"
              | optional,
            secretKeyRef
              | _js2n__-refsenv."_js2n__-:definitions/SecretKeySelector!contract"
              | optional,
          },
      "_js2n__-:definitions/EphemeralVolumeSource!contract" =
        {
            volumeClaimTemplate
              | _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimTemplate!contract"
              | optional,
          },
      "_js2n__-:definitions/EventRateLimit!contract" =
        {
            configuration
              | _js2n__-refsenv."_js2n__-:definitions/Configuration!contract"
              | optional,
            enabled | Bool | optional,
          },
      "_js2n__-:definitions/ExtraEnv!contract" =
        {
            name | String,
            value | String | optional,
            valueFrom
              | _js2n__-refsenv."_js2n__-:definitions/EnvVarSource!contract"
              | optional,
          },
      "_js2n__-:definitions/ExtraVolume!contract" =
        {
            VolumeSource
              | _js2n__-refsenv."_js2n__-:definitions/VolumeSource!contract",
            name | String,
          },
      "_js2n__-:definitions/ExtraVolumeMount!contract" =
        {
            mountPath | String,
            mountPropagation | String | optional,
            name | String,
            readOnly | Bool | optional,
            subPath | String | optional,
            subPathExpr | String | optional,
          },
      "_js2n__-:definitions/FCVolumeSource!contract" =
        {
            fsType | String | optional,
            lun | std.number.Integer | optional,
            readOnly | Bool | optional,
            targetWWNs | Array (String) | optional,
            wwids | Array (String) | optional,
          },
      "_js2n__-:definitions/FieldsV1!contract" = {},
      "_js2n__-:definitions/FlannelNetworkProvider!contract" =
        { iface | String | doc "Alternate cloud interface for flannel", },
      "_js2n__-:definitions/FlexVolumeSource!contract" =
        {
            driver | String,
            fsType | String | optional,
            options
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            readOnly | Bool | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
          },
      "_js2n__-:definitions/FlockerVolumeSource!contract" =
        { datasetName | String | optional, datasetUUID | String | optional, },
      "_js2n__-:definitions/GCEPersistentDiskVolumeSource!contract" =
        {
            fsType | String | optional,
            partition | std.number.Integer | optional,
            pdName | String,
            readOnly | Bool | optional,
          },
      "_js2n__-:definitions/GitRepoVolumeSource!contract" =
        {
            directory | String | optional,
            repository | String,
            revision | String | optional,
          },
      "_js2n__-:definitions/GlobalAwsOpts!contract" =
        {
            disable-security-group-ingress
              | Bool
              | doc m%"
                The aws provider creates an inbound rule per load balancer on the node security
                group. However, this can run into the AWS security group rule limit of 50 if
                many LoadBalancers are created.
                
                This flag disables the automatic ingress creation. It requires that the user
                has setup a rule that allows inbound traffic on kubelet ports from the
                local VPC subnet (so load balancers can access it). E.g. 10.82.0.0/16 30000-32000.
              "%,
            disable-strict-zone-check
              | Bool
              | doc m%"
                During the instantiation of an new AWS cloud provider, the detected region
                is validated against a known set of regions.
                
                In a non-standard, AWS like environment (e.g. Eucalyptus), this check may
                be undesirable.  Setting this to true will disable the check and provide
                a warning that the check was skipped.  Please note that this is an
                experimental feature and work-in-progress for the moment.  If you find
                yourself in an non-AWS cloud and open an issue, please indicate that in the
                issue body.
              "%,
            elb-security-group
              | String
              | doc m%"
                AWS has a hard limit of 500 security groups. For large clusters creating a security group for each ELB
                can cause the max number of security groups to be reached. If this is set instead of creating a new
                Security group for each ELB this security group will be used instead.
              "%,
            kubernetes-cluster-id
              | String
              | doc "KubernetesClusterID is the cluster id we'll use to identify our cluster resources",
            kubernetes-cluster-tag
              | String
              | doc "KubernetesClusterTag is the legacy cluster id we'll use to identify our cluster resources",
            role-arn
              | String
              | doc "RoleARN is the IAM role to assume when interaction with AWS APIs.",
            routetable-id
              | String
              | doc "RouteTableID enables using a specific RouteTable",
            subnet-id
              | String
              | doc "SubnetID enables using a specific subnet to use for ELB's",
            vpc
              | String
              | doc m%"
                The AWS VPC flag enables the possibility to run the master components
                on a different aws account, on a different cloud provider or on-premises.
                If the flag is set also the KubernetesClusterTag must be provided
              "%,
            zone
              | String
              | doc m%"
                TODO: Is there any use for this?  We can get it from the instance metadata service
                Maybe if we're not running on AWS, e.g. bootstrap; for now it is not very useful
              "%,
          },
      "_js2n__-:definitions/GlobalOpenstackOpts!contract" =
        {
            auth-url | String,
            ca-file | String,
            domain-id | String,
            domain-name | String,
            password | String,
            region | String,
            tenant-id | String,
            tenant-name | String,
            trust-id | String,
            user-id | String,
            username | String,
          },
      "_js2n__-:definitions/GlobalVsphereOpts!contract" =
        {
            datacenter | String | optional,
            datacenters | String | optional,
            datastore | String | optional,
            insecure-flag | Bool | optional,
            password | String | optional,
            port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            server | String | optional,
            soap-roundtrip-count | std.number.Integer | optional,
            user | String | optional,
            vm-name | String | optional,
            vm-uuid | String | optional,
            working-dir | String | optional,
          },
      "_js2n__-:definitions/GlusterfsVolumeSource!contract" =
        { endpoints | String, path | String, readOnly | Bool | optional, },
      "_js2n__-:definitions/GroupResources!contract" =
        {
            group | String | optional,
            resourceNames | Array (String) | optional,
            resources | Array (String) | optional,
          },
      "_js2n__-:definitions/HostPathVolumeSource!contract" =
        { path | String, type | String | optional, },
      "_js2n__-:definitions/ISCSIVolumeSource!contract" =
        {
            chapAuthDiscovery | Bool | optional,
            chapAuthSession | Bool | optional,
            fsType | String | optional,
            initiatorName | String | optional,
            iqn | String,
            iscsiInterface | String | optional,
            lun | std.number.Integer,
            portals | Array (String) | optional,
            readOnly | Bool | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
            targetPortal | String,
          },
      "_js2n__-:definitions/IdentityConfiguration!contract" = {},
      "_js2n__-:definitions/IngressConfig!contract" =
        {
            defaultBackend
              | Bool
              | doc "Enable or disable nginx default-http-backend"
              | optional,
            defaultHttpBackendPriorityClassName
              | String
              | doc "Priority class name for Nginx-Ingress's \"default-http-backend\" deployment"
              | optional,
            dnsPolicy | String | doc "DNS Policy" | optional,
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "Ingress controller extra arguments"
              | optional,
            extraEnvs
              | Array _js2n__-refsenv."_js2n__-:definitions/ExtraEnv!contract"
              | doc "Extra Env vars"
              | optional,
            extraVolumeMounts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ExtraVolumeMount!contract"
              | doc "Extra volume mounts"
              | optional,
            extraVolumes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ExtraVolume!contract"
              | doc "Extra volumes"
              | optional,
            httpPort
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "Http port for ingress controller daemonset"
              | optional,
            httpsPort
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "Https port for ingress controller daemonset"
              | optional,
            networkMode
              | String
              | doc "NetworkMode selector for ingress controller pods. Default is HostNetwork"
              | optional,
            nginxIngressControllerPriorityClassName
              | String
              | doc "Priority class name for Nginx-Ingress's \"nginx-ingress-controller\" daemonset"
              | optional,
            nodeSelector
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "NodeSelector key pair"
              | optional,
            options
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc m%"
                These options are NOT for configuring Ingress's addon template.
                They are used for its ConfigMap options specifically.
              "%
              | optional,
            provider
              | String
              | doc "Ingress controller type used by kubernetes"
              | optional,
            tolerations
              | Array _js2n__-refsenv."_js2n__-:definitions/Toleration!contract"
              | doc "Tolerations for Deployments"
              | optional,
            updateStrategy
              | _js2n__-refsenv."_js2n__-:definitions/DaemonSetUpdateStrategy!contract"
              | doc "nginx daemonset upgrade strategy"
              | optional,
          },
      "_js2n__-:definitions/IntOrString!contract" =
        {
            IntVal | std.number.Integer,
            StrVal | String,
            Type | std.number.Integer,
          },
      "_js2n__-:definitions/KMSConfiguration!contract" =
        {
            cachesize | std.number.Integer | optional,
            endpoint | String,
            name | String,
            timeout
              | _js2n__-refsenv."_js2n__-:definitions/Duration!contract"
              | optional,
          },
      "_js2n__-:definitions/Key!contract" = { name | String, secret | String, },
      "_js2n__-:definitions/KeyToPath!contract" =
        { key | String, mode | std.number.Integer | optional, path | String, },
      "_js2n__-:definitions/KubeAPIService!contract" =
        {
            admissionConfiguration
              | _js2n__-refsenv."_js2n__-:definitions/AdmissionConfiguration!contract"
              | doc "AdmissionConfiguration"
              | optional,
            alwaysPullImages
              | Bool
              | doc "Enable/Disable AlwaysPullImages admissions plugin"
              | optional,
            auditLog
              | _js2n__-refsenv."_js2n__-:definitions/AuditLog!contract"
              | doc "Audit Log Configuration"
              | optional,
            eventRateLimit
              | _js2n__-refsenv."_js2n__-:definitions/EventRateLimit!contract"
              | doc "Event Rate Limit configuration"
              | optional,
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            extraBinds | Array (String) | optional,
            extraEnv | Array (String) | optional,
            image | String | optional,
            podSecurityPolicy
              | Bool
              | doc "Enabled/Disable PodSecurityPolicy"
              | optional,
            secretsEncryptionConfig
              | _js2n__-refsenv."_js2n__-:definitions/SecretsEncryptionConfig!contract"
              | doc "Secrets encryption provider config"
              | optional,
            serviceClusterIpRange
              | String
              | doc "Virtual IP range that will be used by Kubernetes services"
              | optional,
            serviceNodePortRange
              | String
              | doc "Port range for services defined with NodePort type"
              | optional,
            winExtraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            winExtraBinds | Array (String) | optional,
            winExtraEnv | Array (String) | optional,
          },
      "_js2n__-:definitions/KubeControllerService!contract" =
        {
            clusterCidr
              | String
              | doc "CIDR Range for Pods in cluster"
              | optional,
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            extraBinds | Array (String) | optional,
            extraEnv | Array (String) | optional,
            image | String | optional,
            serviceClusterIpRange
              | String
              | doc "Virtual IP range that will be used by Kubernetes services"
              | optional,
            winExtraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            winExtraBinds | Array (String) | optional,
            winExtraEnv | Array (String) | optional,
          },
      "_js2n__-:definitions/KubeletService!contract" =
        {
            clusterDnsServer | String | doc "Cluster DNS service ip" | optional,
            clusterDomain
              | String
              | doc "Domain of the cluster (default: \"cluster.local\")"
              | optional,
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            extraBinds | Array (String) | optional,
            extraEnv | Array (String) | optional,
            failSwapOn | Bool | doc "Fail if swap is enabled" | optional,
            generateServingCertificate
              | Bool
              | doc "Generate per node kubelet serving certificates created using kube-ca"
              | optional,
            image | String | optional,
            infraContainerImage
              | String
              | doc "The image whose network/ipc namespaces containers in each pod will use"
              | optional,
            winExtraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            winExtraBinds | Array (String) | optional,
            winExtraEnv | Array (String) | optional,
          },
      "_js2n__-:definitions/KubeproxyService!contract" =
        {
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            extraBinds | Array (String) | optional,
            extraEnv | Array (String) | optional,
            image | String | optional,
            winExtraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            winExtraBinds | Array (String) | optional,
            winExtraEnv | Array (String) | optional,
          },
      "_js2n__-:definitions/LabelSelector!contract" =
        {
            matchExpressions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/LabelSelectorRequirement!contract"
              | optional,
            matchLabels
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
          },
      "_js2n__-:definitions/LabelSelectorRequirement!contract" =
        {
            key | String,
            operator | String,
            values | Array (String) | optional,
          },
      "_js2n__-:definitions/Limit!contract" =
        {
            burst | std.number.Integer,
            cacheSize | std.number.Integer | optional,
            qps | std.number.Integer,
            type | String,
          },
      "_js2n__-:definitions/LinearAutoscalerParams!contract" =
        {
            coresPerReplica | Number | optional,
            max | std.number.Integer | optional,
            min | std.number.Integer | optional,
            nodesPerReplica | Number | optional,
            preventSinglePointFailure | Bool | optional,
          },
      "_js2n__-:definitions/LoadBalancerOpenstackOpts!contract" =
        {
            create-monitor | Bool,
            floating-network-id
              | String
              | doc "If specified, will create floating ip for loadbalancer, or do not create floating ip.",
            lb-method | String | doc "default to ROUND_ROBIN.",
            lb-provider | String,
            lb-version
              | String
              | doc "overrides autodetection. Only support v2.",
            manage-security-groups | Bool,
            monitor-delay | String,
            monitor-max-retries | std.number.Integer,
            monitor-timeout | String,
            subnet-id | String | doc "overrides autodetection.",
            use-octavia | Bool | doc "uses Octavia V2 service catalog endpoint",
          },
      "_js2n__-:definitions/LocalObjectReference!contract" =
        { name | String | optional, },
      "_js2n__-:definitions/ManagedFieldsEntry!contract" =
        {
            apiVersion | String | optional,
            fieldsType | String | optional,
            fieldsV1
              | _js2n__-refsenv."_js2n__-:definitions/FieldsV1!contract"
              | optional,
            manager | String | optional,
            operation | String | optional,
            time | String | optional,
          },
      "_js2n__-:definitions/MetadataOpenstackOpts!contract" =
        { request-timeout | std.number.Integer, search-order | String, },
      "_js2n__-:definitions/MonitoringConfig!contract" =
        {
            metricsServerPriorityClassName
              | String
              | doc "Priority class name for Metrics-Server's \"metrics-server\" deployment"
              | optional,
            nodeSelector
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "NodeSelector key pair"
              | optional,
            options
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc m%"
                These options are NOT for configuring the Metrics-Server's addon template.
                They are used to pass command args to the metric-server's deployment containers specifically.
              "%
              | optional,
            provider | String | doc "Monitoring server provider" | optional,
            replicas
              | std.number.Integer
              | doc "Number of monitoring addon pods"
              | optional,
            tolerations
              | Array _js2n__-refsenv."_js2n__-:definitions/Toleration!contract"
              | doc "Tolerations for Deployments"
              | optional,
            updateStrategy
              | _js2n__-refsenv."_js2n__-:definitions/DeploymentStrategy!contract"
              | doc "Update strategy"
              | optional,
          },
      "_js2n__-:definitions/NFSVolumeSource!contract" =
        { path | String, readOnly | Bool | optional, server | String, },
      "_js2n__-:definitions/NetworkConfig!contract" =
        {
            aciNetworkProvider
              | _js2n__-refsenv."_js2n__-:definitions/AciNetworkProvider!contract"
              | doc "AciNetworkProvider"
              | optional,
            calicoNetworkProvider
              | _js2n__-refsenv."_js2n__-:definitions/CalicoNetworkProvider!contract"
              | doc "CalicoNetworkProvider"
              | optional,
            canalNetworkProvider
              | _js2n__-refsenv."_js2n__-:definitions/CanalNetworkProvider!contract"
              | doc "CanalNetworkProvider"
              | optional,
            flannelNetworkProvider
              | _js2n__-refsenv."_js2n__-:definitions/FlannelNetworkProvider!contract"
              | doc "FlannelNetworkProvider"
              | optional,
            mtu
              | std.number.Integer
              | doc "Set MTU for CNI provider"
              | optional,
            nodeSelector
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "NodeSelector key pair"
              | optional,
            options
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "Plugin options to configure network properties"
              | optional,
            plugin
              | String
              | doc "Network Plugin That will be used in kubernetes cluster"
              | optional,
            tolerations
              | Array _js2n__-refsenv."_js2n__-:definitions/Toleration!contract"
              | doc "Tolerations for Deployments"
              | optional,
            updateStrategy
              | _js2n__-refsenv."_js2n__-:definitions/DaemonSetUpdateStrategy!contract"
              | doc "Network plugin daemonset upgrade strategy"
              | optional,
            weaveNetworkProvider
              | _js2n__-refsenv."_js2n__-:definitions/WeaveNetworkProvider!contract"
              | doc "WeaveNetworkProvider"
              | optional,
          },
      "_js2n__-:definitions/NetworkVshpereOpts!contract" =
        { public-network | String | optional, },
      "_js2n__-:definitions/NodeDrainInput!contract" =
        {
            deleteLocalData
              | Bool
              | doc "Continue even if there are pods using emptyDir"
              | optional,
            "force"
              | Bool
              | doc m%"
                Drain node even if there are pods not managed by a ReplicationController, Job, or DaemonSet
                Drain will not proceed without Force set to true if there are such pods
              "%
              | optional,
            gracePeriod
              | std.number.Integer
              | doc m%"
                Period of time in seconds given to each pod to terminate gracefully.
                If negative, the default value specified in the pod will be used
              "%
              | optional,
            ignoreDaemonSets
              | Bool
              | doc m%"
                If there are DaemonSet-managed pods, drain will not proceed without IgnoreDaemonSets set to true
                (even when set to true, kubectl won't delete pods - so setting default to true)
              "%
              | optional,
            timeout
              | std.number.Integer
              | doc "Time to wait (in seconds) before giving up for one try",
          },
      "_js2n__-:definitions/NodeUpgradeStrategy!contract" =
        {
            drain | Bool | optional,
            maxUnavailableControlplane
              | String
              | doc "MaxUnavailableControlplane input can be a number of nodes or a percentage of nodes"
              | optional,
            maxUnavailableWorker
              | String
              | doc "MaxUnavailableWorker input can be a number of nodes or a percentage of nodes (example, max_unavailable_worker: 2 OR max_unavailable_worker: 20%)"
              | optional,
            nodeDrainInput
              | _js2n__-refsenv."_js2n__-:definitions/NodeDrainInput!contract"
              | optional,
          },
      "_js2n__-:definitions/Nodelocal!contract" =
        {
            ipAddress
              | String
              | doc "link-local IP for nodelocal DNS"
              | optional,
            nodeLocalDnsPriorityClassName
              | String
              | doc "Priority class name for NodeLocal's \"node-local-dns\" daemonset"
              | optional,
            nodeSelector
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "NodeSelector key pair"
              | optional,
            updateStrategy
              | _js2n__-refsenv."_js2n__-:definitions/DaemonSetUpdateStrategy!contract"
              | doc "Nodelocal DNS daemonset upgrade strategy"
              | optional,
          },
      "_js2n__-:definitions/ObjectFieldSelector!contract" =
        { apiVersion | String | optional, fieldPath | String, },
      "_js2n__-:definitions/ObjectMeta!contract" =
        {
            annotations
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            clusterName | String | optional,
            creationTimestamp
              | _js2n__-refsenv."_js2n__-:definitions/Time!contract"
              | optional,
            deletionGracePeriodSeconds | std.number.Integer | optional,
            deletionTimestamp | String | optional,
            finalizers | Array (String) | optional,
            generateName | String | optional,
            generation | std.number.Integer | optional,
            labels
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            managedFields
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ManagedFieldsEntry!contract"
              | optional,
            name | String | optional,
            namespace | String | optional,
            ownerReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/OwnerReference!contract"
              | optional,
            resourceVersion | String | optional,
            selfLink | String | optional,
            uid | String | optional,
          },
      "_js2n__-:definitions/OpenstackCloudProvider!contract" =
        {
            blockStorage
              | _js2n__-refsenv."_js2n__-:definitions/BlockStorageOpenstackOpts!contract",
            global
              | _js2n__-refsenv."_js2n__-:definitions/GlobalOpenstackOpts!contract",
            loadBalancer
              | _js2n__-refsenv."_js2n__-:definitions/LoadBalancerOpenstackOpts!contract",
            metadata
              | _js2n__-refsenv."_js2n__-:definitions/MetadataOpenstackOpts!contract",
            route
              | _js2n__-refsenv."_js2n__-:definitions/RouteOpenstackOpts!contract",
          },
      "_js2n__-:definitions/OwnerReference!contract" =
        {
            apiVersion | String,
            blockOwnerDeletion | Bool | optional,
            controller | Bool | optional,
            kind | String,
            name | String,
            uid | String,
          },
      "_js2n__-:definitions/PersistentVolumeClaimSpec!contract" =
        {
            accessModes | Array (String) | optional,
            dataSource
              | _js2n__-refsenv."_js2n__-:definitions/TypedLocalObjectReference!contract"
              | optional,
            resources
              | _js2n__-refsenv."_js2n__-:definitions/ResourceRequirements!contract"
              | optional,
            selector
              | _js2n__-refsenv."_js2n__-:definitions/LabelSelector!contract"
              | optional,
            storageClassName | String | optional,
            volumeMode | String | optional,
            volumeName | String | optional,
          },
      "_js2n__-:definitions/PersistentVolumeClaimTemplate!contract" =
        {
            metadata
              | _js2n__-refsenv."_js2n__-:definitions/ObjectMeta!contract"
              | optional,
            spec
              | _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimSpec!contract",
          },
      "_js2n__-:definitions/PersistentVolumeClaimVolumeSource!contract" =
        { claimName | String, readOnly | Bool | optional, },
      "_js2n__-:definitions/PhotonPersistentDiskVolumeSource!contract" =
        { fsType | String | optional, pdID | String, },
      "_js2n__-:definitions/Policy!contract" =
        {
            TypeMeta | _js2n__-refsenv."_js2n__-:definitions/TypeMeta!contract",
            metadata
              | _js2n__-refsenv."_js2n__-:definitions/ObjectMeta!contract"
              | optional,
            omitStages | Array (String) | optional,
            rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PolicyRule!contract",
          },
      "_js2n__-:definitions/PolicyRule!contract" =
        {
            level | String,
            namespaces | Array (String) | optional,
            nonResourceURLs | Array (String) | optional,
            omitStages | Array (String) | optional,
            resources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/GroupResources!contract"
              | optional,
            userGroups | Array (String) | optional,
            users | Array (String) | optional,
            verbs | Array (String) | optional,
          },
      "_js2n__-:definitions/PortworxVolumeSource!contract" =
        {
            fsType | String | optional,
            readOnly | Bool | optional,
            volumeID | String,
          },
      "_js2n__-:definitions/PrivateRegistry!contract" =
        {
            ecrCredentialPlugin
              | _js2n__-refsenv."_js2n__-:definitions/ECRCredentialPlugin!contract"
              | doc "ECRCredentialPlugin"
              | optional,
            isDefault | Bool | doc "Default registry" | optional,
            password | String | doc "Password for registry access" | optional,
            url | String | doc "URL for the registry" | optional,
            user | String | doc "User name for registry acces" | optional,
          },
      "_js2n__-:definitions/ProjectedVolumeSource!contract" =
        {
            defaultMode | std.number.Integer | optional,
            sources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/VolumeProjection!contract",
          },
      "_js2n__-:definitions/ProviderConfiguration!contract" =
        {
            aescbc
              | _js2n__-refsenv."_js2n__-:definitions/AESConfiguration!contract"
              | optional,
            aesgcm
              | _js2n__-refsenv."_js2n__-:definitions/AESConfiguration!contract"
              | optional,
            identity
              | _js2n__-refsenv."_js2n__-:definitions/IdentityConfiguration!contract"
              | optional,
            kms
              | _js2n__-refsenv."_js2n__-:definitions/KMSConfiguration!contract"
              | optional,
            secretbox
              | _js2n__-refsenv."_js2n__-:definitions/SecretboxConfiguration!contract"
              | optional,
          },
      "_js2n__-:definitions/Quantity!contract" = {},
      "_js2n__-:definitions/Quantity!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/QuobyteVolumeSource!contract" =
        {
            group | String | optional,
            readOnly | Bool | optional,
            registry | String,
            tenant | String | optional,
            user | String | optional,
            volume | String,
          },
      "_js2n__-:definitions/RBDVolumeSource!contract" =
        {
            fsType | String | optional,
            image | String,
            keyring | String | optional,
            monitors | Array (String),
            pool | String | optional,
            readOnly | Bool | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
            user | String | optional,
          },
      "_js2n__-:definitions/RKEConfigNode!contract" =
        {
            address
              | String
              | doc "IP or FQDN that is fully resolvable and used for SSH communication"
              | optional,
            dockerSocket
              | String
              | doc "Optional - Docker socket on the node that will be used in tunneling"
              | optional,
            hostnameOverride
              | String
              | doc "Optional - Hostname of the node"
              | optional,
            internalAddress
              | String
              | doc "Optional - Internal address that will be used for components communication"
              | optional,
            labels
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | doc "Node Labels"
              | optional,
            nodeName
              | String
              | doc "Name of the host provisioned via docker machine"
              | optional,
            port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "Port used for SSH communication"
              | optional,
            role
              | Array (String)
              | doc "Node role in kubernetes cluster (controlplane, worker, or etcd)"
              | optional,
            sshAgentAuth | Bool | doc "SSH Agent Auth enable" | optional,
            sshCert | String | doc "SSH Certificate" | optional,
            sshCertPath | String | doc "SSH Certificate Path" | optional,
            sshKey | String | doc "SSH Private Key" | optional,
            sshKeyPath | String | doc "SSH Private Key Path" | optional,
            taints
              | Array _js2n__-refsenv."_js2n__-:definitions/RKETaint!contract"
              | doc "Node Taints"
              | optional,
            user | String | doc "SSH usesr that will be used by RKE" | optional,
          },
      "_js2n__-:definitions/RKEConfigServices!contract" =
        {
            etcd
              | _js2n__-refsenv."_js2n__-:definitions/ETCDService!contract"
              | doc "Etcd Service"
              | optional,
            kubeApi
              | _js2n__-refsenv."_js2n__-:definitions/KubeAPIService!contract"
              | doc "KubeAPI Service"
              | optional,
            kubeController
              | _js2n__-refsenv."_js2n__-:definitions/KubeControllerService!contract"
              | doc "KubeController Service"
              | optional,
            kubelet
              | _js2n__-refsenv."_js2n__-:definitions/KubeletService!contract"
              | doc "Kubelet Service"
              | optional,
            kubeproxy
              | _js2n__-refsenv."_js2n__-:definitions/KubeproxyService!contract"
              | doc "KubeProxy Service"
              | optional,
            scheduler
              | _js2n__-refsenv."_js2n__-:definitions/SchedulerService!contract"
              | doc "Scheduler Service"
              | optional,
          },
      "_js2n__-:definitions/RKESystemImages!contract" =
        {
            aciCniDeployContainer
              | String
              | doc "Cni deployer container image for Cisco ACI"
              | optional,
            aciControllerContainer
              | String
              | doc "Controller container image for Cisco ACI"
              | optional,
            aciGbpServerContainer
              | String
              | doc "GBP Server container image for Cisco ACI"
              | optional,
            aciHostContainer
              | String
              | doc "host container image for Cisco ACI"
              | optional,
            aciMcastContainer
              | String
              | doc "mcast daemon container image for Cisco ACI"
              | optional,
            aciOpflexContainer
              | String
              | doc "opflex agent container image for Cisco ACI"
              | optional,
            aciOpflexServerContainer
              | String
              | doc "Opflex Server container image for Cisco ACI"
              | optional,
            aciOvsContainer
              | String
              | doc "OpenvSwitch container image for Cisco ACI"
              | optional,
            alpine | String | doc "Alpine image" | optional,
            calicoCni | String | doc "Calico CNI image" | optional,
            calicoControllers
              | String
              | doc "Calico Controllers image"
              | optional,
            calicoCtl | String | doc "Calicoctl image" | optional,
            calicoFlexVol | String | doc "CalicoFlexVol image" | optional,
            calicoNode | String | doc "Calico Node image" | optional,
            canalCni | String | doc "Canal CNI image" | optional,
            canalControllers
              | String
              | doc "Canal Controllers Image needed for Calico/Canal v3.14.0+"
              | optional,
            canalFlannel | String | doc "CanalFlannel image" | optional,
            canalFlexVol | String | doc "CanalFlexVol image" | optional,
            canalNode | String | doc "Canal Node Image" | optional,
            certDownloader | String | doc "rke-cert-deployer image" | optional,
            coredns | String | doc "CoreDNS image" | optional,
            corednsAutoscaler
              | String
              | doc "CoreDNS autoscaler image"
              | optional,
            dnsmasq | String | doc "DNSMasq image" | optional,
            etcd | String | doc "etcd image" | optional,
            flannel | String | doc "Flannel image" | optional,
            flannelCni | String | doc "Flannel CNI image" | optional,
            ingress | String | doc "Ingress Controller image" | optional,
            ingressBackend
              | String
              | doc "Ingress Controller Backend image"
              | optional,
            ingressWebhook | String | doc "Ingress Webhook image" | optional,
            kubedns | String | doc "KubeDNS image" | optional,
            kubednsAutoscaler
              | String
              | doc "KubeDNS autoscaler image"
              | optional,
            kubednsSidecar | String | doc "KubeDNS side car image" | optional,
            kubernetes | String | doc "Kubernetes image" | optional,
            kubernetesServicesSidecar
              | String
              | doc "rke-service-sidekick image"
              | optional,
            metricsServer | String | doc "Metrics Server image" | optional,
            nginxProxy | String | doc "rke-nginx-proxy image" | optional,
            nodelocal | String | doc "Nodelocal image" | optional,
            podInfraContainer
              | String
              | doc "Pod infra container image"
              | optional,
            weaveCni | String | doc "Weave CNI image" | optional,
            weaveNode | String | doc "Weave Node image" | optional,
            windowsPodInfraContainer
              | String
              | doc "Pod infra container image for Windows"
              | optional,
          },
      "_js2n__-:definitions/RKETaint!contract" =
        {
            effect | String | optional,
            key | String | optional,
            timeAdded | String | optional,
            value | String | optional,
          },
      "_js2n__-:definitions/RancherKubernetesEngineConfig!contract" =
        {
            addonJobTimeout
              | std.number.Integer
              | doc "Timeout in seconds for status check on addon deployment jobs"
              | optional,
            addons
              | String
              | doc "YAML manifest for user provided addons to be deployed on the cluster"
              | optional,
            addonsInclude
              | Array (String)
              | doc "List of urls or paths for addons"
              | optional,
            authentication
              | _js2n__-refsenv."_js2n__-:definitions/AuthnConfig!contract"
              | doc "Authentication configuration used in the cluster (default: x509)"
              | optional,
            authorization
              | _js2n__-refsenv."_js2n__-:definitions/AuthzConfig!contract"
              | doc "Authorization mode configuration used in the cluster"
              | optional,
            bastionHost
              | _js2n__-refsenv."_js2n__-:definitions/BastionHost!contract"
              | doc "Bastion/Jump Host configuration"
              | optional,
            cloudProvider
              | _js2n__-refsenv."_js2n__-:definitions/CloudProvider!contract"
              | doc "Cloud Provider options"
              | optional,
            clusterName
              | String
              | doc "Cluster Name used in the kube config"
              | optional,
            dns
              | _js2n__-refsenv."_js2n__-:definitions/DNSConfig!contract"
              | doc "DNS Config"
              | optional,
            enableCriDockerd
              | Bool
              | doc "Enable/disable using cri-dockerd"
              | optional,
            ignoreDockerVersion
              | Bool
              | doc "Enable/disable strict docker version checking"
              | optional,
            ingress
              | _js2n__-refsenv."_js2n__-:definitions/IngressConfig!contract"
              | doc "Ingress controller used in the cluster"
              | optional,
            kubernetesVersion
              | String
              | doc "Kubernetes version to use (if kubernetes image is specified, image version takes precedence)"
              | optional,
            monitoring
              | _js2n__-refsenv."_js2n__-:definitions/MonitoringConfig!contract"
              | doc "Monitoring Config"
              | optional,
            network
              | _js2n__-refsenv."_js2n__-:definitions/NetworkConfig!contract"
              | doc "Network configuration used in the kubernetes cluster (flannel, calico)"
              | optional,
            nodes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/RKEConfigNode!contract"
              | doc "Kubernetes nodes"
              | optional,
            prefixPath | String | doc "kubernetes directory path" | optional,
            privateRegistries
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PrivateRegistry!contract"
              | doc "List of private registries and their credentials"
              | optional,
            restore
              | _js2n__-refsenv."_js2n__-:definitions/RestoreConfig!contract"
              | doc "RestoreCluster flag"
              | optional,
            rotateCertificates
              | _js2n__-refsenv."_js2n__-:definitions/RotateCertificates!contract"
              | doc "Rotating Certificates Option"
              | optional,
            rotateEncryptionKey
              | Bool
              | doc "Rotate Encryption Key Option"
              | optional,
            services
              | _js2n__-refsenv."_js2n__-:definitions/RKEConfigServices!contract"
              | doc "Kubernetes components"
              | optional,
            sshAgentAuth | Bool | doc "SSH Agent Auth enable" | optional,
            sshCertPath | String | doc "SSH Certificate Path" | optional,
            sshKeyPath | String | doc "SSH Private Key Path" | optional,
            systemImages
              | _js2n__-refsenv."_js2n__-:definitions/RKESystemImages!contract"
              | doc "List of images used internally for proxy, cert download and kubedns"
              | optional,
            upgradeStrategy
              | _js2n__-refsenv."_js2n__-:definitions/NodeUpgradeStrategy!contract"
              | doc "Upgrade Strategy for the cluster"
              | optional,
            winPrefixPath
              | String
              | doc "kubernetes directory path for windows"
              | optional,
          },
      "_js2n__-:definitions/ResourceConfiguration!contract" =
        {
            providers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ProviderConfiguration!contract",
            resources | Array (String),
          },
      "_js2n__-:definitions/ResourceFieldSelector!contract" =
        {
            containerName | String | optional,
            divisor
              | _js2n__-refsenv."_js2n__-:definitions/Quantity!contract"
              | optional,
            resource | String,
          },
      "_js2n__-:definitions/ResourceRequirements!contract" =
        {
            limits
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-refsenv."_js2n__-:definitions/Quantity!predicate",
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            requests
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-refsenv."_js2n__-:definitions/Quantity!predicate",
                      } true _js2n__-prdslib.always
                  ])
              | optional,
          },
      "_js2n__-:definitions/RestoreConfig!contract" =
        { restore | Bool | optional, snapshotName | String | optional, },
      "_js2n__-:definitions/RollingUpdateDaemonSet!contract" =
        {
            maxSurge
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract"
              | optional,
            maxUnavailable
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract"
              | optional,
          },
      "_js2n__-:definitions/RollingUpdateDeployment!contract" =
        {
            maxSurge
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract"
              | optional,
            maxUnavailable
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract"
              | optional,
          },
      "_js2n__-:definitions/RotateCertificates!contract" =
        {
            caCertificates | Bool | doc "Rotate CA Certificates" | optional,
            services
              | Array (String)
              | doc "Services to rotate their certs"
              | optional,
          },
      "_js2n__-:definitions/RouteOpenstackOpts!contract" =
        { router-id | String | doc "required", },
      "_js2n__-:definitions/S3BackupConfig!contract" =
        {
            accessKey | String | optional,
            bucketName | String | optional,
            customCa | String | optional,
            endpoint | String,
            folder | String | optional,
            region | String | optional,
            secretKey | String | optional,
          },
      "_js2n__-:definitions/ScaleIOVolumeSource!contract" =
        {
            fsType | String | optional,
            gateway | String,
            protectionDomain | String | optional,
            readOnly | Bool | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            sslEnabled | Bool | optional,
            storageMode | String | optional,
            storagePool | String | optional,
            system | String,
            volumeName | String | optional,
          },
      "_js2n__-:definitions/SchedulerService!contract" =
        {
            extraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            extraBinds | Array (String) | optional,
            extraEnv | Array (String) | optional,
            image | String | optional,
            winExtraArgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            winExtraBinds | Array (String) | optional,
            winExtraEnv | Array (String) | optional,
          },
      "_js2n__-:definitions/SecretKeySelector!contract" =
        {
            LocalObjectReference
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            key | String,
            "optional" | Bool | optional,
          },
      "_js2n__-:definitions/SecretProjection!contract" =
        {
            LocalObjectReference
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract"
              | optional,
            "optional" | Bool | optional,
          },
      "_js2n__-:definitions/SecretVolumeSource!contract" =
        {
            defaultMode | std.number.Integer | optional,
            items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract"
              | optional,
            "optional" | Bool | optional,
            secretName | String | optional,
          },
      "_js2n__-:definitions/SecretboxConfiguration!contract" =
        { keys | Array _js2n__-refsenv."_js2n__-:definitions/Key!contract", },
      "_js2n__-:definitions/SecretsEncryptionConfig!contract" =
        {
            customConfig
              | _js2n__-refsenv."_js2n__-:definitions/EncryptionConfiguration!contract"
              | doc "Custom Encryption Provider configuration object"
              | optional,
            enabled
              | Bool
              | doc "Enable/disable secrets encryption provider config"
              | optional,
          },
      "_js2n__-:definitions/ServiceAccountTokenProjection!contract" =
        {
            audience | String | optional,
            expirationSeconds | std.number.Integer | optional,
            path | String,
          },
      "_js2n__-:definitions/ServiceOverride!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "region",
                  "service",
                  "signing-method",
                  "signing-name",
                  "signing-region",
                  "url"
                ],
              _js2n__-prdslib.records.record
                {
                  region = _js2n__-prdslib.isType '"String",
                  service = _js2n__-prdslib.isType '"String",
                  signing-method = _js2n__-prdslib.isType '"String",
                  signing-name = _js2n__-prdslib.isType '"String",
                  signing-region = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StorageOSVolumeSource!contract" =
        {
            fsType | String | optional,
            readOnly | Bool | optional,
            secretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract"
              | optional,
            volumeName | String | optional,
            volumeNamespace | String | optional,
          },
      "_js2n__-:definitions/Time!contract" = {},
      "_js2n__-:definitions/Toleration!contract" =
        {
            effect | String | optional,
            key | String | optional,
            operator | String | optional,
            tolerationSeconds | std.number.Integer | optional,
            value | String | optional,
          },
      "_js2n__-:definitions/TypeMeta!contract" =
        { apiVersion | String | optional, kind | String | optional, },
      "_js2n__-:definitions/TypedLocalObjectReference!contract" =
        { apiGroup | String, kind | String, name | String, },
      "_js2n__-:definitions/Unknown!contract" =
        {
            ContentEncoding | String,
            ContentType | String,
            Raw | String,
            TypeMeta | _js2n__-refsenv."_js2n__-:definitions/TypeMeta!contract",
          },
      "_js2n__-:definitions/VirtualCenterConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  datacenters = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  port =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  soap-roundtrip-count = _js2n__-prdslib.isType 'Integer,
                  user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VolumeProjection!contract" =
        {
            configMap
              | _js2n__-refsenv."_js2n__-:definitions/ConfigMapProjection!contract"
              | optional,
            downwardAPI
              | _js2n__-refsenv."_js2n__-:definitions/DownwardAPIProjection!contract"
              | optional,
            secret
              | _js2n__-refsenv."_js2n__-:definitions/SecretProjection!contract"
              | optional,
            serviceAccountToken
              | _js2n__-refsenv."_js2n__-:definitions/ServiceAccountTokenProjection!contract"
              | optional,
          },
      "_js2n__-:definitions/VolumeSource!contract" =
        {
            awsElasticBlockStore
              | _js2n__-refsenv."_js2n__-:definitions/AWSElasticBlockStoreVolumeSource!contract"
              | optional,
            azureDisk
              | _js2n__-refsenv."_js2n__-:definitions/AzureDiskVolumeSource!contract"
              | optional,
            azureFile
              | _js2n__-refsenv."_js2n__-:definitions/AzureFileVolumeSource!contract"
              | optional,
            cephfs
              | _js2n__-refsenv."_js2n__-:definitions/CephFSVolumeSource!contract"
              | optional,
            cinder
              | _js2n__-refsenv."_js2n__-:definitions/CinderVolumeSource!contract"
              | optional,
            configMap
              | _js2n__-refsenv."_js2n__-:definitions/ConfigMapVolumeSource!contract"
              | optional,
            csi
              | _js2n__-refsenv."_js2n__-:definitions/CSIVolumeSource!contract"
              | optional,
            downwardAPI
              | _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeSource!contract"
              | optional,
            emptyDir
              | _js2n__-refsenv."_js2n__-:definitions/EmptyDirVolumeSource!contract"
              | optional,
            ephemeral
              | _js2n__-refsenv."_js2n__-:definitions/EphemeralVolumeSource!contract"
              | optional,
            fc
              | _js2n__-refsenv."_js2n__-:definitions/FCVolumeSource!contract"
              | optional,
            flexVolume
              | _js2n__-refsenv."_js2n__-:definitions/FlexVolumeSource!contract"
              | optional,
            flocker
              | _js2n__-refsenv."_js2n__-:definitions/FlockerVolumeSource!contract"
              | optional,
            gcePersistentDisk
              | _js2n__-refsenv."_js2n__-:definitions/GCEPersistentDiskVolumeSource!contract"
              | optional,
            gitRepo
              | _js2n__-refsenv."_js2n__-:definitions/GitRepoVolumeSource!contract"
              | optional,
            glusterfs
              | _js2n__-refsenv."_js2n__-:definitions/GlusterfsVolumeSource!contract"
              | optional,
            hostPath
              | _js2n__-refsenv."_js2n__-:definitions/HostPathVolumeSource!contract"
              | optional,
            iscsi
              | _js2n__-refsenv."_js2n__-:definitions/ISCSIVolumeSource!contract"
              | optional,
            nfs
              | _js2n__-refsenv."_js2n__-:definitions/NFSVolumeSource!contract"
              | optional,
            persistentVolumeClaim
              | _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimVolumeSource!contract"
              | optional,
            photonPersistentDisk
              | _js2n__-refsenv."_js2n__-:definitions/PhotonPersistentDiskVolumeSource!contract"
              | optional,
            portworxVolume
              | _js2n__-refsenv."_js2n__-:definitions/PortworxVolumeSource!contract"
              | optional,
            projected
              | _js2n__-refsenv."_js2n__-:definitions/ProjectedVolumeSource!contract"
              | optional,
            quobyte
              | _js2n__-refsenv."_js2n__-:definitions/QuobyteVolumeSource!contract"
              | optional,
            rbd
              | _js2n__-refsenv."_js2n__-:definitions/RBDVolumeSource!contract"
              | optional,
            scaleIO
              | _js2n__-refsenv."_js2n__-:definitions/ScaleIOVolumeSource!contract"
              | optional,
            secret
              | _js2n__-refsenv."_js2n__-:definitions/SecretVolumeSource!contract"
              | optional,
            storageos
              | _js2n__-refsenv."_js2n__-:definitions/StorageOSVolumeSource!contract"
              | optional,
            vsphereVolume
              | _js2n__-refsenv."_js2n__-:definitions/VsphereVirtualDiskVolumeSource!contract"
              | optional,
          },
      "_js2n__-:definitions/VsphereCloudProvider!contract" =
        {
            disk
              | _js2n__-refsenv."_js2n__-:definitions/DiskVsphereOpts!contract"
              | optional,
            global
              | _js2n__-refsenv."_js2n__-:definitions/GlobalVsphereOpts!contract"
              | optional,
            network
              | _js2n__-refsenv."_js2n__-:definitions/NetworkVshpereOpts!contract"
              | optional,
            virtualCenter
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-refsenv."_js2n__-:definitions/VirtualCenterConfig!predicate",
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            workspace
              | _js2n__-refsenv."_js2n__-:definitions/WorkspaceVsphereOpts!contract"
              | optional,
          },
      "_js2n__-:definitions/VsphereVirtualDiskVolumeSource!contract" =
        {
            fsType | String | optional,
            storagePolicyID | String | optional,
            storagePolicyName | String | optional,
            volumePath | String,
          },
      "_js2n__-:definitions/WeaveNetworkProvider!contract" =
        { password | String | optional, },
      "_js2n__-:definitions/WorkspaceVsphereOpts!contract" =
        {
            datacenter | String | optional,
            default-datastore | String | optional,
            folder | String | optional,
            resourcepool-path | String | optional,
            server | String | optional,
          },
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/RancherKubernetesEngineConfig!contract"