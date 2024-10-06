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
      "_js2n__-:definitions/clearTextReporterOptions!contract" =
        {
            allowColor
              | Bool
              | doc "Indicates whether or not to use color coding in output."
              | optional,
            allowEmojis
              | Bool
              | doc "Enable emojis in your clear text report (experimental)."
              | optional,
            logTests
              | Bool
              | doc "Indicates whether or not to log which tests were executed for a given mutant."
              | optional,
            maxTestsToLog
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.minimum 0
                  ])
              | doc "Indicates the maximum amount of test to log when `logTests` is enabled"
              | optional,
            reportMutants
              | Bool
              | doc "Indicates whether or not to log all mutants."
              | optional,
            reportScoreTable
              | Bool
              | doc "Indicates whether or not to log score table."
              | optional,
            reportTests
              | Bool
              | doc "Indicates whether or not to log all tests."
              | optional,
            skipFull
              | Bool
              | doc "Indicates whether rows with 100% mutation score are hidden in the score table."
              | optional,
            ..
          },
      "_js2n__-:definitions/commandRunnerOptions!contract" =
        {
            command
              | String
              | doc "The command to test each mutant. For example \"npm run mocha\". Defaults to \"npm test\"."
              | optional,
            ..
          },
      "_js2n__-:definitions/coverageAnalysis!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'perTest, 'all, 'off |] ],
      "_js2n__-:definitions/dashboardOptions!contract" =
        {
            baseUrl
              | String
              | doc "Indicates the base url of the stryker dashboard."
              | optional,
            module
              | String
              | doc "Indicates which module to use if the \"dashboard\" reporter is enabled."
              | optional,
            project
              | String
              | doc "Indicates which project to use if the \"dashboard\" reporter is enabled."
              | optional,
            reportType
              | _js2n__-refsenv."_js2n__-:definitions/reportType!contract"
              | doc "Indicates wether to send a full report (inc. source code and mutant results) or only the mutation score."
              | optional,
            version
              | String
              | doc "Indicates which version to use if the \"dashboard\" reporter is enabled."
              | optional,
          },
      "_js2n__-:definitions/eventRecorderOptions!contract" =
        {
            baseDir
              | String
              | doc "The base dir to write the events to"
              | optional,
          },
      "_js2n__-:definitions/htmlReporterOptions!contract" =
        {
            fileName
              | String
              | doc "The `fileName` of the html report."
              | optional,
          },
      "_js2n__-:definitions/jsonReporterOptions!contract" =
        {
            fileName
              | String
              | doc "The relative filename for the json report."
              | optional,
          },
      "_js2n__-:definitions/logLevel!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [| 'trace, 'debug, 'info, 'warn, 'error, 'fatal, 'off |]
            ],
      "_js2n__-:definitions/mutationScoreThresholds!contract" =
        {
            break
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-refsenv."_js2n__-:definitions/percentage!predicate"
                  ])
              | optional,
            high
              | _js2n__-refsenv."_js2n__-:definitions/percentage!contract"
              | optional,
            low
              | _js2n__-refsenv."_js2n__-:definitions/percentage!contract"
              | optional,
          },
      "_js2n__-:definitions/mutatorDescriptor!contract" =
        {
            excludedMutations | Array (String) | optional,
            plugins
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ])
                      ],
                    _js2n__-prdslib.isType 'Null
                  ])
              | doc "Override the default babel plugins Stryker uses to parse your JavaScript files. The default list of plugins is extensive and normally doesn't need overriding. Stryker also loads your babel plugins by default (if you have them). If Stryker's default babel plugins conflicts with your plugins, try to override this list with an empty array."
              | optional,
          },
      "_js2n__-:definitions/percentage!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Number",
                _js2n__-prdslib.numbers.maximum 100,
                _js2n__-prdslib.numbers.minimum 0
              ]),
      "_js2n__-:definitions/percentage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 100,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/reportType!contract" =
        std.contract.Sequence
            [ std.enum.TagOrString, [| 'mutationScore, 'full |] ],
      "_js2n__-:definitions/warningOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  preprocessorErrors = _js2n__-prdslib.isType '"Bool",
                  slow = _js2n__-prdslib.isType '"Bool",
                  unknownOptions = _js2n__-prdslib.isType '"Bool",
                  unserializableOptions = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      allowConsoleColors
        | Bool
        | doc "The 'allowConsoleColors' value indicates whether Stryker should use colors in console."
        | optional,
      allowEmpty
        | Bool
        | doc "Allows stryker to exit without any errors in cases where no tests are found"
        | optional,
      appendPlugins
        | Array (String)
        | doc "A list of additional plugins you want Stryker to load (`require`) without overwriting the (default) `plugins`."
        | optional,
      buildCommand
        | String
        | doc "Configure a build command to run after mutating the code, but before mutants are tested. This is generally used to transpile your code before testing. Only configure this if your test runner doesn't take care of this already and you're not using just-in-time transpiler like `babel/register` or `ts-node`."
        | optional,
      checkerNodeArgs
        | Array (String)
        | doc "Configure arguments to be passed as exec arguments to the checker child process(es). For example, running Stryker with `--concurrency 1 --checkerNodeArgs --inspect-brk` will allow you to debug the checker child process. See `execArgv` of [`child_process.fork`](https://nodejs.org/api/child_process.html#child_process_child_process_fork_modulepath_args_options)"
        | optional,
      checkers
        | Array (String)
        | doc "Enable checker plugins here. A checker plugin will be invoked for each mutant before it is run in a test runner. It can check to see of a given mutant is valid, by for example validate that it won't result in a type error"
        | optional,
      cleanTempDir
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ "always", false, true ])
        | doc m%"
          Choose whether or not to clean the temp dir (which is ".stryker-tmp" inside the current working directory by default).
           - false: Never delete the temp dir;
           - true: Delete the tmp dir after a successful run;
           - "always": Always delete the temp dir, regardless of whether the run was successful.
        "%
        | optional,
      clearTextReporter
        | _js2n__-refsenv."_js2n__-:definitions/clearTextReporterOptions!contract"
        | doc "The options for the clear text reporter."
        | optional,
      commandRunner
        | _js2n__-refsenv."_js2n__-:definitions/commandRunnerOptions!contract"
        | doc "Options used by the command test runner. Note: these options will only be used when the command test runner is activated (this is the default)"
        | optional,
      concurrency
        | Number
        | doc "Set the concurrency of workers. Stryker will always run checkers and test runners in parallel by creating worker processes (note, not `worker_threads`). This defaults to `n-1` where `n` is the number of logical CPU cores available on your machine, unless `n <= 4`, in that case it uses `n`. This is a sane default for most use cases."
        | optional,
      coverageAnalysis
        | _js2n__-refsenv."_js2n__-:definitions/coverageAnalysis!contract"
        | doc m%"
          Indicates which coverage analysis strategy to use. During mutation testing, Stryker will try to only run the tests that cover a particular mutant.
          
          'perTest': Analyse coverage per test.
          'all': Analyse the coverage for the entire test suite.
          'off' (default): Don't use coverage analysis
        "%
        | optional,
      dashboard
        | _js2n__-refsenv."_js2n__-:definitions/dashboardOptions!contract"
        | doc "The options for the dashboard reporter."
        | optional,
      disableBail
        | Bool
        | doc "Disables the default of bailing after first failing test. When true runs all tests covering a mutant. Useful when the subject under test is not completely isolated by mocks and you want to know which tests are killing the mutants. This will impact performance."
        | optional,
      disableTypeChecks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ])
        | doc "Set to 'true' to disable type checking, or 'false' to enable it. For more control, configure a pattern that matches the files of which type checking has to be disabled. This is needed because Stryker will create (typescript) type errors when inserting the mutants in your code. Stryker disables type checking by inserting `// @ts-nocheck` atop those files and removing other `// @ts-xxx` directives (so they won't interfere with `@ts-nocheck`). The default setting allows these directives to be stripped from all JavaScript and friend files in `lib`, `src` and `test` directories."
        | optional,
      dryRunOnly
        | Bool
        | doc "Execute the initial test run only without doing actual mutation testing. Dry run only will still mutate your code before doing the dry run without those mutants being active, thus can be used to test that StrykerJS can run your test setup. This can be useful, for example, in CI pipelines."
        | optional,
      dryRunTimeoutMinutes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc "Configure an absolute timeout for the initial test run. (It can take a while, therefore we use minutes as time unit.)"
        | optional,
      eventReporter
        | _js2n__-refsenv."_js2n__-:definitions/eventRecorderOptions!contract"
        | doc "The options for the event recorder reporter."
        | optional,
      fileLogLevel
        | _js2n__-refsenv."_js2n__-:definitions/logLevel!contract"
        | doc "Set the log level that Stryker uses to write to the \"stryker.log\" file"
        | optional,
      "force"
        | Bool
        | doc "Run all mutants, even if --incremental is provided and an incremental file exists. Can be used to force a rebuild of the incremental file."
        | optional,
      htmlReporter
        | _js2n__-refsenv."_js2n__-:definitions/htmlReporterOptions!contract"
        | doc "The options for the html reporter"
        | optional,
      ignorePatterns
        | Array (String)
        | doc "A comma separated list of patterns used for specifying which files need to be ignored. This should only be used in cases where you experience a slow Stryker startup, because too many (or too large) files are copied to the sandbox that are not needed to run the tests. For example, image or movie directories. Note: This option will have NO effect when using the `--inPlace` option. The directories `node_modules`, `.git` and some others are always ignored. Example: `--ignorePatterns dist`. These patterns are ALWAYS ignored: [`node_modules`, `.git`, `/reports`, `*.tsbuildinfo`, `/stryker.log`, `.stryker-tmp`]. Because Stryker always ignores these, you should rarely have to adjust the `ignorePatterns` setting at all. This is useful to speed up Stryker by ignoring big directories/files you might have in your repo that has nothing to do with your code. For example, 1.5GB of movie/image files. Specify the patterns to all files or directories that are not used to run your tests and thus should NOT be copied to the sandbox directory for mutation testing. Each patterns in this array should be a [glob pattern](#usage-of-globbing-expressions-on-options). If a glob pattern starts with `/`, the pattern is relative to the current working directory. For example, `/foo.js` matches to `foo.js` but not `subdir/foo.js`. However to SELECT specific files TO BE mutated, you better use `--mutate`."
        | optional,
      ignoreStatic
        | Bool
        | doc "Ignore static mutants. Static mutants are mutants which are only executed during the loading of a file. This means that Stryker has to reload the entire environment in order to test the mutant AND has to run all tests. Therefore, it might make sense to ignore static mutants."
        | optional,
      ignorers
        | Array (String)
        | doc "Specify which ignore-plugins to use. With an ignore-plugin you can ignore mutants inside common code patterns that you don't want to test for some reason. For example, you can use this to ignore all `console.debug()` statements from being mutated."
        | optional,
      inPlace
        | Bool
        | doc m%"
          Determines whether or not Stryker should mutate your files in place. Note: mutating your files in place is generally not needed for mutation testing, unless you have a dependency in your project that is really dependent on the file locations (like "app-root-path" for example).
          
          When `true`, Stryker will override your files, but it will keep a copy of the originals in the temp directory (using `tempDirName`) and it will place the originals back after it is done. Also with `true` the `ignorePatterns` has no effect any more.
          
          When `false` (default) Stryker will work in the copy of your code inside the temp directory.
        "%
        | optional,
      incremental
        | Bool
        | doc "Enable 'incremental mode'. Stryker will store results in a file and use that file to speed up the next --incremental run"
        | optional,
      incrementalFile
        | String
        | doc "Specify the file to use for incremental mode."
        | optional,
      jsonReporter
        | _js2n__-refsenv."_js2n__-:definitions/jsonReporterOptions!contract"
        | doc "The options for the json reporter"
        | optional,
      logLevel
        | _js2n__-refsenv."_js2n__-:definitions/logLevel!contract"
        | doc "Set the log level that Stryker uses to write to the console."
        | optional,
      maxConcurrentTestRunners
        | Number
        | doc "[DEPRECATED please use \"concurrency\" instead]. Specifies the maximum number of concurrent test runners to spawn. Mutation testing is time consuming. By default, Stryker tries to make the most of your CPU's, by spawning as many test runners as you have CPU cores (`Number.MAX_SAFE_INTEGER`)."
        | optional,
      maxTestRunnerReuse
        | Number
        | doc "Restart each test runner worker process after `n` runs. Not recommended unless you are experiencing memory leaks that you are unable to resolve. Configuring `0` here means infinite reuse."
        | optional,
      mutate
        | Array (String)
        | doc m%"
          With `mutate` you configure the subset of files or just one specific file to be mutated. These should be your _production code files_, and definitely not your test files.
          (Whereas with `ignorePatterns` you prevent non-relevant files from being copied to the sandbox directory in the first place)
          The default will try to guess your production code files based on sane defaults. It reads like this:
          - Include all js-like files inside the `src` or `lib` dir
          - Except files inside `__tests__` directories and file names ending with `test` or `spec`.
          If the defaults are not sufficient for you, for example in a angular project you might want to
           **exclude** not only the `*.spec.ts` files but other files too, just like the default already does.
          It is possible to specify exactly which code blocks to mutate by means of a _mutation range_. This can be done postfixing your file with `:startLine[:startColumn]-endLine[:endColumn]`. Example: src/index.js:1:3-1:5
        "%
        | optional,
      mutator
        | _js2n__-refsenv."_js2n__-:definitions/mutatorDescriptor!contract"
        | doc "Configure how Stryker mutates your code."
        | optional,
      packageManager
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ "npm", "yarn", "pnpm" ])
        | doc "The package manager Stryker can use to install missing dependencies."
        | optional,
      plugins
        | Array (String)
        | doc "With 'plugins', you can add additional Node modules for Stryker to load (or require). By default, all node_modules starting with @stryker-mutator/* will be loaded, so you would normally not need to specify this option. These modules should be installed right next to stryker. For a current list of plugins, you can consult 'npm' or 'stryker-mutator.io.'"
        | optional,
      reporters
        | Array (String)
        | doc "With reporters, you can set the reporters for stryker to use."
        | optional,
      symlinkNodeModules
        | Bool
        | doc "The 'symlinkNodeModules' value indicates whether Stryker should create a symbolic link to your current node_modules directory in the sandbox directories. This makes running your tests by Stryker behave more like your would run the tests yourself in your project directory. Only disable this setting if you really know what you are doing."
        | optional,
      tempDirName
        | String
        | doc "Choose a different temp dir that Stryker uses for mutation testing. This directory will contain copies of your source code during a mutation test run. It will be created if it not exists and is *entirely deleted* after a successful run, so change this with caution."
        | optional,
      testRunner
        | String
        | doc "With 'testRunner' you specify the test runner that Stryker uses to run your tests. The default value is command. The command runner runs a configurable bash/cmd command and bases the result on the exit code of that program (0 for success, otherwise failed). You can configure this command via the config file using the 'commandRunner: { command: 'npm run mocha' }'. It uses 'npm test' as the command by default."
        | optional,
      testRunnerNodeArgs
        | Array (String)
        | doc "Configure arguments to be passed as exec arguments to the test runner child process. For example, running Stryker with `--timeoutMS 9999999 --concurrency 1 --testRunnerNodeArgs --inspect-brk` will allow you to debug the test runner child process. See `execArgv` of [`child_process.fork`](https://nodejs.org/api/child_process.html#child_process_child_process_fork_modulepath_args_options)"
        | optional,
      thresholds
        | _js2n__-refsenv."_js2n__-:definitions/mutationScoreThresholds!contract"
        | doc "Specify the thresholds for mutation score."
        | optional,
      timeoutFactor
        | Number
        | doc "Configure the allowed timeout deviation relative to the time of a normal test run. Tweak this if you notice that mutants are prone to creating slower code, but not infinite loops (for that, use `timeoutMS`)"
        | optional,
      timeoutMS
        | Number
        | doc "Configure an absolute timeout deviation. Tweak this if you run Stryker on a busy machine and you need to wait longer to make sure that the code indeed entered an infinite loop."
        | optional,
      tsconfigFile
        | String
        | doc "Configure the (root) tsconfig file for typescript projects. This will allow Stryker to rewrite the `extends` and `references` settings in this and related tsconfig files in your sandbox. Defaults to `tsconfig.json`. This setting is also used when you enable the `@stryker-mutator/typescript-checker plugin"
        | optional,
      warnings
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/warningOptions!predicate"
            ])
        | doc "Enable or disable certain warnings"
        | optional,
      ..
    }