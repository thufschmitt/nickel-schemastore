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
    = {}
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              accessLog =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          addInternals = _js2n__-prdslib.isType '"Bool",
                          bufferingSize = _js2n__-prdslib.isType 'Integer,
                          fields =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      defaultMode =
                                        _js2n__-prdslib.isType '"String",
                                      headers =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  defaultMode =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  names =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {}
                                                            {
                                                              "[a-zA-Z0-9-_]+" =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      names =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {
                                                  "[a-zA-Z0-9-_]+" =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } true _js2n__-prdslib.always
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          filePath = _js2n__-prdslib.isType '"String",
                          filters =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      minDuration =
                                        _js2n__-prdslib.isType '"String",
                                      retryAttempts =
                                        _js2n__-prdslib.isType '"Bool",
                                      statusCodes =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                          format = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ],
              api =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          dashboard = _js2n__-prdslib.isType '"Bool",
                          debug = _js2n__-prdslib.isType '"Bool",
                          insecure = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              certificatesResolvers =
                _js2n__-prdslib.allOf
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
                                      acme =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  caServer =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  certificatesDuration =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                  dnsChallenge =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              delayBeforeCheck =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              disablePropagationCheck =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              provider =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              resolvers =
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
                                                  eab =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              hmacEncoded =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              kid =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  email =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  httpChallenge =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              entryPoint =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  keyType =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  preferredChain =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  storage =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  tlsChallenge =
                                                    _js2n__-prdslib.isType
                                                        'Record,
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } true _js2n__-prdslib.always
                    ],
              entryPoints =
                _js2n__-prdslib.allOf
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
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                      forwardedHeaders =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  insecure =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  trustedIPs =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      http =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  middlewares =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                  redirections =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              entryPoint =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          permanent =
                                                                            _js2n__-prdslib.isType
                                                                                '"Bool",
                                                                          "priority" =
                                                                            _js2n__-prdslib.isType
                                                                                'Integer,
                                                                          scheme =
                                                                            _js2n__-prdslib.isType
                                                                                '"String",
                                                                          to =
                                                                            _js2n__-prdslib.isType
                                                                                '"String",
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  tls =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              certResolver =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              domains =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"Array",
                                                                      _js2n__-prdslib.arrays.arrayOf
                                                                        (_js2n__-prdslib.allOf
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
                                                                              }
                                                                              {}
                                                                              true
                                                                              _js2n__-prdslib.always
                                                                          ])
                                                                    ],
                                                              options =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      http2 =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  maxConcurrentStreams =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      http3 =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  advertisedPort =
                                                    _js2n__-prdslib.isType
                                                        'Integer,
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      proxyProtocol =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  insecure =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  trustedIPs =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      transport =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  lifeCycle =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              graceTimeOut =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              requestAcceptGraceTimeout =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  respondingTimeouts =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              idleTimeout =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              readTimeout =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              writeTimeout =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      udp =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  timeout =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } true _js2n__-prdslib.always
                    ],
              experimental =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          http3 = _js2n__-prdslib.isType '"Bool",
                          hub = _js2n__-prdslib.isType '"Bool",
                          kubernetesGateway = _js2n__-prdslib.isType '"Bool",
                          localPlugins =
                            _js2n__-prdslib.allOf
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
                                                  moduleName =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } true _js2n__-prdslib.always
                                ],
                          plugins =
                            _js2n__-prdslib.allOf
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
                                                  moduleName =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  version =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } true _js2n__-prdslib.always
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              global =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          checkNewVersion = _js2n__-prdslib.isType '"Bool",
                          sendAnonymousUsage = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              hostResolver =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          cnameFlattening = _js2n__-prdslib.isType '"Bool",
                          resolvConfig = _js2n__-prdslib.isType '"String",
                          resolvDepth = _js2n__-prdslib.isType 'Integer,
                        } {} false _js2n__-prdslib.never
                    ],
              hub =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          tls =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      ca = _js2n__-prdslib.isType '"String",
                                      cert = _js2n__-prdslib.isType '"String",
                                      insecure = _js2n__-prdslib.isType '"Bool",
                                      key = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              log =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          compress = _js2n__-prdslib.isType '"Bool",
                          filePath = _js2n__-prdslib.isType '"String",
                          format = _js2n__-prdslib.isType '"String",
                          level = _js2n__-prdslib.isType '"String",
                          maxAge = _js2n__-prdslib.isType 'Integer,
                          maxBackups = _js2n__-prdslib.isType 'Integer,
                          maxSize = _js2n__-prdslib.isType 'Integer,
                          noColor = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              metrics =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          datadog =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      addEntryPointsLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addRoutersLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addServicesLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                      prefix = _js2n__-prdslib.isType '"String",
                                      pushInterval =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          influxDB =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      addEntryPointsLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addRoutersLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addServicesLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      additionalLabels =
                                        _js2n__-prdslib.isType 'Record,
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                      database =
                                        _js2n__-prdslib.isType '"String",
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      protocol =
                                        _js2n__-prdslib.isType '"String",
                                      pushInterval =
                                        _js2n__-prdslib.isType '"String",
                                      retentionPolicy =
                                        _js2n__-prdslib.isType '"String",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          influxDB2 =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      addEntryPointsLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addRoutersLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addServicesLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      additionalLabels =
                                        _js2n__-prdslib.isType 'Record,
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                      bucket = _js2n__-prdslib.isType '"String",
                                      org = _js2n__-prdslib.isType '"String",
                                      pushInterval =
                                        _js2n__-prdslib.isType '"String",
                                      token = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          prometheus =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      addEntryPointsLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addRoutersLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addServicesLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      buckets =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"Number")
                                            ],
                                      entryPoint =
                                        _js2n__-prdslib.isType '"String",
                                      manualRouting =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          statsD =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      addEntryPointsLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addRoutersLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      addServicesLabels =
                                        _js2n__-prdslib.isType '"Bool",
                                      address =
                                        _js2n__-prdslib.isType '"String",
                                      prefix = _js2n__-prdslib.isType '"String",
                                      pushInterval =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              pilot =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          dashboard = _js2n__-prdslib.isType '"Bool",
                          token = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ],
              ping =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          entryPoint = _js2n__-prdslib.isType '"String",
                          manualRouting = _js2n__-prdslib.isType '"Bool",
                          terminatingStatusCode =
                            _js2n__-prdslib.isType 'Integer,
                        } {} false _js2n__-prdslib.never
                    ],
              providers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          consul =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      endpoints =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      namespaces =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      rootKey =
                                        _js2n__-prdslib.isType '"String",
                                      tls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  ca =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  caOptional =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  cert =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  insecureSkipVerify =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      token = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          consulCatalog =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      cache = _js2n__-prdslib.isType '"Bool",
                                      connectAware =
                                        _js2n__-prdslib.isType '"Bool",
                                      connectByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      constraints =
                                        _js2n__-prdslib.isType '"String",
                                      defaultRule =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  address =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  datacenter =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  endpointWaitTime =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  httpAuth =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              password =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              username =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} false
                                                            _js2n__-prdslib.never
                                                        ],
                                                  scheme =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  tls =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              ca =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              caOptional =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              cert =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              insecureSkipVerify =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              key =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} false
                                                            _js2n__-prdslib.never
                                                        ],
                                                  token =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      exposedByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      namespaces =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      prefix = _js2n__-prdslib.isType '"String",
                                      refreshInterval =
                                        _js2n__-prdslib.isType '"String",
                                      requireConsistent =
                                        _js2n__-prdslib.isType '"Bool",
                                      serviceName =
                                        _js2n__-prdslib.isType '"String",
                                      stale = _js2n__-prdslib.isType '"Bool",
                                      watch = _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          docker =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowEmptyServices =
                                        _js2n__-prdslib.isType '"Bool",
                                      constraints =
                                        _js2n__-prdslib.isType '"String",
                                      defaultRule =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      exposedByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      httpClientTimeout =
                                        _js2n__-prdslib.isType 'Integer,
                                      network =
                                        _js2n__-prdslib.isType '"String",
                                      swarmMode =
                                        _js2n__-prdslib.isType '"Bool",
                                      swarmModeRefreshSeconds =
                                        _js2n__-prdslib.isType '"String",
                                      tls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  ca =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  caOptional =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  cert =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  insecureSkipVerify =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      useBindPortIP =
                                        _js2n__-prdslib.isType '"Bool",
                                      watch = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          ecs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      accessKeyID =
                                        _js2n__-prdslib.isType '"String",
                                      autoDiscoverClusters =
                                        _js2n__-prdslib.isType '"Bool",
                                      clusters =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      constraints =
                                        _js2n__-prdslib.isType '"String",
                                      defaultRule =
                                        _js2n__-prdslib.isType '"String",
                                      ecsAnywhere =
                                        _js2n__-prdslib.isType '"Bool",
                                      exposedByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      refreshSeconds =
                                        _js2n__-prdslib.isType 'Integer,
                                      region = _js2n__-prdslib.isType '"String",
                                      secretAccessKey =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          etcd =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      endpoints =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      rootKey =
                                        _js2n__-prdslib.isType '"String",
                                      tls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  ca =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  caOptional =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  cert =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  insecureSkipVerify =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          file =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      debugLogGeneratedTemplate =
                                        _js2n__-prdslib.isType '"Bool",
                                      directory =
                                        _js2n__-prdslib.isType '"String",
                                      filename =
                                        _js2n__-prdslib.isType '"String",
                                      watch = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          http =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      pollInterval =
                                        _js2n__-prdslib.isType '"String",
                                      pollTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      tls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  ca =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  caOptional =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  cert =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  insecureSkipVerify =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          kubernetesCRD =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowCrossNamespace =
                                        _js2n__-prdslib.isType '"Bool",
                                      allowEmptyServices =
                                        _js2n__-prdslib.isType '"Bool",
                                      allowExternalNameServices =
                                        _js2n__-prdslib.isType '"Bool",
                                      certAuthFilePath =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      ingressClass =
                                        _js2n__-prdslib.isType '"String",
                                      labelSelector =
                                        _js2n__-prdslib.isType '"String",
                                      namespaces =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      throttleDuration =
                                        _js2n__-prdslib.isType '"String",
                                      token = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          kubernetesGateway =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      certAuthFilePath =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      labelSelector =
                                        _js2n__-prdslib.isType '"String",
                                      namespaces =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      statusAddress =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  ip =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  service =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              name =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              namespace =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      throttleDuration =
                                        _js2n__-prdslib.isType '"String",
                                      token = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          kubernetesIngress =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      allowEmptyServices =
                                        _js2n__-prdslib.isType '"Bool",
                                      allowExternalNameServices =
                                        _js2n__-prdslib.isType '"Bool",
                                      certAuthFilePath =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      ingressClass =
                                        _js2n__-prdslib.isType '"String",
                                      ingressEndpoint =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  hostname =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  ip =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  publishedService =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      labelSelector =
                                        _js2n__-prdslib.isType '"String",
                                      namespaces =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      throttleDuration =
                                        _js2n__-prdslib.isType '"String",
                                      token = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          marathon =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      basic =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  httpBasicAuthUser =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  httpBasicPassword =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      constraints =
                                        _js2n__-prdslib.isType '"String",
                                      dcosToken =
                                        _js2n__-prdslib.isType '"String",
                                      defaultRule =
                                        _js2n__-prdslib.isType '"String",
                                      dialerTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      exposedByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      forceTaskHostname =
                                        _js2n__-prdslib.isType '"Bool",
                                      keepAlive =
                                        _js2n__-prdslib.isType '"String",
                                      respectReadinessChecks =
                                        _js2n__-prdslib.isType '"Bool",
                                      responseHeaderTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      tls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  ca =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  caOptional =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  cert =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  insecureSkipVerify =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      tlsHandshakeTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      trace = _js2n__-prdslib.isType '"Bool",
                                      watch = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          nomad =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      constraints =
                                        _js2n__-prdslib.isType '"String",
                                      defaultRule =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  address =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  endpointWaitTime =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  region =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  tls =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              ca =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              caOptional =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              cert =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                              insecureSkipVerify =
                                                                _js2n__-prdslib.isType
                                                                    '"Bool",
                                                              key =
                                                                _js2n__-prdslib.isType
                                                                    '"String",
                                                            } {} false
                                                            _js2n__-prdslib.never
                                                        ],
                                                  token =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      exposedByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      namespace =
                                        _js2n__-prdslib.isType '"String",
                                      prefix = _js2n__-prdslib.isType '"String",
                                      refreshInterval =
                                        _js2n__-prdslib.isType '"String",
                                      stale = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          plugin =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record {}
                                    {
                                      "[a-zA-Z0-9-_]+" =
                                        _js2n__-prdslib.isType 'Record,
                                    } true _js2n__-prdslib.always
                                ],
                          providersThrottleDuration =
                            _js2n__-prdslib.isType '"String",
                          rancher =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      constraints =
                                        _js2n__-prdslib.isType '"String",
                                      defaultRule =
                                        _js2n__-prdslib.isType '"String",
                                      enableServiceHealthFilter =
                                        _js2n__-prdslib.isType '"Bool",
                                      exposedByDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      intervalPoll =
                                        _js2n__-prdslib.isType '"Bool",
                                      prefix = _js2n__-prdslib.isType '"String",
                                      refreshSeconds =
                                        _js2n__-prdslib.isType 'Integer,
                                      watch = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          redis =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      db = _js2n__-prdslib.isType 'Integer,
                                      endpoints =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      rootKey =
                                        _js2n__-prdslib.isType '"String",
                                      tls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  ca =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  caOptional =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  cert =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  insecureSkipVerify =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                  key =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          rest =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      insecure = _js2n__-prdslib.isType '"Bool",
                                    } {} false _js2n__-prdslib.never
                                ],
                          zooKeeper =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      endpoints =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      password =
                                        _js2n__-prdslib.isType '"String",
                                      rootKey =
                                        _js2n__-prdslib.isType '"String",
                                      username =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              serversTransport =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          forwardingTimeouts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      dialTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      idleConnTimeout =
                                        _js2n__-prdslib.isType '"String",
                                      responseHeaderTimeout =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          insecureSkipVerify = _js2n__-prdslib.isType '"Bool",
                          maxIdleConnsPerHost = _js2n__-prdslib.isType 'Integer,
                          rootCAs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              tracing =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          datadog =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      bagagePrefixHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                      debug = _js2n__-prdslib.isType '"Bool",
                                      globalTag =
                                        _js2n__-prdslib.isType '"String",
                                      globalTags =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {
                                                  "[a-zA-Z0-9-_]+" =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } true _js2n__-prdslib.always
                                            ],
                                      localAgentHostPort =
                                        _js2n__-prdslib.isType '"String",
                                      parentIDHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                      prioritySampling =
                                        _js2n__-prdslib.isType '"Bool",
                                      samplingPriorityHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                      traceIDHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          elastic =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      secretToken =
                                        _js2n__-prdslib.isType '"String",
                                      serverURL =
                                        _js2n__-prdslib.isType '"String",
                                      serviceEnvironment =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          haystack =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      baggagePrefixHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                      globalTag =
                                        _js2n__-prdslib.isType '"String",
                                      localAgentHost =
                                        _js2n__-prdslib.isType '"String",
                                      localAgentPort =
                                        _js2n__-prdslib.isType 'Integer,
                                      parentIDHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                      spanIDHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                      traceIDHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          instana =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      enableAutoProfile =
                                        _js2n__-prdslib.isType '"Bool",
                                      localAgentHost =
                                        _js2n__-prdslib.isType '"String",
                                      localAgentPort =
                                        _js2n__-prdslib.isType 'Integer,
                                      logLevel =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          jaeger =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      collector =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  endpoint =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  password =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  user =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      disableAttemptReconnecting =
                                        _js2n__-prdslib.isType '"Bool",
                                      gen128Bit =
                                        _js2n__-prdslib.isType '"Bool",
                                      localAgentHostPort =
                                        _js2n__-prdslib.isType '"String",
                                      propagation =
                                        _js2n__-prdslib.isType '"String",
                                      samplingParam =
                                        _js2n__-prdslib.isType 'Integer,
                                      samplingServerURL =
                                        _js2n__-prdslib.isType '"String",
                                      samplingType =
                                        _js2n__-prdslib.isType '"String",
                                      traceContextHeaderName =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          serviceName = _js2n__-prdslib.isType '"String",
                          spanNameLimit = _js2n__-prdslib.isType 'Integer,
                          zipkin =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      httpEndpoint =
                                        _js2n__-prdslib.isType '"String",
                                      id128Bit = _js2n__-prdslib.isType '"Bool",
                                      sameSpan = _js2n__-prdslib.isType '"Bool",
                                      sampleRate =
                                        _js2n__-prdslib.isType 'Integer,
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
            } {} false _js2n__-prdslib.never
        ])