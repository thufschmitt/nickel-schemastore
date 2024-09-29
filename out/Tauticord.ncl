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
      "_js2n__-:definitions/combinedLibrary!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.required
                  [
                    "Albums",
                    "Artists",
                    "Episodes",
                    "Libraries",
                    "Movies",
                    "Name",
                    "Series",
                    "Tracks"
                  ],
                _js2n__-prdslib.records.record
                  {
                    Albums =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Artists =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Episodes =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Libraries =
                      _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"Array",
                            _js2n__-prdslib.arrays.arrayOf
                              _js2n__-refsenv."_js2n__-:definitions/combinedLibrarySubLibrary!predicate"
                          ],
                    Movies =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Name =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/discordVoiceChannelName!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/emptyString!predicate"
                          ],
                    Series =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Tracks =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                  } {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/combinedLibrarySubLibrary!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "Name" ],
              _js2n__-prdslib.records.record
                {
                  ID =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/numberZero!predicate"
                        ],
                  Name = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/discordBotToken!contract"
        | doc "A Discord Bot Token"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^[MNO][a-zA-Z\\d_-]{23,25}\\.[a-zA-Z\\d_-]{6}\\.[a-zA-Z\\d_-]{27,}$"
              ]),
      "_js2n__-:definitions/discordCategoryName!contract"
        | doc "A Discord category name. No emojis allowed."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9-_ ]{2,100}$"
              ]),
      "_js2n__-:definitions/discordChannelId!predicate"
        | doc "A Discord channel ID"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[0-9]{17,20}$"
            ],
      "_js2n__-:definitions/discordServerId!contract"
        | doc "A Discord server ID"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[0-9]{17,20}$"
              ]),
      "_js2n__-:definitions/discordTextChannelName!contract"
        | doc "A Discord text channel name. No emojis allowed."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[a-z0-9-]{2,100}$"
              ]),
      "_js2n__-:definitions/discordUserId!contract"
        | doc "A Discord user ID"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[0-9]{17,20}$"
              ]),
      "_js2n__-:definitions/discordVoiceChannelName!predicate"
        | doc "A Discord voice channel name. No emojis allowed."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9-_ ]{2,100}$"
            ],
      "_js2n__-:definitions/emptyString!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^$"
            ],
      "_js2n__-:definitions/hostWithIpAndOptionalPort!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(https?://)?[a-zA-Z0-9.-]+(:[0-9]{1,5})?$"
            ],
      "_js2n__-:definitions/library!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.required
                  [
                    "Albums",
                    "AlternateName",
                    "Artists",
                    "Episodes",
                    "Movies",
                    "Name",
                    "Series",
                    "Tracks"
                  ],
                _js2n__-prdslib.records.record
                  {
                    Albums =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    AlternateName =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/discordVoiceChannelName!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/emptyString!predicate"
                          ],
                    Artists =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Episodes =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    ID =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/positiveInteger!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/numberZero!predicate"
                          ],
                    Movies =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Name = _js2n__-prdslib.isType '"String",
                    Series =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                    Tracks =
                      _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate",
                  } {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/numberZero!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 0,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/positiveInteger!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 1
            ],
      "_js2n__-:definitions/tautulliApiKey!contract"
        | doc "A Tautulli API key"
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9]{32}$"
              ]),
      "_js2n__-:definitions/tautulliUrl!contract"
        | doc "A Tautulli URL"
        = _js2n__-prdslib.contract_from_predicate
            _js2n__-refsenv."_js2n__-:definitions/hostWithIpAndOptionalPort!predicate",
      "_js2n__-:definitions/voiceChannel!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.required
                  [ "CustomEmoji", "Enable", "VoiceChannelID" ],
                _js2n__-prdslib.records.record
                  {
                    CustomEmoji = _js2n__-prdslib.isType '"String",
                    CustomName =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/discordVoiceChannelName!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/emptyString!predicate"
                          ],
                    Enable = _js2n__-prdslib.isType '"Bool",
                    VoiceChannelID =
                      _js2n__-prdslib.oneOf
                          [
                            _js2n__-refsenv."_js2n__-:definitions/discordChannelId!predicate",
                            _js2n__-refsenv."_js2n__-:definitions/numberZero!predicate"
                          ],
                  } {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/voiceChannel!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "CustomEmoji", "Enable", "VoiceChannelID" ],
              _js2n__-prdslib.records.record
                {
                  CustomEmoji = _js2n__-prdslib.isType '"String",
                  CustomName =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/discordVoiceChannelName!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/emptyString!predicate"
                        ],
                  Enable = _js2n__-prdslib.isType '"Bool",
                  VoiceChannelID =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/discordChannelId!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/numberZero!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  {
      Discord
        | {
          AdminIDs
            | Array
              _js2n__-refsenv."_js2n__-:definitions/discordUserId!contract"
            | doc "The IDs of the Discord users who will have admin permissions",
          BotToken
            | _js2n__-refsenv."_js2n__-:definitions/discordBotToken!contract"
            | doc "The token for the Discord bot",
          ChannelName
            | _js2n__-refsenv."_js2n__-:definitions/discordTextChannelName!contract"
            | doc "The name of the channel where the bot will post messages",
          EnableSlashCommands
            | Bool
            | doc "Whether to enable slash commands for the bot",
          EnableTermination
            | Bool
            | doc "Whether to enable stream termination"
            | optional,
          PostSummaryMessage
            | Bool
            | doc "Whether to post a summary message in the activity summary channel",
          ServerID
            | _js2n__-refsenv."_js2n__-:definitions/discordServerId!contract"
            | doc "The ID of the Discord server where the bot will be used",
          StatusMessage
            | {
              CustomMessage
                | String
                | doc "Display a custom activity status message. Overrides default if not-empty"
                | optional,
              Enable
                | Bool
                | doc "Whether to enable the bot's activity status"
                | optional,
              ShowStreamCount
                | Bool
                | doc "Whether to display current active stream count in activity status message"
                | optional,
              ..
            }
            | doc "Settings regarding the bot's Discord status/activity"
            | optional,
          ..
        }
        | doc "Settings for the Discord bot and server",
      Display
        | {
          Anonymize
            | {
              HideBandwidth
                | Bool
                | doc "Whether to hide bandwidth information",
              HideETA | Bool | doc "Whether to hide ETAs for streams",
              HidePlatforms
                | Bool
                | doc "Whether to hide stream platform information",
              HidePlayerNames
                | Bool
                | doc "Whether to hide stream player names",
              HideProgress | Bool | doc "Whether to hide stream progress",
              HideQuality
                | Bool
                | doc "Whether to hide stream quality information",
              HideTranscode
                | Bool
                | doc "Whether to hide stream transcoding information",
              HideUsernames | Bool | doc "Whether to hide Plex usernames",
              ..
            }
            | doc "Settings for anonymizing user information",
          ServerName | String | doc "The name of the Plex server",
          ThousandsSeparator
            | String
            | doc "The character to use as a numerical thousands separator",
          Time
            | {
              ServerTimeZone | String | doc "The time zone of the Plex server",
              Use24HourTime
                | Bool
                | doc "Whether to use 24-hour (military) time",
              ..
            }
            | doc "Settings for how the bot handles time",
          UseFriendlyNames
            | Bool
            | doc "Whether to use Plex user names instead of Plex usernames",
          ..
        }
        | doc "Settings for how the bot displays information",
      Extras
        | {
          AllowAnalytics
            | Bool
            | doc "Whether to allow the bot to collect and send analytics data",
          EnableUpdateReminders
            | Bool
            | doc "Whether to enable update reminders",
          ..
        }
        | doc "Extra settings for the bot",
      Stats
        | {
          Activity
            | {
              CategoryName
                | _js2n__-refsenv."_js2n__-:definitions/discordCategoryName!contract"
                | doc "The name of the category for activity stats",
              Enable | Bool | doc "Whether to enable activity stats",
              StatTypes
                | {
                  Bandwidth
                    | _js2n__-refsenv."_js2n__-:definitions/voiceChannel!contract"
                    | doc "Settings for bandwidth stats",
                  LocalBandwidth
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for local bandwidth stats",
                  PlexServerAvailability
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for Plex server availability stats",
                  RemoteBandwidth
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for remote bandwidth stats",
                  StreamCount
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for stream count stats",
                  TranscodeCount
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for transcode count stats",
                  ..
                }
                | doc "The types of activity stats to track",
              ..
            },
          Libraries
            | {
              CategoryName
                | _js2n__-refsenv."_js2n__-:definitions/discordCategoryName!contract"
                | doc "The name of the category for library stats",
              CombinedLibraries
                | Array
                  _js2n__-refsenv."_js2n__-:definitions/combinedLibrary!contract"
                | doc "Combined libraries to track",
              Enable | Bool | doc "Whether to enable library stats",
              Libraries
                | Array _js2n__-refsenv."_js2n__-:definitions/library!contract"
                | doc "Libraries to track",
              RefreshSeconds
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.multipleOf 5,
                      _js2n__-prdslib.numbers.minimum 300
                    ])
                | doc "How often, in seconds, the bot pulls new library data. A 5-minute minimum is built-in; it's for your own good",
              ..
            }
            | doc "Settings for Plex library stats",
          Performance
            | {
              CategoryName
                | _js2n__-refsenv."_js2n__-:definitions/discordCategoryName!contract"
                | doc "The name of the category for performance stats",
              Enable | Bool | doc "Whether to enable performance stats",
              Metrics
                | {
                  CPU
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for CPU stats",
                  DiskSpace
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for disk space stats",
                  Memory
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for memory stats",
                  UserCount
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/voiceChannel!predicate"
                        ])
                    | doc "Settings for user count stats",
                  ..
                }
                | doc "The performance metrics to track",
              ..
            }
            | doc "Settings for performance stats",
          ..
        }
        | doc "Settings for the bot's stat tracking features (via voice channels)",
      Tautulli
        | {
          APIKey
            | _js2n__-refsenv."_js2n__-:definitions/tautulliApiKey!contract"
            | doc "The API key for the Tautulli instance",
          RefreshSeconds
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.multipleOf 5,
                  _js2n__-prdslib.numbers.minimum 5
                ])
            | doc "How often, in seconds, the bot pulls new live activity data. A 5-second minimum is built-in; it's for your own good",
          TerminateMessage
            | String
            | doc "The message to send when a stream is terminated",
          URL
            | _js2n__-refsenv."_js2n__-:definitions/tautulliUrl!contract"
            | doc "The URL of the Tautulli instance",
          UseSelfSignedCert
            | Bool
            | doc "Whether to use a self-signed certificate for the Tautulli instance (ignore SSL warnings)",
          ..
        }
        | doc "Settings for the Tautulli instance",
      ..
    }