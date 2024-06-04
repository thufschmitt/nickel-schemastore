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
      "_js2n__-:definitions/SpecifAlternativeId!predicate"
        | doc "A list of pointers to resources resp. statements which have been merged to this one."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  project =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpecifAlternativeIds!predicate"
        | doc "The list of consolidated items to be used in case a consolidated item shall be updated."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifAlternativeId!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifCreatedBy!contract"
        | doc "The creator of the SpecIF data-set (file). If specified, at least an e-mail address must be given."
        = {
            email | String,
            familyName | String | optional,
            givenName | String | optional,
            org
              | _js2n__-refsenv."_js2n__-:definitions/SpecifOrg!contract"
              | optional,
            ..
          },
      "_js2n__-:definitions/SpecifDataType!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "changedAt", "id", "title", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      changedAt =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                      changedBy = _js2n__-prdslib.isType '"String",
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                      replaces =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                      revision =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                      title =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "xs:boolean" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "changedAt", "id", "title", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      changedAt =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                      changedBy = _js2n__-prdslib.isType '"String",
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                      enumeration =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifEnumeratedValues!predicate",
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                      multiple = _js2n__-prdslib.isType '"Bool",
                      replaces =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                      revision =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                      title =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "xs:dateTime", "xs:duration", "xs:anyURI" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "changedAt", "id", "title", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      changedAt =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                      changedBy = _js2n__-prdslib.isType '"String",
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                      enumeration =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifEnumeratedValues!predicate",
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                      maxInclusive = _js2n__-prdslib.isType '"Number",
                      minInclusive = _js2n__-prdslib.isType '"Number",
                      multiple = _js2n__-prdslib.isType '"Bool",
                      replaces =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                      revision =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                      title =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "xs:integer" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "changedAt", "id", "title", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      changedAt =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                      changedBy = _js2n__-prdslib.isType '"String",
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                      enumeration =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifEnumeratedValues!predicate",
                      fractionDigits =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 1
                            ],
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                      maxInclusive = _js2n__-prdslib.isType '"Number",
                      minInclusive = _js2n__-prdslib.isType '"Number",
                      multiple = _js2n__-prdslib.isType '"Bool",
                      replaces =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                      revision =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                      title =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "xs:double" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "changedAt", "id", "title", "type" ],
                  _js2n__-prdslib.records.record
                    {
                      changedAt =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                      changedBy = _js2n__-prdslib.isType '"String",
                      description =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                      enumeration =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifEnumeratedValues!predicate",
                      id =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                      maxLength =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      multiple = _js2n__-prdslib.isType '"Bool",
                      replaces =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                      revision =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                      title =
                        _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "xs:string" ]
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/SpecifDateTime!contract"
        | doc "An ISO-8601 dateTime string. For reduced accuracy, any number of values may be dropped, but only from right to left."
        = String,
      "_js2n__-:definitions/SpecifDateTime!predicate"
        | doc "An ISO-8601 dateTime string. For reduced accuracy, any number of values may be dropped, but only from right to left."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SpecifEnumeratedValue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "value" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  value =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifValue!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpecifEnumeratedValues!predicate"
        | doc "Enumerated values for the given dataType. If 'multiple' is true 0..n options may be selected, otherwise exactly one must be selected."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifEnumeratedValue!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifFile!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "changedAt", "id", "title", "type" ],
              _js2n__-prdslib.records.record
                {
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                  title = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpecifIcon!predicate"
        | doc "A symbol for display as a prefix to titles; applicable to all instances of the class. Is usually a XML-encoded UTF-8 symbol, can be an URL or dataURL."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SpecifId!contract"
        | doc "A globally unique identifier."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[_a-zA-Z]{1}[_a-zA-Z0-9.-]*$"
              ]),
      "_js2n__-:definitions/SpecifId!predicate"
        | doc "A globally unique identifier."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[_a-zA-Z]{1}[_a-zA-Z0-9.-]*$"
            ],
      "_js2n__-:definitions/SpecifInstantiation!predicate"
        | doc "Indicates whether an instance of the class is created automatically, manually or both. All is allowed, if the property is omitted. The class is abstract and cannot be instantiated, if the property list is present, but empty."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "auto", "user" ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifKey!predicate"
        | doc "A key for a particular revision of an identifiable item, e.g. of a resource. A key consists of a globally unique identifier and a revision. No or an undefined revision means the latest revision of the identified item."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpecifKeys!predicate"
        | doc "A list of keys referencing items such as propertyClasses, resourceClasses or statementClasses; any list must have >0 entries including those of any parent element."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifMultiLanguageText!contract"
        | doc "A list of items with text and language properties. If the information is be provided in multiple languages, the language must be specified for proper selection; it is however not required by the schema to avoid a lot of overhead in most cases with a single language."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "text" ],
                      _js2n__-prdslib.records.record
                        {
                          format =
                            _js2n__-refsenv."_js2n__-:definitions/SpecifTextFormat!predicate",
                          language = _js2n__-prdslib.isType '"String",
                          text = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]),
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/SpecifMultiLanguageText!predicate"
        | doc "A list of items with text and language properties. If the information is be provided in multiple languages, the language must be specified for proper selection; it is however not required by the schema to avoid a lot of overhead in most cases with a single language."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "text" ],
                    _js2n__-prdslib.records.record
                      {
                        format =
                          _js2n__-refsenv."_js2n__-:definitions/SpecifTextFormat!predicate",
                        language = _js2n__-prdslib.isType '"String",
                        text = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifNode!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "changedAt", "id", "resource" ],
              _js2n__-prdslib.records.record
                {
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  nodes =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifNodes!predicate",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  resource =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpecifNodes!contract"
        | doc "A list of pointers to resources; may be nested forming a tree, i.e. a hierarchy of pointers."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  _js2n__-refsenv."_js2n__-:definitions/SpecifNode!predicate",
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/SpecifNodes!predicate"
        | doc "A list of pointers to resources; may be nested forming a tree, i.e. a hierarchy of pointers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifNode!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifOrg!contract" =
        { organizationName | String, .. },
      "_js2n__-:definitions/SpecifProperties!predicate"
        | doc "A list of properties of a resource or statement; the number of properties including any parent's properties must be >0."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifProperty!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifProperty!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "class", "values" ],
              _js2n__-prdslib.records.record
                {
                  class =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  values =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifValues!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpecifPropertyClass!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "changedAt", "dataType", "id", "title" ],
              _js2n__-prdslib.records.record
                {
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  dataType =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifTextFormat!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  multiple = _js2n__-prdslib.isType '"Bool",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                  unit = _js2n__-prdslib.isType '"String",
                  values =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifValues!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpecifReplaces!predicate"
        | doc "For change and configuration management; the first revision has 0 entries, a simple modification has 1 entry and the result of a merge has 2 entries."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
              _js2n__-prdslib.arrays.maxItems 2,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/SpecifResource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "changedAt", "class", "id", "properties" ],
              _js2n__-prdslib.records.record
                {
                  alternativeIds =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifAlternativeIds!predicate",
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  class =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  language = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifProperties!predicate",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpecifResourceClass!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "changedAt", "id", "propertyClasses", "title" ],
              _js2n__-prdslib.records.record
                {
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                  extends =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifIcon!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  instantiation =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifInstantiation!predicate",
                  isHeading = _js2n__-prdslib.isType '"Bool",
                  propertyClasses =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKeys!predicate",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpecifRevision!contract"
        | doc "A globally unique revision tag with one or multiple blocks with alphanumeric characters separated by a special character [.:,;/-]. Sequential as well as branching/merging notations are possible."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^(?:[0-9a-zA-Z]+[.:,;/-])*[0-9a-zA-Z]+$"
              ]),
      "_js2n__-:definitions/SpecifRevision!predicate"
        | doc "A globally unique revision tag with one or multiple blocks with alphanumeric characters separated by a special character [.:,;/-]. Sequential as well as branching/merging notations are possible."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(?:[0-9a-zA-Z]+[.:,;/-])*[0-9a-zA-Z]+$"
            ],
      "_js2n__-:definitions/SpecifRights!contract" =
        { title | String, url | String, .. },
      "_js2n__-:definitions/SpecifStatement!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "changedAt", "class", "id", "object", "subject" ],
              _js2n__-prdslib.records.record
                {
                  alternativeIds =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifAlternativeIds!predicate",
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  class =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  language = _js2n__-prdslib.isType '"String",
                  object =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  properties =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifProperties!predicate",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                  subject =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SpecifStatementClass!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "changedAt", "id", "title" ],
              _js2n__-prdslib.records.record
                {
                  changedAt =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!predicate",
                  changedBy = _js2n__-prdslib.isType '"String",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate",
                  extends =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKey!predicate",
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifIcon!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifId!predicate",
                  instantiation =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifInstantiation!predicate",
                  isUndirected = _js2n__-prdslib.isType '"Bool",
                  objectClasses =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKeys!predicate",
                  propertyClasses =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKeys!predicate",
                  replaces =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifReplaces!predicate",
                  revision =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!predicate",
                  subjectClasses =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifKeys!predicate",
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/SpecifText!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpecifText!predicate"
        | doc "A good class name indicates it's role. The use of a vocabulary-term is recommended, which in turn can be translated to any natural or domain language."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/SpecifTextFormat!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "plain", "xhtml" ]
            ],
      "_js2n__-:definitions/SpecifValue!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!predicate"
            ],
      "_js2n__-:definitions/SpecifValues!predicate"
        | doc "If 'multiple' of the propertyClass is undefined or false, the array must contain one item. If the value is unknown, omit the whole property. By default, the class' value applies."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifValue!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  {
      "$schema"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^https?:\\/\\/(specif\\.de\\/v1\\.1\\/schema|json\\.schemastore\\.org\\/specif-1\\.1)\\.json$"
            ])
        | doc "An absolute URL pointing to this SpecIF schema. Supports both specif.de and schemastore.org.",
      createdAt
        | _js2n__-refsenv."_js2n__-:definitions/SpecifDateTime!contract"
        | optional,
      createdBy
        | _js2n__-refsenv."_js2n__-:definitions/SpecifCreatedBy!contract"
        | optional,
      dataTypes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifDataType!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The base data types for use by property class definitions.",
      description
        | _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!contract"
        | doc "The project's description; if missing, the first hierarchy node's description applies."
        | optional,
      files
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifFile!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "A list of files being referenced by a resource's or statement's property of dataType XHTML using an <object> tag. A file should have a media type as defined by IANA (see below)."
        | optional,
      generator | String | optional,
      generatorVersion | String | optional,
      hierarchies
        | _js2n__-refsenv."_js2n__-:definitions/SpecifNodes!contract"
        | doc "A list of hierarchies with pointers to resources; may be nested to build a tree, i.e. a hierarchy of pointers.",
      id | _js2n__-refsenv."_js2n__-:definitions/SpecifId!contract",
      isExtension
        | Bool
        | doc "Indicates that the project is not schema-compliant on its own; by default the value is 'false'. Of course, it is expected that once extended the project is schema-compliant."
        | optional,
      language
        | String
        | doc "An IETF language tag such as 'en', 'en-US, 'fr' or 'de' showing the used language of the project. Is superseded by a resource's, statement's or property's language value. By default, 'en' is assumed."
        | optional,
      propertyClasses
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifPropertyClass!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Class definition of a property for resources or statements. Is a sub-element of the respective resourceClass or statementClass. If no revision or change information is specified, the respective values of the parent element apply.",
      resourceClasses
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifResourceClass!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The class definitions for resources.",
      resources
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifResource!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The resources such as diagrams, model elements or requirements.",
      revision
        | _js2n__-refsenv."_js2n__-:definitions/SpecifRevision!contract"
        | optional,
      rights
        | _js2n__-refsenv."_js2n__-:definitions/SpecifRights!contract"
        | optional,
      statementClasses
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifStatementClass!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "The class definitions for statements in subject-predicate-object statements, where subject and object are resources.",
      statements
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/SpecifStatement!predicate",
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Subject-predicate-Object statements, where subject and object are resources. In other terms, statements are directed relations between two resources building a semantic net.",
      title
        | _js2n__-refsenv."_js2n__-:definitions/SpecifMultiLanguageText!contract"
        | doc "The project's name; if missing, the first hierarchy node's title applies."
        | optional,
      ..
    }