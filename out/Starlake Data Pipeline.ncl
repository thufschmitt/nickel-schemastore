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
      "_js2n__-:definitions/AccessControlEntryV1!predicate"
        | doc "Column level security policy to apply to the attribute."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "grants", "role" ],
              _js2n__-prdslib.records.record
                {
                  grants =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  role =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AccessPoliciesV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  apply = _js2n__-prdslib.isType '"Bool",
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  location =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  taxonomy =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AllSinksV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clustering =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  coalesce = _js2n__-prdslib.isType '"Bool",
                  connectionRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  days = _js2n__-prdslib.isType '"Number",
                  enableRefresh = _js2n__-prdslib.isType '"Bool",
                  extension =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  id =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  materializedView =
                    _js2n__-refsenv."_js2n__-:definitions/Materialization!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  partition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  refreshIntervalMs = _js2n__-prdslib.isType '"Number",
                  requirePartitionFilter = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AppConfigV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessPolicies =
                    _js2n__-refsenv."_js2n__-:definitions/AccessPoliciesV1!predicate",
                  archive = _js2n__-prdslib.isType '"Bool",
                  archiveTable = _js2n__-prdslib.isType '"Bool",
                  archiveTablePattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  area =
                    _js2n__-refsenv."_js2n__-:definitions/AreaV1!predicate",
                  audit =
                    _js2n__-refsenv."_js2n__-:definitions/AuditV1!predicate",
                  autoExportSchema = _js2n__-prdslib.isType '"Bool",
                  connectionRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  connections =
                    _js2n__-refsenv."_js2n__-:definitions/MapConnectionV1!predicate",
                  createSchemaIfNotExists = _js2n__-prdslib.isType '"Bool",
                  csvOutput = _js2n__-prdslib.isType '"Bool",
                  csvOutputExt =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  dagRef =
                    _js2n__-refsenv."_js2n__-:definitions/DagRefV1!predicate",
                  dags =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  datasets =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  defaultAuditWriteFormat =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  defaultRejectedWriteFormat =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  defaultWriteFormat =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  dsvOptions =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  duckdbMode = _js2n__-prdslib.isType '"Bool",
                  duckdbPath =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  emptyIsNull = _js2n__-prdslib.isType '"Bool",
                  env =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  expectations =
                    _js2n__-refsenv."_js2n__-:definitions/ExpectationsConfigV1!predicate",
                  extra =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  forceDomainPattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  forceHalt = _js2n__-prdslib.isType '"Bool",
                  forceJobPattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  forceTablePattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  forceTaskPattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  forceViewPattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  grouped = _js2n__-prdslib.isType '"Bool",
                  groupedMax = _js2n__-prdslib.isType 'Integer,
                  hadoop =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  hiveInTest =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/HttpV1!predicate",
                  incoming =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  internal =
                    _js2n__-refsenv."_js2n__-:definitions/InternalV1!predicate",
                  jdbcEngines =
                    _js2n__-refsenv."_js2n__-:definitions/MapJdbcEngineV1!predicate",
                  jobIdEnvName =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  kafka =
                    _js2n__-refsenv."_js2n__-:definitions/KafkaConfigV1!predicate",
                  loadStrategyClass =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "ai.starlake.job.load.IngestionNameStrategy",
                              "ai.starlake.job.load.IngestionTimeStrategy"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  loader =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  lock =
                    _js2n__-refsenv."_js2n__-:definitions/LockV1!predicate",
                  longJobTimeoutMs = _js2n__-prdslib.isType 'Integer,
                  maxInteractiveRecords = _js2n__-prdslib.isType 'Integer,
                  maxParCopy = _js2n__-prdslib.isType 'Integer,
                  maxParTask = _js2n__-prdslib.isType 'Integer,
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  metrics =
                    _js2n__-refsenv."_js2n__-:definitions/MetricsV1!predicate",
                  privacy =
                    _js2n__-refsenv."_js2n__-:definitions/PrivacyV1!predicate",
                  privacyOnly = _js2n__-prdslib.isType '"Bool",
                  refs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RefV1!predicate"
                        ],
                  rejectAllOnError =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  rejectMaxRecords = _js2n__-prdslib.isType 'Integer,
                  root =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  rowValidatorClass =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  scd2EndTimestamp =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  scd2StartTimestamp =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  schedulePresets =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  sessionDurationServe =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  shortJobTimeoutMs = _js2n__-prdslib.isType 'Integer,
                  sinkReplayToFile = _js2n__-prdslib.isType '"Bool",
                  spark =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  sparkScheduling =
                    _js2n__-refsenv."_js2n__-:definitions/SparkSchedulingV1!predicate",
                  sqlParameterPattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tenant =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  testCsvNullString =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tests =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  timezone =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  treeValidatorClass =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  udfs =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  useLocalFileSystem =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  validateOnLoad = _js2n__-prdslib.isType '"Bool",
                  version =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  writeStrategies =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AreaV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  archive =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  hiveDatabase =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  incoming =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  ingesting =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  replay =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  stage =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  unresolved =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AttributeDescV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  accessPolicy =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AttributeV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  accessPolicy =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  array = _js2n__-prdslib.isType '"Bool",
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AttributeV1!predicate"
                        ],
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  foreignKey =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  ignore = _js2n__-prdslib.isType '"Bool",
                  metricType =
                    _js2n__-refsenv."_js2n__-:definitions/MetricTypeV1!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  position =
                    _js2n__-refsenv."_js2n__-:definitions/PositionV1!predicate",
                  privacy =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  rename =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  required = _js2n__-prdslib.isType '"Bool",
                  sample =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  script =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  trim =
                    _js2n__-refsenv."_js2n__-:definitions/TrimV1!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AuditV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active = _js2n__-prdslib.isType '"Bool",
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  domain =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  domainExpectation =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  domainRejected =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  maxErrors =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  sink =
                    _js2n__-refsenv."_js2n__-:definitions/AllSinksV1!predicate",
                  sql =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AutoJobDescV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/AutoTaskDescV1!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tasks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AutoTaskDescV1!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/AutoTaskDescV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  acl =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AccessControlEntryV1!predicate"
                        ],
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AttributeDescV1!predicate"
                        ],
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  connectionRef = _js2n__-prdslib.isType '"String",
                  dagRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  domain =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  expectations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  freshness =
                    _js2n__-refsenv."_js2n__-:definitions/FreshnessV1!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  parseSQL = _js2n__-prdslib.isType '"Bool",
                  partition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  postsql =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  presql =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  python =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  rls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RowLevelSecurityV1!predicate"
                        ],
                  schedule =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  sink =
                    _js2n__-refsenv."_js2n__-:definitions/AllSinksV1!predicate",
                  sql =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  table =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  taskTimeoutMs = _js2n__-prdslib.isType 'Integer,
                  writeStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/WriteStrategyV1!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ConnectionV1!predicate"
        | doc "Connection properties to a datawarehouse."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  loader =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  quote =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  separator =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  sparkFormat =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ConvertibleToString!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.isType 'Null
            ],
      "_js2n__-:definitions/DagGenerationConfigV1!predicate"
        | doc "Dag configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "filename", "template" ],
              _js2n__-prdslib.records.record
                {
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  filename =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DagRefV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  load =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  transform =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DefaultJDBCSchemaV1!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/JDBCSchemaBase!predicate",
      "_js2n__-:definitions/DomainV1!predicate"
        | doc "A schema in JDBC database or a folder in HDFS or a dataset in BigQuery."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/MetadataV1!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  rename =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ExpectationsConfigV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active = _js2n__-prdslib.isType '"Bool",
                  failOnError = _js2n__-prdslib.isType '"Bool",
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/FormatV1!predicate"
        | doc "DSV by default. Supported file formats are :\\n- DSV : Delimiter-separated values file. Delimiter value is specified in the \"separator\" field.\\n- POSITION : FIXED format file where values are located at an exact position in each line.\\n- JSON_FLAT : For optimisation purpose, we differentiate JSON with top level values from JSON\\n  with deep level fields. JSON_FLAT are JSON files with top level fields only.\\n- JSON :  Deep JSON file. Use only when your json documents contain sub-documents, otherwise prefer to\\n  use JSON_FLAT since it is much faster.\\n- XML : XML files"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "DSV",
                  _js2n__-prdslib.const "POSITION",
                  _js2n__-prdslib.const "JSON",
                  _js2n__-prdslib.const "JSON_ARRAY",
                  _js2n__-prdslib.const "JSON_FLAT",
                  _js2n__-prdslib.const "XML",
                  _js2n__-prdslib.const "TEXT_XML",
                  _js2n__-prdslib.const "KAFKA",
                  _js2n__-prdslib.const "KAFKASTREAM",
                  _js2n__-prdslib.const "GENERIC",
                  _js2n__-prdslib.const "PARQUET"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/FreshnessV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  error =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  warn =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/HttpV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  interface =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  port = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InputRefV1!predicate"
        | doc "Input for ref object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "table" ],
              _js2n__-prdslib.records.record
                {
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  domain =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  table =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InternalV1!predicate"
        | doc "configure Spark internal options"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bqAuditSaveInBatchMode = _js2n__-prdslib.isType '"Bool",
                  cacheStorageLevel =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  intermediateBigqueryFormat =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  substituteVars = _js2n__-prdslib.isType '"Bool",
                  temporaryGcsBucket =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/JDBCSchemaBase!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  catalog =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  columnRemarks =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  connectionOptions =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  fetchSize = _js2n__-prdslib.isType 'Integer,
                  fullExport = _js2n__-prdslib.isType '"Bool",
                  numPartitions = _js2n__-prdslib.isType 'Integer,
                  numericTrim =
                    _js2n__-refsenv."_js2n__-:definitions/TrimV1!predicate",
                  partitionColumn =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  sanitizeName = _js2n__-prdslib.isType '"Bool",
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  stringPartitionFunc =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tableRemarks =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tableTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TableTypeV1!predicate"
                        ],
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/JDBCSchemaV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/JDBCSchemaBase!predicate",
                  _js2n__-prdslib.records.record
                    {
                      exclude =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                            ],
                      tables =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/JDBCTableV1!predicate"
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/JDBCSchemasV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auditConnectionRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  connectionRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/DefaultJDBCSchemaV1!predicate",
                  jdbcSchemas =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/JDBCSchemaV1!predicate"
                        ],
                  output =
                    _js2n__-refsenv."_js2n__-:definitions/OutputV1!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/JDBCTableV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  columns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "name" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        name =
                                          _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                                        rename =
                                          _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  connectionOptions =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  fetchSize = _js2n__-prdslib.isType 'Integer,
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  fullExport = _js2n__-prdslib.isType '"Bool",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  numPartitions = _js2n__-prdslib.isType 'Integer,
                  partitionColumn =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  sql =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  stringPartitionFunc =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/JdbcEngineV1!predicate"
        | doc "Jdbc engine"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "quote", "strategyBuilder", "tables" ],
              _js2n__-prdslib.records.record
                {
                  columnRemarks = _js2n__-prdslib.isType '"String",
                  preActions = _js2n__-prdslib.isType '"String",
                  quote = _js2n__-prdslib.isType '"String",
                  strategyBuilder = _js2n__-prdslib.isType '"String",
                  tableRemarks = _js2n__-prdslib.isType '"String",
                  tables =
                    _js2n__-refsenv."_js2n__-:definitions/MapTableDdlV1!predicate",
                  viewPrefix = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/KafkaConfigV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cometOffsetsMode =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  customDeserializers =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  serverOptions =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  topics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/KafkaTopicConfigV1!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/KafkaTopicConfigV1!predicate" =
        _js2n__-prdslib.records.record
            {
              accessOptions =
                _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
              createOptions =
                _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
              fields =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                    ],
              headers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-refsenv."_js2n__-:definitions/MapString!predicate"
                    ],
              maxRead = _js2n__-prdslib.isType 'Integer,
              partitions = _js2n__-prdslib.isType 'Integer,
              replicationFactor = _js2n__-prdslib.isType 'Integer,
              topicName =
                _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/LockV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  pollTime = _js2n__-prdslib.isType 'Integer,
                  refreshTime = _js2n__-prdslib.isType 'Integer,
                  timeout = _js2n__-prdslib.isType 'Integer,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MapConnectionV1!predicate"
        | doc "Map of jdbc engines"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/ConnectionV1!predicate"
            ],
      "_js2n__-:definitions/MapJdbcEngineV1!predicate"
        | doc "Map of jdbc engines"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/JdbcEngineV1!predicate"
            ],
      "_js2n__-:definitions/MapString!predicate"
        | doc "Map of string"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/MapTableDdlV1!predicate"
        | doc "Map of table ddl"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/TableDdlV1!predicate"
            ],
      "_js2n__-:definitions/Materialization!predicate"
        | doc "Table types supported by the Sink option"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "TABLE",
                  _js2n__-prdslib.const "VIEW",
                  _js2n__-prdslib.const "MATERIALIZED_VIEW"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/MergeOnV1!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.const "TARGET",
              _js2n__-prdslib.const "SOURCE_AND_TARGET"
            ],
      "_js2n__-:definitions/MetadataV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ack =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  array = _js2n__-prdslib.isType '"Bool",
                  dagRef =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  directory =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  emptyIsNull = _js2n__-prdslib.isType '"Bool",
                  encoding =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  escape =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  format =
                    _js2n__-refsenv."_js2n__-:definitions/FormatV1!predicate",
                  freshness =
                    _js2n__-refsenv."_js2n__-:definitions/FreshnessV1!predicate",
                  ignore =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  loader =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  multiline = _js2n__-prdslib.isType '"Bool",
                  nullValue =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  quote =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  schedule =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  separator =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  sink =
                    _js2n__-refsenv."_js2n__-:definitions/AllSinksV1!predicate",
                  withHeader = _js2n__-prdslib.isType '"Bool",
                  writeStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/WriteStrategyV1!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MetricTypeV1!predicate"
        | doc "TODO"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "DISCRETE",
                  _js2n__-prdslib.const "CONTINUOUS",
                  _js2n__-prdslib.const "TEXT",
                  _js2n__-prdslib.const "NONE"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/MetricsV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  active = _js2n__-prdslib.isType '"Bool",
                  discreteMaxCardinality = _js2n__-prdslib.isType 'Integer,
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OpenWriteStrategyTypeV1!predicate"
        | doc "Table types supported by the Extract module"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/WriteStrategyTypeBase!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.not
                        _js2n__-refsenv."_js2n__-:definitions/WriteStrategyTypeBase!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                    ]
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/OutputRefV1!predicate"
        | doc "Output for ref object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "database", "domain", "table" ],
              _js2n__-prdslib.records.record
                {
                  database =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  domain =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  table =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/OutputV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  datePattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  encoding =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  escape =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  nullValue =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  quote =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  separator =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  timestampPattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  withHeader = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PositionV1!predicate"
        | doc "First and last char positions of an attribute in a fixed length record"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "first", "last" ],
              _js2n__-prdslib.records.record
                {
                  first = _js2n__-prdslib.isType '"Number",
                  last = _js2n__-prdslib.isType '"Number",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PrimitiveTypeV1!predicate"
        | doc "Define the value type"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "string",
                  _js2n__-prdslib.const "long",
                  _js2n__-prdslib.const "int",
                  _js2n__-prdslib.const "short",
                  _js2n__-prdslib.const "double",
                  _js2n__-prdslib.const "boolean",
                  _js2n__-prdslib.const "byte",
                  _js2n__-prdslib.const "date",
                  _js2n__-prdslib.const "timestamp",
                  _js2n__-prdslib.const "decimal",
                  _js2n__-prdslib.const "variant",
                  _js2n__-prdslib.const "struct"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/PrivacyV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  options =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/RefV1!predicate"
        | doc "Describe how to resolve a reference in a transform task"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "input", "output" ],
              _js2n__-prdslib.records.record
                {
                  input =
                    _js2n__-refsenv."_js2n__-:definitions/InputRefV1!predicate",
                  output =
                    _js2n__-refsenv."_js2n__-:definitions/OutputRefV1!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/RowLevelSecurityV1!predicate"
        | doc "Row level security policy to apply to the output data."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "grants", "name" ],
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  grants =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  predicate =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SparkSchedulingV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  maxJobs = _js2n__-prdslib.isType 'Integer,
                  mode =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  poolName =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/StarlakeV1Base!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "extract" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "load" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "transform" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "env" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "types" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "tables" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "table" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "task" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "application" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "refs" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "dag" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  application =
                    _js2n__-refsenv."_js2n__-:definitions/AppConfigV1!predicate",
                  dag =
                    _js2n__-refsenv."_js2n__-:definitions/DagGenerationConfigV1!predicate",
                  env =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  extract =
                    _js2n__-refsenv."_js2n__-:definitions/JDBCSchemasV1!predicate",
                  load =
                    _js2n__-refsenv."_js2n__-:definitions/DomainV1!predicate",
                  refs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RefV1!predicate"
                        ],
                  table =
                    _js2n__-refsenv."_js2n__-:definitions/TableV1!predicate",
                  task =
                    _js2n__-refsenv."_js2n__-:definitions/AutoTaskDescV1!predicate",
                  transform =
                    _js2n__-refsenv."_js2n__-:definitions/AutoJobDescV1!predicate",
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/TypeV1!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TableDdlV1!predicate"
        | doc "DDL used to create a table"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "createSql" ],
              _js2n__-prdslib.records.record
                {
                  createSql =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  pingSql =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  selectSql =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TableTypeBase!predicate"
        | doc "Table types supported by the Extract module"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "TABLE",
                  _js2n__-prdslib.const "VIEW",
                  _js2n__-prdslib.const "SYSTEM TABLE",
                  _js2n__-prdslib.const "MATERIALIZED VIEW",
                  _js2n__-prdslib.const "GLOBAL TEMPORARY",
                  _js2n__-prdslib.const "LOCAL TEMPORARY",
                  _js2n__-prdslib.const "ALIAS",
                  _js2n__-prdslib.const "SYNONYM"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/TableTypeV1!predicate"
        | doc "Table types supported by the Extract module"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/TableTypeBase!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.not
                        _js2n__-refsenv."_js2n__-:definitions/TableTypeBase!predicate",
                      _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                    ]
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/TableV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "attributes", "name", "pattern" ],
              _js2n__-prdslib.records.record
                {
                  acl =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AccessControlEntryV1!predicate"
                        ],
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/AttributeV1!predicate"
                        ],
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  expectations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  filter =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/MetadataV1!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  patternSample =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  postsql =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  presql =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  primaryKey =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  rename =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  rls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RowLevelSecurityV1!predicate"
                        ],
                  sample =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TrimV1!predicate"
        | doc "How to trim the input string"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "LEFT",
                  _js2n__-prdslib.const "RIGHT",
                  _js2n__-prdslib.const "BOTH",
                  _js2n__-prdslib.const "NONE"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/TypeV1!predicate"
        | doc "Custom type definition. Custom types are defined in the types/types.sl.yml file"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "pattern" ],
              _js2n__-prdslib.records.record
                {
                  comment =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  ddlMapping =
                    _js2n__-refsenv."_js2n__-:definitions/MapString!predicate",
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  primitiveType =
                    _js2n__-refsenv."_js2n__-:definitions/PrimitiveTypeV1!predicate",
                  sample =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  zone =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WriteStrategyTypeBase!predicate"
        | doc "TODO"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.const "OVERWRITE",
                  _js2n__-prdslib.const "APPEND",
                  _js2n__-prdslib.const "UPSERT_BY_KEY",
                  _js2n__-prdslib.const "UPSERT_BY_KEY_AND_TIMESTAMP",
                  _js2n__-prdslib.const "DELETE_THEN_INSERT",
                  _js2n__-prdslib.const "SCD2",
                  _js2n__-prdslib.const "OVERWRITE_BY_PARTITION"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/WriteStrategyTypeV1!predicate"
        | doc "Table types supported by the Extract module"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/WriteStrategyTypeBase!predicate"
                ],
              _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
            ],
      "_js2n__-:definitions/WriteStrategyV1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endTs =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  key =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate"
                        ],
                  on =
                    _js2n__-refsenv."_js2n__-:definitions/MergeOnV1!predicate",
                  queryFilter =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  startTs =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  timestamp =
                    _js2n__-refsenv."_js2n__-:definitions/ConvertibleToString!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/WriteStrategyTypeV1!predicate",
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/OpenWriteStrategyTypeV1!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-refsenv."_js2n__-:definitions/StarlakeV1Base!predicate",
          _js2n__-prdslib.records.required [ "version" ],
          _js2n__-prdslib.records.record
            {
              version =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 1 ]
                    ],
            } {} true _js2n__-prdslib.always
        ])