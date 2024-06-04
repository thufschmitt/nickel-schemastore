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
      "_js2n__-:definitions/AgencySchemeType!predicate"
        | doc "AgencySchemeType defines a specific type of organisation scheme which contains only maintenance agencies. The agency scheme maintained by a particular maintenance agency is always provided a fixed identifier and is never versioned. Therefore, agencies can be added or removed without have to version the scheme. Agencies schemes have no hierarchy, meaning that no agency may define a relationship with another agency in the scheme. In fact, the actual parent agency for an agency in a scheme is the agency which defines the scheme."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableWithoutVersionType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      agencies =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/AgencyType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      id = _js2n__-prdslib.const "AGENCIES",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/AgencyType!predicate"
        | doc "AgencyType defines the structure of an agency description. The contacts defined for the organisation are specific to the agency role the organisation is serving."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          contacts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/AnnotableType!predicate"
        | doc "AnnotableType is an abstract base type used for all annotable artefacts. Any type that provides for annotations should extend this type."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/AnnotationsType!predicate",
                } {} true _js2n__-prdslib.always
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
        | doc "AnnotationsType is a reusable element the provides for a collection of annotations. It has been made global so that restrictions of types that extend AnnotableType my reference it."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/AnnotationType!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/AnyCodelistReferenceType!predicate"
        | doc "AnyCodelistReferenceType is a type for referencing a codelist or valuelist object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.codelist\\.((Codelist)|(ValueList))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/AttributeListType!predicate"
        | doc "AttributeListType describes the attribute descriptor for the data structure definition."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      attributes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/AttributeType!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/ReportingYearStartOrEndDayType!predicate"
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      id = _js2n__-prdslib.const "AttributeDescriptor",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                      metadataAttributeUsages =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MetadataAttributeUsageType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/AttributeRelationshipType!predicate"
        | doc "AttributeRelationship defines the structure for stating the relationship between an attribute and other data structure definition components."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dataflow" ],
                      _js2n__-prdslib.records.record
                        {
                          dataflow =
                            _js2n__-refsenv."_js2n__-:definitions/EmptyType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dimensions" ],
                      _js2n__-prdslib.records.record
                        {
                          areDimensionsOptional =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"Bool"),
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          dimensions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/NCNameIDType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "group" ],
                      _js2n__-prdslib.records.record
                        {
                          group =
                            _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "observation" ],
                      _js2n__-prdslib.records.record
                        {
                          observation =
                            _js2n__-refsenv."_js2n__-:definitions/EmptyType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/AttributeRepresentationType!predicate"
        | doc "AttributeRepresentationType defines the representation for a data attribute. A data attribute can be text (including XHTML and multi-lingual values), a simple value, or an enumerated value"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "enumeration" ],
                      _js2n__-prdslib.records.record
                        {
                          enumeration =
                            _js2n__-refsenv."_js2n__-:definitions/AnyCodelistReferenceType!predicate",
                          enumerationFormat =
                            _js2n__-refsenv."_js2n__-:definitions/CodedTextFormatType!predicate",
                          maxOccurs =
                            _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                          minOccurs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        {
                          format =
                            _js2n__-refsenv."_js2n__-:definitions/BasicComponentTextFormatType!predicate",
                          maxOccurs =
                            _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                          minOccurs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/AttributeType!predicate"
        | doc "AttributeType describes the structure of a data attribute, which is defined as a characteristic of an object or entity. The attribute takes its semantic, and in some cases it representation, from its concept identity. An attribute can be coded by referencing a code list from its coded local representation. It can also specify its text format, which is used as the representation of the attribute if a coded representation is not defined. Neither the coded or uncoded representation are necessary, since the attribute may take these from the referenced concept. An attribute specifies its relationship with other data structure components and is given an assignment status. These two properties dictate where in a data message the attribute will be attached, and whether or not the attribute will be required to be given a value. A set of roles defined in concept scheme can be assigned to the attribute."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      attributeRelationship =
                        _js2n__-refsenv."_js2n__-:definitions/AttributeRelationshipType!predicate",
                      conceptIdentity =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                      conceptRoles =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      localRepresentation =
                        _js2n__-refsenv."_js2n__-:definitions/AttributeRepresentationType!predicate",
                      measureRelationship =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/NCNameIDType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      usage =
                        _js2n__-refsenv."_js2n__-:definitions/UsageType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required
                [ "attributeRelationship", "conceptIdentity" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/BasicComponentDataType!predicate"
        | doc "BasicComponentDataType provides an enumerated list of the types of characters allowed in the dataType attribute for all non-target object components."
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
                  "GeospatialInformation",
                  "XHTML"
                ]
            ],
      "_js2n__-:definitions/BasicComponentTextFormatType!predicate"
        | doc "BasicComponentTextFormatType is a restricted version of the TextFormatType that restricts the text type to the representations allowed for all components except for target objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/BasicComponentDataType!predicate",
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
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/sentinelValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  startTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  startValue = _js2n__-prdslib.isType '"Number",
                  timeInterval =
                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/BasicTimePeriodType!predicate"
        | doc "BasicTimePeriodType contains the basic dates and calendar periods. It is a combination of the Gregorian time periods and the date time type."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.strings.pattern
                    "^([1-9][0-9]{3,}|0[0-9]{3})(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$",
                  _js2n__-prdslib.strings.pattern
                    "^([1-9][0-9]{3,}|0[0-9]{3})-(0[1-9]|1[0-2])(Z|(\\+|-)((0[0-9]|1[0-3]):[0-5][0-9]|14:00))?$",
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CascadeSelectionType!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.const "excluderoot"
            ],
      "_js2n__-:definitions/CategorisationType!predicate"
        | doc "CategorisationType defines the structure for a categorisation. A source object is referenced via an object reference and the target category is referenced via the target category."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/urn!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/CategoryReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CategoryReferenceType!predicate"
        | doc "CategoryReferenceType is a type for referencing a category object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.categoryscheme\\.Category=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)(\\.[A-Za-z0-9_@$-]+(\\.[A-Za-z0-9_@$-]+)*)$"
            ],
      "_js2n__-:definitions/CategorySchemeMapType!predicate"
        | doc "CategorySchemeMapType defines the structure of a map which identifies relationships between categories in different category schemes. Unless the artefact is returned as a stub, it must contain the 'source' and 'target' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      itemMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SingleValueMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/CategorySchemeReferenceType!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/CategorySchemeReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CategorySchemeReferenceType!predicate"
        | doc "CategorySchemeReferenceType is a type for referencing a category scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.categoryscheme\\.CategoryScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/CategorySchemeType!predicate"
        | doc "CategorySchemeType describes the structure of a category scheme. A category scheme is the descriptive information for an arrangement or division of categories into groups based on characteristics, which the objects have in common. This provides for a simple, leveled hierarchy or categories."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      categories =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CategoryType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CategoryType!predicate"
        | doc "CategoryType describes the details of a category. A category is defined as an item at any level in a classification. The Category element represents a set of nested categories which are child categories."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          categories =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/CategoryType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/CodeDataType!predicate"
        | doc "CodeDataType is a restriction of the basic data types that are applicable to codes. Although some of the higher level time period formats are perimitted, it should be noted that any value which contains time (which includes a time zone offset) is not allowable as a code identifier."
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
                  "Month",
                  "MonthDay",
                  "Day",
                  "Duration"
                ]
            ],
      "_js2n__-:definitions/CodeReferenceType!predicate"
        | doc "CodeReferenceType is a type for referencing a code object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.codelist\\.Code=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)(\\.[A-Za-z0-9_@$-]+)$"
            ],
      "_js2n__-:definitions/CodeSelectionType!predicate"
        | doc "CodeSelectionType defines the structure for code selection to be used as inclusive or exclusive extensions."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "wildcardedMemberValues" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "memberValues" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  memberValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MemberValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  wildcardedMemberValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^[A-Za-z0-9_@$-]+%?$"
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CodeType!predicate"
        | doc "CodeType describes the structure of a code. A code is defined as a language independent set of letters, numbers or symbols that represent a concept whose meaning is described in a natural language. Presentational information not present may be added through the use of annotations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          parent =
                            _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/CodedTextFormatType!predicate"
        | doc "CodedTextFormatType is a restricted version of the SimpleComponentTextFormatType that only allows factets and text types applicable to codes. Although the time facets permit any value, an actual code identifier does not support the necessary characters for time. Therefore these facets should not contain time in their values."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/CodeDataType!predicate",
                  endTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  endValue = _js2n__-prdslib.isType 'Integer,
                  interval = _js2n__-prdslib.isType 'Integer,
                  isSequence = _js2n__-prdslib.isType '"Bool",
                  maxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  maxValue = _js2n__-prdslib.isType 'Integer,
                  minLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  minValue = _js2n__-prdslib.isType 'Integer,
                  pattern = _js2n__-prdslib.isType '"String",
                  startTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  startValue = _js2n__-prdslib.isType 'Integer,
                  timeInterval =
                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CodelistExtensionType!predicate"
        | doc "CodelistExtensionType defines the structure of a codelist to be extended by the codelist defining the extension. It provides a reference to the extended codelist and selection criteria to indicate the codes to be included in the extending codelist."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "inclusiveCodeSelection" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "exclusiveCodeSelection" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.not
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required
                      [ "exclusiveCodeSelection", "inclusiveCodeSelection" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.required [ "codelist" ],
              _js2n__-prdslib.records.record
                {
                  codelist =
                    _js2n__-refsenv."_js2n__-:definitions/CodelistReferenceType!predicate",
                  exclusiveCodeSelection =
                    _js2n__-refsenv."_js2n__-:definitions/CodeSelectionType!predicate",
                  inclusiveCodeSelection =
                    _js2n__-refsenv."_js2n__-:definitions/CodeSelectionType!predicate",
                  prefix = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CodelistReferenceType!predicate"
        | doc "CodelistReferenceType is a type for referencing a codelist object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.codelist\\.Codelist=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/CodelistType!predicate"
        | doc "CodelistType defines the structure of a codelist. A codelist is defined as a list from which some statistical concepts (coded concepts) take their values."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      codelistExtensions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CodelistExtensionType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      codes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CodeType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CodingTextFormatType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/SimpleCodeDataType!predicate",
                  endValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  interval = _js2n__-prdslib.isType 'Integer,
                  isSequence = _js2n__-prdslib.isType '"Bool",
                  maxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  maxValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  minLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  minValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                  startValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ComponentMapType!predicate"
        | doc "ComponentMapType defines the structure for relating a component in a source structure to a component in a target structure."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "source", "target" ],
                      _js2n__-prdslib.records.record
                        {
                          representationMap =
                            _js2n__-refsenv."_js2n__-:definitions/RepresentationMapReferenceType!predicate",
                          source =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          target =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ComponentValueSetType!predicate"
        | doc "ComponentValueSetType defines the structure for providing values for a data attributes, measures, or metadata attributes. If no values are provided, the component is implied to include/excluded from the region in which it is defined, with no regard to the value of the component. Note that for metadata attributes which occur within other metadata attributes, a nested identifier can be provided. For example, a value of CONTACT.ADDRESS.STREET refers to the metadata attribute with the identifier STREET which exists in the ADDRESS metadata attribute in the CONTACT metadata attribute, which is defined at the root of the report structure."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "timeRange" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "values" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.not
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "timeRange", "values" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                  include = _js2n__-prdslib.isType '"Bool",
                  removePrefix = _js2n__-prdslib.isType '"Bool",
                  timeRange =
                    _js2n__-refsenv."_js2n__-:definitions/TimeRangeValueType!predicate",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SimpleComponentValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ComputationType!predicate"
        | doc "ComputationType describes a computation in a process."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "description" ],
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/AnnotationsType!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                  descriptions =
                    _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                  localID =
                    _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                  softwareLanguage = _js2n__-prdslib.isType '"String",
                  softwarePackage = _js2n__-prdslib.isType '"String",
                  softwareVersion = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ConceptReferenceType!predicate"
        | doc "ConceptReferenceType is a type for referencing a concept object. It consists of a URN"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.conceptscheme\\.Concept=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)(\\.[A-Za-z0-9_@$-]+)$"
            ],
      "_js2n__-:definitions/ConceptRepresentationType!predicate"
        | doc "ConceptRepresentationType defines the core representation that are allowed for a concept. The text format allowed for a concept is that which is allowed for any non-target object component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "enumeration" ],
                      _js2n__-prdslib.records.record
                        {
                          enumeration =
                            _js2n__-refsenv."_js2n__-:definitions/AnyCodelistReferenceType!predicate",
                          enumerationFormat =
                            _js2n__-refsenv."_js2n__-:definitions/CodedTextFormatType!predicate",
                          maxOccurs =
                            _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                          minOccurs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        {
                          format =
                            _js2n__-refsenv."_js2n__-:definitions/BasicComponentTextFormatType!predicate",
                          maxOccurs =
                            _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                          minOccurs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ConceptSchemeMapType!predicate"
        | doc "ConceptSchemeMapType defines the structure of a map which identifies relationships between concepts in different concept schemes. Unless the artefact is returned as a stub, it must contain the 'source' and 'target' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      itemMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SingleValueMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptSchemeReferenceType!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptSchemeReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ConceptSchemeReferenceType!predicate"
        | doc "ConceptSchemeReferenceType is a type for referencing a concept scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.conceptscheme\\.ConceptScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/ConceptSchemeType!predicate"
        | doc "ConceptSchemeType describes the structure of a concept scheme. A concept scheme is the descriptive information for an arrangement or division of concepts into groups based on characteristics, which the objects have in common. It contains a collection of concept definitions, that may be arranged in simple hierarchies."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      concepts =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ConceptType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ConceptType!predicate"
        | doc "ConceptType describes the details of a concept. A concept is defined as a unit of knowledge created by a unique combination of characteristics. If a concept does not specify a TextFormat or a core representation, then the representation of the concept is assumed to be represented by any set of valid characters (corresponding to the string datatype)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          coreRepresentation =
                            _js2n__-refsenv."_js2n__-:definitions/ConceptRepresentationType!predicate",
                          isoConceptReference =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [
                                      "conceptAgency",
                                      "conceptID",
                                      "conceptSchemeID"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      conceptAgency =
                                        _js2n__-prdslib.isType '"String",
                                      conceptID =
                                        _js2n__-prdslib.isType '"String",
                                      conceptSchemeID =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                          parent =
                            _js2n__-refsenv."_js2n__-:definitions/SingleNCNameIDType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ConstraintRoleType!predicate"
        | doc "ConstraintRoleType defines a list of roles for a content constraint. A constraint can state which data is present or which content is allowed for the constraint attachment. Allowed: The constraint contains the allowed values for attachable object. Actual: The constraints contains the actual data present for the attachable object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "Allowed", "Actual" ]
            ],
      "_js2n__-:definitions/CubeRegionKeyType!predicate"
        | doc "CubeRegionKeyType is a type for providing a set of values for a dimension for the purpose of defining a data cube region. A set of distinct value can be provided, or if this dimension is represented as time, and time range can be specified."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "timeRange" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "values" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.not
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "timeRange", "values" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SingleNCNameIDType!predicate",
                  include = _js2n__-prdslib.isType '"Bool",
                  removePrefix = _js2n__-prdslib.isType '"Bool",
                  timeRange =
                    _js2n__-refsenv."_js2n__-:definitions/TimeRangeValueType!predicate",
                  validFrom =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  validTo =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SimpleComponentValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CubeRegionType!predicate"
        | doc "CubeRegionType defines the structure of a data cube region. This is based on the abstract RegionType and simply refines the key and attribute values to conform with what is applicable for dimensions and attributes, respectively. See the documentation of the base type for more details on how a region is defined."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      components =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ComponentValueSetType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      include = _js2n__-prdslib.isType '"Bool",
                      keyValues =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CubeRegionKeyType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CustomTypeSchemeReferenceType!predicate"
        | doc "CustomTypeSchemeReferenceType is a type for referencing a custom type scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.transformation\\.CustomTypeScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/CustomTypeSchemeType!predicate"
        | doc "CustomTypeSchemeType defines a collection of custom types that are used in transformations. Unless the artefact is returned as a stub, it must contain the 'vtlVersion' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      customTypes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CustomTypeType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      vtlVersion = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/CustomTypeType!predicate"
        | doc "CustomTypeType defines the structure of a custom type. A custom type specifies a custom conversion for a VTL scalar type to a resulting data type. This conversion overrides the default conversion."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "dataType", "id", "vtlScalarType" ],
                      _js2n__-prdslib.records.record
                        {
                          dataType =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-refsenv."_js2n__-:definitions/SimpleDataType!predicate"
                                ],
                          nullValue = _js2n__-prdslib.isType '"String",
                          outputFormat = _js2n__-prdslib.isType '"String",
                          vtlLiteralFormat = _js2n__-prdslib.isType '"String",
                          vtlScalarType = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/DataComponentValueSetType!predicate"
        | doc "DataComponentValueSetType defines the structure for providing values for a data attributes, measures, or metadata attributes. If no values are provided, the component is implied to include/excluded from the region in which it is defined, with no regard to the value of the component. Note that for metadata attributes which occur within other metadata attributes, a nested identifier can be provided. For example, a value of CONTACT.ADDRESS.STREET refers to the metadata attribute with the identifier STREET which exists in the ADDRESS metadata attribute in the CONTACT metadata attribute, which is defined at the root of the report structure."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "timeRange" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "values" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.not
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "timeRange", "values" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                  include = _js2n__-prdslib.isType '"Bool",
                  removePrefix = _js2n__-prdslib.isType '"Bool",
                  timeRange =
                    _js2n__-refsenv."_js2n__-:definitions/TimeRangeValueType!predicate",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DataComponentValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DataComponentValueType!predicate"
        | doc "DataComponentValueType derives from the SimpleComponentValueType, but does not allow for validity dates."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "value" ],
                  _js2n__-prdslib.records.record
                    {
                      cascadeValues =
                        _js2n__-refsenv."_js2n__-:definitions/CascadeSelectionType!predicate",
                      lang =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$"
                            ],
                      value = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DataConstraintAttachmentType!predicate"
        | doc "DataConstraintAttachmentType describes a collection of references to constrainable artefacts related to data."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dataProvider" ],
                      _js2n__-prdslib.records.record
                        {
                          dataProvider =
                            _js2n__-refsenv."_js2n__-:definitions/DataProviderReferenceType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "simpleDataSources" ],
                      _js2n__-prdslib.records.record
                        {
                          simpleDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dataStructures" ],
                      _js2n__-prdslib.records.record
                        {
                          dataStructures =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/DataStructureReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          queryableDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/QueryableDataSourceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dataflows" ],
                      _js2n__-prdslib.records.record
                        {
                          dataflows =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/DataflowReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          queryableDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/QueryableDataSourceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "provisionAgreements" ],
                      _js2n__-prdslib.records.record
                        {
                          provisionAgreements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/ProvisionAgreementReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          queryableDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/QueryableDataSourceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/DataConstraintType!predicate"
        | doc "DataConstraintType defines the structure of a data constraint. A data constraint can specify either the available set of keys (DataKeySet) or set of component values (CubeRegion) in a data source, or the allowable keys that can be constructed from a data structure definition. Multiple such constraints may be present for a constrained artefact. For instance, there may be a constraing that specifies the values allowed for the data source (role is 'Allowed') which can be used for validation or for constructing a partial code list, whilst another constraing can specify the actual content of a data source (role is 'Actual'). Unless the artefact is returned as a stub, it must contain the 'role' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      constraintAttachment =
                        _js2n__-refsenv."_js2n__-:definitions/DataConstraintAttachmentType!predicate",
                      cubeRegions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CubeRegionType!predicate",
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      dataKeySets =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DataKeySetType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      releaseCalendar =
                        _js2n__-refsenv."_js2n__-:definitions/ReleaseCalendarType!predicate",
                      role =
                        _js2n__-refsenv."_js2n__-:definitions/ConstraintRoleType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DataConsumerSchemeType!predicate"
        | doc "DataConsumerSchemeType defines a type of organisation scheme which contains only data consumers. The data consumer scheme maintained by a particular maintenance agency is always provided a fixed identifier and version, and is never final. Therefore, consumers can be added or removed without have to version the scheme. This scheme has no hierarchy, meaning that no organisation may define a relationship with another organisation in the scheme."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableWithoutVersionType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      dataConsumers =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DataConsumerType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      id = _js2n__-prdslib.const "DATA_CONSUMERS",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DataConsumerType!predicate"
        | doc "DataConsumerType defines the structure of a data consumer description. The contacts defined for the organisation are specific to the data consumer role the organisation is serving."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          contacts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/DataKeySetType!predicate"
        | doc "DataKeySetType defines a collection of full or partial data keys (dimension values)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "isIncluded", "keys" ],
              _js2n__-prdslib.records.record
                {
                  isIncluded = _js2n__-prdslib.isType '"Bool",
                  keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DataKeyType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DataKeyType!predicate"
        | doc "DataKeyType is a region which defines a distinct full or partial data key. The key consists of a set of values, each referencing a dimension and providing a single value for that dimension. The purpose of the key is to define a subset of a data set (i.e. the observed value and data attribute) which have the dimension values provided in this definition. Any dimension not stated explicitly in this key is assumed to be wild carded, thus allowing for the definition of partial data keys."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/AnnotationsType!predicate",
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DataComponentValueSetType!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  include = _js2n__-prdslib.const true,
                  keyValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/DataKeyValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 0
                        ],
                  validFrom =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  validTo =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DataKeyValueType!predicate"
        | doc "DataKeyValueType is a type for providing a dimension value for the purpose of defining a distinct data key. Only a single value can be provided for the dimension."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "value" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SingleNCNameIDType!predicate",
                  include = _js2n__-prdslib.isType '"Bool",
                  removePrefix = _js2n__-prdslib.isType '"Bool",
                  value =
                    _js2n__-refsenv."_js2n__-:definitions/SimpleKeyValueType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DataProviderReferenceType!predicate"
        | doc "DataProviderReferenceType is a type for referencing a data provider. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.base\\.DataProvider=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):DATA_PROVIDERS\\(1\\.0\\)(\\.[A-Za-z0-9_@$-]+)$"
            ],
      "_js2n__-:definitions/DataProviderSchemeType!predicate"
        | doc "DataProviderSchemeType defines a type of organisation scheme which contains only data providers. The data provider scheme maintained by a particular maintenance agency is always provided a fixed identifier and version, and is never final. Therefore, providers can be added or removed without have to version the scheme. This scheme has no hierarchy, meaning that no organisation may define a relationship with another organisation in the scheme."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableWithoutVersionType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      dataProviders =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DataProviderType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      id = _js2n__-prdslib.const "DATA_PROVIDERS",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DataProviderType!predicate"
        | doc "DataProviderType defines the structure of a data provider description. The contacts defined for the organisation are specific to the data provider role the organisation is serving."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          contacts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/DataStructureComponentsType!predicate"
        | doc "DataStructureComponentsType describes the structure of the grouping to the sets of components that have a defined structural role in the data structure definition. At a minimum at least one dimension must be defined."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dimensionList" ],
              _js2n__-prdslib.records.record
                {
                  attributeList =
                    _js2n__-refsenv."_js2n__-:definitions/AttributeListType!predicate",
                  dimensionList =
                    _js2n__-refsenv."_js2n__-:definitions/DimensionListType!predicate",
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/GroupType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  measureList =
                    _js2n__-refsenv."_js2n__-:definitions/MeasureListType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DataStructureReferenceType!predicate"
        | doc "DataStructureReferenceType is a type for referencing a data structure definition object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.datastructure\\.DataStructure=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/DataStructureType!predicate"
        | doc "DataStructureType defines the structure for a data structure definition. A data structure definition is defined as a collection of metadata concepts, their structure and usage when used to collect or disseminate data."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      dataStructureComponents =
                        _js2n__-refsenv."_js2n__-:definitions/DataStructureComponentsType!predicate",
                      metadata =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataStructureReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DataType!predicate"
        | doc "DataTypeType provides an enumerated list of the types of data formats allowed as the for the representation of an object."
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
                  "GeospatialInformation",
                  "XHTML",
                  "KeyValues",
                  "IdentifiableReference",
                  "DataSetReference"
                ]
            ],
      "_js2n__-:definitions/DataflowReferenceType!predicate"
        | doc "DataflowReferenceType is a type for referencing a dataflow object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.datastructure\\.Dataflow=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/DataflowType!predicate"
        | doc "DataflowType describes the structure of a data flow. A data flow is defined as the structure of data that will provided for different reference periods. If this type is not referenced externally, then a reference to a data structure definition must be provided."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      structure =
                        _js2n__-refsenv."_js2n__-:definitions/DataStructureReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DateMapType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "mappedComponents" ],
                      _js2n__-prdslib.records.record
                        {
                          mappedComponents =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "source", "target" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            source =
                                              _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                                            target =
                                              _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ]),
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          resolvePeriod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "startOfPeriod",
                                      "endOfPeriod",
                                      "midPeriod"
                                    ]
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "frequencyDimension" ],
                          _js2n__-prdslib.records.record
                            {
                              frequencyDimension =
                                _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                              mappedFrequencies =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                                      _js2n__-prdslib.arrays.minItems 1
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "targetFrequencyID" ],
                          _js2n__-prdslib.records.record
                            {
                              targetFrequencyID =
                                _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ]
                ]
            ],
      "_js2n__-:definitions/DatePatternMapType!predicate"
        | doc "..."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/DateMapType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "locale", "sourcePattern" ],
                      _js2n__-prdslib.records.record
                        {
                          locale = _js2n__-prdslib.isType '"String",
                          sourcePattern = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/DimensionListType!predicate"
        | doc "DimensionListType describes the key descriptor for a data structure definition. The order of the declaration of child dimensions is significant: it is used to describe the order in which they will appear in data formats for which key values are supplied in an ordered fashion (exclusive of the time dimension, which is not represented as a member of the ordered key). Any data structure definition which uses the time dimension should also declare a frequency dimension, conventionally the first dimension in the key (the set of ordered non-time dimensions). If is not necessary to assign a time dimension, as data can be organised in any fashion required."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.const "DimensionDescriptor",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      dimensions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DimensionType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      timeDimension =
                        _js2n__-refsenv."_js2n__-:definitions/TimeDimensionType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/DimensionType!predicate"
        | doc "DimensionType describes the structure of an ordinary dimension, which is defined as a statistical concept used (most probably together with other statistical concepts) to identify a statistical series, such as a time series, e.g. a statistical concept indicating certain economic activity or a geographical reference area. The dimension takes its semantic, and in some cases it representation, from its concept identity. A dimension can be coded by referencing a code list from its coded local representation. It can also specify its text format, which is used as the representation of the dimension if a coded representation is not defined. Neither the coded or uncoded representation are necessary, since the dimension may take these from the referenced concept."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      conceptIdentity =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                      conceptRoles =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      localRepresentation =
                        _js2n__-refsenv."_js2n__-:definitions/SimpleDataStructureRepresentationType!predicate",
                      position =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "conceptIdentity" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/EmptyType!predicate"
        | doc "EmptyType is an empty complex type for elements where the presence of the tag indicates all that is necessary."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/EpochMapType!predicate"
        | doc "..."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/DateMapType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "basePeriod", "epochPeriod" ],
                      _js2n__-prdslib.records.record
                        {
                          basePeriod = _js2n__-prdslib.isType '"String",
                          epochPeriod =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [
                                      "nanosecond",
                                      "millisecond",
                                      "microsecond",
                                      "second",
                                      "day"
                                    ]
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/FixedValueMapType!predicate"
        | doc "FixedValueMapType defines the structure for providing a fixed value for a source or target component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "source" ],
                          _js2n__-prdslib.records.record
                            {
                              source =
                                _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "target" ],
                          _js2n__-prdslib.records.record
                            {
                              target =
                                _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.records.record
                    {
                      values =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/FrequencyFormatMappingType!predicate"
        | doc "..."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "datePattern", "frequencyId" ],
                      _js2n__-prdslib.records.record
                        {
                          datePattern = _js2n__-prdslib.isType '"String",
                          frequencyId =
                            _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/FromVtlMappingType!predicate"
        | doc "FromVtlMappingType defines the mapping method and filter used when mapping from VTL to SDMX."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fromVtlSuperSpace =
                    _js2n__-refsenv."_js2n__-:definitions/SpaceKeyType!predicate",
                  method =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Basic",
                          _js2n__-prdslib.const "Unpivot",
                          _js2n__-prdslib.const "M2A"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GeoGridCodelistType!predicate"
        | doc "GeoGridCodelistType defines the structure of a geographic grid code list. These define a geographical grid composed of cells representing regular squared portions of the Earth. Unless the artefact is returned as a stub, it must contain the 'geoType' and 'gridDefinition' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      codelistExtensions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CodelistExtensionType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      geoGridCodes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CodeType!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "geoCell" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            geoCell =
                                              _js2n__-prdslib.isType '"String",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      geoType = _js2n__-prdslib.const "GeoGridCodelist",
                      gridDefinition = _js2n__-prdslib.isType '"String",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/GeographicCodelistType!predicate"
        | doc "GeographicCodelistType defines the sturcture of a geographic codelist. It comprises a set of GeoFeatureSetCodes, by adding a value in the Code that follows a pattern to represent a geo feature set. Unless the artefact is returned as a stub, it must contain the 'geoType' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      codelistExtensions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/CodelistExtensionType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      geoFeatureSetCodes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/CodeType!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "value" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            value =
                                              _js2n__-prdslib.isType '"String",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      geoType = _js2n__-prdslib.const "GeographicCodelist",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/GroupType!predicate"
        | doc "GroupType describes the structure of a group descriptor in a data structure definition. A group may consist of a of partial key, or collection of distinct cube regions or key sets to which attributes may be attached. The purpose of a group is to specify attributes values which have the same value based on some common dimensionality. All groups declared in the data structure must be unique - that is, you may not have duplicate partial keys. All groups must be given unique identifiers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      groupDimensions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/NCNameIDType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HierarchicalCodeType!predicate"
        | doc "HierarchicalCodeType describes the structure of a hierarchical code. A hierarchical code provides for a reference to a code that is referenced within the hierarchical code list via either a complete reference to a code through either a URN or full set of reference fields. Codes are arranged in a hierarchy by this reference. Note that it is possible to reference a single code such that it has multiple parents within the hierarchy. Further, the hierarchy may or may not be a leveled one."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      code =
                        _js2n__-refsenv."_js2n__-:definitions/CodeReferenceType!predicate",
                      hierarchicalCodes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/HierarchicalCodeType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      level =
                        _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                      validFrom = _js2n__-prdslib.isType '"String",
                      validTo = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "code", "id" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HierarchyAssociationType!predicate"
        | doc "HierarchyAssociationType defines the structure of a hiearchy association, which links a hierarchy with and identifiable object in the context of another object (e.g. a dimension within the context of a dataflow). Unless the artefact is returned as a stub, it must contain the 'linkedHierarchy' and 'linkedObject' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      contextObject =
                        _js2n__-refsenv."_js2n__-:definitions/urn!predicate",
                      linkedHierarchy =
                        _js2n__-refsenv."_js2n__-:definitions/HierarchyReferenceType!predicate",
                      linkedObject =
                        _js2n__-refsenv."_js2n__-:definitions/urn!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/HierarchyReferenceType!predicate"
        | doc "HierarchyReferenceType is a type for referencing a hierarchy object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.codelist\\.Hierarchy=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/HierarchyType!predicate"
        | doc "The Hierarchy is an abstract type that provides for a classification structure of referenced codes arranged in levels of detail from the broadest to the most detailed level. The levels in which the code exist can be formal or informal. Unless the artefact is returned as a stub, it must contain the 'hierarchicalCodes' and 'hasFormalLevels' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      hasFormalLevels = _js2n__-prdslib.isType '"Bool",
                      hierarchicalCodes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/HierarchicalCodeType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      level =
                        _js2n__-refsenv."_js2n__-:definitions/LevelType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/IdentifiableType!predicate"
        | doc "IdentifiableType is an abstract base type for all identifiable objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    {
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate"
                ]
            ],
      "_js2n__-:definitions/IdentifiableTypeWithNCNameID!predicate"
        | doc "IdentifiableType is an abstract base type for all identifiable objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    {
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/NCNameIDType!predicate",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate"
                ]
            ],
      "_js2n__-:definitions/InputOutputType!predicate"
        | doc "InputOutputType describes the structure of an input or output to a process step. It provides a reference to the object that is the input or output."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "objectReference" ],
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/AnnotationsType!predicate",
                  localID =
                    _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                  objectReference =
                    _js2n__-refsenv."_js2n__-:definitions/urn!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/LevelType!predicate"
        | doc "LevelType describes a level in a hierarchical codelist. Where level is defined as a group where codes can be characterised by homogeneous coding, and where the parent of each code in the group is at the same higher level of the hierarchy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          codingFormat =
                            _js2n__-refsenv."_js2n__-:definitions/CodingTextFormatType!predicate",
                          level =
                            _js2n__-refsenv."_js2n__-:definitions/LevelType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/MaintainableType!predicate"
        | doc "MaintainableType is an abstract base type for all maintainable objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      agencyID =
                        _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                      isExternalReference = _js2n__-prdslib.isType '"Bool",
                      validFrom = _js2n__-prdslib.isType '"String",
                      validTo = _js2n__-prdslib.isType '"String",
                      version =
                        _js2n__-refsenv."_js2n__-:definitions/VersionType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "agencyID", "id", "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate"
        | doc "MaintainableType is an abstract base type for all maintainable objects with NCNameID."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    {
                      agencyID =
                        _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                      version =
                        _js2n__-refsenv."_js2n__-:definitions/VersionType!predicate",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/NameableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      isExternalReference = _js2n__-prdslib.isType '"Bool",
                      validFrom = _js2n__-prdslib.isType '"String",
                      validTo = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "agencyID", "id", "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MaintainableWithoutVersionType!predicate"
        | doc "MaintainableWithoutVersionType is an abstract base type for all maintainable objects without version (and fixed id). For the moment, the version number is fixed to '1.0'"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      agencyID =
                        _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                      descriptions =
                        _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                      isExternalReference = _js2n__-prdslib.isType '"Bool",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                      names =
                        _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                      validFrom = _js2n__-prdslib.isType '"String",
                      validTo = _js2n__-prdslib.isType '"String",
                      version = _js2n__-prdslib.const "1.0",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "agencyID", "id", "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MappedValueType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "value" ],
              _js2n__-prdslib.records.record
                {
                  endIndex = _js2n__-prdslib.isType 'Integer,
                  isRegEx = _js2n__-prdslib.isType '"Bool",
                  startIndex = _js2n__-prdslib.isType 'Integer,
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MeasureListType!predicate"
        | doc "MeasureListType describes the structure of the measure descriptor for a data structure definition."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.const "MeasureDescriptor",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      measures =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MeasureType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MeasureRepresentationType!predicate"
        | doc "MeasureRepresentationType defines the representation for a measure. A measure can be text (including XHTML and multi-lingual values), a simple value, or an enumerated value."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "enumeration" ],
                      _js2n__-prdslib.records.record
                        {
                          enumeration =
                            _js2n__-refsenv."_js2n__-:definitions/AnyCodelistReferenceType!predicate",
                          enumerationFormat =
                            _js2n__-refsenv."_js2n__-:definitions/CodedTextFormatType!predicate",
                          maxOccurs =
                            _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                          minOccurs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        {
                          format =
                            _js2n__-refsenv."_js2n__-:definitions/BasicComponentTextFormatType!predicate",
                          maxOccurs =
                            _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                          minOccurs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/MeasureType!predicate"
        | doc "MeasureType defines the structure of a measure descriptor. In addition to the identifying concept and representation, a mandatory usage and max occurs can be defined."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      conceptIdentity =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                      conceptRoles =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      localRepresentation =
                        _js2n__-refsenv."_js2n__-:definitions/MeasureRepresentationType!predicate",
                      usage =
                        _js2n__-refsenv."_js2n__-:definitions/UsageType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "conceptIdentity" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MemberValueType!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "value" ],
                  _js2n__-prdslib.records.record
                    {
                      cascadeValues =
                        _js2n__-refsenv."_js2n__-:definitions/CascadeSelectionType!predicate",
                      value =
                        _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataAttributeListType!predicate"
        | doc "MetadataAttributeListType describes the structure of a meta data attribute list. It comprises a set of metadata attributes that can be defined as a hierarchy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.const "MetadataAttributeDescriptor",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                      metadataAttributes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MetadataAttributeType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "metadataAttributes" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MetadataAttributeRepresentationType!predicate"
        | doc "MetadataAttributeRepresentationType defines the possible local representations of a metadata attribute."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "enumeration" ],
                      _js2n__-prdslib.records.record
                        {
                          enumeration =
                            _js2n__-refsenv."_js2n__-:definitions/CodelistReferenceType!predicate",
                          enumerationFormat =
                            _js2n__-refsenv."_js2n__-:definitions/CodedTextFormatType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        {
                          format =
                            _js2n__-refsenv."_js2n__-:definitions/BasicComponentTextFormatType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/MetadataAttributeType!predicate"
        | doc "MetadataAttributeType describes the structure of a metadata attribute. The metadata attribute takes its semantic, and in some cases it representation, from its concept identity. A metadata attribute may be coded (via the local representation), uncoded (via the text format), or take no value. In addition to this value, the metadata attribute may also specify subordinate metadata attributes. If a metadata attribute only serves the purpose of containing subordinate metadata attributes, then the isPresentational attribute should be used. Otherwise, it is assumed to also take a value. If the metadata attribute does take a value, and a representation is not defined, it will be inherited from the concept it takes its semantic from. The optional id on the metadata attribute uniquely identifies it within the metadata structured definition. If this id is not supplied, its value is assumed to be that of the concept referenced from the concept identity. Note that a metadata attribute (as identified by the id attribute) definition  must be unique across the entire metadata structure definition (including target identifier, identifier component, and report structure ids). A metadata attribute may be used in multiple report structures and at different levels, but the content (value and/or child metadata attributes and their cardinality) of the metadata attribute cannot change."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      conceptIdentity =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                      isPresentational = _js2n__-prdslib.isType '"Bool",
                      localRepresentation =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataAttributeRepresentationType!predicate",
                      maxOccurs =
                        _js2n__-refsenv."_js2n__-:definitions/OccurenceType!predicate",
                      metadataAttributes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MetadataAttributeType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      minOccurs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "conceptIdentity" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MetadataAttributeUsageType!predicate"
        | doc "MetadataAttributeUsageType defines the structure of how a metadata attribute is used in a data structure. This is a local reference to a metadata attribute from the metadata structure referenced by the data structure. An attribute relationship can be defined in order to describe the relationship of the metadata attribute to the data structure components."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      attributeRelationship =
                        _js2n__-refsenv."_js2n__-:definitions/AttributeRelationshipType!predicate",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                      metadataAttributeReference =
                        _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required
                [ "attributeRelationship", "metadataAttributeReference" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MetadataAttributeValueSetType!predicate"
        | doc "MetadataAttributeValueSetType defines the structure for providing values for a metadata attribute. If no values are provided, the attribute is implied to include/excluded from the region in which it is defined, with no regard to the value of the metadata attribute."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "timeRange" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "values" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.not
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "timeRange", "values" ],
                    _js2n__-prdslib.records.record {} {} true
                      _js2n__-prdslib.always
                  ]),
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/NestedNCNameIDType!predicate",
                  include = _js2n__-prdslib.isType '"Bool",
                  removePrefix = _js2n__-prdslib.isType '"Bool",
                  timeRange =
                    _js2n__-refsenv."_js2n__-:definitions/TimeRangeValueType!predicate",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SimpleComponentValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MetadataConstraintAttachmentType!predicate"
        | doc "MetadataConstraintAttachmentType restricts the base ConstraintAttachmentType to only allow artefacts related to metadata."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "metadataProvider" ],
                      _js2n__-prdslib.records.record
                        {
                          metadataProvider =
                            _js2n__-refsenv."_js2n__-:definitions/MetadataProviderReferenceType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "metadataSets" ],
                      _js2n__-prdslib.records.record
                        {
                          metadataSets =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/MetadataSetReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "simpleDataSources" ],
                      _js2n__-prdslib.records.record
                        {
                          simpleDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "metadataStructures" ],
                      _js2n__-prdslib.records.record
                        {
                          metadataStructures =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/MetadataStructureReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          queryableDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/QueryableDataSourceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "metadataflows" ],
                      _js2n__-prdslib.records.record
                        {
                          metadataflows =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/MetadataflowReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          queryableDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/QueryableDataSourceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "metadataProvisionAgreements" ],
                      _js2n__-prdslib.records.record
                        {
                          metadataProvisionAgreements =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/MetadataProvisionAgreementReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          queryableDataSources =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/QueryableDataSourceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/MetadataConstraintType!predicate"
        | doc "MetadataConstraintType defines the structure of a metadata constraint, which specifies a sub set of the definition of the allowable content of a metadata set. A metadata constraint can specify allowed attribute values for metadata described by the constrained artefact. The constraint attachment is restricted to constrainable artefacts related to metadata, and the only possible role is 'Allowed'. Unless the artefact is returned as a stub, it must contain the 'role' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      constraintAttachment =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataConstraintAttachmentType!predicate",
                      metadataTargetRegions =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MetadataTargetRegionType!predicate",
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      releaseCalendar =
                        _js2n__-refsenv."_js2n__-:definitions/ReleaseCalendarType!predicate",
                      role = _js2n__-prdslib.const "Allowed",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataProviderReferenceType!predicate"
        | doc "MetadataProviderReferenceType is a type for referencing a metadata provider. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.base\\.MetadataProvider=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):METADATA_PROVIDERS\\(1\\.0\\)(\\.[A-Za-z0-9_@$-]+)$"
            ],
      "_js2n__-:definitions/MetadataProviderSchemeType!predicate"
        | doc "MetadataProviderSchemeType defines a type of organisation scheme which contains only metadata providers. The metadata provider scheme maintained by a particular maintenance agency is always provided a fixed identifier and is never versioned. Therefore, providers can be added or removed without have to version the scheme. This scheme has no hierarchy, meaning that no organisation may define a relationship with another organisation in the scheme."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableWithoutVersionType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.const "METADATA_PROVIDERS",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      metadataProviders =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MetadataProviderType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataProviderType!predicate"
        | doc "MetadataProviderType defines the structure of a metadata provider description. The contacts defined for the organisation are specific to the metadata provider role the organisation is serving."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          contacts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
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
      "_js2n__-:definitions/MetadataProvisionAgreementType!predicate"
        | doc "MetadataProvisionAgreementType describes the structure of a metadata provision agreement. A metadata provision agreement defines an agreement for a metadata provider to report reference metadata against a metadataflow. Attributes which describe how the registry must behave when metadata is registered against this metadata provision agreement are supplied. Unless the artefact is returned as a stub, it must contain the 'metadataflow' and 'dataProvider' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      metadataProvider =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataProviderReferenceType!predicate",
                      metadataflow =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataflowReferenceType!predicate",
                      targets =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WildcardObjectReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataSetReferenceType!predicate"
        | doc "MetadataSetReferenceType is a type for referencing a metadata set. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.metadatastructure\\.MetadataSet=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/MetadataStructureComponentsType!predicate"
        | doc "MetadataStructureComponentsType describes the structure of one set of components, the metadata attribute list, that make up the metadata structure definition. At a minimum, at least one metadata attribute must be defined."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  metadataAttributeList =
                    _js2n__-refsenv."_js2n__-:definitions/MetadataAttributeListType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MetadataStructureReferenceType!predicate"
        | doc "MetadataStructureReferenceType is a type for referencing a metadata structure definition object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.metadatastructure\\.MetadataStructure=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/MetadataStructureType!predicate"
        | doc "MetadataStructureType is used to describe a metadata structure definition, which is defined as a collection of metadata concepts, their structure and usage when used to collect or disseminate reference metadata."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      metadataStructureComponents =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataStructureComponentsType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataTargetRegionType!predicate"
        | doc "MetadataTargetRegionType defines the structure of a metadata target region. A metadata target region must define the report structure and the metadata target from that structure on which the region is based. This type is based on the abstract RegionType and simply refines the key and attribute values to conform with what is applicable for target objects and metadata attributes, respectively. See the documentation of the base type for more details on how a region is defined."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      components =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MetadataAttributeValueSetType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      include = _js2n__-prdslib.isType '"Bool",
                      validFrom =
                        _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                      validTo =
                        _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/MetadataflowReferenceType!predicate"
        | doc "MetadataflowReferenceType is a type for referencing a metadata flow object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.metadatastructure\\.Metadataflow=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/MetadataflowType!predicate"
        | doc "MetadataflowType describes the structure of a metadata flow. A dataflow is defined as the structure of reference metadata that will be provided for different reference periods. If this type is not referenced externally, then a reference to a metadata structure definition must be provided. Unless the artefact is returned as a stub, it must contain the 'targets' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      structure =
                        _js2n__-refsenv."_js2n__-:definitions/MetadataStructureReferenceType!predicate",
                      targets =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/WildcardObjectReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/NCNameIDType!predicate"
        | doc "NCNameIDType restricts the IDType, so that the id may be used to generate valid XML components. IDs created from this type conform to the W3C XML Schema NCNAME type, and therefore can be used as element or attribute names."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z][A-Za-z0-9_-]*$"
            ],
      "_js2n__-:definitions/NamePersonalisationSchemeReferenceType!predicate"
        | doc "NamePersonalisationSchemeReferenceType is a type for referencing a name personalisation scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.transformation\\.NamePersonalisationScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/NamePersonalisationSchemeType!predicate"
        | doc "NamePersonalisationSchemeType defines a set of personalisations of VTL standard names that are used in a set of transformations. Unless the artefact is returned as a stub, it must contain the 'vtlVersion' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      namePersonalisations =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/NamePersonalisationType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      vtlVersion = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/NamePersonalisationType!predicate"
        | doc "NamePersonalisationType defines the structure of a name personalisation. A name personalisation is is used in place of a standard VTL name in some VTL operations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [
                          "id",
                          "personalisedName",
                          "vtlArtefact",
                          "vtlDefaultName"
                        ],
                      _js2n__-prdslib.records.record
                        {
                          personalisedName = _js2n__-prdslib.isType '"String",
                          vtlArtefact = _js2n__-prdslib.isType '"String",
                          vtlDefaultName = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/NameableType!predicate"
        | doc "NameableType is an abstract base type for all nameable objects."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableType!predicate",
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
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/NameableTypeWithNCNameID!predicate"
        | doc "NameableType is an abstract base type for all nameable objects with NCNameID."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableTypeWithNCNameID!predicate",
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
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/NestedIDType!predicate"
        | doc "NestedIDType is the least restrictive form of an identifier used throughout all SDMX-ML messages. It allows for a hierarchical identifier, with each portion separated by the '.' character. For the identifier portions, valid characters include A-Z, a-z, @, 0-9, _, -, $."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[A-Za-z0-9_@$-]+(\\.[A-Za-z0-9_@$-]+)*$"
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
      "_js2n__-:definitions/OccurenceType!predicate"
        | doc "OccurenceType is used to express the maximum occurrence of an object. It combines an integer, greater than 1, and the literal text, \"unbounded\", for objects which have no upper limit on its occurrence."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 1
                ],
              _js2n__-prdslib.const "unbounded"
            ],
      "_js2n__-:definitions/OrganisationSchemeMapType!predicate"
        | doc "OrganisationSchemeMapType defines the structure of a map which identifies relationships between organisations in different organisation schemes. Unless the artefact is returned as a stub, it must contain the 'source' and 'target' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      itemMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SingleValueMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/OrganisationSchemeReferenceType!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/OrganisationSchemeReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/OrganisationSchemeReferenceType!predicate"
        | doc "OrganisationSchemeReferenceType references an organisation scheme regardless of the specific type. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((base\\.((AgencyScheme)|(DataConsumerScheme)|(DataProviderScheme)|(MetadataProviderScheme)|(OrganisationUnitScheme))))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/OrganisationUnitSchemeType!predicate"
        | doc "OrganisationUnitSchemeType defines a type of organisation scheme which simply defines organisations and there parent child relationships. Organisations in this scheme are assigned no particular role, and may in fact exist within the other type of organisation schemes as well."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableWithoutVersionType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      organisationUnits =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/OrganisationUnitType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/OrganisationUnitType!predicate"
        | doc "OrganisationUnitType defines the structure of an organisation unit description. In addition to general identification and contact information, an organisation unit can specify a relationship with another organisation unit from the same scheme which is its parent organisation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          contacts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          parent =
                            _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ProcessStepType!predicate"
        | doc "ProcessStepType describes the structure of a process step. A nested process step is automatically sub-ordinate, and followed as the next step. If the following step is conditional, it should be referenced in a transition."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          computation =
                            _js2n__-refsenv."_js2n__-:definitions/ComputationType!predicate",
                          inputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/InputOutputType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          outputs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/InputOutputType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          processSteps =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/ProcessStepType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          transitions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/TransitionType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ProcessType!predicate"
        | doc "ProcessType describes the structure of a process, which is a scheme which defines or documents the operations performed on data in order to validate data or to derive new information according to a given set of rules. Processes occur in order, and will continue in order unless a transition dictates another step should occur."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      processSteps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ProcessStepType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ProvisionAgreementReferenceType!predicate"
        | doc "ProvisionAgreementReferenceType is a type for referencing a provision agreement. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.registry\\.ProvisionAgreement=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/ProvisionAgreementType!predicate"
        | doc "ProvisionAgreementType describes the structure of a provision agreement. A provision agreement defines an agreement for a data provider to report data against a dataflow. Attributes which describe how the registry must behave when data is registered against this provision agreement are supplied. Unless the artefact is returned as a stub, it must contain the 'dataflow' and 'dataProvider' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      dataProvider =
                        _js2n__-refsenv."_js2n__-:definitions/DataProviderReferenceType!predicate",
                      dataflow =
                        _js2n__-refsenv."_js2n__-:definitions/DataflowReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/QueryableDataSourceType!predicate"
        | doc "QueryableDataSourceType describes a data source which accepts an standard SDMX Query message and responds appropriately."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "dataURL", "isRESTDatasource", "isWebServiceDatasource" ],
              _js2n__-prdslib.records.record
                {
                  dataURL =
                    _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                  isRESTDatasource = _js2n__-prdslib.isType '"Bool",
                  isWebServiceDatasource = _js2n__-prdslib.isType '"Bool",
                  wadlURL =
                    _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                  wsdlURL =
                    _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ReleaseCalendarType!predicate"
        | doc "ReleaseCalendarType describes information about the timing of releases of the constrained data. All of these values use the standard \"P7D\" - style format."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "offset", "periodicity", "tolerance" ],
              _js2n__-prdslib.records.record
                {
                  offset = _js2n__-prdslib.isType '"String",
                  periodicity = _js2n__-prdslib.isType '"String",
                  tolerance = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ReportingCategoryType!predicate"
        | doc "ReportingCategoryType describes the structure of a reporting category, which groups structure usages into useful sub-packages. Sub ordinate reporting categories can be nested within the category definition."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required
                                [ "structuralMetadata" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required
                                [ "provisioningMetadata" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ]
                        ],
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.records.required
                              [ "provisioningMetadata", "structuralMetadata" ],
                            _js2n__-prdslib.records.record {} {} true
                              _js2n__-prdslib.always
                          ]),
                      _js2n__-prdslib.records.required [ "id" ],
                      _js2n__-prdslib.records.record
                        {
                          provisioningMetadata =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/StructureUsageReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                          reportingCategories =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/ReportingCategoryType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1
                                ],
                          structuralMetadata =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/StructureReferenceType!predicate",
                                  _js2n__-prdslib.arrays.minItems 1,
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ReportingTaxonomyMapType!predicate"
        | doc "ReportingTaxonomyMapType defines the structure of a map which identifies relationships between reporting categories in different reporting taxonomies. Unless the artefact is returned as a stub, it must contain the 'source' and 'target' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      itemMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/SingleValueMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/ReportingTaxonomyReferenceType!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/ReportingTaxonomyReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ReportingTaxonomyReferenceType!predicate"
        | doc "ReportingTaxonomyReferenceType is a type for referencing a reporting taxonomy object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.categoryscheme\\.ReportingTaxonomy=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/ReportingTaxonomyType!predicate"
        | doc "ReportingTaxonomyType describes the structure of a reporting taxonomy, which is a scheme which defines the composition structure of a data report where each component can be described by an independent structure or structure usage description."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      reportingCategories =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ReportingCategoryType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ReportingTimePeriodType!predicate"
        | doc "ReportingTimePeriodType defines standard reporting periods in SDMX, which are all in relation to the start day (day-month) of a reporting year which is specified in the specialized reporting year start day attribute. If the reporting year start day is not defined, a day of January 1 is assumed. The reporting year must be epxressed as the year at the beginning of the period. Therfore, if the reproting year runs from April to March, any given reporting year is expressed as the year for April. The general format of a report period can be described as  [year]-[period][time zone]?, where the type of period is designated with a single character followed by a number representing the period. Note that all periods allow for an optional time zone offset. See the details of each member type for the specifics of its format. It can be one one the following sub-types: (1) ReportingYearType defines a time period of 1 year (P1Y) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. In this case a reporting year will coincide with a calendar year. The format of a reporting year is YYYY-A1 (e.g. 2000-A1). Note that the period value of 1 is fixed. (2) ReportingSemesterType defines a time period of 6 months (P6M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting semester is YYYY-Ss (e.g. 2000-S1), where s is either 1 or 2. (3) ReportingTrimesterType defines a time period of 4 months (P4M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting trimester is YYYY-Tt (e.g. 2000-T1), where s is either 1, 2, or 3. (4) ReportingQuarterType defines a time period of 3 months (P3M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting quarter is YYYY-Qq (e.g. 2000-Q1), where q is a value between 1 and 4. (5) ReportingMonthType defines a time period of 1 month (P1M) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. In this case a reporting month will coincide with a calendar month. The format of a reporting month is YYYY-Mmm (e.g. 2000-M01), where mm is a two digit month (i.e. 01-12). (6) ReportingWeekType defines a time period of 7 days (P7D) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. A standard reporting week is based on the ISO 8601 defintion of a week date, in relation to the reporting period start day. The first week is defined as the week with the first Thursday on or after the reporting year start day. An equivalent definition is the week starting with the Monday nearest in time to the reporting year start day. There are other equivalent defintions, all of which should be adjusted based on the reporting year start day. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting week is YYYY-Www (e.g. 2000-W01), where mm is a two digit week (i.e. 01-53). (7) ReportingDayType defines a time period of 1 day (P1D) in relation to a reporting year which has a start day (day-month) specified in the specialized reporting year start day attribute. In the absence of a start day for the reporting year, a day of January 1 is assumed. The format of a reporting day is YYYY-Dddd (e.g. 2000-D001), where ddd is a three digit day (i.e. 001-366)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^\\d{4}\\-([ASTQ]\\d{1}|[MW]\\d{2}|[D]\\d{3})(Z|((\\+|\\-)\\d{2}:\\d{2}))?$"
            ],
      "_js2n__-:definitions/ReportingYearStartOrEndDayRepresentationType!predicate"
        | doc "ReportingYearStartOrEndDayRepresentationType defines the representation for the reporting year start/end day attribute. Enumerated values are not allowed and the text format is fixed to be a day and month in the ISO 8601 format of '--MM-DD'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "format", "maxOccurs" ],
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/ReportingYearStartOrEndDayTextFormatType!predicate",
                  maxOccurs = _js2n__-prdslib.const 1,
                  minOccurs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 1,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ReportingYearStartOrEndDayTextFormatType!predicate"
        | doc "ReportingYearStartOrEndDayTextFormatType is a restricted version of the NonFacetedTextFormatType that fixes the value of the text type to be MonthDay. This type exists solely for the purpose of fixing the representation of the reporting year start/end day attribute."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dataType" ],
              _js2n__-prdslib.records.record
                { dataType = _js2n__-prdslib.const "MonthDay", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ReportingYearStartOrEndDayType!predicate"
        | doc "ReportingYearStartOrEndDayType defines the structure of the reporting year start or end day attribute. The reporting year start/end day attribute takes its semantic from its concept identity (usually the REPORTING_YEAR_START_DAY or REPORTING_YEAR_END_DAY concepts), yet always has a fixed identifier (REPORTING_YEAR_START_DAY, REPORTING_YEAR_END_DAY). The reporting year start/end day attribute always has a fixed text format, which specifies that the format of its value is always a day and month in the ISO 8601 format of '--MM-DD'. As with any other attribute, an attribute relationship must be specified. This relationship should be carefully selected as it will determine what type of data the data structure definition will allow. For example, if an attribute relationship of `dataflow` is specified, this will mean the data sets for this dataflow can only contain data with standard reporting periods where the all reporting periods have the same start/end day. In this case, data reported as standard reporting periods from two entities with different fiscal year start/end days could not be contained in the same data set."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      attributeRelationship =
                        _js2n__-refsenv."_js2n__-:definitions/AttributeRelationshipType!predicate",
                      conceptIdentity =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                      conceptRoles =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      id =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "REPORTING_YEAR_START_DAY",
                                  "REPORTING_YEAR_END_DAY"
                                ]
                            ],
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                      localRepresentation =
                        _js2n__-refsenv."_js2n__-:definitions/ReportingYearStartOrEndDayRepresentationType!predicate",
                      measureRelationship =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/NCNameIDType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      usage =
                        _js2n__-refsenv."_js2n__-:definitions/UsageType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required
                [
                  "attributeRelationship",
                  "conceptIdentity",
                  "id",
                  "localRepresentation"
                ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/RepresentationMapReferenceType!predicate"
        | doc "RepresentationMapReferenceType is a type for referencing a representation map object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.structuremapping\\.RepresentationMap=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/RepresentationMapType!predicate"
        | doc "RepresentationMapType describes ...  Unless the artefact is returned as a stub, it must contain the 'source' and 'target' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      representationMappings =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ValueMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      source =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "codelist" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "dataType" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ]
                                      ],
                                    _js2n__-prdslib.records.record
                                      {
                                        codelist =
                                          _js2n__-refsenv."_js2n__-:definitions/AnyCodelistReferenceType!predicate",
                                        dataType =
                                          _js2n__-refsenv."_js2n__-:definitions/DataType!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      target =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "codelist" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "dataType" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ]
                                      ],
                                    _js2n__-prdslib.records.record
                                      {
                                        codelist =
                                          _js2n__-refsenv."_js2n__-:definitions/AnyCodelistReferenceType!predicate",
                                        dataType =
                                          _js2n__-refsenv."_js2n__-:definitions/DataType!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/RulesetSchemeReferenceType!predicate"
        | doc "RulesetSchemeReferenceType is a type for referencing a ruleset scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.transformation\\.RulesetScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/RulesetSchemeType!predicate"
        | doc "RulesetSchemeType defines a collection of rulesets that are used in transformations. Unless the artefact is returned as a stub, it must contain the 'vtlVersion' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      rulesets =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/RulesetType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      vtlMappingScheme =
                        _js2n__-refsenv."_js2n__-:definitions/VtlMappingSchemeReferenceType!predicate",
                      vtlVersion = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/RulesetType!predicate"
        | doc "RulesetType defines the structure of a ruleset. A ruleset is a persistent set of rules which can be invoked by using appropriate VTL operators."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [
                          "id",
                          "rulesetDefinition",
                          "rulesetScope",
                          "rulesetType"
                        ],
                      _js2n__-prdslib.records.record
                        {
                          rulesetDefinition = _js2n__-prdslib.isType '"String",
                          rulesetScope = _js2n__-prdslib.isType '"String",
                          rulesetType = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/SimpleCodeDataType!predicate"
        | doc "SimpleCodeDataType restricts SimpleDataType to specify the allowable data types for a simple code. The possible values are simply Alpha, AlphaNumeric, or Numeric."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "Alpha", "AlphaNumeric", "Numeric" ]
            ],
      "_js2n__-:definitions/SimpleComponentTextFormatType!predicate"
        | doc "SimpleComponentTextFormatType is a restricted version of the BasicComponentTextFormatType that does not allow for multi-lingual values."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/SimpleDataType!predicate",
                  decimals =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  endTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  endValue = _js2n__-prdslib.isType '"Number",
                  interval = _js2n__-prdslib.isType 'Integer,
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
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/sentinelValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  startTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  startValue = _js2n__-prdslib.isType '"Number",
                  timeInterval =
                    _js2n__-refsenv."_js2n__-:definitions/duration!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SimpleComponentValueType!predicate"
        | doc "SimpleComponentValueType contains a simple value for a component, and if that value is from a code list, the ability to indicate that child codes in a simple hierarchy are part of the value set of the component for the region."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "value" ],
                  _js2n__-prdslib.records.record
                    {
                      cascadeValues =
                        _js2n__-refsenv."_js2n__-:definitions/CascadeSelectionType!predicate",
                      lang =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$"
                            ],
                      validFrom =
                        _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                      validTo =
                        _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                      value = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/SimpleDataStructureRepresentationType!predicate"
        | doc "SimpleDataStructureRepresentationType defines the representation for any non-time dimension data structure definition component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "enumeration" ],
                      _js2n__-prdslib.records.record
                        {
                          enumeration =
                            _js2n__-refsenv."_js2n__-:definitions/CodelistReferenceType!predicate",
                          enumerationFormat =
                            _js2n__-refsenv."_js2n__-:definitions/CodedTextFormatType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        {
                          format =
                            _js2n__-refsenv."_js2n__-:definitions/SimpleComponentTextFormatType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/SimpleDataType!predicate"
        | doc "SimpleDataType restricts BasicComponentDataType to specify the allowable data types for a data structure definition component. The XHTML representation is removed as a possible type."
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
      "_js2n__-:definitions/SimpleKeyValueType!predicate"
        | doc "SimpleKeyValueType derives from the SimpleComponentValueType, but does not allow for the cascading of value in the hierarchy, as keys are meant to describe a distinct full or partial key."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SingleNCNameIDType!predicate"
        | doc "SingleNCNameIDType restricts the NestedNCNameIDType to allow only one level. Note that this is the same pattern as the NCNameIDType, but can be used when the base type to be restricted is a nested NCNameIDType (where as the NCNameIDType could only restrict the IDType)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z][A-Za-z0-9_-]*$"
            ],
      "_js2n__-:definitions/SingleValueMappingType!predicate"
        | doc "SingleValueMappingType defines a mapping with a single source and optional target."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      sourceValue =
                        _js2n__-refsenv."_js2n__-:definitions/MappedValueType!predicate",
                      targetValue = _js2n__-prdslib.isType '"String",
                      validFrom = _js2n__-prdslib.isType '"String",
                      validTo = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "sourceValue" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpaceKeyType!predicate"
        | doc "SpaceKey defines the structure of a super- or sub- space for a SDMX Dataflow. It is a collection of references to the dimensions that make up the space."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SingleNCNameIDType!predicate",
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                } {} true _js2n__-prdslib.always
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
              _js2n__-refsenv."_js2n__-:definitions/ReportingTimePeriodType!predicate"
            ],
      "_js2n__-:definitions/StructureMapType!predicate"
        | doc "StructureMapType defines the structure for mapping components of one structure to components of another structure. A structure may be referenced directly meaning the map applies wherever the structure is used, or it may be a reference via a structure usage meaning the map only applies within the context of that usage. Using the related structures, one can make extrapolations between maps. For example, if key families, A, B, and C, are all grouped in a related structures container, then a map from data structure A to C and a map from data structure B to C could be used to infer a relation between data structure A to C. Unless the artefact is returned as a stub, it must contain the 'source', 'target' and 'componentMaps' properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      componentMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ComponentMapType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      datePatternMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DatePatternMapType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      epochMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/EpochMapType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      fixedValueMaps =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/FixedValueMapType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      frequencyFormatMappings =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/FrequencyFormatMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/StructureOrUsageReferenceType!predicate",
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/StructureOrUsageReferenceType!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/StructureOrUsageReferenceType!predicate"
        | doc "StructureOrUsageReferenceType is a specific type of a reference for referencing either a structure or a structure usage. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((datastructure\\.((DataStructure)|(Dataflow)))|(metadatastructure\\.((MetadataStructure)|(Metadataflow))))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/StructureReferenceType!predicate"
        | doc "StructureReferenceType is a specific type of MaintainableReference that is used for referencing any structure. It consists of a URN and/or a complete set of reference fields; agency, id, and version."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((datastructure\\.DataStructure)|(metadatastructure\\.MetadataStructure))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/StructureUsageReferenceType!predicate"
        | doc "StructureUsageReferenceType is a specific type of MaintainableReference that is used for referencing any structure usages. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((datastructure\\.Dataflow)|(metadatastructure\\.Metadataflow))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/TimeDataType!predicate"
        | doc "TimeDataType restricts SimpleDataType to specify the allowable data types for representing a time value."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
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
                  "TimeRange"
                ]
            ],
      "_js2n__-:definitions/TimeDimensionRepresentationType!predicate"
        | doc "TimeDimensionRepresentationType defines the representation for the time dimension. Enumerated values are not allowed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "format" ],
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/TimeTextFormatType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TimeDimensionType!predicate"
        | doc "TimeDimensionType describes the structure of a time dimension. The time dimension takes its semantic from its concept identity (usually the TIME_PERIOD concept), yet is always has a fixed identifier (TIME_PERIOD). The time dimension always has a fixed text format, which specifies that its format is always the in the value set of the observational time period (see common:ObservationalTimePeriodType). It is possible that the format may be a sub-set of the observational time period value set. For example, it is possible to state that the representation might always be a calendar year. See the enumerations of the dataType attribute in the LocalRepresentation/format for more details of the possible sub-sets. It is also possible to facet this representation with start and end dates. The purpose of such facts is to restrict the value of the time dimension to occur within the specified range. If the time dimension is expected to allow for the standard reporting periods (see common:ReportingTimePeriodType) to be used, then it is strongly recommended that the reporting year start day attribute also be included in the data structure definition. When the reporting year start day attribute is used, any standard reporting period values will be assumed to be based on the start day contained in this attribute. If the reporting year start day attribute is not included and standard reporting periods are used, these values will be assumed to be based on a reporting year which begins January 1."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.record
                    {
                      id = _js2n__-prdslib.const "TIME_PERIOD",
                      links =
                        _js2n__-refsenv."_js2n__-:definitions/links!predicate",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      conceptIdentity =
                        _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                      localRepresentation =
                        _js2n__-refsenv."_js2n__-:definitions/TimeDimensionRepresentationType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required
                [ "conceptIdentity", "localRepresentation" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TimePeriodRangeType!predicate"
        | doc "TimePeriodRangeType defines a time period, and indicates whether it is inclusive in a range."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "period" ],
              _js2n__-prdslib.records.record
                {
                  isInclusive = _js2n__-prdslib.isType '"Bool",
                  period =
                    _js2n__-refsenv."_js2n__-:definitions/ObservationalTimePeriodType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TimeRangeValueType!predicate"
        | doc "TimeRangeValueType allows a time period value to be expressed as a range. It can be expressed as the period before a period, after a period, or between two periods. Each of these properties can specify their inclusion in regards to the range."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "afterPeriod" ],
                      _js2n__-prdslib.records.record
                        {
                          afterPeriod =
                            _js2n__-refsenv."_js2n__-:definitions/TimePeriodRangeType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "beforePeriod" ],
                      _js2n__-prdslib.records.record
                        {
                          beforePeriod =
                            _js2n__-refsenv."_js2n__-:definitions/TimePeriodRangeType!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "endPeriod", "startPeriod" ],
                      _js2n__-prdslib.records.record
                        {
                          endPeriod =
                            _js2n__-refsenv."_js2n__-:definitions/TimePeriodRangeType!predicate",
                          startPeriod =
                            _js2n__-refsenv."_js2n__-:definitions/TimePeriodRangeType!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/TimeTextFormatType!predicate"
        | doc "TimeTextFormat is a restricted version of the SimpleComponentTextFormatType that only allows time based format and specifies a default ObservationalTimePeriod representation and facets of a start and end time."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/TimeDataType!predicate",
                  endTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                  sentinelValues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/sentinelValueType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  startTime =
                    _js2n__-refsenv."_js2n__-:definitions/StandardTimePeriodType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ToVtlMappingType!predicate"
        | doc "ToVtlMappingType defines the mapping method and filter used when mapping from SDMX to VTL."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  method =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Basic",
                          _js2n__-prdslib.const "Pivot",
                          _js2n__-prdslib.const "Basic-A2M",
                          _js2n__-prdslib.const "Pivot-A2M"
                        ],
                  toVtlSubSpace =
                    _js2n__-refsenv."_js2n__-:definitions/SpaceKeyType!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TransformationSchemeType!predicate"
        | doc "TransformationSchemeType describes the structure of a transformation scheme. A transformation scheme contains a set of transformations to be executed together (in the same run). It can contain any number of transformations that produce any number of results. Unless the artefact is returned as a stub, it must contain the 'vtlVersion' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      customTypeScheme =
                        _js2n__-refsenv."_js2n__-:definitions/CustomTypeSchemeReferenceType!predicate",
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      namePersonalisationScheme =
                        _js2n__-refsenv."_js2n__-:definitions/NamePersonalisationSchemeReferenceType!predicate",
                      rulesetSchemes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/RulesetSchemeReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      transformations =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/TransformationType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      userDefinedOperatorSchemes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/UserDefinedOperatorSchemeReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      vtlMappingScheme =
                        _js2n__-refsenv."_js2n__-:definitions/VtlMappingSchemeReferenceType!predicate",
                      vtlVersion = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/TransformationType!predicate"
        | doc "TransformationType defines the structure of a transformation. A transformation is an assignment of a VTL expression to a specific result."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "expression", "id", "isPersistent", "result" ],
                      _js2n__-prdslib.records.record
                        {
                          expression = _js2n__-prdslib.isType '"String",
                          isPersistent = _js2n__-prdslib.isType '"Bool",
                          result = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/TransitionType!predicate"
        | doc "TransitionType describes the details of a transition, which is an expression in a textual or formalised way of the transformation of data between two specific operations performed on the data."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/IdentifiableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      condition =
                        _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                      conditions =
                        _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                      localID =
                        _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
                      targetStep =
                        _js2n__-refsenv."_js2n__-:definitions/NestedIDType!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "condition", "targetStep" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/UsageType!predicate"
        | doc "An enumeration of optional | mandatory to indicate the usage of an attribute or measure."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "mandatory", "optional" ]
            ],
      "_js2n__-:definitions/UserDefinedOperatorSchemeReferenceType!predicate"
        | doc "UserDefinedOperatorSchemeReferenceType is a type for referencing a user defined operator scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.transformation\\.UserDefinedOperatorScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/UserDefinedOperatorSchemeType!predicate"
        | doc "UserDefinedOperatorSchemeType defines a collection of user defined operators that are used in transformations. Unless the artefact is returned as a stub, it must contain the 'vtlVersion' property."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      rulesetSchemes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/RulesetSchemeReferenceType!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                      userDefinedOperators =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/UserDefinedOperatorType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      vtlMappingScheme =
                        _js2n__-refsenv."_js2n__-:definitions/VtlMappingSchemeReferenceType!predicate",
                      vtlVersion = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/UserDefinedOperatorType!predicate"
        | doc "UserDefinedOperatorType defines the structure of a user defined operator. A user defined operator is a custom VTL operator (not existing in the standard library) that extends the VTL standard library for specific purposes. In addition to its identification and name, and definition of the operator must be provided."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "id", "operatorDefinition" ],
                      _js2n__-prdslib.records.record
                        {
                          operatorDefinition = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/ValueListType!predicate"
        | doc "ValueListType defines the structure of value list. These represent a closed set of values the can occur for a dimension, measure, or attribute. These may be values, or values with names and descriptions (similar to a codelist)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableTypeWithNCNameID!predicate",
                  _js2n__-prdslib.records.record
                    {
                      valueItems =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "id" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            description =
                                              _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                                            descriptions =
                                              _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                                            id =
                                              _js2n__-prdslib.isType '"String",
                                            name =
                                              _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!predicate",
                                            names =
                                              _js2n__-refsenv."_js2n__-:definitions/localisedText!predicate",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ValueMappingType!predicate"
        | doc "ValueMappingType defines a mapping of multiple sources to multiple targets."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/AnnotableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      sourceValues =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/MappedValueType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      targetValues =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                      validFrom = _js2n__-prdslib.isType '"String",
                      validTo = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "sourceValues" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/VersionType!predicate"
        | doc "VersionType is used to communicate version information. The format is restricted to allow for simple incrementing and sorting of version number. The version consists of an unlimited set of numeric components, separated by the '.' character. When processing version, each numeric component (the number preceding and following any '.' character) should be parsed as an integer. Thus, a version of 1.3 and 1.03 would be equivalent, as both the '3' component and the '03' component would parse to an integer value of 3."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.strings.pattern
                    "^(0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?$",
                  _js2n__-prdslib.strings.pattern
                    "^(0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?$"
                ]
            ],
      "_js2n__-:definitions/VtlMappingSchemeReferenceType!predicate"
        | doc "VtlMappingSchemeReferenceType is a type for referencing a VTL mapping scheme object. It consists of a URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.transformation\\.VtlMappingScheme=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)$"
            ],
      "_js2n__-:definitions/VtlMappingSchemeType!predicate"
        | doc "VtlMappingSchemeType defines a set of mappings between SDMX and VTL."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/MaintainableType!predicate",
                  _js2n__-prdslib.records.record
                    {
                      isPartial = _js2n__-prdslib.isType '"Bool",
                      vtlMappings =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/VtlMappingType!predicate",
                              _js2n__-prdslib.arrays.minItems 1
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/VtlMappingType!predicate"
        | doc "VtlMappingType defines the structure of a single mapping between the reference to a SDMX artefact made from VTL transformations, rulesets, user defined operators and the corresponding SDMX structure identifier. These are used to assign an alternative names to SDMX Dataflows, Codelists, Concept Schemes, or Concepts. Although are distinct sub-classes in the Information Model, this structure serves to express them all. The references SDMX artefact serves to distinguish which type of sub-class (VtlDatflowMapping or VtlCodelistMapping, or VtlConceptMapping) is being described. When this is used to assign an alias for a SDMX Dataflow, this can also be used to indicate the methods used to convert the data structure from SDMX to VTL and vice-versa. Finally, this can be used to override the deault Basic mapping methods used for Dataflows by utilizing the GenericDataflow element in place of a reference to a specific Dataflow."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/NameableType!predicate",
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "dataflow" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      dataflow =
                                        _js2n__-refsenv."_js2n__-:definitions/DataflowReferenceType!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "genericDataflow" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      genericDataflow =
                                        _js2n__-refsenv."_js2n__-:definitions/EmptyType!predicate",
                                    } {} true _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.records.record
                            {
                              fromVtlMapping =
                                _js2n__-refsenv."_js2n__-:definitions/FromVtlMappingType!predicate",
                              toVtlMapping =
                                _js2n__-refsenv."_js2n__-:definitions/ToVtlMappingType!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "codelist" ],
                          _js2n__-prdslib.records.record
                            {
                              codelist =
                                _js2n__-refsenv."_js2n__-:definitions/CodelistReferenceType!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "concept" ],
                          _js2n__-prdslib.records.record
                            {
                              concept =
                                _js2n__-refsenv."_js2n__-:definitions/ConceptReferenceType!predicate",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "alias", "id" ],
                      _js2n__-prdslib.records.record
                        { alias = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/WildcardObjectReferenceType!predicate"
        | doc "WildcardObjectReferenceType is a generic URN reference which allows for any object to be referenced with the ability to wildcard certain parts of the identifier. The type of object actually referenced can be determined from the URN."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((base\\.((Any)|(Agency)|(OrganisationUnitScheme)|(AgencyScheme)|(DataProviderScheme)|(MetadataProviderScheme)|(DataConsumerScheme)|(OrganisationUnit)|(DataProvider)|(MetadataProvider)|(DataConsumer)))|(codelist\\.((Any)|(Codelist)|(Valuelist)|(Hierarchy)|(HierarchyAssociation)|(Code)|(HierarchicalCode)|(Level)))|(conceptscheme\\.((Any)|(ConceptScheme)|(Concept)))|(datastructure\\.((Any)|(DataStructure)|(AttributeDescriptor)|(DataAttribute)|(GroupDimensionDescriptor)|(DimensionDescriptor)|(Dimension)|(TimeDimension)|(MeasureDescriptor)|(Measure)|(Dataflow)))|(categoryscheme\\.((Any)|(CategoryScheme)|(Category)|(Categorisation)|(ReportingTaxonomy)|(ReportingCategory)))|(registry\\.((Any)|(ProvisionAgreement)|(MetadataProvisionAgreement)|(DataConstraint)|(MetadataConstraint)|(Subscription)))|(metadatastructure\\.((Any)|(MetadataAttributeDescriptor)|(MetadataAttribute)|(MetadataStructure)|(Metadataflow)))|(process\\.((Any)|(Process)|(ProcessStep)|(Transition)))|(structuremapping\\.((Any)|(StructureMap)|(ComponentMap)|(EpochMap)|(DatePatternMap)|(ConceptSchemeMap)|(OrganisationSchemeMap)|(CategorySchemeMap)|(ReportingTaxonomyMap)|(RepresentationMap)|(FrequencyFormatMapping)))|(transformation\\.((Any)|(TransformationScheme)|(Transformation)|(CustomTypeScheme)|(CustomType)|(NamePersonalisationScheme)|(NamePersonalisation)|(VtlMappingScheme)|(VtlCodelistMapping)|(VtlConceptMapping)|(VtlDataflowMapping)|(RulesetScheme)|(Ruleset)|(UserDefinedOperatorScheme)|(UserDefinedOperator))))=(([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*)|(\\*)):(([A-Za-z0-9_@$-]+)|(\\*))\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+))|(\\*))\\)((((\\.[A-Za-z0-9_@$-]+)*)|(\\.\\*))(((\\.[A-Za-z0-9_@$-]+)*)|(\\.\\*)))?$"
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
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  faxes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  id = _js2n__-refsenv."_js2n__-:definitions/idType!predicate",
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
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  uris =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/uri!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  x400s =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/duration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^P((([0-9]+Y([0-9]+M)?([0-9]+D)?|([0-9]+M)([0-9]+D)?|([0-9]+D))(T(([0-9]+H)([0-9]+M)?([0-9]+(\\.[0-9]+)?S)?|([0-9]+M)([0-9]+(\\.[0-9]+)?S)?|([0-9]+(\\.[0-9]+)?S)))?)|(T(([0-9]+H)([0-9]+M)?([0-9]+(\\.[0-9]+)?S)?|([0-9]+M)([0-9]+(\\.[0-9]+)?S)?|([0-9]+(\\.[0-9]+)?S))))$"
            ],
      "_js2n__-:definitions/idType!predicate"
        | doc "IDType provides a type which is used for restricting the characters in codes and IDs throughout all SDMX-ML messages. Valid characters include A-Z, a-z, @, 0-9, _, -, $. Regex: [A-Za-z0-9_@$-]+"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_@$-]+$"
            ],
      "_js2n__-:definitions/links!contract"
        | doc "Links field is an array of link objects. If appropriate, a collection of links to additional resources, including external resources."
        = Array (
            _js2n__-prdslib.contract_from_predicate
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
                                      "agency",
                                      "agencyscheme",
                                      "attributedescriptor",
                                      "alternate",
                                      "appendix",
                                      "bookmark",
                                      "categorisation",
                                      "category",
                                      "categoryscheme",
                                      "categoryschememap",
                                      "chapter",
                                      "code",
                                      "codelist",
                                      "componentmap",
                                      "concept",
                                      "conceptscheme",
                                      "conceptschememap",
                                      "constraint",
                                      "contents",
                                      "copyright",
                                      "current",
                                      "customtype",
                                      "customtypescheme",
                                      "dataattribute",
                                      "dataconstraint",
                                      "dataconsumer",
                                      "dataconsumerscheme",
                                      "dataflow",
                                      "dataprovider",
                                      "dataproviderscheme",
                                      "datastructure",
                                      "datastructuredefinition",
                                      "datepatternmap",
                                      "describedby",
                                      "dimension",
                                      "dimensiondescriptor",
                                      "edit",
                                      "edit-media",
                                      "enclosure",
                                      "epochmap",
                                      "first",
                                      "frequencyformatmapping",
                                      "glossary",
                                      "groupdimesiondescriptor",
                                      "help",
                                      "hierarchicalcode",
                                      "hierarchy",
                                      "hierarchyassociation",
                                      "hub",
                                      "index",
                                      "itemschememap",
                                      "last",
                                      "latest-version",
                                      "license",
                                      "level",
                                      "measure",
                                      "measuredescriptor",
                                      "metadataattribute",
                                      "metadataconstraint",
                                      "metadataflow",
                                      "metadataproviderscheme",
                                      "metadataprovisionagreement",
                                      "metadataprovider",
                                      "metadatastructure",
                                      "metadatastructuredefinition",
                                      "namepersonalisation",
                                      "namepersonalisatinscheme",
                                      "next",
                                      "next-archive",
                                      "organisationschememap",
                                      "organisationunit",
                                      "organisationunitscheme",
                                      "payment",
                                      "prev",
                                      "predecessor-version",
                                      "previous",
                                      "prev-archive",
                                      "process",
                                      "processstep",
                                      "provisionagreement",
                                      "related",
                                      "replies",
                                      "reportingcategory",
                                      "reportingtaxonomy",
                                      "reportingtaxonomymap",
                                      "metadataattributedescriptor",
                                      "representatiomap",
                                      "ruleset",
                                      "rulesetscheme",
                                      "section",
                                      "self",
                                      "service",
                                      "start",
                                      "structure",
                                      "structuremap",
                                      "stylesheet",
                                      "subscription",
                                      "subsection",
                                      "successor-version",
                                      "timedimension",
                                      "transformation",
                                      "transformationscheme",
                                      "transition",
                                      "userdefinedoperator",
                                      "userdefinedoperatorscheme",
                                      "up",
                                      "valuelist",
                                      "version-history",
                                      "via",
                                      "vtlcodelistmapping",
                                      "vtlconceptmapping",
                                      "vtldataflowmapping",
                                      "vtlmappingscheme",
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
          ),
      "_js2n__-:definitions/links!predicate"
        | doc "Links field is an array of link objects. If appropriate, a collection of links to additional resources, including external resources."
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
                                        "agency",
                                        "agencyscheme",
                                        "attributedescriptor",
                                        "alternate",
                                        "appendix",
                                        "bookmark",
                                        "categorisation",
                                        "category",
                                        "categoryscheme",
                                        "categoryschememap",
                                        "chapter",
                                        "code",
                                        "codelist",
                                        "componentmap",
                                        "concept",
                                        "conceptscheme",
                                        "conceptschememap",
                                        "constraint",
                                        "contents",
                                        "copyright",
                                        "current",
                                        "customtype",
                                        "customtypescheme",
                                        "dataattribute",
                                        "dataconstraint",
                                        "dataconsumer",
                                        "dataconsumerscheme",
                                        "dataflow",
                                        "dataprovider",
                                        "dataproviderscheme",
                                        "datastructure",
                                        "datastructuredefinition",
                                        "datepatternmap",
                                        "describedby",
                                        "dimension",
                                        "dimensiondescriptor",
                                        "edit",
                                        "edit-media",
                                        "enclosure",
                                        "epochmap",
                                        "first",
                                        "frequencyformatmapping",
                                        "glossary",
                                        "groupdimesiondescriptor",
                                        "help",
                                        "hierarchicalcode",
                                        "hierarchy",
                                        "hierarchyassociation",
                                        "hub",
                                        "index",
                                        "itemschememap",
                                        "last",
                                        "latest-version",
                                        "license",
                                        "level",
                                        "measure",
                                        "measuredescriptor",
                                        "metadataattribute",
                                        "metadataconstraint",
                                        "metadataflow",
                                        "metadataproviderscheme",
                                        "metadataprovisionagreement",
                                        "metadataprovider",
                                        "metadatastructure",
                                        "metadatastructuredefinition",
                                        "namepersonalisation",
                                        "namepersonalisatinscheme",
                                        "next",
                                        "next-archive",
                                        "organisationschememap",
                                        "organisationunit",
                                        "organisationunitscheme",
                                        "payment",
                                        "prev",
                                        "predecessor-version",
                                        "previous",
                                        "prev-archive",
                                        "process",
                                        "processstep",
                                        "provisionagreement",
                                        "related",
                                        "replies",
                                        "reportingcategory",
                                        "reportingtaxonomy",
                                        "reportingtaxonomymap",
                                        "metadataattributedescriptor",
                                        "representatiomap",
                                        "ruleset",
                                        "rulesetscheme",
                                        "section",
                                        "self",
                                        "service",
                                        "start",
                                        "structure",
                                        "structuremap",
                                        "stylesheet",
                                        "subscription",
                                        "subsection",
                                        "successor-version",
                                        "timedimension",
                                        "transformation",
                                        "transformationscheme",
                                        "transition",
                                        "userdefinedoperator",
                                        "userdefinedoperatorscheme",
                                        "up",
                                        "valuelist",
                                        "version-history",
                                        "via",
                                        "vtlcodelistmapping",
                                        "vtlconceptmapping",
                                        "vtldataflowmapping",
                                        "vtlmappingscheme",
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
      "_js2n__-:definitions/localisedBestMatchText!contract"
        | doc "localisedBestMatchText is a reusable element, used for providing a human-readable best-language-match texts."
        = String,
      "_js2n__-:definitions/localisedBestMatchText!predicate"
        | doc "localisedBestMatchText is a reusable element, used for providing a human-readable best-language-match texts."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/localisedText!contract"
        | doc "localisedText provides for a set of language-specific alternates to be provided for any human-readable constructs in the instance. "
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.record {}
                  {
                    "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$" =
                      _js2n__-prdslib.isType '"String",
                  } true _js2n__-prdslib.always
              ]),
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
      "_js2n__-:definitions/party!contract"
        | doc "Sender contains information about the party that is transmitting the message."
        = {
            contacts
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                    _js2n__-prdslib.arrays.minItems 1
                  ])
              | doc "Contact provides contact information for the party in regard to the transmission of the message."
              | optional,
            id
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_@$-]+$"
                  ])
              | doc "The id holds the identification of the party.",
            name
              | _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!contract"
              | doc "Name is a human-readable name of the party."
              | optional,
            names
              | _js2n__-refsenv."_js2n__-:definitions/localisedText!contract"
              | doc "Name is a human-readable name of the party."
              | optional,
            ..
          },
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
                            _js2n__-refsenv."_js2n__-:definitions/contactType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
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
      "_js2n__-:definitions/sentinelValueType!predicate"
        | doc "SentinelValueType defines the structure of a sentinel value. A sentinel is a value that has a special meaning within the text format representation of a component. The value is associated with a multi-lingual name and description."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "name", "value" ],
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
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Integer
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/uri!contract"
        | doc "Contains the URL to the schema allowing to validate the message. This also allows identifying the version of SDMX-JSON format used in this message. Providing the link to the SDMX-JSON schema is recommended."
        = String,
      "_js2n__-:definitions/uri!predicate"
        | doc "Contains the URL to the schema allowing to validate the message. This also allows identifying the version of SDMX-JSON format used in this message. Providing the link to the SDMX-JSON schema is recommended."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/urn!predicate"
        | doc "Universal Resource Name (URN) is constructed according to the generic structure 'urn:sdmx:org.SDMX-IM-package-name.class-name=agencyid:maintainedobject-id(maintainedobject-version).containerobject-id.object-id*'. For more information see: Unique identification of SDMX objects, in: SDMX STANDARDS: SECTION 5 SDMX REGISTRY SPECIFICATION"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^urn:sdmx:org\\.sdmx\\.infomodel\\.((base\\.((Agency)|(OrganisationUnitScheme)|(AgencyScheme)|(DataProviderScheme)|(MetadataProviderScheme)|(DataConsumerScheme)|(OrganisationUnit)|(DataProvider)|(MetadataProvider)|(DataConsumer)))|(codelist\\.((Codelist)|(Valuelist)|(Hierarchy)|(HierarchyAssociation)|(Code)|(HierarchicalCode)|(Level)))|(conceptscheme\\.((ConceptScheme)|(Concept)))|(datastructure\\.((DataStructure)|(AttributeDescriptor)|(DataAttribute)|(GroupDimensionDescriptor)|(DimensionDescriptor)|(Dimension)|(TimeDimension)|(MeasureDescriptor)|(Measure)|(Dataflow)))|(categoryscheme\\.((CategoryScheme)|(Category)|(Categorisation)|(ReportingTaxonomy)|(ReportingCategory)))|(registry\\.((ProvisionAgreement)|(MetadataProvisionAgreement)|(DataConstraint)|(MetadataConstraint)|(Subscription)))|(metadatastructure\\.((MetadataAttributeDescriptor)|(MetadataAttribute)|(MetadataStructure)|(Metadataflow)))|(process\\.((Process)|(ProcessStep)|(Transition)))|(structuremapping\\.((StructureMap)|(ComponentMap)|(EpochMap)|(DatePatternMap)|(ConceptSchemeMap)|(OrganisationSchemeMap)|(CategorySchemeMap)|(ReportingTaxonomyMap)|(RepresentationMap)|(FrequencyFormatMapping)))|(transformation\\.((TransformationScheme)|(Transformation)|(CustomTypeScheme)|(CustomType)|(NamePersonalisationScheme)|(NamePersonalisation)|(VtlMappingScheme)|(VtlCodelistMapping)|(VtlConceptMapping)|(VtlDataflowMapping)|(RulesetScheme)|(Ruleset)|(UserDefinedOperatorScheme)|(UserDefinedOperator))))=([A-Za-z][A-Za-z0-9_-]*(\\.[A-Za-z][A-Za-z0-9_-]*)*):([A-Za-z0-9_@$-]+)\\((((0|[1-9]\\d*)(\\.(0|[1-9]\\d*))?)|((0|[1-9]\\d*)(\\.(0|[1-9]\\d*)){2}(-(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*))(\\.(([A-Za-z-]|([A-Za-z-][A-Za-z0-9-]+)|([A-Za-z0-9-]+[A-Za-z-][A-Za-z0-9-]*))|(0|[1-9][0-9]*)))*)?)|(((0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+\\.(0|[1-9]\\d*))|((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\+)))\\)(\\.[A-Za-z0-9_@$-]+(\\.[A-Za-z0-9_@$-]+)*)?$"
            ],
    }
    in
  {
      data
        | {
          agencySchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/AgencySchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "agencySchemes contains a collection of agency scheme descriptions."
            | optional,
          categorisations
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/CategorisationType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "categorisations contains a collection of structural object categorisations. This container may contain categorisations for many types of objects. The categorisations may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          categorySchemeMaps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/CategorySchemeMapType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "categorySchemeMaps contains a collection of category scheme map descriptions. The category scheme maps may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          categorySchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/CategorySchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "categorySchemes contains a collection of category scheme descriptions. The category schemes may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          codelists
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/CodelistType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "codelists contains a collection of code list descriptions. The code lists may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          conceptSchemeMaps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ConceptSchemeMapType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "conceptSchemeMaps contains a collection of concept scheme map descriptions. The concept scheme maps may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          conceptSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ConceptSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "conceptSchemes contains one or more concept schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          customTypeSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/CustomTypeSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "customTypeSchemes contains one or more custom type schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          dataConstraints
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/DataConstraintType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "dataConstraints contains one or more data constraint, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          dataConsumerSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/DataConsumerSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "dataConsumerSchemes contains a collection of data consumer schemes descriptions."
            | optional,
          dataProviderSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/DataProviderSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "dataProviderSchemes contains a collection of data provider schemes descriptions."
            | optional,
          dataStructures
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/DataStructureType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "dataStructures contains a collection of data structure definitions. The data structure definitions may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          dataflows
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/DataflowType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "dataflows contains a collection of data flow descriptions. The data flows may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          geoGridCodelists
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/GeoGridCodelistType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "geoGridCodelists contains a collection of geographic grid code list descriptions. The geographic grid code lists may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          geographicCodelists
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/GeographicCodelistType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "geographicCodelists contains a collection of geographic code list descriptions. The geographic code lists may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          hierarchies
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/HierarchyType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "hierarchies contains a collection of hierarchies, which are hierarchical code list descriptions, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          hierarchyAssociations
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/HierarchyAssociationType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "hierarchyAssociations ontains a collection of hierarchy associations. The associations may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          metadataConstraints
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/MetadataConstraintType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "metadataConstraints contains one or more metadata constraint, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          metadataProviderSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/MetadataProviderSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "metadataProviderSchemes contains a collection of metadata provider schemes descriptions."
            | optional,
          metadataProvisionAgreements
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/MetadataProvisionAgreementType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "metadataProvisionAgreements contains a collection of metadata provision agreements. The metadata provision agreements may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          metadataStructures
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/MetadataStructureType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "metadataStructures contains a collection of metadata structure definition descriptions. The metadata structure definitions may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          metadataflows
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/MetadataflowType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "metadataflows contains a collection of metadata flow descriptions. The metadata flows may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          namePersonalisationSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/NamePersonalisationSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "namePersonalisationSchemes contains one or more name personalisation schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          organisationSchemeMaps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/OrganisationSchemeMapType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "organisationSchemeMaps contains a collection of organisation scheme map descriptions. The organisation scheme maps may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          organisationUnitSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/OrganisationUnitSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "organisationUnitSchemes contains a collection of organisation unit schemes descriptions."
            | optional,
          processes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ProcessType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "processes contains a collection of process descriptions. The processes may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          provisionAgreements
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ProvisionAgreementType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "provisionAgreements contains a collection of provision agreements. The provision agreements may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          reportingTaxonomies
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ReportingTaxonomyType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "reportingTaxonomies contains a collection of reporting taxonomy descriptions. The reporting taxonomies may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          reportingTaxonomyMaps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ReportingTaxonomyMapType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "reportingTaxonomyMaps contains a collection of reporting taxonomy map descriptions. The reporting taxonomy maps may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          representationMaps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/RepresentationMapType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "representationMaps contains a collection of representation map descriptions. The representation maps may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          rulesetSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/RulesetSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "rulesetSchemes contains one or more ruleset schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          structureMaps
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/StructureMapType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "structureMaps contains a collection of structure map descriptions. The structure maps may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          transformationSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/TransformationSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "transformationSchemes contains one or more transformation schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          userDefinedOperatorSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/UserDefinedOperatorSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "userDefinedOperatorSchemes contains one or more user defined operator schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          valueLists
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ValueListType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "valueLists contains a collection of value list descriptions. The value lists may be detailed in full, or referenced from an external structure document or registry service."
            | optional,
          vtlMappingSchemes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/VtlMappingSchemeType!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "vtlMappingSchemes contains one or more vtl mapping schemes, which can be explicitly detailed or referenced from an external structure document or registry service."
            | optional,
          ..
        }
        | doc "Data contains the message's “primary data”."
        | optional,
      errors
        | Array
          {
            code
              | Number
              | doc "Provides a code number for the error message. Code numbers are defined in the SDMX 2.1 Web Services Guidelines.",
            detail
              | _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!contract"
              | doc "Detail contains the detailed text of the message, in best-match language value. A human-readable localised explanation specific to this occurrence of the problem. Like title, this field’s value can be localized. It is fully customizable by the service providers and should provide enough detail to ease understanding the reasons of the error."
              | optional,
            details
              | _js2n__-refsenv."_js2n__-:definitions/localisedText!contract"
              | doc "Detail contains the detailed text of the message, in parallel language values. A list of human-readable localised explanations specific to this occurrence of the problem. Like title, this field’s value can be localized. It is fully customizable by the service providers and should provide enough detail to ease understanding the reasons of the error."
              | optional,
            links
              | _js2n__-refsenv."_js2n__-:definitions/links!contract"
              | doc "Links field is an array of link objects. If appropriate, a collection of links to additional external resources for the error."
              | optional,
            title
              | _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!contract"
              | doc "Title contains the title of the message, in best-match language value. A short, human-readable localised summary of the problem that SHOULD NOT change from occurrence to occurrence of the problem, except for purposes of localization."
              | optional,
            titles
              | _js2n__-refsenv."_js2n__-:definitions/localisedText!contract"
              | doc "Title contains the title of the message, in parallel language values. A list of short, human-readable localised summary of the problem that SHOULD NOT change from occurrence to occurrence of the problem, except for purposes of localization."
              | optional,
            ..
          }
        | doc "Errors field is an array of error objects. When appropriate provides a list of error messages in addition to RESTful web services HTTP error status codes."
        | optional,
      meta
        | {
          contentLanguages
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern
                          "^(?:(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))$|^((?:[a-z]{2,3}(?:(?:-[a-z]{3}){1,3})?)|[a-z]{4}|[a-z]{5,8})(?:-([a-z]{4}))?(?:-([a-z]{2}|[0-9]{3}))?((?:-(?:[0-9a-z]{5,8}|[0-9][0-9a-z]{3}))*)?((?:-[0-9a-wy-z](?:-[0-9a-z]{2,8})+)*)?(-x(?:-[0-9a-z]{1,8})+)?$|^(x(?:-[0-9a-z]{1,8})+)$"
                      ]),
                  _js2n__-prdslib.arrays.minItems 1,
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc "Array of strings containing the identifyer of all languages used anywhere in the message for localized elements, and thus the languages of the intended audience, representaing in an array format the same information than the http Content-Language response header, e.g. \"en, fr-fr\". See IETF Language Tags: https://tools.ietf.org/html/rfc5646#section-2.1. The array's first element indicates the main language used in the message for localized elements. The usage of this property is recommended."
            | optional,
          id
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_@$-]+$"
                ])
            | doc "Unique string assigned by the sender that identifies the message for further references.",
          links
            | _js2n__-refsenv."_js2n__-:definitions/links!contract"
            | optional,
          name
            | _js2n__-refsenv."_js2n__-:definitions/localisedBestMatchText!contract"
            | doc "Name provides a name for the transmission. Multiple instances allow for parallel language values."
            | optional,
          names
            | _js2n__-refsenv."_js2n__-:definitions/localisedText!contract"
            | doc "Name provides a name for the transmission. Multiple instances allow for parallel language values."
            | optional,
          prepared
            | String
            | doc "A timestamp indicating when the message was prepared. Values must follow the ISO 8601 syntax for combined dates and times, including time zone.",
          receivers
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/party!predicate",
                  _js2n__-prdslib.arrays.minItems 1
                ])
            | doc "Receiver is information about the part(y/ies) that is/are the intended recipient(s) of the message. This can be useful if the WS requires authentication."
            | optional,
          schema
            | _js2n__-refsenv."_js2n__-:definitions/uri!contract"
            | doc "Contains the URL to the schema allowing to validate the message. This also allows identifying the version of SDMX-JSON format used in this message. Providing the link to the SDMX-JSON schema is recommended."
            | optional,
          sender
            | _js2n__-refsenv."_js2n__-:definitions/party!contract"
            | doc "Sender is information about the party that is transmitting the message.",
          test
            | Bool
            | doc "Test indicates whether the message is for test purposes or not. False for normal messages."
            | optional,
          ..
        }
        | doc "A meta object that contains non-standard meta-information and basic technical information about the message, such as when it was prepared and who has sent it. Additional properties such as for 'copyright' information can be added."
        | optional,
      ..
    }