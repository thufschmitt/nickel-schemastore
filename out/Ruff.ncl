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
      "_js2n__-:definitions/Alias!predicate" = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/AnalyzeOptions!predicate"
        | doc "Configures Ruff's `analyze` command."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect-string-imports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  direction =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  include-dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  preview =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ApiBan!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "msg" ],
              _js2n__-prdslib.records.record
                { msg = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BannedAliases!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/ConstantType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "bytes", "complex", "float", "int", "str" ]
            ],
      "_js2n__-:definitions/Convention!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "google" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "numpy" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "pep257" ]
                ]
            ],
      "_js2n__-:definitions/Direction!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "Dependencies" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "Dependents" ]
                ]
            ],
      "_js2n__-:definitions/DocstringCodeLineWidth!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.oneOf
                [ _js2n__-refsenv."_js2n__-:definitions/LineWidth!predicate" ],
              _js2n__-prdslib.const "dynamic"
            ],
      "_js2n__-:definitions/Flake8AnnotationsOptions!predicate"
        | doc "Options for the `flake8-annotations` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow-star-arg-any =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore-fully-untyped =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  mypy-init-return =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  suppress-dummy-args =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  suppress-none-returning =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8BanditOptions!predicate"
        | doc "Options for the `flake8-bandit` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed-markup-calls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  check-typed-exception =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  extend-markup-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  hardcoded-tmp-directory =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  hardcoded-tmp-directory-extend =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8BooleanTrapOptions!predicate"
        | doc "Options for the `flake8-boolean-trap` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extend-allowed-calls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8BugbearOptions!predicate"
        | doc "Options for the `flake8-bugbear` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extend-immutable-calls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8BuiltinsOptions!predicate"
        | doc "Options for the `flake8-builtins` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed-modules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  builtins-allowed-modules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  builtins-ignorelist =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  builtins-strict-checking =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignorelist =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  strict-checking =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8ComprehensionsOptions!predicate"
        | doc "Options for the `flake8-comprehensions` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow-dict-calls-with-keyword-arguments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8CopyrightOptions!predicate"
        | doc "Options for the `flake8-copyright` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  author =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  min-file-size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  notice-rgx =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8ErrMsgOptions!predicate"
        | doc "Options for the `flake8-errmsg` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max-string-length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8GetTextOptions!predicate"
        | doc "Options for the `flake8-gettext` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extend-function-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  function-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8ImplicitStrConcatOptions!predicate"
        | doc "Options for the `flake8-implicit-str-concat` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow-multiline =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8ImportConventionsOptions!predicate"
        | doc "Options for the `flake8-import-conventions` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Alias!predicate"
                        ],
                  banned-aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/BannedAliases!predicate"
                        ],
                  banned-from =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  extend-aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Alias!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8PytestStyleOptions!predicate"
        | doc "Options for the `flake8-pytest-style` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fixture-parentheses =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  mark-parentheses =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  parametrize-names-type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ParametrizeNameType!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  parametrize-values-row-type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ParametrizeValuesRowType!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  parametrize-values-type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ParametrizeValuesType!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  raises-extend-require-match-for =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  raises-require-match-for =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  warns-extend-require-match-for =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  warns-require-match-for =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8QuotesOptions!predicate"
        | doc "Options for the `flake8-quotes` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  avoid-escape =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  docstring-quotes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Quote!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  inline-quotes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Quote!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  multiline-quotes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Quote!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8SelfOptions!predicate"
        | doc "Options for the `flake8_self` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extend-ignore-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignore-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8TidyImportsOptions!predicate"
        | doc "Options for the `flake8-tidy-imports` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ban-relative-imports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Strictness!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  banned-api =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ApiBan!predicate"
                        ],
                  banned-module-level-imports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8TypeCheckingOptions!predicate"
        | doc "Options for the `flake8-type-checking` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  exempt-modules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  quote-annotations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  runtime-evaluated-base-classes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  runtime-evaluated-decorators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  strict =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flake8UnusedArgumentsOptions!predicate"
        | doc "Options for the `flake8-unused-arguments` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore-variadic-names =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FormatOptions!predicate"
        | doc "Configures the way Ruff formats your code."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  docstring-code-format =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  docstring-code-line-length =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DocstringCodeLineWidth!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  indent-style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IndentStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  line-ending =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineEnding!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  preview =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  quote-style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/QuoteStyle!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  skip-magic-trailing-comma =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ImportSection!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ImportType!predicate",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/ImportType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "future",
                  "standard-library",
                  "third-party",
                  "first-party",
                  "local-folder"
                ]
            ],
      "_js2n__-:definitions/IndentStyle!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "tab" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "space" ]
                ]
            ],
      "_js2n__-:definitions/IndentWidth!predicate"
        | doc "The size of a tab."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/IsortOptions!predicate"
        | doc "Options for the `isort` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  case-sensitive =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  classes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  combine-as-imports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  constants =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  default-section =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ImportSection!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  detect-same-package =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  extra-standard-library =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  force-single-line =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  force-sort-within-sections =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  force-to-top =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  force-wrap-aliases =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  forced-separate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  from-first =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  known-first-party =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  known-local-folder =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  known-third-party =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  length-sort =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  length-sort-straight =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  lines-after-imports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType 'Null
                        ],
                  lines-between-types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  no-lines-before =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ImportSection!predicate"
                        ],
                  no-sections =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  order-by-type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  relative-imports-order =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RelativeImportsOrder!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  required-imports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NameImports!predicate"
                        ],
                  section-order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ImportSection!predicate"
                        ],
                  sections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  single-line-exclusions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  split-on-trailing-comma =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  variables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LineEnding!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "auto" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "lf" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "cr-lf" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "native" ]
                ]
            ],
      "_js2n__-:definitions/LineLength!predicate"
        | doc m%"
          The length of a line of text that is considered too long.
          
          The allowed range of values is 1..=320
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 320,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/LineWidth!predicate"
        | doc "The maximum visual width to which the formatter should try to limit a line."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/LintOptions!predicate"
        | doc m%"
          Configures how Ruff checks your code.
          
          Options specified in the `lint` section take precedence over the deprecated top-level settings.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed-confusables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.maxLength 1,
                                _js2n__-prdslib.strings.minLength 1
                              ])
                        ],
                  dummy-variable-rgx =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  explicit-preview-rules =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  extend-fixable =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  extend-ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  extend-per-file-ignores =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                              ])
                        ],
                  extend-safe-fixes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  extend-select =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  extend-unfixable =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  extend-unsafe-fixes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  external =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  fixable =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  flake8-annotations =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8AnnotationsOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-bandit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8BanditOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-boolean-trap =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8BooleanTrapOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-bugbear =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8BugbearOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-builtins =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8BuiltinsOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-comprehensions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8ComprehensionsOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-copyright =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8CopyrightOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-errmsg =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8ErrMsgOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-gettext =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8GetTextOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-implicit-str-concat =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8ImplicitStrConcatOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-import-conventions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8ImportConventionsOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-pytest-style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8PytestStyleOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-quotes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8QuotesOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-self =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8SelfOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-tidy-imports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8TidyImportsOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-type-checking =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8TypeCheckingOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  flake8-unused-arguments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Flake8UnusedArgumentsOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  ignore-init-module-imports =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  isort =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/IsortOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  logger-objects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  mccabe =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/McCabeOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pep8-naming =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Pep8NamingOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  per-file-ignores =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                              ])
                        ],
                  preview =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pycodestyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PycodestyleOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pydoclint =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PydoclintOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pydocstyle =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PydocstyleOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pyflakes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PyflakesOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pylint =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PylintOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pyupgrade =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/PyUpgradeOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ruff =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/RuffOptions!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  select =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                  task-tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  typing-modules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  unfixable =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/McCabeOptions!predicate"
        | doc "Options for the `mccabe` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max-complexity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NameImports!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/OutputFormat!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "concise",
                  "full",
                  "json",
                  "json-lines",
                  "junit",
                  "grouped",
                  "github",
                  "gitlab",
                  "pylint",
                  "rdjson",
                  "azure",
                  "sarif"
                ]
            ],
      "_js2n__-:definitions/ParametrizeNameType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "csv", "tuple", "list" ]
            ],
      "_js2n__-:definitions/ParametrizeValuesRowType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "tuple", "list" ]
            ],
      "_js2n__-:definitions/ParametrizeValuesType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "tuple", "list" ]
            ],
      "_js2n__-:definitions/Pep8NamingOptions!predicate"
        | doc "Options for the `pep8-naming` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classmethod-decorators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extend-ignore-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignore-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  staticmethod-decorators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PyUpgradeOptions!predicate"
        | doc "Options for the `pyupgrade` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  keep-runtime-typing =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PycodestyleOptions!predicate"
        | doc "Options for the `pycodestyle` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore-overlong-task-comments =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  max-doc-length =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineLength!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  max-line-length =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/LineLength!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PydoclintOptions!predicate"
        | doc "Options for the `pydoclint` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore-one-line-docstrings =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PydocstyleOptions!predicate"
        | doc "Options for the `pydocstyle` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  convention =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Convention!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore-decorators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignore-var-parameters =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  property-decorators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PyflakesOptions!predicate"
        | doc "Options for the `pyflakes` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed-unused-imports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extend-generics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PylintOptions!predicate"
        | doc "Options for the `pylint` plugin."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow-dunder-method-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  allow-magic-value-types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConstantType!predicate"
                        ],
                  max-args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-bool-expr =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-branches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-locals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-nested-blocks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-positional-args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-public-methods =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-returns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max-statements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PythonVersion!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "py37", "py38", "py39", "py310", "py311", "py312", "py313" ]
            ],
      "_js2n__-:definitions/Quote!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "double" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "single" ]
                ]
            ],
      "_js2n__-:definitions/QuoteStyle!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "single", "double", "preserve" ]
            ],
      "_js2n__-:definitions/RelativeImportsOrder!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "closest-to-furthest" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "furthest-to-closest" ]
                ]
            ],
      "_js2n__-:definitions/RequiredVersion!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/RuffOptions!predicate"
        | doc "Options for the `ruff` plugin"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed-markup-calls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extend-markup-names =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  parenthesize-tuple-in-subscript =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RuleSelector!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "A",
                  "A0",
                  "A00",
                  "A001",
                  "A002",
                  "A003",
                  "A004",
                  "A005",
                  "A006",
                  "AIR",
                  "AIR0",
                  "AIR00",
                  "AIR001",
                  "AIR3",
                  "AIR30",
                  "AIR301",
                  "AIR302",
                  "AIR303",
                  "ALL",
                  "ANN",
                  "ANN0",
                  "ANN00",
                  "ANN001",
                  "ANN002",
                  "ANN003",
                  "ANN2",
                  "ANN20",
                  "ANN201",
                  "ANN202",
                  "ANN204",
                  "ANN205",
                  "ANN206",
                  "ANN4",
                  "ANN40",
                  "ANN401",
                  "ARG",
                  "ARG0",
                  "ARG00",
                  "ARG001",
                  "ARG002",
                  "ARG003",
                  "ARG004",
                  "ARG005",
                  "ASYNC",
                  "ASYNC1",
                  "ASYNC10",
                  "ASYNC100",
                  "ASYNC105",
                  "ASYNC109",
                  "ASYNC11",
                  "ASYNC110",
                  "ASYNC115",
                  "ASYNC116",
                  "ASYNC2",
                  "ASYNC21",
                  "ASYNC210",
                  "ASYNC22",
                  "ASYNC220",
                  "ASYNC221",
                  "ASYNC222",
                  "ASYNC23",
                  "ASYNC230",
                  "ASYNC25",
                  "ASYNC251",
                  "B",
                  "B0",
                  "B00",
                  "B002",
                  "B003",
                  "B004",
                  "B005",
                  "B006",
                  "B007",
                  "B008",
                  "B009",
                  "B01",
                  "B010",
                  "B011",
                  "B012",
                  "B013",
                  "B014",
                  "B015",
                  "B016",
                  "B017",
                  "B018",
                  "B019",
                  "B02",
                  "B020",
                  "B021",
                  "B022",
                  "B023",
                  "B024",
                  "B025",
                  "B026",
                  "B027",
                  "B028",
                  "B029",
                  "B03",
                  "B030",
                  "B031",
                  "B032",
                  "B033",
                  "B034",
                  "B035",
                  "B039",
                  "B9",
                  "B90",
                  "B901",
                  "B903",
                  "B904",
                  "B905",
                  "B909",
                  "B91",
                  "B911",
                  "BLE",
                  "BLE0",
                  "BLE00",
                  "BLE001",
                  "C",
                  "C4",
                  "C40",
                  "C400",
                  "C401",
                  "C402",
                  "C403",
                  "C404",
                  "C405",
                  "C406",
                  "C408",
                  "C409",
                  "C41",
                  "C410",
                  "C411",
                  "C413",
                  "C414",
                  "C415",
                  "C416",
                  "C417",
                  "C418",
                  "C419",
                  "C42",
                  "C420",
                  "C9",
                  "C90",
                  "C901",
                  "COM",
                  "COM8",
                  "COM81",
                  "COM812",
                  "COM818",
                  "COM819",
                  "CPY",
                  "CPY0",
                  "CPY00",
                  "CPY001",
                  "D",
                  "D1",
                  "D10",
                  "D100",
                  "D101",
                  "D102",
                  "D103",
                  "D104",
                  "D105",
                  "D106",
                  "D107",
                  "D2",
                  "D20",
                  "D200",
                  "D201",
                  "D202",
                  "D203",
                  "D204",
                  "D205",
                  "D206",
                  "D207",
                  "D208",
                  "D209",
                  "D21",
                  "D210",
                  "D211",
                  "D212",
                  "D213",
                  "D214",
                  "D215",
                  "D3",
                  "D30",
                  "D300",
                  "D301",
                  "D4",
                  "D40",
                  "D400",
                  "D401",
                  "D402",
                  "D403",
                  "D404",
                  "D405",
                  "D406",
                  "D407",
                  "D408",
                  "D409",
                  "D41",
                  "D410",
                  "D411",
                  "D412",
                  "D413",
                  "D414",
                  "D415",
                  "D416",
                  "D417",
                  "D418",
                  "D419",
                  "DJ",
                  "DJ0",
                  "DJ00",
                  "DJ001",
                  "DJ003",
                  "DJ006",
                  "DJ007",
                  "DJ008",
                  "DJ01",
                  "DJ012",
                  "DJ013",
                  "DOC",
                  "DOC2",
                  "DOC20",
                  "DOC201",
                  "DOC202",
                  "DOC4",
                  "DOC40",
                  "DOC402",
                  "DOC403",
                  "DOC5",
                  "DOC50",
                  "DOC501",
                  "DOC502",
                  "DTZ",
                  "DTZ0",
                  "DTZ00",
                  "DTZ001",
                  "DTZ002",
                  "DTZ003",
                  "DTZ004",
                  "DTZ005",
                  "DTZ006",
                  "DTZ007",
                  "DTZ01",
                  "DTZ011",
                  "DTZ012",
                  "DTZ9",
                  "DTZ90",
                  "DTZ901",
                  "E",
                  "E1",
                  "E10",
                  "E101",
                  "E11",
                  "E111",
                  "E112",
                  "E113",
                  "E114",
                  "E115",
                  "E116",
                  "E117",
                  "E2",
                  "E20",
                  "E201",
                  "E202",
                  "E203",
                  "E204",
                  "E21",
                  "E211",
                  "E22",
                  "E221",
                  "E222",
                  "E223",
                  "E224",
                  "E225",
                  "E226",
                  "E227",
                  "E228",
                  "E23",
                  "E231",
                  "E24",
                  "E241",
                  "E242",
                  "E25",
                  "E251",
                  "E252",
                  "E26",
                  "E261",
                  "E262",
                  "E265",
                  "E266",
                  "E27",
                  "E271",
                  "E272",
                  "E273",
                  "E274",
                  "E275",
                  "E3",
                  "E30",
                  "E301",
                  "E302",
                  "E303",
                  "E304",
                  "E305",
                  "E306",
                  "E4",
                  "E40",
                  "E401",
                  "E402",
                  "E5",
                  "E50",
                  "E501",
                  "E502",
                  "E7",
                  "E70",
                  "E701",
                  "E702",
                  "E703",
                  "E71",
                  "E711",
                  "E712",
                  "E713",
                  "E714",
                  "E72",
                  "E721",
                  "E722",
                  "E73",
                  "E731",
                  "E74",
                  "E741",
                  "E742",
                  "E743",
                  "E9",
                  "E90",
                  "E902",
                  "EM",
                  "EM1",
                  "EM10",
                  "EM101",
                  "EM102",
                  "EM103",
                  "ERA",
                  "ERA0",
                  "ERA00",
                  "ERA001",
                  "EXE",
                  "EXE0",
                  "EXE00",
                  "EXE001",
                  "EXE002",
                  "EXE003",
                  "EXE004",
                  "EXE005",
                  "F",
                  "F4",
                  "F40",
                  "F401",
                  "F402",
                  "F403",
                  "F404",
                  "F405",
                  "F406",
                  "F407",
                  "F5",
                  "F50",
                  "F501",
                  "F502",
                  "F503",
                  "F504",
                  "F505",
                  "F506",
                  "F507",
                  "F508",
                  "F509",
                  "F52",
                  "F521",
                  "F522",
                  "F523",
                  "F524",
                  "F525",
                  "F54",
                  "F541",
                  "F6",
                  "F60",
                  "F601",
                  "F602",
                  "F62",
                  "F621",
                  "F622",
                  "F63",
                  "F631",
                  "F632",
                  "F633",
                  "F634",
                  "F7",
                  "F70",
                  "F701",
                  "F702",
                  "F704",
                  "F706",
                  "F707",
                  "F72",
                  "F722",
                  "F8",
                  "F81",
                  "F811",
                  "F82",
                  "F821",
                  "F822",
                  "F823",
                  "F84",
                  "F841",
                  "F842",
                  "F9",
                  "F90",
                  "F901",
                  "FA",
                  "FA1",
                  "FA10",
                  "FA100",
                  "FA102",
                  "FAST",
                  "FAST0",
                  "FAST00",
                  "FAST001",
                  "FAST002",
                  "FAST003",
                  "FBT",
                  "FBT0",
                  "FBT00",
                  "FBT001",
                  "FBT002",
                  "FBT003",
                  "FIX",
                  "FIX0",
                  "FIX00",
                  "FIX001",
                  "FIX002",
                  "FIX003",
                  "FIX004",
                  "FLY",
                  "FLY0",
                  "FLY00",
                  "FLY002",
                  "FURB",
                  "FURB1",
                  "FURB10",
                  "FURB101",
                  "FURB103",
                  "FURB105",
                  "FURB11",
                  "FURB110",
                  "FURB113",
                  "FURB116",
                  "FURB118",
                  "FURB12",
                  "FURB122",
                  "FURB129",
                  "FURB13",
                  "FURB131",
                  "FURB132",
                  "FURB136",
                  "FURB14",
                  "FURB140",
                  "FURB142",
                  "FURB145",
                  "FURB148",
                  "FURB15",
                  "FURB152",
                  "FURB154",
                  "FURB156",
                  "FURB157",
                  "FURB16",
                  "FURB161",
                  "FURB162",
                  "FURB163",
                  "FURB164",
                  "FURB166",
                  "FURB167",
                  "FURB168",
                  "FURB169",
                  "FURB17",
                  "FURB171",
                  "FURB177",
                  "FURB18",
                  "FURB180",
                  "FURB181",
                  "FURB187",
                  "FURB188",
                  "FURB189",
                  "FURB19",
                  "FURB192",
                  "G",
                  "G0",
                  "G00",
                  "G001",
                  "G002",
                  "G003",
                  "G004",
                  "G01",
                  "G010",
                  "G1",
                  "G10",
                  "G101",
                  "G2",
                  "G20",
                  "G201",
                  "G202",
                  "I",
                  "I0",
                  "I00",
                  "I001",
                  "I002",
                  "ICN",
                  "ICN0",
                  "ICN00",
                  "ICN001",
                  "ICN002",
                  "ICN003",
                  "INP",
                  "INP0",
                  "INP00",
                  "INP001",
                  "INT",
                  "INT0",
                  "INT00",
                  "INT001",
                  "INT002",
                  "INT003",
                  "ISC",
                  "ISC0",
                  "ISC00",
                  "ISC001",
                  "ISC002",
                  "ISC003",
                  "LOG",
                  "LOG0",
                  "LOG00",
                  "LOG001",
                  "LOG002",
                  "LOG004",
                  "LOG007",
                  "LOG009",
                  "LOG01",
                  "LOG014",
                  "LOG015",
                  "N",
                  "N8",
                  "N80",
                  "N801",
                  "N802",
                  "N803",
                  "N804",
                  "N805",
                  "N806",
                  "N807",
                  "N81",
                  "N811",
                  "N812",
                  "N813",
                  "N814",
                  "N815",
                  "N816",
                  "N817",
                  "N818",
                  "N9",
                  "N99",
                  "N999",
                  "NPY",
                  "NPY0",
                  "NPY00",
                  "NPY001",
                  "NPY002",
                  "NPY003",
                  "NPY2",
                  "NPY20",
                  "NPY201",
                  "PD",
                  "PD0",
                  "PD00",
                  "PD002",
                  "PD003",
                  "PD004",
                  "PD007",
                  "PD008",
                  "PD009",
                  "PD01",
                  "PD010",
                  "PD011",
                  "PD012",
                  "PD013",
                  "PD015",
                  "PD1",
                  "PD10",
                  "PD101",
                  "PD9",
                  "PD90",
                  "PD901",
                  "PERF",
                  "PERF1",
                  "PERF10",
                  "PERF101",
                  "PERF102",
                  "PERF2",
                  "PERF20",
                  "PERF203",
                  "PERF4",
                  "PERF40",
                  "PERF401",
                  "PERF402",
                  "PERF403",
                  "PGH",
                  "PGH0",
                  "PGH00",
                  "PGH003",
                  "PGH004",
                  "PGH005",
                  "PIE",
                  "PIE7",
                  "PIE79",
                  "PIE790",
                  "PIE794",
                  "PIE796",
                  "PIE8",
                  "PIE80",
                  "PIE800",
                  "PIE804",
                  "PIE807",
                  "PIE808",
                  "PIE81",
                  "PIE810",
                  "PL",
                  "PLC",
                  "PLC0",
                  "PLC01",
                  "PLC010",
                  "PLC0105",
                  "PLC013",
                  "PLC0131",
                  "PLC0132",
                  "PLC02",
                  "PLC020",
                  "PLC0205",
                  "PLC0206",
                  "PLC0208",
                  "PLC04",
                  "PLC041",
                  "PLC0414",
                  "PLC0415",
                  "PLC1",
                  "PLC18",
                  "PLC180",
                  "PLC1802",
                  "PLC19",
                  "PLC190",
                  "PLC1901",
                  "PLC2",
                  "PLC24",
                  "PLC240",
                  "PLC2401",
                  "PLC2403",
                  "PLC27",
                  "PLC270",
                  "PLC2701",
                  "PLC28",
                  "PLC280",
                  "PLC2801",
                  "PLC3",
                  "PLC30",
                  "PLC300",
                  "PLC3002",
                  "PLE",
                  "PLE0",
                  "PLE01",
                  "PLE010",
                  "PLE0100",
                  "PLE0101",
                  "PLE011",
                  "PLE0115",
                  "PLE0116",
                  "PLE0117",
                  "PLE0118",
                  "PLE02",
                  "PLE023",
                  "PLE0237",
                  "PLE024",
                  "PLE0241",
                  "PLE03",
                  "PLE030",
                  "PLE0302",
                  "PLE0303",
                  "PLE0304",
                  "PLE0305",
                  "PLE0307",
                  "PLE0308",
                  "PLE0309",
                  "PLE06",
                  "PLE060",
                  "PLE0604",
                  "PLE0605",
                  "PLE064",
                  "PLE0643",
                  "PLE07",
                  "PLE070",
                  "PLE0704",
                  "PLE1",
                  "PLE11",
                  "PLE113",
                  "PLE1132",
                  "PLE114",
                  "PLE1141",
                  "PLE1142",
                  "PLE12",
                  "PLE120",
                  "PLE1205",
                  "PLE1206",
                  "PLE13",
                  "PLE130",
                  "PLE1300",
                  "PLE1307",
                  "PLE131",
                  "PLE1310",
                  "PLE15",
                  "PLE150",
                  "PLE1507",
                  "PLE151",
                  "PLE1519",
                  "PLE152",
                  "PLE1520",
                  "PLE17",
                  "PLE170",
                  "PLE1700",
                  "PLE2",
                  "PLE25",
                  "PLE250",
                  "PLE2502",
                  "PLE251",
                  "PLE2510",
                  "PLE2512",
                  "PLE2513",
                  "PLE2514",
                  "PLE2515",
                  "PLE4",
                  "PLE47",
                  "PLE470",
                  "PLE4703",
                  "PLR",
                  "PLR0",
                  "PLR01",
                  "PLR012",
                  "PLR0124",
                  "PLR013",
                  "PLR0133",
                  "PLR02",
                  "PLR020",
                  "PLR0202",
                  "PLR0203",
                  "PLR0206",
                  "PLR04",
                  "PLR040",
                  "PLR0402",
                  "PLR09",
                  "PLR090",
                  "PLR0904",
                  "PLR091",
                  "PLR0911",
                  "PLR0912",
                  "PLR0913",
                  "PLR0914",
                  "PLR0915",
                  "PLR0916",
                  "PLR0917",
                  "PLR1",
                  "PLR17",
                  "PLR170",
                  "PLR1702",
                  "PLR1704",
                  "PLR171",
                  "PLR1711",
                  "PLR1714",
                  "PLR1716",
                  "PLR172",
                  "PLR1722",
                  "PLR173",
                  "PLR1730",
                  "PLR1733",
                  "PLR1736",
                  "PLR2",
                  "PLR20",
                  "PLR200",
                  "PLR2004",
                  "PLR204",
                  "PLR2044",
                  "PLR5",
                  "PLR55",
                  "PLR550",
                  "PLR5501",
                  "PLR6",
                  "PLR61",
                  "PLR610",
                  "PLR6104",
                  "PLR62",
                  "PLR620",
                  "PLR6201",
                  "PLR63",
                  "PLR630",
                  "PLR6301",
                  "PLW",
                  "PLW0",
                  "PLW01",
                  "PLW010",
                  "PLW0108",
                  "PLW012",
                  "PLW0120",
                  "PLW0127",
                  "PLW0128",
                  "PLW0129",
                  "PLW013",
                  "PLW0131",
                  "PLW0133",
                  "PLW017",
                  "PLW0177",
                  "PLW02",
                  "PLW021",
                  "PLW0211",
                  "PLW024",
                  "PLW0244",
                  "PLW0245",
                  "PLW04",
                  "PLW040",
                  "PLW0406",
                  "PLW06",
                  "PLW060",
                  "PLW0602",
                  "PLW0603",
                  "PLW0604",
                  "PLW064",
                  "PLW0642",
                  "PLW07",
                  "PLW071",
                  "PLW0711",
                  "PLW1",
                  "PLW15",
                  "PLW150",
                  "PLW1501",
                  "PLW1507",
                  "PLW1508",
                  "PLW1509",
                  "PLW151",
                  "PLW1510",
                  "PLW1514",
                  "PLW16",
                  "PLW164",
                  "PLW1641",
                  "PLW2",
                  "PLW21",
                  "PLW210",
                  "PLW2101",
                  "PLW29",
                  "PLW290",
                  "PLW2901",
                  "PLW3",
                  "PLW32",
                  "PLW320",
                  "PLW3201",
                  "PLW33",
                  "PLW330",
                  "PLW3301",
                  "PT",
                  "PT0",
                  "PT00",
                  "PT001",
                  "PT002",
                  "PT003",
                  "PT006",
                  "PT007",
                  "PT008",
                  "PT009",
                  "PT01",
                  "PT010",
                  "PT011",
                  "PT012",
                  "PT013",
                  "PT014",
                  "PT015",
                  "PT016",
                  "PT017",
                  "PT018",
                  "PT019",
                  "PT02",
                  "PT020",
                  "PT021",
                  "PT022",
                  "PT023",
                  "PT024",
                  "PT025",
                  "PT026",
                  "PT027",
                  "PT028",
                  "PT029",
                  "PT03",
                  "PT030",
                  "PT031",
                  "PTH",
                  "PTH1",
                  "PTH10",
                  "PTH100",
                  "PTH101",
                  "PTH102",
                  "PTH103",
                  "PTH104",
                  "PTH105",
                  "PTH106",
                  "PTH107",
                  "PTH108",
                  "PTH109",
                  "PTH11",
                  "PTH110",
                  "PTH111",
                  "PTH112",
                  "PTH113",
                  "PTH114",
                  "PTH115",
                  "PTH116",
                  "PTH117",
                  "PTH118",
                  "PTH119",
                  "PTH12",
                  "PTH120",
                  "PTH121",
                  "PTH122",
                  "PTH123",
                  "PTH124",
                  "PTH2",
                  "PTH20",
                  "PTH201",
                  "PTH202",
                  "PTH203",
                  "PTH204",
                  "PTH205",
                  "PTH206",
                  "PTH207",
                  "PTH208",
                  "PTH21",
                  "PTH210",
                  "PYI",
                  "PYI0",
                  "PYI00",
                  "PYI001",
                  "PYI002",
                  "PYI003",
                  "PYI004",
                  "PYI005",
                  "PYI006",
                  "PYI007",
                  "PYI008",
                  "PYI009",
                  "PYI01",
                  "PYI010",
                  "PYI011",
                  "PYI012",
                  "PYI013",
                  "PYI014",
                  "PYI015",
                  "PYI016",
                  "PYI017",
                  "PYI018",
                  "PYI019",
                  "PYI02",
                  "PYI020",
                  "PYI021",
                  "PYI024",
                  "PYI025",
                  "PYI026",
                  "PYI029",
                  "PYI03",
                  "PYI030",
                  "PYI032",
                  "PYI033",
                  "PYI034",
                  "PYI035",
                  "PYI036",
                  "PYI04",
                  "PYI041",
                  "PYI042",
                  "PYI043",
                  "PYI044",
                  "PYI045",
                  "PYI046",
                  "PYI047",
                  "PYI048",
                  "PYI049",
                  "PYI05",
                  "PYI050",
                  "PYI051",
                  "PYI052",
                  "PYI053",
                  "PYI054",
                  "PYI055",
                  "PYI056",
                  "PYI057",
                  "PYI058",
                  "PYI059",
                  "PYI06",
                  "PYI061",
                  "PYI062",
                  "PYI063",
                  "PYI064",
                  "PYI066",
                  "Q",
                  "Q0",
                  "Q00",
                  "Q000",
                  "Q001",
                  "Q002",
                  "Q003",
                  "Q004",
                  "RET",
                  "RET5",
                  "RET50",
                  "RET501",
                  "RET502",
                  "RET503",
                  "RET504",
                  "RET505",
                  "RET506",
                  "RET507",
                  "RET508",
                  "RSE",
                  "RSE1",
                  "RSE10",
                  "RSE102",
                  "RUF",
                  "RUF0",
                  "RUF00",
                  "RUF001",
                  "RUF002",
                  "RUF003",
                  "RUF005",
                  "RUF006",
                  "RUF007",
                  "RUF008",
                  "RUF009",
                  "RUF01",
                  "RUF010",
                  "RUF012",
                  "RUF013",
                  "RUF015",
                  "RUF016",
                  "RUF017",
                  "RUF018",
                  "RUF019",
                  "RUF02",
                  "RUF020",
                  "RUF021",
                  "RUF022",
                  "RUF023",
                  "RUF024",
                  "RUF026",
                  "RUF027",
                  "RUF028",
                  "RUF029",
                  "RUF03",
                  "RUF030",
                  "RUF031",
                  "RUF032",
                  "RUF033",
                  "RUF034",
                  "RUF036",
                  "RUF037",
                  "RUF038",
                  "RUF039",
                  "RUF04",
                  "RUF040",
                  "RUF041",
                  "RUF043",
                  "RUF045",
                  "RUF046",
                  "RUF047",
                  "RUF048",
                  "RUF049",
                  "RUF05",
                  "RUF051",
                  "RUF052",
                  "RUF053",
                  "RUF054",
                  "RUF055",
                  "RUF056",
                  "RUF057",
                  "RUF058",
                  "RUF059",
                  "RUF1",
                  "RUF10",
                  "RUF100",
                  "RUF101",
                  "RUF2",
                  "RUF20",
                  "RUF200",
                  "S",
                  "S1",
                  "S10",
                  "S101",
                  "S102",
                  "S103",
                  "S104",
                  "S105",
                  "S106",
                  "S107",
                  "S108",
                  "S11",
                  "S110",
                  "S112",
                  "S113",
                  "S2",
                  "S20",
                  "S201",
                  "S202",
                  "S3",
                  "S30",
                  "S301",
                  "S302",
                  "S303",
                  "S304",
                  "S305",
                  "S306",
                  "S307",
                  "S308",
                  "S31",
                  "S310",
                  "S311",
                  "S312",
                  "S313",
                  "S314",
                  "S315",
                  "S316",
                  "S317",
                  "S318",
                  "S319",
                  "S32",
                  "S320",
                  "S321",
                  "S323",
                  "S324",
                  "S4",
                  "S40",
                  "S401",
                  "S402",
                  "S403",
                  "S404",
                  "S405",
                  "S406",
                  "S407",
                  "S408",
                  "S409",
                  "S41",
                  "S411",
                  "S412",
                  "S413",
                  "S415",
                  "S5",
                  "S50",
                  "S501",
                  "S502",
                  "S503",
                  "S504",
                  "S505",
                  "S506",
                  "S507",
                  "S508",
                  "S509",
                  "S6",
                  "S60",
                  "S601",
                  "S602",
                  "S603",
                  "S604",
                  "S605",
                  "S606",
                  "S607",
                  "S608",
                  "S609",
                  "S61",
                  "S610",
                  "S611",
                  "S612",
                  "S7",
                  "S70",
                  "S701",
                  "S702",
                  "S704",
                  "SIM",
                  "SIM1",
                  "SIM10",
                  "SIM101",
                  "SIM102",
                  "SIM103",
                  "SIM105",
                  "SIM107",
                  "SIM108",
                  "SIM109",
                  "SIM11",
                  "SIM110",
                  "SIM112",
                  "SIM113",
                  "SIM114",
                  "SIM115",
                  "SIM116",
                  "SIM117",
                  "SIM118",
                  "SIM2",
                  "SIM20",
                  "SIM201",
                  "SIM202",
                  "SIM208",
                  "SIM21",
                  "SIM210",
                  "SIM211",
                  "SIM212",
                  "SIM22",
                  "SIM220",
                  "SIM221",
                  "SIM222",
                  "SIM223",
                  "SIM3",
                  "SIM30",
                  "SIM300",
                  "SIM4",
                  "SIM40",
                  "SIM401",
                  "SIM9",
                  "SIM90",
                  "SIM905",
                  "SIM91",
                  "SIM910",
                  "SIM911",
                  "SLF",
                  "SLF0",
                  "SLF00",
                  "SLF001",
                  "SLOT",
                  "SLOT0",
                  "SLOT00",
                  "SLOT000",
                  "SLOT001",
                  "SLOT002",
                  "T",
                  "T1",
                  "T10",
                  "T100",
                  "T2",
                  "T20",
                  "T201",
                  "T203",
                  "TC",
                  "TC0",
                  "TC00",
                  "TC001",
                  "TC002",
                  "TC003",
                  "TC004",
                  "TC005",
                  "TC006",
                  "TC007",
                  "TC008",
                  "TC01",
                  "TC010",
                  "TD",
                  "TD0",
                  "TD00",
                  "TD001",
                  "TD002",
                  "TD003",
                  "TD004",
                  "TD005",
                  "TD006",
                  "TD007",
                  "TID",
                  "TID2",
                  "TID25",
                  "TID251",
                  "TID252",
                  "TID253",
                  "TRY",
                  "TRY0",
                  "TRY00",
                  "TRY002",
                  "TRY003",
                  "TRY004",
                  "TRY2",
                  "TRY20",
                  "TRY201",
                  "TRY203",
                  "TRY3",
                  "TRY30",
                  "TRY300",
                  "TRY301",
                  "TRY4",
                  "TRY40",
                  "TRY400",
                  "TRY401",
                  "UP",
                  "UP0",
                  "UP00",
                  "UP001",
                  "UP003",
                  "UP004",
                  "UP005",
                  "UP006",
                  "UP007",
                  "UP008",
                  "UP009",
                  "UP01",
                  "UP010",
                  "UP011",
                  "UP012",
                  "UP013",
                  "UP014",
                  "UP015",
                  "UP017",
                  "UP018",
                  "UP019",
                  "UP02",
                  "UP020",
                  "UP021",
                  "UP022",
                  "UP023",
                  "UP024",
                  "UP025",
                  "UP026",
                  "UP028",
                  "UP029",
                  "UP03",
                  "UP030",
                  "UP031",
                  "UP032",
                  "UP033",
                  "UP034",
                  "UP035",
                  "UP036",
                  "UP037",
                  "UP038",
                  "UP039",
                  "UP04",
                  "UP040",
                  "UP041",
                  "UP042",
                  "UP043",
                  "UP044",
                  "UP045",
                  "UP046",
                  "UP047",
                  "UP049",
                  "W",
                  "W1",
                  "W19",
                  "W191",
                  "W2",
                  "W29",
                  "W291",
                  "W292",
                  "W293",
                  "W3",
                  "W39",
                  "W391",
                  "W5",
                  "W50",
                  "W505",
                  "W6",
                  "W60",
                  "W605",
                  "YTT",
                  "YTT1",
                  "YTT10",
                  "YTT101",
                  "YTT102",
                  "YTT103",
                  "YTT2",
                  "YTT20",
                  "YTT201",
                  "YTT202",
                  "YTT203",
                  "YTT204",
                  "YTT3",
                  "YTT30",
                  "YTT301",
                  "YTT302",
                  "YTT303"
                ]
            ],
      "_js2n__-:definitions/Strictness!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "parents" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "all" ]
                ]
            ],
    }
    in
  {
      allowed-confusables
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.maxLength 1,
                    _js2n__-prdslib.strings.minLength 1
                  ])
            ])
        | doc "A list of allowed \"confusable\" Unicode characters to ignore when enforcing `RUF001`, `RUF002`, and `RUF003`."
        | optional,
      analyze
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/AnalyzeOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options to configure import map generation."
        | optional,
      builtins
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "A list of builtins to treat as defined references, in addition to the system builtins."
        | optional,
      cache-dir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          A path to the cache directory.
          
          By default, Ruff stores cache results in a `.ruff_cache` directory in the current project root.
          
          However, Ruff will also respect the `RUFF_CACHE_DIR` environment variable, which takes precedence over that default.
          
          This setting will override even the `RUFF_CACHE_DIR` environment variable, if set.
        "%
        | optional,
      dummy-variable-rgx
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc "A regular expression used to identify \"dummy\" variables, or those which should be ignored when enforcing (e.g.) unused-variable rules. The default expression matches `_`, `__`, and `_var`, but not `_var_`."
        | optional,
      exclude
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of file patterns to exclude from formatting and linting.
          
          Exclusions are based on globs, and can be either:
          
          - Single-path patterns, like `.mypy_cache` (to exclude any directory named `.mypy_cache` in the tree), `foo.py` (to exclude any file named `foo.py`), or `foo_*.py` (to exclude any file matching `foo_*.py` ). - Relative patterns, like `directory/foo.py` (to exclude that specific file) or `directory/*.py` (to exclude any Python files in `directory`). Note that these paths are relative to the project root (e.g., the directory containing your `pyproject.toml`).
          
          For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
          
          Note that you'll typically want to use [`extend-exclude`](#extend-exclude) to modify the excluded paths.
        "%
        | optional,
      explicit-preview-rules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Whether to require exact codes to select preview rules. When enabled, preview rules will not be selected by prefixes — the full code of each preview rule will be required to enable the rule."
        | optional,
      extend
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          A path to a local `pyproject.toml` file to merge into this configuration. User home directory and environment variables will be expanded.
          
          To resolve the current `pyproject.toml` file, Ruff will first resolve this base configuration file, then merge in any properties defined in the current configuration file.
        "%
        | optional,
      extend-exclude
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of file patterns to omit from formatting and linting, in addition to those specified by [`exclude`](#exclude).
          
          Exclusions are based on globs, and can be either:
          
          - Single-path patterns, like `.mypy_cache` (to exclude any directory named `.mypy_cache` in the tree), `foo.py` (to exclude any file named `foo.py`), or `foo_*.py` (to exclude any file matching `foo_*.py` ). - Relative patterns, like `directory/foo.py` (to exclude that specific file) or `directory/*.py` (to exclude any Python files in `directory`). Note that these paths are relative to the project root (e.g., the directory containing your `pyproject.toml`).
          
          For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
        "%
        | optional,
      extend-fixable
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes to consider fixable, in addition to those specified by [`fixable`](#lint_fixable)."
        | optional,
      extend-ignore
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes to ignore, in addition to those specified by `ignore`."
        | optional,
      extend-include
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of file patterns to include when linting, in addition to those specified by [`include`](#include).
          
          Inclusion are based on globs, and should be single-path patterns, like `*.pyw`, to include any file with the `.pyw` extension.
          
          For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
        "%
        | optional,
      extend-per-file-ignores
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                  ])
            ])
        | doc "A list of mappings from file pattern to rule codes or prefixes to exclude, in addition to any rules excluded by [`per-file-ignores`](#lint_per-file-ignores)."
        | optional,
      extend-safe-fixes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes for which unsafe fixes should be considered safe."
        | optional,
      extend-select
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes to enable, in addition to those specified by [`select`](#lint_select)."
        | optional,
      extend-unfixable
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes to consider non-auto-fixable, in addition to those specified by [`unfixable`](#lint_unfixable)."
        | optional,
      extend-unsafe-fixes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes for which safe fixes should be considered unsafe."
        | optional,
      external
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "A list of rule codes or prefixes that are unsupported by Ruff, but should be preserved when (e.g.) validating `# noqa` directives. Useful for retaining `# noqa` directives that cover plugins not yet implemented by Ruff."
        | optional,
      fix
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Enable fix behavior by-default when running `ruff` (overridden by the `--fix` and `--no-fix` command-line flags). Only includes automatic fixes unless `--unsafe-fixes` is provided."
        | optional,
      fix-only
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Like [`fix`](#fix), but disables reporting on leftover violation. Implies [`fix`](#fix)."
        | optional,
      fixable
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes to consider fixable. By default, all rules are considered fixable."
        | optional,
      flake8-annotations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8AnnotationsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-annotations` plugin."
        | optional,
      flake8-bandit
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8BanditOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-bandit` plugin."
        | optional,
      flake8-boolean-trap
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8BooleanTrapOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-boolean-trap` plugin."
        | optional,
      flake8-bugbear
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8BugbearOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-bugbear` plugin."
        | optional,
      flake8-builtins
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8BuiltinsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-builtins` plugin."
        | optional,
      flake8-comprehensions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8ComprehensionsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-comprehensions` plugin."
        | optional,
      flake8-copyright
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8CopyrightOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-copyright` plugin."
        | optional,
      flake8-errmsg
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8ErrMsgOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-errmsg` plugin."
        | optional,
      flake8-gettext
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8GetTextOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-gettext` plugin."
        | optional,
      flake8-implicit-str-concat
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8ImplicitStrConcatOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-implicit-str-concat` plugin."
        | optional,
      flake8-import-conventions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8ImportConventionsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-import-conventions` plugin."
        | optional,
      flake8-pytest-style
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8PytestStyleOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-pytest-style` plugin."
        | optional,
      flake8-quotes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8QuotesOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-quotes` plugin."
        | optional,
      flake8-self
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8SelfOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8_self` plugin."
        | optional,
      flake8-tidy-imports
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8TidyImportsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-tidy-imports` plugin."
        | optional,
      flake8-type-checking
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8TypeCheckingOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-type-checking` plugin."
        | optional,
      flake8-unused-arguments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Flake8UnusedArgumentsOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `flake8-unused-arguments` plugin."
        | optional,
      force-exclude
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Whether to enforce [`exclude`](#exclude) and [`extend-exclude`](#extend-exclude) patterns, even for paths that are passed to Ruff explicitly. Typically, Ruff will lint any paths passed in directly, even if they would typically be excluded. Setting `force-exclude = true` will cause Ruff to respect these exclusions unequivocally.
          
          This is useful for [`pre-commit`](https://pre-commit.com/), which explicitly passes all changed files to the [`ruff-pre-commit`](https://github.com/astral-sh/ruff-pre-commit) plugin, regardless of whether they're marked as excluded by Ruff's own settings.
        "%
        | optional,
      format
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/FormatOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options to configure code formatting."
        | optional,
      ignore
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc m%"
          A list of rule codes or prefixes to ignore. Prefixes can specify exact rules (like `F841`), entire categories (like `F`), or anything in between.
          
          When breaking ties between enabled and disabled rules (via `select` and `ignore`, respectively), more specific prefixes override less specific prefixes. `ignore` takes precedence over `select` if the same prefix appears in both.
        "%
        | optional,
      ignore-init-module-imports
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc m%"
          Avoid automatically removing unused imports in `__init__.py` files. Such imports will still be flagged, but with a dedicated message suggesting that the import is either added to the module's `__all__` symbol, or re-exported with a redundant alias (e.g., `import os as os`).
          
          This option is enabled by default, but you can opt-in to removal of imports via an unsafe fix.
        "%
        | optional,
      include
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of file patterns to include when linting.
          
          Inclusion are based on globs, and should be single-path patterns, like `*.pyw`, to include any file with the `.pyw` extension. `pyproject.toml` is included here not for configuration but because we lint whether e.g. the `[project]` matches the schema.
          
          Notebook files (`.ipynb` extension) are included by default on Ruff 0.6.0+.
          
          For more information on the glob syntax, refer to the [`globset` documentation](https://docs.rs/globset/latest/globset/#syntax).
        "%
        | optional,
      indent-width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/IndentWidth!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          The number of spaces per indentation level (tab).
          
          Used by the formatter and when enforcing long-line violations (like `E501`) to determine the visual width of a tab.
          
          This option changes the number of spaces the formatter inserts when using soft-tabs (`indent-style = space`).
          
          PEP 8 recommends using 4 spaces per [indentation level](https://peps.python.org/pep-0008/#indentation).
        "%
        | optional,
      isort
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/IsortOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `isort` plugin."
        | optional,
      line-length
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LineLength!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          The line length to use when enforcing long-lines violations (like `E501`) and at which `isort` and the formatter prefers to wrap lines.
          
          The length is determined by the number of characters per line, except for lines containing East Asian characters or emojis. For these lines, the [unicode width](https://unicode.org/reports/tr11/) of each character is added up to determine the length.
          
          The value must be greater than `0` and less than or equal to `320`.
          
          Note: While the formatter will attempt to format lines such that they remain within the `line-length`, it isn't a hard upper bound, and formatted lines may exceed the `line-length`.
          
          See [`pycodestyle.max-line-length`](#lint_pycodestyle_max-line-length) to configure different lengths for `E501` and the formatter.
        "%
        | optional,
      lint
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/LintOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | optional,
      logger-objects
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of objects that should be treated equivalently to a `logging.Logger` object.
          
          This is useful for ensuring proper diagnostics (e.g., to identify `logging` deprecations and other best-practices) for projects that re-export a `logging.Logger` object from a common module.
          
          For example, if you have a module `logging_setup.py` with the following contents: ```python import logging
          
          logger = logging.getLogger(__name__) ```
          
          Adding `"logging_setup.logger"` to `logger-objects` will ensure that `logging_setup.logger` is treated as a `logging.Logger` object when imported from other modules (e.g., `from logging_setup import logger`).
        "%
        | optional,
      mccabe
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/McCabeOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `mccabe` plugin."
        | optional,
      namespace-packages
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc "Mark the specified directories as namespace packages. For the purpose of module resolution, Ruff will treat those directories and all their subdirectories as if they contained an `__init__.py` file."
        | optional,
      output-format
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/OutputFormat!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "The style in which violation messages should be formatted: `\"full\"` (default) (shows source), `\"concise\"`, `\"grouped\"` (group messages by file), `\"json\"` (machine-readable), `\"junit\"` (machine-readable XML), `\"github\"` (GitHub Actions annotations), `\"gitlab\"` (GitLab CI code quality report), `\"pylint\"` (Pylint text format) or `\"azure\"` (Azure Pipeline logging commands)."
        | optional,
      pep8-naming
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/Pep8NamingOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `pep8-naming` plugin."
        | optional,
      per-file-ignores
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
                  ])
            ])
        | doc "A list of mappings from file pattern to rule codes or prefixes to exclude, when considering any matching files. An initial '!' negates the file pattern."
        | optional,
      per-file-target-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/PythonVersion!predicate"
            ])
        | doc m%"
          A list of mappings from glob-style file pattern to Python version to use when checking the corresponding file(s).
          
          This may be useful for overriding the global Python version settings in `target-version` or `requires-python` for a subset of files. For example, if you have a project with a minimum supported Python version of 3.9 but a subdirectory of developer scripts that want to use a newer feature like the `match` statement from Python 3.10, you can use `per-file-target-version` to specify `"developer_scripts/*.py" = "py310"`.
          
          This setting is used by the linter to enforce any enabled version-specific lint rules, as well as by the formatter for any version-specific formatting options, such as parenthesizing context managers on Python 3.10+.
        "%
        | optional,
      preview
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Whether to enable preview mode. When preview mode is enabled, Ruff will use unstable rules, fixes, and formatting."
        | optional,
      pycodestyle
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PycodestyleOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `pycodestyle` plugin."
        | optional,
      pydocstyle
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PydocstyleOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `pydocstyle` plugin."
        | optional,
      pyflakes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PyflakesOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `pyflakes` plugin."
        | optional,
      pylint
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PylintOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `pylint` plugin."
        | optional,
      pyupgrade
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PyUpgradeOptions!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc "Options for the `pyupgrade` plugin."
        | optional,
      required-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/RequiredVersion!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          Enforce a requirement on the version of Ruff, to enforce at runtime. If the version of Ruff does not meet the requirement, Ruff will exit with an error.
          
          Useful for unifying results across many environments, e.g., with a `pyproject.toml` file.
          
          Accepts a [PEP 440](https://peps.python.org/pep-0440/) specifier, like `==0.3.1` or `>=0.3.1`.
        "%
        | optional,
      respect-gitignore
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Whether to automatically exclude files that are ignored by `.ignore`, `.gitignore`, `.git/info/exclude`, and global `gitignore` files. Enabled by default."
        | optional,
      select
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc m%"
          A list of rule codes or prefixes to enable. Prefixes can specify exact rules (like `F841`), entire categories (like `F`), or anything in between.
          
          When breaking ties between enabled and disabled rules (via `select` and `ignore`, respectively), more specific prefixes override less specific prefixes. `ignore` takes precedence over `select` if the same prefix appears in both.
        "%
        | optional,
      show-fixes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Whether to show an enumeration of all fixed lint violations (overridden by the `--show-fixes` command-line flag)."
        | optional,
      src
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          The directories to consider when resolving first- vs. third-party imports.
          
          When omitted, the `src` directory will typically default to including both:
          
          1. The directory containing the nearest `pyproject.toml`, `ruff.toml`, or `.ruff.toml` file (the "project root"). 2. The `"src"` subdirectory of the project root.
          
          These defaults ensure that Ruff supports both flat layouts and `src` layouts out-of-the-box. (If a configuration file is explicitly provided (e.g., via the `--config` command-line flag), the current working directory will be considered the project root.)
          
          As an example, consider an alternative project structure, like:
          
          ```text my_project ├── pyproject.toml └── lib └── my_package ├── __init__.py ├── foo.py └── bar.py ```
          
          In this case, the `./lib` directory should be included in the `src` option (e.g., `src = ["lib"]`), such that when resolving imports, `my_package.foo` is considered first-party.
          
          This field supports globs. For example, if you have a series of Python packages in a `python_modules` directory, `src = ["python_modules/*"]` would expand to incorporate all packages in that directory. User home directory and environment variables will also be expanded.
        "%
        | optional,
      target-version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/PythonVersion!predicate",
              _js2n__-prdslib.isType 'Null
            ])
        | doc m%"
          The minimum Python version to target, e.g., when considering automatic code upgrades, like rewriting type annotations. Ruff will not propose changes using features that are not available in the given version.
          
          For example, to represent supporting Python >=3.10 or ==3.10 specify `target-version = "py310"`.
          
          If you're already using a `pyproject.toml` file, we recommend `project.requires-python` instead, as it's based on Python packaging standards, and will be respected by other tools. For example, Ruff treats the following as identical to `target-version = "py38"`:
          
          ```toml [project] requires-python = ">=3.8" ```
          
          If both are specified, `target-version` takes precedence over `requires-python`. See [_Inferring the Python version_](https://docs.astral.sh/ruff/configuration/#inferring-the-python-version) for a complete description of how the `target-version` is determined when left unspecified.
          
          Note that a stub file can [sometimes make use of a typing feature](https://typing.readthedocs.io/en/latest/spec/distributing.html#syntax) before it is available at runtime, as long as the stub does not make use of new *syntax*. For example, a type checker will understand `int | str` in a stub as being a `Union` type annotation, even if the type checker is run using Python 3.9, despite the fact that the `|` operator can only be used to create union types at runtime on Python 3.10+. As such, Ruff will often recommend newer features in a stub file than it would for an equivalent runtime file with the same target version.
        "%
        | optional,
      task-tags
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of task tags to recognize (e.g., "TODO", "FIXME", "XXX").
          
          Comments starting with these tags will be ignored by commented-out code detection (`ERA`), and skipped by line-length rules (`E501`) if [`ignore-overlong-task-comments`](#lint_pycodestyle_ignore-overlong-task-comments) is set to `true`.
        "%
        | optional,
      typing-modules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ])
        | doc m%"
          A list of modules whose exports should be treated equivalently to members of the `typing` module.
          
          This is useful for ensuring proper type annotation inference for projects that re-export `typing` and `typing_extensions` members from a compatibility module. If omitted, any members imported from modules apart from `typing` and `typing_extensions` will be treated as ordinary Python objects.
        "%
        | optional,
      unfixable
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/RuleSelector!predicate"
            ])
        | doc "A list of rule codes or prefixes to consider non-fixable."
        | optional,
      unsafe-fixes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Bool", _js2n__-prdslib.isType 'Null ])
        | doc "Enable application of unsafe fixes. If excluded, a hint will be displayed when unsafe fixes are available. If set to false, the hint will be hidden."
        | optional,
    }