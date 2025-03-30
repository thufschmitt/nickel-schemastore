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
      "_js2n__-:definitions/AwsConfig!predicate"
        | doc m%"
          The `aws` module shows the current AWS region and profile and an expiration timer when using temporary credentials. The output of the module uses the `AWS_REGION`, `AWS_DEFAULT_REGION`, and `AWS_PROFILE` env vars and the `~/.aws/config` and `~/.aws/credentials` files as required.
          
          The module will display a profile only if its credentials are present in `~/.aws/credentials` or if a `credential_process` or `sso_start_url` are defined in `~/.aws/config`. Alternatively, having any of the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, or `AWS_SESSION_TOKEN` env vars defined will also suffice. If the option `force_display` is set to `true`, all available information will be displayed even if no credentials per the conditions above are detected.
          
          When using [aws-vault](https://github.com/99designs/aws-vault) the profile is read from the `AWS_VAULT` env var and the credentials expiration date is read from the `AWS_SESSION_EXPIRATION` or `AWS_CREDENTIAL_EXPIRATION` var.
          
          When using [awsu](https://github.com/kreuzwerker/awsu) the profile is read from the `AWSU_PROFILE` env var.
          
          When using [`AWSume`](https://awsu.me) the profile is read from the `AWSUME_PROFILE` env var and the credentials expiration date is read from the `AWSUME_EXPIRATION` env var.
          
          When using [aws-sso-cli](https://github.com/synfinatic/aws-sso-cli) the profile is read from the `AWS_SSO_PROFILE` env var.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  expiration_symbol = _js2n__-prdslib.isType '"String",
                  force_display = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  profile_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  region_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AzureConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  subscription_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BatteryConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  charging_symbol = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  discharging_symbol = _js2n__-prdslib.isType '"String",
                  display =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/BatteryDisplayConfig!predicate"
                        ],
                  empty_symbol = _js2n__-prdslib.isType '"String",
                  format = _js2n__-prdslib.isType '"String",
                  full_symbol = _js2n__-prdslib.isType '"String",
                  unknown_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BatteryDisplayConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  charging_symbol =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  discharging_symbol =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  style = _js2n__-prdslib.isType '"String",
                  threshold = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BufConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BunConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  commands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CMakeConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CharacterConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  error_symbol = _js2n__-prdslib.isType '"String",
                  format = _js2n__-prdslib.isType '"String",
                  success_symbol = _js2n__-prdslib.isType '"String",
                  vimcmd_replace_one_symbol = _js2n__-prdslib.isType '"String",
                  vimcmd_replace_symbol = _js2n__-prdslib.isType '"String",
                  vimcmd_symbol = _js2n__-prdslib.isType '"String",
                  vimcmd_visual_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CmdDurationConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  min_time = _js2n__-prdslib.isType 'Integer,
                  min_time_to_notify = _js2n__-prdslib.isType 'Integer,
                  notification_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  show_milliseconds = _js2n__-prdslib.isType '"Bool",
                  show_notifications = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CobolConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CondaConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  ignore_base = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContainerConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CrystalConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CustomConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  ignore_timeout = _js2n__-prdslib.isType '"Bool",
                  os =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  require_repo = _js2n__-prdslib.isType '"Bool",
                  shell =
                    _js2n__-refsenv."_js2n__-:definitions/Either_for_String_and_Array_of_String!predicate",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  unsafe_no_escape = _js2n__-prdslib.isType '"Bool",
                  use_stdin =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  when =
                    _js2n__-refsenv."_js2n__-:definitions/Either_for_Boolean_and_String!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DamlConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DartConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DenoConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DirectoryConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  before_repo_root_style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  fish_style_pwd_dir_length = _js2n__-prdslib.isType 'Integer,
                  format = _js2n__-prdslib.isType '"String",
                  home_symbol = _js2n__-prdslib.isType '"String",
                  read_only = _js2n__-prdslib.isType '"String",
                  read_only_style = _js2n__-prdslib.isType '"String",
                  repo_root_format = _js2n__-prdslib.isType '"String",
                  repo_root_style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  style = _js2n__-prdslib.isType '"String",
                  substitutions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  truncate_to_repo = _js2n__-prdslib.isType '"Bool",
                  truncation_length = _js2n__-prdslib.isType 'Integer,
                  truncation_symbol = _js2n__-prdslib.isType '"String",
                  use_logical_path = _js2n__-prdslib.isType '"Bool",
                  use_os_path_sep = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DirenvConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allowed_msg = _js2n__-prdslib.isType '"String",
                  denied_msg = _js2n__-prdslib.isType '"String",
                  detect_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  loaded_msg = _js2n__-prdslib.isType '"String",
                  not_allowed_msg = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  unloaded_msg = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerContextConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  only_with_files = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DotnetConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  heuristic = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Either_for_Boolean_and_String!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/Either_for_String_and_Array_of_String!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/ElixirConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ElmConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/EnvVarConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  variable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ErlangConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FennelConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FillConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FossilBranchConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length = _js2n__-prdslib.isType 'Integer,
                  truncation_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FossilMetricsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  added_style = _js2n__-prdslib.isType '"String",
                  deleted_style = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  only_nonzero_diffs = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GcloudConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  project_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  region_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitBranchConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  always_show_remote = _js2n__-prdslib.isType '"Bool",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  ignore_branches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  only_attached = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length = _js2n__-prdslib.isType 'Integer,
                  truncation_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitCommitConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  commit_hash_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  only_detached = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  tag_disabled = _js2n__-prdslib.isType '"Bool",
                  tag_max_candidates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  tag_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitMetricsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  added_style = _js2n__-prdslib.isType '"String",
                  deleted_style = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  ignore_submodules = _js2n__-prdslib.isType '"Bool",
                  only_nonzero_diffs = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitStateConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  am = _js2n__-prdslib.isType '"String",
                  am_or_rebase = _js2n__-prdslib.isType '"String",
                  bisect = _js2n__-prdslib.isType '"String",
                  cherry_pick = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  "merge" = _js2n__-prdslib.isType '"String",
                  rebase = _js2n__-prdslib.isType '"String",
                  revert = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitStatusConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ahead = _js2n__-prdslib.isType '"String",
                  behind = _js2n__-prdslib.isType '"String",
                  conflicted = _js2n__-prdslib.isType '"String",
                  deleted = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  diverged = _js2n__-prdslib.isType '"String",
                  format = _js2n__-prdslib.isType '"String",
                  ignore_submodules = _js2n__-prdslib.isType '"Bool",
                  modified = _js2n__-prdslib.isType '"String",
                  renamed = _js2n__-prdslib.isType '"String",
                  staged = _js2n__-prdslib.isType '"String",
                  stashed = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  typechanged = _js2n__-prdslib.isType '"String",
                  untracked = _js2n__-prdslib.isType '"String",
                  up_to_date = _js2n__-prdslib.isType '"String",
                  windows_starship =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GleamConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GoConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  not_capable_style = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GradleConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  recursive = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GuixShellConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HaskellConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HaxeConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HelmConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HgBranchConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length = _js2n__-prdslib.isType 'Integer,
                  truncation_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HostnameConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  ssh_only = _js2n__-prdslib.isType '"Bool",
                  ssh_symbol = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  trim_at = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavaConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JobsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  number_threshold = _js2n__-prdslib.isType 'Integer,
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  symbol_threshold = _js2n__-prdslib.isType 'Integer,
                  threshold = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JuliaConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KotlinConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  kotlin_binary = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KubernetesConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  context_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  contexts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/KubernetesContextConfig!predicate"
                        ],
                  detect_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  user_aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KubernetesContextConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  context_alias =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  context_pattern = _js2n__-prdslib.isType '"String",
                  style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  symbol =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  user_alias =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  user_pattern =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LineBreakConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { disabled = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocalipConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  ssh_only = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LuaConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  lua_binary = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MemoryConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  threshold = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MesonConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  truncation_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MojoConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NatsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NimConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NixShellConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  heuristic = _js2n__-prdslib.isType '"Bool",
                  impure_msg = _js2n__-prdslib.isType '"String",
                  pure_msg = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  unknown_msg = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NodejsConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  not_capable_style = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OCamlConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  global_switch_indicator = _js2n__-prdslib.isType '"String",
                  local_switch_indicator = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OSConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OdinConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  show_commit = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OpaConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/OspConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PackageConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  display_private = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PerlConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PhpConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PijulConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length = _js2n__-prdslib.isType 'Integer,
                  truncation_symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PulumiConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  search_upwards = _js2n__-prdslib.isType '"Bool",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PureScriptConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PythonConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  pyenv_prefix = _js2n__-prdslib.isType '"String",
                  pyenv_version_name = _js2n__-prdslib.isType '"Bool",
                  python_binary =
                    _js2n__-refsenv."_js2n__-:definitions/Either_for_String_and_Array_of_String!predicate",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/QuartoConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RLangConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RakuConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RedConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RubyConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_variables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RustConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScalaConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ShLvlConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  repeat = _js2n__-prdslib.isType '"Bool",
                  repeat_offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  threshold = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ShellConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bash_indicator = _js2n__-prdslib.isType '"String",
                  cmd_indicator = _js2n__-prdslib.isType '"String",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  elvish_indicator = _js2n__-prdslib.isType '"String",
                  fish_indicator = _js2n__-prdslib.isType '"String",
                  format = _js2n__-prdslib.isType '"String",
                  ion_indicator = _js2n__-prdslib.isType '"String",
                  nu_indicator = _js2n__-prdslib.isType '"String",
                  powershell_indicator = _js2n__-prdslib.isType '"String",
                  pwsh_indicator =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  style = _js2n__-prdslib.isType '"String",
                  tcsh_indicator = _js2n__-prdslib.isType '"String",
                  unknown_indicator = _js2n__-prdslib.isType '"String",
                  xonsh_indicator = _js2n__-prdslib.isType '"String",
                  zsh_indicator = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SingularityConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SolidityConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  compiler =
                    _js2n__-refsenv."_js2n__-:definitions/Either_for_String_and_Array_of_String!predicate",
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SpackConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  truncation_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/StatusConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  failure_style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  format = _js2n__-prdslib.isType '"String",
                  map_symbol = _js2n__-prdslib.isType '"Bool",
                  not_executable_symbol = _js2n__-prdslib.isType '"String",
                  not_found_symbol = _js2n__-prdslib.isType '"String",
                  pipestatus = _js2n__-prdslib.isType '"Bool",
                  pipestatus_format = _js2n__-prdslib.isType '"String",
                  pipestatus_segment_format =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pipestatus_separator = _js2n__-prdslib.isType '"String",
                  recognize_signal_code = _js2n__-prdslib.isType '"Bool",
                  sigint_symbol = _js2n__-prdslib.isType '"String",
                  signal_symbol = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  success_style =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  success_symbol = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SudoConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_windows = _js2n__-prdslib.isType '"Bool",
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SwiftConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TerraformConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TimeConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  time_format =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  time_range = _js2n__-prdslib.isType '"String",
                  use_12hr = _js2n__-prdslib.isType '"Bool",
                  utc_time_offset = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/TypstConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/UsernameConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aliases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_env_vars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  show_always = _js2n__-prdslib.isType '"Bool",
                  style_root = _js2n__-prdslib.isType '"String",
                  style_user = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VagrantConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VcshConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ZigConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  detect_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_files =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  detect_folders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  disabled = _js2n__-prdslib.isType '"Bool",
                  format = _js2n__-prdslib.isType '"String",
                  style = _js2n__-prdslib.isType '"String",
                  symbol = _js2n__-prdslib.isType '"String",
                  version_format = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      "$schema" | String | optional,
      add_newline | Bool | optional,
      aws
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/AwsConfig!predicate"
        | optional,
      azure
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/AzureConfig!predicate"
        | optional,
      battery
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/BatteryConfig!predicate"
        | optional,
      buf
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/BufConfig!predicate"
        | optional,
      bun
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/BunConfig!predicate"
        | optional,
      c
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CConfig!predicate"
        | optional,
      character
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CharacterConfig!predicate"
        | optional,
      cmake
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CMakeConfig!predicate"
        | optional,
      cmd_duration
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CmdDurationConfig!predicate"
        | optional,
      cobol
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CobolConfig!predicate"
        | optional,
      command_timeout
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | optional,
      conda
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CondaConfig!predicate"
        | optional,
      container
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ContainerConfig!predicate"
        | optional,
      continuation_prompt | String | optional,
      crystal
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/CrystalConfig!predicate"
        | optional,
      custom
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/CustomConfig!predicate"
            ])
        | optional,
      daml
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DamlConfig!predicate"
        | optional,
      dart
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DartConfig!predicate"
        | optional,
      deno
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DenoConfig!predicate"
        | optional,
      directory
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DirectoryConfig!predicate"
        | optional,
      direnv
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DirenvConfig!predicate"
        | optional,
      docker_context
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DockerContextConfig!predicate"
        | optional,
      dotnet
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/DotnetConfig!predicate"
        | optional,
      elixir
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ElixirConfig!predicate"
        | optional,
      elm
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ElmConfig!predicate"
        | optional,
      env_var
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/EnvVarConfig!predicate"
            ])
        | optional,
      erlang
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ErlangConfig!predicate"
        | optional,
      fennel
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/FennelConfig!predicate"
        | optional,
      fill
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/FillConfig!predicate"
        | optional,
      follow_symlinks | Bool | optional,
      format | String | optional,
      fossil_branch
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/FossilBranchConfig!predicate"
        | optional,
      fossil_metrics
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/FossilMetricsConfig!predicate"
        | optional,
      gcloud
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GcloudConfig!predicate"
        | optional,
      git_branch
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GitBranchConfig!predicate"
        | optional,
      git_commit
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GitCommitConfig!predicate"
        | optional,
      git_metrics
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GitMetricsConfig!predicate"
        | optional,
      git_state
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GitStateConfig!predicate"
        | optional,
      git_status
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GitStatusConfig!predicate"
        | optional,
      gleam
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GleamConfig!predicate"
        | optional,
      golang
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GoConfig!predicate"
        | optional,
      gradle
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GradleConfig!predicate"
        | optional,
      guix_shell
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/GuixShellConfig!predicate"
        | optional,
      haskell
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/HaskellConfig!predicate"
        | optional,
      haxe
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/HaxeConfig!predicate"
        | optional,
      helm
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/HelmConfig!predicate"
        | optional,
      hg_branch
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/HgBranchConfig!predicate"
        | optional,
      hostname
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/HostnameConfig!predicate"
        | optional,
      java
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/JavaConfig!predicate"
        | optional,
      jobs
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/JobsConfig!predicate"
        | optional,
      julia
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/JuliaConfig!predicate"
        | optional,
      kotlin
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/KotlinConfig!predicate"
        | optional,
      kubernetes
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/KubernetesConfig!predicate"
        | optional,
      line_break
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/LineBreakConfig!predicate"
        | optional,
      localip
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/LocalipConfig!predicate"
        | optional,
      lua
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/LuaConfig!predicate"
        | optional,
      memory_usage
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/MemoryConfig!predicate"
        | optional,
      meson
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/MesonConfig!predicate"
        | optional,
      mojo
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/MojoConfig!predicate"
        | optional,
      nats
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/NatsConfig!predicate"
        | optional,
      nim
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/NimConfig!predicate"
        | optional,
      nix_shell
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/NixShellConfig!predicate"
        | optional,
      nodejs
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/NodejsConfig!predicate"
        | optional,
      ocaml
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/OCamlConfig!predicate"
        | optional,
      odin
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/OdinConfig!predicate"
        | optional,
      opa
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/OpaConfig!predicate"
        | optional,
      openstack
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/OspConfig!predicate"
        | optional,
      os
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/OSConfig!predicate"
        | optional,
      package
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PackageConfig!predicate"
        | optional,
      palette
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.isType 'Null ])
        | optional,
      palettes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
            ])
        | optional,
      perl
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PerlConfig!predicate"
        | optional,
      php
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PhpConfig!predicate"
        | optional,
      pijul_channel
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PijulConfig!predicate"
        | optional,
      profiles
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ])
        | optional,
      pulumi
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PulumiConfig!predicate"
        | optional,
      purescript
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PureScriptConfig!predicate"
        | optional,
      python
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PythonConfig!predicate"
        | optional,
      quarto
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/QuartoConfig!predicate"
        | optional,
      raku
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/RakuConfig!predicate"
        | optional,
      red
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/RedConfig!predicate"
        | optional,
      right_format | String | optional,
      rlang
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/RLangConfig!predicate"
        | optional,
      ruby
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/RubyConfig!predicate"
        | optional,
      rust
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/RustConfig!predicate"
        | optional,
      scala
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ScalaConfig!predicate"
        | optional,
      scan_timeout
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | optional,
      shell
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ShellConfig!predicate"
        | optional,
      shlvl
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ShLvlConfig!predicate"
        | optional,
      singularity
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/SingularityConfig!predicate"
        | optional,
      solidity
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/SolidityConfig!predicate"
        | optional,
      spack
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/SpackConfig!predicate"
        | optional,
      status
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/StatusConfig!predicate"
        | optional,
      sudo
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/SudoConfig!predicate"
        | optional,
      swift
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/SwiftConfig!predicate"
        | optional,
      terraform
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/TerraformConfig!predicate"
        | optional,
      time
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/TimeConfig!predicate"
        | optional,
      typst
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/TypstConfig!predicate"
        | optional,
      username
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/UsernameConfig!predicate"
        | optional,
      vagrant
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/VagrantConfig!predicate"
        | optional,
      vcsh
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/VcshConfig!predicate"
        | optional,
      vlang
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/VConfig!predicate"
        | optional,
      zig
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ZigConfig!predicate"
        | optional,
    }