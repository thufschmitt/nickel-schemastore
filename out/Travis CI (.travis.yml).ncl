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
      "_js2n__-:definitions/arrayOfNonEmptyStrings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
            ],
      "_js2n__-:definitions/cache!predicate" =
        _js2n__-prdslib.enum
            [
              "apt",
              "bundler",
              "cargo",
              "ccache",
              "cocoapods",
              "packages",
              "pip",
              "yarn",
              "npm"
            ],
      "_js2n__-:definitions/deployment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      on =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  all_branches = _js2n__-prdslib.isType '"Bool",
                                  branch = _js2n__-prdslib.isType '"String",
                                  condition = _js2n__-prdslib.isType '"String",
                                  repo = _js2n__-prdslib.isType '"String",
                                  skip_cleanup = _js2n__-prdslib.isType '"Bool",
                                  tags =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "provider", "script" ],
                      _js2n__-prdslib.records.record
                        {
                          provider = _js2n__-prdslib.enum [ "script" ],
                          script = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required
                                [ "api_key", "email", "provider" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required
                                [ "api_token", "email", "provider" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ]
                        ],
                      _js2n__-prdslib.records.record
                        {
                          api_key =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          api_token =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          email =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          provider = _js2n__-prdslib.enum [ "npm" ],
                          tag = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "provider" ],
                      _js2n__-prdslib.records.record
                        {
                          domain = _js2n__-prdslib.isType '"String",
                          project = _js2n__-prdslib.isType '"String",
                          provider = _js2n__-prdslib.enum [ "surge" ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "provider" ],
                      _js2n__-prdslib.records.record
                        {
                          api_key =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          file =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ]
                                ],
                          file_glob = _js2n__-prdslib.isType '"Bool",
                          overwrite = _js2n__-prdslib.isType '"Bool",
                          password =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          provider = _js2n__-prdslib.enum [ "releases" ],
                          user =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "api_key", "provider" ],
                      _js2n__-prdslib.records.record
                        {
                          api_key =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate"
                                    ]
                                ],
                          app =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.isType '"String")
                                    ]
                                ],
                          provider = _js2n__-prdslib.enum [ "heroku" ],
                          run =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ]
                                ],
                          skip_cleanup = _js2n__-prdslib.isType '"Bool",
                          strategy = _js2n__-prdslib.enum [ "api", "git" ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [
                          "access_key_id",
                          "bucket",
                          "provider",
                          "secret_access_key"
                        ],
                      _js2n__-prdslib.records.record
                        {
                          access_key_id =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          acl =
                            _js2n__-prdslib.enum
                                [
                                  "private",
                                  "public_read",
                                  "public_read_write",
                                  "authenticated_read",
                                  "bucket_owner_read",
                                  "bucket_owner_full_control"
                                ],
                          bucket = _js2n__-prdslib.isType '"String",
                          cache_control = _js2n__-prdslib.isType '"String",
                          default_text_charset =
                            _js2n__-prdslib.isType '"String",
                          detect_encoding = _js2n__-prdslib.isType '"Bool",
                          endpoint = _js2n__-prdslib.isType '"String",
                          expires = _js2n__-prdslib.isType '"String",
                          local_dir = _js2n__-prdslib.isType '"String",
                          provider = _js2n__-prdslib.enum [ "s3" ],
                          region = _js2n__-prdslib.isType '"String",
                          secret_access_key =
                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                          skip_cleanup = _js2n__-prdslib.isType '"Bool",
                          upload-dir = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "provider" ],
                      _js2n__-prdslib.records.record
                        {
                          provider =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.not
                                    (_js2n__-prdslib.enum
                                      [
                                        "script",
                                        "npm",
                                        "surge",
                                        "releases",
                                        "heroku",
                                        "s3"
                                      ])
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/envVar!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "[^=]+=.*"
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      secure =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern "[^=]+=.*"
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/envVars!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/envVar!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/envVar!predicate"
                ]
            ],
      "_js2n__-:definitions/import!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "source" ],
                  _js2n__-prdslib.records.record
                    {
                      "if" =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                      mode =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "merge",
                                  "deep_merge",
                                  "deep_merge_append",
                                  "deep_merge_prepend"
                                ]
                            ],
                      source =
                        _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
            ],
      "_js2n__-:definitions/job!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addons =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              apt =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          packages =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
                                          sources =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [ "sourceline" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                key_url =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                sourceline =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                        _js2n__-prdslib.isType
                                                          '"String"
                                                      ])
                                                ],
                                          update =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              artifacts =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.enum [ true ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                              paths =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Array",
                                                      _js2n__-prdslib.arrays.arrayOf
                                                        (_js2n__-prdslib.isType
                                                          '"String")
                                                    ],
                                              s3_region =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              working_dir =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              browserstack =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          access_key =
                                            _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                                          app_path =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                          forcelocal =
                                            _js2n__-prdslib.isType '"Bool",
                                          only =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                          proxyHost =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                          proxyPass =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                          proxyPort =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                          proxyUser =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                          username =
                                            _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              chrome =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "stable", "beta" ]
                                    ],
                              coverity_scan =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          branch_pattern =
                                            _js2n__-prdslib.isType '"String",
                                          build_command =
                                            _js2n__-prdslib.isType '"String",
                                          build_command_prepend =
                                            _js2n__-prdslib.isType '"String",
                                          notification_email =
                                            _js2n__-prdslib.isType '"String",
                                          project =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "name" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      description =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      version =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                              firefox =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "latest",
                                              "latest-esr",
                                              "latest-beta",
                                              "latest-dev",
                                              "latest-nightly",
                                              "latest-unsigned"
                                            ]
                                        ],
                                      _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate"
                                    ],
                              homebrew =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          brewfile =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          casks =
                                            _js2n__-refsenv."_js2n__-:definitions/stringOrStringArrayUnique!predicate",
                                          packages =
                                            _js2n__-refsenv."_js2n__-:definitions/stringOrStringArrayUnique!predicate",
                                          taps =
                                            _js2n__-refsenv."_js2n__-:definitions/stringOrStringArrayUnique!predicate",
                                          update =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              hosts =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              mariadb = _js2n__-prdslib.isType '"String",
                              postgresql = _js2n__-prdslib.isType '"String",
                              rethinkdb = _js2n__-prdslib.isType '"String",
                              sauce_connect =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              access_key =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              username =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} true _js2n__-prdslib.always
                                        ],
                                      _js2n__-prdslib.isType '"Bool"
                                    ],
                              snaps =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.oneOf
                                              [
                                                _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "name" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        channel =
                                                          _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                                        classic =
                                                          _js2n__-prdslib.isType
                                                              '"Bool",
                                                        confinement =
                                                          _js2n__-prdslib.enum
                                                              [
                                                                "classic",
                                                                "devmode"
                                                              ],
                                                        name =
                                                          _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              sonarcloud =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          organization =
                                            _js2n__-prdslib.isType '"String",
                                          token =
                                            _js2n__-refsenv."_js2n__-:definitions/secretString!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              srcclr =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              debug =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                              ssh_known_hosts =
                                _js2n__-refsenv."_js2n__-:definitions/stringOrStringArrayUnique!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  after_deploy =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  after_failure =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  after_script =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  after_success =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  android =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              components =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              licenses =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  apt_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  arch =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "amd64",
                              "x86_64",
                              "arm64",
                              "ppc64le",
                              "s390x",
                              "arm64-graviton2"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum
                                  [
                                    "amd64",
                                    "arm64",
                                    "ppc64le",
                                    "s390x",
                                    "arm64-graviton2"
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  before_cache =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  before_deploy =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  before_install =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  before_script =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  bioc_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  branches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              except =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              only =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  brew_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  bundler_args = _js2n__-prdslib.isType '"String",
                  cache =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ false ],
                          _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.oneOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.record
                                          {
                                            directories =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.isType
                                                        '"String")
                                                  ],
                                          } {} false _js2n__-prdslib.never
                                      ]
                                  ])
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  apt = _js2n__-prdslib.isType '"Bool",
                                  bundler = _js2n__-prdslib.isType '"Bool",
                                  cargo = _js2n__-prdslib.isType '"Bool",
                                  ccache = _js2n__-prdslib.isType '"Bool",
                                  cocoapods = _js2n__-prdslib.isType '"Bool",
                                  directories =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  npm = _js2n__-prdslib.isType '"Bool",
                                  packages = _js2n__-prdslib.isType '"Bool",
                                  pip = _js2n__-prdslib.isType '"Bool",
                                  timeout = _js2n__-prdslib.isType '"Number",
                                  yarn = _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  compiler =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum [ "clang", "gcc" ])
                            ],
                          _js2n__-prdslib.enum [ "clang", "gcc" ]
                        ],
                  cran = _js2n__-prdslib.isType '"String",
                  crystal =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  d =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dart =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dart_task =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    dartanalyzer =
                                      _js2n__-prdslib.isType '"Bool",
                                    dartfmt = _js2n__-prdslib.isType '"Bool",
                                    install_dartium =
                                      _js2n__-prdslib.isType '"Bool",
                                    test = _js2n__-prdslib.isType '"String",
                                    xvfb = _js2n__-prdslib.isType '"Bool",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  deploy =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/deployment!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/deployment!predicate"
                        ],
                  dist =
                    _js2n__-prdslib.enum
                        [
                          "precise",
                          "trusty",
                          "xenial",
                          "bionic",
                          "focal",
                          "jammy"
                        ],
                  elixir =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  elm =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrStringArrayUnique!predicate",
                  elm-format =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  elm-test =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                  env =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/envVars!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  global =
                                    _js2n__-refsenv."_js2n__-:definitions/envVars!predicate",
                                  jobs =
                                    _js2n__-refsenv."_js2n__-:definitions/envVars!predicate",
                                  matrix =
                                    _js2n__-refsenv."_js2n__-:definitions/envVars!predicate",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  erlang =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  gemfile =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  ghc =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  git =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              autocrlf =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum [ "input" ]
                                        ]
                                    ],
                              clone = _js2n__-prdslib.isType '"Bool",
                              depth =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ false ]
                                    ],
                              lfs_skip_smudge = _js2n__-prdslib.isType '"Bool",
                              quiet = _js2n__-prdslib.isType '"Bool",
                              sparse_checkout =
                                _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                              submodules = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  go =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  haxe =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  hxml =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  install =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  jdk =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  julia =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrNumberOrAcceptBothTypeAsArrayUnique!predicate",
                  language =
                    _js2n__-prdslib.enum
                        [
                          "android",
                          "bash",
                          "c",
                          "c++",
                          "clojure",
                          "cpp",
                          "crystal",
                          "csharp",
                          "d",
                          "dart",
                          "dartlang",
                          "elixir",
                          "elm",
                          "erlang",
                          "generic",
                          "go",
                          "golang",
                          "groovy",
                          "haskell",
                          "haxe",
                          "java",
                          "javascript",
                          "julia",
                          "jvm",
                          "matlab",
                          "minimal",
                          "nix",
                          "node",
                          "node.js",
                          "node_js",
                          "nodejs",
                          "obj-c",
                          "obj_c",
                          "objective-c",
                          "objective_c",
                          "perl",
                          "perl6",
                          "php",
                          "python",
                          "r",
                          "ruby",
                          "rust",
                          "scala",
                          "sh",
                          "shell",
                          "smalltalk"
                        ],
                  lein = _js2n__-prdslib.isType '"String",
                  matlab =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrStringArrayUnique!predicate",
                  mono =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "none" ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  neko = _js2n__-prdslib.isType '"String",
                  node_js =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrNumberOrAcceptBothTypeAsArrayUnique!predicate",
                  opt_release =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  os =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [ "osx", "linux", "linux-ppc64le", "windows" ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.enum
                                  [
                                    "osx",
                                    "linux",
                                    "linux-ppc64le",
                                    "windows"
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  osx_image =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/xcodeVersions!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/xcodeVersions!predicate",
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  pandoc_version = _js2n__-prdslib.isType '"String",
                  perl =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  perl6 =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  php =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrNumberOrAcceptBothTypeAsArrayUnique!predicate",
                  podfile = _js2n__-prdslib.isType '"String",
                  python =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrNumberOrAcceptBothTypeAsArrayUnique!predicate",
                  r =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  r_binary_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  r_github_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  r_packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  repos =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  rust =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number"
                        ],
                  rvm =
                    _js2n__-refsenv."_js2n__-:definitions/stringOrNumberOrAcceptBothTypeAsArrayUnique!predicate",
                  sbt_args = _js2n__-prdslib.isType '"String",
                  scala =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  script =
                    _js2n__-refsenv."_js2n__-:definitions/step!predicate",
                  services =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/service!predicate"
                            ]
                        ],
                  smalltalk =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  solution = _js2n__-prdslib.isType '"String",
                  sudo =
                    _js2n__-prdslib.enum
                        [ true, false, "", "required", "enabled" ],
                  xcode_project = _js2n__-prdslib.isType '"String",
                  xcode_scheme = _js2n__-prdslib.isType '"String",
                  xcode_sdk = _js2n__-prdslib.isType '"String",
                  xcode_workspace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/nonEmptyString!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1
            ],
      "_js2n__-:definitions/nonEmptyStringOrArrayOfNonEmptyStrings!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
              _js2n__-refsenv."_js2n__-:definitions/arrayOfNonEmptyStrings!predicate"
            ],
      "_js2n__-:definitions/possiblySecretString!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    { secure = _js2n__-prdslib.isType '"String", } {} false
                    _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/possiblySecretStringOrPossiblySecretStringTypeArrayUnique!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                  _js2n__-prdslib.arrays.minItems 1,
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ],
      "_js2n__-:definitions/secretString!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  secure =
                    _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/service!predicate" =
        _js2n__-prdslib.enum
            [
              "cassandra",
              "couchdb",
              "docker",
              "elasticsearch",
              "mariadb",
              "memcached",
              "mongodb",
              "mysql",
              "neo4j",
              "postgresql",
              "rabbitmq",
              "redis",
              "redis-server",
              "rethinkdb",
              "riak",
              "xvfb"
            ],
      "_js2n__-:definitions/slackRoom!predicate"
        | doc "Your account name, token and optional channel"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern ".+:.+(#.+)?"
                ],
              _js2n__-refsenv."_js2n__-:definitions/secretString!predicate"
            ],
      "_js2n__-:definitions/step!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.enum [ "skip", "ignore" ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/stringArrayUnique!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/stringOrNumber!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
              _js2n__-prdslib.isType '"Number"
            ],
      "_js2n__-:definitions/stringOrNumberAndBothAreTypeArrayUnique!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/stringOrNumber!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/stringOrNumberOrAcceptBothTypeAsArrayUnique!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stringOrNumber!predicate",
              _js2n__-refsenv."_js2n__-:definitions/stringOrNumberAndBothAreTypeArrayUnique!predicate"
            ],
      "_js2n__-:definitions/stringOrStringArrayUnique!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/nonEmptyString!predicate",
              _js2n__-refsenv."_js2n__-:definitions/stringArrayUnique!predicate"
            ],
      "_js2n__-:definitions/xcodeVersions!predicate" =
        _js2n__-prdslib.enum
            [
              "xcode6.4",
              "xcode7.3",
              "xcode8",
              "xcode8.3",
              "xcode9",
              "xcode9.1",
              "xcode9.2",
              "xcode9.3",
              "xcode9.4",
              "xcode10",
              "xcode10.1",
              "xcode10.2",
              "xcode10.3",
              "xcode11",
              "xcode11.1",
              "xcode11.2",
              "xcode11.3",
              "xcode11.4",
              "xcode11.4.1",
              "xcode11.5",
              "xcode11.6",
              "xcode12u",
              "xcode12",
              "xcode12.2",
              "xcode12.3",
              "xcode12.4",
              "xcode12.5",
              "xcode13.1",
              "xcode13.2",
              "xcode13.3",
              "xcode13.4",
              "xcode14",
              "xcode14.1",
              "xcode14.2"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-refsenv."_js2n__-:definitions/job!predicate",
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "import" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/import!predicate",
                              _js2n__-prdslib.arrays.uniqueItems
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/import!predicate"
                        ],
                  jobs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allow_failures =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/job!predicate"
                                    ],
                              exclude =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-refsenv."_js2n__-:definitions/job!predicate",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    stage =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ]
                                          ])
                                    ],
                              fast_finish = _js2n__-prdslib.isType '"Bool",
                              include =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-refsenv."_js2n__-:definitions/job!predicate",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    stage =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ]
                                          ])
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  matrix =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allow_failures =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/job!predicate"
                                    ],
                              exclude =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/job!predicate"
                                    ],
                              fast_finish = _js2n__-prdslib.isType '"Bool",
                              include =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/job!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  notifications =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              campfire =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/possiblySecretStringOrPossiblySecretStringTypeArrayUnique!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              email =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/possiblySecretStringOrPossiblySecretStringTypeArrayUnique!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              flowdock =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/possiblySecretString!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              hipchat =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/possiblySecretStringOrPossiblySecretStringTypeArrayUnique!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              irc =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/possiblySecretStringOrPossiblySecretStringTypeArrayUnique!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              pushover =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/nonEmptyStringOrArrayOfNonEmptyStrings!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              slack =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/slackRoom!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                              webhooks =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/possiblySecretStringOrPossiblySecretStringTypeArrayUnique!predicate",
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.always,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-prdslib.always,
                                          _js2n__-prdslib.arrays.minItems 1,
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  stages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        "if" = _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ])
                        ],
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(~>|>|>=|=|<=|<) (\\d+(?:\\.\\d+)?(?:\\.\\d+)?)$"
                        ],
                } {} true _js2n__-prdslib.always
            ]
        ])