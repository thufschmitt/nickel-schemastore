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
      "_js2n__-:definitions/AwsAlexaSmartHome!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  appId = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsApiGateway!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiKeySourceType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "HEADER", "AUTHORIZER" ]
                        ],
                  apiKeys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        customerId =
                                          _js2n__-prdslib.isType '"String",
                                        description =
                                          _js2n__-prdslib.isType '"String",
                                        enabled =
                                          _js2n__-prdslib.isType '"Bool",
                                        name = _js2n__-prdslib.isType '"String",
                                        value =
                                          _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ])
                        ],
                  binaryMediaTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  disableDefaultEndpoint = _js2n__-prdslib.isType '"Bool",
                  metrics = _js2n__-prdslib.isType '"Bool",
                  minimumCompressionSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 10485760,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  restApiId = _js2n__-prdslib.isType '"String",
                  restApiResources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  restApiRootResourceId = _js2n__-prdslib.isType '"String",
                  shouldStartNameWithService = _js2n__-prdslib.isType '"Bool",
                  usagePlan =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              quota =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          limit =
                                            _js2n__-prdslib.isType '"Number",
                                          offset =
                                            _js2n__-prdslib.isType '"Number",
                                          period =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              throttle =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          burstLimit =
                                            _js2n__-prdslib.isType '"Number",
                                          rateLimit =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  websocketApiId = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsCloudFront!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  eventType = _js2n__-prdslib.isType '"String",
                  includeBody = _js2n__-prdslib.isType '"Bool",
                  origin =
                    _js2n__-refsenv."_js2n__-:definitions/AwsOrigin!predicate",
                  pathPattern = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsCloudwatchLog!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filter = _js2n__-prdslib.isType '"String",
                  logGroup = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsCognitoUserPool!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  existing = _js2n__-prdslib.isType '"Bool",
                  pool = _js2n__-prdslib.isType '"String",
                  trigger = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsDeploymentBucket!predicate"
        | doc "Configure the S3 bucket used by Serverless Framework to deploy code packages to Lambda"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  blockPublicAccess = _js2n__-prdslib.isType '"Bool",
                  maxPreviousDeploymentArtifacts =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  serverSideEncryption = _js2n__-prdslib.isType '"String",
                  skipPolicySetup = _js2n__-prdslib.isType '"Bool",
                  sseCustomerAlgorithim = _js2n__-prdslib.isType '"String",
                  sseCustomerKey = _js2n__-prdslib.isType '"String",
                  sseCustomerKeyMD5 = _js2n__-prdslib.isType '"String",
                  sseKMSKeyId = _js2n__-prdslib.isType '"String",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/AwsTags!predicate",
                  versioning = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsDestinations!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  onFailure = _js2n__-prdslib.isType '"String",
                  onSuccess = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsDetail!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String")
                  ])
            ],
      "_js2n__-:definitions/AwsEnvironment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsEvent!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  activemq = _js2n__-prdslib.always,
                  alb = _js2n__-prdslib.always,
                  alexaSkill = _js2n__-prdslib.always,
                  alexaSmartHome =
                    _js2n__-refsenv."_js2n__-:definitions/AwsAlexaSmartHome!predicate",
                  cloudFront =
                    _js2n__-refsenv."_js2n__-:definitions/AwsCloudFront!predicate",
                  cloudwatchEvent = _js2n__-prdslib.always,
                  cloudwatchLog =
                    _js2n__-refsenv."_js2n__-:definitions/AwsCloudwatchLog!predicate",
                  cognitoUserPool =
                    _js2n__-refsenv."_js2n__-:definitions/AwsCognitoUserPool!predicate",
                  eventBridge =
                    _js2n__-refsenv."_js2n__-:definitions/AwsEventBridge!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/AwsHttp!predicate",
                  httpApi =
                    _js2n__-refsenv."_js2n__-:definitions/AwsHttpApiEvent!predicate",
                  iot = _js2n__-refsenv."_js2n__-:definitions/AwsIot!predicate",
                  s3 = _js2n__-refsenv."_js2n__-:definitions/AwsS3!predicate",
                  schedule =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.isType '"String"
                        ],
                  sns = _js2n__-prdslib.always,
                  sqs =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.isType '"String"
                        ],
                  stream =
                    _js2n__-refsenv."_js2n__-:definitions/AwsStream!predicate",
                  websocket =
                    _js2n__-refsenv."_js2n__-:definitions/AwsWebsocket!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsEventBridge!predicate"
        | doc "Aws Lambda function Eventbridge event source"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "pattern" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "schedule" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  eventBus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  input = _js2n__-prdslib.isType 'Record,
                  inputPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 256,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  inputTransformer = _js2n__-prdslib.always,
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 64,
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern "[a-zA-Z0-9-_.]+"
                        ],
                  pattern =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AwsPatternExisting!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/AwsPatternInput!predicate"
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              maximumEventAge =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.numbers.maximum 86400,
                                      _js2n__-prdslib.numbers.minimum 60
                                    ],
                              maximumRetryAttempts =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.numbers.maximum 185,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  schedule =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?:cron|rate)\\(.+\\)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsFunction!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  awsKmsKeyArn = _js2n__-prdslib.isType '"String",
                  condition = _js2n__-prdslib.isType '"String",
                  dependsOn =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  destinations =
                    _js2n__-refsenv."_js2n__-:definitions/AwsDestinations!predicate",
                  environment =
                    _js2n__-refsenv."_js2n__-:definitions/AwsEnvironment!predicate",
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AwsEvent!predicate"
                        ],
                  handler = _js2n__-prdslib.isType '"String",
                  image =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  command =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  entryPoint =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  name = _js2n__-prdslib.isType '"String",
                                  uri = _js2n__-prdslib.isType '"String",
                                  workingDirectory =
                                    _js2n__-prdslib.isType '"String",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  layers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.always,
                                _js2n__-prdslib.always,
                                _js2n__-prdslib.always,
                                _js2n__-prdslib.always,
                                _js2n__-prdslib.always
                              ])
                        ],
                  logDataProtectionPolicy = _js2n__-prdslib.always,
                  memorySize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  onError = _js2n__-prdslib.isType '"String",
                  package = _js2n__-prdslib.always,
                  provisionedConcurrency =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.always
                        ],
                  reservedConcurrency =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                          _js2n__-prdslib.always,
                          _js2n__-prdslib.always
                        ],
                  role = _js2n__-prdslib.isType '"String",
                  runtime = _js2n__-prdslib.always,
                  runtimeManagement = _js2n__-prdslib.always,
                  snapStart = _js2n__-prdslib.isType '"Bool",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/AwsTags!predicate",
                  timeout =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  tracing = _js2n__-prdslib.isType '"String",
                  vpc = _js2n__-refsenv."_js2n__-:definitions/AwsVpc!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsFunctions!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/AwsFunction!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/ServerlessFilePath!predicate"
                ]
            ],
      "_js2n__-:definitions/AwsHttp!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      async = _js2n__-prdslib.isType '"Bool",
                      authorizer =
                        _js2n__-refsenv."_js2n__-:definitions/AwsHttpAuthorizer!predicate",
                      cors = _js2n__-prdslib.always,
                      method = _js2n__-prdslib.isType '"String",
                      path = _js2n__-prdslib.isType '"String",
                      private = _js2n__-prdslib.isType '"Bool",
                      request =
                        _js2n__-refsenv."_js2n__-:definitions/AwsHttpRequestValidation!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [
                      "ANY /",
                      "GET /",
                      "POST /",
                      "PUT /",
                      "PATCH /",
                      "OPTIONS /",
                      "HEAD /",
                      "DELETE /",
                      "ANY /{proxy+}",
                      "GET /{proxy+}",
                      "POST /{proxy+}",
                      "PUT /{proxy+}",
                      "PATCH /{proxy+}",
                      "OPTIONS /{proxy+}",
                      "HEAD /{proxy+}",
                      "DELETE /{proxy+}"
                    ]
                ]
            ],
      "_js2n__-:definitions/AwsHttpApiEvent!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      authorizer =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/AwsNamedHttpApiEventAuthorizer!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/AwsIdRefHttpApiEventAuthorizer!predicate"
                            ],
                      method = _js2n__-prdslib.isType '"String",
                      path = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ]
            ],
      "_js2n__-:definitions/AwsHttpApiLogs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { format = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsHttpAuthorizer!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "aws_iam" ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "type" ],
                  _js2n__-prdslib.records.record
                    {
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "aws_iam" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required [ "arn", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      arn = _js2n__-prdslib.isType '"String",
                      claims =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      identitySource = _js2n__-prdslib.isType '"String",
                      identityValidationExpression =
                        _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      resultTtlInSeconds =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.numbers.maximum 3600,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      scopes =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "COGNITO_USER_POOLS" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "arn" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "name" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.records.record
                    {
                      arn = _js2n__-prdslib.isType '"String",
                      identitySource = _js2n__-prdslib.isType '"String",
                      identityValidationExpression =
                        _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                      resultTtlInSeconds =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.numbers.maximum 3600,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "request", "token", "REQUEST", "TOKEN" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "authorizerId", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      authorizerId = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "CUSTOM" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/AwsHttpRequestParametersValidation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                  querystrings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"Bool")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsHttpRequestValidation!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  parameters =
                    _js2n__-refsenv."_js2n__-:definitions/AwsHttpRequestParametersValidation!predicate",
                  schema =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsIdRefHttpApiEventAuthorizer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsIot!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  sql = _js2n__-prdslib.isType '"String",
                  sqlVersion = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsLogs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  frameworkLambda = _js2n__-prdslib.isType '"Bool",
                  httpApi =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/AwsHttpApiLogs!predicate",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  restApi =
                    _js2n__-refsenv."_js2n__-:definitions/AwsRestApiLogs!predicate",
                  websocket =
                    _js2n__-refsenv."_js2n__-:definitions/AwsWebsocketLogs!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsNamedHttpApiEventAuthorizer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsOrigin!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  CustomOriginConfig =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              OriginProtocolPolicy =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  DomainName = _js2n__-prdslib.isType '"String",
                  OriginPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsPatternExisting!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  source =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsPatternInput!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detail =
                    _js2n__-refsenv."_js2n__-:definitions/AwsDetail!predicate",
                  detail-type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  source =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsProvider!predicate"
        | doc "Configuration for Serverless AWS "
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  alb = _js2n__-prdslib.always,
                  apiGateway =
                    _js2n__-refsenv."_js2n__-:definitions/AwsApiGateway!predicate",
                  apiKeys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  apiName = _js2n__-prdslib.isType '"String",
                  architecture = _js2n__-prdslib.always,
                  cfnRole = _js2n__-prdslib.isType '"String",
                  deploymentBucket =
                    _js2n__-refsenv."_js2n__-:definitions/AwsDeploymentBucket!predicate",
                  deploymentMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "direct", "changesets" ]
                        ],
                  deploymentPrefix = _js2n__-prdslib.isType '"String",
                  disableRollback = _js2n__-prdslib.isType '"Bool",
                  ecr =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              images =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    uri =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ],
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    buildArgs =
                                                      _js2n__-prdslib.isType
                                                          'Record,
                                                    cacheFrom =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.isType
                                                                '"String")
                                                          ],
                                                    file =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    path =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ]
                                          ])
                                    ],
                              scanOnPush = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  endpointType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "EDGE", "PRIVATE", "REGIONAL" ]
                        ],
                  environment =
                    _js2n__-refsenv."_js2n__-:definitions/AwsEnvironment!predicate",
                  httpApi = _js2n__-prdslib.always,
                  iam = _js2n__-prdslib.always,
                  iamManagedPolicies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  iamRoleStatements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  logDataProtectionPolicy = _js2n__-prdslib.always,
                  logRetentionInDays =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  logs =
                    _js2n__-refsenv."_js2n__-:definitions/AwsLogs!predicate",
                  memorySize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number"
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Number",
                                  _js2n__-prdslib.numbers.maximum 10240,
                                  _js2n__-prdslib.numbers.minimum 128
                                ]
                            ]
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "aws" ]
                        ],
                  notificationArns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  profile = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.always,
                  reservedConcurrency =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  resourcePolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AwsResourcePolicy!predicate"
                        ],
                  role = _js2n__-prdslib.isType '"String",
                  rolePermissionsBoundary = _js2n__-prdslib.isType '"String",
                  rollbackConfiguration =
                    _js2n__-refsenv."_js2n__-:definitions/AwsRollbackConfiguration!predicate",
                  runtime = _js2n__-prdslib.always,
                  runtimeManagement = _js2n__-prdslib.always,
                  stackName = _js2n__-prdslib.isType '"String",
                  stackParameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AwsStackParameters!predicate"
                        ],
                  stackPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AwsResourcePolicy!predicate"
                        ],
                  stackTags =
                    _js2n__-refsenv."_js2n__-:definitions/AwsTags!predicate",
                  stage = _js2n__-prdslib.isType '"String",
                  tags =
                    _js2n__-refsenv."_js2n__-:definitions/AwsTags!predicate",
                  timeout =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  tracing =
                    _js2n__-refsenv."_js2n__-:definitions/AwsTracing!predicate",
                  usagePlan =
                    _js2n__-refsenv."_js2n__-:definitions/AwsUsagePlan!predicate",
                  versionFunctions = _js2n__-prdslib.isType '"Bool",
                  vpc = _js2n__-refsenv."_js2n__-:definitions/AwsVpc!predicate",
                  websocketsApiName = _js2n__-prdslib.isType '"String",
                  websocketsApiRouteSelectionExpression =
                    _js2n__-prdslib.isType '"String",
                  websocketsDescription = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsQuota!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  limit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  offset =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  period = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsResourcePolicy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Action =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  Condition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  Effect =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Allow", "Deny" ]
                        ],
                  Principal =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  Resource =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsRestApiLogs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessLogging = _js2n__-prdslib.isType '"Bool",
                  executionLogging = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  fullExecutionData = _js2n__-prdslib.isType '"Bool",
                  level = _js2n__-prdslib.isType '"String",
                  role = _js2n__-prdslib.isType '"String",
                  roleManagedExternally = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsRollbackConfiguration!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  MonitoringTimeInMinutes =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  RollbackTriggers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AwsRollbackTrigger!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsRollbackTrigger!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Arn = _js2n__-prdslib.isType '"String",
                  Type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsS3!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      bucket = _js2n__-prdslib.isType '"String",
                      event = _js2n__-prdslib.isType '"String",
                      existing = _js2n__-prdslib.isType '"Bool",
                      rules =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/AwsS3Rule!predicate"
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.maxLength 63,
                  _js2n__-prdslib.strings.minLength 3,
                  _js2n__-prdslib.strings.pattern
                    "(?!(^((2(5[0-5]|[0-4][0-9])|[01]?[0-9]{1,2})\\.){3}(2(5[0-5]|[0-4][0-9])|[01]?[0-9]{1,2})$|^xn--|-s3alias$))^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$"
                ]
            ],
      "_js2n__-:definitions/AwsS3Rule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  prefix = _js2n__-prdslib.isType '"String",
                  suffix = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsStackParameters!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ParameterKey = _js2n__-prdslib.isType '"String",
                  ParameterValue = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsStream!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arn = _js2n__-prdslib.always,
                  batchSize =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  startingPosition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsTags!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/AwsThrottle!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  burstLimit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  rateLimit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsTracing!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apiGateway = _js2n__-prdslib.isType '"Bool",
                  lambda = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsUsagePlan!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  quota =
                    _js2n__-refsenv."_js2n__-:definitions/AwsQuota!predicate",
                  throttle =
                    _js2n__-refsenv."_js2n__-:definitions/AwsThrottle!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsVpc!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "securityGroupIds", "subnetIds" ],
              _js2n__-prdslib.records.record
                {
                  securityGroupIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.always,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  subnetIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.always,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsWebsocket!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authorizer =
                    _js2n__-refsenv."_js2n__-:definitions/AwsWebsocketAuthorizer!predicate",
                  route = _js2n__-prdslib.isType '"String",
                  routeResponseSelectionExpression =
                    _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsWebsocketAuthorizer!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arn = _js2n__-prdslib.isType '"String",
                  identitySource =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AwsWebsocketLogs!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessLogging = _js2n__-prdslib.isType '"Bool",
                  executionLogging = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  fullExecutionData = _js2n__-prdslib.isType '"Bool",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "INFO", "ERROR" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ServerlessCustom!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  esbuild = _js2n__-prdslib.always,
                  prune = _js2n__-prdslib.always,
                  pythonRequirements = _js2n__-prdslib.always,
                  splitStacks = _js2n__-prdslib.always,
                  ssmPublish = _js2n__-prdslib.always,
                  webpack = _js2n__-prdslib.always,
                  wsgi = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ServerlessFilePath!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.strings.pattern
                "\\$\\{file\\(.+\\.(yml|yaml)\\)(:[A-Za-z]+)?(\\s*,\\s*(\"[^,]*\"|'[^,]*'|[A-Za-z:._-]+)\\s*)?\\}"
            ],
      "_js2n__-:definitions/ServerlessFrameworkResources!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      AWSTemplateFormatVersion =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "2010-09-09" ]
                            ],
                      Conditions = _js2n__-prdslib.always,
                      Description =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.maxLength 1024
                            ],
                      Hooks = _js2n__-prdslib.isType 'Record,
                      Mappings =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9._-]{1,255}$" =
                                    _js2n__-prdslib.always,
                                } false _js2n__-prdslib.never
                            ],
                      Metadata = _js2n__-prdslib.isType 'Record,
                      Outputs = _js2n__-prdslib.always,
                      Parameters = _js2n__-prdslib.always,
                      Resources = _js2n__-prdslib.always,
                      Rules = _js2n__-prdslib.isType 'Record,
                      Transform =
                        _js2n__-refsenv."_js2n__-:definitions/Transform!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/ServerlessFilePath!predicate"
            ],
      "_js2n__-:definitions/ServerlessServiceConfiguration!predicate"
        | doc "**@deprecated and doesn't work in serverless framework v3**"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  awsKmsKeyArn = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Transform!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.records.record
                    {
                      Name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "AWS::Include" ]
                            ],
                      Parameters =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                { Location = _js2n__-prdslib.isType '"String", }
                                {} false _js2n__-prdslib.never
                            ],
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "AWS::CodeDeployBlueGreen",
                          "AWS::CodeStar",
                          "AWS::SecretsManager-2020-07-23",
                          "AWS::Serverless-2016-10-31"
                        ]
                    ]
                ]
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "provider", "service" ],
          _js2n__-prdslib.records.record
            {
              app = _js2n__-prdslib.isType '"String",
              custom =
                _js2n__-refsenv."_js2n__-:definitions/ServerlessCustom!predicate",
              frameworkVersion = _js2n__-prdslib.isType '"String",
              functions =
                _js2n__-refsenv."_js2n__-:definitions/AwsFunctions!predicate",
              layers = _js2n__-prdslib.always,
              org = _js2n__-prdslib.isType '"String",
              package = _js2n__-prdslib.always,
              plugins =
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
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              localPath = _js2n__-prdslib.isType '"String",
                              modules =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              provider =
                _js2n__-refsenv."_js2n__-:definitions/AwsProvider!predicate",
              resources =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/ServerlessFrameworkResources!predicate",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ServerlessFrameworkResources!predicate"
                        ]
                    ],
              service =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-refsenv."_js2n__-:definitions/ServerlessServiceConfiguration!predicate",
                      _js2n__-prdslib.isType '"String"
                    ],
              stepFunctions = _js2n__-prdslib.always,
              tenant = _js2n__-prdslib.isType '"String",
            } {} true _js2n__-prdslib.always
        ])