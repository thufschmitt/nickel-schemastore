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
      "_js2n__-:definitions/analyzer_list!contract" = Array (String),
      "_js2n__-:definitions/architecture_group!contract" =
        {
            annotation | String | optional,
            exclude
              | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
              | optional,
            include
              | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract",
            name | String,
          },
      "_js2n__-:definitions/architecture_group_list!contract" =
        Array
            _js2n__-refsenv."_js2n__-:definitions/architecture_group!contract",
      "_js2n__-:definitions/architecture_pattern!contract" =
        {
            action | String,
            description | String,
            technologies
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.isType '"String")
                      ]
                  ]),
            ..
          },
      "_js2n__-:definitions/architecture_patterns!contract" =
        Array
            _js2n__-refsenv."_js2n__-:definitions/architecture_pattern!contract",
      "_js2n__-:definitions/branches!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[0-9a-zA-Z]+(,[0-9a-zA-Z]+)*$"
              ]),
      "_js2n__-:definitions/component!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      exclude =
                        _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!predicate",
                      include =
                        _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!predicate",
                      override = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/component_list!contract" =
        Array
            {
              exclude
                | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
                | optional,
              include
                | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
                | optional,
              name | String | optional,
            },
      "_js2n__-:definitions/dependency!contract" =
        {
            bidirectional | Bool | optional,
            count | std.number.Integer | optional,
            source | String,
            target | String,
            type | String | optional,
          },
      "_js2n__-:definitions/dependency_list!contract" =
        Array _js2n__-refsenv."_js2n__-:definitions/dependency!contract",
      "_js2n__-:definitions/file_pattern_list!contract" = Array (String),
      "_js2n__-:definitions/file_pattern_list!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/interval!contract" =
        std.contract.Sequence [ std.enum.TagOrString, [| 'month, 'week |] ],
      "_js2n__-:definitions/language!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      generated =
                        _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                      name =
                        _js2n__-refsenv."_js2n__-:definitions/language_name!predicate",
                      production =
                        _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                      supplementary =
                        _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                      test =
                        _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-refsenv."_js2n__-:definitions/language_name!predicate"
            ],
      "_js2n__-:definitions/language_list!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  _js2n__-refsenv."_js2n__-:definitions/language!predicate",
                _js2n__-prdslib.arrays.minItems 1
              ]),
      "_js2n__-:definitions/language_name!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/model!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "20[0-9]{2}"
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.exclusiveMaximum 2100,
                    _js2n__-prdslib.numbers.minimum 2000
                  ]
              ]),
      "_js2n__-:definitions/system_element!contract" =
        { name | String, type | String | optional, .. },
      "_js2n__-:definitions/system_element_list!contract" =
        Array _js2n__-refsenv."_js2n__-:definitions/system_element!contract",
      "_js2n__-:definitions/yyyymmdd!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "20\\d{2}-?\\d{2}-?\\d{2}"
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.exclusiveMaximum 21000000,
                    _js2n__-prdslib.numbers.minimum 20000000
                  ]
              ]),
    }
    in
  {
      alerts
        | {
          enabled
            | Bool
            | doc "When true, will send alert email notifications when noteworthy events happen."
            | optional,
          recipients
            | Array (String)
            | doc "List of email addresses that should receive alerts."
            | optional,
        }
        | optional,
      architecture
        | {
          add_dependencies
            | _js2n__-refsenv."_js2n__-:definitions/dependency_list!contract"
            | doc "List of manually added dependencies on top of the ones detected automatically by the analysis."
            | optional,
          add_system_elements
            | _js2n__-refsenv."_js2n__-:definitions/system_element_list!contract"
            | doc "List of system elements that are manually defined and added to the architecture graph."
            | optional,
          branch
            | _js2n__-refsenv."_js2n__-:definitions/branches!contract"
            | doc "Repository branch to use, comma-separated for multiple branches. Defaults to current branch."
            | optional,
          co_evolution
            | Bool
            | doc "Set to false to disable co-evolution detection, improves performance for huge systems."
            | optional,
          custom_components
            | Bool
            | doc "Overrides automatic component detection with components defined manually in scope file."
            | optional,
          custom_patterns
            | _js2n__-refsenv."_js2n__-:definitions/architecture_patterns!contract"
            | doc "Adds additional custom patterns to the architecture knowledge base used for the analysis."
            | optional,
          disabled_metrics
            | Array (String)
            | doc "List of metrics that should be removed from the analysis and set to N/A."
            | optional,
          duplication
            | Bool
            | doc "Set to false to disable duplication detection, improves performance for huge systems."
            | optional,
          enabled
            | Bool
            | doc "When true, architecture analysis will be triggered for each incoming upload."
            | optional,
          exclude
            | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
            | doc "List of exclude patterns that applies only to Architecture Quality, not globally."
            | optional,
          file_annotation_components
            | Bool
            | doc "Automatic componentization based on @sigrid:component annotations in source files."
            | optional,
          flatten_directories
            | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
            | doc "List of directory names that should be flattened and not considered as components during the analysis."
            | optional,
          grouping
            | _js2n__-refsenv."_js2n__-:definitions/architecture_group_list!contract"
            | doc "Annotate all top-level components matching the pattern, in order to divide them into logical groups."
            | optional,
          history
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "Deprecated, this is now detected automatically."
            | optional,
          history_enabled
            | Bool
            | doc "Deprecated, this is now detected automatically."
            | optional,
          history_end
            | _js2n__-refsenv."_js2n__-:definitions/yyyymmdd!contract"
            | doc "Repository history end date in the format 'yyyy-mm-dd', default is current date."
            | optional,
          history_filter_outliers
            | Bool
            | doc "Filters commits with an abnormally large amount of churn from the history analysis."
            | optional,
          history_interval
            | _js2n__-refsenv."_js2n__-:definitions/interval!contract"
            | doc "Either 'week' (default) or ‘month’."
            | optional,
          history_period_months
            | std.number.Integer
            | doc "Period to use for repository history analysis, default is last 12 months."
            | optional,
          history_start
            | _js2n__-refsenv."_js2n__-:definitions/yyyymmdd!contract"
            | doc "Repository history start date in the format 'yyyy-mm-dd', default is last year."
            | optional,
          merge_data_stores
            | Bool
            | doc "Default is false. When true, skips automated data store detection and assumes one monolithic data store."
            | optional,
          model
            | _js2n__-refsenv."_js2n__-:definitions/model!contract"
            | doc "SIG Architecture Quality Model that should be used for the analysis, defaults to latest."
            | optional,
          remove_dependencies
            | _js2n__-refsenv."_js2n__-:definitions/dependency_list!contract"
            | doc "List of dependencies that manually overrides the analysis and removes them from the results."
            | optional,
          remove_system_elements
            | _js2n__-refsenv."_js2n__-:definitions/system_element_list!contract"
            | doc "List of system elements to manually remove from the architecture graph."
            | optional,
          rename
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "Map of system elements for which to manually override the name."
            | optional,
          undesirable_dependencies
            | _js2n__-refsenv."_js2n__-:definitions/dependency_list!contract"
            | doc "List of dependencies considered undesirable, and should therefore be highlighted in the visualization."
            | optional,
        }
        | optional,
      checkmarx
        | {
          enabled
            | Bool
            | doc "Indicates that this system should be scanned for vulnerabilities using Checkmarx.",
          id
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "Unique ID to identify the Checkmarx project.",
          username | String | doc "Your Checkmarx username." | optional,
        }
        | optional,
      component_base_dirs
        | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
        | optional,
      component_depth
        | std.number.Integer
        | doc "Directory depth that will be used to define components."
        | optional,
      components
        | _js2n__-refsenv."_js2n__-:definitions/component_list!contract"
        | optional,
      default_excludes
        | Bool
        | doc "When true, excludes files and directories from the analysis scope based on common conventions."
        | optional,
      dependencychecker
        | {
          blacklist
            | Array (String)
            | doc "Deprecated, use 'blocklist' instead."
            | optional,
          blocklist
            | Array (String)
            | doc "List of patterns for library names that should not be sent to external services."
            | optional,
          enabled
            | Bool
            | doc "When this *or* the 'blocklist' option is provided, OSH analysis is performed for every upload."
            | optional,
          exclude
            | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
            | doc "List of file/directory patterns that should be excluded from the Open Source Health analysis."
            | optional,
          model
            | _js2n__-refsenv."_js2n__-:definitions/model!contract"
            | doc "SIG Open Source Health model version that should be used for the analysis, defaults to latest."
            | optional,
          override_disabled_technologies
            | Array (String)
            | doc "List of technologies for which the analysis should be disabled."
            | optional,
          override_enabled_technologies
            | Array (String)
            | doc "List of additional technologies to analyze, which are not enabled by default."
            | optional,
          transitive
            | Bool
            | doc "When true, transitive dependencies are also checked and included in the results."
            | optional,
        }
        | optional,
      exclude
        | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
        | doc "List of file and directory patterns to manually exclude from the analysis."
        | optional,
      experimental
        | Bool
        | doc "Enable experimental analysis features."
        | optional,
      languages
        | _js2n__-refsenv."_js2n__-:definitions/language_list!contract"
        | doc "A list of technologies that should be included as part of the analysis.",
      model
        | _js2n__-refsenv."_js2n__-:definitions/model!contract"
        | doc "SIG Maintainability Model that should be used for the analysis, defaults to latest."
        | optional,
      thirdpartyfindings
        | {
          disabled_analyzers
            | _js2n__-refsenv."_js2n__-:definitions/analyzer_list!contract"
            | doc "List of third-party analyzers that should not be ran."
            | optional,
          disabled_rules
            | Array (String)
            | doc "List of rule IDs that should not be reported by Sigrid."
            | optional,
          enabled
            | Bool
            | doc "When true, third party findings analysis will be triggered for each incoming upload."
            | optional,
          enabled_analyzers
            | _js2n__-refsenv."_js2n__-:definitions/analyzer_list!contract"
            | doc "List of third-party analyzer names that should be ran even though they are disabled by default."
            | optional,
          enabled_rules
            | Array (String)
            | doc "List of rule IDs that should be reported by Sigrid, even though they are disabled by default."
            | optional,
          exclude
            | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
            | doc "List of file/directory patterns that should be excluded from the third party findings analysis."
            | optional,
          include
            | _js2n__-refsenv."_js2n__-:definitions/file_pattern_list!contract"
            | doc "List of file/directory patterns that should be included in the third party findings analysis beyond the maintainability scope and production configuration files."
            | optional,
        }
        | optional,
      ..
    }