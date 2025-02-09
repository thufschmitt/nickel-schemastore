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
      "_js2n__-:definitions/admin_worker!contract" =
        {
            enable_admin_worker | Bool | optional,
            enable_notification_worker | Bool | optional,
            enable_queue_stats_worker | Bool | optional,
            poll_interval | std.number.Integer | optional,
            transports | Array (String) | optional,
          },
      "_js2n__-:definitions/api!contract" =
        {
            access_token_ttl | String | optional,
            api_browser
              | _js2n__-refsenv."_js2n__-:definitions/api_browser!contract"
              | optional,
            max_limit
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.isType 'Null
                  ])
              | optional,
            rate_limiter
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter!contract"
              | optional,
            refresh_token_ttl | String | optional,
            store
              | _js2n__-refsenv."_js2n__-:definitions/api_store!contract"
              | optional,
          },
      "_js2n__-:definitions/api_browser!contract" =
        { auth_required | Bool | optional, },
      "_js2n__-:definitions/api_store!contract" =
        {
            context_lifetime | String | optional,
            max_limit
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.isType 'Null
                  ])
              | optional,
          },
      "_js2n__-:definitions/auto_update!contract" =
        { enabled | Bool | optional, },
      "_js2n__-:definitions/cache!contract" =
        {
            cache_compression
              | Bool
              | doc "Controls the cache compression before the storage"
              | optional,
            cache_compression_method
              | std.enum.TagOrString
              | [| 'zstd, 'gzip |]
              | doc "Controls the cache compression method"
              | optional,
            invalidation
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation!contract"
              | optional,
            redis_prefix | String | optional,
            tagging
              | _js2n__-refsenv."_js2n__-:definitions/cache_tags!contract"
              | optional,
          },
      "_js2n__-:definitions/cache_invalidation!contract" =
        {
            category_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            count | std.number.Integer | optional,
            country_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            country_state_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            currency_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            delay | std.number.Integer | optional,
            delay_options
              | {
                connection | String | optional,
                dsn | String | optional,
                storage
                  | std.enum.TagOrString
                  | [| 'mysql, 'redis, 'cache |]
                  | optional,
              }
              | optional,
            http_cache
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            landing_page_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            language_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            navigation_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            payment_method_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            product_cross_selling_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            product_detail_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            product_listing_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            product_review_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            product_search_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            product_suggest_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            salutation_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            shipping_method_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
            sitemap_route
              | _js2n__-refsenv."_js2n__-:definitions/cache_invalidation_states!contract"
              | optional,
          },
      "_js2n__-:definitions/cache_invalidation_states!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "logged-in", "cart-filled" ]
                    ])
              ]),
      "_js2n__-:definitions/cache_tags!contract" =
        {
            each_config
              | Bool
              | doc "If enabled, each config will be cached with a unique tag. This allows to invalidate a single config. If disabled, the whole page will be invalidated on each config change."
              | optional,
            each_snippet
              | Bool
              | doc "If enabled, each snippet will be cached with a unique tag. This allows to invalidate a single snippet. If disabled, the whole page will be invalidated on each snippet change."
              | optional,
            each_theme_config
              | Bool
              | doc "If enabled, each theme config will be cached with a unique tag. This allows to invalidate a single theme config. If disabled, the whole page will be invalidated on each theme config change."
              | optional,
          },
      "_js2n__-:definitions/cart!contract" =
        {
            compress
              | Bool
              | doc "All carts, which stored in redis, are compressed via gzcompress. This option is only available if redis is used."
              | optional,
            compression_method
              | std.enum.TagOrString
              | [| 'zstd, 'gzip |]
              | doc "Controls the cache compression method"
              | optional,
            expire_days | std.number.Integer | optional,
            storage
              | {
                config
                  | {
                    connection | String | optional,
                    dsn
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.isType '"String")
                      | optional,
                  }
                  | optional,
                type | std.enum.TagOrString | [| 'redis, 'mysql |] | optional,
              }
              | optional,
          },
      "_js2n__-:definitions/cdn!contract" =
        {
            fastly
              | {
                api_key | String | optional,
                max_parallel_invalidations | std.number.Integer | optional,
                soft_purge | std.enum.TagOrString | [| '"0", '"1" |] | optional,
              }
              | optional,
            strategy | String | optional,
            url | String | optional,
          },
      "_js2n__-:definitions/dal!contract" =
        {
            batch_size | std.number.Integer | optional,
            max_rule_prices | std.number.Integer | optional,
            versioning
              | { expire_days | std.number.Integer | optional, }
              | optional,
          },
      "_js2n__-:definitions/deployment!contract" =
        {
            blue_green | Bool | optional,
            cluster_setup | Bool | optional,
            runtime_extension_management | Bool | optional,
          },
      "_js2n__-:definitions/dompdf!contract" =
        { options | {  .. } | optional, },
      "_js2n__-:definitions/elasticsearch!contract" =
        {
            administration
              | {
                enabled | Bool | doc "Admin Elasticsearch Enabled" | optional,
                hosts | String | doc "Admin Elasticsearch Hosts" | optional,
                index_prefix
                  | String
                  | doc "Admin Elasticsearch Index Prefix"
                  | optional,
                refresh_indices
                  | Bool
                  | doc "Admin Elasticsearch Refresh Indices"
                  | optional,
              }
              | optional,
            analysis | {  .. } | optional,
            dynamic_templates | Array Dyn | optional,
            enabled
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | doc "Enable Elasticsearch Searching"
              | optional,
            hosts | String | doc "Elasticsearch Hosts" | optional,
            index_prefix | String | doc "Elasticsearch Index Prefix" | optional,
            index_settings
              | {
                "mapping.nested_fields.limit" | std.number.Integer | optional,
                "mapping.nested_objects.limit" | std.number.Integer | optional,
                "mapping.total_fields.limit" | std.number.Integer | optional,
                number_of_replicas
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType 'Null
                      ])
                  | optional,
                number_of_shards
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Integer,
                        _js2n__-prdslib.isType 'Null
                      ])
                  | optional,
                ..
              }
              | optional,
            indexing_batch_size
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType 'Integer
                  ])
              | doc "Elasticsearch Batch Size"
              | optional,
            indexing_enabled
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | doc "Enable Elasticsearch Indexing"
              | optional,
            product
              | {
                custom_fields_mapping
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ])
                  | optional,
              }
              | optional,
            ssl
              | {
                cert_key_path
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"Bool",
                        _js2n__-prdslib.isType '"String"
                      ])
                  | optional,
                cert_path
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"Bool",
                        _js2n__-prdslib.isType '"String"
                      ])
                  | optional,
                sigV4
                  | {
                    credentials_provider
                      | {
                        key_id
                          | _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"String"
                              ])
                          | optional,
                        secret_key
                          | _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"String"
                              ])
                          | optional,
                      }
                      | optional,
                    enabled | Bool | optional,
                    region
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"Bool",
                            _js2n__-prdslib.isType '"String"
                          ])
                      | optional,
                    service
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"Bool",
                            _js2n__-prdslib.isType '"String"
                          ])
                      | optional,
                  }
                  | optional,
                verify_server_cert | Bool | optional,
              }
              | optional,
            throw_exception
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | doc "Throw exception when Elasticsearch queries failing"
              | optional,
          },
      "_js2n__-:definitions/feature_toggle!contract" =
        { enable | Bool | optional, },
      "_js2n__-:definitions/file_system_type!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.isType 'Null
                  ],
                _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/filesystem!contract" =
        {
            allowed_extensions | Array (String) | optional,
            asset
              | _js2n__-refsenv."_js2n__-:definitions/file_system_type!contract"
              | optional,
            private
              | _js2n__-refsenv."_js2n__-:definitions/file_system_type!contract"
              | optional,
            private_allowed_extensions | Array (String) | optional,
            private_local_download_strategy
              | std.enum.TagOrString
              | [| 'x-accel, 'x-sendfile, 'php |]
              | optional,
            public
              | _js2n__-refsenv."_js2n__-:definitions/file_system_type!contract"
              | optional,
            sitemap
              | _js2n__-refsenv."_js2n__-:definitions/file_system_type!contract"
              | optional,
            temp
              | _js2n__-refsenv."_js2n__-:definitions/file_system_type!contract"
              | optional,
            theme
              | _js2n__-refsenv."_js2n__-:definitions/file_system_type!contract"
              | optional,
          },
      "_js2n__-:definitions/framework!contract" =
        {
            cache
              | {
                app | String | optional,
                default_redis_provider | String | optional,
                system | String | optional,
                ..
              }
              | optional,
            lock | String | optional,
            session
              | {
                cookie_lifetime
                  | std.number.Integer
                  | doc "The cookie lifetime of the session"
                  | optional,
                handler_id | String | optional,
                name | String | doc "The cookie name of the session" | optional,
                storage_factory_id | String | optional,
                ..
              }
              | optional,
            trusted_headers
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
                              "x-forwarded-for",
                              "x-forwarded-host",
                              "x-forwarded-proto",
                              "x-forwarded-port",
                              "x-forwarded-prefix"
                            ]
                        ])
                  ])
              | optional,
            trusted_proxies
              | String
              | doc "A list of IP ranges to be considered as proxies and trust the headers"
              | optional,
            ..
          },
      "_js2n__-:definitions/html_sanitizer!contract" =
        {
            cache_dir | String | optional,
            cache_enabled | Bool | optional,
            enabled | Bool | optional,
            fields
              | Array
                { name | String | optional, sets | Array (String) | optional, }
              | optional,
            sets
              | Array
                {
                  attributes | Array (String) | optional,
                  custom_attributes
                    | Array
                      {
                        attributes | Array (String) | optional,
                        tags | Array (String) | optional,
                        ..
                      }
                    | optional,
                  name | String | optional,
                  options | Array {  .. } | optional,
                  tags | Array (String) | optional,
                }
              | optional,
          },
      "_js2n__-:definitions/http_cache!contract" =
        {
            ignored_url_parameters | Array (String) | optional,
            reverse_proxy
              | {
                ban_headers
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.isType 'Null
                      ])
                  | optional,
                ban_method | String | optional,
                enabled | Bool | optional,
                fastly
                  | {
                    api_key | String | optional,
                    enabled | Bool | optional,
                    instance_tag | String | optional,
                    service_id | String | optional,
                    soft_purge
                      | std.enum.TagOrString
                      | [| '"0", '"1" |]
                      | optional,
                  }
                  | optional,
                hosts | Array (String) | optional,
                max_parallel_invalidations | std.number.Integer | optional,
                purge_all
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.isType 'Null
                          ],
                        _js2n__-prdslib.records.record
                          {
                            ban_headers =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.isType 'Null
                                  ],
                            ban_method = _js2n__-prdslib.isType '"String",
                            urls =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                          } {} false _js2n__-prdslib.never
                      ])
                  | optional,
                redis_url
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.isType '"String")
                  | optional,
                use_varnish_xkey | Bool | optional,
              }
              | optional,
            stale_if_error
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.isType 'Null
                  ])
              | optional,
            stale_while_revalidate
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.isType 'Null
                  ])
              | optional,
          },
      "_js2n__-:definitions/increment!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.required
                  [ "message_queue", "user_activity" ],
                _js2n__-prdslib.records.record {}
                  {
                    "^.*$" =
                      _js2n__-refsenv."_js2n__-:definitions/increment_config!predicate",
                  } true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/increment_config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.records.record
                  { type = _js2n__-prdslib.const "redis", } {} true
                  _js2n__-prdslib.always)
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.required [ "config" ],
                    _js2n__-prdslib.records.record
                      {
                        config =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "url" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ],
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.records.required
                                          [ "connection" ],
                                        _js2n__-prdslib.records.record {} {}
                                          true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.records.record
                                  {
                                    connection =
                                      _js2n__-prdslib.isType '"String",
                                    url = _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ],
                      } {} true _js2n__-prdslib.always
                  ]) _js2n__-prdslib.always,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "mysql", "redis", "array" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/logger!contract" =
        {
            enforce_throw_exception | Bool | optional,
            error_code_log_levels
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | optional,
            exclude_events | Array (String) | optional,
            exclude_exception | Array (String) | optional,
            file_rotation_count | std.number.Integer | optional,
          },
      "_js2n__-:definitions/mail!contract" =
        {
            max_body_length | std.number.Integer | optional,
            update_mail_variables_on_send | Bool | optional,
          },
      "_js2n__-:definitions/media!contract" =
        {
            enable_url_upload_feature | Bool | optional,
            enable_url_validation | Bool | optional,
            remote_thumbnails
              | { enable | Bool | optional, pattern | String | optional, }
              | optional,
            url_upload_max_size | String | optional,
          },
      "_js2n__-:definitions/messenger!contract" =
        {
            enforce_message_size | Bool | optional,
            routing_overwrite
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String"),
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | optional,
          },
      "_js2n__-:definitions/number_range!contract" =
        {
            config
              | {
                connection | String | optional,
                dsn
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.isType '"String")
                  | optional,
              }
              | optional,
            increment_storage
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum [ "mysql", "redis" ]
                      ],
                    _js2n__-prdslib.isType '"String"
                  ])
              | doc "The storage engine used for the increments. Note that you need to configure also `config.dsn` if you want to use the `redis` storage."
              | optional,
          },
      "_js2n__-:definitions/parameters!contract" = {  .. },
      "_js2n__-:definitions/product_stream!contract" =
        { indexing | Bool | optional, },
      "_js2n__-:definitions/profiler!contract" =
        {
            integrations
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "Symfony", "Datadog", "Tideways" ]
                            ],
                          _js2n__-prdslib.isType '"String"
                        ]),
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | optional,
          },
      "_js2n__-:definitions/rate_limiter!contract" =
        {
            cart_add_line_item_from
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            contact_form
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            guest_login
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            login
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            newsletter_form
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            notification
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            oauth
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            reset_password
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            user_recovery
              | _js2n__-refsenv."_js2n__-:definitions/rate_limiter_config!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/rate_limiter_config!contract" =
        {
            enabled | Bool | optional,
            limits
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.isType '"Array"
                  ])
              | optional,
            policy | String | optional,
            reset | String | optional,
            ..
          },
      "_js2n__-:definitions/redis!contract" =
        {
            connections
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { dsn = _js2n__-prdslib.isType '"String", } {} false
                            _js2n__-prdslib.never
                        ])
                  ])
              | optional,
          },
      "_js2n__-:definitions/root!contract" =
        {
            elasticsearch
              | _js2n__-refsenv."_js2n__-:definitions/elasticsearch!contract"
              | optional,
            framework
              | _js2n__-refsenv."_js2n__-:definitions/framework!contract"
              | optional,
            parameters
              | _js2n__-refsenv."_js2n__-:definitions/parameters!contract"
              | optional,
            shopware
              | _js2n__-refsenv."_js2n__-:definitions/shopware!contract"
              | optional,
            storefront
              | _js2n__-refsenv."_js2n__-:definitions/storefront!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/sales_channel_context!contract" =
        { expire_days | std.number.Integer | optional, },
      "_js2n__-:definitions/shopware!contract" =
        {
            admin_worker
              | _js2n__-refsenv."_js2n__-:definitions/admin_worker!contract"
              | optional,
            api
              | _js2n__-refsenv."_js2n__-:definitions/api!contract"
              | optional,
            auto_update
              | _js2n__-refsenv."_js2n__-:definitions/auto_update!contract"
              | optional,
            cache
              | _js2n__-refsenv."_js2n__-:definitions/cache!contract"
              | optional,
            cart
              | _js2n__-refsenv."_js2n__-:definitions/cart!contract"
              | optional,
            cdn
              | _js2n__-refsenv."_js2n__-:definitions/cdn!contract"
              | optional,
            dal
              | _js2n__-refsenv."_js2n__-:definitions/dal!contract"
              | optional,
            deployment
              | _js2n__-refsenv."_js2n__-:definitions/deployment!contract"
              | optional,
            dompdf
              | _js2n__-refsenv."_js2n__-:definitions/dompdf!contract"
              | optional,
            feature_toggle
              | _js2n__-refsenv."_js2n__-:definitions/feature_toggle!contract"
              | optional,
            filesystem
              | _js2n__-refsenv."_js2n__-:definitions/filesystem!contract"
              | optional,
            html_sanitizer
              | _js2n__-refsenv."_js2n__-:definitions/html_sanitizer!contract"
              | optional,
            http_cache
              | _js2n__-refsenv."_js2n__-:definitions/http_cache!contract"
              | optional,
            increment
              | _js2n__-refsenv."_js2n__-:definitions/increment!contract"
              | optional,
            logger
              | _js2n__-refsenv."_js2n__-:definitions/logger!contract"
              | optional,
            mail
              | _js2n__-refsenv."_js2n__-:definitions/mail!contract"
              | optional,
            media
              | _js2n__-refsenv."_js2n__-:definitions/media!contract"
              | optional,
            messenger
              | _js2n__-refsenv."_js2n__-:definitions/messenger!contract"
              | optional,
            number_range
              | _js2n__-refsenv."_js2n__-:definitions/number_range!contract"
              | optional,
            product_stream
              | _js2n__-refsenv."_js2n__-:definitions/product_stream!contract"
              | optional,
            profiler
              | _js2n__-refsenv."_js2n__-:definitions/profiler!contract"
              | optional,
            redis
              | _js2n__-refsenv."_js2n__-:definitions/redis!contract"
              | optional,
            sales_channel_context
              | _js2n__-refsenv."_js2n__-:definitions/sales_channel_context!contract"
              | optional,
            sitemap
              | _js2n__-refsenv."_js2n__-:definitions/sitemap!contract"
              | optional,
            staging
              | _js2n__-refsenv."_js2n__-:definitions/staging!contract"
              | optional,
            stock
              | _js2n__-refsenv."_js2n__-:definitions/stock!contract"
              | optional,
            store
              | _js2n__-refsenv."_js2n__-:definitions/shopware_store!contract"
              | optional,
            system_config | {  .. } | optional,
            twig
              | _js2n__-refsenv."_js2n__-:definitions/twig!contract"
              | optional,
            usage_data
              | _js2n__-refsenv."_js2n__-:definitions/usage_data!contract"
              | optional,
          },
      "_js2n__-:definitions/shopware_store!contract" =
        { frw | Bool | optional, },
      "_js2n__-:definitions/sitemap!contract" =
        {
            batchsize | std.number.Integer | optional,
            custom_urls
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType 'Null)
              | optional,
            excluded_urls
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType 'Null)
              | optional,
          },
      "_js2n__-:definitions/staging!contract" =
        {
            administration | { show_banner | Bool | optional, } | optional,
            elasticsearch
              | { check_for_existence | Bool | optional, }
              | optional,
            mailing | { disable_delivery | Bool | optional, } | optional,
            sales_channel
              | {
                domain_rewrite
                  | Array
                    {
                      "match" | String | optional,
                      replace | String | optional,
                      type
                        | std.enum.TagOrString
                        | [| 'prefix, 'regex, 'equal |]
                        | optional,
                    }
                  | optional,
              }
              | optional,
            storefront | { show_banner | Bool | optional, } | optional,
          },
      "_js2n__-:definitions/stock!contract" =
        { enable_stock_management | Bool | optional, },
      "_js2n__-:definitions/storefront!contract" =
        {
            theme
              | {
                available_theme_provider | String | optional,
                config_loader_id | String | optional,
                file_delete_delay
                  | std.number.Integer
                  | doc "Delay in seconds until old theme files will be deleted after a new theme compile"
                  | optional,
                theme_path_builder_id | String | optional,
              }
              | optional,
          },
      "_js2n__-:definitions/twig!contract" =
        {
            allowed_php_functions
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.isType '"String"),
                    _js2n__-prdslib.arrays.uniqueItems
                  ])
              | optional,
          },
      "_js2n__-:definitions/usage_data!contract" =
        {
            gateway
              | {
                base_uri | String | optional,
                batch_size | std.number.Integer | optional,
                dispatch_enabled | Bool | optional,
              }
              | optional,
          },
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/root!contract"