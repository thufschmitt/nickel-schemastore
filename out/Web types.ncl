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
      "_js2n__-:definitions/abstract!predicate"
        | doc "Mark contribution as abstract. Such contributions serve only as super contributions for other contributions."
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/base-contribution!predicate"
        | doc "The base for any contributions."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  abstract =
                    _js2n__-refsenv."_js2n__-:definitions/abstract!predicate",
                  css = _js2n__-refsenv."_js2n__-:definitions/css!predicate",
                  deprecated =
                    _js2n__-refsenv."_js2n__-:definitions/deprecated!predicate",
                  deprecated-since =
                    _js2n__-refsenv."_js2n__-:definitions/deprecated-since!predicate",
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                  description-sections =
                    _js2n__-refsenv."_js2n__-:definitions/description-sections!predicate",
                  doc-url =
                    _js2n__-refsenv."_js2n__-:definitions/doc-url!predicate",
                  exclusive-contributions =
                    _js2n__-refsenv."_js2n__-:definitions/exclusive-contributions!predicate",
                  experimental =
                    _js2n__-refsenv."_js2n__-:definitions/experimental!predicate",
                  extends =
                    _js2n__-refsenv."_js2n__-:definitions/extends!predicate",
                  extension =
                    _js2n__-refsenv."_js2n__-:definitions/extension!predicate",
                  html = _js2n__-refsenv."_js2n__-:definitions/html!predicate",
                  icon = _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
                  js = _js2n__-refsenv."_js2n__-:definitions/js!predicate",
                  name = _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  obsolete =
                    _js2n__-refsenv."_js2n__-:definitions/obsolete!predicate",
                  obsolete-since =
                    _js2n__-refsenv."_js2n__-:definitions/obsolete-since!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/name-pattern-root!predicate",
                  "priority" =
                    _js2n__-refsenv."_js2n__-:definitions/priority!predicate",
                  proximity =
                    _js2n__-refsenv."_js2n__-:definitions/proximity!predicate",
                  required-context =
                    _js2n__-refsenv."_js2n__-:definitions/required-context!predicate",
                  since =
                    _js2n__-refsenv."_js2n__-:definitions/since!predicate",
                  source =
                    _js2n__-refsenv."_js2n__-:definitions/source!predicate",
                  virtual =
                    _js2n__-refsenv."_js2n__-:definitions/virtual!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/context-config!predicate"
        | doc "Since 2024.2. Provide rules for setting a particular name for particular context kind. This allows to contribute additional Web Types for example if a particular library is present in the project."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disable-when =
                    _js2n__-refsenv."_js2n__-:definitions/disablement-rules!predicate",
                  enable-when =
                    _js2n__-refsenv."_js2n__-:definitions/enablement-rules!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/context-kind-config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disable-when =
                    _js2n__-refsenv."_js2n__-:definitions/disablement-rules!predicate",
                  enable-when =
                    _js2n__-refsenv."_js2n__-:definitions/enablement-rules!predicate",
                  kind = _js2n__-prdslib.isType '"String",
                } {} true
                _js2n__-refsenv."_js2n__-:definitions/context-config!predicate"
            ],
      "_js2n__-:definitions/contexts-config!predicate"
        | doc "Provide configuration for Web Types contexts. This allows to contribute additional Web Types for example if a particular library is present in the project."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/context-kind-config!predicate"
            ],
      "_js2n__-:definitions/css!predicate"
        | doc "Contains contributions to CSS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are predefined kinds, which integrate directly with IDE - properties, classes, functions, pseudo-elements, pseudo-classes and parts."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/css-contributions-host!predicate"
            ],
      "_js2n__-:definitions/css-contributions-host!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  classes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/css-generic-item!predicate"
                        ],
                  functions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/css-generic-item!predicate"
                        ],
                  parts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/css-generic-item!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/css-property!predicate"
                        ],
                  pseudo-classes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/css-pseudo-class!predicate"
                        ],
                  pseudo-elements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/css-pseudo-element!predicate"
                        ],
                }
                {
                  "^(?!pattern$).*$" =
                    _js2n__-refsenv."_js2n__-:definitions/generic-css-contributions!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/css-generic-item!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/css-contributions-host!predicate"
                ]
            ],
      "_js2n__-:definitions/css-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/css-contributions-host!predicate"
                ],
              _js2n__-prdslib.records.record
                {
                  values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/css-pseudo-class!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/css-contributions-host!predicate"
                ],
              _js2n__-prdslib.records.record
                { arguments = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/css-pseudo-element!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/css-contributions-host!predicate"
                ],
              _js2n__-prdslib.records.record
                { arguments = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/custom-enablement-rules!predicate"
        | doc "Since 2024.2. Custom package manager dependencies, which would enable context according to the rules of custom provider."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/default!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/deprecated!predicate"
        | doc "Specifies whether the symbol is deprecated. Deprecated symbol usage is discouraged, but still supported. Value can be a boolean or a string message with explanation and migration information."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/deprecated-description-markup!predicate"
        | doc "Deprecated, use top-level property."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/description-markup!predicate"
            ],
      "_js2n__-:definitions/deprecated-html-attribute-vue-argument!predicate"
        | doc "Deprecated vue-specific property - contribute Vue directives to /contributions/html/vue-directives"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                  doc-url =
                    _js2n__-refsenv."_js2n__-:definitions/doc-url!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/name-pattern-root!predicate",
                  required = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/deprecated-html-attribute-vue-modifier!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  description =
                    _js2n__-refsenv."_js2n__-:definitions/description!predicate",
                  doc-url =
                    _js2n__-refsenv."_js2n__-:definitions/doc-url!predicate",
                  name = _js2n__-refsenv."_js2n__-:definitions/name!predicate",
                  pattern =
                    _js2n__-refsenv."_js2n__-:definitions/name-pattern-root!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/deprecated-since!predicate"
        | doc "Version in which this symbol was first deprecated."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/deprecated-types-syntax!predicate"
        | doc "Deprecated, use top-level js-types-syntax property."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/js-types-syntax!predicate"
            ],
      "_js2n__-:definitions/description!predicate"
        | doc "Short description to be rendered in documentation popup. It will be rendered according to description-markup setting."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/description-markup!predicate"
        | doc "Markup language in which descriptions are formatted."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "html", "markdown", "none" ]
            ],
      "_js2n__-:definitions/description-sections!predicate"
        | doc "Custom sections to be shown below description in the documentation popup."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/disablement-rules!predicate"
        | doc "Specify rules for disabling web framework support. These rules take precedence over enable-when rules. They allow to turn off framework support in case of some conflicts between frameworks priority."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file-extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  file-name-patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/pattern!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/doc-url!predicate"
        | doc "Link to online documentation."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/enablement-rules!predicate"
        | doc "Specify rules for enabling web framework support. Only one framework can be enabled in a particular file. If you need your contributions to be enabled in all files, regardless of the context, do not specify the framework."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  file-extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  file-name-patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/pattern!predicate"
                        ],
                  ide-libraries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  node-packages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  project-tool-executables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  ruby-gems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} true
                _js2n__-refsenv."_js2n__-:definitions/custom-enablement-rules!predicate"
            ],
      "_js2n__-:definitions/exclusive-contributions!predicate"
        | doc m%"
          Specify list of contribution kinds qualified with a namespace, for which during reference resolution this will be the final contribution host. E.g. if a special HTML element does not accept standard attributes, add:
          "exclusive-contributions": ["/html/attributes"].
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "/[^/\\n\\r]+/[^/\\n\\r]+"
                  ])
            ],
      "_js2n__-:definitions/experimental!predicate"
        | doc "Specifies whether the symbol is experimental. Value can be a boolean or a string message with explanation. Experimental symbols should be used with caution as the API might change."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/extends!predicate" =
        _js2n__-refsenv."_js2n__-:definitions/reference!predicate",
      "_js2n__-:definitions/extension!predicate"
        | doc "Mark contribution as an extension. Such contributions do not define a new contribution on their own, but can provide additional properties or contributions to existing contributions."
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/framework-config!predicate"
        | doc "Provide configuration for the specified web framework. This is an advanced feature, which is used to provide support for templating frameworks like Angular, Vue, Svelte, etc."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  canonical-names =
                    _js2n__-refsenv."_js2n__-:definitions/name-conversion-rules-single!predicate",
                  disable-when =
                    _js2n__-refsenv."_js2n__-:definitions/disablement-rules!predicate",
                  enable-when =
                    _js2n__-refsenv."_js2n__-:definitions/enablement-rules!predicate",
                  match-names =
                    _js2n__-refsenv."_js2n__-:definitions/name-conversion-rules-multiple!predicate",
                  name-variants =
                    _js2n__-refsenv."_js2n__-:definitions/name-conversion-rules-multiple!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/generic-contribution!predicate"
        | doc "A generic contribution. All contributions are of this type, except for HTML attributes and elements, as well as predefined CSS contribution kinds."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/typed-contribution!predicate",
              _js2n__-prdslib.records.record
                {
                  attribute-value =
                    _js2n__-refsenv."_js2n__-:definitions/html-attribute-value!predicate",
                  "default" =
                    _js2n__-refsenv."_js2n__-:definitions/default!predicate",
                  required =
                    _js2n__-refsenv."_js2n__-:definitions/required!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/generic-css-contribution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/generic-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/css-contributions-host!predicate"
                ]
            ],
      "_js2n__-:definitions/generic-css-contribution-or-property!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/generic-css-contribution!predicate"
            ],
      "_js2n__-:definitions/generic-css-contributions!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/generic-css-contribution-or-property!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/generic-css-contribution-or-property!predicate"
                ]
            ],
      "_js2n__-:definitions/generic-html-contribution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/generic-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/html-contributions-host!predicate"
                ]
            ],
      "_js2n__-:definitions/generic-html-contribution-or-property!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/generic-html-contribution!predicate",
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool"
            ],
      "_js2n__-:definitions/generic-html-contributions!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/generic-html-contribution-or-property!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/generic-html-contribution-or-property!predicate"
                ]
            ],
      "_js2n__-:definitions/generic-js-contribution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/generic-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/js-contributions-host!predicate"
                ]
            ],
      "_js2n__-:definitions/generic-js-contribution-or-property!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-refsenv."_js2n__-:definitions/generic-js-contribution!predicate"
            ],
      "_js2n__-:definitions/generic-js-contributions!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/generic-js-contribution-or-property!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/generic-js-contribution-or-property!predicate"
                ]
            ],
      "_js2n__-:definitions/html!predicate"
        | doc "Contains contributions to HTML namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - HTML elements and HTML attributes. There are also 2 deprecated kinds: tags (which is equivalent to 'elements') and 'events' (which was moved to JS namespace)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/html-contributions-host!predicate",
              _js2n__-prdslib.records.record
                {
                  description-markup =
                    _js2n__-refsenv."_js2n__-:definitions/deprecated-description-markup!predicate",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/html-element!predicate"
                        ],
                  types-syntax =
                    _js2n__-refsenv."_js2n__-:definitions/deprecated-types-syntax!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/html-attribute!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/html-contributions-host!predicate"
                ],
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.isType '"String",
                  required =
                    _js2n__-refsenv."_js2n__-:definitions/required!predicate",
                  value =
                    _js2n__-refsenv."_js2n__-:definitions/html-attribute-value!predicate",
                  vue-argument =
                    _js2n__-refsenv."_js2n__-:definitions/deprecated-html-attribute-vue-argument!predicate",
                  vue-modifiers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/deprecated-html-attribute-vue-modifier!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/html-attribute-value!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "default" = _js2n__-prdslib.isType '"String",
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "no-value", "plain", "expression" ]
                        ],
                  required = _js2n__-prdslib.isType '"Bool",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/html-value-type!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/html-contributions-host!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  attributes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/html-attribute!predicate"
                        ],
                  elements =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/html-element!predicate"
                        ],
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/generic-html-contribution!predicate"
                        ],
                }
                {
                  "^(?!pattern$).*$" =
                    _js2n__-refsenv."_js2n__-:definitions/generic-html-contributions!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/html-element!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/html-contributions-host!predicate"
                ]
            ],
      "_js2n__-:definitions/html-value-type!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/type-reference!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/type!predicate"
                ]
            ],
      "_js2n__-:definitions/icon!predicate"
        | doc "Relative path to the icon representing the symbol or actual SVG of the icon."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/js!predicate"
        | doc "Contains contributions to JS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - properties and events."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/js-contributions-host!predicate"
            ],
      "_js2n__-:definitions/js-contributions-host!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/generic-js-contribution!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/js-property!predicate"
                        ],
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/js-symbol!predicate"
                        ],
                }
                {
                  "^(?!pattern$).*$" =
                    _js2n__-refsenv."_js2n__-:definitions/generic-js-contributions!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/js-global!predicate"
        | doc "Contains contributions to JS namespace. It's property names represent symbol kinds, its property values contain list of contributions of particular kind. There are 2 predefined kinds, which integrate directly with IDE - properties and events, but only events can be contributed globally."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  events =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/generic-js-contribution!predicate"
                        ],
                  symbols =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/js-symbol!predicate"
                        ],
                }
                {
                  "^(?!pattern$).*$" =
                    _js2n__-refsenv."_js2n__-:definitions/generic-js-contributions!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/js-property!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/generic-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/js-contributions-host!predicate"
                ],
              _js2n__-prdslib.records.record
                { read-only = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/js-symbol!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/typed-contribution!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/js-contributions-host!predicate"
                ],
              _js2n__-prdslib.records.record
                {
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Variable",
                              "Function",
                              "Namespace",
                              "Class",
                              "Interface",
                              "Enum",
                              "Alias",
                              "Module"
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/js-types-syntax!predicate"
        | doc "Language in which JavaScript objects types are specified."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "typescript" ]
            ],
      "_js2n__-:definitions/list-reference!predicate"
        | doc "A reference to an element in Web-Types model."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/reference!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/reference!predicate"
                ]
            ],
      "_js2n__-:definitions/name!predicate" = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/name-conversion-rules-multiple!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^/[^/\\n\\r]+/[^/\\n\\r]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/name-converters!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/name-conversion-rules-single!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^/[^/\\n\\r]+/[^/\\n\\r]+$" =
                    _js2n__-refsenv."_js2n__-:definitions/name-converter!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/name-converter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "as-is",
                  "PascalCase",
                  "camelCase",
                  "lowercase",
                  "UPPERCASE",
                  "kebab-case",
                  "snake_case"
                ]
            ],
      "_js2n__-:definitions/name-converters!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/name-converter!predicate"
            ],
      "_js2n__-:definitions/name-pattern!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          delegate =
                            _js2n__-refsenv."_js2n__-:definitions/reference!predicate",
                          deprecated =
                            _js2n__-refsenv."_js2n__-:definitions/deprecated!predicate",
                          items =
                            _js2n__-refsenv."_js2n__-:definitions/list-reference!predicate",
                          or =
                            _js2n__-refsenv."_js2n__-:definitions/name-pattern-template!predicate",
                          "priority" =
                            _js2n__-refsenv."_js2n__-:definitions/priority!predicate",
                          proximity =
                            _js2n__-refsenv."_js2n__-:definitions/proximity!predicate",
                          repeat = _js2n__-prdslib.isType '"Bool",
                          required =
                            _js2n__-refsenv."_js2n__-:definitions/required!predicate",
                          template =
                            _js2n__-refsenv."_js2n__-:definitions/name-pattern-template!predicate",
                          unique = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "regex" ],
                      _js2n__-prdslib.records.record
                        {
                          case-sensitive = _js2n__-prdslib.isType '"Bool",
                          regex = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ]
            ],
      "_js2n__-:definitions/name-pattern-root!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/name-pattern!predicate",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/name-pattern-template!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-refsenv."_js2n__-:definitions/name-pattern-template!predicate",
                    _js2n__-refsenv."_js2n__-:definitions/name-pattern!predicate"
                  ]),
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/obsolete!predicate"
        | doc "Specifies whether the symbol is obsolete. Obsolete symbols are no longer supported. Value can be a boolean or a string message with explanation and migration information."
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/obsolete-since!predicate"
        | doc "Version in which this symbol was first made obsolete."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/pattern!predicate"
        | doc "A RegEx pattern to match whole content. Syntax should work with at least ECMA, Java and Python implementations."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      case-sensitive = _js2n__-prdslib.isType '"Bool",
                      regex = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/priority!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "lowest", "low", "normal", "high", "highest" ]
            ],
      "_js2n__-:definitions/proximity!predicate" =
        _js2n__-prdslib.isType 'Integer,
      "_js2n__-:definitions/reference!predicate"
        | doc "A reference to an element in Web-Types model."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/reference-with-props!predicate",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/reference-name-conversion!predicate"
        | doc "Override global name conversion rules for matching symbols under the path."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  canonical-names =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/name-converter!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/name-conversion-rules-single!predicate"
                        ],
                  match-names =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/name-converters!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/name-conversion-rules-multiple!predicate"
                        ],
                  name-variants =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/name-converters!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/name-conversion-rules-multiple!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/reference-with-props!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "path" ],
              _js2n__-prdslib.records.record
                {
                  filter = _js2n__-prdslib.isType '"String",
                  includeAbstract = _js2n__-prdslib.isType '"Bool",
                  includeVirtual = _js2n__-prdslib.isType '"Bool",
                  name-conversion =
                    _js2n__-refsenv."_js2n__-:definitions/reference-name-conversion!predicate",
                  path = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/required!predicate" =
        _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/required-context!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "kind", "name" ],
                  _js2n__-prdslib.records.record
                    {
                      kind = _js2n__-prdslib.isType '"String",
                      name = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "anyOf" ],
                  _js2n__-prdslib.records.record
                    {
                      anyOf =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/required-context!predicate"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "allOf" ],
                  _js2n__-prdslib.records.record
                    {
                      allOf =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/required-context!predicate"
                            ],
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "not" ],
                  _js2n__-prdslib.records.record
                    {
                      not =
                        _js2n__-refsenv."_js2n__-:definitions/required-context!predicate",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/since!predicate"
        | doc "Version since this symbol is available."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/source!predicate"
        | doc "Allows to specify the source of the entity. For Vue.js component this may be for instance a class."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "file", "offset" ],
                      _js2n__-prdslib.records.record
                        {
                          file = _js2n__-prdslib.isType '"String",
                          offset = _js2n__-prdslib.isType 'Integer,
                        } {} false _js2n__-prdslib.never
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "symbol" ],
                      _js2n__-prdslib.records.record
                        {
                          module = _js2n__-prdslib.isType '"String",
                          symbol = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ]
            ],
      "_js2n__-:definitions/type!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/type-reference!predicate",
              _js2n__-prdslib.isType '"String"
            ],
      "_js2n__-:definitions/type-list!predicate"
        | doc "Specify type according to selected language for type syntax. The type can be specified by a string expression, an object with list of imports and an expression, or an array of possible types."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/type!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    _js2n__-refsenv."_js2n__-:definitions/type!predicate"
                ]
            ],
      "_js2n__-:definitions/type-reference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  module = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/typed-contribution!predicate"
        | doc "The base for any contribution, which can possibly have a JS type."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-refsenv."_js2n__-:definitions/base-contribution!predicate",
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/type-list!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/virtual!predicate"
        | doc "Mark contribution as virtual. Virtual contributions can be filtered out if needed in references. A virtual contribution meaning may differ by framework or kind contexts, but usually means something synthetic or something, which gets erased in the runtime by the framework. E.g. Vue or Angular attribute bindings are virtual. "
        = _js2n__-prdslib.isType '"Bool",
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "name", "version" ],
          _js2n__-prdslib.records.record
            {
              "$schema" = _js2n__-prdslib.isType '"String",
              context =
                _js2n__-refsenv."_js2n__-:definitions/required-context!predicate",
              contexts-config =
                _js2n__-refsenv."_js2n__-:definitions/contexts-config!predicate",
              contributions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          css =
                            _js2n__-refsenv."_js2n__-:definitions/css!predicate",
                          html =
                            _js2n__-refsenv."_js2n__-:definitions/html!predicate",
                          js =
                            _js2n__-refsenv."_js2n__-:definitions/js-global!predicate",
                        } {} false _js2n__-prdslib.never
                    ],
              default-icon =
                _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
              description-markup =
                _js2n__-refsenv."_js2n__-:definitions/description-markup!predicate",
              framework = _js2n__-prdslib.isType '"String",
              framework-config =
                _js2n__-refsenv."_js2n__-:definitions/framework-config!predicate",
              js-types-syntax =
                _js2n__-refsenv."_js2n__-:definitions/js-types-syntax!predicate",
              name = _js2n__-prdslib.isType '"String",
              required-context =
                _js2n__-refsenv."_js2n__-:definitions/required-context!predicate",
              version = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never
        ])