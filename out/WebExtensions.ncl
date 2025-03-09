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
      "_js2n__-:definitions/action!predicate" =
        _js2n__-prdslib.allOf
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
            ],
      "_js2n__-:definitions/browser_style!predicate"
        | doc m%"
          Do not set browser_style to true: its not support in Manifest V3 from Firefox 118. See Manifest V3 migration for browser_style.
          
          https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/user_interface/Browser_styles#manifest_v3_migration
        "%
        = _js2n__-prdslib.always,
      "_js2n__-:definitions/color!predicate" =
        _js2n__-prdslib.oneOf
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
            ],
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
              browser_style =
                _js2n__-refsenv."_js2n__-:definitions/browser_style!predicate",
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
      "_js2n__-:definitions/scripts!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.ifThenElse
            (_js2n__-prdslib.records.record
              { manifest_version = _js2n__-prdslib.const 2, } {} true
              _js2n__-prdslib.always)
            (_js2n__-prdslib.records.record
              {
                browser_action =
                  _js2n__-refsenv."_js2n__-:definitions/action!predicate",
                options_ui =
                  _js2n__-prdslib.records.record
                      { browser_style = _js2n__-prdslib.isType '"Bool", } {}
                      true _js2n__-prdslib.always,
              } {} true _js2n__-prdslib.always)
            (_js2n__-prdslib.records.record
              {
                action =
                  _js2n__-refsenv."_js2n__-:definitions/action!predicate",
                background =
                  _js2n__-prdslib.records.record
                      { persistent = _js2n__-prdslib.const false, } {} true
                      _js2n__-prdslib.always,
                host_permissions =
                  _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          _js2n__-refsenv."_js2n__-:definitions/match_pattern!predicate"
                      ],
              } {} true _js2n__-prdslib.always),
          _js2n__-prdslib.records.required
            [ "manifest_version", "name", "version" ],
          _js2n__-prdslib.records.record
            {
              author = _js2n__-prdslib.isType '"String",
              background =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          page = _js2n__-prdslib.isType '"String",
                          persistent = _js2n__-prdslib.isType '"Bool",
                          scripts =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          service_worker = _js2n__-prdslib.isType '"String",
                          type =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum [ "classic", "module" ]
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              browser_specific_settings =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          gecko =
                            _js2n__-prdslib.allOf
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
                                      update_url =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always,
                                  _js2n__-refsenv."_js2n__-:definitions/gecko_version_support!predicate"
                                ],
                          gecko_android =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/gecko_version_support!predicate"
                                ],
                          safari =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-refsenv."_js2n__-:definitions/gecko_version_support!predicate"
                                ],
                        } {} true _js2n__-prdslib.always
                    ],
              chrome_settings_overrides =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          homepage = _js2n__-prdslib.isType '"String",
                          search_provider =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "name", "search_url" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      alternate_urls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      encoding =
                                        _js2n__-prdslib.isType '"String",
                                      favicon_url =
                                        _js2n__-prdslib.isType '"String",
                                      image_url =
                                        _js2n__-prdslib.isType '"String",
                                      image_url_post_params =
                                        _js2n__-prdslib.isType '"String",
                                      instant_url =
                                        _js2n__-prdslib.isType '"String",
                                      instant_url_post_params =
                                        _js2n__-prdslib.isType '"String",
                                      is_default =
                                        _js2n__-prdslib.isType '"Bool",
                                      keyword =
                                        _js2n__-prdslib.isType '"String",
                                      name = _js2n__-prdslib.isType '"String",
                                      prepopulated_id =
                                        _js2n__-prdslib.isType '"String",
                                      search_url =
                                        _js2n__-prdslib.isType '"String",
                                      search_url_post_params =
                                        _js2n__-prdslib.isType '"String",
                                      suggest_url =
                                        _js2n__-prdslib.isType '"String",
                                      suggest_url_post_params =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              chrome_url_overrides =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          bookmarks = _js2n__-prdslib.isType '"String",
                          history = _js2n__-prdslib.isType '"String",
                          newtab = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ],
              commands =
                _js2n__-prdslib.allOf
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
                    ],
              content_scripts =
                _js2n__-prdslib.allOf
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
                                match_about_blank =
                                  _js2n__-prdslib.isType '"Bool",
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
                                        _js2n__-prdslib.enum
                                          [ "ISOLATED", "MAIN" ]
                                      ],
                              } {} false _js2n__-prdslib.never
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              content_security_policy = _js2n__-prdslib.isType '"String",
              declarative_net_request =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "rule_resources" ],
                      _js2n__-prdslib.records.record
                        {
                          rule_resources =
                            _js2n__-prdslib.allOf
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
                                            enabled =
                                              _js2n__-prdslib.isType '"Bool",
                                            id =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      ".+"
                                                  ],
                                            path =
                                              _js2n__-prdslib.isType '"String",
                                          } {} false _js2n__-prdslib.never
                                      ]),
                                  _js2n__-prdslib.arrays.uniqueItems
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              default_locale = _js2n__-prdslib.isType '"String",
              description = _js2n__-prdslib.isType '"String",
              developer =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          name = _js2n__-prdslib.isType '"String",
                          url = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ],
              devtools_page = _js2n__-prdslib.isType '"String",
              dictionaries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.propertyNames
                        (_js2n__-prdslib.isType '"String"),
                      _js2n__-prdslib.records.record {} {} false
                        _js2n__-prdslib.never
                    ],
              externally_connectable =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          ids =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          matches =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              homepage_url = _js2n__-prdslib.isType '"String",
              icons =
                _js2n__-prdslib.records.record {}
                    { "^[1-9]\\d*$" = _js2n__-prdslib.isType '"String", } false
                    _js2n__-prdslib.never,
              incognito =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "spanning", "split", "not_allowed" ]
                    ],
              manifest_version =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 2, 3 ]
                    ],
              name = _js2n__-prdslib.isType '"String",
              offline_enabled = _js2n__-prdslib.isType '"Bool",
              omnibox =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "keyword" ],
                      _js2n__-prdslib.records.record
                        { keyword = _js2n__-prdslib.isType '"String", } {} false
                        _js2n__-prdslib.never
                    ],
              optional_permissions =
                _js2n__-prdslib.allOf
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
                    ],
              options_page = _js2n__-prdslib.isType '"String",
              options_ui =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "page" ],
                      _js2n__-prdslib.records.record
                        {
                          browser_style =
                            _js2n__-refsenv."_js2n__-:definitions/browser_style!predicate",
                          open_in_tab = _js2n__-prdslib.isType '"Bool",
                          page = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ],
              page_action =
                _js2n__-prdslib.allOf
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
                    ],
              permissions =
                _js2n__-prdslib.allOf
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
                    ],
              protocol_handlers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required
                              [ "name", "protocol", "uriTemplate" ],
                            _js2n__-prdslib.records.record
                              {
                                name = _js2n__-prdslib.isType '"String",
                                protocol =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.strings.pattern
                                              "^(ext|web)\\+[a-z]+"
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
                                      ],
                                uriTemplate =
                                  _js2n__-prdslib.strings.pattern "%s",
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
              short_name = _js2n__-prdslib.isType '"String",
              sidebar_action =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "default_panel" ],
                      _js2n__-prdslib.records.record
                        {
                          browser_style =
                            _js2n__-refsenv."_js2n__-:definitions/browser_style!predicate",
                          default_icon =
                            _js2n__-refsenv."_js2n__-:definitions/icon!predicate",
                          default_panel = _js2n__-prdslib.isType '"String",
                          default_title = _js2n__-prdslib.isType '"String",
                          open_at_install = _js2n__-prdslib.isType '"Bool",
                        } {} false _js2n__-prdslib.never
                    ],
              storage =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "managed_schema" ],
                      _js2n__-prdslib.records.record
                        { managed_schema = _js2n__-prdslib.isType '"String", }
                        {} false _js2n__-prdslib.never
                    ],
              theme =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          colors =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      bookmark_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      button_background_active =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      button_background_hover =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      frame =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      frame_inactive =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      icons =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      icons_attention =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      ntp_background =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      ntp_card_background =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      ntp_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      popup =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      popup_border =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      popup_highlight =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      popup_highlight_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      popup_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      sidebar =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      sidebar_border =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      sidebar_highlight =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      sidebar_highlight_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      sidebar_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      tab_background_separator =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      tab_background_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      tab_line =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      tab_loading =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      tab_selected =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      tab_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_bottom_separator =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_border =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_border_focus =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_focus =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_highlight =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_highlight_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_separator =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_field_text_focus =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_text =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_top_separator =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                      toolbar_vertical_separator =
                                        _js2n__-refsenv."_js2n__-:definitions/color!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          images =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      additional_backgrounds =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      theme_frame =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          properties =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      additional_backgrounds_alignment =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
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
                                            ],
                                      additional_backgrounds_tiling =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "no-repeat",
                                                        "repeat",
                                                        "repeat-x",
                                                        "repeat-y"
                                                      ]
                                                  ])
                                            ],
                                      color_scheme =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "auto",
                                                        "light",
                                                        "dark",
                                                        "system"
                                                      ]
                                                  ])
                                            ],
                                      content_color_scheme =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "auto",
                                                        "light",
                                                        "dark",
                                                        "system"
                                                      ]
                                                  ])
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              user_scripts =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { api_script = _js2n__-prdslib.isType '"String", } {}
                        false _js2n__-prdslib.never
                    ],
              version =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^(0|[1-9][0-9]*)(\\.(0|[1-9][0-9]*)){0,3}$"
                    ],
              version_name = _js2n__-prdslib.isType '"String",
              web_accessible_resources =
                _js2n__-refsenv."_js2n__-:definitions/scripts!predicate",
            } {} true _js2n__-prdslib.always
        ])