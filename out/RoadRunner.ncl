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
      "_js2n__-:definitions/BoltDB!predicate"
        | doc "BoltDB config section"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file = _js2n__-prdslib.isType '"String",
                  interval = _js2n__-prdslib.isType 'Integer,
                  permission = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Duration!predicate"
        | doc "Time duration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^([0-9]*(\\.[0-9]*)?(ms|h|m|s))+$"
            ],
      "_js2n__-:definitions/Hashmap!predicate"
        | doc "Hashmap"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                { "^[a-zA-Z0-9._-]+$" = _js2n__-prdslib.isType '"String", }
                false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HostAndPort!predicate"
        | doc "Host and port"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^((([0-9a-zA-Z_.-]+|)|\\$\\{([^}]+)\\}):([0-9]{1,5})|\\$\\{([^}]+)\\})|\\$\\{([^}]+)\\}$"
            ],
      "_js2n__-:definitions/HostAndPortWithTCP!predicate"
        | doc "Host and port with tcp:// prefix"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(((tcp://[0-9a-zA-Z_.-]+|)|\\$\\{([^}]+)\\}):([0-9]{1,5}||\\$\\{([^}]+)\\}))|\\$\\{([^}]+)\\}$"
            ],
      "_js2n__-:definitions/KAFKA_J!predicate"
        | doc "Kafka jobs driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  brokers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "127.0.0.1:9092", "127.0.0.1:9002" ]
                              ])
                        ],
                  sasl =
                    _js2n__-prdslib.records.record
                        {
                          access_key = _js2n__-prdslib.isType '"String",
                          is_token = _js2n__-prdslib.isType '"Bool",
                          mechanism =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "aws_msk_iam",
                                            "plain",
                                            "SCRAM-SHA-256",
                                            "SCRAM-SHA-512"
                                          ]
                                      ])
                                ],
                          nonce = _js2n__-prdslib.isType '"String",
                          password = _js2n__-prdslib.isType '"String",
                          secret_key = _js2n__-prdslib.isType '"String",
                          session_token = _js2n__-prdslib.isType '"String",
                          user_agent = _js2n__-prdslib.isType '"String",
                          username = _js2n__-prdslib.isType '"String",
                          zid = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always,
                  tls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cert = _js2n__-prdslib.isType '"String",
                              client_auth_type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "request_client_cert",
                                          "require_any_client_cert",
                                          "verify_client_cert_if_given",
                                          "no_client_certs",
                                          "require_and_verify_client_cert"
                                        ]
                                    ],
                              key = _js2n__-prdslib.isType '"String",
                              root_ca = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/LogEncoding!predicate"
        | doc "Encoding format"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "console", "json" ]
            ],
      "_js2n__-:definitions/LogLevel!predicate"
        | doc "Logging level"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "debug", "info", "warn", "error", "panic" ]
            ],
      "_js2n__-:definitions/LogMode!predicate"
        | doc "Logging mode"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "development", "production", "raw" ]
            ],
      "_js2n__-:definitions/LogOutput!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Memcached!predicate"
        | doc "In-memory config section"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { addr = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Memory!predicate"
        | doc "In-memory config section"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { interval = _js2n__-prdslib.isType 'Integer, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/NATS_J!predicate"
        | doc "NATS jobs driver"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { addr = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Redis!predicate"
        | doc "Redis config section"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addrs = _js2n__-prdslib.isType '"Array",
                  db =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 10
                        ],
                  dial_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  idle_check_freq =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  idle_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  master_name = _js2n__-prdslib.isType '"String",
                  max_conn_age =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  max_retries = _js2n__-prdslib.isType 'Integer,
                  max_retry_backoff =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  min_idle_conns = _js2n__-prdslib.isType 'Integer,
                  min_retry_backoff =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  password = _js2n__-prdslib.isType '"String",
                  pool_size = _js2n__-prdslib.isType 'Integer,
                  pool_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  read_only = _js2n__-prdslib.isType '"Bool",
                  read_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  route_by_latency = _js2n__-prdslib.isType '"Bool",
                  route_randomly = _js2n__-prdslib.isType '"Bool",
                  sentinel_password = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                  write_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Service!predicate"
        | doc "User defined service"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  env =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate"
                        ],
                  exec_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/Duration!predicate"
                        ],
                  process_num = _js2n__-prdslib.isType 'Integer,
                  remain_after_exit = _js2n__-prdslib.isType '"Bool",
                  restart_sec = _js2n__-prdslib.isType 'Integer,
                  timeout_stop_sec = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TCPServers!predicate"
        | doc "TCP server"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "addr" ],
              _js2n__-prdslib.records.record
                {
                  addr =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9a-zA-Z_.-]+:[0-9]{1,5}$"
                        ],
                  delimiter = _js2n__-prdslib.isType '"String",
                  read_buf_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WorkersPool!predicate"
        | doc "Static pool with PHP workers"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allocate_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  command = _js2n__-prdslib.isType '"String",
                  debug = _js2n__-prdslib.isType '"Bool",
                  destroy_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  max_jobs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max_queue_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  num_workers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  reset_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  stream_timeout =
                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                  supervisor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              exec_ttl =
                                _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                              idle_ttl =
                                _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                              max_worker_memory =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              ttl =
                                _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                              watch_tick =
                                _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.minProperties 1,
          _js2n__-prdslib.records.required [ "version" ],
          _js2n__-prdslib.records.record
            {
              amqp =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          addr = _js2n__-prdslib.isType '"String",
                          tls =
                            _js2n__-prdslib.records.record
                                {
                                  cert = _js2n__-prdslib.isType '"String",
                                  client_auth_type =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "request_client_cert",
                                              "require_any_client_cert",
                                              "verify_client_cert_if_given",
                                              "no_client_certs",
                                              "require_and_verify_client_cert"
                                            ]
                                        ],
                                  key = _js2n__-prdslib.isType '"String",
                                  root_ca = _js2n__-prdslib.isType '"String",
                                } {} true _js2n__-prdslib.always,
                        } {} true _js2n__-prdslib.always
                    ],
              beanstalk =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          addr = _js2n__-prdslib.isType '"String",
                          timeout =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-refsenv."_js2n__-:definitions/Duration!predicate"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              centrifuge =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          grpc_api_address = _js2n__-prdslib.isType '"String",
                          name = _js2n__-prdslib.isType '"String",
                          pool =
                            _js2n__-refsenv."_js2n__-:definitions/WorkersPool!predicate",
                          proxy_address = _js2n__-prdslib.isType '"String",
                          tls =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      cert =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                1
                                            ],
                                      key =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                1
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          use_compressor = _js2n__-prdslib.isType '"Bool",
                          version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              fileserver =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          address = _js2n__-prdslib.always,
                          calculate_etag = _js2n__-prdslib.always,
                          serve =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "prefix" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            bytes_range =
                                              _js2n__-prdslib.isType '"Bool",
                                            cache_duration =
                                              _js2n__-prdslib.isType 'Integer,
                                            compress =
                                              _js2n__-prdslib.isType '"Bool",
                                            max_age =
                                              _js2n__-prdslib.isType 'Integer,
                                            prefix =
                                              _js2n__-prdslib.isType '"String",
                                            root =
                                              _js2n__-prdslib.isType '"String",
                                          } {} true _js2n__-prdslib.always
                                      ]),
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          stream_request_body = _js2n__-prdslib.always,
                          weak = _js2n__-prdslib.always,
                        } {} true _js2n__-prdslib.always
                    ],
              grpc =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          listen =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-refsenv."_js2n__-:definitions/HostAndPortWithTCP!predicate"
                                ],
                          max_concurrent_streams =
                            _js2n__-prdslib.isType 'Integer,
                          max_connection_age =
                            _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                          max_connection_age_grace =
                            _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                          max_connection_idle =
                            _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                          max_recv_msg_size = _js2n__-prdslib.isType 'Integer,
                          max_send_msg_size = _js2n__-prdslib.isType 'Integer,
                          ping_time =
                            _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                          pool =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/WorkersPool!predicate"
                                ],
                          proto =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          timeout =
                            _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                          tls =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      cert = _js2n__-prdslib.isType '"String",
                                      client_auth_type =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "request_client_cert",
                                                  "require_any_client_cert",
                                                  "verify_client_cert_if_given",
                                                  "no_client_certs",
                                                  "require_and_verify_client_cert"
                                                ]
                                            ],
                                      key = _js2n__-prdslib.isType '"String",
                                      root_ca =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              http =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record
                        {
                          access_logs = _js2n__-prdslib.isType '"Bool",
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/HostAndPort!predicate",
                          cache =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      api =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  basepath =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  prometheus =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              basepath =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  souin =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              basepath =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      cache_keys =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {
                                                  "^[a-zA-Z0-9._-]+$" =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              disable_body =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              disable_host =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              disable_method =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } true _js2n__-prdslib.always
                                            ],
                                      cdn =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  api_key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  dynamic =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  provider =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "fastly",
                                                              "cloudflare",
                                                              "akamai",
                                                              "varnish"
                                                            ]
                                                        ],
                                                  strategy =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [ "soft", "hard" ]
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      default_cache =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  allowed_http_verbs =
                                                    _js2n__-prdslib.isType
                                                        '"Array",
                                                  cache_name =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  default_cache_control =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  distributed =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  etcd =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              configuration =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          endpoints =
                                                                            _js2n__-prdslib.isType
                                                                                '"Array",
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  headers =
                                                    _js2n__-prdslib.isType
                                                        '"Array",
                                                  key =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              disable_body =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              disable_host =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              disable_method =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  olric =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              url =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
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
                                                              exclude =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  stale =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  timeout =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              backend =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              cache =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  ttl =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      log_level =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "DEBUG",
                                                  "INFO",
                                                  "WARN",
                                                  "DPANIC",
                                                  "PANIC",
                                                  "ERROR",
                                                  "FATAL"
                                                ]
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          fcgi =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "address" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          headers =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      cors =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  allow_credentials =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  allowed_headers =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  allowed_methods =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  allowed_origin =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  allowed_origin_regex =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  exposed_headers =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  max_age =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      request =
                                        _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate",
                                      response =
                                        _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                          http2 =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      h2c = _js2n__-prdslib.isType '"Bool",
                                      max_concurrent_streams =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          max_request_size =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          middleware =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "headers",
                                            "gzip",
                                            "static",
                                            "sendfile",
                                            "http_metrics",
                                            "cache",
                                            "proxy_ip_parser",
                                            "otel"
                                          ],
                                        _js2n__-prdslib.strings.pattern
                                          "^[0-9a-zA-Z_]+$"
                                      ])
                                ],
                          pool =
                            _js2n__-refsenv."_js2n__-:definitions/WorkersPool!predicate",
                          raw_body = _js2n__-prdslib.isType '"Bool",
                          ssl =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "address", "cert", "key" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      acme =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "domains", "email" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  alt_http_port =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                  alt_tlsalpn_port =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                  certs_dir =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  challenge_type =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "http-01",
                                                              "tlsalpn-01"
                                                            ]
                                                        ],
                                                  domains =
                                                    _js2n__-prdslib.isType
                                                        '"Array",
                                                  email =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  use_production_endpoint =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      address =
                                        _js2n__-refsenv."_js2n__-:definitions/HostAndPort!predicate",
                                      cert =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                1
                                            ],
                                      client_auth_type =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "request_client_cert",
                                                  "require_any_client_cert",
                                                  "verify_client_cert_if_given",
                                                  "no_client_certs",
                                                  "require_and_verify_client_cert"
                                                ]
                                            ],
                                      key =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                1
                                            ],
                                      redirect = _js2n__-prdslib.isType '"Bool",
                                      root_ca =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                1
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          static =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "dir" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      allow =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      calculate_etag =
                                        _js2n__-prdslib.isType '"Bool",
                                      dir = _js2n__-prdslib.isType '"String",
                                      forbid =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      response =
                                        _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate",
                                      weak = _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          trusted_subnets =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          uploads =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      allow =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      dir = _js2n__-prdslib.isType '"String",
                                      forbid =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              jobs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          consume =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          num_pollers = _js2n__-prdslib.isType 'Integer,
                          pipeline_size = _js2n__-prdslib.isType 'Integer,
                          pipelines =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      config =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {
                                                  "^[a-zA-Z0-9._-]+$" =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  file =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  permissions =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  prefetch =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                } {} true
                                                                _js2n__-prdslib.always,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  consume_all =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  consumer_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  exchange =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  exchange_auto_deleted =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  exchange_durable =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  exchange_type =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  exclusive =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  multiple_ack =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  prefetch =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  queue =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  queue_auto_deleted =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  queue_headers =
                                                                    _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate",
                                                                  redial_timeout =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  requeue_on_fail =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  routing_key =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  auto_create_topics_enable =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  consumer_options =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              consume_offset =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        'Record,
                                                                                      _js2n__-prdslib.records.record
                                                                                        {
                                                                                          type =
                                                                                            _js2n__-prdslib.allOf
                                                                                                [
                                                                                                  _js2n__-prdslib.isType
                                                                                                    '"String",
                                                                                                  _js2n__-prdslib.enum
                                                                                                    [
                                                                                                      "AtEnd",
                                                                                                      "At",
                                                                                                      "AfterMilli",
                                                                                                      "AtStart",
                                                                                                      "Relative",
                                                                                                      "WithEpoch"
                                                                                                    ]
                                                                                                ],
                                                                                          value =
                                                                                            _js2n__-prdslib.isType
                                                                                                'Integer,
                                                                                        }
                                                                                        {}
                                                                                        true
                                                                                        _js2n__-prdslib.always
                                                                                    ],
                                                                              consume_partitions =
                                                                                _js2n__-prdslib.records.record
                                                                                    {}
                                                                                    {
                                                                                      "^[a-zA-Z0-9._-]+$" =
                                                                                        _js2n__-prdslib.allOf
                                                                                            [
                                                                                              _js2n__-prdslib.isType
                                                                                                '"String",
                                                                                              _js2n__-prdslib.records.record
                                                                                                {}
                                                                                                {
                                                                                                  "^[0-9]+$" =
                                                                                                    _js2n__-prdslib.allOf
                                                                                                        [
                                                                                                          _js2n__-prdslib.isType
                                                                                                            'Integer,
                                                                                                          _js2n__-prdslib.records.record
                                                                                                            {
                                                                                                              type =
                                                                                                                _js2n__-prdslib.allOf
                                                                                                                    [
                                                                                                                      _js2n__-prdslib.isType
                                                                                                                        '"String",
                                                                                                                      _js2n__-prdslib.enum
                                                                                                                        [
                                                                                                                          "AtEnd",
                                                                                                                          "At",
                                                                                                                          "AfterMilli",
                                                                                                                          "AtStart",
                                                                                                                          "Relative",
                                                                                                                          "WithEpoch"
                                                                                                                        ]
                                                                                                                    ],
                                                                                                              value =
                                                                                                                _js2n__-prdslib.isType
                                                                                                                    'Integer,
                                                                                                            }
                                                                                                            {}
                                                                                                            true
                                                                                                            _js2n__-prdslib.always
                                                                                                        ],
                                                                                                }
                                                                                                true
                                                                                                _js2n__-prdslib.always
                                                                                            ],
                                                                                    }
                                                                                    true
                                                                                    _js2n__-prdslib.always,
                                                                              consume_regexp =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Bool",
                                                                              max_fetch_message_size =
                                                                                _js2n__-prdslib.isType
                                                                                    'Integer,
                                                                              min_fetch_message_size =
                                                                                _js2n__-prdslib.isType
                                                                                    'Integer,
                                                                              topics =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Array",
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                  group_options =
                                                                    _js2n__-prdslib.records.record
                                                                        {
                                                                          block_rebalance_on_poll =
                                                                            _js2n__-prdslib.isType
                                                                                '"Bool",
                                                                          group_id =
                                                                            _js2n__-prdslib.isType
                                                                                '"String",
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  producer_options =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {
                                                                              compression_codec =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "none",
                                                                                          "gzip",
                                                                                          "snappy",
                                                                                          "lz4",
                                                                                          "zstd"
                                                                                        ]
                                                                                    ],
                                                                              delivery_timeout =
                                                                                _js2n__-prdslib.isType
                                                                                    'Integer,
                                                                              disable_idempotent =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Bool",
                                                                              max_message_bytes =
                                                                                _js2n__-prdslib.isType
                                                                                    'Integer,
                                                                              request_timeout =
                                                                                _js2n__-prdslib.isType
                                                                                    'Integer,
                                                                              required_acks =
                                                                                _js2n__-prdslib.allOf
                                                                                    [
                                                                                      _js2n__-prdslib.isType
                                                                                        '"String",
                                                                                      _js2n__-prdslib.enum
                                                                                        [
                                                                                          "NoAck",
                                                                                          "LeaderAck",
                                                                                          "AllISRAck"
                                                                                        ]
                                                                                    ],
                                                                              transaction_timeout =
                                                                                _js2n__-prdslib.isType
                                                                                    '"Bool",
                                                                            } {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                } {} true
                                                                _js2n__-prdslib.always,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  prefetch =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                } {} true
                                                                _js2n__-prdslib.always,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  consume_all =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  prefetch =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  reserve_timeout =
                                                                    _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                                                                  tube =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  tube_priority =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                } {} true
                                                                _js2n__-prdslib.always,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  attributes =
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
                                                                                  {}
                                                                                  {}
                                                                                  true
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"Number")
                                                                              ])
                                                                        ],
                                                                  consume_all =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  message_group_id =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  prefetch =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  queue =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  skip_queue_declaration =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  tags =
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
                                                                                  {}
                                                                                  {}
                                                                                  true
                                                                                  (_js2n__-prdslib.isType
                                                                                    '"String")
                                                                              ])
                                                                        ],
                                                                  visibility_timeout =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  wait_time_seconds =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                } {} true
                                                                _js2n__-prdslib.always,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  consume_all =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  delete_after_ack =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  delete_stream_on_stop =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                  deliver_new =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  prefetch =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  "priority" =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  rate_limit =
                                                                    _js2n__-prdslib.isType
                                                                        'Integer,
                                                                  stream =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  subject =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                          _js2n__-prdslib.records.maxProperties
                                                            1,
                                                          _js2n__-prdslib.records.record
                                                            {} {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } true _js2n__-prdslib.always
                                            ],
                                      driver =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "amqp",
                                                        "sqs",
                                                        "beanstalk",
                                                        "boltdb",
                                                        "memory",
                                                        "nats",
                                                        "kafka"
                                                      ]
                                                  ])
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          pool =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/WorkersPool!predicate"
                                ],
                          timeout = _js2n__-prdslib.isType 'Integer,
                        } {} true _js2n__-prdslib.always
                    ],
              kafka = _js2n__-refsenv."_js2n__-:definitions/KAFKA_J!predicate",
              kv =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.minProperties 1,
                      _js2n__-prdslib.records.record {}
                        {
                          "[a-zA-Z0-9_-]*" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "driver" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      config =
                                        _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-refsenv."_js2n__-:definitions/BoltDB!predicate"
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-refsenv."_js2n__-:definitions/Memcached!predicate"
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-refsenv."_js2n__-:definitions/Redis!predicate"
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-refsenv."_js2n__-:definitions/Memory!predicate"
                                                ]
                                            ],
                                      driver = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } true _js2n__-prdslib.always
                    ],
              logs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          channels =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            encoding =
                                              _js2n__-refsenv."_js2n__-:definitions/LogEncoding!predicate",
                                            err_output =
                                              _js2n__-refsenv."_js2n__-:definitions/LogOutput!predicate",
                                            level =
                                              _js2n__-refsenv."_js2n__-:definitions/LogLevel!predicate",
                                            mode =
                                              _js2n__-refsenv."_js2n__-:definitions/LogMode!predicate",
                                            output =
                                              _js2n__-refsenv."_js2n__-:definitions/LogOutput!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ])
                                ],
                          encoding =
                            _js2n__-refsenv."_js2n__-:definitions/LogEncoding!predicate",
                          err_output =
                            _js2n__-refsenv."_js2n__-:definitions/LogOutput!predicate",
                          file_logger_options =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      compress = _js2n__-prdslib.isType '"Bool",
                                      log_output =
                                        _js2n__-prdslib.isType '"String",
                                      max_age = _js2n__-prdslib.isType 'Integer,
                                      max_backups =
                                        _js2n__-prdslib.isType 'Integer,
                                      max_size =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} true _js2n__-prdslib.always
                                ],
                          level =
                            _js2n__-refsenv."_js2n__-:definitions/LogLevel!predicate",
                          mode =
                            _js2n__-refsenv."_js2n__-:definitions/LogMode!predicate",
                          output =
                            _js2n__-refsenv."_js2n__-:definitions/LogOutput!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
              metrics =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          address = _js2n__-prdslib.isType '"String",
                          collect =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "^[a-zA-Z0-9._-]+$" =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  buckets =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"Number")
                                                        ],
                                                  help =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  labels =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.minItems
                                                            1
                                                        ],
                                                  objectives =
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
                                                                  {} {} true
                                                                  (_js2n__-prdslib.isType
                                                                    '"Number")
                                                              ])
                                                        ],
                                                  type =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "histogram",
                                                              "gauge",
                                                              "counter",
                                                              "summary"
                                                            ]
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              nats = _js2n__-refsenv."_js2n__-:definitions/NATS_J!predicate",
              otel =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          client =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum [ "http", "grpc" ],
                                        _js2n__-prdslib.strings.pattern
                                          "^[0-9a-zA-Z_]+$"
                                      ])
                                ],
                          compress = _js2n__-prdslib.isType '"Bool",
                          custom_url = _js2n__-prdslib.isType '"String",
                          endpoint = _js2n__-prdslib.isType '"String",
                          exporter =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "zipkin",
                                            "stdout",
                                            "stderr",
                                            "otlp",
                                            "jaeger",
                                            "jaeger_agent"
                                          ],
                                        _js2n__-prdslib.strings.pattern
                                          "^[0-9a-zA-Z_]+$"
                                      ])
                                ],
                          headers =
                            _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate",
                          insecure = _js2n__-prdslib.isType '"Bool",
                          service_name = _js2n__-prdslib.isType '"String",
                          service_version = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              redis =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-refsenv."_js2n__-:definitions/Redis!predicate"
                    ],
              reload =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          interval =
                            _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                          patterns =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          services =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.minProperties 0,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "^[a-zA-Z0-9._-]+$" =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  dirs =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.strings.minLength
                                                                  1
                                                              ])
                                                        ],
                                                  ignore =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.strings.minLength
                                                                  1
                                                              ])
                                                        ],
                                                  patterns =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.strings.minLength
                                                                  1
                                                              ])
                                                        ],
                                                  recursive =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } false _js2n__-prdslib.never
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              rpc =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          listen =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "^tcp://[0-9a-zA-Z_.-]+:[0-9]{1,5}$"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              server =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "command" ],
                      _js2n__-prdslib.records.record
                        {
                          command = _js2n__-prdslib.isType '"String",
                          env =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record {}
                                          {
                                            "^[a-zA-Z0-9._-]+$" =
                                              _js2n__-prdslib.isType '"String",
                                          } false _js2n__-prdslib.never
                                      ])
                                ],
                          group = _js2n__-prdslib.isType '"String",
                          on_init =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      command =
                                        _js2n__-prdslib.isType '"String",
                                      env =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {}
                                                      {
                                                        "^[a-zA-Z0-9._-]+$" =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } false
                                                      _js2n__-prdslib.never
                                                  ])
                                            ],
                                      exec_timeout =
                                        _js2n__-refsenv."_js2n__-:definitions/Duration!predicate",
                                      user = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          relay = _js2n__-prdslib.isType '"String",
                          user = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              service =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9._-]+$" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/Service!predicate"
                                ],
                        } true _js2n__-prdslib.always
                    ],
              sqs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          endpoint = _js2n__-prdslib.isType '"String",
                          key = _js2n__-prdslib.isType '"String",
                          region = _js2n__-prdslib.isType '"String",
                          secret = _js2n__-prdslib.isType '"String",
                          session_token = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
              status =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record
                        {
                          address = _js2n__-prdslib.isType '"String",
                          unavailable_status_code =
                            _js2n__-prdslib.isType 'Integer,
                        } {} true _js2n__-prdslib.always
                    ],
              tcp =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          pool =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/WorkersPool!predicate"
                                ],
                          servers =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.minProperties 1,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "^[a-zA-Z0-9._-]+$" =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-refsenv."_js2n__-:definitions/TCPServers!predicate"
                                            ],
                                    } true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              temporal =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          activities =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/WorkersPool!predicate"
                                ],
                          address = _js2n__-prdslib.isType '"String",
                          cache_size = _js2n__-prdslib.isType 'Integer,
                          metrics =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              address =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              prefix =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              type =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.isType
                                                        '"String"
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          flush_bytes =
                                            _js2n__-prdslib.isType 'Integer,
                                          flush_interval =
                                            _js2n__-prdslib.isType '"String",
                                          host_port =
                                            _js2n__-prdslib.isType '"String",
                                          prefix =
                                            _js2n__-prdslib.isType '"String",
                                          tag_prefix =
                                            _js2n__-prdslib.isType '"String",
                                          tag_separator =
                                            _js2n__-prdslib.isType '"String",
                                          tags =
                                            _js2n__-refsenv."_js2n__-:definitions/Hashmap!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      driver =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "prometheus", "statsd" ]
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          namespace = _js2n__-prdslib.isType '"String",
                          tls =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      cert = _js2n__-prdslib.isType '"String",
                                      client_auth_type =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "request_client_cert",
                                                  "require_any_client_cert",
                                                  "verify_client_cert_if_given",
                                                  "no_client_certs",
                                                  "require_and_verify_client_cert"
                                                ]
                                            ],
                                      key = _js2n__-prdslib.isType '"String",
                                      root_ca =
                                        _js2n__-prdslib.isType '"String",
                                      server_name =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              version =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "3" ]
                    ],
            } {} true _js2n__-prdslib.always
        ])