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
      "_js2n__-:definitions/AdditionalBodyParamsEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/AdditionalCredsEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/AdditionalQueryParamsEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/AppConf!predicate"
        | doc "Configuration parameters for the scanned application, independent of the scanner."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "authentication" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.not
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.records.required [ "authentication" ],
                        _js2n__-prdslib.records.record {} {} true
                          _js2n__-prdslib.always
                      ])
                ],
              _js2n__-prdslib.records.required
                [ "applicationId", "env", "host" ],
              _js2n__-prdslib.records.record
                {
                  antiCsrfParam = _js2n__-prdslib.isType '"String",
                  applicationId =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "\\b[0-9a-f]{8}\\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\\b[0-9a-f]{12}\\b"
                        ],
                  authentication =
                    _js2n__-refsenv."_js2n__-:definitions/Authentication!predicate",
                  autoInputVectors = _js2n__-prdslib.isType '"Bool",
                  autoPolicy = _js2n__-prdslib.isType '"Bool",
                  badAuthentication =
                    _js2n__-refsenv."_js2n__-:definitions/Authentication!predicate",
                  env = _js2n__-prdslib.isType '"String",
                  excludePaths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  graphqlConf =
                    _js2n__-refsenv."_js2n__-:definitions/GraphQLConf!predicate",
                  grpcConf =
                    _js2n__-refsenv."_js2n__-:definitions/GrpcConf!predicate",
                  host =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "(?:(?:https?|ftp|file):\\/\\/|www\\.|ftp\\.)(?:\\([-\\w\\d+&@#\\/%=~_|$?!:,.]*\\)|[-\\w\\d+&@#\\/%=~_|$?!:,.])*(?:\\([-\\w\\d+&@#\\/%=~_|$?!:,.]*\\)|[\\w\\d+&@#\\/%=~_|$])"
                        ],
                  includePaths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  inputVectors =
                    _js2n__-refsenv."_js2n__-:definitions/InputVectorParams!predicate",
                  openApiConf =
                    _js2n__-refsenv."_js2n__-:definitions/OpenApiConf!predicate",
                  redact =
                    _js2n__-refsenv."_js2n__-:definitions/AppRedactions!predicate",
                  scanPolicy =
                    _js2n__-refsenv."_js2n__-:definitions/OrganizationPolicy!predicate",
                  sessionTokens =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  soapConf =
                    _js2n__-refsenv."_js2n__-:definitions/SoapConf!predicate",
                  waitForAppTarget =
                    _js2n__-refsenv."_js2n__-:definitions/WaitForAppTarget!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AppRedactions!predicate"
        | doc m%"
          Redaction policy of scan logs and stdout when scanning this application.
          
          HawkScan maintains a list of redacted tokens; strings that are sensitive and should be scrubbed preemptively from logs and collected messages. By default, HawkScan redacts `app.authentication` credentials, and any provided script / discovery credentials.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AuthTestPath!predicate"
        | doc m%"
          A configuration specifying how to verify if Scan authentication and authorization is working before running a scan.
          
          An example configuration of `app.authentication.testPath`:
          ```yaml
           app:
            authentication:
              testPath:
                type: HEADER
                path: /user/profile
                success: ".*200.*"
                requestMethod: POST
                requestBody: '{"feeling": "KaaKaww!"}'
                requestHeaders:
                  Content-Type: "application/json"
          ```
          
          This uses either `success` or `fail` criteria to determine if authorized access is working correctly.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "success" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "fail" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  fail = _js2n__-prdslib.isType '"String",
                  path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                        ],
                  requestBody = _js2n__-prdslib.isType '"String",
                  requestHeaders =
                    _js2n__-refsenv."_js2n__-:definitions/RequestHeadersEntry!predicate",
                  requestMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "GET", "POST", "PUT", "PATCH" ]
                        ],
                  success = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "HEADER", "BODY" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AuthTokens!predicate"
        | doc "Configuration for Token Authentication."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  tokenType = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "TOKEN", "COOKIE" ]
                        ],
                  value =
                    _js2n__-refsenv."_js2n__-:definitions/NameValParam!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Authentication!predicate"
        | doc m%"
          Configuration block for application authentication to enable scanning as the provided user of your application.
          If provided, HawkScan will first attempt to sign into your web application with the provided login credentials.
          Only after successfully verifying will scanning occur.
          For more information, see the Authenticated Scanning section.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "usernamePassword" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "external" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "script" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "externalCommand" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "oauth" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "usernamePassword" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "external" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "script" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "externalCommand" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "oauth" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ])
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "cookieAuthorization" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "tokenAuthorization" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "sessionScript" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.not
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "cookieAuthorization" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "tokenAuthorization" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required
                                  [ "sessionScript" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]
                          ])
                    ]
                ],
              _js2n__-prdslib.records.required [ "testPath" ],
              _js2n__-prdslib.records.record
                {
                  cookieAuthorization =
                    _js2n__-refsenv."_js2n__-:definitions/CookieAuthorization!predicate",
                  external =
                    _js2n__-refsenv."_js2n__-:definitions/ExternalCredentials!predicate",
                  externalCommand =
                    _js2n__-refsenv."_js2n__-:definitions/ExternalCommandCredentials!predicate",
                  loggedInIndicator = _js2n__-prdslib.isType '"String",
                  loggedOutIndicator = _js2n__-prdslib.isType '"String",
                  oauth =
                    _js2n__-refsenv."_js2n__-:definitions/OAuth!predicate",
                  overrideJWTAutoRenew = _js2n__-prdslib.isType '"Bool",
                  script =
                    _js2n__-refsenv."_js2n__-:definitions/AuthenticationScript!predicate",
                  sessionScript =
                    _js2n__-refsenv."_js2n__-:definitions/SessionScript!predicate",
                  testPath =
                    _js2n__-refsenv."_js2n__-:definitions/AuthTestPath!predicate",
                  tokenAuthorization =
                    _js2n__-refsenv."_js2n__-:definitions/TokenAuthorization!predicate",
                  tokenExtraction =
                    _js2n__-refsenv."_js2n__-:definitions/TokenExtraction!predicate",
                  usernamePassword =
                    _js2n__-refsenv."_js2n__-:definitions/UsernamePasswordCredentials!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AuthenticationScript!predicate"
        | doc m%"
          Configuration for a custom authentication script.
          HawkScan will run the provided authentication script until a request matches the `loggedInIndicator`, or if the `loggedOutIndicator` is tripped on a request.
          The authentication script name should also be included in the `hawkAddOn.scripts.name`
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  credentials =
                    _js2n__-refsenv."_js2n__-:definitions/CredentialsEntry!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-refsenv."_js2n__-:definitions/ParametersEntry!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CookieAuthorization!predicate"
        | doc "An optional configuration specifying if authorization is maintained via a cookie session."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cookieNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CredentialsEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/CustomDiscovery!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  command = _js2n__-prdslib.isType '"String",
                  credentials =
                    _js2n__-refsenv."_js2n__-:definitions/CredentialsEntry!predicate",
                  environment =
                    _js2n__-refsenv."_js2n__-:definitions/EnvironmentEntry!predicate",
                  excludeParentEnvironment = _js2n__-prdslib.isType '"Bool",
                  logOutputToForeground = _js2n__-prdslib.isType '"Bool",
                  workingDir = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/CustomVariable!predicate"
        | doc "Generic custom variable for different API types."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  field = _js2n__-prdslib.isType '"String",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/EnabledRPCParam!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  directWebRemoting = _js2n__-prdslib.isType '"Bool",
                  googleWebToolkit = _js2n__-prdslib.isType '"Bool",
                  json = _js2n__-prdslib.isType '"Bool",
                  multipartFormData = _js2n__-prdslib.isType '"Bool",
                  odataId = _js2n__-prdslib.isType '"Bool",
                  xmlTag = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/EnvironmentEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/ExternalCommandCredentials!predicate"
        | doc "Optional configuration block allowing HawkScan to run a specified command line process. HawkScan will attempt to access a protected path in your web application with the supplied headers or cookies before scanning. For more information, see the [Authenticated Scanning section](https://docs.stackhawk.com/hawkscan/configuration/authenticated-scanning.html)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  timeoutSeconds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ExternalCredentials!predicate"
        | doc "Optional configuration block for specifying an externally supplied authorization token, HawkScan will attempt to access a protected path in your web application with the supplied token before scanning. For more information, see the [Authenticated Scanning section](https://docs.stackhawk.com/hawkscan/configuration/authenticated-scanning.html)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "TOKEN", "COOKIE" ]
                        ],
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AuthTokens!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GraphQLConf!predicate"
        | doc "[GraphQL](https://spec.graphql.org/June2018/) scanner parameters. See the StackHawk [graphQL configuration docs](https://docs.stackhawk.com/hawkscan/configuration/graphql-configuration.html) for more details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customVariables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/GraphQLCustomVariable!predicate"
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  excludeOperations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/GraphQLExcludeOperationParam!predicate"
                        ],
                  fakerEnabled = _js2n__-prdslib.isType '"Bool",
                  filePath = _js2n__-prdslib.isType '"String",
                  maxDepth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.maximum 50,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  operation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ALL", "QUERY", "MUTATION" ]
                        ],
                  requestMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "POST", "GET" ]
                        ],
                  schemaPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                        ],
                  uriMaxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GraphQLCustomVariable!predicate"
        | doc "Custom variable data specific to OpenAPI schemas."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  field = _js2n__-prdslib.isType '"String",
                  operationName = _js2n__-prdslib.isType '"String",
                  operationType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ALL", "QUERY", "MUTATION" ]
                        ],
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GraphQLExcludeOperationParam!predicate"
        | doc "A GraphQL operation to exclude from the spider by name and type."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ALL", "QUERY", "MUTATION" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GrpcConf!predicate"
        | doc "[gRPC](https://grpc.io/) API scanner parameters. See the [gRPC configuration docs](https://docs.stackhawk.com/hawkscan/configuration/gRPC-configuration.html) for more details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customVariables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CustomVariable!predicate"
                        ],
                  filePath = _js2n__-prdslib.isType '"String",
                  filePaths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  maxDepth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.maximum 50,
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HARImportConfig!predicate"
        | doc m%"
          Configuration for using a HAR file as the discovery for a scan.
          HAR files often contain requests including urls from many hosts, but only URLs matching the `app.host` or
          `replaceHost` will be included in the scan.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "file" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dir" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  dir =
                    _js2n__-refsenv."_js2n__-:definitions/HARImportDirectory!predicate",
                  file =
                    _js2n__-refsenv."_js2n__-:definitions/HARImportFiles!predicate",
                  replaceHost = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HARImportDirectory!predicate"
        | doc "Paths to directories, for use with HARImportConfig."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HARImportFiles!predicate"
        | doc "Paths to .har HTTP Archive formatted files, for use with HARImportConfig."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HawkAddOnConf!predicate"
        | doc "Configuration block for HawkScan add-ons and custom scripts."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  replacer =
                    _js2n__-refsenv."_js2n__-:definitions/Replacer!predicate",
                  scripts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Script!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HawkConf!predicate"
        | doc "Configuration preferences for HawkScan, independent of the scanned application."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^([a-zA-Z0-9]*\\.)*([a-zA-Z_$0-9])+=.*$"
                              ])
                        ],
                  failureThreshold =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "\\b(?:high|medium|low|HIGH|MEDIUM|LOW)\\b"
                        ],
                  outboundProxy =
                    _js2n__-refsenv."_js2n__-:definitions/Proxy!predicate",
                  scan =
                    _js2n__-refsenv."_js2n__-:definitions/ScanConf!predicate",
                  spider =
                    _js2n__-refsenv."_js2n__-:definitions/Spider!predicate",
                  startupTimeoutMinutes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/InjectableParam!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cookieData = _js2n__-prdslib.isType '"Bool",
                  httpHeaders = _js2n__-prdslib.isType '"Bool",
                  postData = _js2n__-prdslib.isType '"Bool",
                  urlPath = _js2n__-prdslib.isType '"Bool",
                  urlQuery = _js2n__-prdslib.isType '"Bool",
                  urlQueryParam = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InputVectorParams!predicate"
        | doc "Fine-grained configuration of HawkScan input vectors. This configuration is how and where testable inputs are applied on http requests."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabledRpcParam =
                    _js2n__-refsenv."_js2n__-:definitions/EnabledRPCParam!predicate",
                  injectableParam =
                    _js2n__-refsenv."_js2n__-:definitions/InjectableParam!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/NameValParam!predicate"
        | doc "General name / value parameter."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  val = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OAuth!predicate"
        | doc "Optional configuration block allowing HawkScan to authorize requests with a 3rd party [OAuth 2.0](https://oauth.net/2/) auth provider."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  credentials =
                    _js2n__-refsenv."_js2n__-:definitions/OAuthCredentials!predicate",
                  parameters =
                    _js2n__-refsenv."_js2n__-:definitions/OAuthParameters!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OAuthCredentials!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additionalCreds =
                    _js2n__-refsenv."_js2n__-:definitions/AdditionalCredsEntry!predicate",
                  clientId = _js2n__-prdslib.isType '"String",
                  clientSecret = _js2n__-prdslib.isType '"String",
                  password = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OAuthParameters!predicate"
        | doc ""
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additionalBodyParams =
                    _js2n__-refsenv."_js2n__-:definitions/AdditionalBodyParamsEntry!predicate",
                  additionalQueryParams =
                    _js2n__-refsenv."_js2n__-:definitions/AdditionalQueryParamsEntry!predicate",
                  grantType = _js2n__-prdslib.isType '"String",
                  requestHeaders =
                    _js2n__-refsenv."_js2n__-:definitions/RequestHeadersEntry!predicate",
                  requestMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "POST",
                              "PUT",
                              "DELETE",
                              "GET",
                              "OPTIONS",
                              "PATCH",
                              "HEAD"
                            ]
                        ],
                  scope = _js2n__-prdslib.isType '"String",
                  tokenEndpoint = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OpenApiConf!predicate"
        | doc "[OpenApi](https://swagger.io/specification/) scanner parameters. See the StackHawk [OpenAPI configuration docs](https://docs.stackhawk.com/hawkscan/configuration/openapi-configuration.html) for more details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customVariables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/OpenApiCustomVariable!predicate"
                        ],
                  fakerEnabled = _js2n__-prdslib.isType '"Bool",
                  filePath = _js2n__-prdslib.isType '"String",
                  filePaths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  forbiddenVariables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/OpenApiCustomVariable!predicate"
                        ],
                  includeAllMethods = _js2n__-prdslib.isType '"Bool",
                  includedMethods =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "POST",
                                    "PUT",
                                    "DELETE",
                                    "GET",
                                    "OPTIONS",
                                    "PATCH",
                                    "HEAD"
                                  ]
                              ])
                        ],
                  inline = _js2n__-prdslib.isType '"String",
                  maxAliasesForCollections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                        ],
                  strict = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OpenApiCustomVariable!predicate"
        | doc "Custom variable data specific to OpenAPI schemas."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  field = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  requestMethods =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "POST",
                                    "PUT",
                                    "DELETE",
                                    "GET",
                                    "OPTIONS",
                                    "PATCH",
                                    "HEAD"
                                  ]
                              ])
                        ],
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OrganizationPolicy!predicate"
        | doc "Configure the policy to be applied for the scan, optionally specifying which plugins to include or exclude. **Note**: Applies to scan policies created with Organization Policy Management."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  excludePluginIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includePluginIds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ParametersEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/PostmanConfig!predicate"
        | doc "Configuration for the Postman Collection."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apikey = _js2n__-prdslib.isType '"String",
                  collectionUID = _js2n__-prdslib.isType '"String",
                  filePath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Proxy!predicate"
        | doc "Configuration block for a proxy. This enables HawkScan to traffic scanner requests through an outbound network proxy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  credentials =
                    _js2n__-refsenv."_js2n__-:definitions/ProxyCredentials!predicate",
                  host = _js2n__-prdslib.isType '"String",
                  rootCACertPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ProxyCredentials!predicate"
        | doc "Credential details for the outbound proxy behavior."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  password = _js2n__-prdslib.isType '"String",
                  realm = _js2n__-prdslib.isType '"String",
                  scheme = _js2n__-prdslib.isType '"String",
                  username = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Replacer!predicate"
        | doc "Configuration block for header value replacement. These rules support manipulating request headers, useful for modifying requests to web applications running behind a proxy."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  rules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ReplacerRules!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ReplacerRules!predicate"
        | doc m%"
          A list of configuration blocks for the Replacer add-on rules.
          Each configuration block in the list is made up of the following elements.
          See [Configuration Examples](https://docs.stackhawk.com/hawkscan/configuration/#replacer-plugin-configuration) for more information.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "matchString", "replacement" ],
              _js2n__-prdslib.records.record
                {
                  initiators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "PROXY",
                                    "ACTIVE_SCANNER",
                                    "SPIDER",
                                    "FUZZER",
                                    "AUTHENTICATION",
                                    "MANUAL_REQUEST",
                                    "CHECK_FOR_UPDATES",
                                    "BEAN_SHELL",
                                    "ACCESS_CONTROL_SCANNER",
                                    "AJAX_SPIDER",
                                    "FORCED_BROWSE",
                                    "TOKEN_GENERATOR",
                                    "WEB_SOCKET",
                                    "AUTHENTICATION_HELPER"
                                  ]
                              ])
                        ],
                  isRegex = _js2n__-prdslib.isType '"Bool",
                  matchString = _js2n__-prdslib.isType '"String",
                  replaceOnly = _js2n__-prdslib.isType '"Bool",
                  replacement = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/RequestHeadersEntry!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/ScanConf!predicate"
        | doc "Configuration block for HawkScan runtime."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  concurrentRequests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9])$"
                        ],
                  includedPlugins =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  maxDurationMinutes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  maxRuleDurationMinutes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  policyName = _js2n__-prdslib.isType '"String",
                  requestDelayMillis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  throttleIntervalSeconds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9])$"
                        ],
                  throttlePassiveBacklog =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9])$"
                        ],
                  throttleTempRecordDeleteQuota =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.maximum 100,
                          _js2n__-prdslib.numbers.minimum 1,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9])$"
                        ],
                  throttleTempRecordMax =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9])$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Script!predicate"
        | doc "Configuration block for custom scripts."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "language" ],
              _js2n__-prdslib.records.record
                {
                  id =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  language =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "KOTLIN", "JAVASCRIPT" ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "active",
                              "authentication",
                              "httpsender",
                              "passive",
                              "proxy",
                              "session"
                            ]
                        ],
                  vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NameValParam!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SessionScript!predicate"
        | doc "Optional configuration block for specifying a custom session management script. To learn more about session scripts, reference the [HawkScan Examples](https://github.com/kaakaww/hawkscan-examples){:target=\"_blank\"} repository."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-refsenv."_js2n__-:definitions/ParametersEntry!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SoapConf!predicate"
        | doc "[SOAP](https://www.w3.org/TR/soap/) API scanner parameters. See the StackHawk [SOAP configuration docs](https://docs.stackhawk.com/hawkscan/configuration/soap-configuration.html) for more details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  filePath = _js2n__-prdslib.isType '"String",
                  path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Spider!predicate"
        | doc "Configuration block for the application crawling and Discovery Phase aka Spider. See the [Scan Discovery](https://docs.stackhawk.com/hawkscan/scan-discovery/) page for more details."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ajax = _js2n__-prdslib.isType '"Bool",
                  ajaxBrowser =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "FIREFOX_HEADLESS",
                              "CHROME_HEADLESS",
                              "FIREFOX",
                              "CHROME"
                            ]
                        ],
                  base = _js2n__-prdslib.isType '"Bool",
                  custom =
                    _js2n__-refsenv."_js2n__-:definitions/CustomDiscovery!predicate",
                  har =
                    _js2n__-refsenv."_js2n__-:definitions/HARImportConfig!predicate",
                  maxDurationMinutes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.exclusiveMinimum 0
                        ],
                  postmanConfig =
                    _js2n__-refsenv."_js2n__-:definitions/PostmanConfig!predicate",
                  seedPaths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Tag!predicate"
        | doc m%"
          Scan tags are name value pairs that represent metadata of the scan, capturing additional state or context around a scan.
          
          Examples could include adding commit SHAs, branch names, or project management issue titles.
          
          Tag names can use any combination of the following characters: `a-zA-Z-_`, and their values can be any string. Tag entries can also be interpolated from the environment.
          
          {:class="alert alert-info"}
          > ℹ️ **NOTE:** Tag names beginning with `_STACKHAWK` are in a reserved tag name space.
          
          The following selection of YAML is an example of how you can configure your `stackhawk.yml` file to include scan tags:
          
          stackhawk.yml
          {: .filename-tab}
          ```yaml
          app:
          applicationId: <application-uuid>
          env: localhost
          host: http://localhost:8080
          tags:
          - name: category
          value: hawksome
          - name: Another-Value
          value: ${SOMETHING_FROM_ENV:default}
          - name: _GIT_COMMIT_SHA
          value: ${MY_COMMIT_SHA_ENV:HEAD}
          ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 128,
                          _js2n__-prdslib.strings.minLength 1,
                          _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_-]+$"
                        ],
                  value =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 512,
                          _js2n__-prdslib.strings.minLength 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TokenAuthorization!predicate"
        | doc "An optional configuration telling HawkScan how to pass the authorization token to your application on each request to maintain authorized access."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "value" ],
              _js2n__-prdslib.records.record
                {
                  isJWT = _js2n__-prdslib.isType '"Bool",
                  renewMillis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.exclusiveMinimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9])$"
                        ],
                  tokenType = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "HEADER", "QUERY_PARAM" ]
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TokenExtraction!predicate"
        | doc "Token extraction is optional unless you're using the `tokenAuthorization` in combination with `usernamePassword` authentication. This configuration specifies how to extract the authorization token from the authentication response."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "value" ],
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "TOKEN_PATH", "HEADER_NAME" ]
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/UsernamePasswordCredentials!predicate"
        | doc m%"
          Optional configuration specifying a username and password based authentication configuration.
          Currently POSTing the credentials via `FORM` or `JSON` type is supported. Use in conjunction `cookieAuthorization` or `tokenAuthorization` to maintain authorized access to your application.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [
                  "loginPath",
                  "passwordField",
                  "scanPassword",
                  "scanUsername",
                  "usernameField"
                ],
              _js2n__-prdslib.records.record
                {
                  loginPagePath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                        ],
                  loginPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\/(([A-z0-9\\-\\%]+\\/)*[A-z0-9\\-\\%]+$)?"
                        ],
                  otherParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NameValParam!predicate"
                        ],
                  passwordField = _js2n__-prdslib.isType '"String",
                  realm = _js2n__-prdslib.isType '"String",
                  scanPassword = _js2n__-prdslib.isType '"String",
                  scanUsername = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "FORM", "JSON", "HTTP" ]
                        ],
                  usernameField = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WaitForAppTarget!predicate"
        | doc "A configuration specifying how to determine if app is up and ready or scanning."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "pollDelay", "waitTimeoutMillis" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  pollDelay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 50,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                  requestBody = _js2n__-prdslib.isType '"String",
                  requestMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "GET", "POST", "PUT", "PATCH" ]
                        ],
                  waitTimeoutMillis =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.numbers.minimum 0,
                          _js2n__-prdslib.strings.pattern
                            "^([0-9][0-9]+|[1-9]|0)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              app =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-refsenv."_js2n__-:definitions/AppConf!predicate"
                    ],
              hawk =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-refsenv."_js2n__-:definitions/HawkConf!predicate"
                    ],
              hawkAddOn =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-refsenv."_js2n__-:definitions/HawkAddOnConf!predicate"
                    ],
              tags =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/Tag!predicate"
                    ],
            } {} true _js2n__-prdslib.always
        ])