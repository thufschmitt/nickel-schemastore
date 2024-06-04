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
        { Keys | Array _js2n__-refsenv."_js2n__-:definitions/Key!contract", },
      "_js2n__-:definitions/AWSCloudProvider!contract" =
        {
            global
              | _js2n__-refsenv."_js2n__-:definitions/GlobalAwsOpts!contract",
            service_override
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
            FSType | String,
            Partition | std.number.Integer,
            ReadOnly | Bool,
            VolumeID | String,
          },
      "_js2n__-:definitions/AciNetworkProvider!contract" =
        {
            aep | String | optional,
            apic_hosts | Array (String) | optional,
            apic_refresh_time | String | optional,
            apic_user_crt | String | optional,
            apic_user_key | String | optional,
            apic_user_name | String | optional,
            capic | String | optional,
            controller_log_level | String | optional,
            drop_log_enable | String | optional,
            enable_endpoint_slice | String | optional,
            encap_type | String | optional,
            ep_registry | String | optional,
            extern_dynamic | String | optional,
            extern_static | String | optional,
            gbp_pod_subnet | String | optional,
            host_agent_log_level | String | optional,
            image_pull_policy | String | optional,
            image_pull_secret | String | optional,
            infra_vlan | String | optional,
            install_istio | String | optional,
            istio_profile | String | optional,
            kafka_brokers | Array (String) | optional,
            kafka_client_crt | String | optional,
            kafka_client_key | String | optional,
            kube_api_vlan | String | optional,
            l3out | String | optional,
            l3out_external_networks | Array (String) | optional,
            max_nodes_svc_graph | String | optional,
            mcast_range_end | String | optional,
            mcast_range_start | String | optional,
            no_priority_class | String | optional,
            node_subnet | String | optional,
            node_svc_subnet | String | optional,
            opflex_client_ssl | String | optional,
            opflex_log_level | String | optional,
            opflex_mode | String | optional,
            opflex_server_port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            overlay_vrf_name | String | optional,
            ovs_memory_limit | String | optional,
            pbr_tracking_non_snat | String | optional,
            pod_subnet_chunk_size | String | optional,
            run_gbp_container | String | optional,
            run_opflex_server_container | String | optional,
            service_monitor_interval | String | optional,
            service_vlan | String | optional,
            snat_contract_scope | String | optional,
            snat_namespace | String | optional,
            snat_port_range_end
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            snat_port_range_start
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            snat_ports_per_node
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | optional,
            subnet_domain_name | String | optional,
            system_id | String | optional,
            tenant | String | optional,
            token | String | optional,
            use_aci_anywhere_crd | String | optional,
            use_aci_cni_priority_class | String | optional,
            use_host_netns_volume | String | optional,
            use_opflex_server_volume | String | optional,
            use_privileged_container | String | optional,
            vmm_controller | String | optional,
            vmm_domain | String | optional,
            vrf_name | String | optional,
            vrf_tenant | String | optional,
          },
      "_js2n__-:definitions/AdmissionConfiguration!contract" =
        {
            APIVersion | String,
            Kind | String,
            Plugins
              | Array
                _js2n__-refsenv."_js2n__-:definitions/AdmissionPluginConfiguration!contract",
          },
      "_js2n__-:definitions/AdmissionPluginConfiguration!contract" =
        {
            Configuration
              | _js2n__-refsenv."_js2n__-:definitions/Unknown!contract",
            Name | String,
            Path | String,
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
            max_age | std.number.Integer | optional,
            max_backup | std.number.Integer | optional,
            max_size | std.number.Integer | optional,
            path | String | optional,
            policy
              | _js2n__-refsenv."_js2n__-:definitions/Policy!contract"
              | optional,
          },
      "_js2n__-:definitions/AuthWebhookConfig!contract" =
        {
            cache_timeout
              | String
              | doc "CacheTimeout controls how long to cache authentication decisions"
              | optional,
            config_file
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
            CachingMode | String,
            DataDiskURI | String,
            DiskName | String,
            FSType | String,
            Kind | String,
            ReadOnly | Bool,
          },
      "_js2n__-:definitions/AzureFileVolumeSource!contract" =
        { ReadOnly | Bool, SecretName | String, ShareName | String, },
      "_js2n__-:definitions/BackupConfig!contract" =
        {
            S3BackupConfig
              | _js2n__-refsenv."_js2n__-:definitions/S3BackupConfig!contract"
              | optional,
            enabled | Bool,
            interval_hours | std.number.Integer,
            retention | std.number.Integer,
            safe_timestamp | Bool,
            timeout | std.number.Integer,
          },
      "_js2n__-:definitions/BastionHost!contract" =
        {
            address | String | doc "Address of Bastion Host" | optional,
            ignore_proxy_env_vars
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
            ssh_agent_auth | Bool | doc "SSH Agent Auth enable" | optional,
            ssh_cert | String | doc "SSH Certificate" | optional,
            ssh_cert_path | String | doc "SSH Certificate Path" | optional,
            ssh_key | String | doc "SSH Private Key" | optional,
            ssh_key_path | String | doc "SSH Private Key Path" | optional,
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
            Driver | String,
            FSType | String,
            NodePublishSecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            ReadOnly | Bool,
            VolumeAttributes
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
                  ]),
          },
      "_js2n__-:definitions/CalicoNetworkProvider!contract" =
        {
            CloudProvider | String | doc "Cloud provider type used with calico",
          },
      "_js2n__-:definitions/CanalNetworkProvider!contract" =
        { Iface | String, },
      "_js2n__-:definitions/CephFSVolumeSource!contract" =
        {
            Monitors | Array (String),
            Path | String,
            ReadOnly | Bool,
            SecretFile | String,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            User | String,
          },
      "_js2n__-:definitions/CinderVolumeSource!contract" =
        {
            FSType | String,
            ReadOnly | Bool,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            VolumeID | String,
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
        { Key | String, Name | String, Optional | Bool, },
      "_js2n__-:definitions/ConfigMapProjection!contract" =
        {
            Items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract",
            Name | String,
            Optional | Bool,
          },
      "_js2n__-:definitions/ConfigMapVolumeSource!contract" =
        {
            DefaultMode | std.number.Integer,
            Items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract",
            Name | String,
            Optional | Bool,
          },
      "_js2n__-:definitions/Configuration!contract" =
        {
            APIVersion | String,
            Kind | String,
            Limits
              | Array _js2n__-refsenv."_js2n__-:definitions/Limit!contract",
          },
      "_js2n__-:definitions/DNSConfig!contract" =
        {
            linear_autoscaler_params
              | _js2n__-refsenv."_js2n__-:definitions/LinearAutoscalerParams!contract"
              | doc "Autoscaler fields to determine number of dns replicas"
              | optional,
            node_selector
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
            update_strategy
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
            RollingUpdate
              | _js2n__-refsenv."_js2n__-:definitions/RollingUpdateDaemonSet!contract",
            Strategy | String,
          },
      "_js2n__-:definitions/DeploymentStrategy!contract" =
        {
            RollingUpdate
              | _js2n__-refsenv."_js2n__-:definitions/RollingUpdateDeployment!contract",
            Strategy | String,
          },
      "_js2n__-:definitions/DiskVsphereOpts!contract" =
        { scsicontrollertype | String | optional, },
      "_js2n__-:definitions/DownwardAPIProjection!contract" =
        {
            Items
              | Array
                _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeFile!contract",
          },
      "_js2n__-:definitions/DownwardAPIVolumeFile!contract" =
        {
            FieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ObjectFieldSelector!contract",
            Mode | std.number.Integer,
            Path | String,
            ResourceFieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ResourceFieldSelector!contract",
          },
      "_js2n__-:definitions/DownwardAPIVolumeSource!contract" =
        {
            DefaultMode | std.number.Integer,
            Items
              | Array
                _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeFile!contract",
          },
      "_js2n__-:definitions/Duration!contract" = {},
      "_js2n__-:definitions/ECRCredentialPlugin!contract" =
        {
            aws_access_key_id | String,
            aws_secret_access_key | String,
            aws_session_token | String,
          },
      "_js2n__-:definitions/ETCDService!contract" =
        {
            backup_config
              | _js2n__-refsenv."_js2n__-:definitions/BackupConfig!contract"
              | doc "Backup backend for etcd snapshots"
              | optional,
            ca_cert | String | doc "External CA certificate" | optional,
            cert | String | doc "External Client certificate" | optional,
            creation | String | doc "Etcd snapshot Creation period" | optional,
            external_urls | Array (String) | doc "List of etcd urls" | optional,
            extra_args
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
            extra_binds | Array (String) | optional,
            extra_env | Array (String) | optional,
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
            win_extra_args
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
            win_extra_binds | Array (String) | optional,
            win_extra_env | Array (String) | optional,
          },
      "_js2n__-:definitions/EmptyDirVolumeSource!contract" =
        {
            Medium | String,
            SizeLimit
              | _js2n__-refsenv."_js2n__-:definitions/Quantity!contract",
          },
      "_js2n__-:definitions/EncryptionConfiguration!contract" =
        {
            APIVersion | String,
            Kind | String,
            Resources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ResourceConfiguration!contract",
          },
      "_js2n__-:definitions/EnvVarSource!contract" =
        {
            ConfigMapKeyRef
              | _js2n__-refsenv."_js2n__-:definitions/ConfigMapKeySelector!contract",
            FieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ObjectFieldSelector!contract",
            ResourceFieldRef
              | _js2n__-refsenv."_js2n__-:definitions/ResourceFieldSelector!contract",
            SecretKeyRef
              | _js2n__-refsenv."_js2n__-:definitions/SecretKeySelector!contract",
          },
      "_js2n__-:definitions/EphemeralVolumeSource!contract" =
        {
            VolumeClaimTemplate
              | _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimTemplate!contract",
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
            Name | String,
            Value | String,
            ValueFrom
              | _js2n__-refsenv."_js2n__-:definitions/EnvVarSource!contract",
          },
      "_js2n__-:definitions/ExtraVolume!contract" =
        {
            AWSElasticBlockStore
              | _js2n__-refsenv."_js2n__-:definitions/AWSElasticBlockStoreVolumeSource!contract",
            AzureDisk
              | _js2n__-refsenv."_js2n__-:definitions/AzureDiskVolumeSource!contract",
            AzureFile
              | _js2n__-refsenv."_js2n__-:definitions/AzureFileVolumeSource!contract",
            CSI
              | _js2n__-refsenv."_js2n__-:definitions/CSIVolumeSource!contract",
            CephFS
              | _js2n__-refsenv."_js2n__-:definitions/CephFSVolumeSource!contract",
            Cinder
              | _js2n__-refsenv."_js2n__-:definitions/CinderVolumeSource!contract",
            ConfigMap
              | _js2n__-refsenv."_js2n__-:definitions/ConfigMapVolumeSource!contract",
            DownwardAPI
              | _js2n__-refsenv."_js2n__-:definitions/DownwardAPIVolumeSource!contract",
            EmptyDir
              | _js2n__-refsenv."_js2n__-:definitions/EmptyDirVolumeSource!contract",
            Ephemeral
              | _js2n__-refsenv."_js2n__-:definitions/EphemeralVolumeSource!contract",
            FC | _js2n__-refsenv."_js2n__-:definitions/FCVolumeSource!contract",
            FlexVolume
              | _js2n__-refsenv."_js2n__-:definitions/FlexVolumeSource!contract",
            Flocker
              | _js2n__-refsenv."_js2n__-:definitions/FlockerVolumeSource!contract",
            GCEPersistentDisk
              | _js2n__-refsenv."_js2n__-:definitions/GCEPersistentDiskVolumeSource!contract",
            GitRepo
              | _js2n__-refsenv."_js2n__-:definitions/GitRepoVolumeSource!contract",
            Glusterfs
              | _js2n__-refsenv."_js2n__-:definitions/GlusterfsVolumeSource!contract",
            HostPath
              | _js2n__-refsenv."_js2n__-:definitions/HostPathVolumeSource!contract",
            ISCSI
              | _js2n__-refsenv."_js2n__-:definitions/ISCSIVolumeSource!contract",
            NFS
              | _js2n__-refsenv."_js2n__-:definitions/NFSVolumeSource!contract",
            Name | String,
            PersistentVolumeClaim
              | _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimVolumeSource!contract",
            PhotonPersistentDisk
              | _js2n__-refsenv."_js2n__-:definitions/PhotonPersistentDiskVolumeSource!contract",
            PortworxVolume
              | _js2n__-refsenv."_js2n__-:definitions/PortworxVolumeSource!contract",
            Projected
              | _js2n__-refsenv."_js2n__-:definitions/ProjectedVolumeSource!contract",
            Quobyte
              | _js2n__-refsenv."_js2n__-:definitions/QuobyteVolumeSource!contract",
            RBD
              | _js2n__-refsenv."_js2n__-:definitions/RBDVolumeSource!contract",
            ScaleIO
              | _js2n__-refsenv."_js2n__-:definitions/ScaleIOVolumeSource!contract",
            Secret
              | _js2n__-refsenv."_js2n__-:definitions/SecretVolumeSource!contract",
            StorageOS
              | _js2n__-refsenv."_js2n__-:definitions/StorageOSVolumeSource!contract",
            VsphereVolume
              | _js2n__-refsenv."_js2n__-:definitions/VsphereVirtualDiskVolumeSource!contract",
          },
      "_js2n__-:definitions/ExtraVolumeMount!contract" =
        {
            MountPath | String,
            MountPropagation | String,
            Name | String,
            ReadOnly | Bool,
            SubPath | String,
            SubPathExpr | String,
          },
      "_js2n__-:definitions/FCVolumeSource!contract" =
        {
            FSType | String,
            Lun | std.number.Integer,
            ReadOnly | Bool,
            TargetWWNs | Array (String),
            WWIDs | Array (String),
          },
      "_js2n__-:definitions/FieldsV1!contract" = { Raw | String, },
      "_js2n__-:definitions/FlannelNetworkProvider!contract" =
        { Iface | String | doc "Alternate cloud interface for flannel", },
      "_js2n__-:definitions/FlexVolumeSource!contract" =
        {
            Driver | String,
            FSType | String,
            Options
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
                  ]),
            ReadOnly | Bool,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
          },
      "_js2n__-:definitions/FlockerVolumeSource!contract" =
        { DatasetName | String, DatasetUUID | String, },
      "_js2n__-:definitions/GCEPersistentDiskVolumeSource!contract" =
        {
            FSType | String,
            PDName | String,
            Partition | std.number.Integer,
            ReadOnly | Bool,
          },
      "_js2n__-:definitions/GitRepoVolumeSource!contract" =
        { Directory | String, Repository | String, Revision | String, },
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
        { EndpointsName | String, Path | String, ReadOnly | Bool, },
      "_js2n__-:definitions/GroupResources!contract" =
        {
            Group | String,
            ResourceNames | Array (String),
            Resources | Array (String),
          },
      "_js2n__-:definitions/HostPathVolumeSource!contract" =
        { Path | String, Type | String, },
      "_js2n__-:definitions/ISCSIVolumeSource!contract" =
        {
            DiscoveryCHAPAuth | Bool,
            FSType | String,
            IQN | String,
            ISCSIInterface | String,
            InitiatorName | String,
            Lun | std.number.Integer,
            Portals | Array (String),
            ReadOnly | Bool,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            SessionCHAPAuth | Bool,
            TargetPortal | String,
          },
      "_js2n__-:definitions/IdentityConfiguration!contract" = {},
      "_js2n__-:definitions/IngressConfig!contract" =
        {
            default_backend
              | Bool
              | doc "Enable or disable nginx default-http-backend"
              | optional,
            default_http_backend_priority_class_name
              | String
              | doc "Priority class name for Nginx-Ingress's \"default-http-backend\" deployment"
              | optional,
            dns_policy | String | doc "DNS Policy" | optional,
            extra_args
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
            extra_envs
              | Array _js2n__-refsenv."_js2n__-:definitions/ExtraEnv!contract"
              | doc "Extra Env vars"
              | optional,
            extra_volume_mounts
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ExtraVolumeMount!contract"
              | doc "Extra volume mounts"
              | optional,
            extra_volumes
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ExtraVolume!contract"
              | doc "Extra volumes"
              | optional,
            http_port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "Http port for ingress controller daemonset"
              | optional,
            https_port
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number"
                  ])
              | doc "Https port for ingress controller daemonset"
              | optional,
            network_mode
              | String
              | doc "NetworkMode selector for ingress controller pods. Default is HostNetwork"
              | optional,
            nginx_ingress_controller_priority_class_name
              | String
              | doc "Priority class name for Nginx-Ingress's \"nginx-ingress-controller\" daemonset"
              | optional,
            node_selector
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
            update_strategy
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
            CacheSize | std.number.Integer,
            Endpoint | String,
            Name | String,
            Timeout | _js2n__-refsenv."_js2n__-:definitions/Duration!contract",
          },
      "_js2n__-:definitions/Key!contract" = { Name | String, Secret | String, },
      "_js2n__-:definitions/KeyToPath!contract" =
        { Key | String, Mode | std.number.Integer, Path | String, },
      "_js2n__-:definitions/KubeAPIService!contract" =
        {
            admission_configuration
              | _js2n__-refsenv."_js2n__-:definitions/AdmissionConfiguration!contract"
              | doc "AdmissionConfiguration"
              | optional,
            always_pull_images
              | Bool
              | doc "Enable/Disable AlwaysPullImages admissions plugin"
              | optional,
            audit_log
              | _js2n__-refsenv."_js2n__-:definitions/AuditLog!contract"
              | doc "Audit Log Configuration"
              | optional,
            event_rate_limit
              | _js2n__-refsenv."_js2n__-:definitions/EventRateLimit!contract"
              | doc "Event Rate Limit configuration"
              | optional,
            extra_args
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
            extra_binds | Array (String) | optional,
            extra_env | Array (String) | optional,
            image | String | optional,
            pod_security_policy
              | Bool
              | doc "Enabled/Disable PodSecurityPolicy"
              | optional,
            secrets_encryption_config
              | _js2n__-refsenv."_js2n__-:definitions/SecretsEncryptionConfig!contract"
              | doc "Secrets encryption provider config"
              | optional,
            service_cluster_ip_range
              | String
              | doc "Virtual IP range that will be used by Kubernetes services"
              | optional,
            service_node_port_range
              | String
              | doc "Port range for services defined with NodePort type"
              | optional,
            win_extra_args
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
            win_extra_binds | Array (String) | optional,
            win_extra_env | Array (String) | optional,
          },
      "_js2n__-:definitions/KubeControllerService!contract" =
        {
            cluster_cidr
              | String
              | doc "CIDR Range for Pods in cluster"
              | optional,
            extra_args
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
            extra_binds | Array (String) | optional,
            extra_env | Array (String) | optional,
            image | String | optional,
            service_cluster_ip_range
              | String
              | doc "Virtual IP range that will be used by Kubernetes services"
              | optional,
            win_extra_args
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
            win_extra_binds | Array (String) | optional,
            win_extra_env | Array (String) | optional,
          },
      "_js2n__-:definitions/KubeletService!contract" =
        {
            cluster_dns_server
              | String
              | doc "Cluster DNS service ip"
              | optional,
            cluster_domain
              | String
              | doc "Domain of the cluster (default: \"cluster.local\")"
              | optional,
            extra_args
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
            extra_binds | Array (String) | optional,
            extra_env | Array (String) | optional,
            fail_swap_on | Bool | doc "Fail if swap is enabled" | optional,
            generate_serving_certificate
              | Bool
              | doc "Generate per node kubelet serving certificates created using kube-ca"
              | optional,
            image | String | optional,
            infra_container_image
              | String
              | doc "The image whose network/ipc namespaces containers in each pod will use"
              | optional,
            win_extra_args
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
            win_extra_binds | Array (String) | optional,
            win_extra_env | Array (String) | optional,
          },
      "_js2n__-:definitions/KubeproxyService!contract" =
        {
            extra_args
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
            extra_binds | Array (String) | optional,
            extra_env | Array (String) | optional,
            image | String | optional,
            win_extra_args
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
            win_extra_binds | Array (String) | optional,
            win_extra_env | Array (String) | optional,
          },
      "_js2n__-:definitions/LabelSelector!contract" =
        {
            MatchExpressions
              | Array
                _js2n__-refsenv."_js2n__-:definitions/LabelSelectorRequirement!contract",
            MatchLabels
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
                  ]),
          },
      "_js2n__-:definitions/LabelSelectorRequirement!contract" =
        { Key | String, Operator | String, Values | Array (String), },
      "_js2n__-:definitions/Limit!contract" =
        {
            Burst | std.number.Integer,
            CacheSize | std.number.Integer,
            QPS | std.number.Integer,
            Type | String,
          },
      "_js2n__-:definitions/LinearAutoscalerParams!contract" =
        {
            cores_per_replica | Number | optional,
            max | std.number.Integer,
            min | std.number.Integer,
            nodes_per_replica | Number | optional,
            prevent_single_point_failure | Bool | optional,
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
      "_js2n__-:definitions/LocalObjectReference!contract" = { Name | String, },
      "_js2n__-:definitions/ManagedFieldsEntry!contract" =
        {
            APIVersion | String,
            FieldsType | String,
            FieldsV1 | _js2n__-refsenv."_js2n__-:definitions/FieldsV1!contract",
            Manager | String,
            Operation | String,
            Time | String,
          },
      "_js2n__-:definitions/MetadataOpenstackOpts!contract" =
        { request-timeout | std.number.Integer, search-order | String, },
      "_js2n__-:definitions/MonitoringConfig!contract" =
        {
            metrics_server_priority_class_name
              | String
              | doc "Priority class name for Metrics-Server's \"metrics-server\" deployment"
              | optional,
            node_selector
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
              | doc "Number of monitoring addon pods",
            tolerations
              | Array _js2n__-refsenv."_js2n__-:definitions/Toleration!contract"
              | doc "Tolerations for Deployments"
              | optional,
            update_strategy
              | _js2n__-refsenv."_js2n__-:definitions/DeploymentStrategy!contract"
              | doc "Update strategy"
              | optional,
          },
      "_js2n__-:definitions/NFSVolumeSource!contract" =
        { Path | String, ReadOnly | Bool, Server | String, },
      "_js2n__-:definitions/NetworkConfig!contract" =
        {
            aci_network_provider
              | _js2n__-refsenv."_js2n__-:definitions/AciNetworkProvider!contract"
              | doc "AciNetworkProvider"
              | optional,
            calico_network_provider
              | _js2n__-refsenv."_js2n__-:definitions/CalicoNetworkProvider!contract"
              | doc "CalicoNetworkProvider"
              | optional,
            canal_network_provider
              | _js2n__-refsenv."_js2n__-:definitions/CanalNetworkProvider!contract"
              | doc "CanalNetworkProvider"
              | optional,
            flannel_network_provider
              | _js2n__-refsenv."_js2n__-:definitions/FlannelNetworkProvider!contract"
              | doc "FlannelNetworkProvider"
              | optional,
            mtu
              | std.number.Integer
              | doc "Set MTU for CNI provider"
              | optional,
            node_selector
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
            update_strategy
              | _js2n__-refsenv."_js2n__-:definitions/DaemonSetUpdateStrategy!contract"
              | doc "Network plugin daemonset upgrade strategy"
              | optional,
            weave_network_provider
              | _js2n__-refsenv."_js2n__-:definitions/WeaveNetworkProvider!contract"
              | doc "WeaveNetworkProvider"
              | optional,
          },
      "_js2n__-:definitions/NetworkVshpereOpts!contract" =
        { public-network | String | optional, },
      "_js2n__-:definitions/NodeDrainInput!contract" =
        {
            delete_local_data
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
            grace_period
              | std.number.Integer
              | doc m%"
                Period of time in seconds given to each pod to terminate gracefully.
                If negative, the default value specified in the pod will be used
              "%
              | optional,
            ignore_daemonsets
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
            max_unavailable_controlplane
              | String
              | doc "MaxUnavailableControlplane input can be a number of nodes or a percentage of nodes"
              | optional,
            max_unavailable_worker
              | String
              | doc "MaxUnavailableWorker input can be a number of nodes or a percentage of nodes (example, max_unavailable_worker: 2 OR max_unavailable_worker: 20%)"
              | optional,
            node_drain_input
              | _js2n__-refsenv."_js2n__-:definitions/NodeDrainInput!contract"
              | optional,
          },
      "_js2n__-:definitions/Nodelocal!contract" =
        {
            ip_address
              | String
              | doc "link-local IP for nodelocal DNS"
              | optional,
            node_local_dns_priority_class_name
              | String
              | doc "Priority class name for NodeLocal's \"node-local-dns\" daemonset"
              | optional,
            node_selector
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
            update_strategy
              | _js2n__-refsenv."_js2n__-:definitions/DaemonSetUpdateStrategy!contract"
              | doc "Nodelocal DNS daemonset upgrade strategy"
              | optional,
          },
      "_js2n__-:definitions/ObjectFieldSelector!contract" =
        { APIVersion | String, FieldPath | String, },
      "_js2n__-:definitions/OpenstackCloudProvider!contract" =
        {
            block_storage
              | _js2n__-refsenv."_js2n__-:definitions/BlockStorageOpenstackOpts!contract",
            global
              | _js2n__-refsenv."_js2n__-:definitions/GlobalOpenstackOpts!contract",
            load_balancer
              | _js2n__-refsenv."_js2n__-:definitions/LoadBalancerOpenstackOpts!contract",
            metadata
              | _js2n__-refsenv."_js2n__-:definitions/MetadataOpenstackOpts!contract",
            route
              | _js2n__-refsenv."_js2n__-:definitions/RouteOpenstackOpts!contract",
          },
      "_js2n__-:definitions/OwnerReference!contract" =
        {
            APIVersion | String,
            BlockOwnerDeletion | Bool,
            Controller | Bool,
            Kind | String,
            Name | String,
            UID | String,
          },
      "_js2n__-:definitions/PersistentVolumeClaimSpec!contract" =
        {
            AccessModes | Array (String),
            DataSource
              | _js2n__-refsenv."_js2n__-:definitions/TypedLocalObjectReference!contract",
            Resources
              | _js2n__-refsenv."_js2n__-:definitions/ResourceRequirements!contract",
            Selector
              | _js2n__-refsenv."_js2n__-:definitions/LabelSelector!contract",
            StorageClassName | String,
            VolumeMode | String,
            VolumeName | String,
          },
      "_js2n__-:definitions/PersistentVolumeClaimTemplate!contract" =
        {
            Annotations
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
                  ]),
            ClusterName | String,
            CreationTimestamp
              | _js2n__-refsenv."_js2n__-:definitions/Time!contract",
            DeletionGracePeriodSeconds | std.number.Integer,
            DeletionTimestamp | String,
            Finalizers | Array (String),
            GenerateName | String,
            Generation | std.number.Integer,
            Labels
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
                  ]),
            ManagedFields
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ManagedFieldsEntry!contract",
            Name | String,
            Namespace | String,
            OwnerReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/OwnerReference!contract",
            ResourceVersion | String,
            SelfLink | String,
            Spec
              | _js2n__-refsenv."_js2n__-:definitions/PersistentVolumeClaimSpec!contract",
            UID | String,
          },
      "_js2n__-:definitions/PersistentVolumeClaimVolumeSource!contract" =
        { ClaimName | String, ReadOnly | Bool, },
      "_js2n__-:definitions/PhotonPersistentDiskVolumeSource!contract" =
        { FSType | String, PdID | String, },
      "_js2n__-:definitions/Policy!contract" =
        {
            APIVersion | String,
            Annotations
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
                  ]),
            ClusterName | String,
            CreationTimestamp
              | _js2n__-refsenv."_js2n__-:definitions/Time!contract",
            DeletionGracePeriodSeconds | std.number.Integer,
            DeletionTimestamp | String,
            Finalizers | Array (String),
            GenerateName | String,
            Generation | std.number.Integer,
            Kind | String,
            Labels
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
                  ]),
            ManagedFields
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ManagedFieldsEntry!contract",
            Name | String,
            Namespace | String,
            OmitStages | Array (String),
            OwnerReferences
              | Array
                _js2n__-refsenv."_js2n__-:definitions/OwnerReference!contract",
            ResourceVersion | String,
            Rules
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PolicyRule!contract",
            SelfLink | String,
            UID | String,
          },
      "_js2n__-:definitions/PolicyRule!contract" =
        {
            Level | String,
            Namespaces | Array (String),
            NonResourceURLs | Array (String),
            OmitStages | Array (String),
            Resources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/GroupResources!contract",
            UserGroups | Array (String),
            Users | Array (String),
            Verbs | Array (String),
          },
      "_js2n__-:definitions/PortworxVolumeSource!contract" =
        { FSType | String, ReadOnly | Bool, VolumeID | String, },
      "_js2n__-:definitions/PrivateRegistry!contract" =
        {
            ecr_credential_plugin
              | _js2n__-refsenv."_js2n__-:definitions/ECRCredentialPlugin!contract"
              | doc "ECRCredentialPlugin"
              | optional,
            is_default | Bool | doc "Default registry" | optional,
            password | String | doc "Password for registry access" | optional,
            url | String | doc "URL for the registry" | optional,
            user | String | doc "User name for registry acces" | optional,
          },
      "_js2n__-:definitions/ProjectedVolumeSource!contract" =
        {
            DefaultMode | std.number.Integer,
            Sources
              | Array
                _js2n__-refsenv."_js2n__-:definitions/VolumeProjection!contract",
          },
      "_js2n__-:definitions/ProviderConfiguration!contract" =
        {
            AESCBC
              | _js2n__-refsenv."_js2n__-:definitions/AESConfiguration!contract",
            AESGCM
              | _js2n__-refsenv."_js2n__-:definitions/AESConfiguration!contract",
            Identity
              | _js2n__-refsenv."_js2n__-:definitions/IdentityConfiguration!contract",
            KMS
              | _js2n__-refsenv."_js2n__-:definitions/KMSConfiguration!contract",
            Secretbox
              | _js2n__-refsenv."_js2n__-:definitions/SecretboxConfiguration!contract",
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
            Group | String,
            ReadOnly | Bool,
            Registry | String,
            Tenant | String,
            User | String,
            Volume | String,
          },
      "_js2n__-:definitions/RBDVolumeSource!contract" =
        {
            CephMonitors | Array (String),
            FSType | String,
            Keyring | String,
            RBDImage | String,
            RBDPool | String,
            RadosUser | String,
            ReadOnly | Bool,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
          },
      "_js2n__-:definitions/RKEConfigNode!contract" =
        {
            address
              | String
              | doc "IP or FQDN that is fully resolvable and used for SSH communication"
              | optional,
            docker_socket
              | String
              | doc "Optional - Docker socket on the node that will be used in tunneling"
              | optional,
            hostname_override
              | String
              | doc "Optional - Hostname of the node"
              | optional,
            internal_address
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
            ssh_agent_auth | Bool | doc "SSH Agent Auth enable" | optional,
            ssh_cert | String | doc "SSH Certificate" | optional,
            ssh_cert_path | String | doc "SSH Certificate Path" | optional,
            ssh_key | String | doc "SSH Private Key" | optional,
            ssh_key_path | String | doc "SSH Private Key Path" | optional,
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
            kube-api
              | _js2n__-refsenv."_js2n__-:definitions/KubeAPIService!contract"
              | doc "KubeAPI Service"
              | optional,
            kube-controller
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
            aci_cni_deploy_container
              | String
              | doc "Cni deployer container image for Cisco ACI"
              | optional,
            aci_controller_container
              | String
              | doc "Controller container image for Cisco ACI"
              | optional,
            aci_gbp_server_container
              | String
              | doc "GBP Server container image for Cisco ACI"
              | optional,
            aci_host_container
              | String
              | doc "host container image for Cisco ACI"
              | optional,
            aci_mcast_container
              | String
              | doc "mcast daemon container image for Cisco ACI"
              | optional,
            aci_opflex_container
              | String
              | doc "opflex agent container image for Cisco ACI"
              | optional,
            aci_opflex_server_container
              | String
              | doc "Opflex Server container image for Cisco ACI"
              | optional,
            aci_ovs_container
              | String
              | doc "OpenvSwitch container image for Cisco ACI"
              | optional,
            alpine | String | doc "Alpine image" | optional,
            calico_cni | String | doc "Calico CNI image" | optional,
            calico_controllers
              | String
              | doc "Calico Controllers image"
              | optional,
            calico_ctl | String | doc "Calicoctl image" | optional,
            calico_flexvol | String | doc "CalicoFlexVol image" | optional,
            calico_node | String | doc "Calico Node image" | optional,
            canal_cni | String | doc "Canal CNI image" | optional,
            canal_controllers
              | String
              | doc "Canal Controllers Image needed for Calico/Canal v3.14.0+"
              | optional,
            canal_flannel | String | doc "CanalFlannel image" | optional,
            canal_flexvol | String | doc "CanalFlexVol image" | optional,
            canal_node | String | doc "Canal Node Image" | optional,
            cert_downloader | String | doc "rke-cert-deployer image" | optional,
            coredns | String | doc "CoreDNS image" | optional,
            coredns_autoscaler
              | String
              | doc "CoreDNS autoscaler image"
              | optional,
            dnsmasq | String | doc "DNSMasq image" | optional,
            etcd | String | doc "etcd image" | optional,
            flannel | String | doc "Flannel image" | optional,
            flannel_cni | String | doc "Flannel CNI image" | optional,
            ingress | String | doc "Ingress Controller image" | optional,
            ingress_backend
              | String
              | doc "Ingress Controller Backend image"
              | optional,
            ingress_webhook | String | doc "Ingress Webhook image" | optional,
            kubedns | String | doc "KubeDNS image" | optional,
            kubedns_autoscaler
              | String
              | doc "KubeDNS autoscaler image"
              | optional,
            kubedns_sidecar | String | doc "KubeDNS side car image" | optional,
            kubernetes | String | doc "Kubernetes image" | optional,
            kubernetes_services_sidecar
              | String
              | doc "rke-service-sidekick image"
              | optional,
            metrics_server | String | doc "Metrics Server image" | optional,
            nginx_proxy | String | doc "rke-nginx-proxy image" | optional,
            nodelocal | String | doc "Nodelocal image" | optional,
            pod_infra_container
              | String
              | doc "Pod infra container image"
              | optional,
            weave_cni | String | doc "Weave CNI image" | optional,
            weave_node | String | doc "Weave Node image" | optional,
            windows_pod_infra_container
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
            addon_job_timeout
              | std.number.Integer
              | doc "Timeout in seconds for status check on addon deployment jobs"
              | optional,
            addons
              | String
              | doc "YAML manifest for user provided addons to be deployed on the cluster"
              | optional,
            addons_include
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
            bastion_host
              | _js2n__-refsenv."_js2n__-:definitions/BastionHost!contract"
              | doc "Bastion/Jump Host configuration"
              | optional,
            cloud_provider
              | _js2n__-refsenv."_js2n__-:definitions/CloudProvider!contract"
              | doc "Cloud Provider options"
              | optional,
            cluster_name
              | String
              | doc "Cluster Name used in the kube config"
              | optional,
            dns
              | _js2n__-refsenv."_js2n__-:definitions/DNSConfig!contract"
              | doc "DNS Config"
              | optional,
            enable_cri_dockerd
              | Bool
              | doc "Enable/disable using cri-dockerd"
              | optional,
            ignore_docker_version
              | Bool
              | doc "Enable/disable strict docker version checking"
              | optional,
            ingress
              | _js2n__-refsenv."_js2n__-:definitions/IngressConfig!contract"
              | doc "Ingress controller used in the cluster"
              | optional,
            kubernetes_version
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
            prefix_path | String | doc "kubernetes directory path" | optional,
            private_registries
              | Array
                _js2n__-refsenv."_js2n__-:definitions/PrivateRegistry!contract"
              | doc "List of private registries and their credentials"
              | optional,
            restore
              | _js2n__-refsenv."_js2n__-:definitions/RestoreConfig!contract"
              | doc "RestoreCluster flag"
              | optional,
            rotate_certificates
              | _js2n__-refsenv."_js2n__-:definitions/RotateCertificates!contract"
              | doc "Rotating Certificates Option"
              | optional,
            rotate_encryption_key
              | Bool
              | doc "Rotate Encryption Key Option"
              | optional,
            services
              | _js2n__-refsenv."_js2n__-:definitions/RKEConfigServices!contract"
              | doc "Kubernetes components"
              | optional,
            ssh_agent_auth | Bool | doc "SSH Agent Auth enable" | optional,
            ssh_cert_path | String | doc "SSH Certificate Path" | optional,
            ssh_key_path | String | doc "SSH Private Key Path" | optional,
            system_images
              | _js2n__-refsenv."_js2n__-:definitions/RKESystemImages!contract"
              | doc "List of images used internally for proxy, cert download and kubedns"
              | optional,
            upgrade_strategy
              | _js2n__-refsenv."_js2n__-:definitions/NodeUpgradeStrategy!contract"
              | doc "Upgrade Strategy for the cluster"
              | optional,
            win_prefix_path
              | String
              | doc "kubernetes directory path for windows"
              | optional,
          },
      "_js2n__-:definitions/ResourceConfiguration!contract" =
        {
            Providers
              | Array
                _js2n__-refsenv."_js2n__-:definitions/ProviderConfiguration!contract",
            Resources | Array (String),
          },
      "_js2n__-:definitions/ResourceFieldSelector!contract" =
        {
            ContainerName | String,
            Divisor | _js2n__-refsenv."_js2n__-:definitions/Quantity!contract",
            Resource | String,
          },
      "_js2n__-:definitions/ResourceRequirements!contract" =
        {
            Limits
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-refsenv."_js2n__-:definitions/Quantity!predicate",
                      } true _js2n__-prdslib.always
                  ]),
            Requests
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        ".*" =
                          _js2n__-refsenv."_js2n__-:definitions/Quantity!predicate",
                      } true _js2n__-prdslib.always
                  ]),
          },
      "_js2n__-:definitions/RestoreConfig!contract" =
        { restore | Bool | optional, snapshot_name | String | optional, },
      "_js2n__-:definitions/RollingUpdateDaemonSet!contract" =
        {
            MaxSurge
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract",
            MaxUnavailable
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract",
          },
      "_js2n__-:definitions/RollingUpdateDeployment!contract" =
        {
            MaxSurge
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract",
            MaxUnavailable
              | _js2n__-refsenv."_js2n__-:definitions/IntOrString!contract",
          },
      "_js2n__-:definitions/RotateCertificates!contract" =
        {
            CACertificates | Bool | doc "Rotate CA Certificates",
            Services | Array (String) | doc "Services to rotate their certs",
          },
      "_js2n__-:definitions/RouteOpenstackOpts!contract" =
        { router-id | String | doc "required", },
      "_js2n__-:definitions/S3BackupConfig!contract" =
        {
            access_key | String,
            bucket_name | String,
            custom_ca | String,
            endpoint | String,
            folder | String,
            region | String,
            secret_key | String,
          },
      "_js2n__-:definitions/ScaleIOVolumeSource!contract" =
        {
            FSType | String,
            Gateway | String,
            ProtectionDomain | String,
            ReadOnly | Bool,
            SSLEnabled | Bool,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            StorageMode | String,
            StoragePool | String,
            System | String,
            VolumeName | String,
          },
      "_js2n__-:definitions/SchedulerService!contract" =
        {
            extra_args
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
            extra_binds | Array (String) | optional,
            extra_env | Array (String) | optional,
            image | String | optional,
            win_extra_args
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
            win_extra_binds | Array (String) | optional,
            win_extra_env | Array (String) | optional,
          },
      "_js2n__-:definitions/SecretKeySelector!contract" =
        { Key | String, Name | String, Optional | Bool, },
      "_js2n__-:definitions/SecretProjection!contract" =
        {
            Items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract",
            Name | String,
            Optional | Bool,
          },
      "_js2n__-:definitions/SecretVolumeSource!contract" =
        {
            DefaultMode | std.number.Integer,
            Items
              | Array _js2n__-refsenv."_js2n__-:definitions/KeyToPath!contract",
            Optional | Bool,
            SecretName | String,
          },
      "_js2n__-:definitions/SecretboxConfiguration!contract" =
        { Keys | Array _js2n__-refsenv."_js2n__-:definitions/Key!contract", },
      "_js2n__-:definitions/SecretsEncryptionConfig!contract" =
        {
            custom_config
              | _js2n__-refsenv."_js2n__-:definitions/EncryptionConfiguration!contract"
              | doc "Custom Encryption Provider configuration object",
            enabled
              | Bool
              | doc "Enable/disable secrets encryption provider config"
              | optional,
          },
      "_js2n__-:definitions/ServiceAccountTokenProjection!contract" =
        {
            Audience | String,
            ExpirationSeconds | std.number.Integer,
            Path | String,
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
            FSType | String,
            ReadOnly | Bool,
            SecretRef
              | _js2n__-refsenv."_js2n__-:definitions/LocalObjectReference!contract",
            VolumeName | String,
            VolumeNamespace | String,
          },
      "_js2n__-:definitions/Time!contract" = {},
      "_js2n__-:definitions/Toleration!contract" =
        {
            Effect | String,
            Key | String,
            Operator | String,
            TolerationSeconds | std.number.Integer,
            Value | String,
          },
      "_js2n__-:definitions/TypedLocalObjectReference!contract" =
        { APIGroup | String, Kind | String, Name | String, },
      "_js2n__-:definitions/Unknown!contract" =
        {
            ContentEncoding | String,
            ContentType | String,
            Raw | String,
            apiVersion | String | optional,
            kind | String | optional,
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
            ConfigMap
              | _js2n__-refsenv."_js2n__-:definitions/ConfigMapProjection!contract",
            DownwardAPI
              | _js2n__-refsenv."_js2n__-:definitions/DownwardAPIProjection!contract",
            Secret
              | _js2n__-refsenv."_js2n__-:definitions/SecretProjection!contract",
            ServiceAccountToken
              | _js2n__-refsenv."_js2n__-:definitions/ServiceAccountTokenProjection!contract",
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
            virtual_center
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
            FSType | String,
            StoragePolicyID | String,
            StoragePolicyName | String,
            VolumePath | String,
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