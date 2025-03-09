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
      "_js2n__-:definitions/buildFilter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignoredPaths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cronService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "name", "runtime", "schedule", "type" ],
              _js2n__-prdslib.records.record
                {
                  autoDeploy = _js2n__-prdslib.isType '"Bool",
                  branch = _js2n__-prdslib.isType '"String",
                  buildCommand = _js2n__-prdslib.isType '"String",
                  buildFilter =
                    _js2n__-refsenv."_js2n__-:definitions/buildFilter!predicate",
                  dockerCommand = _js2n__-prdslib.isType '"String",
                  dockerContext = _js2n__-prdslib.isType '"String",
                  dockerfilePath = _js2n__-prdslib.isType '"String",
                  envVars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/envVar!predicate"
                        ],
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/image!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  plan = _js2n__-refsenv."_js2n__-:definitions/plan!predicate",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  registryCredential =
                    _js2n__-refsenv."_js2n__-:definitions/registryCredential!predicate",
                  repo = _js2n__-prdslib.isType '"String",
                  rootDir = _js2n__-prdslib.isType '"String",
                  runtime =
                    _js2n__-refsenv."_js2n__-:definitions/runtime!predicate",
                  schedule = _js2n__-prdslib.isType '"String",
                  startCommand = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "cron"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/database!contract" =
        {
            databaseName | String | optional,
            diskSizeGB
              | _js2n__-refsenv."_js2n__-:definitions/diskSizeGB!contract"
              | optional,
            highAvailability | { enabled | Bool, } | optional,
            ipAllowList
              | _js2n__-refsenv."_js2n__-:definitions/ipAllowList!contract"
              | optional,
            name | String,
            plan
              | _js2n__-refsenv."_js2n__-:definitions/plan!contract"
              | optional,
            postgresMajorVersion
              | std.enum.TagOrString
              | [| '"16", '"15", '"14", '"13", '"12", '"11", '"10" |]
              | doc "What major version of PostgreSQL the database will use. Please refer to https://docs.render.com/postgresql-upgrading#version-support for which versions may be valid for this owner."
              | optional,
            previewDiskSizeGB
              | _js2n__-refsenv."_js2n__-:definitions/diskSizeGB!contract"
              | doc "The disk size to use for this database in preview environments. If omitted, preview instances use the same disk size as the primary database (specified by `diskSizeGB`)."
              | optional,
            previewPlan
              | _js2n__-refsenv."_js2n__-:definitions/plan!contract"
              | optional,
            readReplicas
              | Array
                _js2n__-refsenv."_js2n__-:definitions/readReplica!contract"
              | optional,
            region
              | _js2n__-refsenv."_js2n__-:definitions/region!contract"
              | optional,
            user | String | optional,
          },
      "_js2n__-:definitions/disk!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "mountPath", "name" ],
              _js2n__-prdslib.records.record
                {
                  mountPath = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  sizeGB =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/diskSizeGB!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Integer,
                _js2n__-prdslib.numbers.minimum 1
              ]),
      "_js2n__-:definitions/envVar!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/envVarFromKeyValue!predicate",
              _js2n__-refsenv."_js2n__-:definitions/envVarFromDatabase!predicate",
              _js2n__-refsenv."_js2n__-:definitions/envVarFromService!predicate",
              _js2n__-refsenv."_js2n__-:definitions/envVarFromGroup!predicate"
            ],
      "_js2n__-:definitions/envVarFromDatabase!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fromDatabase", "key" ],
              _js2n__-prdslib.records.record
                {
                  fromDatabase =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "name", "property" ],
                          _js2n__-prdslib.records.record
                            {
                              name = _js2n__-prdslib.isType '"String",
                              property = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  key = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/envVarFromGroup!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fromGroup" ],
              _js2n__-prdslib.records.record
                { fromGroup = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/envVarFromKeyValue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  generateValue = _js2n__-prdslib.isType '"Bool",
                  key = _js2n__-prdslib.isType '"String",
                  previewValue =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  sync = _js2n__-prdslib.isType '"Bool",
                  value =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/envVarFromService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fromService", "key" ],
              _js2n__-prdslib.records.record
                {
                  fromService =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "name", "type" ],
                          _js2n__-prdslib.records.record
                            {
                              envVarKey = _js2n__-prdslib.isType '"String",
                              name = _js2n__-prdslib.isType '"String",
                              property = _js2n__-prdslib.isType '"String",
                              type =
                                _js2n__-refsenv."_js2n__-:definitions/serviceType!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  key = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/envVarGroup!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.records.required [ "envVars", "name" ],
                _js2n__-prdslib.records.record
                  {
                    envVars =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              _js2n__-refsenv."_js2n__-:definitions/envVarFromKeyValue!predicate"
                          ],
                    name = _js2n__-prdslib.isType '"String",
                  } {} false _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/header!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path", "value" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/image!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  creds =
                    _js2n__-refsenv."_js2n__-:definitions/registryCredential!predicate",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ipAllowList!contract" =
        Array { description | String | optional, source | String, .. },
      "_js2n__-:definitions/ipAllowList!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "source" ],
                    _js2n__-prdslib.records.record
                      {
                        description = _js2n__-prdslib.isType '"String",
                        source = _js2n__-prdslib.isType '"String",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/plan!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'accelerated-1024gb,
                'accelerated-768gb,
                'accelerated-512gb,
                'accelerated-384gb,
                'accelerated-256gb,
                'accelerated-128gb,
                'accelerated-64gb,
                'accelerated-32gb,
                'accelerated-16gb,
                'pro-512gb,
                'pro-384gb,
                'pro-256gb,
                'pro-192gb,
                'pro-128gb,
                'pro-64gb,
                'pro-32gb,
                'pro-16gb,
                'pro-8gb,
                'pro-4gb,
                'basic-4gb,
                'basic-1gb,
                'basic-256mb,
                '"pro ultra",
                '"pro max",
                '"pro plus",
                'pro,
                'standard,
                'starter,
                'free
              |]
            ],
      "_js2n__-:definitions/plan!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "free",
                  "starter",
                  "standard",
                  "pro",
                  "pro plus",
                  "pro max",
                  "pro ultra",
                  "basic-256mb",
                  "basic-1gb",
                  "basic-4gb",
                  "pro-4gb",
                  "pro-8gb",
                  "pro-16gb",
                  "pro-32gb",
                  "pro-64gb",
                  "pro-128gb",
                  "pro-192gb",
                  "pro-256gb",
                  "pro-384gb",
                  "pro-512gb",
                  "accelerated-16gb",
                  "accelerated-32gb",
                  "accelerated-64gb",
                  "accelerated-128gb",
                  "accelerated-256gb",
                  "accelerated-384gb",
                  "accelerated-512gb",
                  "accelerated-768gb",
                  "accelerated-1024gb"
                ]
            ],
      "_js2n__-:definitions/previewsGeneration!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'off, 'manual, 'automatic |] ],
      "_js2n__-:definitions/previewsGeneration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "automatic", "manual", "off" ]
            ],
      "_js2n__-:definitions/readReplica!contract" =
        { name | String | optional, },
      "_js2n__-:definitions/redisServer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "ipAllowList", "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  ipAllowList =
                    _js2n__-refsenv."_js2n__-:definitions/ipAllowList!predicate",
                  maxmemoryPolicy = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  plan = _js2n__-refsenv."_js2n__-:definitions/plan!predicate",
                  previewPlan =
                    _js2n__-refsenv."_js2n__-:definitions/plan!predicate",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "redis"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/region!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'virginia, 'singapore, 'frankfurt, 'ohio, 'oregon |]
            ],
      "_js2n__-:definitions/region!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "oregon", "ohio", "frankfurt", "singapore", "virginia" ]
            ],
      "_js2n__-:definitions/registryCredential!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "fromRegistryCreds" ],
              _js2n__-prdslib.records.record
                {
                  fromRegistryCreds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "name" ],
                          _js2n__-prdslib.records.record
                            { name = _js2n__-prdslib.isType '"String", } {}
                            false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/rootPreviews!contract" =
        {
            expireAfterDays
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | optional,
            generation
              | _js2n__-refsenv."_js2n__-:definitions/previewsGeneration!contract"
              | optional,
          },
      "_js2n__-:definitions/route!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "destination", "source", "type" ],
              _js2n__-prdslib.records.record
                {
                  destination = _js2n__-prdslib.isType '"String",
                  source = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "redirect", "rewrite" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/runtime!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "docker",
                  "elixir",
                  "go",
                  "image",
                  "node",
                  "python",
                  "ruby",
                  "rust",
                  "static"
                ]
            ],
      "_js2n__-:definitions/serverService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "runtime", "type" ],
              _js2n__-prdslib.records.record
                {
                  autoDeploy = _js2n__-prdslib.isType '"Bool",
                  branch = _js2n__-prdslib.isType '"String",
                  buildCommand = _js2n__-prdslib.isType '"String",
                  buildFilter =
                    _js2n__-refsenv."_js2n__-:definitions/buildFilter!predicate",
                  disk = _js2n__-refsenv."_js2n__-:definitions/disk!predicate",
                  dockerCommand = _js2n__-prdslib.isType '"String",
                  dockerContext = _js2n__-prdslib.isType '"String",
                  dockerfilePath = _js2n__-prdslib.isType '"String",
                  domain = _js2n__-prdslib.isType '"String",
                  domains =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  envVars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/envVar!predicate"
                        ],
                  healthCheckPath = _js2n__-prdslib.isType '"String",
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/image!predicate",
                  initialDeployHook = _js2n__-prdslib.isType '"String",
                  maxShutdownDelaySeconds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 300,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  numInstances =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  plan = _js2n__-refsenv."_js2n__-:definitions/plan!predicate",
                  preDeployCommand = _js2n__-prdslib.isType '"String",
                  previewPlan =
                    _js2n__-refsenv."_js2n__-:definitions/plan!predicate",
                  previews =
                    _js2n__-refsenv."_js2n__-:definitions/servicePreviews!predicate",
                  pullRequestPreviewsEnabled = _js2n__-prdslib.isType '"Bool",
                  region =
                    _js2n__-refsenv."_js2n__-:definitions/region!predicate",
                  registryCredential =
                    _js2n__-refsenv."_js2n__-:definitions/registryCredential!predicate",
                  repo = _js2n__-prdslib.isType '"String",
                  rootDir = _js2n__-prdslib.isType '"String",
                  runtime =
                    _js2n__-refsenv."_js2n__-:definitions/runtime!predicate",
                  scaling =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              maxInstances =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              minInstances =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              targetCPUPercent =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum 90,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              targetMemoryPercent =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum 90,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  startCommand = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "web", "worker", "pserv" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/servicePreviews!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  generation =
                    _js2n__-refsenv."_js2n__-:definitions/previewsGeneration!predicate",
                  plan = _js2n__-refsenv."_js2n__-:definitions/plan!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/serviceType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "web",
                  "cron",
                  "worker",
                  "pserv",
                  "static",
                  "dpg",
                  "job",
                  "redis"
                ]
            ],
      "_js2n__-:definitions/staticService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  autoDeploy = _js2n__-prdslib.isType '"Bool",
                  branch = _js2n__-prdslib.isType '"String",
                  buildCommand = _js2n__-prdslib.isType '"String",
                  buildFilter =
                    _js2n__-refsenv."_js2n__-:definitions/buildFilter!predicate",
                  domain = _js2n__-prdslib.isType '"String",
                  domains =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  envVars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/envVar!predicate"
                        ],
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/header!predicate"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  previews =
                    _js2n__-refsenv."_js2n__-:definitions/staticServicePreviews!predicate",
                  pullRequestPreviewsEnabled = _js2n__-prdslib.isType '"Bool",
                  repo = _js2n__-prdslib.isType '"String",
                  rootDir = _js2n__-prdslib.isType '"String",
                  routes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/route!predicate"
                        ],
                  runtime =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "static"
                        ],
                  staticPublishPath = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "web"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/staticServicePreviews!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  generation =
                    _js2n__-refsenv."_js2n__-:definitions/previewsGeneration!predicate",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      databases
        | Array _js2n__-refsenv."_js2n__-:definitions/database!contract"
        | optional,
      envVarGroups
        | Array _js2n__-refsenv."_js2n__-:definitions/envVarGroup!contract"
        | optional,
      previews
        | _js2n__-refsenv."_js2n__-:definitions/rootPreviews!contract"
        | optional,
      previewsEnabled | Bool | optional,
      previewsExpireAfterDays
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ])
        | optional,
      services
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-refsenv."_js2n__-:definitions/redisServer!predicate",
                _js2n__-refsenv."_js2n__-:definitions/cronService!predicate",
                _js2n__-refsenv."_js2n__-:definitions/serverService!predicate",
                _js2n__-refsenv."_js2n__-:definitions/staticService!predicate"
              ])
        )
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.const "1" ])
        | optional,
    }