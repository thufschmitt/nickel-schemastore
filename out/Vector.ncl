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
      "_js2n__-:definitions/codecs::common::length_delimited::LengthDelimitedCoderOptions!predicate"
        | doc "Options for building a `LengthDelimitedDecoder` or `LengthDelimitedEncoder`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  length_field_is_big_endian = _js2n__-prdslib.isType '"Bool",
                  length_field_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  length_field_offset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max_frame_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate"
        | doc "Configures how events are decoded from raw bytes."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "codec" ],
                  _js2n__-prdslib.records.record
                    { codec = _js2n__-prdslib.const "bytes", } {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          json =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    { lossy = _js2n__-prdslib.isType '"Bool", }
                                    {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "json", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          protobuf =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "desc_file", "message_type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      desc_file =
                                        _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                                      message_type =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "protobuf", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          syslog =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    { lossy = _js2n__-prdslib.isType '"Bool", }
                                    {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "syslog", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "codec" ],
                  _js2n__-prdslib.records.record
                    { codec = _js2n__-prdslib.const "native", } {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          native_json =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    { lossy = _js2n__-prdslib.isType '"Bool", }
                                    {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "native_json", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          gelf =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    { lossy = _js2n__-prdslib.isType '"Bool", }
                                    {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "gelf", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          influxdb =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    { lossy = _js2n__-prdslib.isType '"Bool", }
                                    {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "influxdb", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "avro", "codec" ],
                  _js2n__-prdslib.records.record
                    {
                      avro =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "schema", "strip_schema_id_prefix" ],
                              _js2n__-prdslib.records.record
                                {
                                  schema = _js2n__-prdslib.isType '"String",
                                  strip_schema_id_prefix =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ],
                      codec = _js2n__-prdslib.const "avro",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "vrl" ],
                      _js2n__-prdslib.records.record
                        {
                          vrl =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "source" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      source = _js2n__-prdslib.isType '"String",
                                      timezone = _js2n__-prdslib.always,
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "codec" ],
                      _js2n__-prdslib.records.record
                        { codec = _js2n__-prdslib.const "vrl", } {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/codecs::decoding::FramingConfig!predicate"
        | doc m%"
          Framing handles how events are separated when encoded in a raw byte form, where each event is
          a frame that must be prefixed, or delimited, in a way that marks where an event begins and
          ends within the byte stream.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "method" ],
                  _js2n__-prdslib.records.record
                    { method = _js2n__-prdslib.const "bytes", } {} true
                    _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required
                        [ "character_delimited" ],
                      _js2n__-prdslib.records.record
                        {
                          character_delimited =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "delimiter" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      delimiter =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.numbers.maximum
                                                255,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      max_length =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.numbers.maximum
                                                9007199254740990,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        {
                          method = _js2n__-prdslib.const "character_delimited",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "length_delimited" ],
                      _js2n__-prdslib.records.record
                        {
                          length_delimited =
                            _js2n__-refsenv."_js2n__-:definitions/codecs::common::length_delimited::LengthDelimitedCoderOptions!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        { method = _js2n__-prdslib.const "length_delimited", }
                        {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          newline_delimited =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      max_length =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.numbers.maximum
                                                9007199254740990,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        { method = _js2n__-prdslib.const "newline_delimited", }
                        {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          octet_counting =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      max_length =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.numbers.maximum
                                                9007199254740990,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        { method = _js2n__-prdslib.const "octet_counting", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          chunked_gelf =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      decompression =
                                        _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.const "Auto",
                                              _js2n__-prdslib.const "Gzip",
                                              _js2n__-prdslib.const "Zlib",
                                              _js2n__-prdslib.const "None"
                                            ],
                                      max_length =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.numbers.maximum
                                                9007199254740990,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      pending_messages_limit =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                              _js2n__-prdslib.numbers.maximum
                                                9007199254740990,
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      timeout_secs =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.maximum
                                                9007199254740990,
                                              _js2n__-prdslib.numbers.minimum
                                                (-9007199254740990)
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "method" ],
                      _js2n__-prdslib.records.record
                        { method = _js2n__-prdslib.const "chunked_gelf", } {}
                        true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/file_source::ReadFromConfig!predicate"
        | doc "File position to use when reading a new file."
        = _js2n__-prdslib.oneOf
            [ _js2n__-prdslib.const "beginning", _js2n__-prdslib.const "end" ],
      "_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate"
        | doc "A span of time, in fractional seconds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 9007199254740990,
              _js2n__-prdslib.numbers.minimum (-9007199254740990)
            ],
      "_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate"
        | doc "A span of time, in whole milliseconds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 9007199254740990,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/serde_with::DurationSeconds!predicate"
        | doc "A span of time, in whole seconds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.maximum 9007199254740990,
              _js2n__-prdslib.numbers.minimum 0
            ],
      "_js2n__-:definitions/stdlib::PathBuf!predicate"
        | doc "A file path."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "(\\/.*|[a-zA-Z]:\\\\(?:([^<>:\"\\/\\\\|?*]*[^<>:\"\\/\\\\|?*.]\\\\|..\\\\)*([^<>:\"\\/\\\\|?*]*[^<>:\"\\/\\\\|?*.]\\\\?|..\\\\))?)"
            ],
      "_js2n__-:definitions/stdlib::SocketAddr!predicate"
        | doc "An internet socket address, either IPv4 or IPv6."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/vector::amqp::AmqpConfig!predicate"
        | doc "AMQP connection options."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "connection_string" ],
              _js2n__-prdslib.records.record
                {
                  connection_string = _js2n__-prdslib.isType '"String",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::aws::auth::AwsAuthentication!predicate"
        | doc "Configuration of the authentication strategy for interacting with AWS services."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "access_key_id", "secret_access_key" ],
                  _js2n__-prdslib.records.record
                    {
                      access_key_id =
                        _js2n__-refsenv."_js2n__-:definitions/vector_common::sensitive_string::SensitiveString!predicate",
                      assume_role =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      external_id =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      region =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      secret_access_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_common::sensitive_string::SensitiveString!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "credentials_file" ],
                  _js2n__-prdslib.records.record
                    {
                      credentials_file = _js2n__-prdslib.isType '"String",
                      profile = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "assume_role" ],
                  _js2n__-prdslib.records.record
                    {
                      assume_role = _js2n__-prdslib.isType '"String",
                      external_id =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      imds =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  connect_timeout_seconds =
                                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                                  max_attempts =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            4294967295,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  read_timeout_seconds =
                                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                                } {} true _js2n__-prdslib.always
                            ],
                      load_timeout_secs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      region =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      imds =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  connect_timeout_seconds =
                                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                                  max_attempts =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            4294967295,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  read_timeout_seconds =
                                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                                } {} true _js2n__-prdslib.always
                            ],
                      load_timeout_secs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      region =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/vector::aws::region::RegionOrEndpoint!predicate"
        | doc "Configuration of the region/endpoint to use when interacting with an AWS service."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endpoint =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  region =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::conditions::AnyCondition!predicate"
        | doc m%"
          Many methods exist for matching events, such as using a VRL expression, a Datadog Search query string,
          or hard-coded matchers like "must be a metric" or "fields A, B, and C must match these constraints".
          
          As VRL is the most common way to apply conditions to events, this type provides a shortcut to define VRL expressions
          directly in the configuration by passing the VRL expression as a string:
          
          ```toml
          condition = '.message == "hooray"'
          ```
          
          When other condition types are required, they can be specified with an enum-style notation:
          
          ```toml
          condition.type = 'datadog_search'
          condition.source = 'NOT "foo"'
          ```
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "is_log", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "is_metric", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "is_trace", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "source" ],
                          _js2n__-prdslib.records.record
                            {
                              runtime = _js2n__-prdslib.isType '"String",
                              source = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "type" ],
                          _js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "vrl", } {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "source" ],
                          _js2n__-prdslib.records.record
                            { source = _js2n__-prdslib.isType '"String", } {}
                            true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "type" ],
                          _js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "datadog_search", }
                            {} true _js2n__-prdslib.always
                        ]
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::config::TestInput!predicate"
        | doc m%"
          An input describes not only the type of event to insert, but also which transform within the
          configuration to insert it to.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "insert_at" ],
              _js2n__-prdslib.records.record
                {
                  insert_at = _js2n__-prdslib.isType '"String",
                  log_fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.numbers.maximum
                                      9007199254740990,
                                    _js2n__-prdslib.numbers.minimum
                                      (-9007199254740990)
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.numbers.maximum
                                      9007199254740990,
                                    _js2n__-prdslib.numbers.minimum
                                      (-9007199254740990)
                                  ],
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        ],
                  metric =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          tags =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType 'Null,
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        (_js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.const
                                                              "Empty",
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [ "Single" ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    Single =
                                                                      _js2n__-prdslib.oneOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              'Null,
                                                                            _js2n__-prdslib.isType
                                                                              '"String"
                                                                          ],
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ],
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Record,
                                                                _js2n__-prdslib.records.required
                                                                  [ "Set" ],
                                                                _js2n__-prdslib.records.record
                                                                  {
                                                                    Set =
                                                                      _js2n__-prdslib.allOf
                                                                          [
                                                                            _js2n__-prdslib.isType
                                                                              '"Array",
                                                                            _js2n__-prdslib.arrays.arrayOf
                                                                              (_js2n__-prdslib.oneOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    'Null,
                                                                                  _js2n__-prdslib.isType
                                                                                    '"String"
                                                                                ]),
                                                                            _js2n__-prdslib.arrays.uniqueItems
                                                                          ],
                                                                  } {} true
                                                                  _js2n__-prdslib.always
                                                              ]
                                                          ])
                                                    ]
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "name" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          name =
                                            _js2n__-prdslib.isType '"String",
                                          namespace =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "kind" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          kind =
                                            _js2n__-refsenv."_js2n__-:definitions/vector_core::event::metric::MetricKind!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          interval_ms =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Integer,
                                                      _js2n__-prdslib.isType
                                                        'Null
                                                    ],
                                                  _js2n__-prdslib.numbers.maximum
                                                    4294967295,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          timestamp =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-refsenv."_js2n__-:definitions/vector_core::event::metric::value::MetricValue!predicate"
                                ]
                            ]
                        ],
                  source =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  type = _js2n__-prdslib.isType '"String",
                  value =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::config::dot_graph::GraphConfig!predicate"
        | doc "Configure output for component when generated with graph command"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  node_attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::config::source::SourceOuter!predicate"
        | doc "Fully resolved source component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      graph =
                        _js2n__-refsenv."_js2n__-:definitions/vector::config::dot_graph::GraphConfig!predicate",
                      proxy =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::proxy::ProxyConfig!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::sources::Sources!predicate"
            ],
      "_js2n__-:definitions/vector::config::unit_test::unit_test_components::UnitTestSourceConfig!predicate"
        | doc "Configuration for the `unit_test` source."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/vector::config::unit_test::unit_test_components::UnitTestStreamSourceConfig!predicate"
        | doc "Configuration for the `unit_test_stream` source."
        = _js2n__-prdslib.isType 'Record,
      "_js2n__-:definitions/vector::enrichment_tables::file::FileConfig!predicate"
        | doc "Configuration for the `file` enrichment table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "file" ],
              _js2n__-prdslib.records.record
                {
                  file =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "encoding", "path" ],
                          _js2n__-prdslib.records.record
                            {
                              encoding =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "type" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              delimiter =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.maxLength
                                                        1,
                                                      _js2n__-prdslib.strings.minLength
                                                        1
                                                    ],
                                              include_headers =
                                                _js2n__-prdslib.isType '"Bool",
                                              type =
                                                _js2n__-prdslib.const "csv",
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              path =
                                _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  schema =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::enrichment_tables::geoip::GeoipConfig!predicate"
        | doc "Configuration for the `geoip` enrichment table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  locale = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::enrichment_tables::mmdb::MmdbConfig!predicate"
        | doc "Configuration for the `mmdb` enrichment table."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::gcp::GcpAuthConfig!predicate"
        | doc "Configuration of the authentication strategy for interacting with GCP services."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api_key = _js2n__-prdslib.always,
                  credentials_path =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  skip_authentication = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::http::KeepaliveConfig!predicate"
        | doc "Configuration of HTTP server keepalive parameters."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  max_connection_age_jitter_factor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 1,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max_connection_age_secs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::internal_events::file::FileInternalMetricsConfig!predicate"
        | doc "Configuration of internal metrics for file-based components."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { include_file_tag = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::kafka::KafkaAuthConfig!predicate"
        | doc "Kafka authentication configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  sasl =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  enabled =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  mechanism =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                  password = _js2n__-prdslib.always,
                                  username =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::providers::http::HttpConfig!predicate"
        | doc "Configuration for the `http` provider."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      poll_interval_secs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      proxy =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::proxy::ProxyConfig!predicate",
                      request =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  headers =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record {} {}
                                            true
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                      url =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Null,
                  _js2n__-refsenv."_js2n__-:definitions/vector_core::tls::settings::TlsConfig!predicate"
                ]
            ],
      "_js2n__-:definitions/vector::secrets::aws_secrets_manager::AwsSecretsManagerBackend!predicate"
        | doc "Configuration for the `aws_secrets_manager` secrets backend."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "secret_id" ],
                  _js2n__-prdslib.records.record
                    {
                      auth =
                        _js2n__-refsenv."_js2n__-:definitions/vector::aws::auth::AwsAuthentication!predicate",
                      secret_id = _js2n__-prdslib.isType '"String",
                      tls = _js2n__-prdslib.always,
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::aws::region::RegionOrEndpoint!predicate"
            ],
      "_js2n__-:definitions/vector::secrets::directory::DirectoryBackend!predicate"
        | doc "Configuration for the `directory` secrets backend."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                  remove_trailing_whitespace = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::secrets::exec::ExecBackend!predicate"
        | doc "Configuration for the `exec` secrets backend."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::secrets::file::FileBackend!predicate"
        | doc "Configuration for the `file` secrets backend."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::secrets::test::TestBackend!predicate"
        | doc "Configuration for the `test` secrets backend."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "replacement" ],
              _js2n__-prdslib.records.record
                { replacement = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::Sources!predicate"
        | doc "Configurable sources in Vector."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::amqp::AmqpSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "amqp", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::apache_metrics::ApacheMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "apache_metrics", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::aws_ecs_metrics::AwsEcsMetricsSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "aws_ecs_metrics", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::aws_kinesis_firehose::AwsKinesisFirehoseConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "aws_kinesis_firehose", }
                        {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::aws_s3::AwsS3Config!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "aws_s3", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::aws_sqs::config::AwsSqsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "aws_sqs", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::datadog_agent::DatadogAgentConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "datadog_agent", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::demo_logs::DemoLogsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "demo_logs", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::dnstap::DnstapConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "dnstap", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::docker_logs::DockerLogsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "docker_logs", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::eventstoredb_metrics::EventStoreDbConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "eventstoredb_metrics", }
                        {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::exec::ExecConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "exec", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::file::FileConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "file", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::file_descriptors::file_descriptor::FileDescriptorSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "file_descriptor", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::fluent::FluentConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "fluent", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::gcp_pubsub::PubsubConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "gcp_pubsub", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::heroku_logs::LogplexConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "heroku_logs", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::HostMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "host_metrics", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::http_server::HttpConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "http", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::http_client::client::HttpClientConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "http_client", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::http_server::SimpleHttpConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "http_server", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::internal_logs::InternalLogsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "internal_logs", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::internal_metrics::InternalMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "internal_metrics", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::journald::JournaldConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "journald", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::kafka::KafkaSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "kafka", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::kubernetes_logs::Config!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "kubernetes_logs", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::logstash::LogstashConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "logstash", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::mongodb_metrics::MongoDbMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "mongodb_metrics", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::nats::NatsSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "nats", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::nginx_metrics::NginxMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "nginx_metrics", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::opentelemetry::OpentelemetryConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "opentelemetry", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::postgresql_metrics::PostgresqlMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "postgresql_metrics", }
                        {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::prometheus::pushgateway::PrometheusPushgatewayConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        {
                          type = _js2n__-prdslib.const "prometheus_pushgateway",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::prometheus::remote_write::PrometheusRemoteWriteConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        {
                          type =
                            _js2n__-prdslib.const "prometheus_remote_write",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::prometheus::scrape::PrometheusScrapeConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "prometheus_scrape", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::pulsar::PulsarSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "pulsar", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::redis::RedisSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "redis", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::socket::SocketConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "socket", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::splunk_hec::SplunkConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "splunk_hec", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::static_metrics::StaticMetricsConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "static_metrics", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::statsd::StatsdConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "statsd", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::file_descriptors::stdin::StdinConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "stdin", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::syslog::SyslogConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "syslog", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::config::unit_test::unit_test_components::UnitTestSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "unit_test", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::config::unit_test::unit_test_components::UnitTestStreamSourceConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "unit_test_stream", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/vector::sources::vector::VectorConfig!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "type" ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.const "vector", } {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::sources::amqp::AmqpSourceConfig!predicate"
        | doc "Supports AMQP version 0.9.1"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      acknowledgements =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                      consumer = _js2n__-prdslib.isType '"String",
                      decoding =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                      exchange_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      framing =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      offset_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      queue = _js2n__-prdslib.isType '"String",
                      routing_key_field =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::amqp::AmqpConfig!predicate"
            ],
      "_js2n__-:definitions/vector::sources::apache_metrics::ApacheMetricsConfig!predicate"
        | doc "Configuration for the `apache_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoints" ],
              _js2n__-prdslib.records.record
                {
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::aws_ecs_metrics::AwsEcsMetricsSourceConfig!predicate"
        | doc "Configuration for the `aws_ecs_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endpoint = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  version =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "v2",
                          _js2n__-prdslib.const "v3",
                          _js2n__-prdslib.const "v4"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::aws_kinesis_firehose::AwsKinesisFirehoseConfig!predicate"
        | doc "Configuration for the `aws_kinesis_firehose` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "address", "store_access_key" ],
              _js2n__-prdslib.records.record
                {
                  access_key = _js2n__-prdslib.always,
                  access_keys =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/vector_common::sensitive_string::SensitiveString!predicate"
                        ],
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  record_compression =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "auto",
                          _js2n__-prdslib.const "none",
                          _js2n__-prdslib.const "gzip"
                        ],
                  store_access_key = _js2n__-prdslib.isType '"Bool",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::aws_s3::AwsS3Config!predicate"
        | doc "Configuration for the `aws_s3` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      acknowledgements =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                      assume_role =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Null
                            ],
                      auth =
                        _js2n__-refsenv."_js2n__-:definitions/vector::aws::auth::AwsAuthentication!predicate",
                      compression =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.const "auto",
                              _js2n__-prdslib.const "none",
                              _js2n__-prdslib.const "gzip",
                              _js2n__-prdslib.const "zstd"
                            ],
                      decoding =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                      framing =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      multiline = _js2n__-prdslib.always,
                      sqs =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType 'Null,
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "queue_url" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          client_concurrency =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Integer,
                                                      _js2n__-prdslib.isType
                                                        'Null
                                                    ],
                                                  _js2n__-prdslib.numbers.maximum
                                                    9007199254740990,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          delete_failed_message =
                                            _js2n__-prdslib.isType '"Bool",
                                          delete_message =
                                            _js2n__-prdslib.isType '"Bool",
                                          max_number_of_messages =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.maximum
                                                    4294967295,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          poll_secs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.maximum
                                                    4294967295,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                          queue_url =
                                            _js2n__-prdslib.isType '"String",
                                          tls_options = _js2n__-prdslib.always,
                                          visibility_timeout_secs =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.maximum
                                                    4294967295,
                                                  _js2n__-prdslib.numbers.minimum
                                                    0
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              connect_timeout_seconds =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Integer,
                                                          _js2n__-prdslib.isType
                                                            'Null
                                                        ],
                                                      _js2n__-prdslib.numbers.maximum
                                                        9007199254740990,
                                                      _js2n__-prdslib.numbers.minimum
                                                        0
                                                    ],
                                              operation_timeout_seconds =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Integer,
                                                          _js2n__-prdslib.isType
                                                            'Null
                                                        ],
                                                      _js2n__-prdslib.numbers.maximum
                                                        9007199254740990,
                                                      _js2n__-prdslib.numbers.minimum
                                                        0
                                                    ],
                                              read_timeout_seconds =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Integer,
                                                          _js2n__-prdslib.isType
                                                            'Null
                                                        ],
                                                      _js2n__-prdslib.numbers.maximum
                                                        9007199254740990,
                                                      _js2n__-prdslib.numbers.minimum
                                                        0
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ]
                                ]
                            ],
                      strategy =
                        _js2n__-prdslib.oneOf [ _js2n__-prdslib.const "sqs" ],
                      tls_options = _js2n__-prdslib.always,
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::aws::region::RegionOrEndpoint!predicate"
            ],
      "_js2n__-:definitions/vector::sources::aws_sqs::config::AwsSqsConfig!predicate"
        | doc "Configuration for the `aws_sqs` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "queue_url" ],
                  _js2n__-prdslib.records.record
                    {
                      acknowledgements =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                      auth =
                        _js2n__-refsenv."_js2n__-:definitions/vector::aws::auth::AwsAuthentication!predicate",
                      client_concurrency =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 1
                            ],
                      decoding =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                      delete_message = _js2n__-prdslib.isType '"Bool",
                      framing =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      poll_secs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 4294967295,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      queue_url = _js2n__-prdslib.isType '"String",
                      tls = _js2n__-prdslib.always,
                      visibility_timeout_secs =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 4294967295,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::aws::region::RegionOrEndpoint!predicate"
            ],
      "_js2n__-:definitions/vector::sources::datadog_agent::DatadogAgentConfig!predicate"
        | doc "Configuration for the `datadog_agent` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  disable_logs = _js2n__-prdslib.isType '"Bool",
                  disable_metrics = _js2n__-prdslib.isType '"Bool",
                  disable_traces = _js2n__-prdslib.isType '"Bool",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  multiple_outputs = _js2n__-prdslib.isType '"Bool",
                  parse_ddtags = _js2n__-prdslib.isType '"Bool",
                  store_api_key = _js2n__-prdslib.isType '"Bool",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::demo_logs::DemoLogsConfig!predicate"
        | doc "Configuration for the `demo_logs` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      count =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      decoding =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                      framing =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                      interval =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "format", "lines" ],
                      _js2n__-prdslib.records.record
                        {
                          format = _js2n__-prdslib.const "shuffle",
                          lines =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          sequence = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        { format = _js2n__-prdslib.const "apache_common", } {}
                        true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        { format = _js2n__-prdslib.const "apache_error", } {}
                        true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        { format = _js2n__-prdslib.const "syslog", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        { format = _js2n__-prdslib.const "bsd_syslog", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "format" ],
                      _js2n__-prdslib.records.record
                        { format = _js2n__-prdslib.const "json", } {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::sources::dnstap::DnstapConfig!predicate"
        | doc "Configuration for the `dnstap` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      host_key = _js2n__-prdslib.always,
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      lowercase_hostnames = _js2n__-prdslib.isType '"Bool",
                      max_frame_handling_tasks =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 4294967295,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      max_frame_length =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      multithreaded =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      raw_data_only =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "address" ],
                          _js2n__-prdslib.records.record
                            {
                              address =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                              connection_limit =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.numbers.maximum
                                        4294967295,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              keepalive = _js2n__-prdslib.always,
                              max_connection_duration_secs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              permit_origin = _js2n__-prdslib.always,
                              port_key =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                              receive_buffer_bytes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              shutdown_timeout_secs =
                                _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                              tls = _js2n__-prdslib.always,
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "mode" ],
                          _js2n__-prdslib.records.record
                            { mode = _js2n__-prdslib.const "tcp", } {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "socket_path" ],
                          _js2n__-prdslib.records.record
                            {
                              socket_file_mode =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.numbers.maximum
                                        4294967295,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              socket_path =
                                _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                              socket_receive_buffer_size =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              socket_send_buffer_size =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "mode" ],
                          _js2n__-prdslib.records.record
                            { mode = _js2n__-prdslib.const "unix", } {} true
                            _js2n__-prdslib.always
                        ]
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::sources::docker_logs::DockerLogsConfig!predicate"
        | doc "Configuration for the `docker_logs` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auto_partial_merge = _js2n__-prdslib.isType '"Bool",
                  docker_host =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  exclude_containers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  host_key = _js2n__-prdslib.always,
                  include_containers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  include_images =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  include_labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  multiline = _js2n__-prdslib.always,
                  partial_event_marker_field =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  retry_backoff_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  tls =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "ca_file", "crt_file", "key_file" ],
                              _js2n__-prdslib.records.record
                                {
                                  ca_file =
                                    _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                                  crt_file =
                                    _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                                  key_file =
                                    _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::eventstoredb_metrics::EventStoreDbConfig!predicate"
        | doc "Configuration for the `eventstoredb_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  default_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  endpoint = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::exec::ExecConfig!predicate"
        | doc "Configuration for the `exec` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command", "mode" ],
              _js2n__-prdslib.records.record
                {
                  clear_environment = _js2n__-prdslib.isType '"Bool",
                  command =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  environment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  framing = _js2n__-prdslib.always,
                  include_stderr = _js2n__-prdslib.isType '"Bool",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  maximum_buffer_size_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  mode =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "scheduled",
                          _js2n__-prdslib.const "streaming"
                        ],
                  scheduled =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  exec_interval_secs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  streaming =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  respawn_interval_secs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  respawn_on_exit =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  working_directory = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::file::FileConfig!predicate"
        | doc "Configuration for the `file` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "include" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  data_dir = _js2n__-prdslib.always,
                  encoding =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "charset" ],
                              _js2n__-prdslib.records.record
                                { charset = _js2n__-prdslib.isType '"String", }
                                {} true _js2n__-prdslib.always
                            ]
                        ],
                  exclude =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate"
                        ],
                  file_key =
                    _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                  fingerprint =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "strategy" ],
                              _js2n__-prdslib.records.record
                                {
                                  bytes =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType 'Integer,
                                              _js2n__-prdslib.isType 'Null
                                            ],
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  ignored_header_bytes =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  lines =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  strategy = _js2n__-prdslib.const "checksum",
                                } {} true _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "strategy" ],
                              _js2n__-prdslib.records.record
                                {
                                  strategy =
                                    _js2n__-prdslib.const "device_and_inode",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  glob_minimum_cooldown_ms =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                  host_key = _js2n__-prdslib.always,
                  ignore_checkpoints =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  ignore_not_found = _js2n__-prdslib.isType '"Bool",
                  ignore_older_secs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  include =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate"
                        ],
                  internal_metrics =
                    _js2n__-refsenv."_js2n__-:definitions/vector::internal_events::file::FileInternalMetricsConfig!predicate",
                  line_delimiter = _js2n__-prdslib.isType '"String",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  max_line_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max_read_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  message_start_indicator =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  multi_line_timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  multiline = _js2n__-prdslib.always,
                  offset_key = _js2n__-prdslib.always,
                  oldest_first = _js2n__-prdslib.isType '"Bool",
                  read_from =
                    _js2n__-refsenv."_js2n__-:definitions/file_source::ReadFromConfig!predicate",
                  remove_after_secs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  rotate_wait_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  start_at_beginning =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::file_descriptors::file_descriptor::FileDescriptorSourceConfig!predicate"
        | doc "Configuration for the `file_descriptor` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "fd" ],
              _js2n__-prdslib.records.record
                {
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  fd =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 4294967295,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  framing = _js2n__-prdslib.always,
                  host_key = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  max_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::file_descriptors::stdin::StdinConfig!predicate"
        | doc "Configuration for the `stdin` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  framing = _js2n__-prdslib.always,
                  host_key = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  max_length =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::fluent::FluentConfig!predicate"
        | doc "Configuration for the `fluent` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                  connection_limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 4294967295,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  keepalive = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  permit_origin = _js2n__-prdslib.always,
                  receive_buffer_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::gcp_pubsub::PubsubConfig!predicate"
        | doc "Configuration for the `gcp_pubsub` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "project", "subscription" ],
                  _js2n__-prdslib.records.record
                    {
                      ack_deadline_seconds =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 65535,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      ack_deadline_secs =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                      acknowledgements =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                      decoding =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                      endpoint = _js2n__-prdslib.isType '"String",
                      framing =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                      full_response_size =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      keepalive_secs =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      max_concurrency =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      poll_time_seconds =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                      project = _js2n__-prdslib.isType '"String",
                      retry_delay_seconds =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Number",
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum
                                (-9007199254740990)
                            ],
                      retry_delay_secs =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                      subscription = _js2n__-prdslib.isType '"String",
                      tls = _js2n__-prdslib.always,
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::gcp::GcpAuthConfig!predicate"
            ],
      "_js2n__-:definitions/vector::sources::heroku_logs::LogplexConfig!predicate"
        | doc "Configuration for `heroku_logs` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  auth = _js2n__-prdslib.always,
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  query_parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate"
        | doc "Filtering configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::host_metrics::HostMetricsConfig!predicate"
        | doc "Configuration for the `host_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cgroups =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  base = _js2n__-prdslib.always,
                                  base_dir = _js2n__-prdslib.always,
                                  groups =
                                    _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                                  levels =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  collectors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.const "cgroups",
                                _js2n__-prdslib.const "cpu",
                                _js2n__-prdslib.const "process",
                                _js2n__-prdslib.const "disk",
                                _js2n__-prdslib.const "filesystem",
                                _js2n__-prdslib.const "load",
                                _js2n__-prdslib.const "host",
                                _js2n__-prdslib.const "memory",
                                _js2n__-prdslib.const "network"
                              ])
                        ],
                  disk =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              devices =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  filesystem =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              devices =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                              filesystems =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                              mountpoints =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  network =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              devices =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  process =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              processes =
                                _js2n__-refsenv."_js2n__-:definitions/vector::sources::host_metrics::FilterList!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::http_client::client::HttpClientConfig!predicate"
        | doc "Configuration for the `http_client` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoint" ],
              _js2n__-prdslib.records.record
                {
                  auth = _js2n__-prdslib.always,
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  method =
                    _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::http::method::HttpMethod!predicate",
                  query =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  scrape_timeout_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::http_server::HttpConfig!predicate"
        | doc "Configuration for the `http` source."
        = _js2n__-refsenv."_js2n__-:definitions/vector::sources::http_server::SimpleHttpConfig!predicate",
      "_js2n__-:definitions/vector::sources::http_server::SimpleHttpConfig!predicate"
        | doc "Configuration for the `http_server` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  auth = _js2n__-prdslib.always,
                  decoding =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "codec" ],
                                  _js2n__-prdslib.records.record
                                    { codec = _js2n__-prdslib.const "bytes", }
                                    {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          json =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      lossy =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          codec = _js2n__-prdslib.const "json",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          protobuf =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [
                                                      "desc_file",
                                                      "message_type"
                                                    ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      desc_file =
                                                        _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                                                      message_type =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          codec =
                                            _js2n__-prdslib.const "protobuf",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          syslog =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      lossy =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          codec =
                                            _js2n__-prdslib.const "syslog",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "codec" ],
                                  _js2n__-prdslib.records.record
                                    { codec = _js2n__-prdslib.const "native", }
                                    {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          native_json =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      lossy =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          codec =
                                            _js2n__-prdslib.const "native_json",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          gelf =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      lossy =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          codec = _js2n__-prdslib.const "gelf",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          influxdb =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      lossy =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          codec =
                                            _js2n__-prdslib.const "influxdb",
                                        } {} true _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "avro", "codec" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      avro =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [
                                                  "schema",
                                                  "strip_schema_id_prefix"
                                                ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  schema =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  strip_schema_id_prefix =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} true _js2n__-prdslib.always
                                            ],
                                      codec = _js2n__-prdslib.const "avro",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "vrl" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          vrl =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "source" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      source =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      timezone =
                                                        _js2n__-prdslib.always,
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "codec" ],
                                      _js2n__-prdslib.records.record
                                        { codec = _js2n__-prdslib.const "vrl", }
                                        {} true _js2n__-prdslib.always
                                    ]
                                ]
                            ]
                        ],
                  encoding =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.const "text",
                              _js2n__-prdslib.const "ndjson",
                              _js2n__-prdslib.const "json",
                              _js2n__-prdslib.const "binary"
                            ]
                        ],
                  framing = _js2n__-prdslib.always,
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  host_key =
                    _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  method =
                    _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::http::method::HttpMethod!predicate",
                  path = _js2n__-prdslib.isType '"String",
                  path_key =
                    _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                  query_parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  response_code =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 65535,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  strict_path = _js2n__-prdslib.isType '"Bool",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::internal_logs::InternalLogsConfig!predicate"
        | doc "Configuration for the `internal_logs` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  host_key = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pid_key =
                    _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::internal_metrics::InternalMetricsConfig!predicate"
        | doc "Configuration for the `internal_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  namespace = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              host_key = _js2n__-prdslib.always,
                              pid_key =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType 'Null
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::journald::JournaldConfig!predicate"
        | doc "Configuration for the `journald` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  batch_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  current_boot_only = _js2n__-prdslib.isType '"Bool",
                  data_dir = _js2n__-prdslib.always,
                  emit_cursor = _js2n__-prdslib.isType '"Bool",
                  exclude_matches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String"),
                                _js2n__-prdslib.arrays.uniqueItems
                              ])
                        ],
                  exclude_units =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extra_args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  include_matches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String"),
                                _js2n__-prdslib.arrays.uniqueItems
                              ])
                        ],
                  include_units =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  journal_directory = _js2n__-prdslib.always,
                  journal_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  journalctl_path = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  remap_priority = _js2n__-prdslib.isType '"Bool",
                  since_now = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::kafka::KafkaSourceConfig!predicate"
        | doc "Configuration for the `kafka` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required
                    [ "bootstrap_servers", "group_id", "topics" ],
                  _js2n__-prdslib.records.record
                    {
                      acknowledgements =
                        _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                      auto_offset_reset = _js2n__-prdslib.isType '"String",
                      bootstrap_servers = _js2n__-prdslib.isType '"String",
                      commit_interval_ms =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                      decoding =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                      drain_timeout_ms =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                      fetch_wait_max_ms =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                      framing =
                        _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                      group_id = _js2n__-prdslib.isType '"String",
                      headers_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      key_field =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      librdkafka_options =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.isType 'Null
                                ],
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ],
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      metrics =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "topic_lag_metric" ],
                              _js2n__-prdslib.records.record
                                {
                                  topic_lag_metric =
                                    _js2n__-prdslib.isType '"Bool",
                                } {} true _js2n__-prdslib.always
                            ],
                      offset_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      partition_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      session_timeout_ms =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                      socket_timeout_ms =
                        _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                      topic_key =
                        _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                      topics =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-refsenv."_js2n__-:definitions/vector::kafka::KafkaAuthConfig!predicate"
            ],
      "_js2n__-:definitions/vector::sources::kubernetes_logs::Config!predicate"
        | doc "Configuration for the `kubernetes_logs` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  auto_partial_merge = _js2n__-prdslib.isType '"Bool",
                  data_dir = _js2n__-prdslib.always,
                  delay_deletion_ms =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                  exclude_paths_glob_patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate"
                        ],
                  extra_field_selector = _js2n__-prdslib.isType '"String",
                  extra_label_selector = _js2n__-prdslib.isType '"String",
                  extra_namespace_label_selector =
                    _js2n__-prdslib.isType '"String",
                  fingerprint_lines =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  glob_minimum_cooldown_ms =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationMilliSeconds!predicate",
                  ignore_older_secs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  include_paths_glob_patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate"
                        ],
                  ingestion_timestamp_field = _js2n__-prdslib.always,
                  internal_metrics =
                    _js2n__-refsenv."_js2n__-:definitions/vector::internal_events::file::FileInternalMetricsConfig!predicate",
                  kube_config_file = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  max_line_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  max_read_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  namespace_annotation_fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              namespace_labels =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  node_annotation_fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              node_labels =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  oldest_first = _js2n__-prdslib.isType '"Bool",
                  pod_annotation_fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              container_id =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              container_image =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              container_image_id =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              container_name =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_annotations =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_ip =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_ips =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_labels =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_name =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_namespace =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_node_name =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_owner =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              pod_uid =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  read_from =
                    _js2n__-refsenv."_js2n__-:definitions/file_source::ReadFromConfig!predicate",
                  rotate_wait_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  self_node_name = _js2n__-prdslib.isType '"String",
                  timezone = _js2n__-prdslib.always,
                  use_apiserver_cache = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::logstash::LogstashConfig!predicate"
        | doc "Configuration for the `logstash` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                  connection_limit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 4294967295,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  keepalive = _js2n__-prdslib.always,
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  permit_origin = _js2n__-prdslib.always,
                  receive_buffer_bytes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::mongodb_metrics::MongoDbMetricsConfig!predicate"
        | doc "Configuration for the `mongodb_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoints" ],
              _js2n__-prdslib.records.record
                {
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::nats::NatsSourceConfig!predicate"
        | doc "Configuration for the `nats` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "connection_name", "subject", "url" ],
              _js2n__-prdslib.records.record
                {
                  auth = _js2n__-prdslib.always,
                  connection_name = _js2n__-prdslib.isType '"String",
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  queue =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  subject = _js2n__-prdslib.isType '"String",
                  subject_key_field =
                    _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                  subscriber_capacity =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  tls = _js2n__-prdslib.always,
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::nginx_metrics::NginxMetricsConfig!predicate"
        | doc "Configuration for the `nginx_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoints" ],
              _js2n__-prdslib.records.record
                {
                  auth = _js2n__-prdslib.always,
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::opentelemetry::OpentelemetryConfig!predicate"
        | doc "Configuration for the `opentelemetry` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "grpc", "http" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  grpc =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "address" ],
                          _js2n__-prdslib.records.record
                            {
                              address =
                                _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                              tls = _js2n__-prdslib.always,
                            } {} true _js2n__-prdslib.always
                        ],
                  http =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "address" ],
                          _js2n__-prdslib.records.record
                            {
                              address =
                                _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                              headers =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              keepalive =
                                _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                              tls = _js2n__-prdslib.always,
                            } {} true _js2n__-prdslib.always
                        ],
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::postgresql_metrics::PostgresqlMetricsConfig!predicate"
        | doc "Configuration for the `postgresql_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoints" ],
              _js2n__-prdslib.records.record
                {
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  exclude_databases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  include_databases =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  tls =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "ca_file" ],
                              _js2n__-prdslib.records.record
                                {
                                  ca_file =
                                    _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::prometheus::pushgateway::PrometheusPushgatewayConfig!predicate"
        | doc "Configuration for the `prometheus_pushgateway` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  aggregate_metrics = _js2n__-prdslib.isType '"Bool",
                  auth = _js2n__-prdslib.always,
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::prometheus::remote_write::PrometheusRemoteWriteConfig!predicate"
        | doc "Configuration for the `prometheus_remote_write` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  auth = _js2n__-prdslib.always,
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::prometheus::scrape::PrometheusScrapeConfig!predicate"
        | doc "Configuration for the `prometheus_scrape` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoints" ],
              _js2n__-prdslib.records.record
                {
                  auth = _js2n__-prdslib.always,
                  endpoint_tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  honor_labels = _js2n__-prdslib.isType '"Bool",
                  instance_tag =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  query =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ])
                        ],
                  scrape_interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                  scrape_timeout_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                  tls = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::pulsar::PulsarSourceConfig!predicate"
        | doc "Configuration for the `pulsar` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoint", "topics" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  auth =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "name", "token" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      name = _js2n__-prdslib.isType '"String",
                                      token =
                                        _js2n__-refsenv."_js2n__-:definitions/vector_common::sensitive_string::SensitiveString!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required [ "oauth2" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      oauth2 =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [
                                                  "credentials_url",
                                                  "issuer_url"
                                                ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  audience =
                                                    _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.isType
                                                            'Null
                                                        ],
                                                  credentials_url =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  issuer_url =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  scope =
                                                    _js2n__-prdslib.anyOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.isType
                                                            'Null
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ],
                                    } {} true _js2n__-prdslib.always
                                ]
                            ]
                        ],
                  batch_size =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 4294967295,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  consumer_name =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  dead_letter_queue_policy =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "dead_letter_topic", "max_redeliver_count" ],
                              _js2n__-prdslib.records.record
                                {
                                  dead_letter_topic =
                                    _js2n__-prdslib.isType '"String",
                                  max_redeliver_count =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  endpoint = _js2n__-prdslib.isType '"String",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  priority_level =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 2147483647,
                          _js2n__-prdslib.numbers.minimum (-2147483648)
                        ],
                  subscription_name =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  topics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::redis::RedisSourceConfig!predicate"
        | doc "Configuration for the `redis` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "url" ],
              _js2n__-prdslib.records.record
                {
                  data_type =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.const "list",
                          _js2n__-prdslib.const "channel"
                        ],
                  decoding =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                  framing =
                    _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::FramingConfig!predicate",
                  key = _js2n__-prdslib.isType '"String",
                  list =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "method" ],
                              _js2n__-prdslib.records.record
                                {
                                  method =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.const "lpop",
                                          _js2n__-prdslib.const "rpop"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  redis_key = _js2n__-prdslib.always,
                  url = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::socket::SocketConfig!predicate"
        | doc "Configuration for the `socket` source."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record
                        {
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                          connection_limit =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum 4294967295,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          decoding =
                            _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                          framing = _js2n__-prdslib.always,
                          host_key = _js2n__-prdslib.always,
                          keepalive = _js2n__-prdslib.always,
                          log_namespace =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType 'Null
                                ],
                          max_connection_duration_secs =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          permit_origin = _js2n__-prdslib.always,
                          port_key =
                            _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                          receive_buffer_bytes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          shutdown_timeout_secs =
                            _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                          tls = _js2n__-prdslib.always,
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "tcp", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record
                        {
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                          decoding =
                            _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                          framing = _js2n__-prdslib.always,
                          host_key = _js2n__-prdslib.always,
                          log_namespace =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType 'Null
                                ],
                          max_length =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          port_key =
                            _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                          receive_buffer_bytes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "udp", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "path" ],
                      _js2n__-prdslib.records.record
                        {
                          decoding =
                            _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                          framing = _js2n__-prdslib.always,
                          host_key =
                            _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                          log_namespace =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType 'Null
                                ],
                          path =
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                          socket_file_mode =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum 4294967295,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "unix_datagram", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "path" ],
                      _js2n__-prdslib.records.record
                        {
                          decoding =
                            _js2n__-refsenv."_js2n__-:definitions/codecs::decoding::DeserializerConfig!predicate",
                          framing = _js2n__-prdslib.always,
                          host_key =
                            _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate",
                          log_namespace =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"Bool",
                                  _js2n__-prdslib.isType 'Null
                                ],
                          path =
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                          socket_file_mode =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum 4294967295,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "unix_stream", } {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::sources::splunk_hec::SplunkConfig!predicate"
        | doc "Configuration for the `splunk_hec` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ack_idle_cleanup = _js2n__-prdslib.isType '"Bool",
                              enabled =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType 'Null
                                    ],
                              max_idle_time =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              max_number_of_ack_channels =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              max_pending_acks =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                              max_pending_acks_per_channel =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.maximum
                                        9007199254740990,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  keepalive =
                    _js2n__-refsenv."_js2n__-:definitions/vector::http::KeepaliveConfig!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  store_hec_token = _js2n__-prdslib.isType '"Bool",
                  tls = _js2n__-prdslib.always,
                  token = _js2n__-prdslib.always,
                  valid_tokens =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/vector_common::sensitive_string::SensitiveString!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::static_metrics::StaticMetricsConfig!predicate"
        | doc "Configuration for the `static_metrics` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  interval_secs =
                    _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationFractionalSeconds!predicate",
                  metrics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "kind", "name", "value" ],
                                _js2n__-prdslib.records.record
                                  {
                                    kind =
                                      _js2n__-refsenv."_js2n__-:definitions/vector_core::event::metric::MetricKind!predicate",
                                    name = _js2n__-prdslib.isType '"String",
                                    tags =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    value =
                                      _js2n__-refsenv."_js2n__-:definitions/vector_core::event::metric::value::MetricValue!predicate",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector::sources::statsd::StatsdConfig!predicate"
        | doc "Configuration for the `statsd` source."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record
                        {
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                          connection_limit =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum 4294967295,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          keepalive = _js2n__-prdslib.always,
                          permit_origin = _js2n__-prdslib.always,
                          receive_buffer_bytes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          sanitize = _js2n__-prdslib.isType '"Bool",
                          shutdown_timeout_secs =
                            _js2n__-refsenv."_js2n__-:definitions/serde_with::DurationSeconds!predicate",
                          tls = _js2n__-prdslib.always,
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "tcp", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address" ],
                      _js2n__-prdslib.records.record
                        {
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                          receive_buffer_bytes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          sanitize = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "udp", } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "path" ],
                      _js2n__-prdslib.records.record
                        {
                          path =
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                          sanitize = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode" ],
                      _js2n__-prdslib.records.record
                        { mode = _js2n__-prdslib.const "unix", } {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::sources::syslog::SyslogConfig!predicate"
        | doc "Configuration for the `syslog` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      host_key = _js2n__-prdslib.always,
                      log_namespace =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                      max_length =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 9007199254740990,
                              _js2n__-prdslib.numbers.minimum 0
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address", "mode" ],
                      _js2n__-prdslib.records.record
                        {
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                          connection_limit =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum 4294967295,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          keepalive = _js2n__-prdslib.always,
                          mode = _js2n__-prdslib.const "tcp",
                          permit_origin = _js2n__-prdslib.always,
                          receive_buffer_bytes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                          tls = _js2n__-prdslib.always,
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "address", "mode" ],
                      _js2n__-prdslib.records.record
                        {
                          address =
                            _js2n__-refsenv."_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate",
                          mode = _js2n__-prdslib.const "udp",
                          receive_buffer_bytes =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum
                                    9007199254740990,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "mode", "path" ],
                      _js2n__-prdslib.records.record
                        {
                          mode = _js2n__-prdslib.const "unix",
                          path =
                            _js2n__-refsenv."_js2n__-:definitions/stdlib::PathBuf!predicate",
                          socket_file_mode =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.numbers.maximum 4294967295,
                                  _js2n__-prdslib.numbers.minimum 0
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/vector::sources::util::http::method::HttpMethod!predicate"
        | doc "HTTP method."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.const "HEAD",
              _js2n__-prdslib.const "GET",
              _js2n__-prdslib.const "POST",
              _js2n__-prdslib.const "PUT",
              _js2n__-prdslib.const "PATCH",
              _js2n__-prdslib.const "DELETE",
              _js2n__-prdslib.const "OPTIONS"
            ],
      "_js2n__-:definitions/vector::sources::util::net::SocketListenAddr!predicate"
        | doc "If a socket address is used, it _must_ include a port."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/vector::sources::vector::VectorConfig!predicate"
        | doc "Configuration for the `vector` source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "address" ],
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate",
                  address =
                    _js2n__-refsenv."_js2n__-:definitions/stdlib::SocketAddr!predicate",
                  log_namespace =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  tls = _js2n__-prdslib.always,
                  version =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.oneOf [ _js2n__-prdslib.const "2" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector_common::sensitive_string::SensitiveString!predicate"
        | doc "Wrapper for sensitive strings containing credentials"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/vector_core::config::AcknowledgementsConfig!predicate"
        | doc m%"
          See [End-to-end Acknowledgements][e2e_acks] for more information on how event acknowledgement is handled.
          
          [e2e_acks]: https://vector.dev/docs/about/under-the-hood/architecture/end-to-end-acknowledgements/
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector_core::config::SourceAcknowledgementsConfig!predicate"
        | doc m%"
          This setting is **deprecated** in favor of enabling `acknowledgements` at the [global][global_acks] or sink level.
          
          Enabling or disabling acknowledgements at the source level has **no effect** on acknowledgement behavior.
          
          See [End-to-end Acknowledgements][e2e_acks] for more information on how event acknowledgement is handled.
          
          [global_acks]: https://vector.dev/docs/reference/configuration/global-options/#acknowledgements
          [e2e_acks]: https://vector.dev/docs/about/under-the-hood/architecture/end-to-end-acknowledgements/
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector_core::config::proxy::ProxyConfig!predicate"
        | doc m%"
          Configure to proxy traffic through an HTTP(S) proxy when making external requests.
          
          Similar to common proxy configuration convention, you can set different proxies
          to use based on the type of traffic being proxied. You can also set specific hosts that
          should not be proxied.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  http =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  https =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  no_proxy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector_core::event::metric::MetricKind!predicate"
        | doc m%"
          Metrics can be either absolute or incremental. Absolute metrics represent a sort of "last write wins" scenario,
          where the latest absolute value seen is meant to be the actual metric value.  In contrast, and perhaps intuitively,
          incremental metrics are meant to be additive, such that we don't know what total value of the metric is, but we know
          that we'll be adding or subtracting the given value from it.
          
          Generally speaking, most metrics storage systems deal with incremental updates. A notable exception is Prometheus,
          which deals with, and expects, absolute values from clients.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.const "incremental",
              _js2n__-prdslib.const "absolute"
            ],
      "_js2n__-:definitions/vector_core::event::metric::value::MetricValue!predicate"
        | doc m%"
          Metric value.
          Container for the actual value of a metric.
        "%
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "counter" ],
                  _js2n__-prdslib.records.record
                    {
                      counter =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "value" ],
                              _js2n__-prdslib.records.record
                                {
                                  value =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum
                                            (-9007199254740990)
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "gauge" ],
                  _js2n__-prdslib.records.record
                    {
                      gauge =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "value" ],
                              _js2n__-prdslib.records.record
                                {
                                  value =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum
                                            (-9007199254740990)
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "set" ],
                  _js2n__-prdslib.records.record
                    {
                      set =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "values" ],
                              _js2n__-prdslib.records.record
                                {
                                  values =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String"),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "distribution" ],
                  _js2n__-prdslib.records.record
                    {
                      distribution =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "samples", "statistic" ],
                              _js2n__-prdslib.records.record
                                {
                                  samples =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "rate", "value" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    rate =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Integer,
                                                            _js2n__-prdslib.numbers.maximum
                                                              4294967295,
                                                            _js2n__-prdslib.numbers.minimum
                                                              0
                                                          ],
                                                    value =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              9007199254740990,
                                                            _js2n__-prdslib.numbers.minimum
                                                              (-9007199254740990)
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ])
                                        ],
                                  statistic =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.const "histogram",
                                          _js2n__-prdslib.const "summary"
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "aggregated_histogram" ],
                  _js2n__-prdslib.records.record
                    {
                      aggregated_histogram =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "buckets", "count", "sum" ],
                              _js2n__-prdslib.records.record
                                {
                                  buckets =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "count", "upper_limit" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    count =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Integer,
                                                            _js2n__-prdslib.numbers.maximum
                                                              9007199254740990,
                                                            _js2n__-prdslib.numbers.minimum
                                                              0
                                                          ],
                                                    upper_limit =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              9007199254740990,
                                                            _js2n__-prdslib.numbers.minimum
                                                              (-9007199254740990)
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ])
                                        ],
                                  count =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  sum =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum
                                            (-9007199254740990)
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "aggregated_summary" ],
                  _js2n__-prdslib.records.record
                    {
                      aggregated_summary =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "count", "quantiles", "sum" ],
                              _js2n__-prdslib.records.record
                                {
                                  count =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  quantiles =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "quantile", "value" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    quantile =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              9007199254740990,
                                                            _js2n__-prdslib.numbers.minimum
                                                              (-9007199254740990)
                                                          ],
                                                    value =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.numbers.maximum
                                                              9007199254740990,
                                                            _js2n__-prdslib.numbers.minimum
                                                              (-9007199254740990)
                                                          ],
                                                  } {} true
                                                  _js2n__-prdslib.always
                                              ])
                                        ],
                                  sum =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum
                                            (-9007199254740990)
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "sketch" ],
                  _js2n__-prdslib.records.record
                    {
                      sketch =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "sketch" ],
                              _js2n__-prdslib.records.record
                                {
                                  sketch =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "AgentDDSketch" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  AgentDDSketch =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [
                                                              "avg",
                                                              "bins",
                                                              "count",
                                                              "max",
                                                              "min",
                                                              "sum"
                                                            ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              avg =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"Number",
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        9007199254740990,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        (-9007199254740990)
                                                                    ],
                                                              bins =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Record,
                                                                      _js2n__-prdslib.records.required
                                                                        [
                                                                          "k",
                                                                          "n"
                                                                        ],
                                                                      _js2n__-prdslib.records.record
                                                                        {
                                                                          k =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    '"Array",
                                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                                    (_js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Integer,
                                                                                        _js2n__-prdslib.numbers.maximum
                                                                                          32767,
                                                                                        _js2n__-prdslib.numbers.minimum
                                                                                          (-32768)
                                                                                      ])
                                                                                ],
                                                                          n =
                                                                            _js2n__-prdslib.allOf
                                                                                [
                                                                                  _js2n__-prdslib.isType
                                                                                    '"Array",
                                                                                  _js2n__-prdslib.arrays.arrayOf
                                                                                    (_js2n__-prdslib.allOf
                                                                                      [
                                                                                        _js2n__-prdslib.isType
                                                                                          'Integer,
                                                                                        _js2n__-prdslib.numbers.maximum
                                                                                          65535,
                                                                                        _js2n__-prdslib.numbers.minimum
                                                                                          0
                                                                                      ])
                                                                                ],
                                                                        } {}
                                                                        true
                                                                        _js2n__-prdslib.always
                                                                    ],
                                                              count =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        'Integer,
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        4294967295,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        0
                                                                    ],
                                                              max =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"Number",
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        9007199254740990,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        (-9007199254740990)
                                                                    ],
                                                              min =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"Number",
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        9007199254740990,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        (-9007199254740990)
                                                                    ],
                                                              sum =
                                                                _js2n__-prdslib.allOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"Number",
                                                                      _js2n__-prdslib.numbers.maximum
                                                                        9007199254740990,
                                                                      _js2n__-prdslib.numbers.minimum
                                                                        (-9007199254740990)
                                                                    ],
                                                            } {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                } {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/vector_core::tls::settings::TlsConfig!predicate"
        | doc "TLS configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  alpn_protocols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ca_file = _js2n__-prdslib.always,
                  crt_file = _js2n__-prdslib.always,
                  key_file = _js2n__-prdslib.always,
                  key_pass =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  server_name =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  verify_certificate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  verify_hostname =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate"
        | doc "An optional path that deserializes an empty string to `None`."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalValuePath!predicate"
        | doc "An optional path that deserializes an empty string to `None`."
        = _js2n__-prdslib.isType '"String",
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  api =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              address =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType 'Null,
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              enabled = _js2n__-prdslib.isType '"Bool",
                              graphql = _js2n__-prdslib.isType '"Bool",
                              playground = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  enrichment_tables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::enrichment_tables::file::FileConfig!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "file",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::enrichment_tables::geoip::GeoipConfig!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "geoip",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::enrichment_tables::mmdb::MmdbConfig!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "mmdb",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ]
                              ])
                        ],
                  healthchecks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enabled = _js2n__-prdslib.isType '"Bool",
                              require_healthy = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  provider =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/vector::providers::http::HttpConfig!predicate",
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "type" ],
                                      _js2n__-prdslib.records.record
                                        { type = _js2n__-prdslib.const "http", }
                                        {} true _js2n__-prdslib.always
                                    ]
                                ]
                            ]
                        ],
                  schema =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              enabled = _js2n__-prdslib.isType '"Bool",
                              log_namespace =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType 'Null
                                    ],
                              validation = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ],
                  secret =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::secrets::file::FileBackend!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "file",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::secrets::directory::DirectoryBackend!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "directory",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::secrets::exec::ExecBackend!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "exec",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::secrets::aws_secrets_manager::AwsSecretsManagerBackend!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "aws_secrets_manager",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/vector::secrets::test::TestBackend!predicate",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "type" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "test",
                                          } {} true _js2n__-prdslib.always
                                      ]
                                  ]
                              ])
                        ],
                  sinks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                  sources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/vector::config::source::SourceOuter!predicate"
                        ],
                  tests =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "name" ],
                                _js2n__-prdslib.records.record
                                  {
                                    input =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType 'Null,
                                            _js2n__-refsenv."_js2n__-:definitions/vector::config::TestInput!predicate"
                                          ],
                                    inputs =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              _js2n__-refsenv."_js2n__-:definitions/vector::config::TestInput!predicate"
                                          ],
                                    name = _js2n__-prdslib.isType '"String",
                                    no_outputs_from =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    outputs =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.required
                                                    [ "extract_from" ],
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      conditions =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.anyOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"Array",
                                                                  _js2n__-prdslib.isType
                                                                    'Null
                                                                ],
                                                              _js2n__-prdslib.arrays.arrayOf
                                                                _js2n__-refsenv."_js2n__-:definitions/vector::conditions::AnyCondition!predicate"
                                                            ],
                                                      extract_from =
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
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ])
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  transforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  acknowledgements =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::AcknowledgementsConfig!predicate",
                  data_dir = _js2n__-prdslib.always,
                  expire_metrics =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Null,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "nsecs", "secs" ],
                              _js2n__-prdslib.records.record
                                {
                                  nsecs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            4294967295,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                  secs =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.numbers.maximum
                                            9007199254740990,
                                          _js2n__-prdslib.numbers.minimum 0
                                        ],
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  expire_metrics_secs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType 'Null
                            ],
                          _js2n__-prdslib.numbers.maximum 9007199254740990,
                          _js2n__-prdslib.numbers.minimum (-9007199254740990)
                        ],
                  log_schema =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              host_key =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              message_key =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              metadata_key =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              source_type_key =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                              timestamp_key =
                                _js2n__-refsenv."_js2n__-:definitions/vector_lookup::lookup_v2::optional_path::OptionalTargetPath!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  proxy =
                    _js2n__-refsenv."_js2n__-:definitions/vector_core::config::proxy::ProxyConfig!predicate",
                  telemetry =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              tags =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          emit_service =
                                            _js2n__-prdslib.isType '"Bool",
                                          emit_source =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  timezone = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ]
        ])