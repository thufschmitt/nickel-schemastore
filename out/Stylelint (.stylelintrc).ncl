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
      "_js2n__-:definitions/allRules!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.allOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/atRule!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/block!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/comment!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/customMedia!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/customProperty!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/declaration!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/declarationBlock!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/font!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/function!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/generalSheet!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/keyframeDeclaration!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/length!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/lightness!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/mediaFeature!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/mediaQuery!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/mediaQueryList!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/number!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/property!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/rootRule!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/rule!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/selector!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/selectorList!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/shorthandProperty!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/string!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/stylelintDisableComment!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/time!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/unit!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/value!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/valueList!predicate"
                  ]
              ]),
      "_js2n__-:definitions/alwaysMultiLineRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "always", "always-multi-line", [  ] ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "always", "always-multi-line", {} ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/alwaysNeverRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "always", "never", [  ] ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "always", "never", {} ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/arrayStringRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Null,
                      _js2n__-prdslib.isType '"String"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum [ [  ], {} ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/atRule!predicate" =
        _js2n__-prdslib.records.record
            {
              at-rule-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              at-rule-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", "never", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "always", "never", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "all-nested",
                                                                  "after-same-name",
                                                                  "inside-block",
                                                                  "blockless-after-same-name-blockless",
                                                                  "blockless-after-blockless",
                                                                  "first-nested"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment",
                                                                  "first-nested",
                                                                  "inside-block",
                                                                  "blockless-after-same-name-blockless",
                                                                  "blockless-after-blockless"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignoreAtRules =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              at-rule-name-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              at-rule-name-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysMultiLineRule!predicate",
              at-rule-name-space-after =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "always", "always-single-line", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always",
                                                "always-single-line",
                                                {}
                                              ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              at-rule-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreAtRules =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              at-rule-no-vendor-prefix =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              at-rule-semicolon-newline-after =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "always", {} ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              at-rule-semicolon-space-before = _js2n__-prdslib.always,
              at-rule-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/block!predicate" =
        _js2n__-prdslib.records.record
            {
              block-closing-brace-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "always-multi-line", "never", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always-multi-line",
                                                "never",
                                                {}
                                              ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              block-closing-brace-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineSpaceWithIgnoreRule!predicate",
              block-closing-brace-newline-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              block-closing-brace-space-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineSpaceRule!predicate",
              block-closing-brace-space-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineSpaceRule!predicate",
              block-no-empty =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              block-no-single-line =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              block-opening-brace-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              block-opening-brace-newline-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "always",
                                  "always-single-line",
                                  "never-single-line",
                                  "always-multi-line",
                                  "never-multi-line",
                                  [  ]
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always",
                                                "always-single-line",
                                                "never-single-line",
                                                "always-multi-line",
                                                "never-multi-line",
                                                {}
                                              ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              block-opening-brace-space-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineSpaceRule!predicate",
              block-opening-brace-space-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineSpaceWithIgnoreRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/booleanRule!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"Bool",
                    _js2n__-prdslib.isType '"Array"
                  ],
                _js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType 'Null,
                    _js2n__-prdslib.isType '"Bool",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType 'Record
                                ],
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ]),
                        _js2n__-prdslib.arrays.maxItems 2,
                        _js2n__-prdslib.arrays.minItems 2,
                        _js2n__-prdslib.arrays.uniqueItems
                      ]
                  ]
              ]),
      "_js2n__-:definitions/booleanRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/color!predicate" =
        _js2n__-prdslib.records.record
            {
              color-hex-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              color-hex-length =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "short", "long", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "short", "long", {} ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              color-named =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "always-where-possible", "never", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always-where-possible",
                                                "never",
                                                {}
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              color-no-hex =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              color-no-invalid-hex =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/comment!predicate" =
        _js2n__-prdslib.records.record
            {
              comment-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", "never", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "always", "never", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "first-nested"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "between-comments",
                                                                  "after-comment",
                                                                  "stylelint-command",
                                                                  "stylelint-commands"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              comment-no-empty =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              comment-whitespace-inside =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              comment-word-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/coreRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disableFix = _js2n__-prdslib.isType '"Bool",
                  message = _js2n__-prdslib.isType '"String",
                  reportDisables = _js2n__-prdslib.isType '"Bool",
                  severity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "warning", "error" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/customMedia!predicate" =
        _js2n__-prdslib.records.record
            {
              custom-media-pattern =
                _js2n__-refsenv."_js2n__-:definitions/stringRule!predicate",
              no-unknown-custom-media =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const true,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.const true,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/customProperty!predicate" =
        _js2n__-prdslib.records.record
            {
              custom-property-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", "never", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "always", "never", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment",
                                                                  "after-custom-property",
                                                                  "first-nested"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment",
                                                                  "inside-single-line-block"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              custom-property-no-outside-root =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              custom-property-pattern =
                _js2n__-refsenv."_js2n__-:definitions/stringRule!predicate",
              no-unknown-custom-properties =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const true,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.const true,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/declaration!predicate" =
        _js2n__-prdslib.records.record
            {
              declaration-bang-space-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              declaration-bang-space-before =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              declaration-colon-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysMultiLineRule!predicate",
              declaration-colon-space-after =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "always",
                                  "never",
                                  "always-single-line",
                                  [  ]
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always",
                                                "never",
                                                "always-single-line",
                                                {}
                                              ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              declaration-colon-space-before =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              declaration-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "always", "never", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "always", "never", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment",
                                                                  "after-declaration",
                                                                  "first-nested"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment",
                                                                  "after-declaration",
                                                                  "first-nested",
                                                                  "inside-single-line-block"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              declaration-no-important =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              declaration-property-unit-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/objectRule!predicate",
              declaration-property-unit-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/objectRule!predicate",
              declaration-property-value-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/objectRule!predicate",
              declaration-property-value-no-unknown =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const true,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.const true,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                  _js2n__-prdslib.records.record
                                    {
                                      ignoreProperties =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.anyOf
                                                  [
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.isType
                                                                '"String")
                                                          ]
                                                      ],
                                                    _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.strings.pattern
                                                                  "^\\/.+\\/i?$"
                                                              ]
                                                          ],
                                                        _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Array",
                                                            _js2n__-prdslib.arrays.arrayOf
                                                              (_js2n__-prdslib.anyOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    'Record,
                                                                  _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.strings.pattern
                                                                        "^\\/.+\\/i?$"
                                                                    ]
                                                                ])
                                                          ]
                                                      ]
                                                  ])
                                            ],
                                      propertiesSyntax =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ]
                                                  ])
                                            ],
                                      typesSyntax =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ]
                                                  ])
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
              declaration-property-value-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/objectRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/declarationBlock!predicate" =
        _js2n__-prdslib.records.record
            {
              declaration-block-no-duplicate-properties =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "consecutive-duplicates",
                                                                  "consecutive-duplicates-with-different-values",
                                                                  "consecutive-duplicates-with-different-syntaxes",
                                                                  "consecutive-duplicates-with-same-prefixless-values"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignoreProperties =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              declaration-block-no-ignored-properties =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              declaration-block-no-redundant-longhand-properties =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreShorthands =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              declaration-block-no-shorthand-property-overrides =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              declaration-block-properties-order =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "alphabetical", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "alphabetical", [  ], {} ]
                                          ],
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                order =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "strict",
                                                            "flexible"
                                                          ]
                                                      ],
                                                properties =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                                unspecified =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "top",
                                                            "bottom",
                                                            "bottomAlphabetical",
                                                            "ignore"
                                                          ]
                                                      ],
                                              } {} true _js2n__-prdslib.always,
                                            _js2n__-prdslib.records.dependencies
                                              {
                                                order = [ "properties" ],
                                                properties = [ "order" ],
                                              }
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              declaration-block-semicolon-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              declaration-block-semicolon-newline-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              declaration-block-semicolon-space-after =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              declaration-block-semicolon-space-before =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              declaration-block-single-line-max-declarations =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
              declaration-block-trailing-semicolon =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/font!predicate" =
        _js2n__-prdslib.records.record
            {
              font-family-name-quotes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "always-where-required",
                                  "always-where-recommended",
                                  "always-unless-keyword",
                                  [  ]
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always-where-required",
                                                "always-where-recommended",
                                                "always-unless-keyword",
                                                {}
                                              ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              font-weight-notation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "numeric", "named-where-possible", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "numeric",
                                                "named-where-possible",
                                                {}
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ "relative" ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/function!predicate" =
        _js2n__-prdslib.records.record
            {
              function-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              function-calc-no-unspaced-operator =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              function-comma-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              function-comma-newline-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              function-comma-space-after =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              function-comma-space-before =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              function-linear-gradient-no-nonstandard-direction =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              function-max-empty-lines =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
              function-name-case =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "lower", "upper", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "lower", "upper", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreFunctions =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              function-parentheses-newline-inside =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              function-parentheses-space-inside =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              function-url-data-uris =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              function-url-no-scheme-relative =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              function-url-quotes =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              function-url-scheme-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              function-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              function-whitespace-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/generalSheet!predicate" =
        _js2n__-prdslib.records.record
            {
              indentation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType 'Integer
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "tab", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum [ "tab", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "block",
                                                                  "param",
                                                                  "value"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "inside-parens",
                                                                  "param",
                                                                  "value"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                indentInsideParens =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "twice",
                                                            "once-at-root-twice-in-block"
                                                          ]
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              linebreaks = _js2n__-prdslib.always,
              max-empty-lines =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
              max-line-length =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType 'Integer
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.isType
                                                              '"Array"
                                                          ],
                                                        _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"String",
                                                                _js2n__-prdslib.enum
                                                                  [
                                                                    "non-comments",
                                                                    "comments"
                                                                  ]
                                                              ],
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  '"Array",
                                                                _js2n__-prdslib.arrays.arrayOf
                                                                  (_js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.enum
                                                                        [
                                                                          "non-comments",
                                                                          "comments"
                                                                        ]
                                                                    ]),
                                                                _js2n__-prdslib.arrays.minItems
                                                                  1,
                                                                _js2n__-prdslib.arrays.uniqueItems
                                                              ]
                                                          ]
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              max-nesting-depth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType 'Integer
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "at-rules-without-declaration-blocks",
                                                                  "blockless-at-rules",
                                                                  "pseudo-classes"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignoreAtRules =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              no-browser-hacks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                browsers =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              no-descending-specificity =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-duplicate-selectors =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-empty-first-line = _js2n__-prdslib.always,
              no-empty-source =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-eol-whitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "empty-lines"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              no-extra-semicolons =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-indistinguishable-colors =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                                threshold =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Integer,
                                                        _js2n__-prdslib.numbers.maximum
                                                          100,
                                                        _js2n__-prdslib.numbers.minimum
                                                          0
                                                      ],
                                                whitelist =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              no-invalid-double-slash-comments =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-missing-end-of-source-newline =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-unknown-animations =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              no-unsupported-browser-features =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                browsers =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                ignore =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              unicode-bom =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/integerRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Null,
                      _js2n__-prdslib.isType 'Integer
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.enum [ {} ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/keyframeDeclaration!predicate" =
        _js2n__-prdslib.records.record
            {
              keyframe-declaration-no-important =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/length!predicate" =
        _js2n__-prdslib.records.record
            {
              length-zero-no-unit =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/lightness!predicate" =
        _js2n__-prdslib.records.record
            {
              lightness-notation =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "percentage", "number" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "percentage", "number" ]
                                    ],
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/lowerUpperRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "lower", "upper", [  ] ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "lower", "upper", {} ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/mediaFeature!predicate" =
        _js2n__-prdslib.records.record
            {
              media-feature-colon-space-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              media-feature-colon-space-before =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              media-feature-name-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              media-feature-name-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreMediaFeatureNames =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              media-feature-name-no-vendor-prefix =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              media-feature-name-unit-allowed-list =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ]
                                  ])
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ]
                                          ])
                                    ],
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
              media-feature-name-value-no-unknown =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const true,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.const true,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
              media-feature-no-missing-punctuation =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              media-feature-parentheses-space-inside =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              media-feature-range-notation =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "prefix", "context" ]
                            ],
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "prefix", "context" ]
                                    ],
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
              media-feature-range-operator-space-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              media-feature-range-operator-space-before =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/mediaQuery!predicate" =
        _js2n__-prdslib.records.record
            {
              media-query-no-invalid =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const true,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.const true,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/mediaQueryList!predicate" =
        _js2n__-prdslib.records.record
            {
              media-query-list-comma-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              media-query-list-comma-newline-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              media-query-list-comma-space-after =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              media-query-list-comma-space-before =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/newlineRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "always",
                          "always-multi-line",
                          "never-multi-line",
                          [  ]
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "always",
                                        "always-multi-line",
                                        "never-multi-line",
                                        {}
                                      ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/newlineSpaceRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "always",
                          "never",
                          "always-single-line",
                          "never-single-line",
                          "always-multi-line",
                          "never-multi-line",
                          [  ]
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "always",
                                        "never",
                                        "always-single-line",
                                        "never-single-line",
                                        "always-multi-line",
                                        "never-multi-line",
                                        {}
                                      ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/newlineSpaceWithIgnoreRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "always",
                          "never",
                          "always-single-line",
                          "never-single-line",
                          "always-multi-line",
                          "never-multi-line",
                          [  ]
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "always",
                                        "always-single-line",
                                        "never-single-line",
                                        "always-multi-line",
                                        "never-multi-line",
                                        {}
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                    _js2n__-prdslib.records.record
                                      {
                                        ignoreAtRules =
                                          _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!predicate",
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/number!predicate" =
        _js2n__-prdslib.records.record
            {
              number-leading-zero =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              number-max-precision =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
              number-no-trailing-zeros =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/objectRule!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!predicate"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!predicate"
                        ],
                      _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                    ],
                  _js2n__-prdslib.arrays.maxItems 2,
                  _js2n__-prdslib.arrays.minItems 2
                ]
            ],
      "_js2n__-:definitions/property!predicate" =
        _js2n__-prdslib.records.record
            {
              property-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              property-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              property-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                checkPrefixed =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                ignoreProperties =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              property-no-vendor-prefix =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              property-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/rootRule!predicate" =
        _js2n__-prdslib.records.record
            {
              root-no-standard-properties =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/rule!predicate" =
        _js2n__-prdslib.records.record
            {
              rule-nested-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "always",
                                  "never",
                                  "always-multi-line",
                                  "never-multi-line",
                                  [  ]
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always",
                                                "never",
                                                "always-multi-line",
                                                "never-multi-line",
                                                {}
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "first-nested"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              rule-non-nested-empty-line-before =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "always",
                                  "never",
                                  "always-multi-line",
                                  "never-multi-line",
                                  [  ]
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always",
                                                "never",
                                                "always-multi-line",
                                                "never-multi-line",
                                                {}
                                              ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                except =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-single-line-comment"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "after-comment"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/selector!predicate" =
        _js2n__-prdslib.records.record
            {
              selector-anb-no-unmatchable =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const true,
                          _js2n__-prdslib.isType 'Null
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.const true,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {} {} false
                                    _js2n__-prdslib.never,
                                  _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                ]
                            ],
                          _js2n__-prdslib.arrays.maxItems 2,
                          _js2n__-prdslib.arrays.minItems 1
                        ]
                    ],
              selector-attribute-brackets-space-inside =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-attribute-operator-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              selector-attribute-operator-space-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-attribute-operator-space-before =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-attribute-operator-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              selector-attribute-quotes =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-class-pattern =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                resolveNestedSelectors =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              selector-combinator-space-after =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-combinator-space-before =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-descendant-combinator-no-non-space =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-id-pattern =
                _js2n__-refsenv."_js2n__-:definitions/stringRule!predicate",
              selector-max-compound-selectors =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
              selector-max-empty-lines =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
              selector-max-specificity =
                _js2n__-refsenv."_js2n__-:definitions/stringRule!predicate",
              selector-nested-pattern =
                _js2n__-refsenv."_js2n__-:definitions/stringRule!predicate",
              selector-no-attribute =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-no-combinator =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-no-id =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-no-qualifying-type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "attribute",
                                                                  "class",
                                                                  "id"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              selector-no-type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignore =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "compounded",
                                                                  "descendant"
                                                                ]
                                                            ]),
                                                        _js2n__-prdslib.arrays.minItems
                                                          1,
                                                        _js2n__-prdslib.arrays.uniqueItems
                                                      ],
                                                ignoreTypes =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              selector-no-universal =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-no-vendor-prefix =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-pseudo-class-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              selector-pseudo-class-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignorePseudoClasses =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              selector-pseudo-class-parentheses-space-inside =
                _js2n__-refsenv."_js2n__-:definitions/alwaysNeverRule!predicate",
              selector-pseudo-class-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/arrayStringRule!predicate",
              selector-pseudo-element-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              selector-pseudo-element-colon-notation =
                _js2n__-refsenv."_js2n__-:definitions/singleDoubleRule!predicate",
              selector-pseudo-element-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignorePseudoElements =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              selector-root-no-composition =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              selector-type-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              selector-type-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreTypes =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/selectorList!predicate" =
        _js2n__-prdslib.records.record
            {
              selector-list-comma-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              selector-list-comma-newline-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              selector-list-comma-space-after =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              selector-list-comma-space-before =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/shorthandProperty!predicate" =
        _js2n__-prdslib.records.record
            {
              shorthand-property-no-redundant-values =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/simpleArrayStringRule!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.isType '"String"),
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/simpleArrayStringRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/simpleStringOrArrayStringRule!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Array"
                  ],
                _js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate"
                  ]
              ]),
      "_js2n__-:definitions/simpleStringOrArrayStringRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate"
                ]
            ],
      "_js2n__-:definitions/singleDoubleRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "single", "double", [  ] ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "single", "double", {} ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/spaceRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "always",
                          "never",
                          "always-single-line",
                          "never-single-line",
                          [  ]
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "always",
                                        "never",
                                        "always-single-line",
                                        "never-single-line",
                                        {}
                                      ]
                                  ],
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/string!predicate" =
        _js2n__-prdslib.records.record
            {
              string-no-newline =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
              string-quotes =
                _js2n__-refsenv."_js2n__-:definitions/singleDoubleRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/stringRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Null,
                      _js2n__-prdslib.isType '"String"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.maxItems 2,
                      _js2n__-prdslib.arrays.minItems 2,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/stylelintDisableComment!predicate" =
        _js2n__-prdslib.records.record
            {
              stylelint-disable-reason =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "always-before", "always-after", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "always-before",
                                                "always-after",
                                                {}
                                              ]
                                          ],
                                        _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/time!predicate" =
        _js2n__-prdslib.records.record
            {
              time-no-imperceptible =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/unit!predicate" =
        _js2n__-prdslib.records.record
            {
              unit-blacklist =
                _js2n__-refsenv."_js2n__-:definitions/unitRule!predicate",
              unit-case =
                _js2n__-refsenv."_js2n__-:definitions/lowerUpperRule!predicate",
              unit-no-unknown =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.enum [ true, [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.enum [ true, {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreUnits =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              unit-whitelist =
                _js2n__-refsenv."_js2n__-:definitions/unitRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/unitRule!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Array"
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "em",
                          "ex",
                          "px",
                          "%",
                          "rem",
                          "vw",
                          "vh",
                          "vm",
                          "vmin",
                          "vmax",
                          "ch",
                          "in",
                          "cm",
                          "mm",
                          "q",
                          "pt",
                          "pc",
                          "deg",
                          "grad",
                          "rad",
                          "turn",
                          "ms",
                          "s",
                          "Hz",
                          "kHz",
                          "dpi",
                          "dpcm",
                          "dppx",
                          "fr",
                          [  ]
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType 'Record
                              ],
                            _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "em",
                                        "ex",
                                        "px",
                                        "%",
                                        "rem",
                                        "vw",
                                        "vh",
                                        "vm",
                                        "vmin",
                                        "vmax",
                                        "ch",
                                        "in",
                                        "cm",
                                        "mm",
                                        "q",
                                        "pt",
                                        "pc",
                                        "deg",
                                        "grad",
                                        "rad",
                                        "turn",
                                        "ms",
                                        "s",
                                        "Hz",
                                        "kHz",
                                        "dpi",
                                        "dpcm",
                                        "dppx",
                                        "fr",
                                        [  ],
                                        {}
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "em",
                                              "ex",
                                              "px",
                                              "%",
                                              "rem",
                                              "vw",
                                              "vh",
                                              "vm",
                                              "vmin",
                                              "vmax",
                                              "ch",
                                              "in",
                                              "cm",
                                              "mm",
                                              "q",
                                              "pt",
                                              "pc",
                                              "deg",
                                              "grad",
                                              "rad",
                                              "turn",
                                              "ms",
                                              "s",
                                              "Hz",
                                              "kHz",
                                              "dpi",
                                              "dpcm",
                                              "dppx",
                                              "fr"
                                            ]
                                        ]),
                                    _js2n__-prdslib.arrays.minItems 1,
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                    _js2n__-prdslib.records.record
                                      {
                                        ignoreProperties =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {}
                                                  {
                                                    "(em|ex|ch|vw|vh|cm|mm|in|pt|pc|px|rem|vmin|vmax|%)" =
                                                      _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                                  } true _js2n__-prdslib.always
                                              ],
                                      } {} true _js2n__-prdslib.always
                                  ]
                              ]
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ]
            ],
      "_js2n__-:definitions/value!predicate" =
        _js2n__-prdslib.records.record
            {
              value-keyword-case =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "lower", "upper", [  ] ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType 'Record
                                      ],
                                    _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [ "lower", "upper", {} ]
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-refsenv."_js2n__-:definitions/coreRule!predicate",
                                            _js2n__-prdslib.records.record
                                              {
                                                ignoreKeywords =
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!predicate",
                                              } {} true _js2n__-prdslib.always
                                          ]
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 2,
                              _js2n__-prdslib.arrays.minItems 2,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ]
                    ],
              value-no-vendor-prefix =
                _js2n__-refsenv."_js2n__-:definitions/booleanRule!predicate",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/valueList!predicate" =
        _js2n__-prdslib.records.record
            {
              value-list-comma-newline-after =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              value-list-comma-newline-before =
                _js2n__-refsenv."_js2n__-:definitions/newlineRule!predicate",
              value-list-comma-space-after =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              value-list-comma-space-before =
                _js2n__-refsenv."_js2n__-:definitions/spaceRule!predicate",
              value-list-max-empty-lines =
                _js2n__-refsenv."_js2n__-:definitions/integerRule!predicate",
            } {} true _js2n__-prdslib.always,
    }
    in
  {
      customSyntax
        | String
        | doc "Specify a custom syntax to use on your code."
        | optional,
      defaultSeverity
        | std.enum.TagOrString
        | [| 'error, 'warning |]
        | doc "The default severity level for all rules that do not have a severity specified in their secondary options"
        | optional,
      extends
        | _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!contract"
        | doc "Your configuration can extend an existing configuration(s) (whether your own or a third-party config)"
        | optional,
      ignoreDisables
        | Bool
        | doc "Ignore stylelint-disable (e.g. /* stylelint-disable block-no-empty */) comments."
        | optional,
      ignoreFiles
        | _js2n__-refsenv."_js2n__-:definitions/simpleStringOrArrayStringRule!contract"
        | doc "Provide a glob or array of globs to ignore specific files"
        | optional,
      overrides
        | Array
          {
            customSyntax | String | optional,
            files | Array (String) | optional,
            rules
              | _js2n__-refsenv."_js2n__-:definitions/allRules!contract"
              | optional,
            ..
          }
        | doc "Provide rule and behavior overrides for files that match particular glob patterns."
        | optional,
      plugins
        | _js2n__-refsenv."_js2n__-:definitions/simpleArrayStringRule!contract"
        | doc "Plugins are rules or sets of rules built by the community that support methodologies, toolsets, non-standard CSS features, or very specific use cases"
        | optional,
      processors
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.items
                      [ _js2n__-prdslib.isType '"String" ],
                    _js2n__-prdslib.arrays.additionalItems
                      (_js2n__-prdslib.isType 'Record) 1
                  ]
              ])
        )
        | doc "Processors are functions that hook into stylelint's pipeline, modifying code on its way into stylelint and modifying results on their way out"
        | optional,
      reportDescriptionlessDisables
        | _js2n__-refsenv."_js2n__-:definitions/booleanRule!contract"
        | doc "Report stylelint-disable comments without a description."
        | optional,
      reportInvalidScopeDisables
        | _js2n__-refsenv."_js2n__-:definitions/booleanRule!contract"
        | doc "Report stylelint-disable comments that don't match rules that are specified in the configuration object."
        | optional,
      reportNeedlessDisables
        | _js2n__-refsenv."_js2n__-:definitions/booleanRule!contract"
        | doc "Report stylelint-disable comments that don't actually match any lints that need to be disabled"
        | optional,
      rules
        | _js2n__-refsenv."_js2n__-:definitions/allRules!contract"
        | optional,
      ..
    }