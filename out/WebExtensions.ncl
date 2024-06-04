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
      "_js2n__-:definitions/color!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 255,
                          _js2n__-prdslib.numbers.minimum 0
                        ]),
                    _js2n__-prdslib.arrays.maxItems 3,
                    _js2n__-prdslib.arrays.minItems 3
                  ]
              ]),
      "_js2n__-:definitions/command!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  suggested_key =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              android =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                              chromeos =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                              "default" =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                              ios =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                              linux =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                              mac =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                              windows =
                                _js2n__-refsenv."_js2n__-:definitions/command_shortcut!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/command_shortcut!predicate"
        | doc m%"
          There are two valid formats for shortcut keys: as a key combination or as a media key.
          
          Key combinations must consist of 2 or 3 keys (<modifier>+[<secondary_modifier>]+<key>), e.g.: "Ctrl+Shift+Z"
          
          If a key combination is already used by the browser (like "Ctrl+P") or by an existing add-on, then you can't override it. You can define it, but your event handler will not be called when the user presses the key combination.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/commands#shortcut_values
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(MediaNextTrack|MediaPlayPause|MediaPrevTrack|MediaStop|F(\\d|1[0-2])|((Ctrl|Alt|Command|MacCtrl)\\+((Shift|Ctrl|Alt|Command|MacCtrl)\\+)?(Comma|Period|Home|End|PageUp|PageDown|Space|Insert|Delete|Up|Down|Left|Right|[A-Z0-9]|F(\\d|1[0-2]|))))$"
            ],
      "_js2n__-:definitions/common_action!predicate" =
        _js2n__-prdslib.records.record
            {
              browser_style = _js2n__-prdslib.isType '"Bool",
              default_icon =
                _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
              default_popup = _js2n__-prdslib.isType '"String",
              default_title = _js2n__-prdslib.isType '"String",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/gecko_version_support!predicate" =
        _js2n__-prdslib.records.record
            {
              strict_max_version = _js2n__-prdslib.isType '"String",
              strict_min_version = _js2n__-prdslib.isType '"String",
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/glob_pattern!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/icon!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType 'Record
                  ],
                _js2n__-prdslib.records.record {}
                  { "^[1-9]\\d+$" = _js2n__-prdslib.isType '"String", } false
                  _js2n__-prdslib.never
              ]),
      "_js2n__-:definitions/icon!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.records.record {}
                { "^[1-9]\\d+$" = _js2n__-prdslib.isType '"String", } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/match_pattern!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(<all_urls>|(\\*|http|https|ws|wss|ftp|data|file|ftp|(chrome-)?extension):\\/\\/(\\*|\\*\\.[^\\/\\*]+|[^\\/\\*]+)?(\\/.*))$"
            ],
      "_js2n__-:definitions/match_pattern_strict!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(\\*|http|https|ws|wss|ftp|data|file|ftp|(chrome-)?extension):\\/\\/(\\*|\\*\\.[^\\/\\*]+|[^\\/\\*]+)?(\\/.*)$"
            ],
      "_js2n__-:definitions/scripts!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"Array",
                _js2n__-prdslib.arrays.arrayOf
                  (_js2n__-prdslib.isType '"String"),
                _js2n__-prdslib.arrays.uniqueItems
              ]),
      "_js2n__-:definitions/scripts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  {
      author
        | String
        | doc m%"
          The extension's author, intended for display in the browser's user interface. If the developer key is supplied and it contains the "name`" property, it will override the author key. There's no way to specify multiple authors.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/author
        "%
        | optional,
      background
        | {
          page
            | String
            | doc m%"
               If you need specific content in the background page, you can define a page using the page property. This is a String representing a path relative to the manifest.json file to an HTML document included in your extension bundle.
              
              If you use this property, you can not specify background scripts using scripts, but you can include scripts from the page, just like a normal web page.
            "%
            | optional,
          persistent
            | Bool
            | doc m%"
              If omitted, this property defaults to true in Manifest V2 and false in Manifest V3. Setting to true in Manifest V3 results in an error.
              
              `true` indicates the background page is to be kept in memory from when the extension is loaded or the browser starts until the extension is unloaded or disabled, or the browser is closed (that is, the background page is persistent).
              `false` indicates the background page may be unloaded from memory when idle and recreated when needed. Such background pages are often called Event Pages, because they are loaded into memory to allow the background page to handle the events to which it has added listeners. Registration of listeners is persistent when the page is unloaded from memory, but other values are not persistent. If you want to store data persistently in an event page, then you should use the storage API.
            "%
            | optional,
          scripts
            | Array (String)
            | doc m%"
               An Array of Strings, each of which is a path to a JavaScript source. The path is relative to the manifest.json file itself. These are the scripts that are executed in the extension's background page.
              The scripts share the same window global context.
              The scripts are loaded in the order they appear in the array.
              If you specify scripts, an empty page is created where your scripts run.
              Note: If you want to fetch a script from a remote location with the <script> tag (e.g., <script src = "https://code.jquery.com/jquery-3.6.0.min.js">), you have to change the content_security_policy key in the manifest.json file of your extension.
            "%
            | optional,
          service_worker
            | String
            | doc "Specify a JavaScript file as the extension service worker. A service worker is a background script that acts as the extension's main event handler."
            | optional,
          type
            | std.enum.TagOrString
            | [| 'module, 'classic |]
            | doc m%"
              Determines whether the scripts specified in "scripts" are loaded as ES modules.
              
              `classic` indicates the background scripts or service workers are not included as an ES Module.
              
              If omitted, this property defaults to classic.
            "%
            | optional,
        }
        | doc m%"
          Use the background key to include one or more background scripts, a background page, or a Service worker in your extension.
          
          Background scripts are the place to put code that needs to maintain a long-term state or perform long-term operations independently of the lifetime of any particular web pages or browser windows.
          
          Background scripts are loaded as soon as the extension is loaded and stay loaded until the extension is disabled or uninstalled unless persistent is specified as false. You can use any WebExtension APIs in the script if you have requested the necessary permissions.
          
          See Background scripts for some more details.
          
          The background key is an object that must have one of these properties (for more information on how these properties are supported, see Browser support)
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/background
        "%
        | optional,
      browser_action
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  default_area =
                    _js2n__-prdslib.enum
                        [
                          "navbar",
                          "menupanel",
                          "tabstrip",
                          "personaltoolbar"
                        ],
                  theme_icons =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "dark", "light", "size" ],
                                _js2n__-prdslib.records.record
                                  {
                                    dark = _js2n__-prdslib.isType '"String",
                                    light = _js2n__-prdslib.isType '"String",
                                    size =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Integer,
                                            _js2n__-prdslib.enum [ 16, 32 ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} true _js2n__-prdslib.always,
              _js2n__-refsenv."_js2n__-:definitions/common_action!predicate"
            ])
        | doc m%"
          A browser action is a button that your extension adds to the browser's toolbar. The button has an icon, and may optionally have a popup whose content is specified using HTML, CSS, and JavaScript.
          
          This key is replaced by action in Manifest V3 extensions.
          
          If you supply a popup, then the popup is opened when the user clicks the button, and your JavaScript running in the popup can handle the user's interaction with it. If you don't supply a popup, then a click event is dispatched to your extension's background scripts when the user clicks the button.
          
          You can also create and manipulate browser actions programmatically using the browserAction API.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/browser_action
        "%
        | optional,
      browser_specific_settings
        | {
          gecko
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      id =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.pattern
                                "^\\{[A-Fa-f0-9]{8}-([A-Fa-f0-9]{4}-){3}[A-Fa-f0-9]{12}\\}$|^[A-Za-z0-9-._]*@[A-Za-z0-9-._]+$"
                            ],
                      update_url = _js2n__-prdslib.isType '"String",
                    } {} true _js2n__-prdslib.always,
                  _js2n__-refsenv."_js2n__-:definitions/gecko_version_support!predicate"
                ])
            | optional,
          gecko_android
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-refsenv."_js2n__-:definitions/gecko_version_support!predicate"
                ])
            | doc "When not defined, it falls back to `gecko`"
            | optional,
          safari
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-refsenv."_js2n__-:definitions/gecko_version_support!predicate"
                ])
            | doc "Specific for Safari and Safari on IOS"
            | optional,
          ..
        }
        | doc "The browser_specific_settings key contains keys that are specific to a particular host application."
        | optional,
      chrome_settings_overrides
        | {
          homepage
            | String
            | doc m%"
              Defines the page to be used as the browser's homepage.
              
              The replacement is given as a URL. The URL may:
              - point to a file bundled with the extension, in which case it is given as a URL relative to the manifest.json file
              - be a remote URL, such as "https://developer.mozilla.org/".
              
              If two or more extensions both set this value, then the setting from the most recently installed one will take precedence.
              
              To override new tabs, use "chrome_url_overrides" instead.
              
              This is a localizable property.
            "%
            | optional,
          search_provider
            | {
              alternate_urls
                | Array (String)
                | doc "An array of alternative URLs that can be used instead of search_url."
                | optional,
              encoding
                | String
                | doc "Encoding of the search term, specified as a standard character encoding name, such as \"UTF-8\"."
                | optional,
              favicon_url
                | String
                | doc "URL pointing to an icon for the search engine. This must be an absolute HTTP or HTTPS URL."
                | optional,
              image_url | String | doc "URL used for image search." | optional,
              image_url_post_params
                | String
                | doc "POST parameters to send to image_url."
                | optional,
              instant_url
                | String
                | doc "URL used for instant search."
                | optional,
              instant_url_post_params
                | String
                | doc "POST parameters to send to instant_url."
                | optional,
              is_default
                | Bool
                | doc "True if the search engine should be the default choice. On Firefox, this is opt-in and the user will only be asked the first time the extension is installed. They will not be asked again if a search engine is added later."
                | optional,
              keyword
                | String
                | doc "Address bar keyword for the search engine."
                | optional,
              name
                | String
                | doc "The search engine's name, displayed to the user.",
              prepopulated_id
                | String
                | doc "The ID of a built-in search engine to use."
                | optional,
              search_url
                | String
                | doc "URL used by the search engine. This must be an HTTPS URL.",
              search_url_post_params
                | String
                | doc "POST parameters to send to search_url."
                | optional,
              suggest_url
                | String
                | doc "URL used for search suggestions. This must be an HTTPS URL."
                | optional,
              suggest_url_post_params
                | String
                | doc "POST parameters to send to suggest_url."
                | optional,
            }
            | doc m%"
              Defines a search provider to add to the browser.
              
              In the URLs you supply, use "{searchTerms}" to interpolate the search term into the URL, like: https://www.discogs.com/search/?q={searchTerms}. You can also provide POST parameters to be sent along with the search.
              
              The search provider will be presented to the user alongside the built-in providers.
              
              All string properties are localizable.
            "%
            | optional,
        }
        | doc m%"
          Use the chrome_settings_overrides key to override the browser's home page and add a new search engine.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/chrome_settings_overrides
        "%
        | optional,
      chrome_url_overrides
        | {
          bookmarks
            | String
            | doc "Provide a replacement for the page that shows the bookmarks."
            | optional,
          history
            | String
            | doc "Provide a replacement for the page that shows the browsing history."
            | optional,
          newtab
            | String
            | doc "Provide a replacement for the document that's shown in the \"new tab\" page"
            | optional,
        }
        | doc m%"
          Use the chrome_url_overrides key to provide a custom replacement for the documents loaded into various special pages usually provided by the browser itself.
          
          The replacements are given as a URL to an HTML file. The file must be bundled with the extension: you can't specify a remote URL here. You can specify it relative to the extension's root folder, like: "path/to/newtab.html".
          
          The document can load CSS and JavaScript, just like a normal web page. JavaScript running in the page gets access to the same privileged "browser.*" APIs as the extension's background script.
          
          If two or more extensions both define custom new tab pages, then the last one to be installed or enabled gets to use its value.
          
          All properties are localizable.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/chrome_url_overrides
        "%
        | optional,
      commands
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  _execute_browser_action =
                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                  _execute_page_action =
                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                  _execute_sidebar_action =
                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                } {} true
                _js2n__-refsenv."_js2n__-:definitions/command!predicate"
            ])
        | doc m%"
          Use the commands key to define one or more keyboard shortcuts for your extension.
          
          Each keyboard shortcut is defined with a name, a combination of keys, and a description. Once you've defined commands in your extension's manifest.json, you can listen for their associated key combinations with the commands JavaScript API.
          
          The properties' name is the name of the shortcut.
          
          There are these 4 special shortcuts with default actions for which the commands.onCommand event does not fire
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/commands
        "%
        | optional,
      content_scripts
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "matches" ],
                    _js2n__-prdslib.records.record
                      {
                        all_frames = _js2n__-prdslib.isType '"Bool",
                        css =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String"),
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                        exclude_globs =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/glob_pattern!predicate",
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                        exclude_matches =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/match_pattern!predicate",
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                        include_globs =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/glob_pattern!predicate",
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                        js =
                          _js2n__-refsenv."_js2n__-:definitions/scripts!predicate",
                        match_about_blank = _js2n__-prdslib.isType '"Bool",
                        matches =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  _js2n__-refsenv."_js2n__-:definitions/match_pattern!predicate",
                                _js2n__-prdslib.arrays.minItems 1,
                                _js2n__-prdslib.arrays.uniqueItems
                              ],
                        run_at =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "document_start",
                                    "document_end",
                                    "document_idle"
                                  ]
                              ],
                        world =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "ISOLATED", "MAIN" ]
                              ],
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Instructs the browser to load content scripts into web pages whose URL matches a given pattern.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/content_scripts"
        | optional,
      content_security_policy
        | String
        | doc "Extensions have a content security policy (CSP) applied to them by default. The default policy restricts the sources from which extensions can load code (such as <script> resources) and disallows potentially unsafe practices such as the use of eval().<br>You can use this key to loosen or tighten the default policy. This key is specified in the same way as the Content-Security-Policy HTTP header.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/content_security_policy"
        | optional,
      declarative_net_request
        | {
          rule_resources
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "enabled", "id", "path" ],
                        _js2n__-prdslib.records.record
                          {
                            enabled = _js2n__-prdslib.isType '"Bool",
                            id =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.strings.pattern ".+"
                                  ],
                            path = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ]),
                  _js2n__-prdslib.arrays.uniqueItems
                ])
            | doc "An array of rulesets",
        }
        | doc "Specify static rulesets for use with declarativeNetRequest.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/declarative_net_request"
        | optional,
      default_locale
        | String
        | doc "This key must be present if the extension contains the _locales directory, and must be absent otherwise. It identifies a subdirectory of _locales, and this subdirectory will be used to find the default strings for your extension.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/default_locale"
        | optional,
      description
        | String
        | doc "A short description of the extension, intended for display in the browser's user interface. In Firefox and Chrome this value can be up to 132 characters. The limit in other browsers may differ.<br>This is a localizable property.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/description"
        | optional,
      developer
        | {
          name | String | doc "Overrides the `author` key" | optional,
          url | String | doc "Overrides the `homepage_url` key" | optional,
        }
        | doc "The name of the extension's developer and their homepage URL, intended for display in the browser's user interface.<br>This object only allows for a single developer name and URL to be specified.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/developer"
        | optional,
      devtools_page
        | String
        | doc "Use this key to enable your extension to extend the browser's built-in devtools.<br>This key is defined as a URL to an HTML file. The HTML file must be bundled with the extension, and the URL is relative to the extension's root.<br>The use of this manifest key triggers an install-time permission warning about devtools. To avoid an install-time permission warning, mark the feature as optional by listing the \"devtools\" permission in the optional_permissions manifest key.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/devtools_page"
        | optional,
      dictionaries
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ])
        | doc "The dictionaries key specifies the locale_code for which your extension supplies a dictionary (like `en-US`).<br>If you use the dictionaries key, you must also set an ID for your extension using the browser_specific_settings manifest.json key.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/dictionaries"
        | optional,
      externally_connectable
        | {
          ids
            | Array (String)
            | doc "Enables communication between this extension and other installed extensions specified by extension identifiers. Use the pattern \"*\" to communicate with all extensions."
            | optional,
          matches
            | Array (String)
            | doc "A list of regular expressions that enables communication between an extension and the web pages that match the expression.<br><br>Note: If `externally_connectable` is not specified, communication among extensions is allowed as if `externally_connectable` specified `{\"ids\": [\"*\"] }`. Therefore, if you specify `externally_connectable.matches`, don't forget to add `ids` if you want to communicate with other extensions."
            | optional,
        }
        | doc "Externally connectable controls which other extensions and web pages can communicate with an extension using runtime.connect() and runtime.sendMessage() message passing. If externally_connectable is not specified, all extensions can communicate with each other but not with web pages.<br><br>Note: For communication with web pages:<br>In Chrome, chrome.runtime.connect and chrome.runtime.sendMessage are used. These methods are only available when there is at least one extension listening for messages, see chrome.runtime will no longer be defined unconditionally in Chrome 106 for more details.<br>In Safari, browser.runtime.connect and browser.runtime.sendMessage are used.<br>In Firefox, neither API is supported. See Firefox bug 1319168.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/externally_connectable"
        | optional,
      homepage_url
        | String
        | doc "URL for the extension's home page.<br>If a developer key containing the \"url\" property and \"homepage_url\" are defined, Firefox uses \"developer.url\" while Opera uses \"homepage_url\". Chrome and Safari do not support the \"developer\" key.<br>This is a localizable property.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/homepage_url"
        | optional,
      icons
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.records.record {}
            { "^[1-9]\\d*$" = _js2n__-prdslib.isType '"String", } false
            _js2n__-prdslib.never)
        | doc "The icons key specifies icons for your extension. Those icons will be used to represent the extension in components such as the Add-ons Manager.<br>It consists of key-value pairs of image size in px and image path relative to the root directory of the extension.<br>If icons is not supplied, a standard extension icon will be used by default.<br>You should supply at least a main extension icon, ideally 48x48 px in size. This is the default icon that will be used in the Add-ons Manager.<br>You can use SVG and the browser will scale your icon appropriately. There are currently two caveats though.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/icons"
        | optional,
      incognito
        | std.enum.TagOrString
        | [| 'not_allowed, 'split, 'spanning |]
        | doc "Use the incognito key to control how the extension works with private browsing windows.<br><br>Note: By default, extensions do not run in private browsing windows. Whether an extension can access private browsing windows is under user control. For details, see Extensions in Private Browsing. Your extension can check whether it can access private browsing windows using extension.isAllowedIncognitoAccess.<br><br>This is a string that can take any of these values:<br>\"spanning\" (the default): the extension will see events from private and non-private windows and tabs. Windows and tabs will get an incognito property in the `Window` or `Tab` that represents them. This property indicates whether or not the object is private<br>\"split\": the extension will be split between private and non-private windows. There are effectively two copies of the extension running: one sees only non-private windows, the other sees only private windows. Each copy has isolated access to Web APIs (so, for example, localStorage is not shared). However, the WebExtension API storage.local is shared. (Note: this setting is not supported by Firefox.)<br>\"not_allowed\": private tabs and windows are invisible to the extension.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/incognito"
        | optional,
      manifest_version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.enum [ 2 ] ])
        | doc "This key specifies the version of manifest.json used by this extension.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/manifest_version",
      name
        | String
        | doc "Name of the extension. This is used to identify the extension in the browser's user interface and on sites like addons.mozilla.org.<br>It's good practice to keep the name short enough to display in the UI. Also, the length of the name of a published extension may be limited.<br>These restrictions do not apply to self-hosted extensions or extensions distributed outside the stores.<br>This is a localizable property.<br><br>https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/name",
      omnibox
        | {
          keyword
            | String
            | doc "The keyword that will trigger your extension.",
        }
        | doc m%"
          Use the omnibox key to define an omnibox keyword for your extension.
          
          When the user types this keyword into the browser's address bar, followed by a space, then any subsequent characters will be sent to the extension using the omnibox API. The extension will then be able to populate the address bar's drop-down suggestions list with its own suggestions.
          
          If two or more extensions define the same keyword, then the extension that was installed last gets to control the keyword. Any previously installed extensions that defined the same keyword will no longer be able to use the omnibox API.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/omnibox
        "%
        | optional,
      optional_permissions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "activeTab",
                        "background",
                        "bookmarks",
                        "browserSettings",
                        "browsingData",
                        "clipboardRead",
                        "clipboardWrite",
                        "contentSettings",
                        "contextMenus",
                        "cookies",
                        "debugger",
                        "declarativeNetRequest",
                        "declarativeNetRequestFeedback",
                        "declarativeNetRequestWithHostAccess",
                        "devtools",
                        "downloads",
                        "downloads.open",
                        "find",
                        "geolocation",
                        "history",
                        "idle",
                        "management",
                        "nativeMessaging",
                        "notifications",
                        "pageCapture",
                        "pkcs11",
                        "privacy",
                        "proxy",
                        "scripting",
                        "search",
                        "sessions",
                        "tabHide",
                        "tabs",
                        "topSites",
                        "webNavigation",
                        "webRequest",
                        "webRequestBlocking",
                        "webRequestFilterResponse",
                        "webRequestFilterResponse.serviceWorkerScript"
                      ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Use the optional_permissions key to list permissions which you want to ask for at runtime, after your add-on has been installed.
          The key can contain two kinds of permissions: host permissions and API permissions.
          Not all permissions are compatible with all browsers
          Some are granted silently, without user prompt
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/optional_permissions
        "%
        | optional,
      options_page
        | String
        | doc m%"
          Use the options_page key to define an options page for your extension.
          
          The options page contains settings for the extension. The user can access it from the browser's add-ons manager, and you can open it from within your extension using runtime.openOptionsPage().
          
          Unlike options pages specified using the newer options_ui key, options pages specified using the deprecated options_page key don't receive browser styles and always open in a normal browser tab.
          
          WARNING: This manifest key has been deprecated. Use `options_ui` instead.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/options_page#browser_compatibility
        "%
        | optional,
      options_ui
        | {
          browser_style
            | Bool
            | doc "Use this to include a stylesheet in your page that will make it look consistent with the browser's UI and with other add-ons that use the browser_style property."
            | optional,
          open_in_tab
            | Bool
            | doc "If true, the options page will open in a normal browser tab, rather than being integrated into the browser's add-ons manager."
            | optional,
          page
            | String
            | doc m%"
              The path to an HTML file containing the specification of your options page.
              
              The path is relative to the location of manifest.json itself.
            "%,
        }
        | doc m%"
          Use the options_ui key to define an options page for your extension.
          
          The options page contains settings for the extension. The user can access it from the browser's add-ons manager, and you can open it from within your extension using runtime.openOptionsPage().
          
          You specify options_ui as a path to an HTML file packaged with your extension. The HTML file can include CSS and JavaScript files, just like a normal web page. Unlike a normal page, though, the JavaScript can use all the WebExtension APIs that the extension has permissions for. However, it runs in a different scope than your background scripts.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/options_ui
        "%
        | optional,
      page_action
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  hide_matches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/match_pattern_strict!predicate"
                        ],
                  pinned = _js2n__-prdslib.isType '"Bool",
                  show_matches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/match_pattern!predicate"
                        ],
                } {} true _js2n__-prdslib.always,
              _js2n__-refsenv."_js2n__-:definitions/common_action!predicate"
            ])
        | doc m%"
          A page action is an icon that your extension adds inside the browser's URL bar.
          
          Your extension may optionally also supply an associated popup whose content is specified using HTML, CSS, and JavaScript.
          
          If you supply a popup, then the popup is opened when the user clicks the icon, and your JavaScript running in the popup can handle the user's interaction with it. If you don't supply a popup, then a click event is dispatched to your extension's background scripts when the user clicks the icon.
          
          Page actions are like browser actions, except that they are associated with particular web pages rather than with the browser as a whole. If an action is only relevant on certain pages, then you should use a page action and display it only on relevant pages. If an action is relevant to all pages or to the browser itself, use a browser action.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/page_action
        "%
        | optional,
      permissions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "<all_urls>",
                        "activeTab",
                        "alarms",
                        "background",
                        "bookmarks",
                        "browserSettings",
                        "browsingData",
                        "captivePortal",
                        "clipboardRead",
                        "clipboardWrite",
                        "contentSettings",
                        "contextMenus",
                        "contextualIdentities",
                        "cookies",
                        "debugger",
                        "declarativeNetRequest",
                        "declarativeNetRequestFeedback",
                        "declarativeNetRequestWithHostAccess",
                        "devtools ",
                        "dns",
                        "downloads",
                        "downloads.open",
                        "find",
                        "geolocation",
                        "history",
                        "identity",
                        "idle",
                        "management",
                        "menus",
                        "menus.overrideContext",
                        "nativeMessaging",
                        "notifications",
                        "pageCapture",
                        "pkcs11",
                        "privacy",
                        "proxy",
                        "scripting",
                        "search",
                        "sessions",
                        "storage",
                        "tabHide",
                        "tabs",
                        "theme",
                        "topSites",
                        "unlimitedStorage",
                        "webNavigation",
                        "webRequest",
                        "webRequestBlocking",
                        "webRequestFilterResponse",
                        "webRequestFilterResponse.serviceWorkerScript"
                      ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc m%"
          Use the permissions key to request special powers for your extension. This key is an array of strings, and each string is a request for a permission.
          
          If you request permissions using this key, then the browser may inform the user at install time that the extension is requesting certain privileges, and ask them to confirm that they are happy to grant these privileges.
          
          The key can contain three kinds of permissions:
           - host permissions: Specified as match patterns, and each pattern identifies a group of URLs for which the extension is requesting extra privileges. For example, a host permission could be "*://developer.mozilla.org/*".
          - API permissions: Specified as keywords, and each keyword names a WebExtension API that the extension would like to use.
          - activeTab: This permission is specified as "activeTab". If an extension has the activeTab permission, then when the user interacts with the extension, the extension is granted extra privileges for the active tab only.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/permissions
        "%
        | optional,
      protocol_handlers
        | Array
          {
            name
              | String
              | doc "A string representing the name of the protocol handler. This will be displayed to the user when they are being asked if they want this handler to open the link.",
            protocol
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.pattern "^(ext|web)\\+[a-z]+"
                      ],
                    _js2n__-prdslib.enum
                      [
                        "bitcoin",
                        "dat",
                        "dweb",
                        "ftp",
                        "geo",
                        "gopher",
                        "im",
                        "ipfs",
                        "ipns",
                        "irc",
                        "ircs",
                        "magnet",
                        "mailto",
                        "matrix",
                        "mms",
                        "news",
                        "nntp",
                        "sip",
                        "sms",
                        "smsto",
                        "ssb",
                        "ssh",
                        "tel",
                        "urn",
                        "webcal",
                        "wtai",
                        "xmpp"
                      ]
                  ])
              | doc "A string defining the protocol. It can either be one of the predefined protocols, or a custom name prefixed with \"web+\" or \"ext+\". For example: \"web+foo\" or \"ext+foo\". The custom name must consist only of lower-case ASCII characters. It's recommended that extensions use the \"ext+\" form.",
            uriTemplate
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.strings.pattern "%s")
              | doc "A string representing the URL of the handler. This string must include \"%s\" as a placeholder: this will be replaced with the escaped URL of the document to be handled. This URL might be a true URL, or it could be a phone number, email address, or so forth. This is a localizable property.",
          }
        | doc m%"
          Use this key to register one or more web-based protocol handlers.
          
          A protocol handler is an application that knows how to handle particular types of links: for example, a mail client is a protocol handler for "mailto:" links. When the user clicks a "mailto:" link, the browser opens the application selected as the handler for the "mailto:" protocol (or offers them a choice of handlers, depending on their settings).
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/protocol_handlers
        "%
        | optional,
      short_name
        | String
        | doc m%"
          Short name for the extension. If given, this will be used in contexts where the name field is too long. It's recommended that the short name should not exceed 12 characters. If the short name field is not included in manifest.json, then name will be used instead and may be truncated.
          
          This is a localizable property.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/short_name
        "%
        | optional,
      sidebar_action
        | {
          browser_style
            | Bool
            | doc "In Firefox, the stylesheet can be seen at chrome://browser/content/extension.css or chrome://browser/content/extension-mac.css on macOS."
            | optional,
          default_icon
            | _js2n__-refsenv."_js2n__-:definitions/icon!contract"
            | optional,
          default_panel
            | String
            | doc m%"
              The path to an HTML file that specifies the sidebar's contents.
              
              Unlike a normal web page, JavaScript running in the panel can access all the WebExtension APIs (subject, of course, to the extension having the appropriate permissions).
              
              This is a localizable property.
            "%,
          default_title
            | String
            | doc m%"
               Title for the sidebar. This is used in the browser UI for listing and opening sidebars, and is displayed at the top of the sidebar when it is open.
              
              This property is optional: if it is omitted, the sidebar's title is the extension's name.
              
              This is a localizable property.
            "%
            | optional,
          open_at_install
            | Bool
            | doc "Determines whether the sidebar should open on install. The default behavior is to open the sidebar when installation is completed."
            | optional,
        }
        | doc m%"
          A sidebar is a pane that is displayed at the left-hand side of the browser window, next to the web page. The browser provides a UI that enables the user to see the currently available sidebars and to select a sidebar to display.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/sidebar_action
        "%
        | optional,
      storage
        | {
          managed_schema
            | String
            | doc "The full path of the file within the extension that defines the schema of the manage storage.",
        }
        | doc m%"
          Use the storage key to specify the name of the schema file that defines the structure of data in managed storage.
          
          Managed data declares the enterprise policies supported by the app. Policies are analogous to options but are configured by a system administrator instead of the user, enabling the app to be configured for all users of an organization.
          
          After declaring the policies, they are read from the storage.managed API. However, if a policy value does not conform to the schema, then it is not published by the storage.managed API. It's up to the app to enforce the policies configured by the administrator.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/storage
        "%
        | optional,
      theme
        | {
          colors
            | {
              bookmark_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of text and icons in the bookmark and find bars. Also, if tab_text isn't defined it sets the color of the active tab text and if icons isn't defined the color of the toolbar icons. Provided as Chrome compatible alias for toolbar_text."
                | optional,
              button_background_active
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the background of the pressed toolbar buttons."
                | optional,
              button_background_hover
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the background of the toolbar buttons on hover."
                | optional,
              frame
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the header area background, displayed in the part of the header not covered or visible through the images specified in \"theme_frame\" and \"additional_backgrounds\"."
                | optional,
              frame_inactive
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the header area background when the browser window is inactive, displayed in the part of the header not covered or visible through the images specified in \"theme_frame\" and \"additional_backgrounds\"."
                | optional,
              icons
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of toolbar icons, excluding those in the find toolbar."
                | optional,
              icons_attention
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of toolbar icons in attention state such as the starred bookmark icon or finished download icon."
                | optional,
              ntp_background
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The new tab page background color."
                | optional,
              ntp_card_background
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The new tab page card background color."
                | optional,
              ntp_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The new tab page text color."
                | optional,
              popup
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The background color of popups (such as the URL bar dropdown and the arrow panels)."
                | optional,
              popup_border
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The border color of popups."
                | optional,
              popup_highlight
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The background color of items highlighted using the keyboard inside popups (such as the selected URL bar dropdown item)."
                | optional,
              popup_highlight_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The text color of items highlighted inside popups."
                | optional,
              popup_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The text color of popups."
                | optional,
              sidebar
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The background color of the sidebar."
                | optional,
              sidebar_border
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The border and splitter color of the browser sidebar"
                | optional,
              sidebar_highlight
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The background color of highlighted rows in built-in sidebars"
                | optional,
              sidebar_highlight_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The text color of highlighted rows in sidebars."
                | optional,
              sidebar_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The text color of sidebars."
                | optional,
              tab_background_separator
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  The color of the vertical separator of the background tabs.
                  
                  DEPRECATED
                "%
                | optional,
              tab_background_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the text displayed in the inactive page tabs. If tab_text or bookmark_text isn't specified, applies to the active tab text."
                | optional,
              tab_line
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the selected tab line."
                | optional,
              tab_loading
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the tab loading indicator and the tab loading burst."
                | optional,
              tab_selected
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The background color of the selected tab. When not in use selected tab color is set by frame and the frame_inactive."
                | optional,
              tab_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "Represents the text color for the selected tab. If tab_line isn't specified, it also defines the color of the selected tab line."
                | optional,
              toolbar
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  The background color for the navigation bar, the bookmarks bar, and the selected tab.
                  
                  This also sets the background color of the "Find" bar.
                "%
                | optional,
              toolbar_bottom_separator
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the line separating the bottom of the toolbar from the region below."
                | optional,
              toolbar_field
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  The background color for fields in the toolbar, such as the URL bar.
                  
                  This also sets the background color of the Find in page field. 
                "%
                | optional,
              toolbar_field_border
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  The border color for fields in the toolbar.
                  
                  This also sets the border color of the Find in page field. 
                "%
                | optional,
              toolbar_field_border_focus
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The focused border color for fields in the toolbar."
                | optional,
              toolbar_field_focus
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The focused background color for fields in the toolbar, such as the URL bar."
                | optional,
              toolbar_field_highlight
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The background color used to indicate the current selection of text in the URL bar (and the search bar, if it's configured to be separate)."
                | optional,
              toolbar_field_highlight_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color used to draw text that's currently selected in the URL bar (and the search bar, if it's configured to be separate box)."
                | optional,
              toolbar_field_separator
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc m%"
                  The color of separators inside the URL bar. In Firefox 58 this was implemented as toolbar_vertical_separator.
                  
                  DEPRECATED
                "%
                | optional,
              toolbar_field_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of text in fields in the toolbar, such as the URL bar. This also sets the color of text in the Find in page field."
                | optional,
              toolbar_field_text_focus
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of text in focused fields in the toolbar, such as the URL bar."
                | optional,
              toolbar_text
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of toolbar text. This also sets the color of text in the \"Find\" bar."
                | optional,
              toolbar_top_separator
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the line separating the top of the toolbar from the region above."
                | optional,
              toolbar_vertical_separator
                | _js2n__-refsenv."_js2n__-:definitions/color!contract"
                | doc "The color of the separator in the bookmarks toolbar."
                | optional,
            }
            | doc m%"
              Represents the colors of various parts of the browser.
              
              These properties define the colors used for different parts of the browser. How these properties affect the Firefox UI can be seen at https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/theme#colors.
              
              All these properties can be specified as either a string containing any valid CSS color string including hexadecimal (see https://developer.mozilla.org/en-US/docs/Web/CSS/color_value), or an RGB array
              
              Note: Where a component is affected by multiple color properties, the properties are listed in order of precedence.
            "%
            | optional,
          images
            | {
              additional_backgrounds
                | Array (String)
                | doc "An array of URLs for additional background images to be added to the header area and displayed behind the \"theme_frame\": image. These images layer the first image in the array on top, the last image in the array at the bottom."
                | optional,
              theme_frame
                | String
                | doc "The URL of a foreground image to be added to the header area and anchored to the upper right corner of the header area."
                | optional,
            }
            | doc "Represents the images to display in various parts of the browser."
            | optional,
          properties
            | {
              additional_backgrounds_alignment
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
                                "bottom",
                                "center",
                                "left",
                                "right",
                                "top",
                                "center bottom",
                                "center center",
                                "center top",
                                "left bottom",
                                "left center",
                                "left top",
                                "right bottom",
                                "right center",
                                "right top"
                              ]
                          ])
                    ])
                | doc "An array of enumeration values defining the alignment of the corresponding \"additional_backgrounds\": array item."
                | optional,
              additional_backgrounds_tiling
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [ "no-repeat", "repeat", "repeat-x", "repeat-y" ]
                          ])
                    ])
                | doc "Defines how the corresponding \"additional_backgrounds\": array item repeats."
                | optional,
              color_scheme
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [ "auto", "light", "dark", "system" ]
                          ])
                    ])
                | doc "Determines which color scheme is applied to the chrome (for example, context menus) and content (for example, built-in pages and the preferred color scheme for web pages)."
                | optional,
              content_color_scheme
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [ "auto", "light", "dark", "system" ]
                          ])
                    ])
                | doc "Determines which color scheme is applied to the content (for example, built-in pages and preferred color scheme for web pages). Overrides color_scheme."
                | optional,
            }
            | doc "Affects how the \"additional_backgrounds\" images are displayed and color schemes are applied."
            | optional,
        }
        | doc m%"
          Use the theme key to define a static theme to apply to Firefox.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/theme
        "%
        | optional,
      user_scripts
        | {
          api_script
            | String
            | doc m%"
              The API script:
              - runs in the content processes.
              - has access to the window and document globals related to the webpage it is attached to.
              - has access to the same subset of WebExtension APIs usually available in a content script.
              
              The script executes automatically on any webpage defined in matches by userScripts.register. However, this is before the user script sandbox object is created and the custom API methods can be exported.
              
              To export the custom API methods, the script listens for userScripts.onBeforeScript and then export the custom API methods.
              
              Not every user script may need to consume all of the custom API methods. You can, therefore, include details of the APIs needed in scriptMetadata when running userScripts.register. The API script then accesses the scriptMetadata through the script parameter received by the userScripts.onBeforeScript listener (as script.metadata).
            "%
            | optional,
        }
        | doc m%"
          Instructs the browser to load a script packaged in the extension, known as the API script, this script is used to export a set of custom API methods for use in user scripts.
          
          Note: The user_script key is required for the userScripts API to function, even if no API script is specified.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/user_scripts
        "%
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(0|[1-9][0-9]*)(\\.(0|[1-9][0-9]*)){0,3}$"
            ])
        | doc m%"
          The version string for the extension.
          
          The version string consists of 1 to 4 numbers separated by dots, for example, 1.2.3.4. Non-zero numbers must not include a leading zero.
          
          Extension stores and browsers may enforce or warn if the version string doesn't comply with this format. They may also apply restrictions to the range of numbers available.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/version
        "%,
      version_name
        | String
        | doc m%"
          In addition to the version field, which is used for update purposes, version_name can be set to a descriptive version string and will be used for display purposes if present.
          
          If no version_name is present, the version field will be used for display purposes as well.https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/version_name
        "%
        | optional,
      web_accessible_resources
        | _js2n__-refsenv."_js2n__-:definitions/scripts!contract"
        | doc m%"
          Sometimes you want to package resources—for example, images, HTML, CSS, or JavaScript—with your extension and make them available to web pages and other extensions.
          
          With the web_accessible_resources key, you list all the packaged resources that you want to make available to web pages. You specify them as paths relative to the manifest.json file.
          
          Note that content scripts don't need to be listed as web accessible resources.
          
          If an extension wants to use webRequest or declarativeNetRequest to redirect a public URL (e.g., HTTPS) to a page that's packaged in the extension, then the extension must list the page in the web_accessible_resources key.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/web_accessible_resources
        "%
        | optional,
      ..
    }