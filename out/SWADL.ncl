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
      "_js2n__-:definitions/active!predicate"
        | doc "If false, the room is not active anymore."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/activity-completed-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "activity-completed" ],
              _js2n__-prdslib.records.record
                {
                  activity-completed =
                    _js2n__-refsenv."_js2n__-:definitions/activity-completed-event-inner!predicate",
                  "if" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/activity-completed-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "activity-id" ],
              _js2n__-prdslib.records.record
                {
                  activity-id =
                    _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/activity-expired-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "activity-expired" ],
              _js2n__-prdslib.records.record
                {
                  activity-expired =
                    _js2n__-refsenv."_js2n__-:definitions/activity-expired-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/activity-expired-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "activity-id" ],
              _js2n__-prdslib.records.record
                {
                  activity-id =
                    _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/activity-failed-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "activity-failed" ],
              _js2n__-prdslib.records.record
                {
                  activity-failed =
                    _js2n__-refsenv."_js2n__-:definitions/activity-failed-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/activity-failed-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "activity-id" ],
              _js2n__-prdslib.records.record
                {
                  activity-id =
                    _js2n__-refsenv."_js2n__-:definitions/id!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/add-group-member-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "group-id" ],
              _js2n__-prdslib.records.record
                {
                  group-id =
                    _js2n__-refsenv."_js2n__-:definitions/group-id!predicate",
                  members =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/group-member!predicate",
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.minLength 1,
                                  _js2n__-prdslib.strings.pattern
                                    "^\\$\\{.*\\}$"
                                ],
                              _js2n__-prdslib.enum
                                [ "${variables.VARIABLE_NAME}" ]
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/add-room-member-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id", "user-ids" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/all-of-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "all-of" ],
              _js2n__-prdslib.records.record
                {
                  all-of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/form-replied-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/activity-completed-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/activity-failed-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/message-received-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/request-received-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/message-suppressed-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/post-shared-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/im-created-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-created-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-updated-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-deactivated-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-reactivated-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-member-promoted-to-owner-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-member-demoted-from-owner-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-joined-room-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-left-room-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-requested-join-room-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/connection-requested-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/connection-accepted-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/timer-fired-event!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/at!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "at" ],
              _js2n__-prdslib.records.record
                { at = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/attachment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/attachment-message!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/attachment-file!predicate"
                ]
            ],
      "_js2n__-:definitions/attachment-file!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "content-path" ],
              _js2n__-prdslib.records.record
                {
                  content-path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/attachment-message!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message-id" ],
              _js2n__-prdslib.records.record
                {
                  attachment-id =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  message-id =
                    _js2n__-refsenv."_js2n__-:definitions/message-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/basic-activity-inner!predicate"
        | doc "Inner property having common properties for every activity."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  "else" = _js2n__-prdslib.isType 'Record,
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                  "if" = _js2n__-prdslib.isType '"String",
                  on = _js2n__-refsenv."_js2n__-:definitions/on!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/business!predicate"
        | doc "Business information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  asset-classes =
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
                                        "Equities",
                                        "Cash Equities",
                                        "Securities Lending",
                                        "Fixed Income",
                                        "Government Bonds",
                                        "Prime Brokerage",
                                        "Commodities",
                                        "Municipal Bonds",
                                        "Currencies",
                                        "Corporate Bonds"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  company-name = _js2n__-prdslib.isType '"String",
                  department = _js2n__-prdslib.isType '"String",
                  division = _js2n__-prdslib.isType '"String",
                  functions =
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
                                        "Collateral",
                                        "Confirmation",
                                        "Trade Processing",
                                        "Pre-Matching",
                                        "Margin",
                                        "Matching",
                                        "Claims Processing",
                                        "Middle Office",
                                        "Liquidity Management",
                                        "Allocation",
                                        "Trade Management",
                                        "Regulatory Outreach",
                                        "Settlements",
                                        "Post Trade Management"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  industries =
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
                                        "Healthcare",
                                        "Consumer Non-Cyclicals",
                                        "Transportation",
                                        "Technology",
                                        "Real Estate",
                                        "Basic Materials",
                                        "Financials",
                                        "Energy & Utilities",
                                        "Conglomerates",
                                        "Consumer Cyclicals",
                                        "Services"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  instruments =
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
                                        "Securities",
                                        "Fixed Income",
                                        "Equities"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  job-function =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Analyst",
                              "Other",
                              "Business Development Executive",
                              "Corporate Access",
                              "Developer",
                              "Director",
                              "Economist",
                              "Portfolio Manager",
                              "Project Manager",
                              "Research Analyst",
                              "Sales",
                              "Strategist",
                              "Trader"
                            ]
                        ],
                  location = _js2n__-prdslib.isType '"String",
                  market-coverages =
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
                                      [ "EMEA", "NA", "APAC", "LATAM" ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  responsibilities =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "BAU", "Escalation" ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  title = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/connection-accepted-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connection-accepted" ],
              _js2n__-prdslib.records.record
                {
                  connection-accepted =
                    _js2n__-refsenv."_js2n__-:definitions/connection-accepted-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/connection-accepted-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/connection-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user-id" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  user-id =
                    _js2n__-refsenv."_js2n__-:definitions/user-id!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/connection-requested-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connection-requested" ],
              _js2n__-prdslib.records.record
                {
                  connection-requested =
                    _js2n__-refsenv."_js2n__-:definitions/connection-requested-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/connection-requested-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/content-inner!predicate"
        | doc "The content of the message in MessageML format. Must contain at least one space. In case the content is a form, this latter's id should be the same as the activity one."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${text(ACTIVITY_ID.outputs.message.message)}",
                  "${event.args.NAME}",
                  "<mention uid='${ACTIVITY_ID.outputs.user.userSystemInfo.id}'/>",
                  "<mention uid='${event.initiator.user.userId}'/>"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "template" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "template-path" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.records.record
                    {
                      template =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                      template-path =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 0
                ]
            ],
      "_js2n__-:definitions/copy-protected!predicate"
        | doc m%"
          If true, users cannot copy content from this room.
          Note: Once this value is set to true for a room, it is read-only and can’t be updated.
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/create-group-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  members =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    _js2n__-refsenv."_js2n__-:definitions/group-member!predicate",
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.minLength 1,
                                  _js2n__-prdslib.strings.pattern
                                    "^\\$\\{.*\\}$"
                                ],
                              _js2n__-prdslib.enum
                                [ "${variables.VARIABLE_NAME}" ]
                            ]
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  owner =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/group-owner!predicate"
                        ],
                  profile =
                    _js2n__-refsenv."_js2n__-:definitions/group-profile!predicate",
                  referrer =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  sub-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "COMMUNITY", "CHANNEL" ]
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/create-room-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "room-description", "room-name" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "user-ids" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  copy-protected =
                    _js2n__-refsenv."_js2n__-:definitions/copy-protected!predicate",
                  cross-pod =
                    _js2n__-refsenv."_js2n__-:definitions/cross-pod!predicate",
                  discoverable =
                    _js2n__-refsenv."_js2n__-:definitions/discoverable!predicate",
                  keywords =
                    _js2n__-refsenv."_js2n__-:definitions/keywords!predicate",
                  members-can-invite =
                    _js2n__-refsenv."_js2n__-:definitions/members-can-invite!predicate",
                  multilateral-room =
                    _js2n__-refsenv."_js2n__-:definitions/multilateral-room!predicate",
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  public =
                    _js2n__-refsenv."_js2n__-:definitions/public!predicate",
                  read-only =
                    _js2n__-refsenv."_js2n__-:definitions/read-only!predicate",
                  room-description =
                    _js2n__-refsenv."_js2n__-:definitions/room-description!predicate",
                  room-name =
                    _js2n__-refsenv."_js2n__-:definitions/room-name!predicate",
                  sub-type =
                    _js2n__-refsenv."_js2n__-:definitions/sub-type!predicate",
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                  view-history =
                    _js2n__-refsenv."_js2n__-:definitions/view-history!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/create-system-user-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  business =
                    _js2n__-refsenv."_js2n__-:definitions/business!predicate",
                  display-name =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  email =
                    _js2n__-refsenv."_js2n__-:definitions/email!predicate",
                  entitlements =
                    _js2n__-refsenv."_js2n__-:definitions/entitlements-inner!predicate",
                  keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              current =
                                _js2n__-refsenv."_js2n__-:definitions/key-inner!predicate",
                              previous =
                                _js2n__-refsenv."_js2n__-:definitions/key-inner!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  roles =
                    _js2n__-refsenv."_js2n__-:definitions/roles-inner!predicate",
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ENABLED", "DISABLED" ]
                        ],
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/create-user-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  business =
                    _js2n__-refsenv."_js2n__-:definitions/business!predicate",
                  contact =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              mobile-phone-number =
                                _js2n__-refsenv."_js2n__-:definitions/phoneNumber!predicate",
                              sms-number =
                                _js2n__-refsenv."_js2n__-:definitions/phoneNumber!predicate",
                              two-factor-auth-number =
                                _js2n__-refsenv."_js2n__-:definitions/phoneNumber!predicate",
                              work-phone-number =
                                _js2n__-refsenv."_js2n__-:definitions/phoneNumber!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  display-name =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  email =
                    _js2n__-refsenv."_js2n__-:definitions/email!predicate",
                  entitlements =
                    _js2n__-refsenv."_js2n__-:definitions/entitlements-inner!predicate",
                  firstname =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  lastname =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  password =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "hashed-password", "hashed-salt" ],
                          _js2n__-prdslib.records.record
                            {
                              hashed-km-password =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              hashed-km-salt =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              hashed-password =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                              hashed-salt =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.minLength 1
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  recommended-language = _js2n__-prdslib.isType '"String",
                  roles =
                    _js2n__-refsenv."_js2n__-:definitions/roles-inner!predicate",
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ENABLED", "DISABLED" ]
                        ],
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/cross-pod!predicate"
        | doc "If true, this room is a cross-pod room."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/demote-room-owner-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id", "user-ids" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/discoverable!predicate"
        | doc "If true, this chat room (name, description and messages) non-participants can search for this room. If false, only participants can search for this room."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/email!predicate"
        | doc "Email address, must be unique"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.emailAddress}"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "([$][{].+})|(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
                ]
            ],
      "_js2n__-:definitions/entitlements-inner!predicate"
        | doc "Feature entitlements to configure for the user."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      canCreateDatahose =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canCreateMultiLateralRoom =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canCreatePublicRoom =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canCreatePushedSignals =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canIntegrateEmail =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canJoinMultiLateralRoom =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canManageSignalSubscription =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canProjectInternalScreenShare =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canProjectInternalScreenShareMobile =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canReadDatahose =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canShareFilesExternally =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canSuppressMessage =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canSwitchToClient20 =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUpdateAvatar =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUpdateRoomHistoryProperty =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseCompactMode =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseEncryptAPI =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseFirehose =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseInternalAudio =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseInternalAudioMobile =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseInternalVideo =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canUseInternalVideoMobile =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canViewInternalScreenShare =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      canViewInternalScreenShareMobile =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      delegatesEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      enableSwiftSearch =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      isExternalIMEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      isExternalRoomEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      mustBeRecorded =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      postReadEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      postWriteEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaDevtoolsEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsFullScreen =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsGeoLocation =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsMedia =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsMidiSysex =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsNotifications =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsOpenExternalApp =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sdaPermissionsPointerLock =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                      sendFilesEnabled =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String"
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
            ],
      "_js2n__-:definitions/execute-request-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  body =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                  encode-query-params =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  headers = _js2n__-prdslib.isType 'Record,
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "GET",
                              "POST",
                              "PUT",
                              "DELETE",
                              "PATCH",
                              "HEAD",
                              "OPTIONS"
                            ]
                        ],
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/execute-script-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "script" ],
              _js2n__-prdslib.records.record
                { script = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/form-replied-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "form-replied" ],
              _js2n__-prdslib.records.record
                {
                  form-replied =
                    _js2n__-refsenv."_js2n__-:definitions/form-replied-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/form-replied-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "form-id" ],
              _js2n__-prdslib.records.record
                {
                  exclusive = _js2n__-prdslib.isType '"Bool",
                  form-id = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-attachment-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "attachment-id", "message-id" ],
              _js2n__-prdslib.records.record
                {
                  attachment-id =
                    _js2n__-refsenv."_js2n__-:definitions/single-attachment!predicate",
                  message-id =
                    _js2n__-refsenv."_js2n__-:definitions/message-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-connections-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "PENDING_INCOMING",
                              "PENDING_OUTGOING",
                              "ACCEPTED",
                              "REJECTED",
                              "ALL"
                            ]
                        ],
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-group-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "group-id" ],
              _js2n__-prdslib.records.record
                {
                  group-id =
                    _js2n__-refsenv."_js2n__-:definitions/group-id!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-groups-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  after =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  before =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Integer
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  sort-order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ASC", "DESC" ]
                        ],
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ACTIVE", "DELETED" ]
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-message-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "message-id" ],
              _js2n__-prdslib.records.record
                {
                  message-id =
                    _js2n__-refsenv."_js2n__-:definitions/message-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-messages-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "since", "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  limit =
                    _js2n__-refsenv."_js2n__-:definitions/limit!predicate",
                  since =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-room-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-room-members-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-rooms-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "query" ],
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  creator-id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number"
                            ],
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  labels =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  limit =
                    _js2n__-refsenv."_js2n__-:definitions/limit!predicate",
                  member-id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number"
                            ],
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  owner-id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number"
                            ],
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  private =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  query =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  sort-order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "BASIC", "RELEVANCE" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-stream-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-stream-members-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  limit =
                    _js2n__-refsenv."_js2n__-:definitions/limit!predicate",
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-streams-inner!predicate" =
        _js2n__-prdslib.records.record
            {
              end-date = _js2n__-prdslib.isType '"String",
              limit = _js2n__-refsenv."_js2n__-:definitions/limit!predicate",
              origin =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "INTERNAL", "EXTERNAL" ]
                    ],
              privacy =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "PRIVATE", "PUBLIC" ]
                    ],
              scope =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "INTERNAL", "EXTERNAL" ]
                    ],
              skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
              start-date = _js2n__-prdslib.isType '"String",
              status =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "ACTIVE", "INACTIVE" ]
                    ],
              types =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "IM", "MIM", "ROOM" ]
                              ])
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                        ],
                      _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/get-user-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user-id" ],
              _js2n__-prdslib.records.record
                {
                  user-id =
                    _js2n__-refsenv."_js2n__-:definitions/user-id!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/get-user-streams-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.record
                {
                  include-inactive-streams =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  limit =
                    _js2n__-refsenv."_js2n__-:definitions/limit!predicate",
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  skip = _js2n__-refsenv."_js2n__-:definitions/skip!predicate",
                  types =
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
                                      [ "IM", "MIM", "ROOM", "POST" ]
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                } {} true _js2n__-prdslib.always,
              _js2n__-prdslib.records.dependencies
                { limit = [ "skip" ], skip = [ "limit" ], }
            ],
      "_js2n__-:definitions/get-users-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "user-ids" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "emails" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "usernames" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  emails =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/email!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  local =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                  usernames =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/name!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/group-id!predicate"
        | doc "Group's unique identifier."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Integer
                    ],
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
            ],
      "_js2n__-:definitions/group-member!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "tenant-id", "user-id" ],
              _js2n__-prdslib.records.record
                {
                  tenant-id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Integer
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  user-id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Integer
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/group-owner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "type" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.isType 'Integer
                                ],
                              _js2n__-prdslib.strings.minLength 1
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "TENANT", "PLATFORM", "USER" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/group-profile!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "display-name" ],
              _js2n__-prdslib.records.record
                {
                  asset-classes =
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
                                        "Equities",
                                        "Cash Equities",
                                        "Securities Lending",
                                        "Fixed Income",
                                        "Government Bonds",
                                        "Prime Brokerage",
                                        "Commodities",
                                        "Municipal Bonds",
                                        "Currencies",
                                        "Corporate Bonds"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  company-name = _js2n__-prdslib.isType '"String",
                  display-name = _js2n__-prdslib.isType '"String",
                  email = _js2n__-prdslib.isType '"String",
                  functions =
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
                                        "Collateral",
                                        "Confirmation",
                                        "Trade Processing",
                                        "Pre-Matching",
                                        "Margin",
                                        "Matching",
                                        "Claims Processing",
                                        "Middle Office",
                                        "Liquidity Management",
                                        "Allocation",
                                        "Trade Management",
                                        "Regulatory Outreach",
                                        "Settlements",
                                        "Post Trade Management"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  implicit-connection =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/tenants-users-list!predicate"
                        ],
                  industries =
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
                                        "Healthcare",
                                        "Consumer Non-Cyclicals",
                                        "Transportation",
                                        "Technology",
                                        "Real Estate",
                                        "Basic Materials",
                                        "Financials",
                                        "Energy & Utilities",
                                        "Conglomerates",
                                        "Consumer Cyclicals",
                                        "Services"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  instruments =
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
                                        "Securities",
                                        "Fixed Income",
                                        "Equities"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  interaction-transfer =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/tenants-users-list!predicate"
                        ],
                  job =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              city = _js2n__-prdslib.isType '"String",
                              department = _js2n__-prdslib.isType '"String",
                              division = _js2n__-prdslib.isType '"String",
                              phone = _js2n__-prdslib.isType '"String",
                              role = _js2n__-prdslib.isType '"String",
                              title = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  market-coverages =
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
                                      [ "EMEA", "NA", "APAC", "LATAM" ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  mobile = _js2n__-prdslib.isType '"String",
                  responsibilities =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ "BAU", "Escalation" ]
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  visibility-restriction =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/tenants-users-list!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/id!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/im-created-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "im-created" ],
              _js2n__-prdslib.records.record
                {
                  im-created =
                    _js2n__-refsenv."_js2n__-:definitions/im-created-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/im-created-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/key-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  action =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SAVE", "EXTEND", "REVOKE" ]
                        ],
                  expiration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  key =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/keywords!predicate"
        | doc "A list of key-value pairs, describing additional properties of the room."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
            ],
      "_js2n__-:definitions/limit!predicate"
        | doc "Maximum number of elements to be returned - used for pagination."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.isType '"String"
                    ],
                  _js2n__-prdslib.numbers.maximum 1000,
                  _js2n__-prdslib.numbers.minimum 1
                ]
            ],
      "_js2n__-:definitions/members-can-invite!predicate"
        | doc "If true, any chat room participant can add new participants. If false, only owners can add new participants."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/message-id-inner!predicate"
        | doc "Message identifier. Both safe url and Base64 encoded urls are accepted."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.msgId}",
                  "${ACTIVITY_ID.outputs.message.messageId}",
                  "${ACTIVITY_ID.outputs.message.initialMessageId}"
                ],
              _js2n__-refsenv."_js2n__-:definitions/id!predicate"
            ],
      "_js2n__-:definitions/message-received-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message-received" ],
              _js2n__-prdslib.records.record
                {
                  message-received =
                    _js2n__-refsenv."_js2n__-:definitions/message-received-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/message-received-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  content = _js2n__-prdslib.isType '"String",
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                  requires-bot-mention = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/message-suppressed-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message-suppressed" ],
              _js2n__-prdslib.records.record
                {
                  message-suppressed =
                    _js2n__-refsenv."_js2n__-:definitions/message-suppressed-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/message-suppressed-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/multilateral-room!predicate"
        | doc "If true, this is a multilateral room where users belonging to more than 2 companies can be found."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/name!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.firstName}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.lastName}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.userName}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.displayName}"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ]
            ],
      "_js2n__-:definitions/obo-inner!predicate"
        | doc "Defines whether the activity will be executed on behalf of a user and the user on whose behalf the call will be made."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "user-id" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "username" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  user-id =
                    _js2n__-refsenv."_js2n__-:definitions/user-id!predicate",
                  username =
                    _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/on!predicate"
        | doc "Events that can trigger the activity execution."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          timeout =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.strings.pattern
                                    "^P(?!$)(\\d+(?:\\.\\d+)?Y)?(\\d+(?:\\.\\d+)?M)?(\\d+(?:\\.\\d+)?W)?(\\d+(?:\\.\\d+)?D)?(T(?=\\d)(\\d+(?:\\.\\d+)?H)?(\\d+(?:\\.\\d+)?M)?(\\d+(?:\\.\\d+)?S)?)?$"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/form-replied-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/activity-expired-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/activity-completed-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/activity-failed-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/message-received-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/request-received-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/message-suppressed-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/post-shared-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/im-created-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/room-created-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/room-updated-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/room-deactivated-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/room-reactivated-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/room-member-promoted-to-owner-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/room-member-demoted-from-owner-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/user-joined-room-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/user-left-room-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/user-requested-join-room-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/connection-requested-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/connection-accepted-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/timer-fired-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/one-of-event!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/all-of-event!predicate"
                    ]
                ]
            ],
      "_js2n__-:definitions/one-of-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "one-of" ],
              _js2n__-prdslib.records.record
                {
                  one-of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/form-replied-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/activity-expired-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/activity-completed-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/activity-failed-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/message-received-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/request-received-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/message-suppressed-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/post-shared-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/im-created-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-created-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-updated-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-deactivated-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-reactivated-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-member-promoted-to-owner-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/room-member-demoted-from-owner-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-joined-room-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-left-room-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-requested-join-room-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/connection-requested-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/connection-accepted-event!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/timer-fired-event!predicate"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/phoneNumber!predicate"
        | doc "The user's work phone number."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.workPhoneNumber}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.mobilePhoneNumber}",
                  "${ACTIVITY_ID.outputs.user.userAttributes.twoFactorAuthPhone}"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[0-9]*$|^\\+[0-9]*$"
                ]
            ],
      "_js2n__-:definitions/pin-message-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "message-id" ],
              _js2n__-prdslib.records.record
                {
                  message-id =
                    _js2n__-refsenv."_js2n__-:definitions/message-id-inner!predicate",
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/post-shared-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "post-shared" ],
              _js2n__-prdslib.records.record
                {
                  post-shared =
                    _js2n__-refsenv."_js2n__-:definitions/post-shared-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/post-shared-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/promote-room-owner-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id", "user-ids" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/public!predicate"
        | doc m%"
          If true, this is a public chatroom. If false, a private chatroom.
          Note: Once this value is set for a room, it is read-only and can’t be updated.
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/read-only!predicate"
        | doc m%"
          If true, only stream owners can send messages.
          Note: Once this value is set for a room, it is read-only and can’t be updated.
        "%
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/remove-room-member-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id", "user-ids" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/repeat!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "repeat" ],
              _js2n__-prdslib.records.record
                { repeat = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/request-received-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "request-received" ],
              _js2n__-prdslib.records.record
                {
                  request-received =
                    _js2n__-refsenv."_js2n__-:definitions/request-received-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/request-received-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "token" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                  token =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/roles-inner!predicate"
        | doc m%"
          The roles object consists of the following possibilities:
          For end-user accounts: INDIVIDUAL, ADMINISTRATOR, SUPER_ADMINISTRATOR, L1_SUPPORT, L2_SUPPORT, COMPLIANCE_OFFICER, SUPER_COMPLIANCE_OFFICER
          For service accounts: INDIVIDUAL, USER_PROVISIONING, SCOPE_MANAGEMENT, CONTENT_MANAGEMENT, MALWARE_SCAN_MANAGER, MALWARE_SCAN_STATE_USER, AUDIT_TRAIL_MANAGEMENT
        "%
        = _js2n__-prdslib.oneOf
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
                            "INDIVIDUAL",
                            "ADMINISTRATOR",
                            "SUPER_ADMINISTRATOR",
                            "L1_SUPPORT",
                            "L2_SUPPORT",
                            "COMPLIANCE_OFFICER",
                            "SUPER_COMPLIANCE_OFFICER",
                            "USER_PROVISIONING",
                            "SCOPE_MANAGEMENT",
                            "CONTENT_MANAGEMENT",
                            "MALWARE_SCAN_MANAGER",
                            "MALWARE_SCAN_STATE_USER",
                            "AUDIT_TRAIL_MANAGEMENT",
                            "AGENT",
                            "CONTENT_EXPORT_SERVICE",
                            "SYMPHONY_ADMIN",
                            "KEY_MANAGER",
                            "EF_POLICY_MANAGEMENT",
                            "CEP_VISIBILITY_GROUP_MANAGEMENT"
                          ]
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1,
                  _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                ],
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
            ],
      "_js2n__-:definitions/room-created-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "room-created" ],
              _js2n__-prdslib.records.record
                {
                  room-created =
                    _js2n__-refsenv."_js2n__-:definitions/room-created-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-created-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/room-deactivated-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "room-deactivated" ],
              _js2n__-prdslib.records.record
                {
                  room-deactivated =
                    _js2n__-refsenv."_js2n__-:definitions/room-deactivated-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-deactivated-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/room-description!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${ACTIVITY_ID.outputs.room.roomAttributes.description}",
                  "${variables.VARIABLE_NAME}"
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/room-member-demoted-from-owner-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "room-member-demoted-from-owner" ],
              _js2n__-prdslib.records.record
                {
                  room-member-demoted-from-owner =
                    _js2n__-refsenv."_js2n__-:definitions/room-member-demoted-from-owner-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-member-demoted-from-owner-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/room-member-promoted-to-owner-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "room-member-promoted-to-owner" ],
              _js2n__-prdslib.records.record
                {
                  room-member-promoted-to-owner =
                    _js2n__-refsenv."_js2n__-:definitions/room-member-promoted-to-owner-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-member-promoted-to-owner-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-name!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${ACTIVITY_ID.outputs.room.roomAttributes.name}",
                  "${ACTIVITY_ID.outputs.stream.roomAttributes.name}",
                  "${variables.VARIABLE_NAME}"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.maxLength 50
                ]
            ],
      "_js2n__-:definitions/room-reactivated-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "room-reactivated" ],
              _js2n__-prdslib.records.record
                {
                  room-reactivated =
                    _js2n__-refsenv."_js2n__-:definitions/room-reactivated-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-reactivated-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/room-updated-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "room-updated" ],
              _js2n__-prdslib.records.record
                {
                  room-updated =
                    _js2n__-refsenv."_js2n__-:definitions/room-updated-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/room-updated-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/send-message-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "content" ],
              _js2n__-prdslib.records.record
                {
                  attachments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/attachment!predicate"
                        ],
                  content =
                    _js2n__-refsenv."_js2n__-:definitions/content-inner!predicate",
                  data = _js2n__-prdslib.isType '"String",
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  to = _js2n__-refsenv."_js2n__-:definitions/to!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/single-attachment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/skip!predicate"
        | doc "Number of elements to be skipped during return - used for pagination."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.isType '"String"
                    ],
                  _js2n__-prdslib.numbers.minimum 0
                ]
            ],
      "_js2n__-:definitions/stream-id!predicate"
        | doc "Stream id to sent the message to."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stream-id-inner!predicate"
        | doc "Stream identifier. Both safe url and Base64 encoded urls are accepted."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.enum
                [
                  "${event.source.message.stream.streamId}",
                  "${variables.VARIABLE_NAME}",
                  "${ACTIVITY_ID.outputs.roomId}",
                  "${ACTIVITY_ID.outputs.stream.id}"
                ],
              _js2n__-refsenv."_js2n__-:definitions/id!predicate"
            ],
      "_js2n__-:definitions/stream-ids!predicate"
        | doc "Stream ids to sent the message to (blast message)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-ids" ],
              _js2n__-prdslib.records.record
                {
                  stream-ids =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String"),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/sub-type!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "EMAIL" ]
            ],
      "_js2n__-:definitions/tenants-users-list!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  tenant-ids =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Integer
                                      ],
                                    _js2n__-prdslib.numbers.minimum 0,
                                    _js2n__-prdslib.strings.minLength 1
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                  user-ids =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Integer
                                      ],
                                    _js2n__-prdslib.numbers.minimum 0,
                                    _js2n__-prdslib.strings.minLength 1
                                  ]),
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/timer-fired-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "timer-fired" ],
              _js2n__-prdslib.records.record
                {
                  timer-fired =
                    _js2n__-refsenv."_js2n__-:definitions/timer-fired-event-inner!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/timer-fired-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/repeat!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/at!predicate"
                ]
            ],
      "_js2n__-:definitions/to!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/stream-id!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/stream-ids!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/user-ids!predicate"
                ]
            ],
      "_js2n__-:definitions/unpin-message-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/update-group-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "group-id" ],
              _js2n__-prdslib.records.record
                {
                  e-tag = _js2n__-prdslib.isType '"String",
                  group-id =
                    _js2n__-refsenv."_js2n__-:definitions/group-id!predicate",
                  image-path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ]
                        ],
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ACTIVE", "DELETED" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/update-message-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "content", "message-id" ],
              _js2n__-prdslib.records.record
                {
                  content =
                    _js2n__-refsenv."_js2n__-:definitions/content-inner!predicate",
                  message-id =
                    _js2n__-refsenv."_js2n__-:definitions/message-id-inner!predicate",
                  silent =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/update-room-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "stream-id" ],
              _js2n__-prdslib.records.record
                {
                  active =
                    _js2n__-refsenv."_js2n__-:definitions/active!predicate",
                  copy-protected =
                    _js2n__-refsenv."_js2n__-:definitions/copy-protected!predicate",
                  cross-pod =
                    _js2n__-refsenv."_js2n__-:definitions/cross-pod!predicate",
                  discoverable =
                    _js2n__-refsenv."_js2n__-:definitions/discoverable!predicate",
                  keywords =
                    _js2n__-refsenv."_js2n__-:definitions/keywords!predicate",
                  members-can-invite =
                    _js2n__-refsenv."_js2n__-:definitions/members-can-invite!predicate",
                  multilateral-room =
                    _js2n__-refsenv."_js2n__-:definitions/multilateral-room!predicate",
                  obo =
                    _js2n__-refsenv."_js2n__-:definitions/obo-inner!predicate",
                  public =
                    _js2n__-refsenv."_js2n__-:definitions/public!predicate",
                  read-only =
                    _js2n__-refsenv."_js2n__-:definitions/read-only!predicate",
                  room-description =
                    _js2n__-refsenv."_js2n__-:definitions/room-description!predicate",
                  room-name =
                    _js2n__-refsenv."_js2n__-:definitions/room-name!predicate",
                  stream-id =
                    _js2n__-refsenv."_js2n__-:definitions/stream-id-inner!predicate",
                  view-history =
                    _js2n__-refsenv."_js2n__-:definitions/view-history!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-id!predicate"
        | doc "User id."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType 'Integer
                    ],
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.enum
                [
                  "${ACTIVITY_ID.outputs.user.userSystemInfo.id}",
                  "${event.initiator.user.userId}",
                  "${event.source.fromUser.userId}",
                  "${event.source.toUser.userId}"
                ]
            ],
      "_js2n__-:definitions/user-ids!predicate"
        | doc "List of user ids."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user-ids" ],
              _js2n__-prdslib.records.record
                {
                  user-ids =
                    _js2n__-refsenv."_js2n__-:definitions/user-ids-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-ids-inner!predicate"
        | doc "User identifiers list."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.strings.minLength 1,
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/user-id!predicate",
                  _js2n__-prdslib.arrays.uniqueItems
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1,
                  _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                ],
              _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
            ],
      "_js2n__-:definitions/user-joined-room-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user-joined-room" ],
              _js2n__-prdslib.records.record
                {
                  user-joined-room =
                    _js2n__-refsenv."_js2n__-:definitions/user-joined-room-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-joined-room-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-left-room-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user-left-room" ],
              _js2n__-prdslib.records.record
                {
                  user-left-room =
                    _js2n__-refsenv."_js2n__-:definitions/user-left-room-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-left-room-event-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-requested-join-room-event!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "user-requested-join-room" ],
              _js2n__-prdslib.records.record
                {
                  user-requested-join-room =
                    _js2n__-refsenv."_js2n__-:definitions/user-requested-join-room-event-inner!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/user-requested-join-room-event-inner!predicate" =
        _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/user-role-inner!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "roles", "user-ids" ],
              _js2n__-prdslib.records.record
                {
                  roles =
                    _js2n__-refsenv."_js2n__-:definitions/roles-inner!predicate",
                  user-ids =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Integer
                                      ],
                                    _js2n__-prdslib.strings.minLength 1
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1,
                              _js2n__-prdslib.strings.pattern "^\\$\\{.*\\}$"
                            ],
                          _js2n__-prdslib.enum [ "${variables.VARIABLE_NAME}" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/view-history!predicate"
        | doc "If true, new members can view the room chat history of the room."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
    }
    in
  {
      activities
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.maxProperties 1,
                    _js2n__-prdslib.records.minProperties 1,
                    _js2n__-prdslib.records.record
                      {
                        accept-connection =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/connection-inner!predicate"
                                  ]
                              ],
                        add-group-member =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/add-group-member-inner!predicate"
                                  ]
                              ],
                        add-room-member =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/add-room-member-inner!predicate"
                              ],
                        add-user-role =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-role-inner!predicate"
                              ],
                        create-connection =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/connection-inner!predicate"
                                  ]
                              ],
                        create-group =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/create-group-inner!predicate"
                                  ],
                                _js2n__-prdslib.records.required
                                  [ "members", "name", "owner", "profile" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                        create-room =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/create-room-inner!predicate"
                              ],
                        create-system-user =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "display-name", "email", "username" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always,
                                    _js2n__-refsenv."_js2n__-:definitions/create-system-user-inner!predicate"
                                  ]
                              ],
                        create-user =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [
                                        "display-name",
                                        "email",
                                        "firstname",
                                        "lastname",
                                        "username"
                                      ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always,
                                    _js2n__-refsenv."_js2n__-:definitions/create-user-inner!predicate"
                                  ]
                              ],
                        debug =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "object" ],
                                _js2n__-prdslib.records.record
                                  {
                                    "else" = _js2n__-prdslib.isType 'Record,
                                    id =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^(?!variables$)([a-zA-Z][a-zA-Z0-9_]+)$"
                                          ],
                                    "if" = _js2n__-prdslib.isType '"String",
                                    object =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                    on =
                                      _js2n__-refsenv."_js2n__-:definitions/on!predicate",
                                  } {} true _js2n__-prdslib.always
                              ],
                        demote-room-owner =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/demote-room-owner-inner!predicate"
                              ],
                        execute-request =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/execute-request-inner!predicate"
                              ],
                        execute-script =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/execute-script-inner!predicate"
                              ],
                        get-attachment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/get-attachment-inner!predicate"
                              ],
                        get-connection =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/connection-inner!predicate"
                                  ]
                              ],
                        get-connections =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-connections-inner!predicate"
                                  ]
                              ],
                        get-group =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-group-inner!predicate"
                                  ]
                              ],
                        get-groups =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-groups-inner!predicate"
                                  ]
                              ],
                        get-message =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-message-inner!predicate"
                                  ]
                              ],
                        get-messages =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-messages-inner!predicate"
                                  ]
                              ],
                        get-room =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-room-inner!predicate"
                                  ]
                              ],
                        get-room-members =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-room-members-inner!predicate"
                                  ]
                              ],
                        get-rooms =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-rooms-inner!predicate"
                                  ]
                              ],
                        get-stream =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-stream-inner!predicate"
                                  ]
                              ],
                        get-stream-members =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-stream-members-inner!predicate"
                                  ]
                              ],
                        get-streams =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-streams-inner!predicate"
                                  ]
                              ],
                        get-user =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-user-inner!predicate"
                                  ]
                              ],
                        get-user-streams =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-user-streams-inner!predicate"
                                  ]
                              ],
                        get-users =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/get-users-inner!predicate"
                                  ]
                              ],
                        pin-message =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/pin-message-inner!predicate"
                              ],
                        promote-room-owner =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/promote-room-owner-inner!predicate"
                              ],
                        reject-connection =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/connection-inner!predicate"
                                  ]
                              ],
                        remove-connection =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/connection-inner!predicate"
                                  ]
                              ],
                        remove-room-member =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/remove-room-member-inner!predicate"
                              ],
                        remove-user-role =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/user-role-inner!predicate"
                              ],
                        send-message =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/send-message-inner!predicate"
                              ],
                        unpin-message =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/unpin-message-inner!predicate"
                              ],
                        update-group =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/create-group-inner!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-refsenv."_js2n__-:definitions/update-group-inner!predicate"
                                      ]
                                  ]
                              ],
                        update-message =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/update-message-inner!predicate"
                              ],
                        update-room =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/update-room-inner!predicate"
                              ],
                        update-system-user =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/create-system-user-inner!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "user-id" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        user-id =
                                          _js2n__-refsenv."_js2n__-:definitions/user-id!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ],
                        update-user =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/create-user-inner!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "user-id" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        user-id =
                                          _js2n__-refsenv."_js2n__-:definitions/user-id!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ],
                      }
                      {
                        "^(?!create-room|update-room|add-room-member|remove-room-member|promote-room-owner|demote-room-owner|send-message|update-message|pin-message|unpin-message|debug|execute-script|execute-request|create-user|create-system-user|create-connection|update-user|update-system-user|add-user-role|remove-user-role|remove-connection|reject-connection|accept-connection|get-user|get-users|get-stream|get-room|get-message|get-connection|get-stream-members|get-room-members|get-user-streams|get-streams|get-rooms|get-messages|get-connections)([a-z0-9-]+)$" =
                          _js2n__-refsenv."_js2n__-:definitions/basic-activity-inner!predicate",
                      } false _js2n__-prdslib.never
                  ])
            ])
        | doc "A list of activities to be executed by the workflow. By default the execution is sequential but complex logic can be orchestrated with if/else conditions as well as on/activity-completed events.",
      id
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 100,
              _js2n__-prdslib.strings.pattern "^[a-zA-Z]+[a-zA-Z0-9][^ ]*$"
            ])
        | doc "Workflow's id should start with a letter. It is optional. If no id is provided, the workflow filename is used. Otherwise, it will be generated. The id will appear in logs and audit trails.",
      properties
        | {
          publish
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "Should the workflow be published or not, true publish, false otherwise"
            | optional,
          ..
        }
        | doc "Some metadata about the workflow"
        | optional,
      variables
        | {  .. }
        | doc "Variables are accessible and editable within the entire workflow. A map of key: value entries is expected."
        | optional,
    }