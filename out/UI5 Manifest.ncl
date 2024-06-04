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
      "_js2n__-:definitions/Configuration.BasicDataType!predicate"
        | doc "Basic data types for parameters and filters"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "string", "integer", "number", "boolean", "date", "datetime" ]
            ],
      "_js2n__-:definitions/Configuration.CSRFToken!predicate"
        | doc "Represents a configuration for a CSRF token"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.Destinations!predicate"
        | doc "Represents a configuration for a cloud platform destination"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  defaultUrl = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.Filter.ComboBoxItem!predicate"
        | doc "A single Combo Box filter selection option"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additionalText = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.Filter.Item!predicate"
        | doc "A single filter selection option"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.FilterType.ComboBox!predicate"
        | doc "[Experimental] ComboBox filter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  item =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "template" ],
                          _js2n__-prdslib.records.record
                            {
                              path =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[a-zA-Z0-9_\\.\\-/|@#]*$"
                                    ],
                              template =
                                _js2n__-refsenv."_js2n__-:definitions/Configuration.Filter.ComboBoxItem!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Configuration.Filter.ComboBoxItem!predicate"
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  placeholder = _js2n__-prdslib.isType '"String",
                  selectedKey = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "ComboBox",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  value = _js2n__-prdslib.always,
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.FilterType.DateRange!predicate"
        | doc "Date range filter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  label = _js2n__-prdslib.isType '"String",
                  options =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "date",
                                    "today",
                                    "yesterday",
                                    "tomorrow",
                                    "dateRange",
                                    "dateTimeRange",
                                    "from",
                                    "to",
                                    "fromDateTime",
                                    "toDateTime",
                                    "yearToDate",
                                    "lastDays",
                                    "lastWeeks",
                                    "lastMonths",
                                    "lastQuarters",
                                    "lastYears",
                                    "nextDays",
                                    "nextWeeks",
                                    "nextMonths",
                                    "nextQuarters",
                                    "nextYears",
                                    "todayFromTo",
                                    "thisWeek",
                                    "lastWeek",
                                    "nextWeek",
                                    "specificMonth",
                                    "thisMonth",
                                    "lastMonth",
                                    "nextMonth",
                                    "thisQuarter",
                                    "lastQuarter",
                                    "nextQuarter",
                                    "quarter1",
                                    "quarter2",
                                    "quarter3",
                                    "quarter4",
                                    "thisYear",
                                    "lastYear",
                                    "nextYear",
                                    "dateTime"
                                  ]
                              ])
                        ],
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "DateRange",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  value =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              option = _js2n__-prdslib.isType '"String",
                              values = _js2n__-prdslib.isType '"Array",
                            } {} false _js2n__-prdslib.never
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.FilterType.Search!predicate"
        | doc "Search filter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  label = _js2n__-prdslib.isType '"String",
                  placeholder = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "Search",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  value = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.FilterType.Select!predicate"
        | doc "Select filter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  item =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "template" ],
                          _js2n__-prdslib.records.record
                            {
                              path =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[a-zA-Z0-9_\\.\\-/|@#]*$"
                                    ],
                              template =
                                _js2n__-refsenv."_js2n__-:definitions/Configuration.Filter.Item!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Configuration.Filter.Item!predicate"
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "Select",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  value = _js2n__-prdslib.always,
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.NoData!predicate"
        | doc "Represents a configuration for a NoData"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  size = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Configuration.Parameter!predicate"
        | doc "Represents configuration parameter"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/Configuration.BasicDataType!predicate",
                  value = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.AdaptiveCard!predicate"
        | doc "Represents AdaptiveCard content"
        = _js2n__-prdslib.always,
      "_js2n__-:definitions/ContentType.Analytical!predicate"
        | doc "Represents analytical content attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actionableArea =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "Full", "Chart" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  chartProperties =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  chartType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  dimensionAxis = _js2n__-prdslib.isType '"String",
                  dimensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.Dimension!predicate"
                        ],
                  feeds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.Field!predicate"
                        ],
                  legend =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.Legend!predicate",
                  measureAxis = _js2n__-prdslib.isType '"String",
                  measures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.Measure!predicate"
                        ],
                  minHeight =
                    _js2n__-refsenv."_js2n__-:definitions/minHeight!predicate",
                  plotArea =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              categoryAxisText =
                                _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.AxisText!predicate",
                              dataLabel =
                                _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.DataLabel!predicate",
                              valueAxisText =
                                _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical.AxisText!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  popover =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              actionsStrip =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                actions =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                                                      ],
                                                text =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ]),
                                      _js2n__-prdslib.arrays.maxItems 1
                                    ],
                              active =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              alignment =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.enum
                                        [ "Left", "Center", "Right" ],
                                      _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                                    ],
                              text = _js2n__-prdslib.isType '"String",
                              visible =
                                _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Analytical.AxisText!predicate"
        | doc "Represents descriptive text of the axis"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Analytical.DataLabel!predicate"
        | doc "Represents value attributes in the plot area"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  showTotal =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Analytical.Dimension!predicate"
        | doc "Dimension for the dataset"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum
                                [ "string", "number", "date" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  displayValue = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Analytical.Field!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "Measure", "Dimension" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  uid = _js2n__-prdslib.isType '"String",
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Analytical.Legend!predicate"
        | doc "[Deprecated] Represents chart legend attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alignment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "TopLeft", "Center" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  position =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum
                                [ "Top", "Bottom", "Left", "Right" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Analytical.Measure!predicate"
        | doc "Measure for the dataset"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.AnalyticsCloud!predicate"
        | doc "Represents SAP Analytics Cloud content attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  minHeight =
                    _js2n__-refsenv."_js2n__-:definitions/minHeight!predicate",
                  options =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar!predicate"
        | doc "The calendar card is used to display a schedule of a single entity (such as person, resource) for a selected time interval"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  date =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  item =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar.Item!predicate",
                  legendItem =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar.LegendItem!predicate",
                  maxItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  maxLegendItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  moreItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              actions =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  noItemsText =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  specialDate =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar.SpecialDate!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar.Item!predicate"
        | doc "Describes each item"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar.Item.Template!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar.Item.Template!predicate"
        | doc "The template for all items"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  endDate = _js2n__-prdslib.isType '"String",
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/simpleIcon!predicate",
                  startDate = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "Type01",
                              "Type02",
                              "Type03",
                              "Type04",
                              "Type05",
                              "Type06",
                              "Type07",
                              "Type08",
                              "Type09",
                              "Type10",
                              "Type11",
                              "Type12",
                              "Type13",
                              "Type14",
                              "Type15",
                              "Type16",
                              "Type17",
                              "Type18",
                              "Type19",
                              "Type20"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar.LegendItem!predicate"
        | doc "Describes each legendItem"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar.LegendItem.Template!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar.LegendItem.Template!predicate"
        | doc "The template for all legendItems"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  category = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "Type01",
                              "Type02",
                              "Type03",
                              "Type04",
                              "Type05",
                              "Type06",
                              "Type07",
                              "Type08",
                              "Type09",
                              "Type10",
                              "Type11",
                              "Type12",
                              "Type13",
                              "Type14",
                              "Type15",
                              "Type16",
                              "Type17",
                              "Type18",
                              "Type19",
                              "Type20"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar.SpecialDate!predicate"
        | doc "Describes each specialDate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar.SpecialDate.Template!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Calendar.SpecialDate.Template!predicate"
        | doc "The template for all specialDates"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endDate = _js2n__-prdslib.isType '"String",
                  startDate = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "Type01",
                              "Type02",
                              "Type03",
                              "Type04",
                              "Type05",
                              "Type06",
                              "Type07",
                              "Type08",
                              "Type09",
                              "Type10",
                              "Type11",
                              "Type12",
                              "Type13",
                              "Type14",
                              "Type15",
                              "Type16",
                              "Type17",
                              "Type18",
                              "Type19",
                              "Type20"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Component!predicate"
        | doc "Represents the configuration for a component card's content"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  minHeight =
                    _js2n__-refsenv."_js2n__-:definitions/minHeight!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.List!predicate"
        | doc "Represents list content attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  group =
                    _js2n__-refsenv."_js2n__-:definitions/group!predicate",
                  item =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.List.Item!predicate",
                  maxItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  minItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.List.Item!predicate"
        | doc "The template for all items"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  actionsStrip =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/actionsStripItem!predicate"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/actionsStrip!predicate"
                        ],
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.List.Item.ValueStateItem!predicate"
                        ],
                  attributesLayoutType =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "OneColumn", "TwoColumns" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  chart =
                    _js2n__-refsenv."_js2n__-:definitions/MicroChart!predicate",
                  description =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/field!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  highlight =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/state!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  highlightText = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
                  info =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.List.Item.ValueStateItem!predicate",
                  title =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/field!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.List.Item.ValueStateItem!predicate"
        | doc "Represents value and state information for an object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customStateIcon = _js2n__-prdslib.isType '"String",
                  showStateIcon =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  state =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/state!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object!predicate"
        | doc "Represents object content attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Group!predicate"
                        ],
                  hasData =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Group!predicate"
        | doc "Represents a group of information for an object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "items" ],
              _js2n__-prdslib.records.record
                {
                  alignment = _js2n__-prdslib.enum [ "Default", "Stretch" ],
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Item!predicate"
                        ],
                  labelWrapping =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  titleMaxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Item!predicate"
        | doc "Represents a single item of information. It can contain label, value and image"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  alt = _js2n__-prdslib.isType '"String",
                  customStateIcon = _js2n__-prdslib.isType '"String",
                  details = _js2n__-prdslib.isType '"String",
                  emailSubject = _js2n__-prdslib.isType '"String",
                  fullWidth =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  height = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  imageFit = _js2n__-prdslib.isType '"String",
                  imagePosition = _js2n__-prdslib.isType '"String",
                  item =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "template" ],
                          _js2n__-prdslib.records.record
                            {
                              path =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[a-zA-Z0-9_\\.\\-/|@#]*$"
                                    ],
                              template =
                                _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Item.ComboBoxItemTemplate!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  mainIndicator =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Item.MainIndicator!predicate",
                  maxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  maxValue =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  overlay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              animation = _js2n__-prdslib.isType '"String",
                              background = _js2n__-prdslib.isType '"String",
                              horizontalPosition =
                                _js2n__-prdslib.isType '"String",
                              padding = _js2n__-prdslib.isType '"String",
                              subTitle = _js2n__-prdslib.isType '"String",
                              supertitle = _js2n__-prdslib.isType '"String",
                              textColor = _js2n__-prdslib.isType '"String",
                              textFilter = _js2n__-prdslib.isType '"String",
                              title = _js2n__-prdslib.isType '"String",
                              verticalPosition =
                                _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  path = _js2n__-prdslib.isType '"String",
                  placeholder = _js2n__-prdslib.isType '"String",
                  rows = _js2n__-prdslib.isType '"Number",
                  selectedKey = _js2n__-prdslib.isType '"String",
                  showColon =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  showStateIcon =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  sideIndicators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HeaderType.Numeric.SideIndicator!predicate",
                          _js2n__-prdslib.arrays.maxItems 2
                        ],
                  sideIndicatorsAlignment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Begin", "End" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  size =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "XS", "S", "M" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  src = _js2n__-prdslib.isType '"String",
                  state =
                    _js2n__-refsenv."_js2n__-:definitions/state!predicate",
                  target =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Item.IconGroupTemplate!predicate",
                  tooltip = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum
                                [
                                  "Default",
                                  "NumericData",
                                  "Status",
                                  "IconGroup",
                                  "ComboBox",
                                  "TextArea",
                                  "Input",
                                  "Duration",
                                  "DateRange",
                                  "RatingIndicator",
                                  "phone",
                                  "email",
                                  "link",
                                  "text",
                                  "Image"
                                ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  validations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Item.Validation!predicate"
                        ],
                  value =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  option = _js2n__-prdslib.isType '"String",
                                  values = _js2n__-prdslib.isType '"Array",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                  visualMode =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "Full", "Half" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Item.ComboBoxItemTemplate!predicate"
        | doc "Template for combo box items"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Item.IconGroupIcon!predicate"
        | doc "Definition for icons in the IconGroup"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alt = _js2n__-prdslib.isType '"String",
                  initials = _js2n__-prdslib.isType '"String",
                  src = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Item.IconGroupTemplate!predicate"
        | doc "Template definition for the icons in the group"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "icon" ],
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Object.Item.IconGroupIcon!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Item.MainIndicator!predicate"
        | doc "Represents the main numeric indicator of the NumericData"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  number = _js2n__-prdslib.isType '"String",
                  size =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "S", "L" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Enums.ValueColor!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  trend =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Down", "None", "Up" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  unit = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Object.Item.Validation!predicate"
        | doc "[Experimental] Defines the user input validation"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  maxLength =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  message = _js2n__-prdslib.isType '"String",
                  minLength =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                  required =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  restrictToPredefinedOptions =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [ "Error", "Warning", "Information" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  validate = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Table!predicate"
        | doc "Represents table content attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  group =
                    _js2n__-refsenv."_js2n__-:definitions/group!predicate",
                  maxItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  minItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  row =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              actions =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                                    ],
                              columns =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/ContentType.Table.Column!predicate"
                                    ],
                              highlight =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/state!predicate",
                                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                                        ]
                                    ],
                              highlightText = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Table.Column!predicate"
        | doc "Represents object item attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  additionalText = _js2n__-prdslib.isType '"String",
                  customStateIcon = _js2n__-prdslib.isType '"String",
                  hAlign =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/textAlign!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  icon = _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
                  identifier =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/identifier!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  progressIndicator =
                    _js2n__-refsenv."_js2n__-:definitions/progressIndicator!predicate",
                  showStateIcon =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  state =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/state!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  target =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  url = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                  width = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Timeline!predicate"
        | doc "Represents time related content"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  item =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType.Timeline.Item!predicate",
                  maxItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  minItems =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.Timeline.Item!predicate"
        | doc "Represents a single timeline item"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  dateTime =
                    _js2n__-refsenv."_js2n__-:definitions/field!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/field!predicate",
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/simpleIcon!predicate",
                  owner =
                    _js2n__-refsenv."_js2n__-:definitions/field!predicate",
                  ownerImage =
                    _js2n__-prdslib.records.record
                        { value = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always,
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/field!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType.WebPage!predicate"
        | doc "WebPage content is used to embed HTML page"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  minHeight =
                    _js2n__-refsenv."_js2n__-:definitions/minHeight!predicate",
                  sandbox = _js2n__-prdslib.isType '"String",
                  src = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Enums.ValueColor!predicate" =
        _js2n__-prdslib.enum [ "Critical", "Error", "Good", "Neutral" ],
      "_js2n__-:definitions/HeaderType!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/HeaderType.Default!predicate",
              _js2n__-refsenv."_js2n__-:definitions/HeaderType.Numeric!predicate"
            ],
      "_js2n__-:definitions/HeaderType.Default!predicate"
        | doc "Represents default header attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  closeButton =
                    _js2n__-refsenv."_js2n__-:definitions/closeButton!predicate",
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  icon =
                    _js2n__-refsenv."_js2n__-:definitions/iconWithoutSize!predicate",
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/status!predicate",
                  subTitle =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  subTitleMaxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  titleMaxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Default" ]
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                  wrappingType =
                    _js2n__-refsenv."_js2n__-:definitions/wrappingType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HeaderType.Numeric!predicate"
        | doc "Represents header with numeric data"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  chart =
                    _js2n__-refsenv."_js2n__-:definitions/MicroChart!predicate",
                  closeButton =
                    _js2n__-refsenv."_js2n__-:definitions/closeButton!predicate",
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  details = _js2n__-prdslib.isType '"String",
                  detailsMaxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  mainIndicator =
                    _js2n__-refsenv."_js2n__-:definitions/HeaderType.Numeric.MainIndicator!predicate",
                  sideIndicators =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HeaderType.Numeric.SideIndicator!predicate",
                          _js2n__-prdslib.arrays.maxItems 2
                        ],
                  sideIndicatorsAlignment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Begin", "End" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/status!predicate",
                  subTitle =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  subTitleMaxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  titleMaxLines =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Numeric" ]
                        ],
                  unitOfMeasurement = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                  wrappingType =
                    _js2n__-refsenv."_js2n__-:definitions/wrappingType!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HeaderType.Numeric.MainIndicator!predicate"
        | doc "Represents the main numeric indicator of the header"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  number = _js2n__-prdslib.isType '"String",
                  state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Enums.ValueColor!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  trend =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Down", "None", "Up" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  unit = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/HeaderType.Numeric.SideIndicator!predicate"
        | doc "Represents side indicator attributes which are used for additional information about the main indicator"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  number = _js2n__-prdslib.isType '"String",
                  state =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Enums.ValueColor!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  unit = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MicroChart!predicate"
        | doc "[Experimental] Describes MicroChart attributes"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/MicroChart.Generic!predicate",
              _js2n__-refsenv."_js2n__-:definitions/MicroChart.Bullet!predicate",
              _js2n__-refsenv."_js2n__-:definitions/MicroChart.StackedBar!predicate"
            ],
      "_js2n__-:definitions/MicroChart.Bullet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Enums.ValueColor!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  displayValue = _js2n__-prdslib.isType '"String",
                  maxValue =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  minValue =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  scale = _js2n__-prdslib.isType '"String",
                  target =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  thresholds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MicroChart.Bullet.Threshold!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "Bullet"
                        ],
                  value =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MicroChart.Bullet.Threshold!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Enums.ValueColor!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  value =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MicroChart.Generic!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Line", "Column", "HarveyBall", "Radial" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MicroChart.StackedBar!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  bars =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MicroChart.StackedBar.Bar!predicate"
                        ],
                  displayValue = _js2n__-prdslib.isType '"String",
                  maxValue =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "StackedBar"
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MicroChart.StackedBar.Bar!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Enums.ValueColor!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  displayValue = _js2n__-prdslib.isType '"String",
                  legendTitle = _js2n__-prdslib.isType '"String",
                  value =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/action!predicate"
        | doc "Represents actions that can be applied on card elements"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Custom", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        parameters =
                          _js2n__-refsenv."_js2n__-:definitions/customActionParameters!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Navigation", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        parameters =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/navigationActionParameters!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/navigationActionIBParameters!predicate"
                              ],
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Submit", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        parameters =
                          _js2n__-refsenv."_js2n__-:definitions/submitActionParameters!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "ShowCard", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        parameters =
                          _js2n__-refsenv."_js2n__-:definitions/showCardActionParameters!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "HideCard", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        parameters =
                          _js2n__-refsenv."_js2n__-:definitions/hideCardActionParameters!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  parameters = _js2n__-prdslib.always,
                  service =
                    _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                  target =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum
                                [
                                  "Custom",
                                  "Navigation",
                                  "Submit",
                                  "ShowCard",
                                  "HideCard"
                                ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/action_prop_def!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path", "target" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  refreshStrategyOnAppRestore =
                    _js2n__-refsenv."_js2n__-:definitions/refreshStrategies_prop_def!predicate",
                  target = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/actionsStrip!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  item =
                    _js2n__-refsenv."_js2n__-:definitions/actionsStripItemBindingInfo!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/actionsStripItem!predicate"
        | doc "Attributes of actions strip item"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/action!predicate"
                        ],
                  ariaHasPopup =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "Dialog",
                              "Grid",
                              "ListBox",
                              "Menu",
                              "None",
                              "Tree"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  buttonType =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "Accept",
                              "Attention",
                              "Back",
                              "Critical",
                              "Default",
                              "Emphasized",
                              "Ghost",
                              "Negative",
                              "Neutral",
                              "Reject",
                              "Success",
                              "Transparent",
                              "Unstyled",
                              "Up"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  icon = _js2n__-prdslib.isType '"String",
                  overflowPriority =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [
                              "AlwaysOverflow",
                              "Disappear",
                              "High",
                              "Low",
                              "NeverOverflow"
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  text = _js2n__-prdslib.isType '"String",
                  tooltip = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum
                            [ "Button", "ToolbarSpacer", "Link", "Label" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/actionsStripItemBindingInfo!predicate"
        | doc "[Experimental] Binding info for items of type actionsStripItem"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  template =
                    _js2n__-refsenv."_js2n__-:definitions/actionsStripItem!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/actualTargetAdditionComponentUsage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "usage" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Component" ]
                        ],
                  usage = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/actualTargetAdditionStandard!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "View", "Component" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/actualTargetAdditionStandardWithoutRequiredProp!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "View", "Component" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/batchRequest!predicate"
        | doc "Represents a request which is a part of a batch request"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "method", "url" ],
              _js2n__-prdslib.records.record
                {
                  body =
                    _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always,
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "GET", "POST", "PUT", "PATCH", "DELETE" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/booleanOrString!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/cache!predicate"
        | doc "Cache control settings"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  maxAge = _js2n__-prdslib.isType '"Number",
                  noStore = _js2n__-prdslib.isType '"Bool",
                  staleWhileRevalidate = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/card!predicate"
        | doc "Represents the card attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "template" ],
              _js2n__-prdslib.records.record
                {
                  model =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@]*$"
                        ],
                  sequencePos = _js2n__-prdslib.isType 'Integer,
                  settings =
                    _js2n__-refsenv."_js2n__-:definitions/card_setting!predicate",
                  tabs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/tab_setting!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  template =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9\\.]+$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/card_setting!predicate"
        | doc "Represents the card specific properties - properties that are passed to the card"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "title" ],
              _js2n__-prdslib.records.record
                {
                  annotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  category =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\{\\{[^\\W\\.\\-][\\w\\.\\-]*\\}\\}$"
                        ],
                  chartAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  chartProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              plotArea =
                                _js2n__-refsenv."_js2n__-:definitions/plotAreaDef!predicate",
                              timeAxis =
                                _js2n__-refsenv."_js2n__-:definitions/timeAxisDef!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  colorPalette =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Record)
                            ],
                          _js2n__-prdslib.isType 'Record
                        ],
                  customParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[^\\W\\.\\-][\\w\\.\\-]*$"
                        ],
                  dataPointAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  defaultSpan =
                    _js2n__-refsenv."_js2n__-:definitions/defaultSpanDef!predicate",
                  dynamicSubtitleAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  enableAddToInsights = _js2n__-prdslib.isType '"Bool",
                  enableLocaleCurrencyFormatting =
                    _js2n__-prdslib.isType '"Bool",
                  entitySet =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_]+$"
                        ],
                  identificationAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#,]*$"
                        ],
                  ignoreSapText = _js2n__-prdslib.isType '"Bool",
                  imageSupported = _js2n__-prdslib.isType '"Bool",
                  itemText =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\{\\{[^\\W\\.\\-][\\w\\.\\-]*\\}\\}$"
                        ],
                  kpiAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  listFlavor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "standard", "bar", "carousel" ]
                        ],
                  listType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "extended", "condensed" ]
                        ],
                  navigation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "dataPointNav",
                              "chartNav",
                              "headerNav",
                              "noHeaderNav"
                            ]
                        ],
                  objectStreamCardsSettings =
                    _js2n__-refsenv."_js2n__-:definitions/objectStreamCardsSettingsDef!predicate",
                  presentationAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  requireAppAuthorization = _js2n__-prdslib.isType '"String",
                  selectionAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  selectionPresentationAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  showFilterInHeader = _js2n__-prdslib.isType '"Bool",
                  showLabelText = _js2n__-prdslib.isType '"Bool",
                  showLineItemDetail = _js2n__-prdslib.isType '"Bool",
                  showRefresh = _js2n__-prdslib.isType '"Bool",
                  showSortingInHeader = _js2n__-prdslib.isType '"Bool",
                  sortBy = _js2n__-prdslib.isType '"String",
                  sortOrder =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ascending", "descending" ]
                        ],
                  staticContent =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Record)
                        ],
                  subTitle =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\{\\{[^\\W\\.\\-][\\w\\.\\-]*\\}\\}$"
                        ],
                  title =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\{\\{[^\\W\\.\\-][\\w\\.\\-]*\\}\\}$"
                        ],
                  valueSelectionInfo =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\{\\{[^\\W\\.\\-][\\w\\.\\-]*\\}\\}$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/closeButton!predicate"
        | doc "[Experimental] Represents attributes of the Close button"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/command!predicate"
        | doc "Represents a UI5 shortcut command."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  shortcut =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(([Cc][Tt][Rr][Ll]|[Ss][Hh][Ii][Ff][Tt]|[Aa][Ll][Tt])(\\+)?){0,3}([A-Za-z0-9\\.,\\-\\*\\/=]|[Pp][Ll][Uu][Ss]|[Tt][Aa][Bb]|[Ss][Pp][Aa][Cc][Ee]|[Ee][Nn][Tt][Ee][Rr]|[Bb][Aa][Cc][Kk][Ss][Pp][Aa][Cc][Ee]|[Hh][Oo][Mm][Ee]|[Dd][Ee][Ll][Ee][Tt][Ee]|[Ee][Nn][Dd]|[Pp][Aa][Gg][Ee][Uu][Pp]|[Pp][Aa][Gg][Ee][Dd][Oo][Ww][Nn]|[Ee][Ss][Cc][Aa][Pp][Ee]|[Aa][Rr][Rr][Oo][Ww][Uu][Pp]|[Aa][Rr][Rr][Oo][Ww][Dd][Oo][Ww][Nn]|[Aa][Rr][Rr][Oo][Ww][Ll][Ee][Ff][Tt]|[Aa][Rr][Rr][Oo][Ww][Rr][Ii][Gg][Hh][Tt]|F[1-9]|F1[0-2])$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/component!predicate"
        | doc "Represents sapui5 component name"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  lazy = _js2n__-prdslib.isType '"Bool",
                  minVersion =
                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/componentUsages!predicate"
        | doc "Represents component name for usage"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  componentData =
                    _js2n__-refsenv."_js2n__-:definitions/config!predicate",
                  lazy = _js2n__-prdslib.isType '"Bool",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([a-zA-Z_$][a-zA-Z0-9_$]{0,39}\\.)*([a-zA-Z_$][a-zA-Z0-9_$]{0,39})$"
                        ],
                  settings =
                    _js2n__-refsenv."_js2n__-:definitions/config!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/component_binding_def!predicate"
        | doc " Represents a binding string to indicate, how the reuse component should be bound relative to the containing page or absolute "
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/component_def!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  list = _js2n__-prdslib.isType '"Bool",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([a-zA-Z][a-zA-Z0-9]{0,39})(\\.[a-zA-Z][a-zA-Z0-9]{0,39})*$"
                        ],
                  settings =
                    _js2n__-refsenv."_js2n__-:definitions/component_setting_def!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/component_pages_def!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z0-9_\\.\\-]+[\\|]?[a-zA-Z0-9_\\.\\-]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/pages_map!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/component_setting_def!predicate"
        | doc "Represents the settings specific to one component"
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/config!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/config!predicate"
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType 'Record
            ],
      "_js2n__-:definitions/contentitem!contract"
        | doc "Represents an item of the content list defining the sub manifest and baseurl"
        = {
            baseURL
              | String
              | doc "Relative url to the artifact within the folder in this package"
              | optional,
            manifest
              | {
                "sap.artifact"
                  | {  .. }
                  | doc "The artifacts manifest"
                  | optional,
                ..
              }
              | doc "Wraps the child manifest"
              | optional,
            ..
          },
      "_js2n__-:definitions/customActionParameters!predicate"
        | doc "Parameters for Custom action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/customActionsSetting!predicate"
        | doc "Represents the properties for the custom actions in the Quick View Cards"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  position = _js2n__-prdslib.isType 'Integer,
                  press =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[^\\W\\.\\-][\\w\\.\\-]*$"
                        ],
                  text =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^\\{\\{[^\\W\\.\\-][\\w\\.\\-]*\\}\\}$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/data!predicate"
        | doc "Represents request and response attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extension =
                    _js2n__-refsenv."_js2n__-:definitions/extension!predicate",
                  json =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType '"Array"
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  mockData =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              extension =
                                _js2n__-refsenv."_js2n__-:definitions/extension!predicate",
                              json =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.isType '"Array"
                                        ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                              request =
                                _js2n__-refsenv."_js2n__-:definitions/request!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-/|@#]*$"
                        ],
                  request =
                    _js2n__-refsenv."_js2n__-:definitions/request!predicate",
                  service =
                    _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                  updateInterval =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dataSource!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/dataSourceEnum!predicate",
              _js2n__-refsenv."_js2n__-:definitions/dataSourceCustom!predicate"
            ],
      "_js2n__-:definitions/dataSourceCustom!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "customType", "uri" ],
              _js2n__-prdslib.records.record
                {
                  customType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.enum [ true ]
                        ],
                  settings =
                    _js2n__-refsenv."_js2n__-:definitions/setting!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.enum
                              [
                                "OData",
                                "ODataAnnotation",
                                "INA",
                                "XML",
                                "JSON",
                                "FHIR",
                                "WebSocket",
                                "http"
                              ]),
                          _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_\\-]+$"
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/dataSourceEnum!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "uri" ],
              _js2n__-prdslib.records.record
                {
                  customType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.enum [ false ]
                        ],
                  settings =
                    _js2n__-refsenv."_js2n__-:definitions/setting!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "OData",
                              "ODataAnnotation",
                              "INA",
                              "XML",
                              "JSON",
                              "FHIR",
                              "WebSocket",
                              "http"
                            ]
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/defaultLayoutType_def!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/defaultSpanDef!predicate"
        | doc "Represents the card default grid size in columns and rows"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "cols", "rows" ],
                  _js2n__-prdslib.records.record
                    {
                      cols = _js2n__-prdslib.isType 'Integer,
                      minimumSubTitleRow =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.strings.pattern "^[12]$"
                            ],
                      minimumTitleRow =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.strings.pattern "^[1-3]$"
                            ],
                      rows = _js2n__-prdslib.isType 'Integer,
                      showOnlyHeader = _js2n__-prdslib.isType '"Bool",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "auto" ]
                ]
            ],
      "_js2n__-:definitions/definingRequest!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "dataSource", "path" ],
              _js2n__-prdslib.records.record
                {
                  dataSource = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  retrieveStreams = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/deviceType!predicate"
        | doc "Represents device types on which the app is running"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  desktop = _js2n__-prdslib.isType '"Bool",
                  phone = _js2n__-prdslib.isType '"Bool",
                  tablet = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/embeddedComponent!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z0-9_.:-]+$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "id", "title" ],
                              _js2n__-prdslib.records.record
                                {
                                  binding = _js2n__-prdslib.isType '"String",
                                  groupTitle = _js2n__-prdslib.isType '"String",
                                  hiddenByDefault = _js2n__-prdslib.always,
                                  id =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^([A-Za-z_][-A-Za-z0-9_.:]*)$"
                                        ],
                                  leadingSectionIdOrPath =
                                    _js2n__-prdslib.isType '"String",
                                  settings = _js2n__-prdslib.isType 'Record,
                                  title =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^\\{\\{[^\\W][\\w\\.\\-]*\\}\\}$"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "componentName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      componentName =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^([a-zA-Z][a-zA-Z0-9_]{0,39})(\\.[a-zA-Z][a-zA-Z0-9_]{0,39})*$"
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "componentUsage" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      componentUsage =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "embeddedComponents" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      embeddedComponents =
                                        _js2n__-refsenv."_js2n__-:definitions/embeddedComponent!predicate",
                                    } {} true _js2n__-prdslib.always
                                ]
                            ]
                        ],
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/embedsSettings!contract"
        | doc "Represents the embeds settings"
        = {
            "default"
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_]+$"
                  ])
              | doc "Represents the detault card"
              | optional,
            manifests
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {}
                      {
                        "^[a-zA-Z0-9_]+$" =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/manifestSettings!predicate"
                              ],
                      } true _js2n__-prdslib.always
                  ])
              | optional,
            ..
          },
      "_js2n__-:definitions/enhanceWithSetting!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required [ "bundleUrl" ],
                  _js2n__-prdslib.records.record
                    {
                      bundleUrl = _js2n__-prdslib.isType '"String",
                      bundleUrlRelativeTo =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "manifest", "component" ]
                            ],
                      fallbackLocale = _js2n__-prdslib.isType '"String",
                      supportedLocales = _js2n__-prdslib.isType '"Array",
                      terminologies =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9_\\-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                                } false _js2n__-prdslib.never
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required [ "bundleName" ],
                  _js2n__-prdslib.records.record
                    {
                      bundleName = _js2n__-prdslib.isType '"String",
                      fallbackLocale = _js2n__-prdslib.isType '"String",
                      supportedLocales = _js2n__-prdslib.isType '"Array",
                      terminologies =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9_\\-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                                } false _js2n__-prdslib.never
                            ],
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/extension!predicate"
        | doc "[Experimental] Represents attributes, needed to get data via extension"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "method" ],
              _js2n__-prdslib.records.record
                {
                  args = _js2n__-prdslib.isType '"Array",
                  method = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/field!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  label =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  value = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/filterFieldName!predicate"
        | doc "Represents the configuration object for each date filter field"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customDateRangeImplementation =
                    _js2n__-prdslib.isType '"String",
                  defaultValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { operation = _js2n__-prdslib.isType '"String", } {}
                            true _js2n__-prdslib.always
                        ],
                  exclude = _js2n__-prdslib.isType '"Bool",
                  selectedValues = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/group!predicate"
        | doc "Represents group of items"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  order =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dir =
                                _js2n__-prdslib.oneOf
                                    [ _js2n__-prdslib.enum [ "ASC", "DESC" ] ],
                              path = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  title = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/hideCardActionParameters!predicate"
        | doc "Parameters for HideCard action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/i18n_key_string!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.anyOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^\\{\\{[\\w][\\w\\.\\-]*\\}\\}$"
                  ],
                _js2n__-prdslib.isType '"String"
              ]),
      "_js2n__-:definitions/i18n_key_string!predicate" =
        _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^\\{\\{[\\w][\\w\\.\\-]*\\}\\}$"
                ],
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/ibnTarget!predicate"
        | doc "The application identifier consisting of semanticObject and action or "
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "action", "semanticObject" ],
              _js2n__-prdslib.records.record
                {
                  action = _js2n__-prdslib.isType '"String",
                  semanticObject = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/icon!predicate"
        | doc "Represents icon attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alt = _js2n__-prdslib.isType '"String",
                  backgroundColor =
                    _js2n__-refsenv."_js2n__-:definitions/iconBackgroundColor!predicate",
                  initials = _js2n__-prdslib.isType '"String",
                  shape =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Square", "Circle" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  size =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.enum [ "XS", "S", "M" ],
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  src = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/iconBackgroundColor!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.enum
                [
                  "Accent1",
                  "Accent2",
                  "Accent3",
                  "Accent4",
                  "Accent5",
                  "Accent6",
                  "Accent7",
                  "Accent8",
                  "Accent9",
                  "Accent10",
                  "Placeholder",
                  "Random",
                  "TileIcon",
                  "Transparent"
                ],
              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
            ],
      "_js2n__-:definitions/iconWithoutSize!predicate"
        | doc "Represents icon attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alt = _js2n__-prdslib.isType '"String",
                  backgroundColor =
                    _js2n__-refsenv."_js2n__-:definitions/iconBackgroundColor!predicate",
                  initials = _js2n__-prdslib.isType '"String",
                  shape =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Square", "Circle" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  src = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/id_def!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 70
            ],
      "_js2n__-:definitions/iddef!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.maxLength 70,
                _js2n__-prdslib.strings.pattern "^[A-Za-z]{2,}.[A-Za-z]{2,}"
              ]),
      "_js2n__-:definitions/identifier!predicate"
        | doc "Represents identifier"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      target =
                        _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                      url = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/implementingComponent_def!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "componentName" ],
                  _js2n__-prdslib.records.record
                    {
                      binding =
                        _js2n__-refsenv."_js2n__-:definitions/component_binding_def!predicate",
                      componentName =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^([a-zA-Z][a-zA-Z0-9_]{0,39})(\\.[a-zA-Z][a-zA-Z0-9_]{0,39})*$"
                            ],
                      pages =
                        _js2n__-refsenv."_js2n__-:definitions/component_pages_def!predicate",
                      settings =
                        _js2n__-refsenv."_js2n__-:definitions/component_setting_def!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "componentUsage" ],
                  _js2n__-prdslib.records.record
                    {
                      binding =
                        _js2n__-refsenv."_js2n__-:definitions/component_binding_def!predicate",
                      componentUsage = _js2n__-prdslib.isType '"String",
                      pages =
                        _js2n__-refsenv."_js2n__-:definitions/component_pages_def!predicate",
                      settings =
                        _js2n__-refsenv."_js2n__-:definitions/component_setting_def!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/inbound!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[\\w\\.\\-]+$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "action", "semanticObject" ],
                          _js2n__-prdslib.records.record
                            {
                              action =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[\\w\\*]{0,60}$"
                                    ],
                              deviceTypes =
                                _js2n__-refsenv."_js2n__-:definitions/deviceType!predicate",
                              displayMode =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "ContentMode", "HeaderMode" ]
                                    ],
                              hideLauncher = _js2n__-prdslib.isType '"Bool",
                              icon = _js2n__-prdslib.isType '"String",
                              indicatorDataSource =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "dataSource", "path" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          dataSource =
                                            _js2n__-prdslib.isType '"String",
                                          path =
                                            _js2n__-prdslib.isType '"String",
                                          refresh =
                                            _js2n__-prdslib.isType '"Number",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              info =
                                _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                              semanticObject =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[\\w\\*]{0,30}$"
                                    ],
                              shortTitle =
                                _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                              signature =
                                _js2n__-refsenv."_js2n__-:definitions/signature_def!predicate",
                              subTitle =
                                _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                              title =
                                _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/infolink!contract"
        | doc "Represents a link information with text and url"
        = {
            text | String | doc "Represents a descriptive text for the target",
            url | String | doc "Represents a target url",
            ..
          },
      "_js2n__-:definitions/legacyTargetAddition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "viewName" ],
              _js2n__-prdslib.records.record
                {
                  viewId = _js2n__-prdslib.isType '"String",
                  viewLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1
                        ],
                  viewName = _js2n__-prdslib.isType '"String",
                  viewPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/legacyTargetAdditionWithoutRequiredProp!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  viewId = _js2n__-prdslib.isType '"String",
                  viewLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1
                        ],
                  viewName = _js2n__-prdslib.isType '"String",
                  viewPath = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/levelsDef!predicate"
        | doc "Plot area is a parent property which defines multiple other properties for smoothness and marker size"
        = _js2n__-prdslib.isType '"Array",
      "_js2n__-:definitions/lib!predicate"
        | doc "Represents sapui5 library name"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  lazy = _js2n__-prdslib.isType '"Bool",
                  minVersion =
                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/manifestSettings!predicate"
        | doc "Represents the manifest settings"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { localUri = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/minHeight!predicate"
        | doc "Defines the min-height of the Content as a CSS value"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/minUI5Version!predicate" =
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
      "_js2n__-:definitions/model!predicate"
        | doc "Represents sapui5 model name"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataSource = _js2n__-prdslib.isType '"String",
                  preload = _js2n__-prdslib.isType '"Bool",
                  settings =
                    _js2n__-refsenv."_js2n__-:definitions/ui5setting!predicate",
                  type = _js2n__-prdslib.isType '"String",
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/navigationActionIBParameters!predicate"
        | doc "Parameters for Intent-Based Navigation action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ibnTarget" ],
              _js2n__-prdslib.records.record
                {
                  ibnAppSpecificRoute = _js2n__-prdslib.isType '"String",
                  ibnParams = _js2n__-prdslib.isType 'Record,
                  ibnTarget =
                    _js2n__-refsenv."_js2n__-:definitions/ibnTarget!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/navigationActionParameters!predicate"
        | doc "Parameters for Navigation action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  target = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/navigation_def!predicate"
        | doc "Represents ..."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record
                {
                  create =
                    _js2n__-refsenv."_js2n__-:definitions/action_prop_def!predicate",
                  display =
                    _js2n__-refsenv."_js2n__-:definitions/action_prop_def!predicate",
                  edit =
                    _js2n__-refsenv."_js2n__-:definitions/action_prop_def!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/objectName!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 50,
              _js2n__-prdslib.strings.minLength 3,
              _js2n__-prdslib.strings.pattern
                "^(\\\\[0-9a-zA-Z_]+\\\\)?[a-zA-Z][a-zA-Z0-9_]*$"
            ],
      "_js2n__-:definitions/objectStreamCardsSettingsDef!predicate"
        | doc "Represents the Object Stream properties - properties that are passed to the Object Stream cards"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customActions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/customActionsSetting!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  showFirstActionInFooter = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/objectType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "query", "cdsprojectionview", "view", "inamodel" ]
            ],
      "_js2n__-:definitions/openSource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  packagedWithMySelf = _js2n__-prdslib.isType '"Bool",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/outbound!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[\\w\\.\\-]+$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "action", "semanticObject" ],
                          _js2n__-prdslib.records.record
                            {
                              action =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[\\w\\*]{0,60}$"
                                    ],
                              additionalParameters =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "notallowed", "ignored", "allowed" ]
                                    ],
                              parameters =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          "^[\\w\\.\\-\\/]+$" =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      required =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      value =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  format =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.enum
                                                                            [
                                                                              "plain",
                                                                              "regexp",
                                                                              "reference",
                                                                              "binding"
                                                                            ]
                                                                        ],
                                                                  value =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                        } false _js2n__-prdslib.never
                                    ],
                              semanticObject =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^[\\w\\*]{0,30}$"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pages_array!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "component" ],
              _js2n__-prdslib.records.record
                {
                  component =
                    _js2n__-refsenv."_js2n__-:definitions/component_def!predicate",
                  defaultLayoutType =
                    _js2n__-refsenv."_js2n__-:definitions/defaultLayoutType_def!predicate",
                  defaultLayoutTypeIfExternalNavigation =
                    _js2n__-refsenv."_js2n__-:definitions/defaultLayoutType_def!predicate",
                  embeddedComponents =
                    _js2n__-refsenv."_js2n__-:definitions/embeddedComponent!predicate",
                  entitySet = _js2n__-prdslib.isType '"String",
                  implementingComponent =
                    _js2n__-refsenv."_js2n__-:definitions/implementingComponent_def!predicate",
                  navigation =
                    _js2n__-refsenv."_js2n__-:definitions/navigation_def!predicate",
                  navigationProperty = _js2n__-prdslib.isType '"String",
                  pages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/pages_array!predicate"
                        ],
                  routingSpec =
                    _js2n__-refsenv."_js2n__-:definitions/routingSpec_def!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/pages_map!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "component" ],
              _js2n__-prdslib.records.record
                {
                  component =
                    _js2n__-refsenv."_js2n__-:definitions/component_def!predicate",
                  defaultLayoutType =
                    _js2n__-refsenv."_js2n__-:definitions/defaultLayoutType_def!predicate",
                  defaultLayoutTypeIfExternalNavigation =
                    _js2n__-refsenv."_js2n__-:definitions/defaultLayoutType_def!predicate",
                  embeddedComponents =
                    _js2n__-refsenv."_js2n__-:definitions/embeddedComponent!predicate",
                  entitySet = _js2n__-prdslib.isType '"String",
                  implementingComponent =
                    _js2n__-refsenv."_js2n__-:definitions/implementingComponent_def!predicate",
                  navigation =
                    _js2n__-refsenv."_js2n__-:definitions/navigation_def!predicate",
                  navigationProperty = _js2n__-prdslib.isType '"String",
                  pages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[a-zA-Z0-9_\\.\\-]+[\\|]?[a-zA-Z0-9_\\.\\-]+$" =
                                _js2n__-refsenv."_js2n__-:definitions/pages_map!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  routingSpec =
                    _js2n__-refsenv."_js2n__-:definitions/routingSpec_def!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/plotAreaDef!predicate"
        | doc "Plot area is a parent property which defines multiple other properties for smoothness and marker size"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dataLabel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "value", "percentage" ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  isSmoothed = _js2n__-prdslib.isType '"Bool",
                  markerSize = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/progressIndicator!predicate"
        | doc "Represents progress indicator attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  percent =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  state =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/state!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/refreshStrategies_prop_def!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { entitySets = _js2n__-prdslib.isType 'Record, } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/request!predicate"
        | doc "Represents request attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  batch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/batchRequest!predicate"
                        ],
                  cache =
                    _js2n__-refsenv."_js2n__-:definitions/cache!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum
                                [
                                  "GET",
                                  "POST",
                                  "PUT",
                                  "PATCH",
                                  "DELETE",
                                  "OPTIONS",
                                  "HEAD"
                                ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum
                                [ "no-cors", "same-origin", "cors" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  parameters = _js2n__-prdslib.isType 'Record,
                  retryAfter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  withCredentials =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/resizableLayoutVariant!predicate"
        | doc "Represents the resizable layout variant"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-zA-Z0-9_\\.\\-]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/resizableLayoutVariantCardProperties!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/resizableLayoutVariantCardProperties!predicate"
        | doc "Represents the card properties is a layout variant"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "col", "colSpan", "row", "rowSpan" ],
              _js2n__-prdslib.records.record
                {
                  col = _js2n__-prdslib.isType 'Integer,
                  colSpan = _js2n__-prdslib.isType 'Integer,
                  row = _js2n__-prdslib.isType 'Integer,
                  rowSpan = _js2n__-prdslib.isType 'Integer,
                  visible = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/resource!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  css =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "uri" ],
                                _js2n__-prdslib.records.record
                                  {
                                    id = _js2n__-prdslib.isType '"String",
                                    uri = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  js =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "uri" ],
                                _js2n__-prdslib.records.record
                                  { uri = _js2n__-prdslib.isType '"String", } {}
                                  true _js2n__-prdslib.always
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/resourceRoot!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^((\\.(?!\\.)\\/)?\\w+\\/?)+$"
            ],
      "_js2n__-:definitions/rootView_def!predicate"
        | doc "Represents the root view definition being either the name of the view or the view definition object"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "viewName" ],
                  _js2n__-prdslib.records.record
                    {
                      async = _js2n__-prdslib.isType '"Bool",
                      id = _js2n__-prdslib.isType '"String",
                      type =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "XML", "JSON", "JS", "HTML", "Template" ]
                            ],
                      viewName = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/rootView_def_flexEnabled!predicate"
        | doc "Represents the root view definition when flex is enabled (requires a view id)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "viewName" ],
              _js2n__-prdslib.records.record
                {
                  async = _js2n__-prdslib.isType '"Bool",
                  id = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "XML", "JSON", "JS", "HTML", "Template" ]
                        ],
                  viewName = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/route!predicate"
        | doc "Represents the definition of each route"
        = _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/routeWithoutName!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    { name = _js2n__-prdslib.isType '"String", } {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/routeTarget!predicate"
        | doc "Represents the definition of a target of a route."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.items
                    [
                      _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/routeTargetObject!predicate"
                        ]
                    ]
                ],
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/routeTargetObject!predicate"
            ],
      "_js2n__-:definitions/routeTargetObject!predicate"
        | doc "Represents the definition of a target of a route as object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  prefix = _js2n__-prdslib.isType '"String",
                  propagateTitle = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/routeWithoutName!predicate"
        | doc "Represents the definition of route without the option 'name'. This is used when routes are defined in an object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  greedy = _js2n__-prdslib.isType '"Bool",
                  pattern = _js2n__-prdslib.isType '"String",
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/routeTarget!predicate",
                  titleTarget = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/routing!predicate"
        | doc "Represents the configuration of routing"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  async = _js2n__-prdslib.isType '"Bool",
                                  bypassed =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "target" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              target =
                                                _js2n__-refsenv."_js2n__-:definitions/routeTarget!predicate",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                  propagateTitle =
                                    _js2n__-prdslib.isType '"Bool",
                                  routerClass =
                                    _js2n__-prdslib.isType '"String",
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/legacyTargetAdditionWithoutRequiredProp!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/actualTargetAdditionStandardWithoutRequiredProp!predicate"
                        ],
                  routes =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/route!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "[\\s\\S]*" =
                                    _js2n__-refsenv."_js2n__-:definitions/routeWithoutName!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  targets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "[\\s\\S]*" =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                                          _js2n__-refsenv."_js2n__-:definitions/legacyTargetAddition!predicate"
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                                          _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-refsenv."_js2n__-:definitions/actualTargetAdditionStandard!predicate",
                                              _js2n__-refsenv."_js2n__-:definitions/actualTargetAdditionComponentUsage!predicate"
                                            ]
                                        ]
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/routingSpec_def!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "routeName" ],
              _js2n__-prdslib.records.record
                {
                  binding = _js2n__-prdslib.isType '"String",
                  headerTitle = _js2n__-prdslib.isType '"String",
                  noKey = _js2n__-prdslib.isType '"Bool",
                  noOData = _js2n__-prdslib.isType '"Bool",
                  routeName = _js2n__-prdslib.isType '"String",
                  semanticKey = _js2n__-prdslib.isType '"String",
                  typeImageUrl = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/routing_flexEnabled!predicate"
        | doc "Represents the configuration of routing"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  async = _js2n__-prdslib.isType '"Bool",
                                  bypassed =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "target" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              target =
                                                _js2n__-refsenv."_js2n__-:definitions/routeTarget!predicate",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                  routerClass =
                                    _js2n__-prdslib.isType '"String",
                                  viewPath = _js2n__-prdslib.isType '"String",
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/target!predicate"
                        ],
                  routes =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/route!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "[\\s\\S]*" =
                                    _js2n__-refsenv."_js2n__-:definitions/routeWithoutName!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  targets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "[\\s\\S]*" =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "viewId", "viewName" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  viewId =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  viewName =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  viewPath =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-refsenv."_js2n__-:definitions/target!predicate",
                                          _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "id", "name" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      name =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      path =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "View",
                                                                  "Component"
                                                                ]
                                                            ],
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "id", "type", "usage" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      id =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      type =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ "Component" ]
                                                            ],
                                                      usage =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ]
                                            ]
                                        ]
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/semanticversion!contract"
        | doc "The version number of the schema in major.minor.patch format."
        = _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^[0-9]{1,}.[0-9]{1,}.[0-9]{1,}$"
              ]),
      "_js2n__-:definitions/service!predicate"
        | doc "Represents the definition of each service"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "factoryName" ],
              _js2n__-prdslib.records.record
                {
                  factoryName =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([a-z_$][a-z0-9_$]{0,39}\\.)*([a-zA-Z_$][a-zA-Z0-9_$]{0,39})$"
                        ],
                  "optional" = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/setting!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ignoreAnnotationsFromMetadata =
                    _js2n__-prdslib.isType '"Bool",
                  localUri = _js2n__-prdslib.isType '"String",
                  maxAge =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1
                        ],
                  objects =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "objectName", "objectType" ],
                                _js2n__-prdslib.records.record
                                  {
                                    objectName =
                                      _js2n__-refsenv."_js2n__-:definitions/objectName!predicate",
                                    objectType =
                                      _js2n__-refsenv."_js2n__-:definitions/objectType!predicate",
                                    packageName =
                                      _js2n__-prdslib.isType '"String",
                                    schemaName =
                                      _js2n__-prdslib.isType '"String",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  odataVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "2.0", "4.0" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/setting_def!contract"
        | doc "Represents global settings for the application controller"
        = {  .. },
      "_js2n__-:definitions/showCardActionParameters!predicate"
        | doc "Parameters for ShowCard action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "manifest" ],
              _js2n__-prdslib.records.record
                {
                  baseUrl = _js2n__-prdslib.isType '"String",
                  data = _js2n__-prdslib.isType 'Record,
                  manifest =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                  parameters = _js2n__-prdslib.isType 'Record,
                  resizable =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                        ],
                  width = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/signature_def!predicate"
        | doc "Represents signature for inbound targets "
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "additionalParameters", "parameters" ],
              _js2n__-prdslib.records.record
                {
                  additionalParameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "ignored", "allowed", "notallowed" ]
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[\\w\\.\\-\\/]+$" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          defaultValue =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          format =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [ "plain" ]
                                                                ],
                                                          value =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} true
                                                        _js2n__-prdslib.always,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          format =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "reference"
                                                                    ]
                                                                ],
                                                          value =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(User[.]env|UserDefault(.extended)?)[.][^.]+$"
                                                                ],
                                                        } {} true
                                                        _js2n__-prdslib.always,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          format =
                                                            _js2n__-prdslib.isType
                                                                'Null,
                                                          value =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                                  _js2n__-prdslib.records.required
                                                    [ "value" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      format =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "plain",
                                                                  "reference"
                                                                ]
                                                            ],
                                                      value =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          filter =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "value" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      format =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "plain",
                                                                  "regexp",
                                                                  "reference"
                                                                ]
                                                            ],
                                                      value =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          launcherValue =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      format =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [
                                                                  "plain",
                                                                  "array"
                                                                ]
                                                            ],
                                                      prompt =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      value =
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
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          renameTo =
                                            _js2n__-prdslib.isType '"String",
                                          required =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} false _js2n__-prdslib.never
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/simpleBinding!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "\\{.*\\}"
            ],
      "_js2n__-:definitions/simpleIcon!predicate"
        | doc "Represents simple icon attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  src = _js2n__-prdslib.isType '"String",
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/state!predicate"
        | doc "Represents state of an entity"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "Error", "Success", "Warning", "None", "Information" ]
            ],
      "_js2n__-:definitions/status!predicate"
        | doc "Represents status attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  text =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/statusTextFormatter!predicate"
                        ],
                  visible =
                    _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/statusTextFormatter!predicate"
        | doc "Defines fields for dynamic status formatting"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  format =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              parts = _js2n__-prdslib.isType '"Array",
                              translationKey = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/submitActionParameters!predicate"
        | doc "Parameters for Submit action"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/tab_setting!predicate"
        | doc "Represents the tab specific properties - properties that are passed to a particular tab in a card"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  chartAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  chartProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              plotArea =
                                _js2n__-refsenv."_js2n__-:definitions/plotAreaDef!predicate",
                              timeAxis =
                                _js2n__-refsenv."_js2n__-:definitions/timeAxisDef!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  colorPalette =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Record)
                            ],
                          _js2n__-prdslib.isType 'Record
                        ],
                  dataPointAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  dynamicSubtitleAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  identificationAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  presentationAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  selectionAnnotationPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@#]*$"
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tag!contract" =
        Array _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!contract",
      "_js2n__-:definitions/tag!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            ],
      "_js2n__-:definitions/target!predicate"
        | doc "Represents the definition of each target"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  clearControlAggregation = _js2n__-prdslib.isType '"Bool",
                  controlAggregation = _js2n__-prdslib.isType '"String",
                  controlId = _js2n__-prdslib.isType '"String",
                  parent = _js2n__-prdslib.isType '"String",
                  targetParent = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  transition =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "slide", "flip", "fade", "show" ]
                            ]
                        ],
                  transitionParameters = _js2n__-prdslib.isType 'Record,
                  viewType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "XML", "JSON", "JS", "HTML", "Template" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/terminologySetting!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required [ "bundleName" ],
                  _js2n__-prdslib.records.record
                    {
                      bundleName = _js2n__-prdslib.isType '"String",
                      supportedLocales = _js2n__-prdslib.isType '"Array",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.records.required [ "bundleUrl" ],
                  _js2n__-prdslib.records.record
                    {
                      bundleUrl = _js2n__-prdslib.isType '"String",
                      bundleUrlRelativeTo =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "manifest", "component" ]
                            ],
                      supportedLocales = _js2n__-prdslib.isType '"Array",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/textAlign!predicate"
        | doc "Represents options for text alignments"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "Begin", "Center", "End", "Initial", "Left", "Right" ]
            ],
      "_js2n__-:definitions/timeAxisDef!predicate"
        | doc "Represents the configuration to customize the time axis"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  levels =
                    _js2n__-refsenv."_js2n__-:definitions/levelsDef!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ui5setting!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundleName = _js2n__-prdslib.isType '"String",
                  bundleUrl = _js2n__-prdslib.isType '"String",
                  bundleUrlRelativeTo =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "manifest", "component" ]
                        ],
                  defaultBindingMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Default", "OneTime", "OneWay", "TwoWay" ]
                        ],
                  enhanceWith =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-refsenv."_js2n__-:definitions/enhanceWithSetting!predicate"
                              ])
                        ],
                  fallbackLocale = _js2n__-prdslib.isType '"String",
                  supportedLocales = _js2n__-prdslib.isType '"Array",
                  terminologies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[a-zA-Z0-9_\\-]*$" =
                                _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                            } true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vendor!contract"
        | doc "Represents the vendor information"
        = {
            id | String | doc "Represents the vendor id",
            lineOfBusiness
              | String
              | doc "Represents the vendor line of business within the vendors organization if any"
              | optional,
            name | String | doc "Represents the vendor name",
            url | String | doc "Represents a target url",
            ..
          },
      "_js2n__-:definitions/version!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/visibility!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
            ],
      "_js2n__-:definitions/wrappingType!predicate"
        | doc "The wrapping type for texts"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.enum [ "Normal", "Hyphenated" ],
                  _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                ]
            ],
    }
    in
  {
      "$schema"
        | String
        | doc "The resource identifier for the JSON schema to be used. The value of this keyword MUST be a URI [RFC3986] (containing a scheme) and this URI MUST be normalized. The current schema MUST be valid against the meta-schema identified by this URI. If this URI identifies a retrievable resource, that resource SHOULD be of media type \"application/schema+json\"."
        | optional,
      _version
        | std.enum.TagOrString
        | [|
          '"1.64.0",
          '"1.63.0",
          '"1.62.0",
          '"1.61.0",
          '"1.60.0",
          '"1.59.0",
          '"1.58.0",
          '"1.57.0",
          '"1.56.0",
          '"1.55.0",
          '"1.54.0",
          '"1.53.0",
          '"1.52.0",
          '"1.51.0",
          '"1.50.0",
          '"1.49.0",
          '"1.48.0",
          '"1.47.0",
          '"1.46.0",
          '"1.45.0",
          '"1.44.0",
          '"1.43.0",
          '"1.42.0",
          '"1.41.0",
          '"1.40.0",
          '"1.39.0",
          '"1.38.0",
          '"1.37.0",
          '"1.36.0",
          '"1.35.0",
          '"1.34.0",
          '"1.33.0",
          '"1.32.0",
          '"1.31.0",
          '"1.30.0",
          '"1.29.0",
          '"1.28.0",
          '"1.27.0",
          '"1.26.0",
          '"1.25.0",
          '"1.24.0",
          '"1.23.0",
          '"1.22.0",
          '"1.21.0",
          '"1.20.0",
          '"1.19.0",
          '"1.18.0",
          '"1.17.0",
          '"1.16.0",
          '"1.15.0",
          '"1.14.0",
          '"1.13.0",
          '"1.12.0",
          '"1.11.0",
          '"1.10.0",
          '"1.9.0",
          '"1.8.0",
          '"1.7.0",
          '"1.6.0",
          '"1.5.0",
          '"1.4.0",
          '"1.3.0",
          '"1.2.0",
          '"1.1.0"
        |]
        | doc "Represents Application Descriptor format version. It is managed by schema owner",
      "sap.apf"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          activateFilterReduction
            | Bool
            | doc "Represents a switch to activate filter reduction so that filters in OData requests can be represented as ABAP select options"
            | optional,
          activateLrep
            | Bool
            | doc "Represents a switch to activate LREP as the persistence for configurations and texts"
            | optional,
          useHeadRequestForXsrfToken
            | Bool
            | doc "Represents a switch to use HEAD-Requests instead of GET-Requests when fetching the XSRF-Security-Token"
            | optional,
        }
        | doc "Represents APF specific attributes"
        | optional,
      "sap.app"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "applicationVersion", "id", "title", "type" ],
              _js2n__-prdslib.records.record
                {
                  _version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "1.1.0",
                              "1.2.0",
                              "1.3.0",
                              "1.4.0",
                              "1.5.0",
                              "1.6.0",
                              "1.7.0",
                              "1.8.0",
                              "1.9.0",
                              "1.10.0",
                              "1.11.0",
                              "1.12.0",
                              "1.13.0",
                              "1.14.0",
                              "1.15.0",
                              "1.16.0",
                              "1.17.0",
                              "1.18.0",
                              "1.19.0",
                              "1.20.0",
                              "1.21.0"
                            ]
                        ],
                  ach =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([a-zA-Z0-9]{2,3})(-[a-zA-Z0-9]{1,6})*$"
                        ],
                  applicationVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "version" ],
                          _js2n__-prdslib.records.record
                            {
                              version =
                                _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  cdsViews =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  crossNavigation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "inbounds" ],
                          _js2n__-prdslib.records.record
                            {
                              inbounds =
                                _js2n__-refsenv."_js2n__-:definitions/inbound!predicate",
                              outbounds =
                                _js2n__-refsenv."_js2n__-:definitions/outbound!predicate",
                              scopes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          "^[a-zA-Z0-9_\\.\\-]+$" =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "value" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      value =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } false _js2n__-prdslib.never
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  dataSources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[a-zA-Z0-9_\\.\\-]*$" =
                                _js2n__-refsenv."_js2n__-:definitions/dataSource!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  destination =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "name" ],
                          _js2n__-prdslib.records.record
                            { name = _js2n__-prdslib.isType '"String", } {}
                            false _js2n__-prdslib.never
                        ],
                  embeddedBy = _js2n__-prdslib.isType '"String",
                  embeds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  i18n =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "bundleName" ],
                              _js2n__-prdslib.records.record
                                {
                                  bundleName = _js2n__-prdslib.isType '"String",
                                  enhanceWith =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-refsenv."_js2n__-:definitions/enhanceWithSetting!predicate"
                                              ])
                                        ],
                                  fallbackLocale =
                                    _js2n__-prdslib.isType '"String",
                                  supportedLocales =
                                    _js2n__-prdslib.isType '"Array",
                                  terminologies =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^[a-zA-Z0-9_\\-]*$" =
                                                _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                                            } false _js2n__-prdslib.never
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "bundleUrl" ],
                              _js2n__-prdslib.records.record
                                {
                                  bundleUrl = _js2n__-prdslib.isType '"String",
                                  bundleUrlRelativeTo =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "manifest", "component" ]
                                        ],
                                  enhanceWith =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-refsenv."_js2n__-:definitions/enhanceWithSetting!predicate"
                                              ])
                                        ],
                                  fallbackLocale =
                                    _js2n__-prdslib.isType '"String",
                                  supportedLocales =
                                    _js2n__-prdslib.isType '"Array",
                                  terminologies =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^[a-zA-Z0-9_\\-]*$" =
                                                _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                                            } false _js2n__-prdslib.never
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  id = _js2n__-refsenv."_js2n__-:definitions/id_def!predicate",
                  info =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  offline = _js2n__-prdslib.isType '"Bool",
                  openSourceComponents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/openSource!predicate"
                        ],
                  provider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "sfsf" ]
                        ],
                  resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "resources.json" ]
                        ],
                  shortTitle =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  sourceTemplate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "id", "version" ],
                          _js2n__-prdslib.records.record
                            {
                              id = _js2n__-prdslib.isType '"String",
                              toolsId = _js2n__-prdslib.isType '"String",
                              version = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                  subTitle =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "keywords" ],
                          _js2n__-prdslib.records.record
                            {
                              keywords =
                                _js2n__-refsenv."_js2n__-:definitions/tag!predicate",
                              technicalAttributes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^[A-Z0-9_\\-\\/]+$"
                                          ])
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  title =
                    _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "application", "component", "library", "card" ]
                        ],
                } {} false _js2n__-prdslib.never
            ])
        | doc "Represents general application attributes",
      "sap.artifact"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0", '"1.0.0" |]
            | doc "Represents SAP.ARTIFACT attributes format version. It is managed by namespace owner"
            | optional,
          artifactVersion
            | {
              version
                | _js2n__-refsenv."_js2n__-:definitions/semanticversion!contract",
              ..
            }
            | doc "Represents mandatory semantic version of the artifact",
          description
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a description; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'",
          i18n
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf [ _js2n__-prdslib.isType '"String" ])
            | doc "Represents path inside the artifact to the properties file containing text symbols for the artifacts texts"
            | optional,
          icon
            | String
            | doc "Represents icon name or source URL for the artifact"
            | optional,
          id
            | _js2n__-refsenv."_js2n__-:definitions/iddef!contract"
            | doc "Represents mandatory unique artifact identifier",
          info
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents additional information to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          shortTitle
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a shorter version of the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          subTitle
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a subtitle to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          tags
            | {
              keywords | _js2n__-refsenv."_js2n__-:definitions/tag!contract",
              technicalAttributes
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern "^[A-Z0-9_\\-\\/]+$"
                      ])
                )
                | optional,
              ..
            }
            | doc "Represents array of keywords used to find the artifact"
            | optional,
          title
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a title (mandatory); to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'",
          type
            | std.enum.TagOrString
            | [| 'workspace-template, 'workflow, 'card |]
            | doc "Represents type of an artifact and can be card, workflow, workspace-template",
          ..
        }
        | doc "Represents general artifact attributes."
        | optional,
      "sap.bpa.task"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "inputs", "outputs" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required
                [ "_version", "category", "outcomes" ],
              _js2n__-prdslib.records.record
                {
                  _version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "1.0.0", "1.1.0" ]
                        ],
                  category =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "standard", "approval" ]
                        ],
                  inputs = _js2n__-prdslib.always,
                  outcomes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "id", "label" ],
                                _js2n__-prdslib.records.record
                                  {
                                    id =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^[a-zA-Z0-9_]{1,60}$"
                                          ],
                                    label = _js2n__-prdslib.isType '"String",
                                    type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "positive",
                                                "negative",
                                                "neutral"
                                              ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]),
                          _js2n__-prdslib.arrays.maxItems 5,
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  outputs = _js2n__-prdslib.always,
                  preview =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { src = _js2n__-prdslib.isType '"String", } {} true
                            _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ])
        | doc "Represents SBPA Custom Task UI Attributes"
        | optional,
      "sap.card"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "List", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.List!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Analytical", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.Analytical!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "AnalyticsCloud", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.AnalyticsCloud!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Timeline", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.Timeline!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Table", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.Table!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Object", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.Object!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Component", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.Component!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Calendar", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.Calendar!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "AdaptiveCard", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.AdaptiveCard!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "WebPage", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      {
                        content =
                          _js2n__-refsenv."_js2n__-:definitions/ContentType.WebPage!predicate",
                      } {} true _js2n__-prdslib.always) _js2n__-prdslib.always
                ],
              _js2n__-prdslib.records.required [ "header", "type" ],
              _js2n__-prdslib.records.record
                {
                  _version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "1.1.0",
                              "1.2.0",
                              "1.3.0",
                              "1.4.0",
                              "1.5.0",
                              "1.6.0",
                              "1.7.0",
                              "1.8.0",
                              "1.9.0",
                              "1.10.0",
                              "1.11.0",
                              "1.13.0",
                              "1.14.0",
                              "1.15.0",
                              "1.16.0",
                              "1.17.0",
                              "1.18.0",
                              "1.19.0",
                              "1.20.0",
                              "1.21.0",
                              "1.22.0",
                              "1.23.0",
                              "1.24.0",
                              "1.25.0",
                              "1.26.0",
                              "1.27.0",
                              "1.28.0",
                              "1.29.0",
                              "1.30.0",
                              "1.31.0",
                              "1.32.0",
                              "1.33.0",
                              "1.34.0",
                              "1.35.0",
                              "1.36.0",
                              "1.37.0",
                              "1.38.0",
                              "1.39.0",
                              "1.40.0",
                              "1.41.0",
                              "1.42.0",
                              "1.43.0",
                              "1.44.0",
                              "1.45.0"
                            ]
                        ],
                  configuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              actionHandlers =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          submit =
                                            _js2n__-prdslib.isType 'Record,
                                        } {} false _js2n__-prdslib.never
                                    ],
                              componentData = _js2n__-prdslib.isType 'Record,
                              csrfTokens =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.CSRFToken!predicate"
                                    ],
                              destinations =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.Destinations!predicate"
                                    ],
                              editor = _js2n__-prdslib.isType '"String",
                              enableMarkdown = _js2n__-prdslib.isType '"Bool",
                              filters =
                                _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.oneOf
                                      [
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.FilterType.Select!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.FilterType.DateRange!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.FilterType.Search!predicate",
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.FilterType.ComboBox!predicate"
                                      ]),
                              helpId = _js2n__-prdslib.isType '"String",
                              messages =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.NoData!predicate"
                                    ],
                              modelSizeLimit =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                                    ],
                              parameters =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-refsenv."_js2n__-:definitions/Configuration.Parameter!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  content = _js2n__-prdslib.always,
                  data = _js2n__-refsenv."_js2n__-:definitions/data!predicate",
                  designtime = _js2n__-prdslib.isType '"String",
                  extension = _js2n__-prdslib.isType '"String",
                  footer =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              actionsStrip =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            _js2n__-refsenv."_js2n__-:definitions/actionsStripItem!predicate"
                                        ],
                                      _js2n__-refsenv."_js2n__-:definitions/actionsStrip!predicate"
                                    ],
                              paginator =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          pageSize =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                                                ],
                                          totalCount =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                                                ],
                                          visible =
                                            _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              visible =
                                _js2n__-refsenv."_js2n__-:definitions/visibility!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                  header =
                    _js2n__-refsenv."_js2n__-:definitions/HeaderType!predicate",
                  headerPosition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Top", "Bottom" ],
                              _js2n__-refsenv."_js2n__-:definitions/simpleBinding!predicate"
                            ]
                        ],
                  requiredHeight = _js2n__-prdslib.isType '"String",
                  requiredWidth = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "AdaptiveCard",
                              "Analytical",
                              "AnalyticsCloud",
                              "Calendar",
                              "Component",
                              "List",
                              "Object",
                              "Table",
                              "Timeline",
                              "WebPage"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ])
        | doc "Represents general card attributes"
        | optional,
      "sap.cards.ap"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.0.0" |]
            | doc "Represents attributes format version."
            | optional,
          embeds
            | {
              ObjectPage
                | _js2n__-refsenv."_js2n__-:definitions/embedsSettings!contract"
                | optional,
              ..
            }
            | doc "Represents an object with reference to the generated cards"
            | optional,
          ..
        }
        | doc "Represents generated cards saved to the application repository"
        | optional,
      "sap.cloud"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0", '"1.0.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          public
            | Bool
            | doc "Specify if the UI can be accessed from a different space than origin development space"
            | optional,
          service
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[^- @#$%^&()!]+$"
                ])
            | doc "Unique Business Service Identifier"
            | optional,
        }
        | doc "Represents cloud platform specific attributes"
        | optional,
      "sap.cloud.portal"
        | {  .. }
        | doc "Represents Cloud Portal specific attributes"
        | optional,
      "sap.copilot"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.1.0", '"1.0.0" |]
            | doc "Represents SAP.COPILOT attributes format version. It is managed by namespace owner"
            | optional,
          contextAnalysis
            | {
              allowAddingObjectsFromAppScreenToCollection
                | Bool
                | doc "Enable/Disable the ability for SAP CoPilot to analyze your Application Screens and add the found objects to a Collection"
                | optional,
              whitelistedEntityTypes
                | Array (String)
                | doc "A list of the whitelisted EntityTypes, prefixed with their namespace, that SAP CoPilot can display. The empty list is ignored, thus allowing all EntityTypes by default."
                | optional,
              ..
            }
            | doc "Settings for the context analysis features of SAP CoPilot"
            | optional,
          digitalAssistant
            | {
              intentDefinition
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9_\\.\\-]*$" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      dataSources =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      i18n = _js2n__-prdslib.isType '"String",
                                      uri = _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } false _js2n__-prdslib.never
                    ])
                | doc "A list of Intent"
                | optional,
              ..
            }
            | doc "Settings for the Digital Assistant features of SAP CoPilot"
            | optional,
          ..
        }
        | doc "Represents specific attributes for SAP CoPilot"
        | optional,
      "sap.fe"
        | {  .. }
        | doc "Represents specific attributes for Fiori Elements "
        | optional,
      "sap.fiori"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.3.0", '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          abstract
            | Bool
            | doc "Indicator that app is an abstract (generic) app which may not be used directly, but needs to be specialized in the SAP Fiori launchpad content"
            | optional,
          archeType
            | std.enum.TagOrString
            | [|
              'designstudio,
              'fpmwebdynpro,
              'reusecomponent,
              'factsheet,
              'analytical,
              'transactional
            |]
            | doc "Represents architecture type of an application. The supported types are transactional or analytical or factsheet or reusecomponent or fpmwebdynpro or designstudio",
          cloudDevAdaptationStatus
            | std.enum.TagOrString
            | [| 'obsolete, 'deprecated, 'released |]
            | doc "Represents the release status for the developer adaptation in the cloud (relevant for SAP internal only). The supported types are released, deprecated, obsolete, no value means not released"
            | optional,
          registrationIds
            | Array (String)
            | doc "Represents array of registration ids, i.e. for Fiori apps fiori id(s)",
        }
        | doc "Represents SAP Fiori  specific attributes"
        | optional,
      "sap.flp"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.3.0", '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          config
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "^[a-zA-Z0-9\\_\\.\\-]*$" =
                        _js2n__-prdslib.isType 'Record,
                    } false _js2n__-prdslib.never
                ])
            | doc "Represents configuration parameters of the FLP entry"
            | optional,
          origin
            | {
              targetMappingId
                | String
                | doc "Represents the original target mapping which resulted in this app"
                | optional,
              tileId
                | String
                | doc "Represents the original tile which resulted in this app"
                | optional,
            }
            | doc "Represents the original tile and target mapping which resulted in this app"
            | optional,
          tileSize
            | std.enum.TagOrString
            | [| '"1x2", '"1x1" |]
            | doc "Represents size of the tile"
            | optional,
          type
            | std.enum.TagOrString
            | [| 'plugin, 'tile, 'application |]
            | doc "Represents the type of FLP entry. It must be 'application' or 'tile' or 'plugin'",
        }
        | doc "Represents FLP specific attributes"
        | optional,
      "sap.gui"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          flavorId
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[A-F0-9]{1,32}$"
                ])
            | doc "Represents SAP Screen Personas Flavor ID"
            | optional,
          transaction
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9\\/_]{1,20}$"
                ])
            | doc "Represents transaction of an application",
        }
        | doc "Represents GUI specific attributes"
        | optional,
      "sap.insights"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.5.0", '"1.4.0", '"1.3.0", '"1.2.0", '"1.1.0", '"1.0.0" |]
            | optional,
          allowedChartTypes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.enum
                          [
                            "bar",
                            "column",
                            "line",
                            "bullet",
                            "vertical_bullet",
                            "100_stacked_bar",
                            "100_stacked_column",
                            "waterfall",
                            "horizontal_waterfall",
                            "area",
                            "radar",
                            "combination",
                            "stacked_bar",
                            "stacked_column",
                            "stacked_combination",
                            "horizontal_stacked_combination",
                            "pie",
                            "donut",
                            "dual_bar",
                            "dual_column",
                            "dual_line",
                            "dual_stacked_bar",
                            "dual_stacked_column",
                            "dual_combination",
                            "dual_horizontal_combination",
                            "dual_stacked_combination",
                            "dual_horizontal_stacked_combination",
                            "100_dual_stacked_bar",
                            "100_dual_stacked_column",
                            "scatter",
                            "heatmap",
                            "timeseries_column",
                            "timeseries_line",
                            "timeseries_scatter",
                            "timeseries_stacked_column",
                            "timeseries_100_stacked_column",
                            "timeseries_bullet",
                            "timeseries_waterfall",
                            "timeseries_stacked_combination"
                          ]
                      ])
                ])
            | doc "Array of all supported chart type allowed for transformation."
            | optional,
          cardType
            | std.enum.TagOrString
            | [| 'RT, 'DT |]
            | doc "Represents the environment type of Insights card",
          filterEntitySet
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_\\.\\-\\|@]*$"
                ])
            | doc "Represents the entity to use as global filter in the filter bar control"
            | optional,
          isDeletedForUser
            | Bool
            | doc "Represents the deleted state for a user"
            | optional,
          isDtCardCopy
            | Bool
            | doc "Represents the state of original or copied card"
            | optional,
          parentAppId
            | String
            | doc "Represents mandatory unique app identifier of the app containing self manifest.",
          rank
            | std.number.Integer
            | doc "Deprecated: Represents the display order of Insights card"
            | optional,
          ranking
            | String
            | doc "New property representing the display order of Insights card"
            | optional,
          templateName
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9_\\.\\-\\|@]*$"
                ])
            | doc "Represents the template name, from where manifest is generated"
            | optional,
          versions
            | {
              dtMiddleware
                | String
                | doc "Represents the version of design time card generator"
                | optional,
              ui5
                | String
                | doc "Represents the version of UI5 used to generate the card."
                | optional,
              ..
            }
            | doc "Represents UI5 and card generator middleware version."
            | optional,
          visible
            | Bool
            | doc "Represents the visibility type of Insights card"
            | optional,
        }
        | doc "Represents Insights attributes"
        | optional,
      "sap.integration"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.0.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          parameters
            | Array
              {
                key
                  | String
                  | doc "Represents the name of the desired parameter",
                value
                  | String
                  | doc "Represents the actual value of the desired parameter",
                ..
              }
            | doc "Represents configuration parameters which will be used by Template Engine to compile URL Template",
          urlTemplateId | String | doc "Reference to the desired URL Template",
          ..
        }
        | doc "Represents Application Integration specific attributes"
        | optional,
      "sap.map"
        | {  .. }
        | doc "Represents specific attributes for SAP.MAP  "
        | optional,
      "sap.mobile"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          definingRequests
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "^[a-zA-Z0-9_\\.\\-]*" =
                        _js2n__-refsenv."_js2n__-:definitions/definingRequest!predicate",
                    } false _js2n__-prdslib.never
                ])
            | doc "Represents mobile specific attributes",
          ..
        }
        | doc "Represents mobile specific attributes"
        | optional,
      "sap.ovp"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "cards" ],
              _js2n__-prdslib.records.record
                {
                  _version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "1.1.0",
                              "1.2.0",
                              "1.3.0",
                              "1.4.0",
                              "1.5.0",
                              "1.6.0",
                              "1.7.0",
                              "1.8.0",
                              "1.9.0",
                              "1.10.0",
                              "1.11.0"
                            ]
                        ],
                  bHeaderExpanded = _js2n__-prdslib.isType '"Bool",
                  cards =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^[a-zA-Z0-9_\\.\\-]+$" =
                                _js2n__-refsenv."_js2n__-:definitions/card!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  chartSettings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { showDataLabel = _js2n__-prdslib.isType '"Bool", }
                            {} true _js2n__-prdslib.always
                        ],
                  considerAnalyticalParameters = _js2n__-prdslib.isType '"Bool",
                  containerLayout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "fixed", "resizable" ]
                        ],
                  dataLoadSettings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              loadDataOnAppLaunch =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "always",
                                          "never",
                                          "ifAnyFilterExist"
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  disableErrorPage = _js2n__-prdslib.isType '"Bool",
                  disableTableCardFlexibility = _js2n__-prdslib.isType '"Bool",
                  enableLazyRendering = _js2n__-prdslib.isType '"Bool",
                  enableLiveFilter = _js2n__-prdslib.isType '"Bool",
                  filterSettings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dateSettings =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          exclude =
                                            _js2n__-prdslib.isType '"Bool",
                                          fields =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {}
                                                    {
                                                      "^[a-zA-Z0-9_\\.\\-]*$" =
                                                        _js2n__-refsenv."_js2n__-:definitions/filterFieldName!predicate",
                                                    } true
                                                    _js2n__-prdslib.always
                                                ],
                                          selectedValues =
                                            _js2n__-prdslib.isType '"String",
                                          useDateRange =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  globalFilterControlType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "MacroFilterBar", "SmartFilterBar" ]
                        ],
                  globalFilterEntitySet =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@]*$"
                        ],
                  globalFilterEntityType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@]*$"
                        ],
                  globalFilterModel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9_\\.\\-\\|@]*$"
                        ],
                  refreshIntervalInMinutes = _js2n__-prdslib.isType 'Integer,
                  refreshStrategyOnAppRestore =
                    _js2n__-refsenv."_js2n__-:definitions/refreshStrategies_prop_def!predicate",
                  resizableLayout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^cols_[0-9]+$" =
                                _js2n__-refsenv."_js2n__-:definitions/resizableLayoutVariant!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  showBasicSearch = _js2n__-prdslib.isType '"Bool",
                  showDateInRelativeFormat = _js2n__-prdslib.isType '"Bool",
                  smartVariantRequired = _js2n__-prdslib.isType '"Bool",
                  useDateRangeType = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never,
              _js2n__-prdslib.records.dependencies
                { globalFilterEntityType = [ "globalFilterModel" ], }
            ])
        | doc "Represents OVP specific attributes"
        | optional,
      "sap.package"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0", '"1.0.0" |]
            | doc "Represents SAP.PACKAGE attributes format version. It is managed by namespace owner"
            | optional,
          consumption
            | Array (String)
            | doc "Represents list of product ids that are allowed to consume this package. if not defined all products that are capable of installing this package are allowed"
            | optional,
          contents
            | Array _js2n__-refsenv."_js2n__-:definitions/contentitem!contract"
            | optional,
          dependencies
            | {
              products
                | Array (String)
                | doc "List of products that this package depends on"
                | optional,
              services
                | Array (String)
                | doc "List of services that this package depends on"
                | optional,
              ..
            }
            | doc "Represents the products and service that the pacakge depends on"
            | optional,
          description
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a description; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'",
          documentation
            | _js2n__-refsenv."_js2n__-:definitions/infolink!contract"
            | doc "Represents the documentation information"
            | optional,
          homepage
            | _js2n__-refsenv."_js2n__-:definitions/infolink!contract"
            | doc "Represents the homepage information"
            | optional,
          i18n
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf [ _js2n__-prdslib.isType '"String" ])
            | doc "Represents path inside the package to the properties file containing text symbols for the packages texts"
            | optional,
          icon
            | String
            | doc "Represents icon name or source URL for the package"
            | optional,
          id
            | _js2n__-refsenv."_js2n__-:definitions/iddef!contract"
            | doc "Represents mandatory unique package identifier",
          info
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents additional information to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          packageVersion
            | {
              upgradeNotification
                | std.enum.TagOrString
                | [| 'all, '"major.minor", 'major, 'none |]
                | doc "Represents optional upgrade notification once the package is available. none - no notification, package will be installed automatically for any version. major - notification before a new major version is installed. major.minor - notification before a major and minor version is installed. all - notification before any new version is installed, including patches"
                | optional,
              version
                | _js2n__-refsenv."_js2n__-:definitions/semanticversion!contract"
                | doc "Represents mandatory semantic version of the package",
              ..
            }
            | doc "Represents mandatory semantic version of the package information and optional the upgrade notification",
          shortTitle
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a shorter version of the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          subTitle
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a subtitle to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          support
            | _js2n__-refsenv."_js2n__-:definitions/infolink!contract"
            | doc "Represents the support information",
          tags
            | {
              keywords | _js2n__-refsenv."_js2n__-:definitions/tag!contract",
              technicalAttributes
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern "^[A-Z0-9_\\-\\/]+$"
                      ])
                )
                | optional,
              ..
            }
            | doc "Represents array of keywords used to find the package"
            | optional,
          title
            | _js2n__-prdslib.contract_from_predicate
              _js2n__-refsenv."_js2n__-:definitions/i18n_key_string!predicate"
            | doc "Represents a title (mandatory); to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'",
          type
            | std.enum.TagOrString
            | [| 'workspace-template, 'workflow, 'card |]
            | doc "Represents type of an package and can be card, workflow, workspace-template"
            | optional,
          vendor
            | _js2n__-refsenv."_js2n__-:definitions/vendor!contract"
            | doc "Represents the support information",
          ..
        }
        | doc "Represents general package attributes. Experimental, will be detailed in the future"
        | optional,
      "sap.platform.abap"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          uri
            | String
            | doc "Represents the uri of the app in the ABAP system"
            | optional,
          uriNwbc
            | String
            | doc "Represents the alternative uri of the app in the ABAP system for starting the application"
            | optional,
        }
        | doc "Represents ABAP platform specific attributes"
        | optional,
      "sap.platform.cf"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          oAuthScopes
            | Array (String)
            | doc "Represents the authorization scope of the application"
            | optional,
          ..
        }
        | doc "Represents CF(Cloud Foundry) platform specific attributes"
        | optional,
      "sap.platform.hcp"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.3.0", '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          appName
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-z][a-z0-9]{0,29}$"
                ])
            | doc "Represents the HTML5 application name"
            | optional,
          appVersion
            | String
            | doc "Represents the version of the HTML5 application"
            | optional,
          multiVersionApp
            | Bool
            | doc "Indicates that HCP application is multi-version enabled"
            | optional,
          providerAccount
            | String
            | doc "Represents the provider account of the HTML5 application"
            | optional,
          uri
            | String
            | doc "Represents the uri of the app in the HANA Cloud Platform"
            | optional,
          uriNwbc
            | String
            | doc "Represents the alternative uri of the app in the ABAP system for starting the application"
            | optional,
        }
        | doc "Represents HANA Cloud Platform platform specific attributes"
        | optional,
      "sap.platform.mobilecards"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.0.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          compatible
            | Bool
            | doc "Represents the compatibility of this app with the Mobile Cards platform."
            | optional,
          ..
        }
        | doc "Represents Mobile Cards platform specific attributes"
        | optional,
      "sap.platform.sfsf"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.0.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          appName | String | doc "Represents the SFSF application name",
          appVersion
            | String
            | doc "Represents the version of the SFSF application"
            | optional,
          uri
            | String
            | doc "Represents the uri inside the SFSF app"
            | optional,
        }
        | doc "Represents SFSF platform specific attributes"
        | optional,
      "sap.ui"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.5.0", '"1.4.0", '"1.3.0", '"1.2.0", '"1.1.0" |]
            | doc "Represents UI attributes format version. It is managed by namespace owner"
            | optional,
          deviceTypes
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/deviceType!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "desktop", "phone", "tablet" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ])
            | doc "Represents device types on which application is running. Supported device types are desktop, tablet and phone",
          fullWidth
            | Bool
            | doc "Indicates whether app should run in full screen mode: possible values: true or false "
            | optional,
          icons
            | {
              favIcon
                | String
                | doc "Represents ICO file to be used inside the browser and for desktop shortcuts"
                | optional,
              icon | String | doc "Represents icon of the app" | optional,
              phone
                | String
                | doc "Represents 57x57 pixel version for non-retina iPhones"
                | optional,
              "phone@2"
                | String
                | doc "Represents 114x114 pixel version for non-retina iPhones"
                | optional,
              tablet
                | String
                | doc "Represents 72x72 pixel version for non-retina iPads"
                | optional,
              "tablet@2"
                | String
                | doc "Represents 144x144 pixel version for non-retina iPads"
                | optional,
            }
            | doc "Represents icons which used in application"
            | optional,
          supportedThemes
            | Array (String)
            | doc "The property is Deprecated. Represents array of supported SAP themes such as sap_hcb, sap_bluecrystal"
            | optional,
          technology
            | std.enum.TagOrString
            | [| 'WCF, 'URL, 'GUI, 'NWBC, 'WDA, 'UI5 |]
            | doc "Represents UI technology. The possible values are UI5 (default), WDA, NWBC, GUI, URL and WCF",
          ..
        }
        | doc "Represents general ui attributes",
      "sap.ui.generic.app"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.6.0", '"1.5.0", '"1.4.0", '"1.3.0", '"1.2.0", '"1.1.0" |]
            | optional,
          pages
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/pages_array!predicate"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9_\\.\\-]+[\\|]?[a-zA-Z0-9_\\.\\-]+$" =
                            _js2n__-refsenv."_js2n__-:definitions/pages_map!predicate",
                        } false _js2n__-prdslib.never
                    ]
                ])
            | doc "Represents one ore more pages of an application. UI5 routing is created from the definitions in this section"
            | optional,
          settings
            | _js2n__-refsenv."_js2n__-:definitions/setting_def!contract"
            | doc "Represents global settings for the application controller"
            | optional,
        }
        | doc "Represents GENERIC APP specific attributes"
        | optional,
      "sap.ui.smartbusiness.app"
        | {  .. }
        | doc "Represents specific attributes for Smart Business  "
        | optional,
      "sap.ui5"
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "contentDensities", "dependencies" ],
                  _js2n__-prdslib.records.record
                    {
                      _version =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "1.1.0",
                                  "1.2.0",
                                  "1.3.0",
                                  "1.4.0",
                                  "1.5.0",
                                  "1.6.0",
                                  "1.7.0",
                                  "1.8.0",
                                  "1.9.0",
                                  "1.10.0",
                                  "1.11.0",
                                  "1.12.0",
                                  "1.13.0",
                                  "1.14.0",
                                  "1.15.0",
                                  "1.16.0",
                                  "1.17.0",
                                  "1.18.0"
                                ]
                            ],
                      appVariantId = _js2n__-prdslib.isType '"String",
                      appVariantIdHierarchy =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "appVariantId", "layer", "version" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        appVariantId =
                                          _js2n__-prdslib.isType '"String",
                                        layer =
                                          _js2n__-prdslib.isType '"String",
                                        version =
                                          _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ])
                            ],
                      autoPrefixId = _js2n__-prdslib.isType '"Bool",
                      commands =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[A-Za-z_][A-Za-z0-9_\\-\\|@]+$" =
                                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                                } false _js2n__-prdslib.never
                            ],
                      componentName =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^([a-zA-Z_$][a-zA-Z0-9_$]{0,39}\\.)*([a-zA-Z_$][a-zA-Z0-9_$]{0,39})$"
                            ],
                      componentUsages =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9_\\.]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/componentUsages!predicate",
                                } false _js2n__-prdslib.never
                            ],
                      config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "[\\s\\S]*" =
                                    _js2n__-refsenv."_js2n__-:definitions/config!predicate",
                                } false _js2n__-prdslib.never
                            ],
                      contentDensities =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "compact", "cozy" ],
                              _js2n__-prdslib.records.record
                                {
                                  compact = _js2n__-prdslib.isType '"Bool",
                                  cozy = _js2n__-prdslib.isType '"Bool",
                                } {} false _js2n__-prdslib.never
                            ],
                      dependencies =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "minUI5Version" ],
                              _js2n__-prdslib.records.record
                                {
                                  components =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^([a-zA-Z_$][a-zA-Z0-9_$]{0,39}\\.)*([a-zA-Z_$][a-zA-Z0-9_$]{0,39})$" =
                                                _js2n__-refsenv."_js2n__-:definitions/component!predicate",
                                            } false _js2n__-prdslib.never
                                        ],
                                  libs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^([a-z][a-z0-9]{0,39})(\\.[a-z][a-z0-9]{0,39})*$" =
                                                _js2n__-refsenv."_js2n__-:definitions/lib!predicate",
                                            } false _js2n__-prdslib.never
                                        ],
                                  minUI5Version =
                                    _js2n__-refsenv."_js2n__-:definitions/minUI5Version!predicate",
                                } {} false _js2n__-prdslib.never
                            ],
                      extends =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  component =
                                    _js2n__-refsenv."_js2n__-:definitions/id_def!predicate",
                                  extensions = _js2n__-prdslib.isType 'Record,
                                  minVersion =
                                    _js2n__-refsenv."_js2n__-:definitions/version!predicate",
                                } {} false _js2n__-prdslib.never
                            ],
                      flexExtensionPointEnabled =
                        _js2n__-prdslib.isType '"Bool",
                      handleValidation = _js2n__-prdslib.isType '"Bool",
                      isCloudDevAdaptation = _js2n__-prdslib.isType '"Bool",
                      library =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  content = _js2n__-prdslib.isType 'Record,
                                  css =
                                    _js2n__-refsenv."_js2n__-:definitions/booleanOrString!predicate",
                                  i18n =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "bundleUrl" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  bundleUrl =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  enhanceWith =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-refsenv."_js2n__-:definitions/enhanceWithSetting!predicate"
                                                              ])
                                                        ],
                                                  fallbackLocale =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  supportedLocales =
                                                    _js2n__-prdslib.isType
                                                        '"Array",
                                                  terminologies =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {}
                                                            {
                                                              "^[a-zA-Z0-9_\\-]*$" =
                                                                _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                                                            } false
                                                            _js2n__-prdslib.never
                                                        ],
                                                } {} false _js2n__-prdslib.never
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "bundleName" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  bundleName =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  enhanceWith =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-refsenv."_js2n__-:definitions/enhanceWithSetting!predicate"
                                                              ])
                                                        ],
                                                  fallbackLocale =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  supportedLocales =
                                                    _js2n__-prdslib.isType
                                                        '"Array",
                                                  terminologies =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {}
                                                            {
                                                              "^[a-zA-Z0-9_\\-]*$" =
                                                                _js2n__-refsenv."_js2n__-:definitions/terminologySetting!predicate",
                                                            } false
                                                            _js2n__-prdslib.never
                                                        ],
                                                } {} false _js2n__-prdslib.never
                                            ]
                                        ],
                                } {} false _js2n__-prdslib.never
                            ],
                      models =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9_\\.\\-\\|@]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/model!predicate",
                                } false _js2n__-prdslib.never
                            ],
                      resourceRoots =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9_\\.\\-]*$" =
                                    _js2n__-refsenv."_js2n__-:definitions/resourceRoot!predicate",
                                } false _js2n__-prdslib.never
                            ],
                      resources =
                        _js2n__-refsenv."_js2n__-:definitions/resource!predicate",
                      services =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "[\\s\\S]*" =
                                    _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                                } false _js2n__-prdslib.never
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "flexEnabled" ],
                      _js2n__-prdslib.records.record
                        {
                          flexEnabled =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.enum [ true ]
                                ],
                          rootView =
                            _js2n__-refsenv."_js2n__-:definitions/rootView_def_flexEnabled!predicate",
                          routing =
                            _js2n__-refsenv."_js2n__-:definitions/routing_flexEnabled!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          flexEnabled =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.enum [ false ]
                                ],
                          rootView =
                            _js2n__-refsenv."_js2n__-:definitions/rootView_def!predicate",
                          routing =
                            _js2n__-refsenv."_js2n__-:definitions/routing!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ])
        | doc "Represents sapui5 attributes"
        | optional,
      "sap.url"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.0.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          uri | String | doc "Represents URI of an application",
        }
        | doc "Represents specific attributes for SAP URL"
        | optional,
      "sap.wcf"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          wcf-target-id
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9\\/_]{1,10}$"
                ])
            | doc "Represents the target technical id for a WCF Application",
        }
        | doc "Represents WCF Application specific attributes"
        | optional,
      "sap.wda"
        | {
          _version
            | std.enum.TagOrString
            | [| '"1.2.0", '"1.1.0" |]
            | doc "Represents attributes format version. It is managed by namespace owner"
            | optional,
          applicationId
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9\\/_]{1,30}$"
                ])
            | doc "Represents ID of an application",
          compatibilityMode
            | Bool
            | doc "Indicates that WebDynpro Application requires Compatibility Mode, while uses legacy shell services. Possible values are true or false (default)"
            | optional,
          configId
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[a-zA-Z0-9\\/\\_]{1,32}$"
                ])
            | doc "Represents ID of an application configuration"
            | optional,
          flavorId
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern "^[A-F0-9]{1,32}$"
                ])
            | doc "Represents SAP Screen Personas Flavor ID"
            | optional,
        }
        | doc "Represents WDA specific attributes"
        | optional,
      start_url
        | String
        | doc "Represents the URL that the developer would prefer the user agent load when the user launches the web application"
        | optional,
    }