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
  {
      addLabels
        | Array (String)
        | doc "Labels to add to Pull Request."
        | optional,
      additionalBranchPrefix
        | String
        | doc "Additional string value to be appended to `branchPrefix`."
        | optional,
      additionalReviewers
        | Array (String)
        | doc "Additional reviewers for Pull Requests (in contrast to `reviewers`, this option adds to the existing reviewer list, rather than replacing it)."
        | optional,
      allowCustomCrateRegistries
        | Bool
        | doc "Set this to `true` to allow custom crate registries."
        | optional,
      allowPlugins
        | Bool
        | doc "Set this to `true` if repositories are allowed to run install plugins."
        | optional,
      allowPostUpgradeCommandTemplating
        | Bool
        | doc "Set this to `false` to disable template compilation for post-upgrade commands."
        | optional,
      allowScripts
        | Bool
        | doc "Set this to `true` if repositories are allowed to run install scripts."
        | optional,
      allowedEnv
        | Array (String)
        | doc "List of allowed patterns for environment variable names in repository env config."
        | optional,
      allowedHeaders
        | Array (String)
        | doc "List of allowed patterns for header names in repository hostRules config."
        | optional,
      allowedPostUpgradeCommands
        | Array (String)
        | doc "A list of regular expressions that decide which post-upgrade tasks are allowed."
        | optional,
      ansible
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the ansible manager"
        | optional,
      ansible-galaxy
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the ansible-galaxy manager"
        | optional,
      argocd
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the argocd manager"
        | optional,
      asdf
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the asdf manager"
        | optional,
      assignAutomerge
        | Bool
        | doc "Assign reviewers and assignees even if the PR is to be automerged."
        | optional,
      assignees
        | Array (String)
        | doc "Assignees for Pull Request (either username or email address depending on the platform)."
        | optional,
      assigneesFromCodeOwners
        | Bool
        | doc "Determine assignees based on configured code owners and changes in PR."
        | optional,
      assigneesSampleSize
        | std.number.Integer
        | doc "Take a random sample of given size from `assignees`."
        | optional,
      autoApprove
        | Bool
        | doc "Set to `true` to automatically approve PRs."
        | optional,
      autoReplaceGlobalMatch
        | Bool
        | doc "Control whether replacement regular expressions are global matches or only the first match."
        | optional,
      autodiscover | Bool | doc "Autodiscover all repositories." | optional,
      autodiscoverFilter
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Filter the list of autodiscovered repositories."
        | optional,
      autodiscoverNamespaces
        | Array (String)
        | doc "Filter the list of autodiscovered repositories by namespaces."
        | optional,
      autodiscoverProjects
        | Array (String)
        | doc "Filter the list of autodiscovered repositories by project names."
        | optional,
      autodiscoverRepoOrder
        | std.enum.TagOrString
        | [| 'desc, 'asc |]
        | doc "The order method for autodiscover server side repository search."
        | optional,
      autodiscoverRepoSort
        | std.enum.TagOrString
        | [| 'id, 'size, 'updated, 'created, 'alpha |]
        | doc "The sort method for autodiscover server side repository search."
        | optional,
      autodiscoverTopics
        | Array (String)
        | doc "Filter the list of autodiscovered repositories by topics."
        | optional,
      automerge
        | Bool
        | doc "Whether to automerge branches/PRs automatically, without human intervention."
        | optional,
      automergeComment
        | String
        | doc "PR comment to add to trigger automerge. Only used if `automergeType=pr-comment`."
        | optional,
      automergeSchedule
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Limit automerge to these times of day or week."
        | optional,
      automergeStrategy
        | std.enum.TagOrString
        | [| 'squash, 'rebase, 'merge-commit, 'fast-forward, 'auto |]
        | doc "The merge strategy to use when automerging PRs. Used only if `automergeType=pr`."
        | optional,
      automergeType
        | std.enum.TagOrString
        | [| 'pr-comment, 'pr, 'branch |]
        | doc "How to automerge, if enabled."
        | optional,
      azure-pipelines
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the azure-pipelines manager"
        | optional,
      azureWorkItemId
        | std.number.Integer
        | doc "The id of an existing work item on Azure Boards to link to each PR."
        | optional,
      baseBranches
        | Array (String)
        | doc "List of one or more custom base branches defined as exact strings and/or via regex expressions."
        | optional,
      baseDir
        | String
        | doc "The base directory for Renovate to store local files, including repository files and cache. If left empty, Renovate will create its own temporary directory to use."
        | optional,
      batect
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the batect manager"
        | optional,
      batect-wrapper
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the batect-wrapper manager"
        | optional,
      bazel
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bazel manager"
        | optional,
      bazel-module
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bazel-module manager"
        | optional,
      bazelisk
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bazelisk manager"
        | optional,
      bbUseDefaultReviewers
        | Bool
        | doc "Use the default reviewers (Bitbucket only)."
        | optional,
      bbUseDevelopmentBranch
        | Bool
        | doc "Use the repository's [development branch](https://support.atlassian.com/bitbucket-cloud/docs/branch-a-repository/#The-branching-model) as the repository's default branch."
        | optional,
      bicep
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bicep manager"
        | optional,
      binarySource
        | std.enum.TagOrString
        | [| 'hermit, 'install, 'docker, 'global |]
        | doc "Controls how third-party tools like npm or Gradle are called: directly, via Docker sidecar containers, or via dynamic install."
        | optional,
      bitbucket-pipelines
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bitbucket-pipelines manager"
        | optional,
      branchConcurrentLimit
        | std.number.Integer
        | doc "Limit to a maximum of x concurrent branches. 0 means no limit, `null` (default) inherits value from `prConcurrentLimit`."
        | optional,
      branchName | String | doc "Branch name template." | optional,
      branchNameStrict
        | Bool
        | doc "Whether to be strict about the use of special characters within the branch name."
        | optional,
      branchPrefix
        | String
        | doc "Prefix to use for all branch names."
        | optional,
      branchPrefixOld
        | String
        | doc "Old branchPrefix value to check for existing PRs."
        | optional,
      branchTopic | String | doc "Branch topic." | optional,
      buildkite
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the buildkite manager"
        | optional,
      bumpVersion
        | std.enum.TagOrString
        | [| 'prerelease, 'patch, 'minor, 'major |]
        | doc "Bump the version in the package file being updated."
        | optional,
      bun
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bun manager"
        | optional,
      bundler
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the bundler manager"
        | optional,
      cacheDir
        | String
        | doc "The directory where Renovate stores its cache. If left empty, Renovate creates a subdirectory within the `baseDir`."
        | optional,
      cacheHardTtlMinutes
        | std.number.Integer
        | doc "Maximum duration in minutes to keep datasource cache entries."
        | optional,
      cacheTtlOverride
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "An object that contains cache namespace TTL override values."
        | optional,
      cake
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the cake manager"
        | optional,
      cargo
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the cargo manager"
        | optional,
      cdnurl
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the cdnurl manager"
        | optional,
      checkedBranches
        | Array (String)
        | doc "A list of branch names to mark for creation or rebasing as if it was selected in the Dependency Dashboard issue."
        | optional,
      circleci
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the circleci manager"
        | optional,
      cloneSubmodules
        | Bool
        | doc "Set to `true` to initialize submodules during repository clone."
        | optional,
      cloudbuild
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the cloudbuild manager"
        | optional,
      cocoapods
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the cocoapods manager"
        | optional,
      commitBody
        | String
        | doc "Commit message body template. Will be appended to commit message, separated by two line returns."
        | optional,
      commitBodyTable
        | Bool
        | doc "If enabled, append a table in the commit message body describing all updates in the commit."
        | optional,
      commitMessage
        | String
        | doc "Message to use for commit messages and pull request titles."
        | optional,
      commitMessageAction
        | String
        | doc "Action verb to use in commit messages and PR titles."
        | optional,
      commitMessageExtra
        | String
        | doc "Extra description used after the commit message topic - typically the version."
        | optional,
      commitMessageLowerCase
        | std.enum.TagOrString
        | [| 'never, 'auto |]
        | doc "Lowercase PR- and commit titles."
        | optional,
      commitMessagePrefix
        | String
        | doc "Prefix to add to start of commit messages and PR titles. Uses a semantic prefix if `semanticCommits` is enabled."
        | optional,
      commitMessageSuffix
        | String
        | doc "Suffix to add to end of commit messages and PR titles."
        | optional,
      commitMessageTopic
        | String
        | doc "The upgrade topic/noun used in commit messages and PR titles."
        | optional,
      composer
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the composer manager"
        | optional,
      composerIgnorePlatformReqs
        | Array (String)
        | doc "Configure use of `--ignore-platform-reqs` or `--ignore-platform-req` for the Composer package manager."
        | optional,
      conan
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the conan manager"
        | optional,
      confidential
        | Bool
        | doc "If enabled, issues created by Renovate are set as confidential."
        | optional,
      configMigration
        | Bool
        | doc "Enable this to get config migration PRs when needed."
        | optional,
      configWarningReuseIssue
        | Bool
        | doc "Set this to `false` to make Renovate create a new issue for each config warning, instead of reopening or reusing an existing issue."
        | optional,
      constraints
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object to define language or manager version constraints."
        | optional,
      constraintsFiltering
        | std.enum.TagOrString
        | [| 'strict, 'none |]
        | doc "Perform release filtering based on language constraints."
        | optional,
      containerbaseDir
        | String
        | doc "The directory where Renovate stores its containerbase cache. If left empty, Renovate creates a subdirectory within the `cacheDir`."
        | optional,
      cpanfile
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the cpanfile manager"
        | optional,
      crossplane
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the crossplane manager"
        | optional,
      customDatasources
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        defaultRegistryUrlTemplate =
                          _js2n__-prdslib.isType '"String",
                        description =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                                _js2n__-prdslib.isType '"String"
                              ],
                        format =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "json", "plain" ]
                              ],
                        transformTemplates =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                      } {} true _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.always
            ])
        | doc "Defines custom datasources for usage by managers."
        | optional,
      customEnvVariables
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Custom environment variables for child processes and sidecar Docker containers."
        | optional,
      customManagers
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    autoReplaceStringTemplate =
                      _js2n__-prdslib.isType '"String",
                    currentValueTemplate = _js2n__-prdslib.isType '"String",
                    customType =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum [ "regex" ]
                          ],
                    datasourceTemplate = _js2n__-prdslib.isType '"String",
                    depNameTemplate = _js2n__-prdslib.isType '"String",
                    depTypeTemplate = _js2n__-prdslib.isType '"String",
                    description =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    extractVersionTemplate = _js2n__-prdslib.isType '"String",
                    matchStrings =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.isType '"String")
                          ],
                    matchStringsStrategy =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [ "any", "recursive", "combination" ]
                          ],
                    packageNameTemplate = _js2n__-prdslib.isType '"String",
                    registryUrlTemplate = _js2n__-prdslib.isType '"String",
                    versioningTemplate = _js2n__-prdslib.isType '"String",
                  } {} true _js2n__-prdslib.always
              ])
        )
        | doc "Custom managers using regex matching."
        | optional,
      customizeDashboard
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | doc "Customize sections in the Dependency Dashboard issue."
        | optional,
      defaultRegistryUrls
        | Array (String)
        | doc "List of registry URLs to use as the default for a datasource."
        | optional,
      dependencyDashboard
        | Bool
        | doc "Whether to create a \"Dependency Dashboard\" issue in the repository."
        | optional,
      dependencyDashboardApproval
        | Bool
        | doc "Controls if updates need manual approval from the Dependency Dashboard issue before PRs are created."
        | optional,
      dependencyDashboardAutoclose
        | Bool
        | doc "Set to `true` to let Renovate close the Dependency Dashboard issue if there are no more updates."
        | optional,
      dependencyDashboardFooter
        | String
        | doc "Any text added here will be placed last in the Dependency Dashboard issue body, with a divider separator before it."
        | optional,
      dependencyDashboardHeader
        | String
        | doc "Any text added here will be placed first in the Dependency Dashboard issue body."
        | optional,
      dependencyDashboardLabels
        | Array (String)
        | doc "These labels will always be applied on the Dependency Dashboard issue, even when they have been removed manually."
        | optional,
      dependencyDashboardOSVVulnerabilitySummary
        | std.enum.TagOrString
        | [| 'unresolved, 'all, 'none |]
        | doc "Control if the Dependency Dashboard issue lists CVEs supplied by [osv.dev](https://osv.dev)."
        | optional,
      dependencyDashboardTitle
        | String
        | doc "Title for the Dependency Dashboard issue."
        | optional,
      deps-edn
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the deps-edn manager"
        | optional,
      description
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Plain text description for a config or preset."
        | optional,
      detectGlobalManagerConfig
        | Bool
        | doc "If `true`, Renovate tries to detect global manager configuration from the file system."
        | optional,
      detectHostRulesFromEnv
        | Bool
        | doc "If `true`, Renovate tries to detect host rules from environment variables."
        | optional,
      devcontainer
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the devcontainer manager"
        | optional,
      digest
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when updating a digest (no change in tag/version)."
        | optional,
      docker-compose
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the docker-compose manager"
        | optional,
      dockerChildPrefix
        | String
        | doc "Change this value to add a prefix to the Renovate Docker sidecar container names and labels."
        | optional,
      dockerCliOptions
        | String
        | doc "Pass CLI flags to `docker run` command when `binarySource=docker`."
        | optional,
      dockerSidecarImage
        | String
        | doc "Change this value to override the default Renovate sidecar image."
        | optional,
      dockerUser
        | String
        | doc "Set the `UID` and `GID` for Docker-based binaries if you use `binarySource=docker`."
        | optional,
      dockerfile
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the dockerfile manager"
        | optional,
      draftPR
        | Bool
        | doc "If set to `true` then Renovate creates draft PRs, instead of normal status PRs."
        | optional,
      droneci
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the droneci manager"
        | optional,
      dryRun
        | std.enum.TagOrString
        | [| 'full, 'lookup, 'extract |]
        | doc "If enabled, perform a dry run by logging messages instead of creating/updating/deleting branches and PRs."
        | optional,
      enabled | Bool | doc "Enable or disable Renovate bot." | optional,
      enabledManagers
        | Array (String)
        | doc "A list of package managers to enable. Only managers on the list are enabled."
        | optional,
      encrypted
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "An object containing configuration encrypted with project key."
        | optional,
      encryptedWarning
        | String
        | doc "Warning text to use if encrypted config is found."
        | optional,
      endpoint | String | doc "Custom endpoint to use." | optional,
      env
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Environment variables that Renovate uses when executing package manager commands."
        | optional,
      excludeCommitPaths
        | Array (String)
        | doc "A file matching any of these glob patterns will not be committed, even if the file has been updated."
        | optional,
      executionTimeout
        | std.number.Integer
        | doc "Default execution timeout in minutes for child processes Renovate creates."
        | optional,
      expandCodeOwnersGroups
        | Bool
        | doc "Expand the configured code owner groups into a full list of group members."
        | optional,
      exposeAllEnv
        | Bool
        | doc "Set this to `true` to allow passing of all environment variables to package managers."
        | optional,
      extends
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Configuration presets to use or extend."
        | optional,
      extractVersion
        | String
        | doc "A regex (`re2`) to extract a version from a datasource's raw version string."
        | optional,
      fetchChangeLogs
        | std.enum.TagOrString
        | [| 'pr, 'branch, 'off |]
        | doc "Controls if and when changelogs/release notes are fetched."
        | optional,
      fileMatch
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "RegEx (`re2`) pattern for matching manager files."
        | optional,
      filterUnavailableUsers
        | Bool
        | doc "Filter reviewers and assignees based on their availability."
        | optional,
      fleet
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the fleet manager"
        | optional,
      flux
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the flux manager"
        | optional,
      followTag
        | String
        | doc "If defined, packages will follow this release tag exactly."
        | optional,
      "force"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Any configuration set in this object will force override existing settings."
        | optional,
      forceCli
        | Bool
        | doc "Decides if CLI configuration options are moved to the `force` config section."
        | optional,
      forkCreation
        | Bool
        | doc "Whether to create forks as needed at runtime when running in \"fork mode\"."
        | optional,
      forkModeDisallowMaintainerEdits
        | Bool
        | doc "Disallow maintainers to push to Renovate pull requests when running in fork mode."
        | optional,
      forkOrg
        | String
        | doc "The preferred organization to create or find forked repositories, when in fork mode."
        | optional,
      forkProcessing
        | std.enum.TagOrString
        | [| 'disabled, 'enabled, 'auto |]
        | doc "Whether to process forked repositories. By default, all forked repositories are skipped when in `autodiscover` mode."
        | optional,
      forkToken
        | String
        | doc "Set a personal access token here to enable \"fork mode\"."
        | optional,
      fvm
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the fvm manager"
        | optional,
      git-submodules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the git-submodules manager"
        | optional,
      gitAuthor
        | String
        | doc "Author to use for Git commits. Must conform to [RFC5322](https://datatracker.ietf.org/doc/html/rfc5322)."
        | optional,
      gitIgnoredAuthors
        | Array (String)
        | doc "Git authors which are ignored by Renovate. Must conform to [RFC5322](https://datatracker.ietf.org/doc/html/rfc5322)."
        | optional,
      gitLabIgnoreApprovals
        | Bool
        | doc "Ignore approval rules for MRs created by Renovate, which is useful for automerge."
        | optional,
      gitNoVerify
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "commit", "push" ]
                      ])
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "commit", "push" ]
                ]
            ])
        | doc "Which Git commands will be run with the `--no-verify` option."
        | optional,
      gitPrivateKey
        | String
        | doc "PGP key to use for signing Git commits."
        | optional,
      gitTimeout
        | std.number.Integer
        | doc "Configure the timeout with a number of milliseconds to wait for a Git task."
        | optional,
      gitUrl
        | std.enum.TagOrString
        | [| 'endpoint, 'ssh, '"default" |]
        | doc "Overrides the default resolution for Git remote, e.g. to switch GitLab from HTTPS to SSH-based."
        | optional,
      github-actions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the github-actions manager"
        | optional,
      githubTokenWarn
        | Bool
        | doc "Display warnings about GitHub token not being set."
        | optional,
      gitlabci
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the gitlabci manager"
        | optional,
      gitlabci-include
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the gitlabci-include manager"
        | optional,
      globalExtends
        | Array (String)
        | doc "Configuration presets to use or extend for a self-hosted config."
        | optional,
      goGetDirs
        | Array (String)
        | doc "Directory pattern to run `go get` on."
        | optional,
      gomod
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the gomod manager"
        | optional,
      gradle
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the gradle manager"
        | optional,
      gradle-wrapper
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the gradle-wrapper manager"
        | optional,
      group
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Config if `groupName` is enabled."
        | optional,
      groupName
        | String
        | doc "Human understandable name for the dependency group."
        | optional,
      groupSlug
        | String
        | doc "Slug to use for group (e.g. in branch name). Slug is calculated from `groupName` if `null`."
        | optional,
      hashedBranchLength
        | std.number.Integer
        | doc "If enabled, branch names will use a hashing function to ensure each branch has that length."
        | optional,
      helm-requirements
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the helm-requirements manager"
        | optional,
      helm-values
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the helm-values manager"
        | optional,
      helmfile
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the helmfile manager"
        | optional,
      helmsman
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the helmsman manager"
        | optional,
      helmv3
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the helmv3 manager"
        | optional,
      hermit
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the hermit manager"
        | optional,
      homebrew
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the homebrew manager"
        | optional,
      hostRules
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    abortIgnoreStatusCodes =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.isType '"Number")
                          ],
                    abortOnError = _js2n__-prdslib.isType '"Bool",
                    artifactAuth =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "composer" ]
                                ])
                          ],
                    authType = _js2n__-prdslib.isType '"String",
                    concurrentRequestLimit = _js2n__-prdslib.isType 'Integer,
                    description =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    dnsCache = _js2n__-prdslib.isType '"Bool",
                    enableHttp2 = _js2n__-prdslib.isType '"Bool",
                    headers =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.always
                          ],
                    hostType = _js2n__-prdslib.isType '"String",
                    httpsCertificate = _js2n__-prdslib.isType '"String",
                    httpsCertificateAuthority =
                      _js2n__-prdslib.isType '"String",
                    httpsPrivateKey = _js2n__-prdslib.isType '"String",
                    insecureRegistry = _js2n__-prdslib.isType '"Bool",
                    keepAlive = _js2n__-prdslib.isType '"Bool",
                    matchHost = _js2n__-prdslib.isType '"String",
                    maxRequestsPerSecond = _js2n__-prdslib.isType 'Integer,
                    maxRetryAfter = _js2n__-prdslib.isType 'Integer,
                    readOnly = _js2n__-prdslib.isType '"Bool",
                    timeout = _js2n__-prdslib.isType 'Integer,
                  } {} true _js2n__-prdslib.always
              ])
        )
        | doc "Host rules/configuration including credentials."
        | optional,
      html
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the html manager"
        | optional,
      httpCacheTtlDays
        | std.number.Integer
        | doc "Maximum duration in days to keep HTTP cache entries."
        | optional,
      ignoreDeprecated
        | Bool
        | doc "Avoid upgrading from a non-deprecated version to a deprecated one."
        | optional,
      ignoreDeps | Array (String) | doc "Dependencies to ignore." | optional,
      ignorePaths
        | Array (String)
        | doc "Skip any package file whose path matches one of these. Can be a string or glob pattern."
        | optional,
      ignorePlugins
        | Bool
        | doc "Set this to `true` if `allowPlugins=true` but you wish to skip running plugins when updating lock files."
        | optional,
      ignorePrAuthor
        | Bool
        | doc "Set to `true` to fetch the entire list of PRs instead of only those authored by the Renovate user."
        | optional,
      ignorePresets
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "A list of presets to ignore, including any that are nested inside an `extends` array."
        | optional,
      ignoreReviewers
        | Array (String)
        | doc "Reviewers to be ignored in PR reviewers presence (either username or email address depending on the platform)."
        | optional,
      ignoreScripts
        | Bool
        | doc "Set this to `false` if `allowScripts=true` and you wish to run scripts when updating lock files."
        | optional,
      ignoreTests
        | Bool
        | doc "Set to `true` to enable automerging without tests."
        | optional,
      ignoreUnstable
        | Bool
        | doc "Ignore versions with unstable SemVer."
        | optional,
      includeMirrors
        | Bool
        | doc "Whether to process repositories that are mirrors. By default, repositories that are mirrors are skipped."
        | optional,
      includePaths
        | Array (String)
        | doc "Include package files only within these defined paths."
        | optional,
      inheritConfig
        | Bool
        | doc "If `true`, Renovate will inherit configuration from the `inheritConfigFileName` file in `inheritConfigRepoName`."
        | optional,
      inheritConfigFileName
        | String
        | doc "Renovate will look for this config file name in the `inheritConfigRepoName`."
        | optional,
      inheritConfigRepoName
        | String
        | doc "Renovate will look in this repo for the `inheritConfigFileName`."
        | optional,
      inheritConfigStrict
        | Bool
        | doc "If `true`, any `inheritedConfig` fetch error will result in an aborted run."
        | optional,
      internalChecksAsSuccess
        | Bool
        | doc "Whether to consider passing internal checks such as `minimumReleaseAge` when determining branch status."
        | optional,
      internalChecksFilter
        | std.enum.TagOrString
        | [| 'none, 'flexible, 'strict |]
        | doc "When and how to filter based on internal checks."
        | optional,
      jenkins
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the jenkins manager"
        | optional,
      jsonnet-bundler
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the jsonnet-bundler manager"
        | optional,
      keepUpdatedLabel
        | String
        | doc "If set, users can add this label to PRs to request they be kept updated with the base branch."
        | optional,
      kotlin-script
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the kotlin-script manager"
        | optional,
      kubernetes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the kubernetes manager"
        | optional,
      kustomize
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the kustomize manager"
        | optional,
      labels | Array (String) | doc "Labels to set in Pull Request." | optional,
      leiningen
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the leiningen manager"
        | optional,
      lockFileMaintenance
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration for lock file maintenance."
        | optional,
      logContext
        | String
        | doc "Add a global or per-repo log context to each log entry."
        | optional,
      logFile | String | doc "Log file path." | optional,
      logFileLevel | String | doc "Set the log file log level." | optional,
      logLevelRemap
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    description =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchMessage = _js2n__-prdslib.isType '"String",
                    newLogLevel =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "trace",
                                "debug",
                                "info",
                                "warn",
                                "error",
                                "fatal"
                              ]
                          ],
                  } {} true _js2n__-prdslib.always
              ])
        )
        | doc "Remap log levels to different levels."
        | optional,
      major
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when an update type is `major`."
        | optional,
      maven
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the maven manager"
        | optional,
      maven-wrapper
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the maven-wrapper manager"
        | optional,
      mergeConfidenceDatasources
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "go",
                        "maven",
                        "npm",
                        "nuget",
                        "packagist",
                        "pypi",
                        "rubygems"
                      ]
                  ])
            ])
        | doc "If set, Renovate will query the merge-confidence JSON API only for datasources that are part of this list."
        | optional,
      mergeConfidenceEndpoint
        | String
        | doc "If set, Renovate will query this API for Merge Confidence data."
        | optional,
      meteor
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the meteor manager"
        | optional,
      migratePresets
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.always
            ])
        | doc "Define presets here which have been removed or renamed and should be migrated automatically."
        | optional,
      milestone
        | std.number.Integer
        | doc "The number of a milestone. If set, the milestone will be set when Renovate creates the PR."
        | optional,
      minimumReleaseAge
        | String
        | doc "Time required before a new release is considered stable."
        | optional,
      minor
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when an update type is `minor`."
        | optional,
      mint
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the mint manager"
        | optional,
      mix
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the mix manager"
        | optional,
      mode
        | std.enum.TagOrString
        | [| 'silent, 'full |]
        | doc "Mode of operation."
        | optional,
      nix
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the nix manager"
        | optional,
      nodenv
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the nodenv manager"
        | optional,
      npm
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the npm manager"
        | optional,
      npmToken
        | String
        | doc "npm token used to authenticate with the default registry."
        | optional,
      npmrc
        | String
        | doc "String copy of `.npmrc` file. Use `\\n` instead of line breaks."
        | optional,
      npmrcMerge
        | Bool
        | doc "Whether to merge `config.npmrc` with repo `.npmrc` content if both are found."
        | optional,
      nuget
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the nuget manager"
        | optional,
      nvm
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the nvm manager"
        | optional,
      ocb
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the ocb manager"
        | optional,
      onboarding | Bool | doc "Require a Configuration PR first." | optional,
      onboardingBranch
        | String
        | doc "Change this value to override the default onboarding branch name."
        | optional,
      onboardingCommitMessage
        | String
        | doc "Change this value to override the default onboarding commit message."
        | optional,
      onboardingConfig
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to use for onboarding PRs."
        | optional,
      onboardingConfigFileName
        | String
        | doc "Change this value to override the default onboarding config file name."
        | optional,
      onboardingNoDeps
        | Bool
        | doc "Onboard the repository even if no dependencies are found."
        | optional,
      onboardingPrTitle
        | String
        | doc "Change this value to override the default onboarding PR title."
        | optional,
      onboardingRebaseCheckbox
        | Bool
        | doc "Set to enable rebase/retry markdown checkbox for onboarding PRs."
        | optional,
      optimizeForDisabled
        | Bool
        | doc "Set to `true` to perform a check for disabled config prior to cloning."
        | optional,
      osgi
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the osgi manager"
        | optional,
      osvVulnerabilityAlerts
        | Bool
        | doc "Use vulnerability alerts from `osv.dev`."
        | optional,
      packageRules
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record
                  {
                    allowedVersions = _js2n__-prdslib.isType '"String",
                    changelogUrl = _js2n__-prdslib.isType '"String",
                    description =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludeDepNames =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludeDepPatterns =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludeDepPrefixes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludePackageNames =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludePackagePatterns =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludePackagePrefixes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    excludeRepositories =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchBaseBranches =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchCategories =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchConfidence =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "low",
                                          "neutral",
                                          "high",
                                          "very high"
                                        ]
                                    ])
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "low", "neutral", "high", "very high" ]
                              ]
                          ],
                    matchCurrentAge = _js2n__-prdslib.isType '"String",
                    matchCurrentValue = _js2n__-prdslib.isType '"String",
                    matchCurrentVersion = _js2n__-prdslib.isType '"String",
                    matchDatasources =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchDepNames =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchDepPatterns =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchDepPrefixes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchDepTypes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchFileNames =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              (_js2n__-prdslib.isType '"String")
                          ],
                    matchManagers =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchNewValue = _js2n__-prdslib.isType '"String",
                    matchPackageNames =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchPackagePatterns =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchPackagePrefixes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchRepositories =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchSourceUrlPrefixes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchSourceUrls =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                            _js2n__-prdslib.isType '"String"
                          ],
                    matchUpdateTypes =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "major",
                                          "minor",
                                          "patch",
                                          "pin",
                                          "pinDigest",
                                          "digest",
                                          "lockFileMaintenance",
                                          "rollback",
                                          "bump",
                                          "replacement"
                                        ]
                                    ])
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "major",
                                    "minor",
                                    "patch",
                                    "pin",
                                    "pinDigest",
                                    "digest",
                                    "lockFileMaintenance",
                                    "rollback",
                                    "bump",
                                    "replacement"
                                  ]
                              ]
                          ],
                    prPriority = _js2n__-prdslib.isType 'Integer,
                    replacementName = _js2n__-prdslib.isType '"String",
                    replacementNameTemplate = _js2n__-prdslib.isType '"String",
                    replacementVersion = _js2n__-prdslib.isType '"String",
                    sourceDirectory = _js2n__-prdslib.isType '"String",
                    sourceUrl = _js2n__-prdslib.isType '"String",
                  } {} true _js2n__-prdslib.always
              ])
        )
        | doc "Rules for matching packages."
        | optional,
      password | String | doc "Password for authentication." | optional,
      patch
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when an update type is `patch`."
        | optional,
      pep621
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pep621 manager"
        | optional,
      persistRepoData
        | Bool
        | doc "If set to `true`: keep repository data between runs instead of deleting the data."
        | optional,
      pin
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when an update type is `pin`."
        | optional,
      pinDigest
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when pinning a digest (no change in tag/version)."
        | optional,
      pinDigests
        | Bool
        | doc "Whether to add digests to Dockerfile source images."
        | optional,
      pip-compile
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pip-compile manager"
        | optional,
      pip_requirements
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pip_requirements manager"
        | optional,
      pip_setup
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pip_setup manager"
        | optional,
      pipenv
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pipenv manager"
        | optional,
      platform
        | std.enum.TagOrString
        | [|
          'local,
          'gitlab,
          'github,
          'gitea,
          'gerrit,
          'codecommit,
          'bitbucket-server,
          'bitbucket,
          'azure
        |]
        | doc "Platform type of repository."
        | optional,
      platformAutomerge
        | Bool
        | doc "Controls if platform-native auto-merge is used."
        | optional,
      platformCommit
        | Bool
        | doc "Use platform API to perform commits instead of using Git directly."
        | optional,
      poetry
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the poetry manager"
        | optional,
      postUpdateOptions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "bundlerConservative",
                        "gomodMassage",
                        "gomodTidy",
                        "gomodTidy1.17",
                        "gomodTidyE",
                        "gomodUpdateImportPaths",
                        "helmUpdateSubChartArchives",
                        "npmDedupe",
                        "pnpmDedupe",
                        "yarnDedupeFewer",
                        "yarnDedupeHighest"
                      ]
                  ])
            ])
        | doc "Enable post-update options to be run after package/artifact updating."
        | optional,
      postUpgradeTasks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        commands =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        description =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                                _js2n__-prdslib.isType '"String"
                              ],
                        executionMode =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "update", "branch" ]
                              ],
                        fileFilters =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                      } {} true _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.always
            ])
        | doc "Post-upgrade tasks that are executed before a commit is made by Renovate."
        | optional,
      prBodyColumns
        | Array (String)
        | doc "List of columns to use in PR bodies."
        | optional,
      prBodyDefinitions
        | {  .. }
        | doc "Table column definitions to use in PR tables."
        | optional,
      prBodyNotes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "List of extra notes or templates to include in the Pull Request body."
        | optional,
      prBodyTemplate
        | String
        | doc "Pull Request body template. Controls which sections are rendered in the body of the pull request."
        | optional,
      prCommitsPerRunLimit
        | std.number.Integer
        | doc "Set the maximum number of commits per Renovate run. By default there is no limit."
        | optional,
      prConcurrentLimit
        | std.number.Integer
        | doc "Limit to a maximum of x concurrent branches/PRs. 0 means no limit."
        | optional,
      prCreation
        | std.enum.TagOrString
        | [| 'approval, 'status-success, 'not-pending, 'immediate |]
        | doc "When to create the PR for a branch."
        | optional,
      prFooter
        | String
        | doc "Text added here will be placed last in the PR body, with a divider separator before it."
        | optional,
      prHeader
        | String
        | doc "Text added here will be placed first in the PR body."
        | optional,
      prHourlyLimit
        | std.number.Integer
        | doc "Rate limit PRs to maximum x created per hour. 0 means no limit."
        | optional,
      prNotPendingHours
        | std.number.Integer
        | doc "Timeout in hours for when `prCreation=not-pending`."
        | optional,
      prTitle
        | String
        | doc "Pull Request title template. Inherits from `commitMessage` if null."
        | optional,
      prTitleStrict
        | Bool
        | doc "Whether to bypass appending extra context to the Pull Request title."
        | optional,
      pre-commit
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pre-commit manager"
        | optional,
      presetCachePersistence
        | Bool
        | doc "Cache resolved presets in package cache."
        | optional,
      printConfig
        | Bool
        | doc "If enabled, Renovate logs the fully resolved config for each repository, plus the fully resolved presets."
        | optional,
      privateKey | String | doc "Server-side private key." | optional,
      privateKeyOld
        | String
        | doc "Secondary or old private key to try."
        | optional,
      privateKeyPath
        | String
        | doc "Path to the Server-side private key."
        | optional,
      privateKeyPathOld
        | String
        | doc "Path to the Server-side old private key."
        | optional,
      productLinks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.always
            ])
        | doc "Links which are used in PRs, issues and comments."
        | optional,
      pruneBranchAfterAutomerge
        | Bool
        | doc "Set to `true` to enable branch pruning after automerging."
        | optional,
      pruneStaleBranches
        | Bool
        | doc "Set to `false` to disable pruning stale branches."
        | optional,
      pub
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pub manager"
        | optional,
      puppet
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the puppet manager"
        | optional,
      pyenv
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the pyenv manager"
        | optional,
      rangeStrategy
        | std.enum.TagOrString
        | [|
          'in-range-only,
          'update-lockfile,
          'widen,
          'replace,
          'bump,
          'pin,
          'auto
        |]
        | doc "Determines how to modify or update existing ranges."
        | optional,
      rebaseLabel
        | String
        | doc "Label to request a rebase from Renovate bot."
        | optional,
      rebaseWhen
        | std.enum.TagOrString
        | [| 'behind-base-branch, 'conflicted, 'never, 'auto |]
        | doc "Controls when Renovate rebases an existing branch."
        | optional,
      recreateWhen
        | std.enum.TagOrString
        | [| 'never, 'always, 'auto |]
        | doc "Recreate PRs even if same ones were closed previously."
        | optional,
      redisPrefix
        | String
        | doc "Key prefix for redis cache entries."
        | optional,
      redisUrl
        | String
        | doc "If set, this Redis URL will be used for caching instead of the file system."
        | optional,
      regex
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the regex manager"
        | optional,
      registryAliases
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.always
            ])
        | doc "Aliases for registries."
        | optional,
      registryUrls
        | Array (String)
        | doc "List of URLs to try for dependency lookup. Package manager specific."
        | optional,
      replacement
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when replacing a dependency."
        | optional,
      reportPath
        | String
        | doc "Path to where the file should be written. In case of `s3` this has to be a full S3 URI."
        | optional,
      reportType
        | std.enum.TagOrString
        | [| 's3, 'file, 'logging |]
        | doc "Set how, or if, reports should be generated."
        | optional,
      repositories | Array (String) | doc "List of Repositories." | optional,
      repositoryCache
        | std.enum.TagOrString
        | [| 'reset, 'enabled, 'disabled |]
        | doc "This option decides if Renovate uses a JSON cache to speed up extractions."
        | optional,
      repositoryCacheType
        | String
        | doc "Set the type of renovate repository cache if `repositoryCache` is enabled."
        | optional,
      requireConfig
        | std.enum.TagOrString
        | [| 'ignored, '"optional", 'required |]
        | doc "Controls Renovate's behavior regarding repository config files such as `renovate.json`."
        | optional,
      respectLatest
        | Bool
        | doc "Ignore versions newer than npm \"latest\" version."
        | optional,
      reviewers
        | Array (String)
        | doc "Requested reviewers for Pull Requests (either username or email address depending on the platform)."
        | optional,
      reviewersFromCodeOwners
        | Bool
        | doc "Determine reviewers based on configured code owners and changes in PR."
        | optional,
      reviewersSampleSize
        | std.number.Integer
        | doc "Take a random sample of given size from `reviewers`."
        | optional,
      rollback
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration to apply when rolling back a version."
        | optional,
      rollbackPrs
        | Bool
        | doc "Create PRs to roll back versions if the current version is not found in the registry."
        | optional,
      ruby-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the ruby-version manager"
        | optional,
      runtime-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the runtime-version manager"
        | optional,
      sbt
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the sbt manager"
        | optional,
      scalafmt
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the scalafmt manager"
        | optional,
      schedule
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Limit branch creation to these times of day or week."
        | optional,
      secrets
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.always
            ])
        | doc "Object which holds secret name/value pairs."
        | optional,
      semanticCommitScope
        | String
        | doc "Commit scope to use if Semantic Commits are enabled."
        | optional,
      semanticCommitType
        | String
        | doc "Commit type to use if Semantic Commits is enabled."
        | optional,
      semanticCommits
        | std.enum.TagOrString
        | [| 'disabled, 'enabled, 'auto |]
        | doc "Enable Semantic Commit prefixes for commits and PR titles."
        | optional,
      separateMajorMinor
        | Bool
        | doc "If set to `false`, Renovate will upgrade dependencies to their latest release only. Renovate will not separate major or minor branches."
        | optional,
      separateMinorPatch
        | Bool
        | doc "If set to `true`, Renovate will separate `minor` and `patch` updates into separate branches."
        | optional,
      separateMultipleMajor
        | Bool
        | doc "If set to `true`, PRs will be raised separately for each available `major` upgrade version."
        | optional,
      separateMultipleMinor
        | Bool
        | doc "If set to `true`, Renovate creates separate PRs for each `minor` stream."
        | optional,
      setup-cfg
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the setup-cfg manager"
        | optional,
      skipInstalls
        | Bool
        | doc "Skip installing modules/dependencies if lock file updating is possible without a full install."
        | optional,
      statusCheckNames
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Custom strings to use as status check names."
        | optional,
      stopUpdatingLabel
        | String
        | doc "Label to make Renovate stop updating a PR."
        | optional,
      suppressNotifications
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "artifactErrors",
                        "branchAutomergeFailure",
                        "configErrorIssue",
                        "dependencyLookupWarnings",
                        "lockFileErrors",
                        "missingCredentialsError",
                        "onboardingClose",
                        "prEditedNotification",
                        "prIgnoreNotification"
                      ]
                  ])
            ])
        | doc "Options to suppress various types of warnings and other notifications."
        | optional,
      swift
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the swift manager"
        | optional,
      tekton
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the tekton manager"
        | optional,
      terraform
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the terraform manager"
        | optional,
      terraform-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the terraform-version manager"
        | optional,
      terragrunt
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the terragrunt manager"
        | optional,
      terragrunt-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the terragrunt-version manager"
        | optional,
      tflint-plugin
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the tflint-plugin manager"
        | optional,
      timezone
        | String
        | doc "Must conform to [IANA Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) format."
        | optional,
      token | String | doc "Repository Auth Token." | optional,
      transitiveRemediation
        | Bool
        | doc "Enable remediation of transitive dependencies."
        | optional,
      travis
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the travis manager"
        | optional,
      unicodeEmoji | Bool | doc "Enable or disable Unicode emoji." | optional,
      updateInternalDeps
        | Bool
        | doc "Whether to update internal dep versions in a monorepo. Works on Yarn Workspaces."
        | optional,
      updateLockFiles
        | Bool
        | doc "Set to `false` to disable lock file updating."
        | optional,
      updateNotScheduled
        | Bool
        | doc "Whether to update branches when not scheduled. Renovate will not create branches outside of the schedule."
        | optional,
      updatePinnedDependencies
        | Bool
        | doc "Whether to update pinned (single version) dependencies or not."
        | optional,
      useBaseBranchConfig
        | std.enum.TagOrString
        | [| 'none, '"merge" |]
        | doc "Whether to read configuration from `baseBranches` instead of only the default branch."
        | optional,
      useCloudMetadataServices
        | Bool
        | doc "If `false`, Renovate does not try to access cloud metadata services."
        | optional,
      userAgent
        | String
        | doc "If set to any string, Renovate will use this as the `user-agent` it sends with HTTP requests."
        | optional,
      userStrings
        | {  .. }
        | doc "User-facing strings for the Renovate comment when a PR is closed."
        | optional,
      username | String | doc "Username for authentication." | optional,
      velaci
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the velaci manager"
        | optional,
      vendir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the vendir manager"
        | optional,
      versionCompatibility
        | String
        | doc "A regex (`re2`) with named capture groups to show how version and compatibility are split from a raw version string."
        | optional,
      versioning
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.enum
                    [
                      "aws-machine-image",
                      "azure-rest-api",
                      "bazel-module",
                      "cargo",
                      "composer",
                      "conan",
                      "deb",
                      "debian",
                      "docker",
                      "git",
                      "glasskube",
                      "go-mod-directive",
                      "gradle",
                      "hashicorp",
                      "helm",
                      "hermit",
                      "hex",
                      "ivy",
                      "kubernetes-api",
                      "loose",
                      "maven",
                      "nixpkgs",
                      "node",
                      "npm",
                      "nuget",
                      "pep440",
                      "perl",
                      "poetry",
                      "python",
                      "redhat",
                      "regex",
                      "rez",
                      "rpm",
                      "ruby",
                      "same-major",
                      "semver",
                      "semver-coerced",
                      "swift",
                      "ubuntu",
                      "unity3d"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^regex:"
                    ]
                ]
            ])
        | doc "Versioning to use for filtering and comparisons."
        | optional,
      vulnerabilityAlerts
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Config to apply when a PR is needed due to a vulnerability in the existing package version."
        | optional,
      woodpecker
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Record, _js2n__-prdslib.always ])
        | doc "Configuration object for the woodpecker manager"
        | optional,
      writeDiscoveredRepos
        | String
        | doc "Writes discovered repositories to a JSON file and then exit."
        | optional,
      ..
    }