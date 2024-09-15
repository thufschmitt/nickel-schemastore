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
      "_js2n__-:definitions/addPrefixMiddleware!predicate"
        | doc "The AddPrefix middleware updates the URL Path of the request before forwarding it."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { prefix = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/basicAuthMiddleware!predicate"
        | doc "The BasicAuth middleware is a quick way to restrict access to your services to known users. If both users and usersFile are provided, the two are merged. The contents of usersFile have precedence over the values in users."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  headerField = _js2n__-prdslib.isType '"String",
                  realm = _js2n__-prdslib.isType '"String",
                  removeHeader = _js2n__-prdslib.isType '"Bool",
                  users =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  usersFile = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/bufferingMiddleware!predicate"
        | doc m%"
          The Buffering middleware gives you control on how you want to read the requests before sending them to services.
          
          With Buffering, Traefik reads the entire request into memory (possibly buffering large requests into disk), and rejects requests that are over a specified limit.
          
          This can help services deal with large data (multipart/form-data for example), and can minimize time spent sending data to a service.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  maxRequestBodyBytes = _js2n__-prdslib.isType 'Integer,
                  maxResponseBodyBytes = _js2n__-prdslib.isType 'Integer,
                  memRequestBodyBytes = _js2n__-prdslib.isType 'Integer,
                  memResponseBodyBytes = _js2n__-prdslib.isType 'Integer,
                  retryExpression = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/chainMiddleware!predicate"
        | doc "The Chain middleware enables you to define reusable combinations of other pieces of middleware. It makes reusing the same groups easier."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  middlewares =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/circuitBreakerMiddleware!predicate"
        | doc m%"
          The circuit breaker protects your system from stacking requests to unhealthy services (resulting in cascading failures).
          
          When your system is healthy, the circuit is closed (normal operations). When your system becomes unhealthy, the circuit becomes open and the requests are no longer forwarded (but handled by a fallback mechanism).
          
          To assess if your system is healthy, the circuit breaker constantly monitors the services.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  checkPeriod = _js2n__-prdslib.isType '"String",
                  expression = _js2n__-prdslib.isType '"String",
                  fallbackDuration = _js2n__-prdslib.isType '"String",
                  recoveryDuration = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/compressMiddleware!predicate"
        | doc "The Compress middleware enables the gzip compression."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludedContentTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  minResponseBodyBytes = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/contentTypeMiddleware!predicate"
        | doc m%"
          The Content-Type middleware - or rather its unique autoDetect option - specifies whether to let the Content-Type header, if it has not been set by the backend, be automatically set to a value derived from the contents of the response.
          
          As a proxy, the default behavior should be to leave the header alone, regardless of what the backend did with it. However, the historic default was to always auto-detect and set the header if it was nil, and it is going to be kept that way in order to support users currently relying on it. This middleware exists to enable the correct behavior until at least the default one can be changed in a future version.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { autoDetect = _js2n__-prdslib.isType '"Bool", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/digestAuthMiddleware!predicate"
        | doc "The DigestAuth middleware is a quick way to restrict access to your services to known users. If both users and usersFile are provided, the two are merged. The contents of usersFile have precedence over the values in users."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  headerField = _js2n__-prdslib.isType '"String",
                  realm = _js2n__-prdslib.isType '"String",
                  removeHeader = _js2n__-prdslib.isType '"Bool",
                  users =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  usersFile = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/errorsMiddleware!predicate"
        | doc "The ErrorPage middleware returns a custom page in lieu of the default, according to configured ranges of HTTP Status codes. The error page itself is not hosted by Traefik."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  query = _js2n__-prdslib.isType '"String",
                  service = _js2n__-prdslib.isType '"String",
                  status =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/forwardAuthMiddleware!predicate"
        | doc "The ForwardAuth middleware delegate the authentication to an external service. If the service response code is 2XX, access is granted and the original request is performed. Otherwise, the response from the authentication server is returned."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  address = _js2n__-prdslib.isType '"String",
                  authRequestHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  authResponseHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  authResponseHeadersRegex = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ca = _js2n__-prdslib.isType '"String",
                              caOptional = _js2n__-prdslib.isType '"Bool",
                              cert = _js2n__-prdslib.isType '"String",
                              insecureSkipVerify =
                                _js2n__-prdslib.isType '"Bool",
                              key = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always,
                          _js2n__-prdslib.records.dependencies
                            { caOptional = [ "ca" ], }
                        ],
                  trustForwardHeader = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/headersMiddleware!predicate"
        | doc "The Headers middleware can manage the requests/responses headers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accessControlAllowCredentials =
                    _js2n__-prdslib.isType '"Bool",
                  accessControlAllowHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  accessControlAllowMethods =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  accessControlAllowOriginList =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  accessControlAllowOriginListRegex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  accessControlExposeHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  accessControlMaxAge = _js2n__-prdslib.isType 'Integer,
                  addVaryHeader = _js2n__-prdslib.isType '"Bool",
                  allowedHosts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  browserXssFilter = _js2n__-prdslib.isType '"Bool",
                  contentSecurityPolicy = _js2n__-prdslib.isType '"String",
                  contentTypeNosniff = _js2n__-prdslib.isType '"Bool",
                  customBrowserXSSValue = _js2n__-prdslib.isType '"String",
                  customFrameOptionsValue = _js2n__-prdslib.isType '"String",
                  customRequestHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  customResponseHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  featurePolicy = _js2n__-prdslib.isType '"String",
                  forceSTSHeader = _js2n__-prdslib.isType '"Bool",
                  frameDeny = _js2n__-prdslib.isType '"Bool",
                  hostsProxyHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  isDevelopment = _js2n__-prdslib.isType '"Bool",
                  permissionsPolicy = _js2n__-prdslib.isType '"String",
                  publicKey = _js2n__-prdslib.isType '"String",
                  referrerPolicy = _js2n__-prdslib.isType '"String",
                  sslForceHost = _js2n__-prdslib.isType '"Bool",
                  sslHost = _js2n__-prdslib.isType '"String",
                  sslProxyHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  sslRedirect = _js2n__-prdslib.isType '"Bool",
                  sslTemporaryRedirect = _js2n__-prdslib.isType '"Bool",
                  stsIncludeSubdomains = _js2n__-prdslib.isType '"Bool",
                  stsPreload = _js2n__-prdslib.isType '"Bool",
                  stsSeconds = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/httpFailoverService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fallback = _js2n__-prdslib.isType '"String",
                  healthCheck = _js2n__-prdslib.isType 'Record,
                  service = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/httpLoadBalancerService!predicate"
        | doc m%"
          The load balancers are able to load balance the requests between multiple instances of your programs.
          
          Each service has a load-balancer, even if there is only one server to forward traffic to.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "servers" ],
              _js2n__-prdslib.records.record
                {
                  healthCheck =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              followRedirects = _js2n__-prdslib.isType '"Bool",
                              headers =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              hostname = _js2n__-prdslib.isType '"String",
                              interval = _js2n__-prdslib.isType '"String",
                              method = _js2n__-prdslib.isType '"String",
                              path = _js2n__-prdslib.isType '"String",
                              port = _js2n__-prdslib.isType 'Integer,
                              scheme = _js2n__-prdslib.isType '"String",
                              timeout = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  passHostHeader = _js2n__-prdslib.isType '"Bool",
                  responseForwarding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              flushInterval = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "url" ],
                                _js2n__-prdslib.records.record
                                  { url = _js2n__-prdslib.isType '"String", } {}
                                  true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  serversTransport = _js2n__-prdslib.isType '"String",
                  sticky =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cookie =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          httpOnly =
                                            _js2n__-prdslib.isType '"Bool",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          sameSite =
                                            _js2n__-prdslib.isType '"String",
                                          secure =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/httpMiddleware!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.records.record
                    {
                      addPrefix =
                        _js2n__-refsenv."_js2n__-:definitions/addPrefixMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      basicAuth =
                        _js2n__-refsenv."_js2n__-:definitions/basicAuthMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      buffering =
                        _js2n__-refsenv."_js2n__-:definitions/bufferingMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      chain =
                        _js2n__-refsenv."_js2n__-:definitions/chainMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      circuitBreaker =
                        _js2n__-refsenv."_js2n__-:definitions/circuitBreakerMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      compress =
                        _js2n__-refsenv."_js2n__-:definitions/compressMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      contentType =
                        _js2n__-refsenv."_js2n__-:definitions/contentTypeMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      digestAuth =
                        _js2n__-refsenv."_js2n__-:definitions/digestAuthMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      errors =
                        _js2n__-refsenv."_js2n__-:definitions/errorsMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      forwardAuth =
                        _js2n__-refsenv."_js2n__-:definitions/forwardAuthMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      headers =
                        _js2n__-refsenv."_js2n__-:definitions/headersMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      ipWhiteList =
                        _js2n__-refsenv."_js2n__-:definitions/ipWhiteListMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      ipAllowList =
                        _js2n__-refsenv."_js2n__-:definitions/ipAllowListMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      inFlightReq =
                        _js2n__-refsenv."_js2n__-:definitions/inFlightReqMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      passTLSClientCert =
                        _js2n__-refsenv."_js2n__-:definitions/passTLSClientCertMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      plugin =
                        _js2n__-refsenv."_js2n__-:definitions/pluginMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      rateLimit =
                        _js2n__-refsenv."_js2n__-:definitions/rateLimitMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      redirectRegex =
                        _js2n__-refsenv."_js2n__-:definitions/redirectRegexMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      redirectScheme =
                        _js2n__-refsenv."_js2n__-:definitions/redirectSchemeMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      replacePath =
                        _js2n__-refsenv."_js2n__-:definitions/replacePathMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      replacePathRegex =
                        _js2n__-refsenv."_js2n__-:definitions/replacePathRegexMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      retry =
                        _js2n__-refsenv."_js2n__-:definitions/retryMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      stripPrefix =
                        _js2n__-refsenv."_js2n__-:definitions/stripPrefixMiddleware!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      stripPrefixRegex =
                        _js2n__-refsenv."_js2n__-:definitions/stripPrefixRegexMiddleware!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/httpMirroringService!predicate"
        | doc "The mirroring is able to mirror requests sent to a service to other services. Please note that by default the whole request is buffered in memory while it is being mirrored. See the maxBodySize option for how to modify this behaviour."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  healthCheck = _js2n__-prdslib.isType 'Record,
                  maxBodySize = _js2n__-prdslib.isType 'Integer,
                  mirrors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    name = _js2n__-prdslib.isType '"String",
                                    percent =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.numbers.maximum 100,
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  service = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/httpRouter!predicate"
        | doc "A router is in charge of connecting incoming requests to the services that can handle them. In the process, routers may use pieces of middleware to update the request, or act before forwarding the request to the service."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "rule", "service" ],
              _js2n__-prdslib.records.record
                {
                  entryPoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  middlewares =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "priority" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  rule = _js2n__-prdslib.isType '"String",
                  service = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              certResolver = _js2n__-prdslib.isType '"String",
                              domains =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                main =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sans =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                              options = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/httpService!predicate"
        | doc "The Services are responsible for configuring how to reach the actual services that will eventually handle the incoming requests."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.records.record
                    {
                      loadBalancer =
                        _js2n__-refsenv."_js2n__-:definitions/httpLoadBalancerService!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      weighted =
                        _js2n__-refsenv."_js2n__-:definitions/httpWeightedService!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      mirroring =
                        _js2n__-refsenv."_js2n__-:definitions/httpMirroringService!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      failover =
                        _js2n__-refsenv."_js2n__-:definitions/httpFailoverService!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/httpWeightedService!predicate"
        | doc m%"
          The WRR is able to load balance the requests between multiple services based on weights.
          
          This strategy is only available to load balance between services and not between servers.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  healthCheck = _js2n__-prdslib.isType 'Record,
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    name = _js2n__-prdslib.isType '"String",
                                    weight = _js2n__-prdslib.isType '"Number",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  sticky =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              cookie =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          httpOnly =
                                            _js2n__-prdslib.isType '"Bool",
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          sameSite =
                                            _js2n__-prdslib.isType '"String",
                                          secure =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/inFlightReqMiddleware!predicate"
        | doc "To proactively prevent services from being overwhelmed with high load, a limit on the number of simultaneous in-flight requests can be applied."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  amount = _js2n__-prdslib.isType 'Integer,
                  sourceCriterion =
                    _js2n__-refsenv."_js2n__-:definitions/sourceCriterion!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ipAllowListMiddleware!predicate"
        | doc "IPAllowList accepts / refuses requests based on the client IP."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ipStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/ipStrategy!predicate",
                  sourceRange =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ipStrategy!predicate"
        | doc "The ipStrategy option defines parameters that set how Traefik will determine the client IP."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  depth = _js2n__-prdslib.isType 'Integer,
                  excludedIPs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ipWhiteListMiddleware!predicate"
        | doc "DEPRECATED: IPWhitelist accepts / refuses requests based on the client IP."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ipStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/ipStrategy!predicate",
                  sourceRange =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/passTLSClientCertMiddleware!predicate"
        | doc "PassTLSClientCert adds in header the selected data from the passed client tls certificate."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  info =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              issuer =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          commonName =
                                            _js2n__-prdslib.isType '"Bool",
                                          country =
                                            _js2n__-prdslib.isType '"Bool",
                                          domainComponent =
                                            _js2n__-prdslib.isType '"Bool",
                                          locality =
                                            _js2n__-prdslib.isType '"Bool",
                                          organization =
                                            _js2n__-prdslib.isType '"Bool",
                                          province =
                                            _js2n__-prdslib.isType '"Bool",
                                          serialNumber =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              notAfter = _js2n__-prdslib.isType '"Bool",
                              notBefore = _js2n__-prdslib.isType '"Bool",
                              sans = _js2n__-prdslib.isType '"Bool",
                              subject =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          commonName =
                                            _js2n__-prdslib.isType '"Bool",
                                          country =
                                            _js2n__-prdslib.isType '"Bool",
                                          domainComponent =
                                            _js2n__-prdslib.isType '"Bool",
                                          locality =
                                            _js2n__-prdslib.isType '"Bool",
                                          organization =
                                            _js2n__-prdslib.isType '"Bool",
                                          province =
                                            _js2n__-prdslib.isType '"Bool",
                                          serialNumber =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  pem = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pluginMiddleware!predicate"
        | doc "Some plugins will need to be configured by adding a dynamic configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType 'Record)
            ],
      "_js2n__-:definitions/rateLimitMiddleware!predicate"
        | doc "The RateLimit middleware ensures that services will receive a fair number of requests, and allows one to define what fair is."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  average =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  burst = _js2n__-prdslib.isType '"Number",
                  period =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  sourceCriterion =
                    _js2n__-refsenv."_js2n__-:definitions/sourceCriterion!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/redirectRegexMiddleware!predicate"
        | doc "RegexRedirect redirect a request from an url to another with regex matching and replacement."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  permanent = _js2n__-prdslib.isType '"Bool",
                  regex = _js2n__-prdslib.isType '"String",
                  replacement = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/redirectSchemeMiddleware!predicate"
        | doc "RedirectScheme redirect request from a scheme to another."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  permanent = _js2n__-prdslib.isType '"Bool",
                  port = _js2n__-prdslib.isType '"String",
                  scheme = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/replacePathMiddleware!predicate"
        | doc "Replace the path of the request url. It will replace the actual path by the specified one and will store the original path in a X-Replaced-Path header."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/replacePathRegexMiddleware!predicate"
        | doc "The ReplaceRegex replace a path from an url to another with regex matching and replacement. It will replace the actual path by the specified one and store the original path in a X-Replaced-Path header."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  regex = _js2n__-prdslib.isType '"String",
                  replacement = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/retryMiddleware!predicate"
        | doc "The Retry middleware is in charge of reissuing a request a given number of times to a backend server if that server does not reply. To be clear, as soon as the server answers, the middleware stops retrying, regardless of the response status."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "attempts" ],
              _js2n__-prdslib.records.record
                {
                  attempts = _js2n__-prdslib.isType 'Integer,
                  initialInterval = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sourceCriterion!predicate"
        | doc "SourceCriterion defines what criterion is used to group requests as originating from a common source. The precedence order is ipStrategy, then requestHeaderName, then requestHost. If none are set, the default is to use the requestHost."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ipStrategy =
                    _js2n__-refsenv."_js2n__-:definitions/ipStrategy!predicate",
                  requestHeaderName = _js2n__-prdslib.isType '"String",
                  requestHost = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stripPrefixMiddleware!predicate"
        | doc "Remove the specified prefixes from the URL path. It will strip the matching path prefix and will store the matching path prefix in a X-Forwarded-Prefix header."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  forceSlash = _js2n__-prdslib.isType '"Bool",
                  prefixes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stripPrefixRegexMiddleware!predicate"
        | doc "Remove the matching prefixes from the URL path. It will strip the matching path prefix and will store the matching path prefix in a X-Forwarded-Prefix header."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  regex =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tcpLoadBalancerService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "servers" ],
              _js2n__-prdslib.records.record
                {
                  proxyProtocol =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { version = _js2n__-prdslib.isType 'Integer, } {}
                            true _js2n__-prdslib.always
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "address" ],
                                _js2n__-prdslib.records.record
                                  {
                                    address = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  terminationDelay = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tcpRouter!predicate"
        | doc "If both HTTP routers and TCP routers listen to the same entry points, the TCP routers will apply before the HTTP routers. If no matching route is found for the TCP routers, then the HTTP routers will take over."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "rule", "service" ],
              _js2n__-prdslib.records.record
                {
                  entryPoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  middlewares =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "priority" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  rule = _js2n__-prdslib.isType '"String",
                  service = _js2n__-prdslib.isType '"String",
                  tls =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              certResolver = _js2n__-prdslib.isType '"String",
                              domains =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                main =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sans =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                              options = _js2n__-prdslib.isType '"String",
                              passthrough = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tcpService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.records.record
                    {
                      loadBalancer =
                        _js2n__-refsenv."_js2n__-:definitions/tcpLoadBalancerService!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      weighted =
                        _js2n__-refsenv."_js2n__-:definitions/tcpWeightedService!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/tcpWeightedService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "services" ],
              _js2n__-prdslib.records.record
                {
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "name", "weight" ],
                                _js2n__-prdslib.records.record
                                  {
                                    name = _js2n__-prdslib.isType '"String",
                                    weight = _js2n__-prdslib.isType '"Number",
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/udpLoadBalancerService!predicate"
        | doc "The servers load balancer is in charge of balancing the requests between the servers of the same service."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "servers" ],
              _js2n__-prdslib.records.record
                {
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "address" ],
                                _js2n__-prdslib.records.record
                                  {
                                    address = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/udpRouter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "service" ],
              _js2n__-prdslib.records.record
                {
                  entryPoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  service = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/udpService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.records.record
                    {
                      loadBalancer =
                        _js2n__-refsenv."_js2n__-:definitions/udpLoadBalancerService!predicate",
                    } {} false _js2n__-prdslib.never,
                  _js2n__-prdslib.records.record
                    {
                      weighted =
                        _js2n__-refsenv."_js2n__-:definitions/udpWeightedService!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/udpWeightedService!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "services" ],
              _js2n__-prdslib.records.record
                {
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "name", "weight" ],
                                _js2n__-prdslib.records.record
                                  {
                                    name = _js2n__-prdslib.isType '"String",
                                    weight = _js2n__-prdslib.isType '"Number",
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      http
        | {
          middlewares
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/httpMiddleware!predicate"
                ])
            | doc m%"
              Attached to the routers, pieces of middleware are a means of tweaking the requests before they are sent to your service (or before the answer from the services are sent to the clients).
              
              There are several available middleware in Traefik, some can modify the request, the headers, some are in charge of redirections, some add authentication, and so on.
              
              Pieces of middleware can be combined in chains to fit every scenario.
            "%
            | optional,
          routers
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/httpRouter!predicate"
                ])
            | optional,
          services
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/httpService!predicate"
                ])
            | optional,
          ..
        }
        | optional,
      tcp
        | {
          routers
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/tcpRouter!predicate"
                ])
            | optional,
          services
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/tcpService!predicate"
                ])
            | doc "Each of the fields of the service section represents a kind of service. Which means, that for each specified service, one of the fields, and only one, has to be enabled to define what kind of service is created. Currently, the two available kinds are LoadBalancer, and Weighted."
            | optional,
          ..
        }
        | optional,
      tls
        | {
          certificates
            | Array
              {
                certFile | String | optional,
                keyFile | String | optional,
                stores
                  | Array (String)
                  | doc "A list of stores can be specified here to indicate where the certificates should be stored. Although the stores list will actually be ignored and automatically set to [\"default\"]."
                  | optional,
                ..
              }
            | optional,
          options
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "[a-zA-Z0-9-_]+" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  cipherSuites =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  clientAuth =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              caFiles =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              clientAuthType =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                  curvePreferences =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  maxVersion = _js2n__-prdslib.isType '"String",
                                  minVersion = _js2n__-prdslib.isType '"String",
                                  preferServerCipherSuites =
                                    _js2n__-prdslib.isType '"Bool",
                                  sniStrict = _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ],
                    } false _js2n__-prdslib.never
                ])
            | doc "The TLS options allow one to configure some parameters of the TLS connection."
            | optional,
          stores
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "[a-zA-Z0-9-_]+" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  defaultCertificate =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              certFile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              keyFile =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                  defaultGeneratedCert =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              domain =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          main =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          sans =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                    (_js2n__-prdslib.isType
                                                                      '"String")
                                                                ],
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                              resolver =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "Any store definition other than the default one (named default) will be ignored, and there is therefore only one globally available TLS store."
            | optional,
        }
        | doc "Configures the TLS connection, TLS options, and certificate stores."
        | optional,
      udp
        | {
          routers
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/udpRouter!predicate"
                ])
            | doc "Similarly to TCP, as UDP is the transport layer, there is no concept of a request, so there is no notion of an URL path prefix to match an incoming UDP packet with. Furthermore, as there is no good TLS support at the moment for multiple hosts, there is no Host SNI notion to match against either. Therefore, there is no criterion that could be used as a rule to match incoming packets in order to route them. So UDP \"routers\" at this time are pretty much only load-balancers in one form or another."
            | optional,
          services
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-refsenv."_js2n__-:definitions/udpService!predicate"
                ])
            | doc "Each of the fields of the service section represents a kind of service. Which means, that for each specified service, one of the fields, and only one, has to be enabled to define what kind of service is created. Currently, the two available kinds are LoadBalancer, and Weighted."
            | optional,
        }
        | optional,
    }