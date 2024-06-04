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
      "_js2n__-:definitions/Description!contract"
        | doc "Free text commenting on or summarizing this configuration. Optional"
        = String,
      "_js2n__-:definitions/FlexrayClusterParameters!contract" =
        {
            gColdstartAttempts
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 31,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Number of attempts for a cold start before giving up (range 2-31)"
              | optional,
            gCycleCountMax
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 63,
                    _js2n__-prdslib.numbers.minimum 7
                  ])
              | doc "Max cycle count value in a given cluster (range 7-63, must be an odd integer)"
              | optional,
            gListenNoise
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 16,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Upper limit for the startup listen timeout and wakeup listen timeout in the presence of noise; Used as a multiplier of pdListenTimeout (range 2 - 16)"
              | optional,
            gMacroPerCycle
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 16000,
                    _js2n__-prdslib.numbers.minimum 8
                  ])
              | doc "Number of macroticks per cycle (range 8 - 16000)"
              | optional,
            gMaxWithoutClockCorrectionFatal
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 15,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Threshold used for testing the vClockCorrectionFailed counter (range 1 - 15)"
              | optional,
            gMaxWithoutClockCorrectionPassive
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 15,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Threshold used for testing the vClockCorrectionFailed counter (range 1 - 15)"
              | optional,
            gNumberOfMiniSlots
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 7988,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Number of mini slots (range 0 - 7988)"
              | optional,
            gNumberOfStaticSlots
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1023,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Number of static slots in a cycle (range 2 - 1023)"
              | optional,
            gPayloadLengthStatic
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 127,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Length of the payload of a static frame in 16-Bits words (range 0 - 127)"
              | optional,
            gSyncFrameIDCountMax
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 15,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Maximum number of distinct sync frame identifiers present in a given cluster (range 2 - 15)"
              | optional,
            gdActionPointOffset
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 63,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Time offset for a static slot in macroticks (range 1 - 63)"
              | optional,
            gdDynamicSlotIdlePhase
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 2,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Duration of the idle phase within a dynamic slot in gdMiniSlots (range 0 - 2)"
              | optional,
            gdMiniSlot
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 63,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Duration of a mini slot in macroticks (2 - 63)"
              | optional,
            gdMiniSlotActionPointOffset
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 31,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Time offset for a mini slot in macroticks (range 1- 31)"
              | optional,
            gdStaticSlot
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 664,
                    _js2n__-prdslib.numbers.minimum 3
                  ])
              | doc "Duration of a static slot in macroticks (range 3 - 664)"
              | optional,
            gdSymbolWindow
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 162,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Duration of the symbol window in macroticks (range 0 - 162)"
              | optional,
            gdSymbolWindowActionPointOffset
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 63,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Time offset for a static symbol windows in macroticks (range 1 - 63)"
              | optional,
            gdTSSTransmitter
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 15,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Duration of TSS (Transmission Start Sequence) in gdBits (range 1 - 15)"
              | optional,
            gdWakeupTxActive
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 60,
                    _js2n__-prdslib.numbers.minimum 15
                  ])
              | doc "Duration of LOW Phase of a wakeup symbol in gdBit (range 15 - 60)"
              | optional,
            gdWakeupTxIdle
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 180,
                    _js2n__-prdslib.numbers.minimum 45
                  ])
              | doc "Duration of the idle of a wakeup symbol in gdBit (45 - 180)"
              | optional,
            ..
          },
      "_js2n__-:definitions/FlexrayController!contract" =
        {
            ClusterParameters
              | _js2n__-refsenv."_js2n__-:definitions/FlexrayClusterParameters!contract"
              | optional,
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            Network
              | _js2n__-refsenv."_js2n__-:definitions/Network!contract"
              | optional,
            NodeParameters
              | _js2n__-refsenv."_js2n__-:definitions/FlexrayNodeParameters!contract"
              | optional,
            Replay
              | _js2n__-refsenv."_js2n__-:definitions/Replay!contract"
              | optional,
            TxBufferConfigurations
              | _js2n__-refsenv."_js2n__-:definitions/FlexrayTxBufferConfigurations!contract"
              | optional,
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          },
      "_js2n__-:definitions/FlexrayControllers!contract"
        | doc "Reconfigures the FlexrayControllers of the participant"
        = Array
            _js2n__-refsenv."_js2n__-:definitions/FlexrayController!contract",
      "_js2n__-:definitions/FlexrayNodeParameters!contract" =
        {
            pAllowHaltDueToClock
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Controls the transition to halt state due to clock synchronization errors. (values 0, 1)"
              | optional,
            pAllowPassiveToActive
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 31,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Required number of consecutive even / odd cycle pairs for normal passive to normal active (range 0 - 31)"
              | optional,
            pChannels
              | std.enum.TagOrString
              | [| 'None, 'AB, 'B, 'A |]
              | doc "Channel(s) to which the controller is connected"
              | optional,
            pClusterDriftDamping
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 10,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Cluster drift damping factor for rate correction in microticks (range 0 - 10)"
              | optional,
            pKeySlotId
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1023,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Slot ID of the key slot (range 0 - 1023; value 0 means that there is no key slot)"
              | optional,
            pKeySlotOnlyEnabled
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Shall the node enter key slot only mode after startup. (values 0, 1) (AUTOSAR pSingleSlotEnabled)"
              | optional,
            pKeySlotUsedForStartup
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Key slot is used for startup (values 0, 1)"
              | optional,
            pKeySlotUsedForSync
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Key slot is used for sync (values 0, 1)"
              | optional,
            pLatestTx
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 7988,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Last mini slot which can be transmitted (range 0 - 7988)"
              | optional,
            pMacroInitialOffsetA
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 68,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Initial startup offset for frame reference point on channel A (range 2 - 68 macroticks)"
              | optional,
            pMacroInitialOffsetB
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 68,
                    _js2n__-prdslib.numbers.minimum 2
                  ])
              | doc "Initial startup offset for frame reference point on channel B (range 2 - 68 macroticks)"
              | optional,
            pMicroInitialOffsetA
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 239,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Offset between secondary time reference and MT boundary (range 0 - 239 microticks)"
              | optional,
            pMicroInitialOffsetB
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 239,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Offset between secondary time reference and MT boundary (range 0 - 239 microticks)"
              | optional,
            pMicroPerCycle
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 1280000,
                    _js2n__-prdslib.numbers.minimum 960
                  ])
              | doc "Nominal number of microticks in the communication cycle (range 960 - 1280000)"
              | optional,
            pOffsetCorrectionOut
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 16082,
                    _js2n__-prdslib.numbers.minimum 15
                  ])
              | doc "Maximum permissible offset correction value (range 15 - 16082 microticks)"
              | optional,
            pOffsetCorrectionStart
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 15999,
                    _js2n__-prdslib.numbers.minimum 7
                  ])
              | doc "Start of the offset correction phase within the NIT, (7 - 15999 macroticks)"
              | optional,
            pRateCorrectionOut
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 3846,
                    _js2n__-prdslib.numbers.minimum 3
                  ])
              | doc "Maximum permissible rate correction value (range 3 - 3846 microticks)"
              | optional,
            pSamplesPerMicrotick
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 2,
                    _js2n__-prdslib.numbers.minimum 1
                  ])
              | doc "Number of samples per microtick (values 1, 2)"
              | optional,
            pWakeupChannel
              | std.enum.TagOrString
              | [| 'B, 'A |]
              | doc "Channel used by the node to send a wakeup pattern"
              | optional,
            pWakeupPattern
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 63,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Number of repetitions of the wakeup symbol (range 0 - 63, value 0 or 1 prevents sending of WUP)"
              | optional,
            pdAcceptedStartupRange
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 2743,
                    _js2n__-prdslib.numbers.minimum 29
                  ])
              | doc "Allowed deviation for startup frames during integration in microticks (range 29 - 2743)"
              | optional,
            pdListenTimeout
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 2567692,
                    _js2n__-prdslib.numbers.minimum 1926
                  ])
              | doc "Duration of listen phase in microticks (range 1926 - 2567692)"
              | optional,
            pdMicrotick
              | std.enum.TagOrString
              | [| '"50ns", '"25ns", '"12.5ns" |]
              | doc "Duration of a FlexRay microtick"
              | optional,
            ..
          },
      "_js2n__-:definitions/FlexrayTxBufferConfigurations!contract" =
        Array
            {
              PPindicator | Bool | doc "Set the PPindicator" | optional,
              channels
                | std.enum.TagOrString
                | [| 'None, 'AB, 'B, 'A |]
                | doc "Channel(s)"
                | optional,
              headerCrc
                | std.number.Integer
                | doc "Header CRC, 11 bits"
                | optional,
              offset
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.maximum 63,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Base offset for cycle multiplexing (values 0 - 63)"
                | optional,
              repetition
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.maximum 64,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "Repetition for cycle multiplexing (values 1, 2, 4, 8, 16, 32, 64)"
                | optional,
              slotId
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.maximum 65535,
                      _js2n__-prdslib.numbers.minimum 0
                    ])
                | doc "The slot Id of frame"
                | optional,
              transmissionMode
                | std.enum.TagOrString
                | [| 'Continuous, 'SingleShot |]
                | doc "SingleShot or Continuous transmission mode"
                | optional,
              ..
            },
      "_js2n__-:definitions/Logging!contract"
        | doc "Configures the properties of the SIL Kit Logging Service"
        = {
            FlushLevel
              | std.enum.TagOrString
              | [| 'Off, 'Trace, 'Debug, 'Info, 'Warn, 'Error, 'Critical |]
              | optional,
            LogFromRemotes
              | Bool
              | doc "Enables receiving of remote log messages from other participants"
              | optional,
            Sinks
              | Array
                {
                  Level
                    | std.enum.TagOrString
                    | [|
                      'Off,
                      'Trace,
                      'Debug,
                      'Info,
                      'Warn,
                      'Error,
                      'Critical
                    |]
                    | optional,
                  LogName
                    | String
                    | doc "Log name; Results in the following filename: <LogName>_%y-%m-%dT%h-%m-%s.txt"
                    | optional,
                  Type | std.enum.TagOrString | [| 'Stdout, 'File, 'Remote |],
                },
          },
      "_js2n__-:definitions/Name!contract"
        | doc "Name of the endpoint"
        = String,
      "_js2n__-:definitions/Network!contract"
        | doc "Name of the network. Optional; Defaults to the endpoint name"
        = String,
      "_js2n__-:definitions/Replay!contract" =
        {
            Direction
              | std.enum.TagOrString
              | [| 'Both, 'Receive, 'Send |]
              | doc "Filter messages to use from the trace source by their direction. May be Send, Receive or Both"
              | optional,
            MdfChannel
              | {
                ChannelName
                  | String
                  | doc "Name of an MDF channel in the trace source"
                  | optional,
                ChannelPath
                  | String
                  | doc "Path of an MDF channel's source information object"
                  | optional,
                ChannelSource
                  | String
                  | doc "Name of an MDF channel's source information object"
                  | optional,
                GroupName
                  | String
                  | doc "Name of an MDF channel group"
                  | optional,
                GroupPath
                  | String
                  | doc "Path of an MDF channel group's source information object"
                  | optional,
                GroupSource
                  | String
                  | doc "Name of an MDF channel group's source information object"
                  | optional,
                ..
              }
              | optional,
            UseTraceSource
              | String
              | doc "Name of a trace source used as a simulation message source for this controller"
              | optional,
            ..
          },
      "_js2n__-:definitions/RpcFunctionName!contract"
        | doc "Name of the RPC function called by RpcClients on RpcServers"
        = String,
      "_js2n__-:definitions/Topic!contract"
        | doc "Name of the communication channel between DataPublisher and DataSubscribers"
        = String,
      "_js2n__-:definitions/UseTraceSinks!contract"
        | doc "Names of trace sinks to use"
        = Array Dyn,
    }
    in
  {
      "$schema" | String | doc "The schema file" | optional,
      CanControllers
        | Array
          {
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            Network
              | _js2n__-refsenv."_js2n__-:definitions/Network!contract"
              | optional,
            Replay
              | _js2n__-refsenv."_js2n__-:definitions/Replay!contract"
              | optional,
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the CanControllers of the participant"
        | optional,
      DataPublishers
        | Array
          {
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            Topic
              | _js2n__-refsenv."_js2n__-:definitions/Topic!contract"
              | optional,
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the DataPublishers of the participant"
        | optional,
      DataSubscribers
        | Array
          {
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            Topic
              | _js2n__-refsenv."_js2n__-:definitions/Topic!contract"
              | optional,
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the DataSubscribers of the participant"
        | optional,
      Description
        | _js2n__-refsenv."_js2n__-:definitions/Description!contract"
        | optional,
      EthernetControllers
        | Array
          {
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            Network
              | _js2n__-refsenv."_js2n__-:definitions/Network!contract"
              | optional,
            Replay
              | _js2n__-refsenv."_js2n__-:definitions/Replay!contract"
              | optional,
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the EthernetControllers of the participant"
        | optional,
      Extensions
        | { SearchPathHints | Array (String) | optional, }
        | doc "Optional configuration for the extension loading mechanism"
        | optional,
      FlexrayControllers
        | _js2n__-refsenv."_js2n__-:definitions/FlexrayControllers!contract"
        | optional,
      HealthCheck
        | {
          HardResponseTimeout
            | std.number.Integer
            | doc "If a simulation step is not finished before this limit, the participant enters error state. Optional; Unit is in milliseconds"
            | optional,
          SoftResponseTimeout
            | std.number.Integer
            | doc "If a simulation step is not finished before this limit, a warning is logged. Optional; Unit is in milliseconds"
            | optional,
        }
        | doc "Node to configure properties to determine the health status of the simulation"
        | optional,
      Includes
        | {
          Files | Array (String) | optional,
          SearchPathHints | Array (String) | optional,
          ..
        }
        | doc "Optional configuration to include other participant configurations files"
        | optional,
      LinControllers
        | Array
          {
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            Network
              | _js2n__-refsenv."_js2n__-:definitions/Network!contract"
              | optional,
            Replay
              | _js2n__-refsenv."_js2n__-:definitions/Replay!contract"
              | optional,
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the LinControllers of the participant"
        | optional,
      Logging
        | _js2n__-refsenv."_js2n__-:definitions/Logging!contract"
        | optional,
      Middleware
        | {
          ConnectAttempts | std.number.Integer | optional,
          RegistryUri | String | optional,
          TcpNoDelay | Bool | optional,
          TcpQuickAck | Bool | optional,
          TcpReceiveBufferSize | std.number.Integer | optional,
          TcpSendBufferSize | std.number.Integer | optional,
        }
        | doc "Optional configuration of the SIL Kit middleware"
        | optional,
      ParticipantName | String | doc "Name of the participant" | optional,
      RpcClients
        | Array
          {
            FunctionName
              | _js2n__-refsenv."_js2n__-:definitions/RpcFunctionName!contract"
              | optional,
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the RpcClients of the participant"
        | optional,
      RpcServers
        | Array
          {
            FunctionName
              | _js2n__-refsenv."_js2n__-:definitions/RpcFunctionName!contract"
              | optional,
            Name | _js2n__-refsenv."_js2n__-:definitions/Name!contract",
            UseTraceSinks
              | _js2n__-refsenv."_js2n__-:definitions/UseTraceSinks!contract"
              | optional,
          }
        | doc "Reconfigures the RpcServers of the participant"
        | optional,
      Tracing
        | {
          TraceSinks
            | Array
              {
                Name | String | doc "Name of the trace sink" | optional,
                OutputPath | String | doc "File path of output file" | optional,
                Type
                  | std.enum.TagOrString
                  | [| 'Mdf4File, 'PcapPipe, 'PcapFile |]
                  | doc "File format specifier"
                  | optional,
              }
            | optional,
          TraceSources
            | Array
              {
                InputPath | String | doc "File path of input file" | optional,
                Name | String | doc "Name of the trace source" | optional,
                Type
                  | std.enum.TagOrString
                  | [| 'Mdf4File, 'PcapPipe, 'PcapFile |]
                  | doc "File format specifier"
                  | optional,
              }
            | optional,
          ..
        }
        | doc "Configures the tracing service of the participant"
        | optional,
      schemaVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Version of the schema used to validate this document"
        | optional,
    }