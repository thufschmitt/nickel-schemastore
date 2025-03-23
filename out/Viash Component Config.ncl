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
      "_js2n__-:definitions/ApkRequirements!predicate"
        | doc "Specify which apk packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  packages =
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
                  type = _js2n__-prdslib.const "apk",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AptRequirements!predicate"
        | doc "Specify which apt packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  interactive = _js2n__-prdslib.isType '"Bool",
                  packages =
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
                  type = _js2n__-prdslib.const "apt",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Argument!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/BooleanArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BooleanFalseArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BooleanTrueArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DoubleArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/FileArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/IntegerArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/LongArgument!predicate",
              _js2n__-refsenv."_js2n__-:definitions/StringArgument!predicate"
            ],
      "_js2n__-:definitions/ArgumentGroup!predicate"
        | doc "A grouping of the arguments, used to display the help message."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Argument!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  summary = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Author!predicate"
        | doc "Author metadata."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  email = _js2n__-prdslib.isType '"String",
                  info = _js2n__-prdslib.isType 'Record,
                  name = _js2n__-prdslib.isType '"String",
                  roles =
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
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BashScript!predicate"
        | doc m%"
          An executable Bash script.
          When defined in resources, only the first entry will be executed when running the built component or when running `viash run`.
          When defined in test_resources, all entries will be executed during `viash test`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "bash_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BooleanArgument!predicate"
        | doc "A `boolean` type argument has two possible values: `true` or `false`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  "default" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"Bool")
                            ]
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"Bool")
                            ]
                        ],
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  multiple = _js2n__-prdslib.isType '"Bool",
                  multiple_sep = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "boolean",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BooleanFalseArgument!predicate"
        | doc "An argument of the `boolean_false` type acts like an inverted `boolean` flag with a default value of `true`. When called as an argument it sets the `boolean` to `false`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "boolean_false",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BooleanTrueArgument!predicate"
        | doc "An argument of the `boolean_true` type acts like a `boolean` flag with a default value of `false`. When called as an argument it sets the `boolean` to `true`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "boolean_true",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/BuildInfo!predicate"
        | doc "Meta information fields filled in by Viash during build."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "config" ],
              _js2n__-prdslib.records.record
                {
                  config = _js2n__-prdslib.isType '"String",
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  engine = _js2n__-prdslib.isType '"String",
                  executable = _js2n__-prdslib.isType '"String",
                  git_commit = _js2n__-prdslib.isType '"String",
                  git_remote = _js2n__-prdslib.isType '"String",
                  git_tag = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  runner = _js2n__-prdslib.isType '"String",
                  viash_version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/CSharpScript!predicate"
        | doc m%"
          An executable C# script.
          When defined in resources, only the first entry will be executed when running the built component or when running `viash run`.
          When defined in test_resources, all entries will be executed during `viash test`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "csharp_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ComputationalRequirements!predicate"
        | doc "Computational requirements related to running the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  commands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  cpus = _js2n__-prdslib.isType 'Integer,
                  memory = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Config!predicate"
        | doc m%"
          A Viash configuration is a YAML file which contains metadata to describe the behaviour and build target(s) of a component.  
          We commonly name this file `config.vsh.yaml` in our examples, but you can name it however you choose.  
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  argument_groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArgumentGroup!predicate"
                        ],
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Argument!predicate"
                        ],
                  authors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Author!predicate"
                        ],
                  build_info =
                    _js2n__-refsenv."_js2n__-:definitions/BuildInfo!predicate",
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  engines =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Engine!predicate"
                        ],
                  functionality =
                    _js2n__-refsenv."_js2n__-:definitions/Functionality!predicate",
                  info = _js2n__-prdslib.isType 'Record,
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  license = _js2n__-prdslib.isType '"String",
                  links =
                    _js2n__-refsenv."_js2n__-:definitions/Links!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  package_config =
                    _js2n__-refsenv."_js2n__-:definitions/PackageConfig!predicate",
                  platforms =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Platform!predicate"
                        ],
                  references =
                    _js2n__-refsenv."_js2n__-:definitions/References!predicate",
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RepositoryWithName!predicate"
                        ],
                  requirements =
                    _js2n__-refsenv."_js2n__-:definitions/ComputationalRequirements!predicate",
                  resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Resource!predicate"
                        ],
                  runners =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Runner!predicate"
                        ],
                  scope =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ScopeEnum!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Scope!predicate"
                        ],
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/Status!predicate",
                  summary = _js2n__-prdslib.isType '"String",
                  test_resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Resource!predicate"
                        ],
                  usage = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Dependency!predicate"
        | doc m%"
          Specifies a Viash component (script or executable) that should be made available for the code defined in the component.
          The dependency components are collected and copied to the output folder during the Viash build step.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  alias = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  repository =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/Repository!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Direction!predicate"
        | doc "Makes this argument an `input` or an `output`, as in does the file/folder needs to be read or written. `input` by default."
        = _js2n__-prdslib.enum [ "input", "output" ],
      "_js2n__-:definitions/DockerEngine!predicate"
        | doc m%"
          Run a Viash component on a Docker backend engine.
          By specifying which dependencies your component needs, users will be able to build a docker container from scratch using the setup flag, or pull it from a docker repository.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image", "type" ],
              _js2n__-prdslib.records.record
                {
                  cmd =
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
                  entrypoint =
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
                  id = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  namespace_separator = _js2n__-prdslib.isType '"String",
                  organization = _js2n__-prdslib.isType '"String",
                  registry = _js2n__-prdslib.isType '"String",
                  setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Requirements!predicate"
                        ],
                  tag = _js2n__-prdslib.isType '"String",
                  target_image = _js2n__-prdslib.isType '"String",
                  target_image_source = _js2n__-prdslib.isType '"String",
                  target_organization = _js2n__-prdslib.isType '"String",
                  target_package = _js2n__-prdslib.isType '"String",
                  target_registry = _js2n__-prdslib.isType '"String",
                  target_tag = _js2n__-prdslib.isType '"String",
                  test_setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Requirements!predicate"
                        ],
                  type = _js2n__-prdslib.const "docker",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerPlatform!predicate"
        | doc m%"
          Run a Viash component on a Docker backend platform.
          By specifying which dependencies your component needs, users will be able to build a docker container from scratch using the setup flag, or pull it from a docker repository.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image", "type" ],
              _js2n__-prdslib.records.record
                {
                  cmd =
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
                  entrypoint =
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
                  id = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  namespace_separator = _js2n__-prdslib.isType '"String",
                  organization = _js2n__-prdslib.isType '"String",
                  port =
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
                  registry = _js2n__-prdslib.isType '"String",
                  resolve_volume =
                    _js2n__-refsenv."_js2n__-:definitions/DockerResolveVolume!predicate",
                  run_args =
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
                  setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Requirements!predicate"
                        ],
                  setup_strategy =
                    _js2n__-refsenv."_js2n__-:definitions/DockerSetupStrategy!predicate",
                  tag = _js2n__-prdslib.isType '"String",
                  target_image = _js2n__-prdslib.isType '"String",
                  target_image_source = _js2n__-prdslib.isType '"String",
                  target_organization = _js2n__-prdslib.isType '"String",
                  target_registry = _js2n__-prdslib.isType '"String",
                  target_tag = _js2n__-prdslib.isType '"String",
                  test_setup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Requirements!predicate"
                        ],
                  type = _js2n__-prdslib.const "docker",
                  workdir = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerRequirements!predicate"
        | doc "Specify which Docker commands should be run during setup."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  add =
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
                  build_args =
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
                  copy =
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
                  env =
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
                  label =
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
                  type = _js2n__-prdslib.const "docker",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DockerResolveVolume!predicate"
        | doc "Enables or disables automatic volume mapping. Enabled when set to `Automatic` or disabled when set to `Manual`. Default: `Automatic`"
        = _js2n__-prdslib.enum
            [ "manual", "automatic", "auto", "Manual", "Automatic", "Auto" ],
      "_js2n__-:definitions/DockerSetupStrategy!predicate"
        | doc "The Docker setup strategy to use when building a container."
        = _js2n__-prdslib.enum
            [
              "cb",
              "ifneedbepullelsecachedbuild",
              "donothing",
              "gentlepush",
              "alwayspullelsebuild",
              "build",
              "alwayspull",
              "alwaysbuild",
              "ifneedbebuild",
              "pullelsebuild",
              "p",
              "alwayspullelsecachedbuild",
              "pull",
              "maybepush",
              "ifneedbepullelsebuild",
              "cachedbuild",
              "pullelsecachedbuild",
              "push",
              "forcepush",
              "alwayspush",
              "b",
              "pushifnotpresent",
              "alwayscachedbuild",
              "meh",
              "ifneedbepull",
              "ifneedbecachedbuild"
            ],
      "_js2n__-:definitions/DoubleArgument!predicate"
        | doc "A `double` type argument has a numeric value with decimal points"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  "default" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DoubleWithInf!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DoubleWithInf!predicate"
                            ]
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/DoubleWithInf!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/DoubleWithInf!predicate"
                            ]
                        ],
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  max =
                    _js2n__-refsenv."_js2n__-:definitions/DoubleWithInf!predicate",
                  min =
                    _js2n__-refsenv."_js2n__-:definitions/DoubleWithInf!predicate",
                  multiple = _js2n__-prdslib.isType '"Bool",
                  multiple_sep = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "double",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/DoubleStrings!predicate" =
        _js2n__-prdslib.enum
            [
              "+.inf",
              "+inf",
              "+infinity",
              "positiveinfinity",
              "positiveinf",
              "-.inf",
              "-inf",
              "-infinity",
              "negativeinfinity",
              "negativeinf",
              ".nan",
              "nan"
            ],
      "_js2n__-:definitions/DoubleWithInf!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-refsenv."_js2n__-:definitions/DoubleStrings!predicate"
            ],
      "_js2n__-:definitions/Engine!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DockerEngine!predicate",
              _js2n__-refsenv."_js2n__-:definitions/NativeEngine!predicate"
            ],
      "_js2n__-:definitions/Executable!predicate"
        | doc "An executable file."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "executable",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ExecutableRunner!predicate"
        | doc m%"
          Run code as an executable.
          
          This runner is the default runner. It will generate a bash script that can be run directly.
          
          This runner is also used for the native engine.
          
          This runner is also used for the docker engine.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  docker_run_args =
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
                  docker_setup_strategy =
                    _js2n__-refsenv."_js2n__-:definitions/DockerSetupStrategy!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  port =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer)
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  type = _js2n__-prdslib.const "executable",
                  workdir = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FileArgument!predicate"
        | doc "A `file` type argument has a string value that points to a file or folder path."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  create_parent = _js2n__-prdslib.isType '"Bool",
                  "default" =
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
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  example =
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
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  multiple = _js2n__-prdslib.isType '"Bool",
                  multiple_sep = _js2n__-prdslib.isType '"String",
                  must_exist = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "file",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Functionality!predicate"
        | doc m%"
          The functionality-part of the config file describes the behaviour of the script in terms of arguments and resources.
          By specifying a few restrictions (e.g. mandatory arguments) and adding some descriptions, Viash will automatically generate a stylish command-line interface for you.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  argument_groups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ArgumentGroup!predicate"
                        ],
                  arguments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Argument!predicate"
                        ],
                  authors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Author!predicate"
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Dependency!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  info = _js2n__-prdslib.isType 'Record,
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  license = _js2n__-prdslib.isType '"String",
                  links =
                    _js2n__-refsenv."_js2n__-:definitions/Links!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  organization = _js2n__-prdslib.isType '"String",
                  references =
                    _js2n__-refsenv."_js2n__-:definitions/References!predicate",
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RepositoryWithName!predicate"
                        ],
                  requirements =
                    _js2n__-refsenv."_js2n__-:definitions/ComputationalRequirements!predicate",
                  resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Resource!predicate"
                        ],
                  status =
                    _js2n__-refsenv."_js2n__-:definitions/Status!predicate",
                  test_resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Resource!predicate"
                        ],
                  usage = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitRepository!predicate"
        | doc "A Git repository where remote dependency components can be found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type", "uri" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "git",
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GitRepositoryWithName!predicate"
        | doc "A Git repository where remote dependency components can be found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type", "uri" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "git",
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GithubRepository!predicate"
        | doc "A GitHub repository where remote dependency components can be found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo", "type" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "github",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/GithubRepositoryWithName!predicate"
        | doc "A GitHub repository where remote dependency components can be found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "repo", "type" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "github",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/IntegerArgument!predicate"
        | doc "An `integer` type argument has a numeric value without decimal points."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  choices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                  "default" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer)
                            ]
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer)
                            ]
                        ],
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  max = _js2n__-prdslib.isType 'Integer,
                  min = _js2n__-prdslib.isType 'Integer,
                  multiple = _js2n__-prdslib.isType '"Bool",
                  multiple_sep = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "integer",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavaScriptRequirements!predicate"
        | doc "Specify which JavaScript packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  git =
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
                  github =
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
                  npm =
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
                  packages =
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
                  type = _js2n__-prdslib.const "javascript",
                  url =
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
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/JavaScriptScript!predicate"
        | doc m%"
          An executable JavaScript script.
          When defined in resources, only the first entry will be executed when running the built component or when running `viash run`.
          When defined in test_resources, all entries will be executed during `viash test`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "javascript_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Links!predicate"
        | doc "Links to external resources related to the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  docker_registry = _js2n__-prdslib.isType '"String",
                  documentation = _js2n__-prdslib.isType '"String",
                  homepage = _js2n__-prdslib.isType '"String",
                  issue_tracker = _js2n__-prdslib.isType '"String",
                  repository = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocalRepository!predicate"
        | doc m%"
          Defines a locally present and available repository.
          This can be used to define components from the same code base as the current component.
          Alternatively, this can be used to refer to a code repository present on the local hard-drive instead of fetchable remotely, for example during development.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "local",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LocalRepositoryWithName!predicate"
        | doc m%"
          Defines a locally present and available repository.
          This can be used to define components from the same code base as the current component.
          Alternatively, this can be used to refer to a code repository present on the local hard-drive instead of fetchable remotely, for example during development.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "local",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/LongArgument!predicate"
        | doc "An `long` type argument has a numeric value without decimal points."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  choices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                  "default" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer)
                            ]
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType 'Integer)
                            ]
                        ],
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  max = _js2n__-prdslib.isType 'Integer,
                  min = _js2n__-prdslib.isType 'Integer,
                  multiple = _js2n__-prdslib.isType '"Bool",
                  multiple_sep = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "long",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NativeEngine!predicate"
        | doc m%"
          Running a Viash component on a native engine means that the script will be executed in your current environment.
          Any dependencies are assumed to have been installed by the user, so the native engine is meant for developers (who know what they're doing) or for simple bash scripts (which have no extra dependencies).
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "native",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NativePlatform!predicate"
        | doc m%"
          Running a Viash component on a native platform means that the script will be executed in your current environment.
          Any dependencies are assumed to have been installed by the user, so the native platform is meant for developers (who know what they're doing) or for simple bash scripts (which have no extra dependencies).
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "native",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NextflowAuto!predicate"
        | doc "Automated processing flags which can be toggled on or off."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  publish =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  simplifyInput = _js2n__-prdslib.isType '"Bool",
                  simplifyOutput = _js2n__-prdslib.isType '"Bool",
                  transcript = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NextflowConfig!predicate"
        | doc "Allows tweaking how the Nextflow Config file is generated."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  script =
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
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NextflowDirectives!predicate"
        | doc m%"
          Directives are optional settings that affect the execution of the process.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  accelerator =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  afterScript = _js2n__-prdslib.isType '"String",
                  beforeScript = _js2n__-prdslib.isType '"String",
                  cache =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  conda =
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
                  container =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  containerOptions =
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
                  cpus =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  disk = _js2n__-prdslib.isType '"String",
                  echo =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  errorStrategy = _js2n__-prdslib.isType '"String",
                  executor = _js2n__-prdslib.isType '"String",
                  label =
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
                  machineType = _js2n__-prdslib.isType '"String",
                  maxErrors =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  maxForks =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  maxRetries =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  memory = _js2n__-prdslib.isType '"String",
                  module =
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
                  penv = _js2n__-prdslib.isType '"String",
                  pod =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.isType '"String")
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.isType '"String")
                                  ])
                            ]
                        ],
                  publishDir =
                    _js2n__-prdslib.oneOf
                        [
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
                                        _js2n__-prdslib.records.record {} {}
                                          true
                                          (_js2n__-prdslib.isType '"String")
                                      ]
                                  ])
                            ]
                        ],
                  queue =
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
                  scratch =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stageInMode = _js2n__-prdslib.isType '"String",
                  stageOutMode = _js2n__-prdslib.isType '"String",
                  storeDir = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  time = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NextflowPlatform!predicate"
        | doc "Platform for generating Nextflow VDSL3 modules."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  auto =
                    _js2n__-refsenv."_js2n__-:definitions/NextflowAuto!predicate",
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/NextflowConfig!predicate",
                  container = _js2n__-prdslib.isType '"String",
                  debug = _js2n__-prdslib.isType '"Bool",
                  directives =
                    _js2n__-refsenv."_js2n__-:definitions/NextflowDirectives!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "nextflow",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NextflowRunner!predicate"
        | doc m%"
          Run a Viash component on a Nextflow backend engine.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  auto =
                    _js2n__-refsenv."_js2n__-:definitions/NextflowAuto!predicate",
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/NextflowConfig!predicate",
                  container = _js2n__-prdslib.isType '"String",
                  debug = _js2n__-prdslib.isType '"Bool",
                  directives =
                    _js2n__-refsenv."_js2n__-:definitions/NextflowDirectives!predicate",
                  id = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "nextflow",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NextflowScript!predicate"
        | doc "A Nextflow script. Work in progress; added mainly for annotation at the moment."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "entrypoint", "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  entrypoint = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "nextflow_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PackageConfig!predicate"
        | doc "A Viash package configuration file. It's name should be `_viash.yaml`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Author!predicate"
                        ],
                  config_mods =
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
                  description = _js2n__-prdslib.isType '"String",
                  info = _js2n__-prdslib.isType 'Record,
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  label = _js2n__-prdslib.isType '"String",
                  license = _js2n__-prdslib.isType '"String",
                  links =
                    _js2n__-refsenv."_js2n__-:definitions/Links!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  organization = _js2n__-prdslib.isType '"String",
                  references =
                    _js2n__-refsenv."_js2n__-:definitions/References!predicate",
                  repositories =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RepositoryWithName!predicate"
                        ],
                  source = _js2n__-prdslib.isType '"String",
                  summary = _js2n__-prdslib.isType '"String",
                  target = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                  viash_version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PlainFile!predicate"
        | doc "A plain file. This can only be used as a supporting resource for the main script or unit tests."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "file",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Platform!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DockerPlatform!predicate",
              _js2n__-refsenv."_js2n__-:definitions/NativePlatform!predicate",
              _js2n__-refsenv."_js2n__-:definitions/NextflowPlatform!predicate"
            ],
      "_js2n__-:definitions/PythonRequirements!predicate"
        | doc "Specify which Python packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  bazaar =
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
                  git =
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
                  github =
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
                  gitlab =
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
                  mercurial =
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
                  packages =
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
                  pip =
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
                  pypi =
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
                  script =
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
                  svn =
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
                  type = _js2n__-prdslib.const "python",
                  upgrade = _js2n__-prdslib.isType '"Bool",
                  url =
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
                  user = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/PythonScript!predicate"
        | doc m%"
          An executable Python script.
          When defined in resources, only the first entry will be executed when running the built component or when running `viash run`.
          When defined in test_resources, all entries will be executed during `viash test`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "python_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RRequirements!predicate"
        | doc "Specify which R packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  bioc =
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
                  bioc_force_install = _js2n__-prdslib.isType '"Bool",
                  bitbucket =
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
                  cran =
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
                  git =
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
                  github =
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
                  gitlab =
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
                  packages =
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
                  script =
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
                  svn =
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
                  type = _js2n__-prdslib.const "r",
                  url =
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
                  warnings_as_errors = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RScript!predicate"
        | doc m%"
          An executable R script.
          When defined in resources, only the first entry will be executed when running the built component or when running `viash run`.
          When defined in test_resources, all entries will be executed during `viash test`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "r_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/References!predicate"
        | doc "A list of scholarly sources or publications relevant to the tools or analysis defined in the component. This is important for attribution, scientific reproducibility and transparency."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bibtex =
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
                  doi =
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
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Repository!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/GitRepository!predicate",
              _js2n__-refsenv."_js2n__-:definitions/GithubRepository!predicate",
              _js2n__-refsenv."_js2n__-:definitions/LocalRepository!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ViashhubRepository!predicate"
            ],
      "_js2n__-:definitions/RepositoryWithName!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/GitRepositoryWithName!predicate",
              _js2n__-refsenv."_js2n__-:definitions/GithubRepositoryWithName!predicate",
              _js2n__-refsenv."_js2n__-:definitions/LocalRepositoryWithName!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ViashhubRepositoryWithName!predicate"
            ],
      "_js2n__-:definitions/Requirements!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ApkRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/AptRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DockerRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/JavaScriptRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/PythonRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RubyRequirements!predicate",
              _js2n__-refsenv."_js2n__-:definitions/YumRequirements!predicate"
            ],
      "_js2n__-:definitions/Resource!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/BashScript!predicate",
              _js2n__-refsenv."_js2n__-:definitions/CSharpScript!predicate",
              _js2n__-refsenv."_js2n__-:definitions/Executable!predicate",
              _js2n__-refsenv."_js2n__-:definitions/JavaScriptScript!predicate",
              _js2n__-refsenv."_js2n__-:definitions/NextflowScript!predicate",
              _js2n__-refsenv."_js2n__-:definitions/PlainFile!predicate",
              _js2n__-refsenv."_js2n__-:definitions/PythonScript!predicate",
              _js2n__-refsenv."_js2n__-:definitions/RScript!predicate",
              _js2n__-refsenv."_js2n__-:definitions/ScalaScript!predicate"
            ],
      "_js2n__-:definitions/RubyRequirements!predicate"
        | doc "Specify which Ruby packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  packages =
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
                  type = _js2n__-prdslib.const "ruby",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Runner!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/ExecutableRunner!predicate",
              _js2n__-refsenv."_js2n__-:definitions/NextflowRunner!predicate"
            ],
      "_js2n__-:definitions/ScalaScript!predicate"
        | doc m%"
          An executable Scala script.
          When defined in resources, only the first entry will be executed when running the built component or when running `viash run`.
          When defined in test_resources, all entries will be executed during `viash test`.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  dest = _js2n__-prdslib.isType '"String",
                  is_executable = _js2n__-prdslib.isType '"Bool",
                  path = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "scala_script",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Scope!predicate"
        | doc m%"
          Defines the scope of the component.
          `test`: only available during testing; components aren't published.
          `private`: only meant for internal use within a workflow or other component.
          `public`: core component or workflow meant for general use.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "image", "target" ],
              _js2n__-prdslib.records.record
                {
                  image =
                    _js2n__-refsenv."_js2n__-:definitions/ScopeEnum!predicate",
                  target =
                    _js2n__-refsenv."_js2n__-:definitions/ScopeEnum!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ScopeEnum!predicate"
        | doc "The scope of the component. `public` by default."
        = _js2n__-prdslib.enum [ "test", "private", "public" ],
      "_js2n__-:definitions/Status!predicate"
        | doc "Allows setting a component to active, deprecated or disabled."
        = _js2n__-prdslib.enum [ "enabled", "disabled", "deprecated" ],
      "_js2n__-:definitions/StringArgument!predicate"
        | doc "A `string` type argument has a value made up of an ordered sequences of characters, like \"Hello\" or \"I'm a string\"."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "type" ],
              _js2n__-prdslib.records.record
                {
                  alternatives =
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
                  choices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  "default" =
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
                  description = _js2n__-prdslib.isType '"String",
                  direction =
                    _js2n__-refsenv."_js2n__-:definitions/Direction!predicate",
                  example =
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
                  info = _js2n__-prdslib.isType 'Record,
                  label = _js2n__-prdslib.isType '"String",
                  multiple = _js2n__-prdslib.isType '"Bool",
                  multiple_sep = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                  summary = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "string",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ViashhubRepository!predicate"
        | doc "A Viash-Hub repository where remote dependency components can be found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "repo", "type" ],
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "viashhub",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ViashhubRepositoryWithName!predicate"
        | doc "A Viash-Hub repository where remote dependency components can be found."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "repo", "type" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  repo = _js2n__-prdslib.isType '"String",
                  tag = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.const "viashhub",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/YumRequirements!predicate"
        | doc "Specify which yum packages should be available in order to run the component."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  packages =
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
                  type = _js2n__-prdslib.const "yum",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.oneOf
        [ _js2n__-refsenv."_js2n__-:definitions/Config!predicate" ])