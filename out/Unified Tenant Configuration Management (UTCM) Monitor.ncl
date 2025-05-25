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
      baseline
        | {
          description | String | optional,
          displayName | String | optional,
          id | String | optional,
          parameters
            | Array
              {
                description | String | optional,
                displayName | String | optional,
                parameterType
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.enum
                      [ "string", "integer", "boolean", "unknownFutureValue" ])
                  | optional,
                ..
              }
            | optional,
          resources
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.accepteddomain",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.activesyncdeviceaccessrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.addressbookpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.addresslist",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.antiphishpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.antiphishrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.applicationaccesspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.atppolicyforo365",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.authenticationpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.authenticationpolicyassignment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.availabilityaddressspace",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.availabilityconfig",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.calendarprocessing",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.casmailboxplan",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.casmailboxsettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.clientaccessrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.dataclassification",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.dataencryptionpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.distributiongroup",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.dkimsigningconfig",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.emailaddresspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.eopprotectionpolicyrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.externalinoutlook",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.globaladdresslist",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.groupsettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.hostedconnectionfilterpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.hostedcontentfilterpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.hostedcontentfilterrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.hostedoutboundspamfilterpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.hostedoutboundspamfilterrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.inboundconnector",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.intraorganizationconnector",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.irmconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.journalrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailboxautoreplyconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailboxcalendarfolder",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailboxpermission",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailboxplan",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailboxsettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailcontact",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mailtips",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.malwarefilterpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.malwarefilterrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.managementrole",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.managementroleassignment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.managementroleentry",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.messageclassification",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.mobiledevicemailboxpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.offlineaddressbook",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.omeconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.onpremisesorganization",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.organizationconfig",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.organizationrelationship",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.outboundconnector",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.owamailboxpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.partnerapplication",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.perimeterconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.place",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.policytipconfig",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.quarantinepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.recipientpermission",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.remotedomain",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.reportsubmissionpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.reportsubmissionrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.resourceconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.roleassignmentpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.rolegroup",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.safeattachmentpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.safeattachmentrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.safelinkspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.safelinksrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.sharedmailbox",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.sharingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.sweeprule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.transportconfig",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.exchange.transportrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.administrativeunit",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.application",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.attributeset",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationcontextclassreference",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicyauthenticator",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicyemail",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicyfido2",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicysms",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicysoftware",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicytemporary",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicyvoice",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationmethodpolicyx509",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authenticationstrengthpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.authorizationpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.conditionalaccesspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.crosstenantaccesspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.crosstenantaccesspolicyconfigurationdefault",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.crosstenantaccesspolicyconfigurationpartner",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.entitlementmanagementaccesspackage",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.entitlementmanagementaccesspackageassignmentpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.entitlementmanagementaccesspackagecatalog",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.entitlementmanagementaccesspackagecatalogresource",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.entitlementmanagementconnectedorganization",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.externalidentitypolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const "microsoft.entra.group",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.grouplifecyclepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.groupsnamingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.groupssettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.namedlocationpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.roledefinition",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.roleeligibilityschedulerequest",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.rolesetting",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.securitydefaults",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.serviceprincipal",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.socialidentityprovider",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.tenantdetails",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.entra.tokenlifetimepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const "microsoft.entra.user",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.apppermissionpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.appsetuppolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.audioconferencingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.callholdpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.callingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.callparkpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.callqueue",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.channelspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const "microsoft.teams.channel",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.channeltab",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.clientconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.compliancerecordingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.cortanapolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.dialinconferencingtenantsettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.emergencycallingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.emergencycallroutingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.enhancedencryptionpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.eventspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.federationconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.feedbackpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.filespolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.grouppolicyassignment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.guestcallingconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.guestmeetingconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.guestmessagingconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.ipphonepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.meetingbroadcastconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.meetingbroadcastpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.meetingconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.meetingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.messagingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.mobilitypolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.networkroamingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.onlinevoicemailpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.onlinevoicemailusersettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.onlinevoiceuser",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.orgwideappsettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.pstnusage",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.shiftspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.templatespolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.tenantdialplan",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.tenantnetworkregion",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.tenantnetworksite",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.tenantnetworksubnet",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.tenanttrustedipaddress",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.translationrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.unassignednumbertreatment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.updatemanagementpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.upgradeconfiguration",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.upgradepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const "microsoft.teams.user",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.usercallingsettings",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.userpolicyassignment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.vdipolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.voiceroute",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.voiceroutingpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.teams.workloadpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const "microsoft.teams.team",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.accountprotectionlocaladministratorpasswordsolutionpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.accountprotectionlocalusergroupmembershippolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.accountprotectionpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.antiviruspolicywindows10settingcatalog",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.appconfigurationpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.applicationcontrolpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.appprotectionpolicyandroid",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.appprotectionpolicyios",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.asrrulespolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.attacksurfacereductionrulespolicywindows10configmanager",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceandappmanagementassignmentfilter",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecategory",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecleanuprule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecompliancepolicyandroid",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecompliancepolicyandroiddeviceowner",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecompliancepolicyandroidworkprofile",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecompliancepolicyios",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecompliancepolicymacos",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.devicecompliancepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationadministrativetemplatepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationcustompolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationdefenderforendpointonboardingpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationdeliveryoptimizationpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationdomainjoinpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationemailprofilepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationendpointprotectionpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationfirmwareinterfacepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationhealthmonitoringconfigurationpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationidentityprotectionpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationimportedpfxcertificatepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationkioskpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationnetworkboundarypolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpkcscertificatepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicyandroiddeviceadministrator",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicyandroiddeviceowner",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicyandroidopensourceproject",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicyandroidworkprofile",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicyios",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicymacos",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationscepcertificatepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationsecureassessmentpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationsharedmultidevicepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationtrustedcertificatepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationvpnpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationwindowsteampolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceconfigurationwirednetworkpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceenrollmentlimitrestriction",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceenrollmentplatformrestriction",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.deviceenrollmentstatuspagewindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.endpointdetectionandresponsepolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.exploitprotectionpolicywindows10settingcatalog",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.policysets",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.roleassignment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.roledefinition",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.settingcatalogasrrulespolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicyandroiddeviceadministrator",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicyandroidenterprisedeviceowner",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicyandroidenterpriseworkprofile",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicyandroidforwork",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicyandroidopensourceproject",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicyios",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicymacos",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.wificonfigurationpolicywindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.windowsautopilotdeploymentprofileazureadhybridjoined",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.windowsautopilotdeploymentprofileazureadjoined",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.windowsinformationprotectionpolicywindows10mdmenrolled",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.windowsupdateforbusinessfeatureupdateprofilewindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.intune.windowsupdateforbusinessringupdateprofilewindows10",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.auditconfigurationpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.autosensitivitylabelpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.autosensitivitylabelrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.caseholdpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.caseholdrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.compliancecase",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.compliancesearch",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.compliancesearchaction",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.compliancetag",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.deviceconditionalaccesspolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.deviceconfigurationpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.dlpcompliancepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.dlpcompliancerule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.fileplanpropertyauthority",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.fileplanpropertycategory",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.fileplanpropertycitation",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.fileplanpropertydepartment",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.fileplanpropertyreferenceid",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.fileplanpropertysubcategory",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.labelpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.protectionalert",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.retentioncompliancepolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.retentioncompliancerule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.retentioneventtype",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.securityfilter",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.sensitivitylabel",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.supervisoryreviewpolicy",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              resourceType =
                                _js2n__-prdslib.const
                                    "microsoft.securityandcompliance.supervisoryreviewrule",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.records.record
                            { properties = _js2n__-prdslib.always, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.records.required
                      [ "displayName", "properties", "resourceType" ],
                    _js2n__-prdslib.records.record
                      {
                        displayName = _js2n__-prdslib.isType '"String",
                        properties = _js2n__-prdslib.always,
                        resourceType =
                          _js2n__-prdslib.enum
                              [
                                "microsoft.exchange.accepteddomain",
                                "microsoft.exchange.activesyncdeviceaccessrule",
                                "microsoft.exchange.addressbookpolicy",
                                "microsoft.exchange.addresslist",
                                "microsoft.exchange.antiphishpolicy",
                                "microsoft.exchange.antiphishrule",
                                "microsoft.exchange.applicationaccesspolicy",
                                "microsoft.exchange.atppolicyforo365",
                                "microsoft.exchange.authenticationpolicy",
                                "microsoft.exchange.authenticationpolicyassignment",
                                "microsoft.exchange.availabilityaddressspace",
                                "microsoft.exchange.availabilityconfig",
                                "microsoft.exchange.calendarprocessing",
                                "microsoft.exchange.casmailboxplan",
                                "microsoft.exchange.casmailboxsettings",
                                "microsoft.exchange.clientaccessrule",
                                "microsoft.exchange.dataclassification",
                                "microsoft.exchange.dataencryptionpolicy",
                                "microsoft.exchange.distributiongroup",
                                "microsoft.exchange.dkimsigningconfig",
                                "microsoft.exchange.emailaddresspolicy",
                                "microsoft.exchange.eopprotectionpolicyrule",
                                "microsoft.exchange.externalinoutlook",
                                "microsoft.exchange.globaladdresslist",
                                "microsoft.exchange.groupsettings",
                                "microsoft.exchange.hostedconnectionfilterpolicy",
                                "microsoft.exchange.hostedcontentfilterpolicy",
                                "microsoft.exchange.hostedcontentfilterrule",
                                "microsoft.exchange.hostedoutboundspamfilterpolicy",
                                "microsoft.exchange.hostedoutboundspamfilterrule",
                                "microsoft.exchange.inboundconnector",
                                "microsoft.exchange.intraorganizationconnector",
                                "microsoft.exchange.irmconfiguration",
                                "microsoft.exchange.journalrule",
                                "microsoft.exchange.mailboxautoreplyconfiguration",
                                "microsoft.exchange.mailboxcalendarfolder",
                                "microsoft.exchange.mailboxpermission",
                                "microsoft.exchange.mailboxplan",
                                "microsoft.exchange.mailboxsettings",
                                "microsoft.exchange.mailcontact",
                                "microsoft.exchange.mailtips",
                                "microsoft.exchange.malwarefilterpolicy",
                                "microsoft.exchange.malwarefilterrule",
                                "microsoft.exchange.managementrole",
                                "microsoft.exchange.managementroleassignment",
                                "microsoft.exchange.managementroleentry",
                                "microsoft.exchange.messageclassification",
                                "microsoft.exchange.mobiledevicemailboxpolicy",
                                "microsoft.exchange.offlineaddressbook",
                                "microsoft.exchange.omeconfiguration",
                                "microsoft.exchange.onpremisesorganization",
                                "microsoft.exchange.organizationconfig",
                                "microsoft.exchange.organizationrelationship",
                                "microsoft.exchange.outboundconnector",
                                "microsoft.exchange.owamailboxpolicy",
                                "microsoft.exchange.partnerapplication",
                                "microsoft.exchange.perimeterconfiguration",
                                "microsoft.exchange.place",
                                "microsoft.exchange.policytipconfig",
                                "microsoft.exchange.quarantinepolicy",
                                "microsoft.exchange.recipientpermission",
                                "microsoft.exchange.remotedomain",
                                "microsoft.exchange.reportsubmissionpolicy",
                                "microsoft.exchange.reportsubmissionrule",
                                "microsoft.exchange.resourceconfiguration",
                                "microsoft.exchange.roleassignmentpolicy",
                                "microsoft.exchange.rolegroup",
                                "microsoft.exchange.safeattachmentpolicy",
                                "microsoft.exchange.safeattachmentrule",
                                "microsoft.exchange.safelinkspolicy",
                                "microsoft.exchange.safelinksrule",
                                "microsoft.exchange.sharedmailbox",
                                "microsoft.exchange.sharingpolicy",
                                "microsoft.exchange.sweeprule",
                                "microsoft.exchange.transportconfig",
                                "microsoft.exchange.transportrule",
                                "microsoft.entra.administrativeunit",
                                "microsoft.entra.application",
                                "microsoft.entra.attributeset",
                                "microsoft.entra.authenticationcontextclassreference",
                                "microsoft.entra.authenticationmethodpolicy",
                                "microsoft.entra.authenticationmethodpolicyauthenticator",
                                "microsoft.entra.authenticationmethodpolicyemail",
                                "microsoft.entra.authenticationmethodpolicyfido2",
                                "microsoft.entra.authenticationmethodpolicysms",
                                "microsoft.entra.authenticationmethodpolicysoftware",
                                "microsoft.entra.authenticationmethodpolicytemporary",
                                "microsoft.entra.authenticationmethodpolicyvoice",
                                "microsoft.entra.authenticationmethodpolicyx509",
                                "microsoft.entra.authenticationstrengthpolicy",
                                "microsoft.entra.authorizationpolicy",
                                "microsoft.entra.conditionalaccesspolicy",
                                "microsoft.entra.crosstenantaccesspolicy",
                                "microsoft.entra.crosstenantaccesspolicyconfigurationdefault",
                                "microsoft.entra.crosstenantaccesspolicyconfigurationpartner",
                                "microsoft.entra.entitlementmanagementaccesspackage",
                                "microsoft.entra.entitlementmanagementaccesspackageassignmentpolicy",
                                "microsoft.entra.entitlementmanagementaccesspackagecatalog",
                                "microsoft.entra.entitlementmanagementaccesspackagecatalogresource",
                                "microsoft.entra.entitlementmanagementconnectedorganization",
                                "microsoft.entra.externalidentitypolicy",
                                "microsoft.entra.group",
                                "microsoft.entra.grouplifecyclepolicy",
                                "microsoft.entra.groupsnamingpolicy",
                                "microsoft.entra.groupssettings",
                                "microsoft.entra.namedlocationpolicy",
                                "microsoft.entra.roledefinition",
                                "microsoft.entra.roleeligibilityschedulerequest",
                                "microsoft.entra.rolesetting",
                                "microsoft.entra.securitydefaults",
                                "microsoft.entra.serviceprincipal",
                                "microsoft.entra.socialidentityprovider",
                                "microsoft.entra.tenantdetails",
                                "microsoft.entra.tokenlifetimepolicy",
                                "microsoft.entra.user",
                                "microsoft.teams.apppermissionpolicy",
                                "microsoft.teams.appsetuppolicy",
                                "microsoft.teams.audioconferencingpolicy",
                                "microsoft.teams.callholdpolicy",
                                "microsoft.teams.callingpolicy",
                                "microsoft.teams.callparkpolicy",
                                "microsoft.teams.callqueue",
                                "microsoft.teams.channelspolicy",
                                "microsoft.teams.channel",
                                "microsoft.teams.channeltab",
                                "microsoft.teams.clientconfiguration",
                                "microsoft.teams.compliancerecordingpolicy",
                                "microsoft.teams.cortanapolicy",
                                "microsoft.teams.dialinconferencingtenantsettings",
                                "microsoft.teams.emergencycallingpolicy",
                                "microsoft.teams.emergencycallroutingpolicy",
                                "microsoft.teams.enhancedencryptionpolicy",
                                "microsoft.teams.eventspolicy",
                                "microsoft.teams.federationconfiguration",
                                "microsoft.teams.feedbackpolicy",
                                "microsoft.teams.filespolicy",
                                "microsoft.teams.grouppolicyassignment",
                                "microsoft.teams.guestcallingconfiguration",
                                "microsoft.teams.guestmeetingconfiguration",
                                "microsoft.teams.guestmessagingconfiguration",
                                "microsoft.teams.ipphonepolicy",
                                "microsoft.teams.meetingbroadcastconfiguration",
                                "microsoft.teams.meetingbroadcastpolicy",
                                "microsoft.teams.meetingconfiguration",
                                "microsoft.teams.meetingpolicy",
                                "microsoft.teams.messagingpolicy",
                                "microsoft.teams.mobilitypolicy",
                                "microsoft.teams.networkroamingpolicy",
                                "microsoft.teams.onlinevoicemailpolicy",
                                "microsoft.teams.onlinevoicemailusersettings",
                                "microsoft.teams.onlinevoiceuser",
                                "microsoft.teams.orgwideappsettings",
                                "microsoft.teams.pstnusage",
                                "microsoft.teams.shiftspolicy",
                                "microsoft.teams.templatespolicy",
                                "microsoft.teams.tenantdialplan",
                                "microsoft.teams.tenantnetworkregion",
                                "microsoft.teams.tenantnetworksite",
                                "microsoft.teams.tenantnetworksubnet",
                                "microsoft.teams.tenanttrustedipaddress",
                                "microsoft.teams.translationrule",
                                "microsoft.teams.unassignednumbertreatment",
                                "microsoft.teams.updatemanagementpolicy",
                                "microsoft.teams.upgradeconfiguration",
                                "microsoft.teams.upgradepolicy",
                                "microsoft.teams.user",
                                "microsoft.teams.usercallingsettings",
                                "microsoft.teams.userpolicyassignment",
                                "microsoft.teams.vdipolicy",
                                "microsoft.teams.voiceroute",
                                "microsoft.teams.voiceroutingpolicy",
                                "microsoft.teams.workloadpolicy",
                                "microsoft.teams.team",
                                "microsoft.intune.accountprotectionlocaladministratorpasswordsolutionpolicy",
                                "microsoft.intune.accountprotectionlocalusergroupmembershippolicy",
                                "microsoft.intune.accountprotectionpolicy",
                                "microsoft.intune.antiviruspolicywindows10settingcatalog",
                                "microsoft.intune.appconfigurationpolicy",
                                "microsoft.intune.applicationcontrolpolicywindows10",
                                "microsoft.intune.appprotectionpolicyandroid",
                                "microsoft.intune.appprotectionpolicyios",
                                "microsoft.intune.asrrulespolicywindows10",
                                "microsoft.intune.attacksurfacereductionrulespolicywindows10configmanager",
                                "microsoft.intune.deviceandappmanagementassignmentfilter",
                                "microsoft.intune.devicecategory",
                                "microsoft.intune.devicecleanuprule",
                                "microsoft.intune.devicecompliancepolicyandroid",
                                "microsoft.intune.devicecompliancepolicyandroiddeviceowner",
                                "microsoft.intune.devicecompliancepolicyandroidworkprofile",
                                "microsoft.intune.devicecompliancepolicyios",
                                "microsoft.intune.devicecompliancepolicymacos",
                                "microsoft.intune.devicecompliancepolicywindows10",
                                "microsoft.intune.deviceconfigurationadministrativetemplatepolicywindows10",
                                "microsoft.intune.deviceconfigurationcustompolicywindows10",
                                "microsoft.intune.deviceconfigurationdefenderforendpointonboardingpolicywindows10",
                                "microsoft.intune.deviceconfigurationdeliveryoptimizationpolicywindows10",
                                "microsoft.intune.deviceconfigurationdomainjoinpolicywindows10",
                                "microsoft.intune.deviceconfigurationemailprofilepolicywindows10",
                                "microsoft.intune.deviceconfigurationendpointprotectionpolicywindows10",
                                "microsoft.intune.deviceconfigurationfirmwareinterfacepolicywindows10",
                                "microsoft.intune.deviceconfigurationhealthmonitoringconfigurationpolicywindows10",
                                "microsoft.intune.deviceconfigurationidentityprotectionpolicywindows10",
                                "microsoft.intune.deviceconfigurationimportedpfxcertificatepolicywindows10",
                                "microsoft.intune.deviceconfigurationkioskpolicywindows10",
                                "microsoft.intune.deviceconfigurationnetworkboundarypolicywindows10",
                                "microsoft.intune.deviceconfigurationpkcscertificatepolicywindows10",
                                "microsoft.intune.deviceconfigurationpolicyandroiddeviceadministrator",
                                "microsoft.intune.deviceconfigurationpolicyandroiddeviceowner",
                                "microsoft.intune.deviceconfigurationpolicyandroidopensourceproject",
                                "microsoft.intune.deviceconfigurationpolicyandroidworkprofile",
                                "microsoft.intune.deviceconfigurationpolicyios",
                                "microsoft.intune.deviceconfigurationpolicymacos",
                                "microsoft.intune.deviceconfigurationpolicywindows10",
                                "microsoft.intune.deviceconfigurationscepcertificatepolicywindows10",
                                "microsoft.intune.deviceconfigurationsecureassessmentpolicywindows10",
                                "microsoft.intune.deviceconfigurationsharedmultidevicepolicywindows10",
                                "microsoft.intune.deviceconfigurationtrustedcertificatepolicywindows10",
                                "microsoft.intune.deviceconfigurationvpnpolicywindows10",
                                "microsoft.intune.deviceconfigurationwindowsteampolicywindows10",
                                "microsoft.intune.deviceconfigurationwirednetworkpolicywindows10",
                                "microsoft.intune.deviceenrollmentlimitrestriction",
                                "microsoft.intune.deviceenrollmentplatformrestriction",
                                "microsoft.intune.deviceenrollmentstatuspagewindows10",
                                "microsoft.intune.endpointdetectionandresponsepolicywindows10",
                                "microsoft.intune.exploitprotectionpolicywindows10settingcatalog",
                                "microsoft.intune.policysets",
                                "microsoft.intune.roleassignment",
                                "microsoft.intune.roledefinition",
                                "microsoft.intune.settingcatalogasrrulespolicywindows10",
                                "microsoft.intune.settingcatalogcustompolicywindows10",
                                "microsoft.intune.wificonfigurationpolicyandroiddeviceadministrator",
                                "microsoft.intune.wificonfigurationpolicyandroidenterprisedeviceowner",
                                "microsoft.intune.wificonfigurationpolicyandroidenterpriseworkprofile",
                                "microsoft.intune.wificonfigurationpolicyandroidforwork",
                                "microsoft.intune.wificonfigurationpolicyandroidopensourceproject",
                                "microsoft.intune.wificonfigurationpolicyios",
                                "microsoft.intune.wificonfigurationpolicymacos",
                                "microsoft.intune.wificonfigurationpolicywindows10",
                                "microsoft.intune.windowsautopilotdeploymentprofileazureadhybridjoined",
                                "microsoft.intune.windowsautopilotdeploymentprofileazureadjoined",
                                "microsoft.intune.windowsinformationprotectionpolicywindows10mdmenrolled",
                                "microsoft.intune.windowsupdateforbusinessfeatureupdateprofilewindows10",
                                "microsoft.intune.windowsupdateforbusinessringupdateprofilewindows10",
                                "microsoft.securityandcompliance.auditconfigurationpolicy",
                                "microsoft.securityandcompliance.autosensitivitylabelpolicy",
                                "microsoft.securityandcompliance.autosensitivitylabelrule",
                                "microsoft.securityandcompliance.caseholdpolicy",
                                "microsoft.securityandcompliance.caseholdrule",
                                "microsoft.securityandcompliance.compliancecase",
                                "microsoft.securityandcompliance.compliancesearch",
                                "microsoft.securityandcompliance.compliancesearchaction",
                                "microsoft.securityandcompliance.compliancetag",
                                "microsoft.securityandcompliance.deviceconditionalaccesspolicy",
                                "microsoft.securityandcompliance.deviceconfigurationpolicy",
                                "microsoft.securityandcompliance.dlpcompliancepolicy",
                                "microsoft.securityandcompliance.dlpcompliancerule",
                                "microsoft.securityandcompliance.fileplanpropertyauthority",
                                "microsoft.securityandcompliance.fileplanpropertycategory",
                                "microsoft.securityandcompliance.fileplanpropertycitation",
                                "microsoft.securityandcompliance.fileplanpropertydepartment",
                                "microsoft.securityandcompliance.fileplanpropertyreferenceid",
                                "microsoft.securityandcompliance.fileplanpropertysubcategory",
                                "microsoft.securityandcompliance.labelpolicy",
                                "microsoft.securityandcompliance.protectionalert",
                                "microsoft.securityandcompliance.retentioncompliancepolicy",
                                "microsoft.securityandcompliance.retentioncompliancerule",
                                "microsoft.securityandcompliance.retentioneventtype",
                                "microsoft.securityandcompliance.securityfilter",
                                "microsoft.securityandcompliance.sensitivitylabel",
                                "microsoft.securityandcompliance.supervisoryreviewpolicy",
                                "microsoft.securityandcompliance.supervisoryreviewrule"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
            )
            | optional,
          ..
        }
        | doc "Schema for entity configurationBaseline"
        | optional,
      description | String | optional,
      displayName | String | optional,
      id | String | optional,
      parameters
        | {  .. }
        | doc "Schema for entity openComplexDictionaryType"
        | optional,
    }