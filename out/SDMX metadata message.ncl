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
      "_js2n__-:definitions/ActionType!predicate"
        | doc "ActionType provides a list of actions, describing the intention of the data transmission from the sender's side. Each action provided at the data or metadata set level applies to the entire data set for which it is given. Note that the actions indicated in the Message Header are optional, and used to summarize specific actions indicated with this data type for all registry interactions. The \"Informational\" value is used when the message contains information in response to a query, rather than being used to invoke a maintenance activity."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "Append", "Replace", "Delete", "Information" ],
              _js2n__-prdslib.strings.pattern "^[-._:A-Za-z0-9]+$"
            ],
      "_js2n__-:definitions/AnnotationType!predicate"
        | doc "AnnotationType provides for non-documentation notes and annotations to be embedded in data and structure messages. It provides optional fields for providing a title, a type description, a URI, and the text of the annotation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  links =
                    _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                  text =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  texts =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  title = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AnnotationsType!predicate"
        | doc "Annotations is a reusable element the provides for a collection of annotations. It has been made global so that restrictions of types that extend AnnotatableType my reference it."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/AnnotationType!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/BasicTimePeriodType!predicate"
        | doc "BasicTimePeriodType contains the basic dates and calendar periods. It is a combination of the Gregorian time periods and the date time type.."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.strings.pattern
                    "^-?([1-9][0-9]{3,}|0[0-9]{3})(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$",
                  _js2n__-prdslib.strings.pattern
                    "^-?([1-9][0-9]{3,}|0[0-9]{3})-(0[1-9]|1[0-2])(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$",
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataProvisionAgreementReferenceType!predicate"
        | doc "MetadataProvisionAgreementReferenceType is a type for referencing a metadata provision agreement. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.registry\\.MetadataProvisionAgreement=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/MetadataSetType!predicate"
        | doc "MetadataSetType describes the structure for a metadata set, which contains a collection of reported metadata against a set of values for a given full or partial target identifier, as described in a metadata structure definition. The metadata set may contain reported metadata for multiple report structures defined in a metadata structure definition."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [
                          "agencyID",
                          "attributes",
                          "id",
                          "metadataflow",
                          "name",
                          "targets"
                        ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [
                          "agencyID",
                          "attributes",
                          "id",
                          "metadataProvisionAgreement",
                          "name",
                          "targets"
                        ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  action =
                    _js2n__-refsenv."_js2n__-:definitions/ActionType!predicate",
                  agencyID =
                    _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/AnnotationsType!predicate",
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/attributeType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  descriptions =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  id = _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                  isExternalReference = _js2n__-prdslib.isType '"Bool",
                  links =
                    _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                  metadataProvisionAgreement =
                    _js2n__-refsenv."_js2n__-:definitions/MetadataProvisionAgreementReferenceType!predicate",
                  metadataflow =
                    _js2n__-refsenv."_js2n__-:definitions/MetadataflowReferenceType!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  names =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  publicationPeriod =
                    _js2n__-refsenv."_js2n__-:definitions/ObservationalTimePeriodType!predicate",
                  publicationYear =
                    _js2n__-refsenv."_js2n__-:definitions/gYear!predicate",
                  reportingBegin =
                    _js2n__-refsenv."_js2n__-:definitions/BasicTimePeriodType!predicate",
                  reportingEnd =
                    _js2n__-refsenv."_js2n__-:definitions/BasicTimePeriodType!predicate",
                  targets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/urn!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  validFrom = _js2n__-prdslib.isType '"String",
                  validTo = _js2n__-prdslib.isType '"String",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/VersionType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MetadataflowReferenceType!predicate"
        | doc "MetadataflowReferenceType is a type for referencing a metadata flow object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.metadatastructure\\.Metadataflow=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/NestedNCNameIDType!predicate"
        | doc "NestedNCNameIDType restricts the NestedIDType, so that the id may be used to generate valid XML components. IDs created from this type conform to the W3C XML Schema NCNAME type, and therefore can be used as element or attribute names. Regex: [A-Za-z][A-Za-z0-9_\\-]*(\\.[A-Za-z][A-Za-z0-9_\\-]*)* "
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*$"
            ],
      "_js2n__-:definitions/ObservationalTimePeriodType!predicate"
        | doc "ObservationalTimePeriodType specifies a distinct time period or point in time in SDMX. The time period can either be a Gregorian calendar period, a standard reporting period, a distinct point in time, or a time range with a specific date and duration."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/BasicTimePeriodType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingTimePeriodType!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^.+/P.*T([0-9]+H)?([0-9]+M)?([0-9]+(.[0-9]+)?S)?$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^.+/P[^T]+$"
                ]
            ],
      "_js2n__-:definitions/ReportingDayType!predicate"
        | doc "ReportingDayType defines a time period of 1 day (P1D) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting day is YYYY-Dddd (e.g. 2000-D001), where ddd is a three digit day (i.e. 001-366)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^.{5}D(0[0-9][1-9]|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-6]).*$"
            ],
      "_js2n__-:definitions/ReportingMonthType!predicate"
        | doc "ReportingMonthType defines a time period of 1 month (P1M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. In this case a reporting month will coincide with a calendar month. The format of a reporting month is YYYY-Mmm (e.g. 2000-M01), where mm is a two digit month (i.e. 01-12)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^.{5}M(0[1-9]|1[0-2]).*$"
            ],
      "_js2n__-:definitions/ReportingQuarterType!predicate"
        | doc "ReportingQuarterType defines a time period of 3 months (P3M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting quarter is YYYY-Qq (e.g. 2000-Q1), where q is a value between 1 and 4."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^.{5}Q[1-4].*$"
            ],
      "_js2n__-:definitions/ReportingSemesterType!predicate"
        | doc "ReportingSemesterType defines a time period of 6 months (P6M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting semester is YYYY-Ss (e.g. 2000-S1), where s is either 1 or 2."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^.{5}S[1-2].*$"
            ],
      "_js2n__-:definitions/ReportingTimePeriodType!predicate"
        | doc "ReportingTimePeriodType defines standard reporting periods in SDMX, which are all in relation to the start day (day-month) of a reporting year which is specified in the specialized reporting year start day attribute. If the reporting year start day is not defined, a day of January 1 is assumed. The reporting year must be epxressed as the year at the beginning of the period. Therfore, if the reproting year runs from April to March, any given reporting year is expressed as the year for April. The general format of a report period can be described as  [year]-[period][time zone]?, where the type of period is designated with a single character followed by a number representing the period. Note that all periods allow for an optional time zone offset. See the details of each member type for the specifics of its format."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ReportingYearType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingSemesterType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingTrimesterType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingQuarterType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingMonthType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingWeekType!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ReportingDayType!predicate"
            ],
      "_js2n__-:definitions/ReportingTrimesterType!predicate"
        | doc "ReportingTrimesterType defines a time period of 4 months (P4M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting trimester is YYYY-Tt (e.g. 2000-T1), where s is either 1, 2, or 3."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^.{5}T[1-3].*$"
            ],
      "_js2n__-:definitions/ReportingWeekType!predicate"
        | doc "ReportingWeekType defines a time period of 7 days (P7D) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. A standard reporting week is based on the ISO 8601 defintion of a week date, in relation to the reporting period start day. The first week is defined as the week with the first Thursday on or after the reporting year start day. An equivalent definition is the week starting with the Monday nearest in time to the reporting year start day. There are other equivalent defintions, all of which should be adjusted based on the reporting year start day. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting week is YYYY-Www (e.g. 2000-W01), where mm is a two digit week (i.e. 01-53)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^.{5}W(0[1-9]|[1-4][0-9]|5[0-3]).*$"
            ],
      "_js2n__-:definitions/ReportingYearType!predicate"
        | doc "ReportingYearType defines a time period of 1 year (P1Y) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. In this case a reporting year will coincide with a calendar year. The format of a reporting year is YYYY-A1 (e.g. 2000-A1). Note that the period value of 1 is fixed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^.{5}A1.*$"
            ],
      "_js2n__-:definitions/StandardTimePeriodType!predicate"
        | doc "StandardTimePeriodType defines the set of standard time periods in SDMX. This includes the reporting time periods and the basic date type (i.e. the calendar time periods and the dateTime format)."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^([1-9][0-9]{3,}|0[0-9]{3})(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^([1-9][0-9]{3,}|0[0-9]{3})-(0[1-9]|1[0-2])(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$"
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^\\d{4}\\-([ASTQ]\\d{1}|[MW]\\d{2}|[D]\\d{3})(Z|((\\+|\\-)\\d{2}:\\d{2}))?$"
                ]
            ],
      "_js2n__-:definitions/VersionType!predicate"
        | doc "VersionType is used to communicate version information. The format is restricted to semantic versioning rules (reduced version without 'build metadata'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?$"
            ],
      "_js2n__-:definitions/attributeType!predicate"
        | doc "attributeType defines the structure for a reported metadata attribute. A value for the attribute can be supplied as either a single value, or multi-lingual text values (either structured or unstructured). An optional set of child metadata attributes is also available if the metadata attribute definition defines nested metadata attributes."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id", "value" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/AnnotationsType!predicate",
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/attributeType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/format!predicate",
                  id = _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                  value =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/contactType!predicate"
        | doc "ContactType describes the structure of a contact's details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  department =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  departments =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  emails =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  faxes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  names =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  role =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  roles =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  telephones =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  uris =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/uri!predicate"
                        ],
                  x400s =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/dimensionDataType!predicate"
        | doc "dimensionDataType provides an enumerated list of the types of data formats allowed as the for the representation of dimensions, since SDMX 3.0.0 also including GeospatialInformation. However, time dimensions only allow for 'ObservationalTimePeriod', 'StandardTimePeriod', 'BasicTimePeriod', 'GregorianTimePeriod', 'GregorianYear', 'GregorianYearMonth', 'GregorianDay', 'ReportingTimePeriod', 'ReportingYear', 'ReportingSemester', 'ReportingTrimester', 'ReportingQuarter', 'ReportingMonth', 'ReportingWeek', 'ReportingDay', 'DateTime' and 'TimeRange'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "String",
                  "Alpha",
                  "AlphaNumeric",
                  "Numeric",
                  "BigInteger",
                  "Integer",
                  "Long",
                  "Short",
                  "Decimal",
                  "Float",
                  "Double",
                  "Boolean",
                  "URI",
                  "Count",
                  "InclusiveValueRange",
                  "ExclusiveValueRange",
                  "Incremental",
                  "ObservationalTimePeriod",
                  "StandardTimePeriod",
                  "BasicTimePeriod",
                  "GregorianTimePeriod",
                  "GregorianYear",
                  "GregorianYearMonth",
                  "GregorianDay",
                  "ReportingTimePeriod",
                  "ReportingYear",
                  "ReportingSemester",
                  "ReportingTrimester",
                  "ReportingQuarter",
                  "ReportingMonth",
                  "ReportingWeek",
                  "ReportingDay",
                  "DateTime",
                  "TimeRange",
                  "Month",
                  "MonthDay",
                  "Day",
                  "Time",
                  "Duration",
                  "GeospatialInformation"
                ]
            ],
      "_js2n__-:definitions/duration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^P((([0-9]+Y([0-9]+M)?([0-9]+D)?|([0-9]+M)([0-9]+D)?|([0-9]+D))(T(([0-9]+H)([0-9]+M)?([0-9]+(\\.[0-9]+)?S)?|([0-9]+M)([0-9]+(\\.[0-9]+)?S)?|([0-9]+(\\.[0-9]+)?S)))?)|(T(([0-9]+H)([0-9]+M)?([0-9]+(\\.[0-9]+)?S)?|([0-9]+M)([0-9]+(\\.[0-9]+)?S)?|([0-9]+(\\.[0-9]+)?S))))$"
            ],
      "_js2n__-:definitions/format!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/nonDimensionDataType!predicate",
                  decimals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  endTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  endValue = _js2n__-prdslib.isType '"Number",
                  interval = _js2n__-prdslib.isType '"Number",
                  isMultiLingual = _js2n__-prdslib.isType '"Bool",
                  isSequence = _js2n__-prdslib.isType '"Bool",
                  maxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  maxValue = _js2n__-prdslib.isType '"Number",
                  minLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  minValue = _js2n__-prdslib.isType '"Number",
                  pattern = _js2n__-prdslib.isType '"String",
                  sentinelValues =
                    _js2n__-refsenv."_js2n__-:definitions/sentinelValues!predicate",
                  startTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  startValue = _js2n__-prdslib.isType '"Number",
                  timeInterval =
                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/gYear!predicate"
        | doc "gYear: GregorianTimePeriodType defines the set of standard calendar periods in SDMX."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^-?([1-9][0-9]{3,}|0[0-9]{3})(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$"
            ],
      "_js2n__-:definitions/idType!predicate"
        | doc "IDType provides a type which is used for restricting the characters in codes and IDs throughout all SDMX-ML messages. Valid characters include A-Z, a-z, @, 0-9, _, -, $. Regex: [A-Za-z0-9_@$-]+"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_@$-]+$"
            ],
      "_js2n__-:definitions/links!predicate"
        | doc "Links field is an array of link objects. If appropriate, a collection of links to additional external resources for the header."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "href", "rel" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required [ "rel", "urn" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.record
                      {
                        href =
                          _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                        hreflang =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$"
                              ],
                        rel =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "agencyscheme",
                                        "alternate",
                                        "appendix",
                                        "bookmark",
                                        "categorisation",
                                        "categoryscheme",
                                        "chapter",
                                        "codelist",
                                        "conceptscheme",
                                        "constraint",
                                        "contents",
                                        "copyright",
                                        "current",
                                        "dataflow",
                                        "dataconsumerscheme",
                                        "dataproviderscheme",
                                        "describedby",
                                        "edit",
                                        "edit-media",
                                        "enclosure",
                                        "first",
                                        "glossary",
                                        "help",
                                        "hierarchicalcodelist",
                                        "hub",
                                        "index",
                                        "last",
                                        "latest-version",
                                        "license",
                                        "metadataflow",
                                        "metadatastructure",
                                        "next",
                                        "next-archive",
                                        "organisationunitscheme",
                                        "payment",
                                        "prev",
                                        "predecessor-version",
                                        "previous",
                                        "prev-archive",
                                        "process",
                                        "provisionagreement",
                                        "related",
                                        "replies",
                                        "reportingtaxonomy",
                                        "section",
                                        "self",
                                        "service",
                                        "start",
                                        "structure",
                                        "structureset",
                                        "stylesheet",
                                        "subsection",
                                        "successor-version",
                                        "up",
                                        "version-history",
                                        "via",
                                        "working-copy",
                                        "working-copy-of"
                                      ]
                                  ]
                              ],
                        title =
                          _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                        titles =
                          _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                        type = _js2n__-prdslib.isType '"String",
                        uri =
                          _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                        urn =
                          _js2n__-refsenv."_js2n__-:definitions/urn!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/localisedBestMatchText!predicate"
        | doc "localisedBestMatchText is a reusable element, used for providing a human-readable best-language-match texts."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/localisedText!predicate"
        | doc "localisedText provides for a set of language-specific alternates to be provided for any human-readable constructs in the instance. "
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$" =
                    _js2n__-prdslib.isType '"String",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nonDimensionDataType!predicate"
        | doc "nonDimensionDataType provides an enumerated list of the types of data formats allowed as the for the representation of measures and attributes, since SDMX 3.0.0 also including XHTML and GeospatialInformation."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "XHTML" ]
                ],
              _js2n__-refsenv."_js2n__-:definitions/dimensionDataType!predicate"
            ],
      "_js2n__-:definitions/party!predicate"
        | doc "Sender contains information about the party that is transmitting the message."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  contacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/contactType!predicate"
                        ],
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_@$-]+$"
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  names =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sentinelValues!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "name", "value" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "name", "names", "value" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.record
                      {
                        description =
                          _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                        descriptions =
                          _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                        name =
                          _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                        names =
                          _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                        value =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                      } {} true _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/statusMessage!predicate"
        | doc "statusMessage describes the structure of an error or warning message."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "code" ],
              _js2n__-prdslib.records.record
                {
                  code = _js2n__-prdslib.isType '"Number",
                  detail =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  details =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  links =
                    _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  titles =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/uri!predicate"
        | doc "Contains the URL to the schema allowing to validate the message. This also allows identifying the version of SDMX-JSON format used in this message. Providing the link to the SDMX-JSON schema is recommended."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/urn!predicate"
        | doc "Universal Resource Name (URN) is constructed according to the generic structure 'urn:sdmx:org.SDMX-IM-package-name.class-name=agencyid:maintainedobject-id(maintainedobject-version).containerobject-id.object-id*'. For more information see: Unique identification of SDMX objects, in: SDMX STANDARDS: SECTION 5 SDMX REGISTRY SPECIFICATION"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((base\\.((Agency)|(OrganisationUnitScheme)|(AgencyScheme)|(DataProviderScheme)|(MetadataProviderScheme)|(DataConsumerScheme)|(OrganisationUnit)|(DataProvider)|(MetadataProvider)|(DataConsumer)))|(codelist\\.((Codelist)|(Valuelist)|(Hierarchy)|(HierarchyAssociation)|(Code)|(HierarchicalCode)|(Level)))|(conceptscheme\\.((ConceptScheme)|(Concept)))|(datastructure\\.((DataStructure)|(AttributeDescriptor)|(DataAttribute)|(ReportingYearStartDay)|(GroupDimensionDescriptor)|(DimensionDescriptor)|(Dimension)|(TimeDimension)|(MeasureDescriptor)|(Measure)|(Dataflow)))|(categoryscheme\\.((CategoryScheme)|(Category)|(Categorisation)|(ReportingTaxonomy)|(ReportingCategory)))|(registry\\.((ProvisionAgreement)|(MetadataProvisionAgreement)|(DataConstraint)|(MetadataConstraint)|(Subscription)))|(metadatastructure\\.((MetadataAttributeDescriptor)|(MetadataAttribute)|(MetadataStructure)|(Metadataflow)))|(process\\.((Process)|(ProcessStep)|(Transition)))|(structuremapping\\.((StructureMap)|(ComponentMap)|(EpochMap)|(DatePatternMap)|(ConceptSchemeMap)|(OrganisationSchemeMap)|(CategorySchemeMap)|(ReportingTaxonomyMap)|(RepresentationMap)|(FrequencyFormatMapping)))|(transformation\\.((TransformationScheme)|(Transformation)|(CustomTypeScheme)|(CustomType)|(NamePersonalisationScheme)|(NamePersonalisation)|(VtlMappingScheme)|(VtlCodelistMapping)|(VtlConceptMapping)|(VtlDataflowMapping)|(RulesetScheme)|(Ruleset)|(UserDefinedOperatorScheme)|(UserDefinedOperator))))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)(\\.[A-Za-z0-9_@$-]+(\\.[A-Za-z0-9_@$-]+)*)?$"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "meta" ],
          _js2n__-prdslib.records.record
            {
              data =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          metadataSets =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/MetadataSetType!predicate"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              errors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/statusMessage!predicate"
                    ],
              meta =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "id", "prepared", "sender" ],
                      _js2n__-prdslib.records.record
                        {
                          contentLanguages =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.strings.pattern
                                          "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$"
                                      ])
                                ],
                          id =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "^[A-Za-z0-9_@$-]+$"
                                ],
                          links =
                            _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                          name =
                            _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                          names =
                            _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                          prepared = _js2n__-prdslib.isType '"String",
                          receivers =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/party!predicate"
                                ],
                          schema =
                            _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                          sender =
                            _js2n__-refsenv."_js2n__-:definitions/party!predicate",
                          test = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
            } {} true _js2n__-prdslib.always
        ])