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
          _js2n__-prdslib.records.required [ "toolchain" ],
          _js2n__-prdslib.records.record
            {
              toolchain =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "path" ],
                                _js2n__-prdslib.records.record
                                  { path = _js2n__-prdslib.isType '"String", }
                                  {} true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "path" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ]
                        ],
                      _js2n__-prdslib.records.minProperties 1,
                      _js2n__-prdslib.records.record
                        {
                          channel =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "^(?:stable|beta|nightly|\\d+(?:\\.\\d+){1,2})(?:-\\d{4}(?:-\\d{2}){2})?(?:-\\D[^-]*(?:(?:-(?:[^-]+)){1,3}))?$"
                                ],
                          components =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "rustc",
                                                "cargo",
                                                "rustfmt",
                                                "rust-std",
                                                "rust-docs",
                                                "rls",
                                                "clippy",
                                                "miri",
                                                "rust-src",
                                                "rust",
                                                "rust-analysis",
                                                "llvm-tools",
                                                "rustc-docs",
                                                "rustc-dev",
                                                "rust-analyzer",
                                                "reproducible-artifacts",
                                                "rust-docs-json"
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.minLength 1
                                          ]
                                      ])
                                ],
                          path = _js2n__-prdslib.isType '"String",
                          profile =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "minimal", "default", "complete" ]
                                ],
                          targets =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "aarch64-unknown-linux-gnu",
                                                "aarch64-apple-darwin",
                                                "i686-pc-windows-gnu",
                                                "i686-pc-windows-msvc",
                                                "i686-unknown-linux-gnu",
                                                "x86_64-apple-darwin",
                                                "x86_64-pc-windows-gnu",
                                                "x86_64-pc-windows-msvc",
                                                "x86_64-unknown-linux-gnu",
                                                "aarch64-pc-windows-msvc",
                                                "aarch64-unknown-linux-musl",
                                                "arm-unknown-linux-gnueabi",
                                                "arm-unknown-linux-gnueabihf",
                                                "armv7-unknown-linux-gnueabihf",
                                                "loongarch64-unknown-linux-gnu",
                                                "loongarch64-unknown-linux-musl",
                                                "powerpc-unknown-linux-gnu",
                                                "powerpc64-unknown-linux-gnu",
                                                "powerpc64le-unknown-linux-gnu",
                                                "riscv64gc-unknown-linux-gnu",
                                                "riscv64gc-unknown-linux-musl",
                                                "s390x-unknown-linux-gnu",
                                                "x86_64-unknown-freebsd",
                                                "x86_64-unknown-illumos",
                                                "x86_64-unknown-linux-musl",
                                                "x86_64-unknown-netbsd",
                                                "aarch64-apple-ios",
                                                "aarch64-apple-ios-macabi",
                                                "aarch64-apple-ios-sim",
                                                "aarch64-fuchsia",
                                                "aarch64-unknown-fuchsia",
                                                "aarch64-linux-android",
                                                "aarch64-pc-windows-gnullvm",
                                                "aarch64-unknown-linux-ohos",
                                                "aarch64-unknown-none-softfloat",
                                                "aarch64-unknown-none",
                                                "aarch64-unknown-uefi",
                                                "arm-linux-androideabi",
                                                "arm-unknown-linux-musleabi",
                                                "arm-unknown-linux-musleabihf",
                                                "arm64ec-pc-windows-msvc",
                                                "armebv7r-none-eabi",
                                                "armebv7r-none-eabihf",
                                                "armv5te-unknown-linux-gnueabi",
                                                "armv5te-unknown-linux-musleabi",
                                                "armv7-linux-androideabi",
                                                "armv7-unknown-linux-gnueabi",
                                                "armv7-unknown-linux-musleabi",
                                                "armv7-unknown-linux-musleabihf",
                                                "armv7-unknown-linux-ohos",
                                                "armv7a-none-eabi",
                                                "armv7r-none-eabi",
                                                "armv7r-none-eabihf",
                                                "i586-pc-windows-msvc",
                                                "i586-unknown-linux-gnu",
                                                "i586-unknown-linux-musl",
                                                "i686-linux-android",
                                                "i686-pc-windows-gnullvm",
                                                "i686-unknown-freebsd",
                                                "i686-unknown-linux-musl",
                                                "i686-unknown-uefi",
                                                "loongarch64-unknown-none",
                                                "loongarch64-unknown-none-softfloat",
                                                "nvptx64-nvidia-cuda",
                                                "riscv32imac-unknown-none-elf",
                                                "riscv32i-unknown-none-elf",
                                                "riscv32im-unknown-none-elf",
                                                "riscv32imc-unknown-none-elf",
                                                "riscv32imafc-unknown-none-elf",
                                                "riscv64gc-unknown-none-elf",
                                                "riscv64imac-unknown-none-elf",
                                                "sparc64-unknown-linux-gnu",
                                                "sparcv9-sun-solaris",
                                                "thumbv6m-none-eabi",
                                                "thumbv7em-none-eabi",
                                                "thumbv7em-none-eabihf",
                                                "thumbv7m-none-eabi",
                                                "thumbv7neon-linux-androideabi",
                                                "thumbv7neon-unknown-linux-gnueabihf",
                                                "thumbv8m.base-none-eabi",
                                                "thumbv8m.main-none-eabi",
                                                "thumbv8m.main-none-eabihf",
                                                "wasm32-unknown-emscripten",
                                                "wasm32-unknown-unknown",
                                                "wasm32-wasi",
                                                "wasm32-wasip1",
                                                "wasm32-wasip1-threads",
                                                "x86_64-apple-ios",
                                                "x86_64-apple-ios-macabi",
                                                "x86_64-fortanix-unknown-sgx",
                                                "x86_64-fuchsia",
                                                "x86_64-unknown-fuchsia",
                                                "x86_64-linux-android",
                                                "x86_64-pc-solaris",
                                                "x86_64-pc-windows-gnullvm",
                                                "x86_64-unknown-linux-gnux32",
                                                "x86_64-unknown-linux-ohos",
                                                "x86_64-unknown-none",
                                                "x86_64-unknown-redox",
                                                "x86_64-unknown-uefi",
                                                "arm64e-apple-ios",
                                                "arm64e-apple-darwin",
                                                "aarch64-apple-tvos",
                                                "aarch64-apple-tvos-sim",
                                                "aarch64-apple-watchos",
                                                "aarch64-apple-watchos-sim",
                                                "aarch64-apple-visionos",
                                                "aarch64-apple-visionos-sim",
                                                "aarch64-kmc-solid_asp3",
                                                "aarch64-nintendo-switch-freestanding",
                                                "aarch64-unknown-teeos",
                                                "aarch64-unknown-nto-qnx700",
                                                "aarch64-unknown-nto-qnx710",
                                                "aarch64-unknown-freebsd",
                                                "aarch64-unknown-hermit",
                                                "aarch64-unknown-illumos",
                                                "aarch64-unknown-linux-gnu_ilp32",
                                                "aarch64-unknown-netbsd",
                                                "aarch64-unknown-openbsd",
                                                "aarch64-unknown-redox",
                                                "aarch64-unknown-trusty",
                                                "aarch64-uwp-windows-msvc",
                                                "aarch64-wrs-vxworks",
                                                "aarch64_be-unknown-linux-gnu_ilp32",
                                                "aarch64_be-unknown-linux-gnu",
                                                "aarch64_be-unknown-netbsd",
                                                "arm64_32-apple-watchos",
                                                "armeb-unknown-linux-gnueabi",
                                                "armv4t-none-eabi",
                                                "armv4t-unknown-linux-gnueabi",
                                                "armv5te-none-eabi",
                                                "armv5te-unknown-linux-uclibceabi",
                                                "armv6-unknown-freebsd",
                                                "armv6-unknown-netbsd-eabihf",
                                                "armv6k-nintendo-3ds",
                                                "armv7-rtems-eabihf",
                                                "armv7-sony-vita-newlibeabihf",
                                                "armv7-unknown-linux-uclibceabi",
                                                "armv7-unknown-linux-uclibceabihf",
                                                "armv7-unknown-freebsd",
                                                "armv7-unknown-netbsd-eabihf",
                                                "armv7-unknown-trusty",
                                                "armv7-wrs-vxworks-eabihf",
                                                "armv7a-kmc-solid_asp3-eabi",
                                                "armv7a-kmc-solid_asp3-eabihf",
                                                "armv7a-none-eabihf",
                                                "armv7k-apple-watchos",
                                                "armv7s-apple-ios",
                                                "armv8r-none-eabihf",
                                                "avr-unknown-gnu-atmega328",
                                                "bpfeb-unknown-none",
                                                "bpfel-unknown-none",
                                                "csky-unknown-linux-gnuabiv2",
                                                "csky-unknown-linux-gnuabiv2hf",
                                                "hexagon-unknown-none-elf",
                                                "hexagon-unknown-linux-musl",
                                                "i386-apple-ios",
                                                "i586-pc-nto-qnx700",
                                                "i586-unknown-netbsd",
                                                "i686-apple-darwin",
                                                "i686-unknown-haiku",
                                                "i686-unknown-hurd-gnu",
                                                "i686-unknown-netbsd",
                                                "i686-unknown-openbsd",
                                                "i686-unknown-redox",
                                                "i686-uwp-windows-gnu",
                                                "i686-uwp-windows-msvc",
                                                "i686-win7-windows-msvc",
                                                "i686-wrs-vxworks",
                                                "m68k-unknown-linux-gnu",
                                                "mips-unknown-linux-gnu",
                                                "mips-unknown-linux-musl",
                                                "mips-unknown-linux-uclibc",
                                                "mips64-openwrt-linux-musl",
                                                "mips64-unknown-linux-gnuabi64",
                                                "mips64-unknown-linux-muslabi64",
                                                "mips64el-unknown-linux-gnuabi64",
                                                "mips64el-unknown-linux-muslabi64",
                                                "mipsel-unknown-linux-gnu",
                                                "mipsel-unknown-linux-musl",
                                                "mipsel-unknown-netbsd",
                                                "mipsel-sony-psp",
                                                "mipsel-sony-psx",
                                                "mipsel-unknown-linux-uclibc",
                                                "mipsel-unknown-none",
                                                "mipsisa32r6-unknown-linux-gnu",
                                                "mipsisa32r6el-unknown-linux-gnu",
                                                "mipsisa64r6-unknown-linux-gnuabi64",
                                                "mipsisa64r6el-unknown-linux-gnuabi64",
                                                "msp430-none-elf",
                                                "powerpc-unknown-linux-gnuspe",
                                                "powerpc-unknown-linux-musl",
                                                "powerpc-unknown-linux-muslspe",
                                                "powerpc-unknown-netbsd",
                                                "powerpc-unknown-openbsd",
                                                "powerpc-wrs-vxworks-spe",
                                                "powerpc-wrs-vxworks",
                                                "powerpc64-unknown-freebsd",
                                                "powerpc64le-unknown-freebsd",
                                                "powerpc-unknown-freebsd",
                                                "powerpc64-unknown-linux-musl",
                                                "powerpc64-wrs-vxworks",
                                                "powerpc64le-unknown-linux-musl",
                                                "powerpc64-unknown-openbsd",
                                                "powerpc64-ibm-aix",
                                                "riscv32gc-unknown-linux-gnu",
                                                "riscv32gc-unknown-linux-musl",
                                                "riscv32im-risc0-zkvm-elf",
                                                "riscv32ima-unknown-none-elf",
                                                "riscv32imac-unknown-xous-elf",
                                                "riscv32imc-esp-espidf",
                                                "riscv32imac-esp-espidf",
                                                "riscv32imafc-esp-espidf",
                                                "riscv64gc-unknown-hermit",
                                                "riscv64gc-unknown-freebsd",
                                                "riscv64gc-unknown-fuchsia",
                                                "riscv64gc-unknown-netbsd",
                                                "riscv64gc-unknown-openbsd",
                                                "riscv64-linux-android",
                                                "s390x-unknown-linux-musl",
                                                "sparc-unknown-linux-gnu",
                                                "sparc-unknown-none-elf",
                                                "sparc64-unknown-netbsd",
                                                "sparc64-unknown-openbsd",
                                                "thumbv4t-none-eabi",
                                                "thumbv5te-none-eabi",
                                                "thumbv7a-pc-windows-msvc",
                                                "thumbv7a-uwp-windows-msvc",
                                                "thumbv7neon-unknown-linux-musleabihf",
                                                "wasm32-wasip2",
                                                "wasm64-unknown-unknown",
                                                "x86_64-apple-tvos",
                                                "x86_64-apple-watchos-sim",
                                                "x86_64-pc-nto-qnx710",
                                                "x86_64-unikraft-linux-musl",
                                                "x86_64-unknown-dragonfly",
                                                "x86_64-unknown-haiku",
                                                "x86_64-unknown-hurd-gnu",
                                                "x86_64-unknown-hermit",
                                                "x86_64-unknown-l4re-uclibc",
                                                "x86_64-unknown-openbsd",
                                                "x86_64-uwp-windows-gnu",
                                                "x86_64-uwp-windows-msvc",
                                                "x86_64-win7-windows-msvc",
                                                "x86_64-wrs-vxworks",
                                                "x86_64h-apple-darwin",
                                                "x86_64-unknown-linux-none",
                                                "xtensa-esp32-none-elf",
                                                "xtensa-esp32-espidf",
                                                "xtensa-esp32s2-none-elf",
                                                "xtensa-esp32s2-espidf",
                                                "xtensa-esp32s3-none-elf",
                                                "xtensa-esp32s3-espidf",
                                                "thumbv6m-nuttx-eabi",
                                                "thumbv7m-nuttx-eabi",
                                                "thumbv7em-nuttx-eabi",
                                                "thumbv7em-nuttx-eabihf",
                                                "thumbv8m.base-nuttx-eabi",
                                                "thumbv8m.main-nuttx-eabi",
                                                "thumbv8m.main-nuttx-eabihf",
                                                "riscv32imc-unknown-nuttx-elf",
                                                "riscv32imac-unknown-nuttx-elf",
                                                "riscv32imafc-unknown-nuttx-elf",
                                                "riscv64imac-unknown-nuttx-elf",
                                                "riscv64gc-unknown-nuttx-elf"
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.minLength 1
                                          ]
                                      ])
                                ],
                        } {} true _js2n__-prdslib.always,
                      _js2n__-prdslib.records.dependencies
                        {
                          channel =
                            _js2n__-prdslib.not
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "path" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        path = _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ]),
                          path =
                            _js2n__-prdslib.not
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "channel" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        channel =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ]),
                          profile =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "channel" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          channel =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "components" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          components =
                                            _js2n__-prdslib.isType '"Array",
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "targets" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          targets =
                                            _js2n__-prdslib.isType '"Array",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                        }
                    ],
            } {} true _js2n__-prdslib.always
        ])