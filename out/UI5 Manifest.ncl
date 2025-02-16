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
  {
      "$schema"
        | String
        | doc "The resource identifier for the JSON schema to be used. The value of this keyword MUST be a URI [RFC3986] (containing a scheme) and this URI MUST be normalized. The current schema MUST be valid against the meta-schema identified by this URI. If this URI identifies a retrievable resource, that resource SHOULD be of media type \"application/schema+json\"."
        | optional,
      _version
        | std.enum.TagOrString
        | [|
          '"1.70.1",
          '"1.69.0",
          '"1.68.0",
          '"1.67.2",
          '"1.66.0",
          '"1.65.0",
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
                            { version = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always
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
                              inbounds = _js2n__-prdslib.always,
                              outbounds = _js2n__-prdslib.always,
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
                              "^[a-zA-Z0-9_\\.\\-]*$" = _js2n__-prdslib.always,
                            } false _js2n__-prdslib.never
                        ],
                  description = _js2n__-prdslib.always,
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
                                                _js2n__-prdslib.always
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
                                                _js2n__-prdslib.always,
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
                                                _js2n__-prdslib.always
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
                                                _js2n__-prdslib.always,
                                            } false _js2n__-prdslib.never
                                        ],
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  id = _js2n__-prdslib.always,
                  info = _js2n__-prdslib.always,
                  offline = _js2n__-prdslib.isType '"Bool",
                  openSourceComponents =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
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
                  shortTitle = _js2n__-prdslib.always,
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
                  subTitle = _js2n__-prdslib.always,
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "keywords" ],
                          _js2n__-prdslib.records.record
                            {
                              keywords = _js2n__-prdslib.always,
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
                  title = _js2n__-prdslib.always,
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
            | { version | Dyn, .. }
            | doc "Represents mandatory semantic version of the artifact",
          description
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
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
          id | Dyn | doc "Represents mandatory unique artifact identifier",
          info
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents additional information to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          shortTitle
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents a shorter version of the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          subTitle
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents a subtitle to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          tags
            | {
              keywords | Dyn,
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
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
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
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Analytical", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "AnalyticsCloud", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Timeline", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Table", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Object", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Component", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "Calendar", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "AdaptiveCard", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always,
                  _js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { type = _js2n__-prdslib.const "WebPage", } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.records.record
                      { content = _js2n__-prdslib.always, } {} true
                      _js2n__-prdslib.always) _js2n__-prdslib.always
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
                              "1.45.0",
                              "1.46.0",
                              "1.47.0",
                              "1.48.0",
                              "1.49.0",
                              "1.50.0",
                              "1.51.0"
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
                                        _js2n__-prdslib.always
                                    ],
                              destinations =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                              editor = _js2n__-prdslib.isType '"String",
                              enableMarkdown = _js2n__-prdslib.isType '"Bool",
                              filters =
                                _js2n__-prdslib.records.record {} {} true
                                    (_js2n__-prdslib.oneOf
                                      [
                                        _js2n__-prdslib.always,
                                        _js2n__-prdslib.always,
                                        _js2n__-prdslib.always,
                                        _js2n__-prdslib.always
                                      ]),
                              helpId = _js2n__-prdslib.isType '"String",
                              messages =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                              modelSizeLimit =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.always
                                    ],
                              parameters =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  content = _js2n__-prdslib.always,
                  data = _js2n__-prdslib.always,
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
                                            _js2n__-prdslib.always
                                        ],
                                      _js2n__-prdslib.always
                                    ],
                              closeButton = _js2n__-prdslib.always,
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
                                                  _js2n__-prdslib.always
                                                ],
                                          totalCount =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.always
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              visible = _js2n__-prdslib.always,
                            } {} false _js2n__-prdslib.never
                        ],
                  header = _js2n__-prdslib.always,
                  headerPosition =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.enum [ "Top", "Bottom" ],
                              _js2n__-prdslib.always
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
            | [| '"1.1.0", '"1.0.0" |]
            | doc "Represents attributes format version."
            | optional,
          embeds
            | { ObjectPage | Dyn | optional, .. }
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
            | doc "[Deprecated] Represents the display order of Insights card"
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
                    { "^[a-zA-Z0-9_\\.\\-]*" = _js2n__-prdslib.always, } false
                    _js2n__-prdslib.never
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
                              "^[a-zA-Z0-9_\\.\\-]+$" = _js2n__-prdslib.always,
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
                                                        _js2n__-prdslib.always,
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
                  refreshStrategyOnAppRestore = _js2n__-prdslib.always,
                  resizableLayout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { "^cols_[0-9]+$" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  showBasicSearch = _js2n__-prdslib.isType '"Bool",
                  showDateInRelativeFormat = _js2n__-prdslib.isType '"Bool",
                  smartVariantRequired = _js2n__-prdslib.isType '"Bool",
                  useDateRangeType = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
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
          contents | Array (Dyn) | optional,
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
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents a description; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'",
          documentation
            | Dyn
            | doc "Represents the documentation information"
            | optional,
          homepage | Dyn | doc "Represents the homepage information" | optional,
          i18n
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf [ _js2n__-prdslib.isType '"String" ])
            | doc "Represents path inside the package to the properties file containing text symbols for the packages texts"
            | optional,
          icon
            | String
            | doc "Represents icon name or source URL for the package"
            | optional,
          id | Dyn | doc "Represents mandatory unique package identifier",
          info
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
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
                | Dyn
                | doc "Represents mandatory semantic version of the package",
              ..
            }
            | doc "Represents mandatory semantic version of the package information and optional the upgrade notification",
          shortTitle
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents a shorter version of the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          subTitle
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents a subtitle to the title; to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'"
            | optional,
          support | Dyn | doc "Represents the support information",
          tags
            | {
              keywords | Dyn,
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
            | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
            | doc "Represents a title (mandatory); to make this property language dependent (recommended), use a key in double curly brackets '{{key}}'",
          type
            | std.enum.TagOrString
            | [| 'workspace-template, 'workflow, 'card |]
            | doc "Represents type of an package and can be card, workflow, workspace-template"
            | optional,
          vendor | Dyn | doc "Represents the support information",
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
                  _js2n__-prdslib.always,
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
            | doc "[Deprecated] Represents array of supported SAP themes such as sap_hcb, sap_bluecrystal"
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
                      _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9_\\.\\-]+[\\|]?[a-zA-Z0-9_\\.\\-]+$" =
                            _js2n__-prdslib.always,
                        } false _js2n__-prdslib.never
                    ]
                ])
            | doc "Represents one ore more pages of an application. UI5 routing is created from the definitions in this section"
            | optional,
          settings
            | Dyn
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
                                    _js2n__-prdslib.always,
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
                                  "^[a-zA-Z0-9_\\.]*$" = _js2n__-prdslib.always,
                                } false _js2n__-prdslib.never
                            ],
                      config =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { "[\\s\\S]*" = _js2n__-prdslib.always, } false
                                _js2n__-prdslib.never
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
                                                _js2n__-prdslib.always,
                                            } false _js2n__-prdslib.never
                                        ],
                                  libs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {}
                                            {
                                              "^([a-z][a-z0-9]{0,39})(\\.[a-z][a-z0-9]{0,39})*$" =
                                                _js2n__-prdslib.always,
                                            } false _js2n__-prdslib.never
                                        ],
                                  minUI5Version = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ],
                      extends =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  component = _js2n__-prdslib.always,
                                  extensions = _js2n__-prdslib.isType 'Record,
                                  minVersion = _js2n__-prdslib.always,
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
                                  css = _js2n__-prdslib.always,
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
                                                                _js2n__-prdslib.always
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
                                                                _js2n__-prdslib.always,
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
                                                                _js2n__-prdslib.always
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
                                                                _js2n__-prdslib.always,
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
                                    _js2n__-prdslib.always,
                                } false _js2n__-prdslib.never
                            ],
                      resourceRoots =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9_\\.\\-]*$" =
                                    _js2n__-prdslib.always,
                                } false _js2n__-prdslib.never
                            ],
                      resources = _js2n__-prdslib.always,
                      services =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                { "[\\s\\S]*" = _js2n__-prdslib.always, } false
                                _js2n__-prdslib.never
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
                          rootView = _js2n__-prdslib.always,
                          routing = _js2n__-prdslib.always,
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
                          rootView = _js2n__-prdslib.always,
                          routing = _js2n__-prdslib.always,
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