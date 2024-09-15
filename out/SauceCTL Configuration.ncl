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
      "_js2n__-:allOf/0/then/properties/defaults/properties/timeout!predicate"
        | doc "Instructs how long (in ms, s, m, or h) saucectl should wait for a suite to complete."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(?:\\d+h)?(?:\\d+m)?(?:\\d+s)?(?:\\d+ms)?$"
            ],
      "_js2n__-:allOf/0/then/properties/env!predicate"
        | doc "Set one or more environment variables. Values can be environment variables themselves. Not supported when running espresso/xcuitest!"
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:allOf/1/then/allOf/0!predicate"
        | doc "Subschema for sauce specific settings"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  sauce =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              concurrency =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              launchOrder =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.oneOf
                                        [ _js2n__-prdslib.const "fail rate" ]
                                    ],
                              metadata =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          build =
                                            _js2n__-prdslib.isType '"String",
                                          tags =
                                            _js2n__-prdslib.isType '"Array",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              region =
                                _js2n__-prdslib.enum
                                    [
                                      "us-west-1",
                                      "us-east-4",
                                      "eu-central-1"
                                    ],
                              retries =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              sauceignore = _js2n__-prdslib.always,
                              tunnel =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          owner =
                                            _js2n__-prdslib.isType '"String",
                                          timeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.strings.pattern
                                                    "^(?:\\d+h)?(?:\\d+m)?(?:\\d+s)?(?:\\d+ms)?$"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              visibility =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.const "public",
                                          _js2n__-prdslib.const
                                            "public restricted",
                                          _js2n__-prdslib.const "share",
                                          _js2n__-prdslib.const "team",
                                          _js2n__-prdslib.const "private"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/1/then/allOf/1!predicate"
        | doc "Subschema for controlling artifacts"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cleanup = _js2n__-prdslib.isType '"Bool",
                              download =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "directory", "match", "when" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          allAttempts =
                                            _js2n__-prdslib.isType '"Bool",
                                          directory =
                                            _js2n__-prdslib.isType '"String",
                                          "match" =
                                            _js2n__-prdslib.isType '"Array",
                                          when =
                                            _js2n__-prdslib.enum
                                                [
                                                  "always",
                                                  "fail",
                                                  "never",
                                                  "pass"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              retain =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/1/then/allOf/2!predicate"
        | doc "Subschema for reporters specific settings"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  reporters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              json =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          filename =
                                            _js2n__-prdslib.isType '"String",
                                          webhookURL =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              junit =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          filename =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              spotlight =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/1/then/properties/showConsoleLog!predicate"
        | doc "Shows suites console.log locally. By default console.log is only shown on failures."
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:allOf/1/then/properties/suites/items/properties/appSettings!predicate"
        | doc "Overwrite real device settings."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  audioCapture = _js2n__-prdslib.isType '"Bool",
                  instrumentation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { networkCapture = _js2n__-prdslib.isType '"Bool", }
                            {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/1/then/properties/suites/items/properties/emulators/items/properties/orientation!predicate"
        | doc "The screen orientation to use."
        = _js2n__-prdslib.enum [ "landscape", "portrait" ],
      "_js2n__-:allOf/1/then/properties/suites/items/properties/passThreshold!predicate"
        | doc "The minimum number of successful attempts for a suite to be considered as 'passed'."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:allOf/1/then/properties/suites/items/properties/smartRetry!predicate"
        | doc "Optimize suite retries by configuring the strategy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { failedOnly = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/2/then/allOf/1!predicate"
        | doc "Subschema for npm specific settings"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  npm =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dependencies = _js2n__-prdslib.isType '"Array",
                              packages = _js2n__-prdslib.isType 'Record,
                              registries =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.numbers.minimum 0,
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "url" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                auth =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                authToken =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                email =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                password =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                scope =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                url =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                username =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                              registry = _js2n__-prdslib.isType '"String",
                              strictSSL = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/2/then/properties/env!predicate"
        | doc "Set one or more environment variables. Values can be environment variables themselves. Not supported when running espresso/xcuitest!"
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:allOf/2/then/properties/nodeVersion!predicate"
        | doc "Specifies the Node.js version for Sauce Cloud. Supports SemVer notation and aliases."
        = _js2n__-prdslib.always,
      "_js2n__-:allOf/2/then/properties/rootDir!predicate"
        | doc "The directory of files that need to be bundled and uploaded for the tests to run."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:allOf/2/then/properties/suites/items/properties/excludedTestFiles!predicate"
        | doc "Exclude test files to skip the tests."
        = _js2n__-prdslib.isType '"Array",
      "_js2n__-:allOf/2/then/properties/suites/items/properties/preExec!predicate"
        | doc "Specifies which commands to execute before starting the tests."
        = _js2n__-prdslib.isType '"Array",
      "_js2n__-:allOf/2/then/properties/suites/items/properties/screenResolution!predicate"
        | doc "Specifies a browser window screen resolution, which may be useful if you are attempting to simulate a browser on a particular device type."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:allOf/2/then/properties/suites/items/properties/timeZone!predicate"
        | doc "Specifies the timeZone for the suite."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:allOf/3/then/properties/suites/items/properties/browserVersion!predicate"
        | doc "Which version of the browser to use."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:allOf/3/then/properties/suites/items/properties/platform!predicate"
        | doc "A specific operating system on which to run the tests. Sauce Labs will try to choose a reasonable default if not explicitly specified."
        = _js2n__-prdslib.enum
            [
              "macOS 11.00",
              "macOS 12",
              "macOS 13",
              "Windows 10",
              "Windows 11"
            ],
      "_js2n__-:allOf/7/then/properties/playwright/properties/version!predicate"
        | doc "Which framework version to use."
        = _js2n__-prdslib.always,
      "_js2n__-:allOf/7/then/properties/suites/items/properties/browserName!predicate"
        | doc "The name of the browser in which to run the tests."
        = _js2n__-prdslib.always,
      "_js2n__-:allOf/8/then/definitions/reporters!predicate"
        | doc "Supported saucectl reporters."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additionalProperties = _js2n__-prdslib.never,
                  json =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enabled = _js2n__-prdslib.isType '"Bool",
                              filename = _js2n__-prdslib.isType '"String",
                              webhookURL = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/8/then/definitions/sauce!predicate"
        | doc "All settings related to how tests are run and identified in the Sauce Labs platform."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  region = _js2n__-prdslib.enum [ "us-west-1", "eu-central-1" ],
                  tunnel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "name" ],
                          _js2n__-prdslib.records.record
                            {
                              name = _js2n__-prdslib.isType '"String",
                              owner = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/8/then/definitions/service!predicate"
        | doc "The set of properties providing details about how to run the service container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  entrypoint = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType 'Record,
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    dst = _js2n__-prdslib.isType '"String",
                                    src = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  imagePullAuth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              token = _js2n__-prdslib.isType '"String",
                              user = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  resourceProfile =
                    _js2n__-prdslib.enum [ "", "c1m1", "c2m2", "c3m3" ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/8/then/definitions/suite!predicate"
        | doc "The set of properties providing details about how to run the container."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "workload" ],
              _js2n__-prdslib.records.record
                {
                  artifacts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  entrypoint = _js2n__-prdslib.isType '"String",
                  env = _js2n__-prdslib.isType 'Record,
                  files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    dst = _js2n__-prdslib.isType '"String",
                                    src = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  image = _js2n__-prdslib.isType '"String",
                  imagePullAuth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              token = _js2n__-prdslib.isType '"String",
                              user = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  metadata = _js2n__-prdslib.isType 'Record,
                  name = _js2n__-prdslib.isType '"String",
                  resourceProfile =
                    _js2n__-prdslib.strings.pattern "^c(\\d+)m(\\d+)$",
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/service!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?:\\d+h)?(?:\\d+m)?(?:\\d+s)?(?:\\d+ms)?$"
                        ],
                  workload = _js2n__-prdslib.enum [ "webdriver", "other" ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate"
        | doc "Instructs how long (in ms, s, m, or h) saucectl should wait for a suite to complete."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(?:\\d+h)?(?:\\d+m)?(?:\\d+s)?(?:\\d+ms)?$"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  {
                    apiVersion = _js2n__-prdslib.const "v1",
                    kind = _js2n__-prdslib.const "cypress",
                  } {} true _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                artifacts =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            cleanup =
                                              _js2n__-prdslib.isType '"Bool",
                                            download =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [
                                                        "directory",
                                                        "match",
                                                        "when"
                                                      ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        allAttempts =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        directory =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        "match" =
                                                          _js2n__-prdslib.isType
                                                              '"Array",
                                                        when =
                                                          _js2n__-prdslib.enum
                                                              [
                                                                "always",
                                                                "fail",
                                                                "never",
                                                                "pass"
                                                              ],
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ],
                                            retain =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                npm =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            dependencies =
                                              _js2n__-prdslib.isType '"Array",
                                            packages =
                                              _js2n__-prdslib.isType 'Record,
                                            registries =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.numbers.minimum
                                                      0,
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [ "url" ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              auth =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              authToken =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              email =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              password =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              scope =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              url =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              username =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ])
                                                  ],
                                            registry =
                                              _js2n__-prdslib.isType '"String",
                                            strictSSL =
                                              _js2n__-prdslib.isType '"Bool",
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                sauce =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            concurrency =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      1
                                                  ],
                                            launchOrder =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.const
                                                          "fail rate"
                                                      ]
                                                  ],
                                            metadata =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        build =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        tags =
                                                          _js2n__-prdslib.isType
                                                              '"Array",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ],
                                            region =
                                              _js2n__-prdslib.enum
                                                  [
                                                    "us-west-1",
                                                    "eu-central-1"
                                                  ],
                                            retries =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            sauceignore =
                                              _js2n__-prdslib.always,
                                            tunnel =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.records.required
                                                      [ "name" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        name =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        owner =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ],
                                            visibility =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.const
                                                          "public",
                                                        _js2n__-prdslib.const
                                                          "public restricted",
                                                        _js2n__-prdslib.const
                                                          "share",
                                                        _js2n__-prdslib.const
                                                          "team",
                                                        _js2n__-prdslib.const
                                                          "private"
                                                      ]
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                reporters =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            json =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        enabled =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        filename =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        webhookURL =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            junit =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        enabled =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        filename =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            spotlight =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        enabled =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "cypress", "kind", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1",
                        cypress =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "configFile", "version" ],
                                _js2n__-prdslib.records.record
                                  {
                                    configFile =
                                      _js2n__-prdslib.isType '"String",
                                    key = _js2n__-prdslib.isType '"String",
                                    record = _js2n__-prdslib.isType '"Bool",
                                    reporters =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.numbers.minimum 0,
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      options =
                                                        _js2n__-prdslib.always,
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ])
                                          ],
                                    version =
                                      _js2n__-prdslib.enum
                                          [
                                            "package.json",
                                            "13.13.3",
                                            "13.13.1",
                                            "13.12.0",
                                            "13.10.0",
                                            "13.7.3",
                                            "13.6.6",
                                            "13.6.3",
                                            "13.6.0",
                                            "13.4.0",
                                            "13.3.0",
                                            "12.17.4"
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        defaults =
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
                                              "^(?:\\d+h)?(?:\\d+m)?(?:\\d+s)?(?:\\d+ms)?$"
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        env = _js2n__-prdslib.isType 'Record,
                        kind = _js2n__-prdslib.const "cypress",
                        nodeVersion = _js2n__-prdslib.always,
                        rootDir = _js2n__-prdslib.isType '"String",
                        showConsoleLog = _js2n__-prdslib.isType '"Bool",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "browser", "config", "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          browser =
                                            _js2n__-prdslib.enum
                                                [
                                                  "chrome",
                                                  "firefox",
                                                  "microsoftedge",
                                                  "webkit"
                                                ],
                                          browserVersion =
                                            _js2n__-prdslib.isType '"String",
                                          config =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "specPattern" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      env =
                                                        _js2n__-refsenv."_js2n__-:allOf/0/then/properties/env!predicate",
                                                      excludeSpecPattern =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      specPattern =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      testingType =
                                                        _js2n__-prdslib.enum
                                                            [
                                                              "e2e",
                                                              "component"
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          headless =
                                            _js2n__-prdslib.isType '"Bool",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          passThreshold =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          platformName =
                                            _js2n__-prdslib.enum
                                                [
                                                  "macOS 11.00",
                                                  "macOS 12",
                                                  "macOS 13",
                                                  "Windows 10",
                                                  "Windows 11"
                                                ],
                                          preExec =
                                            _js2n__-prdslib.isType '"Array",
                                          screenResolution =
                                            _js2n__-prdslib.isType '"String",
                                          shard =
                                            _js2n__-prdslib.enum
                                                [ "", "concurrency", "spec" ],
                                          shardGrepEnabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          smartRetry =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      failedOnly =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          timeZone =
                                            _js2n__-prdslib.isType '"String",
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/0/then/properties/defaults/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "espresso", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                sauce =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            concurrency =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      1
                                                  ],
                                            launchOrder =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.const
                                                          "fail rate"
                                                      ]
                                                  ],
                                            metadata =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        build =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        tags =
                                                          _js2n__-prdslib.isType
                                                              '"Array",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ],
                                            region =
                                              _js2n__-prdslib.enum
                                                  [
                                                    "us-west-1",
                                                    "us-east-4",
                                                    "eu-central-1"
                                                  ],
                                            retries =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.minimum
                                                      0
                                                  ],
                                            sauceignore =
                                              _js2n__-prdslib.always,
                                            tunnel =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.records.required
                                                      [ "name" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        name =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        owner =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        timeout =
                                                          _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.strings.pattern
                                                                  "^(?:\\d+h)?(?:\\d+m)?(?:\\d+s)?(?:\\d+ms)?$"
                                                              ],
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ],
                                            visibility =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.const
                                                          "public",
                                                        _js2n__-prdslib.const
                                                          "public restricted",
                                                        _js2n__-prdslib.const
                                                          "share",
                                                        _js2n__-prdslib.const
                                                          "team",
                                                        _js2n__-prdslib.const
                                                          "private"
                                                      ]
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                artifacts =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            cleanup =
                                              _js2n__-prdslib.isType '"Bool",
                                            download =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [
                                                        "directory",
                                                        "match",
                                                        "when"
                                                      ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        allAttempts =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        directory =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        "match" =
                                                          _js2n__-prdslib.isType
                                                              '"Array",
                                                        when =
                                                          _js2n__-prdslib.enum
                                                              [
                                                                "always",
                                                                "fail",
                                                                "never",
                                                                "pass"
                                                              ],
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ],
                                            retain =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                reporters =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            json =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        enabled =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        filename =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        webhookURL =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            junit =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        enabled =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        filename =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            spotlight =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        enabled =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                      } {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ]
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "espresso", "kind", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    timeout =
                                      _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        espresso =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "app", "testApp" ],
                                _js2n__-prdslib.records.record
                                  {
                                    app = _js2n__-prdslib.isType '"String",
                                    appDescription =
                                      _js2n__-prdslib.isType '"String",
                                    otherApps =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.maxItems 7
                                          ],
                                    testApp = _js2n__-prdslib.isType '"String",
                                    testAppDescription =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                        kind = _js2n__-prdslib.const "espresso",
                        showConsoleLog = _js2n__-prdslib.isType '"Bool",
                        suites =
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
                                                [ "emulators" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "devices" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          appSettings =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      audioCapture =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      instrumentation =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  networkCapture =
                                                                    _js2n__-prdslib.isType
                                                                        '"Bool",
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          devices =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.records.required
                                                                  [ "id" ],
                                                                _js2n__-prdslib.records.record
                                                                  {} {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.records.required
                                                                  [ "name" ],
                                                                _js2n__-prdslib.records.record
                                                                  {} {} true
                                                                  _js2n__-prdslib.always
                                                              ]
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            id =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            name =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            options =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        carrierConnectivity =
                                                                          _js2n__-prdslib.isType
                                                                              '"Bool",
                                                                        deviceType =
                                                                          _js2n__-prdslib.enum
                                                                              [
                                                                                "ANY",
                                                                                "PHONE",
                                                                                "TABLET"
                                                                              ],
                                                                        private =
                                                                          _js2n__-prdslib.isType
                                                                              '"Bool",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ],
                                                            platformVersion =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ])
                                                ],
                                          emulators =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "name",
                                                            "platformVersions"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            name =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            orientation =
                                                              _js2n__-prdslib.enum
                                                                  [
                                                                    "landscape",
                                                                    "portrait"
                                                                  ],
                                                            platformVersions =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"Array",
                                                                    _js2n__-prdslib.arrays.minItems
                                                                      1
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ])
                                                ],
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          passThreshold =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          smartRetry =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      failedOnly =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          testApp =
                                            _js2n__-prdslib.isType '"String",
                                          testAppDescription =
                                            _js2n__-prdslib.isType '"String",
                                          testOptions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      annotation =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      class =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      clearPackageData =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      filter =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      func =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      listener =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      newRunListenerMode =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      notAnnotation =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      notClass =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      notPackage =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      numShards =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                      package =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      perf =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      runnerBuilder =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      size =
                                                        _js2n__-prdslib.enum
                                                            [
                                                              "small",
                                                              "medium",
                                                              "large"
                                                            ],
                                                      unit =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      useTestOrchestrator =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always,
                                                  _js2n__-prdslib.records.dependencies
                                                    {
                                                      clearPackageData =
                                                        [
                                                            "useTestOrchestrator"
                                                          ],
                                                    }
                                                ],
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "playwright", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/1!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                npm =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            dependencies =
                                              _js2n__-prdslib.isType '"Array",
                                            packages =
                                              _js2n__-prdslib.isType 'Record,
                                            registries =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.numbers.minimum
                                                      0,
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [ "url" ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              auth =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              authToken =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              email =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              password =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              scope =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              url =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              username =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ])
                                                  ],
                                            registry =
                                              _js2n__-prdslib.isType '"String",
                                            strictSSL =
                                              _js2n__-prdslib.isType '"Bool",
                                          } {} false _js2n__-prdslib.never
                                      ],
                              } {} true _js2n__-prdslib.always
                          ],
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/0!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/2!predicate"
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "playwright", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    timeout =
                                      _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        env = _js2n__-prdslib.isType 'Record,
                        kind = _js2n__-prdslib.const "playwright",
                        nodeVersion = _js2n__-prdslib.always,
                        playwright =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "version" ],
                                _js2n__-prdslib.records.record
                                  {
                                    configFile =
                                      _js2n__-prdslib.isType '"String",
                                    version =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.enum
                                              [
                                                "package.json",
                                                "1.46.1",
                                                "1.45.2",
                                                "1.45.0",
                                                "1.44.0",
                                                "1.43.1",
                                                "1.41.2",
                                                "1.41.0",
                                                "1.40.1",
                                                "1.39.0",
                                                "1.38.1",
                                                "1.37.1"
                                              ],
                                            _js2n__-refsenv."_js2n__-:allOf/7/then/properties/playwright/properties/version!predicate"
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        rootDir = _js2n__-prdslib.isType '"String",
                        showConsoleLog =
                          _js2n__-refsenv."_js2n__-:allOf/1/then/properties/showConsoleLog!predicate",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name", "params", "testMatch" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          env =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                                          excludedTestFiles =
                                            _js2n__-prdslib.isType '"Array",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          numShards =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          params =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "browserName" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      browserName =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "chromium",
                                                                  "firefox",
                                                                  "webkit",
                                                                  "chrome"
                                                                ],
                                                              _js2n__-refsenv."_js2n__-:allOf/7/then/properties/suites/items/properties/browserName!predicate"
                                                            ],
                                                      globalTimeout =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      grep =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      grepInvert =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      headless =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      maxFailures =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                      project =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      repeatEach =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                      retries =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.minimum
                                                                0
                                                            ],
                                                      timeout =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      updateSnapshots =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      workers =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.minimum
                                                                1
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          passThreshold =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/passThreshold!predicate",
                                          platformName =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "macOS 11.00",
                                                      "macOS 12",
                                                      "macOS 13",
                                                      "Windows 10",
                                                      "Windows 11"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:allOf/3/then/properties/suites/items/properties/platform!predicate"
                                                ],
                                          playwrightVersion =
                                            _js2n__-refsenv."_js2n__-:allOf/7/then/properties/playwright/properties/version!predicate",
                                          preExec =
                                            _js2n__-prdslib.isType '"Array",
                                          screenResolution =
                                            _js2n__-prdslib.isType '"String",
                                          shard =
                                            _js2n__-prdslib.enum
                                                [ "", "concurrency", "spec" ],
                                          shardGrepEnabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          smartRetry =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/smartRetry!predicate",
                                          testMatch =
                                            _js2n__-prdslib.isType '"Array",
                                          timeZone =
                                            _js2n__-prdslib.isType '"String",
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "puppeteer-replay", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/1!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/0!predicate"
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    timeout =
                                      _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        kind = _js2n__-prdslib.const "puppeteer-replay",
                        showConsoleLog =
                          _js2n__-refsenv."_js2n__-:allOf/1/then/properties/showConsoleLog!predicate",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name", "recordings" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          browserName =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [ "chrome" ],
                                                  _js2n__-refsenv."_js2n__-:allOf/7/then/properties/suites/items/properties/browserName!predicate"
                                                ],
                                          browserVersion =
                                            _js2n__-prdslib.isType '"String",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          passThreshold =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/passThreshold!predicate",
                                          platform =
                                            _js2n__-prdslib.enum
                                                [
                                                  "macOS 11.00",
                                                  "macOS 12",
                                                  "macOS 13",
                                                  "Windows 10",
                                                  "Windows 11"
                                                ],
                                          recordings =
                                            _js2n__-prdslib.isType '"Array",
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "testcafe", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/1!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/2/then/allOf/1!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/0!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/2!predicate"
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "suites", "testcafe" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    timeout =
                                      _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        env =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                        kind = _js2n__-prdslib.const "testcafe",
                        nodeVersion =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/nodeVersion!predicate",
                        rootDir =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/rootDir!predicate",
                        showConsoleLog =
                          _js2n__-refsenv."_js2n__-:allOf/1/then/properties/showConsoleLog!predicate",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "browserName", "name", "src" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          ajaxRequestTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          assertionTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          browserArgs =
                                            _js2n__-prdslib.isType '"Array",
                                          browserInitTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          browserName =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "chrome",
                                                      "firefox",
                                                      "microsoftedge",
                                                      "safari"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:allOf/7/then/properties/suites/items/properties/browserName!predicate"
                                                ],
                                          browserVersion =
                                            _js2n__-refsenv."_js2n__-:allOf/3/then/properties/suites/items/properties/browserVersion!predicate",
                                          clientScripts =
                                            _js2n__-prdslib.isType '"Array",
                                          compilerOptions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      typescript =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  configPath =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  customCompilerModulePath =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  options =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Record,
                                                                          _js2n__-prdslib.records.record
                                                                            {}
                                                                            {}
                                                                            true
                                                                            _js2n__-prdslib.always
                                                                        ],
                                                                } {} true
                                                                _js2n__-prdslib.always
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          disablePageCaching =
                                            _js2n__-prdslib.isType '"Bool",
                                          disableScreenshots =
                                            _js2n__-prdslib.isType '"Bool",
                                          disableVideo =
                                            _js2n__-prdslib.isType '"Bool",
                                          env =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                                          esm = _js2n__-prdslib.isType '"Bool",
                                          excludedTestFiles =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/excludedTestFiles!predicate",
                                          filter =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      fixture =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      fixtureGrep =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      fixtureMeta =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                      test =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      testGrep =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      testMeta =
                                                        _js2n__-prdslib.isType
                                                            'Record,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          headless =
                                            _js2n__-prdslib.isType '"Bool",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          pageLoadTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          pageRequestTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          passThreshold =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/passThreshold!predicate",
                                          platformName =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "macOS 11.00",
                                                      "macOS 12",
                                                      "macOS 13",
                                                      "Windows 10",
                                                      "Windows 11"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:allOf/3/then/properties/suites/items/properties/platform!predicate"
                                                ],
                                          preExec =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/preExec!predicate",
                                          quarantineMode =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      attemptLimit =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      successThreshold =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          runExecutionTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          screenResolution =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/screenResolution!predicate",
                                          screenshots =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      fullPage =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      takeOnFails =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          selectorTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          shard =
                                            _js2n__-prdslib.enum
                                                [ "", "concurrency", "spec" ],
                                          simulators =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.records.record
                                                      {
                                                        name =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        orientation =
                                                          _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/emulators/items/properties/orientation!predicate",
                                                        platformName =
                                                          _js2n__-prdslib.enum
                                                              [ "iOS" ],
                                                        platformVersions =
                                                          _js2n__-prdslib.isType
                                                              '"Array",
                                                      } {} false
                                                      _js2n__-prdslib.never)
                                                ],
                                          skipJsErrors =
                                            _js2n__-prdslib.isType '"Bool",
                                          skipUncaughtErrors =
                                            _js2n__-prdslib.isType '"Bool",
                                          smartRetry =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/smartRetry!predicate",
                                          speed =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.numbers.maximum
                                                    1,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0.01
                                                ],
                                          src = _js2n__-prdslib.isType '"Array",
                                          stopOnFirstFail =
                                            _js2n__-prdslib.isType '"Bool",
                                          testExecutionTimeout =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          timeZone =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/timeZone!predicate",
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                        testcafe =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "version" ],
                                _js2n__-prdslib.records.record
                                  {
                                    configFile =
                                      _js2n__-prdslib.isType '"String",
                                    version =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.enum
                                              [
                                                "package.json",
                                                "3.6.2",
                                                "3.6.1",
                                                "3.6.0",
                                                "3.5.0",
                                                "3.4.0",
                                                "3.3.0",
                                                "3.2.0"
                                              ],
                                            _js2n__-refsenv."_js2n__-:allOf/7/then/properties/playwright/properties/version!predicate"
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "xcuitest", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/0!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/1!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/2!predicate"
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    timeout =
                                      _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        env =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                        kind = _js2n__-prdslib.const "xcuitest",
                        showConsoleLog =
                          _js2n__-refsenv."_js2n__-:allOf/1/then/properties/showConsoleLog!predicate",
                        suites =
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
                                                [ "simulators" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "devices" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          app =
                                            _js2n__-prdslib.isType '"String",
                                          appDescription =
                                            _js2n__-prdslib.isType '"String",
                                          appSettings =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/appSettings!predicate",
                                          devices =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.records.required
                                                                  [ "id" ],
                                                                _js2n__-prdslib.records.record
                                                                  {} {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.records.required
                                                                  [ "name" ],
                                                                _js2n__-prdslib.records.record
                                                                  {} {} true
                                                                  _js2n__-prdslib.always
                                                              ]
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            id =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            name =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            options =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      'Record,
                                                                    _js2n__-prdslib.records.record
                                                                      {
                                                                        carrierConnectivity =
                                                                          _js2n__-prdslib.isType
                                                                              '"Bool",
                                                                        deviceType =
                                                                          _js2n__-prdslib.enum
                                                                              [
                                                                                "ANY",
                                                                                "PHONE",
                                                                                "TABLET"
                                                                              ],
                                                                        private =
                                                                          _js2n__-prdslib.isType
                                                                              '"Bool",
                                                                      } {} false
                                                                      _js2n__-prdslib.never
                                                                  ],
                                                            platformVersion =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ])
                                                ],
                                          env =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          otherApps =
                                            _js2n__-prdslib.isType '"Array",
                                          passThreshold =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/passThreshold!predicate",
                                          shard =
                                            _js2n__-prdslib.enum
                                                [ "", "concurrency" ],
                                          simulators =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.records.required
                                                          [
                                                            "name",
                                                            "platformVersions"
                                                          ],
                                                        _js2n__-prdslib.records.record
                                                          {
                                                            armRequired =
                                                              _js2n__-prdslib.isType
                                                                  '"Bool",
                                                            name =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                            orientation =
                                                              _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/emulators/items/properties/orientation!predicate",
                                                            platformVersions =
                                                              _js2n__-prdslib.allOf
                                                                  [
                                                                    _js2n__-prdslib.isType
                                                                      '"Array",
                                                                    _js2n__-prdslib.arrays.minItems
                                                                      1
                                                                  ],
                                                          } {} false
                                                          _js2n__-prdslib.never
                                                      ])
                                                ],
                                          smartRetry =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/smartRetry!predicate",
                                          testApp =
                                            _js2n__-prdslib.isType '"String",
                                          testAppDescription =
                                            _js2n__-prdslib.isType '"String",
                                          testListFile =
                                            _js2n__-prdslib.isType '"String",
                                          testOptions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      class =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      defaultTestExecutionTimeAllowance =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      maximumTestExecutionTimeAllowance =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      notClass =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      statusBarOverrideTime =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      testLanguage =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      testRegion =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      testTimeoutsEnabled =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ "Yes", "No" ]
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                        xcuitest =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    app = _js2n__-prdslib.isType '"String",
                                    appDescription =
                                      _js2n__-prdslib.isType '"String",
                                    otherApps = _js2n__-prdslib.isType '"Array",
                                    testApp = _js2n__-prdslib.isType '"String",
                                    testAppDescription =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "apitest", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/0!predicate",
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        kind = _js2n__-prdslib.const "apitest",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name", "projectName" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          projectName =
                                            _js2n__-prdslib.isType '"String",
                                          tags =
                                            _js2n__-prdslib.isType '"Array",
                                          testMatch =
                                            _js2n__-prdslib.isType '"Array",
                                          tests =
                                            _js2n__-prdslib.isType '"Array",
                                          useRemoteTests =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "playwright-cucumberjs", } {}
                  true _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/1!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/2/then/allOf/1!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/0!predicate",
                        _js2n__-refsenv."_js2n__-:allOf/1/then/allOf/2!predicate"
                      ],
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "playwright", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    timeout =
                                      _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                  } {} false _js2n__-prdslib.never
                              ],
                        env =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                        kind = _js2n__-prdslib.const "playwright-cucumberjs",
                        nodeVersion =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/nodeVersion!predicate",
                        playwright =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "version" ],
                                _js2n__-prdslib.records.record
                                  { version = _js2n__-prdslib.always, } {} false
                                  _js2n__-prdslib.never
                              ],
                        rootDir =
                          _js2n__-refsenv."_js2n__-:allOf/2/then/properties/rootDir!predicate",
                        showConsoleLog =
                          _js2n__-refsenv."_js2n__-:allOf/1/then/properties/showConsoleLog!predicate",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          browserName = _js2n__-prdslib.always,
                                          browserVersion =
                                            _js2n__-refsenv."_js2n__-:allOf/3/then/properties/suites/items/properties/browserVersion!predicate",
                                          env =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/env!predicate",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          options =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "paths" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      backtrace =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      config =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      excludedTestFiles =
                                                        _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/excludedTestFiles!predicate",
                                                      format =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      formatOptions =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      "import" =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      parallel =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      paths =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      require =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                      tags =
                                                        _js2n__-prdslib.isType
                                                            '"Array",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          passThreshold =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/passThreshold!predicate",
                                          platformName =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "macOS 11.00",
                                                      "macOS 12",
                                                      "macOS 13",
                                                      "Windows 10",
                                                      "Windows 11"
                                                    ],
                                                  _js2n__-refsenv."_js2n__-:allOf/3/then/properties/suites/items/properties/platform!predicate"
                                                ],
                                          preExec =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/preExec!predicate",
                                          screenResolution =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/screenResolution!predicate",
                                          shard =
                                            _js2n__-prdslib.enum
                                                [
                                                  "",
                                                  "concurrency",
                                                  "spec",
                                                  "scenario"
                                                ],
                                          shardTagsEnabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          smartRetry =
                                            _js2n__-refsenv."_js2n__-:allOf/1/then/properties/suites/items/properties/smartRetry!predicate",
                                          timeZone =
                                            _js2n__-refsenv."_js2n__-:allOf/2/then/properties/suites/items/properties/timeZone!predicate",
                                          timeout =
                                            _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite/properties/timeout!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]),
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { kind = _js2n__-prdslib.const "imagerunner", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required
                      [ "apiVersion", "kind", "suites" ],
                    _js2n__-prdslib.records.record
                      {
                        apiVersion = _js2n__-prdslib.const "v1alpha",
                        defaults =
                          _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite!predicate",
                        kind = _js2n__-prdslib.const "imagerunner",
                        reporters =
                          _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/reporters!predicate",
                        sauce =
                          _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/sauce!predicate",
                        suites =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:allOf/8/then/definitions/suite!predicate",
                                _js2n__-prdslib.arrays.minItems 1
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always
            ],
          _js2n__-prdslib.records.record
            {
              kind =
                _js2n__-prdslib.enum
                    [
                      "apitest",
                      "cypress",
                      "espresso",
                      "imagerunner",
                      "playwright",
                      "puppeteer-replay",
                      "testcafe",
                      "xcuitest",
                      "playwright-cucumberjs"
                    ],
            } {} true _js2n__-prdslib.always
        ])