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
      "_js2n__-:definitions/Workflow!contract" =
        {
            defaultRetryPolicy
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.records.record {} {} false
                      _js2n__-prdslib.never,
                    _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                  ])
              | optional,
            start | String,
            steps
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.minProperties 1,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Step!predicate"
                        ])
                  ]),
            yawl
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^0.1$"
                  ]),
          },
      "_js2n__-:definitions/yawl.Branch!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "start", "steps" ],
              _js2n__-prdslib.records.record
                {
                  start = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.record {} {} false
                                  _js2n__-prdslib.never,
                                _js2n__-refsenv."_js2n__-:definitions/yawl.Step!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Choice!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "condition", "next" ],
              _js2n__-prdslib.records.record
                {
                  condition = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.ContainerCall!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "containerId" ],
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  containerId = _js2n__-prdslib.isType '"String",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "OPTIONS",
                              "GET",
                              "HEAD",
                              "POST",
                              "PUT",
                              "PATCH",
                              "DELETE",
                              "TRACE",
                              "CONNECT"
                            ]
                        ],
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  query =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Default!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "next" ],
              _js2n__-prdslib.records.record
                { next = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Fail!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "errorMessage" ],
              _js2n__-prdslib.records.record
                { errorMessage = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Foreach!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "do", "input", "output" ],
              _js2n__-prdslib.records.record
                {
                  do =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.ForeachDo!predicate"
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.ForeachDo!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "start", "steps" ],
              _js2n__-prdslib.records.record
                {
                  start = _js2n__-prdslib.isType '"String",
                  steps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.record {} {} false
                                  _js2n__-prdslib.never,
                                _js2n__-refsenv."_js2n__-:definitions/yawl.Step!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.FoundationModelsCall!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "generate" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "modelUrl" ],
              _js2n__-prdslib.records.record
                {
                  generate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.FoundationModelsGenerate!predicate"
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  modelUrl = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.FoundationModelsGenerate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "json" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "messages" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "maxTokens", "temperature" ],
              _js2n__-prdslib.records.record
                {
                  json = _js2n__-prdslib.isType '"String",
                  maxTokens = _js2n__-prdslib.isType 'Integer,
                  messages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.FoundationModelsGenerate.Messages!predicate"
                        ],
                  temperature = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.FoundationModelsGenerate.Message!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "role", "text" ],
              _js2n__-prdslib.records.record
                {
                  role = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.FoundationModelsGenerate.Messages!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "messages" ],
              _js2n__-prdslib.records.record
                {
                  messages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/yawl.FoundationModelsGenerate.Message!predicate",
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.FunctionCall!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "functionId" ],
              _js2n__-prdslib.records.record
                {
                  functionId = _js2n__-prdslib.isType '"String",
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  tag = _js2n__-prdslib.isType '"String",
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.GRPCCall!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "endpoint", "method" ],
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  endpoint = _js2n__-prdslib.isType '"String",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  method = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  useServiceAccount = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.HTTPCall!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "url" ],
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  method =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "OPTIONS",
                              "GET",
                              "HEAD",
                              "POST",
                              "PUT",
                              "PATCH",
                              "DELETE",
                              "TRACE",
                              "CONNECT"
                            ]
                        ],
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  query =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.InterpolatableMap!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "json" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "plainValue" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  json = _js2n__-prdslib.isType '"String",
                  plainValue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.MapValue!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.MapValue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pairs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.NoOp!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "next", "output" ],
              _js2n__-prdslib.records.record
                {
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.ObjectStorage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "put" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "get" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "bucket", "object" ],
              _js2n__-prdslib.records.record
                {
                  bucket = _js2n__-prdslib.isType '"String",
                  get =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.ObjectStorageGet!predicate"
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  object = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  put =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.ObjectStoragePut!predicate"
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.ObjectStorageGet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.ObjectStoragePut!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "content" ],
              _js2n__-prdslib.records.record
                { content = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Organization!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "yandexOrganizationId" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "cloudOrganizationId" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  cloudOrganizationId = _js2n__-prdslib.isType '"String",
                  yandexOrganizationId = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Parallel!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "branches" ],
              _js2n__-prdslib.records.record
                {
                  branches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.record {} {} false
                                  _js2n__-prdslib.never,
                                _js2n__-refsenv."_js2n__-:definitions/yawl.Branch!predicate"
                              ])
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Postbox!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "simple" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "raw" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "destination", "fromAddress" ],
              _js2n__-prdslib.records.record
                {
                  destination =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxDestination!predicate"
                        ],
                  fromAddress = _js2n__-prdslib.isType '"String",
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  raw =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxRawMessage!predicate"
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  simple =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxSimpleMessage!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.PostboxBody!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "html", "text" ],
              _js2n__-prdslib.records.record
                {
                  html =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxMessageData!predicate"
                        ],
                  text =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxMessageData!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.PostboxDestination!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "toAddresses" ],
              _js2n__-prdslib.records.record
                {
                  ccAddresses = _js2n__-prdslib.isType '"String",
                  toAddresses = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.PostboxMessageData!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "charset", "data" ],
              _js2n__-prdslib.records.record
                {
                  charset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "CHARSET_UNSPECIFIED",
                              "UTF_8",
                              "ISO_8859_1",
                              "SHIFT_JIS"
                            ]
                        ],
                  data = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.PostboxRawMessage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "data" ],
              _js2n__-prdslib.records.record
                { data = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.PostboxSimpleMessage!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "body", "subject" ],
              _js2n__-prdslib.records.record
                {
                  body =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxBody!predicate"
                        ],
                  subject =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.PostboxMessageData!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.RetryPolicy!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "errorList" ],
              _js2n__-prdslib.records.record
                {
                  backoffRate = _js2n__-prdslib.isType '"Number",
                  errorList =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.enum
                              [
                                "ALL",
                                "STEP_DATA_LIMIT_EXCEEDED",
                                "STEP_NO_CHOICE_MATCHED",
                                "STEP_PERMISSION_DENIED",
                                "STEP_TIMEOUT",
                                "STEP_INVALID_OUTPUT",
                                "STEP_INTERNAL",
                                "STEP_INVALID_TEMPLATE_EXPRESSION",
                                "STEP_FAIL",
                                "STEP_INVALID_ARGUMENT",
                                "STEP_QUOTA_EXCEEDED",
                                "STEP_FAILED_PRECONDITION",
                                "HTTP_CALL_400",
                                "HTTP_CALL_401",
                                "HTTP_CALL_402",
                                "HTTP_CALL_403",
                                "HTTP_CALL_404",
                                "HTTP_CALL_405",
                                "HTTP_CALL_406",
                                "HTTP_CALL_407",
                                "HTTP_CALL_408",
                                "HTTP_CALL_409",
                                "HTTP_CALL_410",
                                "HTTP_CALL_411",
                                "HTTP_CALL_412",
                                "HTTP_CALL_413",
                                "HTTP_CALL_414",
                                "HTTP_CALL_415",
                                "HTTP_CALL_416",
                                "HTTP_CALL_417",
                                "HTTP_CALL_418",
                                "HTTP_CALL_419",
                                "HTTP_CALL_420",
                                "HTTP_CALL_421",
                                "HTTP_CALL_422",
                                "HTTP_CALL_423",
                                "HTTP_CALL_424",
                                "HTTP_CALL_425",
                                "HTTP_CALL_426",
                                "HTTP_CALL_427",
                                "HTTP_CALL_428",
                                "HTTP_CALL_429",
                                "HTTP_CALL_431",
                                "HTTP_CALL_449",
                                "HTTP_CALL_451",
                                "HTTP_CALL_499",
                                "HTTP_CALL_500",
                                "HTTP_CALL_501",
                                "HTTP_CALL_505",
                                "HTTP_CALL_502",
                                "HTTP_CALL_503",
                                "HTTP_CALL_504",
                                "HTTP_CALL_506",
                                "HTTP_CALL_507",
                                "HTTP_CALL_508",
                                "HTTP_CALL_509",
                                "HTTP_CALL_510",
                                "HTTP_CALL_511",
                                "HTTP_CALL_520",
                                "HTTP_CALL_521",
                                "HTTP_CALL_522",
                                "HTTP_CALL_523",
                                "HTTP_CALL_524",
                                "HTTP_CALL_525",
                                "HTTP_CALL_526",
                                "GRPC_CALL_CANCELLED",
                                "GRPC_CALL_DEADLINE_EXCEEDED",
                                "GRPC_CALL_UNIMPLEMENTED",
                                "GRPC_CALL_UNAVAILABLE",
                                "GRPC_CALL_UNKNOWN",
                                "GRPC_CALL_INTERNAL",
                                "GRPC_CALL_RESOURCE_EXHAUSTED",
                                "GRPC_CALL_UNAUTHENTICATED",
                                "GRPC_CALL_INVALID_OPTIONS",
                                "GRPC_CALL_INVALID_REFLECTION_SERVER_RESPONSE",
                                "FUNCTION_CALL_INVALID_RESPONSE",
                                "CONTAINER_CALL_400",
                                "CONTAINER_CALL_401",
                                "CONTAINER_CALL_402",
                                "CONTAINER_CALL_403",
                                "CONTAINER_CALL_404",
                                "CONTAINER_CALL_405",
                                "CONTAINER_CALL_406",
                                "CONTAINER_CALL_407",
                                "CONTAINER_CALL_408",
                                "CONTAINER_CALL_409",
                                "CONTAINER_CALL_410",
                                "CONTAINER_CALL_411",
                                "CONTAINER_CALL_412",
                                "CONTAINER_CALL_413",
                                "CONTAINER_CALL_414",
                                "CONTAINER_CALL_415",
                                "CONTAINER_CALL_416",
                                "CONTAINER_CALL_417",
                                "CONTAINER_CALL_418",
                                "CONTAINER_CALL_419",
                                "CONTAINER_CALL_420",
                                "CONTAINER_CALL_421",
                                "CONTAINER_CALL_422",
                                "CONTAINER_CALL_423",
                                "CONTAINER_CALL_424",
                                "CONTAINER_CALL_425",
                                "CONTAINER_CALL_426",
                                "CONTAINER_CALL_427",
                                "CONTAINER_CALL_428",
                                "CONTAINER_CALL_429",
                                "CONTAINER_CALL_431",
                                "CONTAINER_CALL_449",
                                "CONTAINER_CALL_451",
                                "CONTAINER_CALL_499",
                                "CONTAINER_CALL_500",
                                "CONTAINER_CALL_501",
                                "CONTAINER_CALL_505",
                                "CONTAINER_CALL_502",
                                "CONTAINER_CALL_503",
                                "CONTAINER_CALL_504",
                                "CONTAINER_CALL_506",
                                "CONTAINER_CALL_507",
                                "CONTAINER_CALL_508",
                                "CONTAINER_CALL_509",
                                "CONTAINER_CALL_510",
                                "CONTAINER_CALL_511",
                                "CONTAINER_CALL_520",
                                "CONTAINER_CALL_521",
                                "CONTAINER_CALL_522",
                                "CONTAINER_CALL_523",
                                "CONTAINER_CALL_524",
                                "CONTAINER_CALL_525",
                                "CONTAINER_CALL_526",
                                "YDB_CALL_SERVICE_UNAVAILABLE"
                              ])
                        ],
                  errorListMode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "INCLUDE", "EXCLUDE" ]
                        ],
                  initialDelay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  maxDelay =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  retryCount = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Step!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "switch" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "foreach" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "parallel" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "success" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "fail" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "noOp" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "functionCall" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "containerCall" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "httpCall" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "grpcCall" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "ydbDocument" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "yds" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "ymq" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "foundationModelsCall" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "objectStorage" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "tracker" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "postbox" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "wait" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  containerCall =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.ContainerCall!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  fail =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Fail!predicate"
                        ],
                  foreach =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Foreach!predicate"
                        ],
                  foundationModelsCall =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.FoundationModelsCall!predicate"
                        ],
                  functionCall =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.FunctionCall!predicate"
                        ],
                  grpcCall =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.GRPCCall!predicate"
                        ],
                  httpCall =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.HTTPCall!predicate"
                        ],
                  noOp =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.NoOp!predicate"
                        ],
                  objectStorage =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.ObjectStorage!predicate"
                        ],
                  parallel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Parallel!predicate"
                        ],
                  postbox =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Postbox!predicate"
                        ],
                  success =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Success!predicate"
                        ],
                  switch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Switch!predicate"
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  tracker =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Tracker!predicate"
                        ],
                  wait =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Wait!predicate"
                        ],
                  ydbDocument =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDBDocument!predicate"
                        ],
                  yds =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDS!predicate"
                        ],
                  ymq =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YMQ!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Success!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Switch!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "choices" ],
              _js2n__-prdslib.records.record
                {
                  choices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/yawl.Choice!predicate",
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ],
                  "default" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Default!predicate"
                        ],
                  input = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Tracker!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "oauthToken" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "serviceAccount" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ],
                  _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "getIssue" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "createIssue" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "updateIssue" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "listIssues" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "linkIssues" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required
                            [ "updateIssueStatus" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "createComment" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "updateComment" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "listComments" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ]
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  createComment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerCreateComment!predicate"
                        ],
                  createIssue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerCreateIssue!predicate"
                        ],
                  endpoint = _js2n__-prdslib.isType '"String",
                  getIssue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerGetIssue!predicate"
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  linkIssues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerLinkIssues!predicate"
                        ],
                  listComments =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerListComments!predicate"
                        ],
                  listIssues =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerListIssues!predicate"
                        ],
                  next = _js2n__-prdslib.isType '"String",
                  oauthToken = _js2n__-prdslib.isType '"String",
                  organization =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.Organization!predicate"
                        ],
                  output = _js2n__-prdslib.isType '"String",
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  serviceAccount = _js2n__-prdslib.isType '"Bool",
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  updateComment =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateComment!predicate"
                        ],
                  updateIssue =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateIssue!predicate"
                        ],
                  updateIssueStatus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateIssueStatus!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerCreateComment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "text" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  mentions = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerCreateIssue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "queue", "title" ],
              _js2n__-prdslib.records.record
                {
                  additionalProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  assignee = _js2n__-prdslib.isType '"String",
                  author = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  followers = _js2n__-prdslib.isType '"String",
                  parent = _js2n__-prdslib.isType '"String",
                  "priority" = _js2n__-prdslib.isType '"String",
                  queue = _js2n__-prdslib.isType '"String",
                  sprints = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerGetIssue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                { key = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerLinkIssues!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "key", "linkKey", "relationship" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  linkKey = _js2n__-prdslib.isType '"String",
                  relationship = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerListComments!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  key = _js2n__-prdslib.isType '"String",
                  lastCommentId = _js2n__-prdslib.isType '"String",
                  pageSize = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerListIssues!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "queue" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "keys" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "filter" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "query" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  filter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerListIssues.SearchOptionsFilter!predicate"
                        ],
                  keys = _js2n__-prdslib.isType '"String",
                  pageNumber = _js2n__-prdslib.isType '"String",
                  pageSize = _js2n__-prdslib.isType '"String",
                  query = _js2n__-prdslib.isType '"String",
                  queue = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerListIssues.SearchOptionsFilter!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  issueProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  order = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerUpdateComment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "issueKey", "text" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  issueKey = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerUpdateIssue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                {
                  additionalProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateIssue.AdditionalProperties!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  followers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateIssue.Action!predicate"
                        ],
                  key = _js2n__-prdslib.isType '"String",
                  parent = _js2n__-prdslib.isType '"String",
                  "priority" = _js2n__-prdslib.isType '"String",
                  sprints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateIssue.Action!predicate"
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerUpdateIssue.Action!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "setValue" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "addValuesList" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "removeValuesList" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "replaceValuesMap" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  addValuesList = _js2n__-prdslib.isType '"String",
                  removeValuesList = _js2n__-prdslib.isType '"String",
                  replaceValuesMap =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.InterpolatableMap!predicate"
                        ],
                  setValue = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerUpdateIssue.AdditionalProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  pairs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.record {} {} false
                                  _js2n__-prdslib.never,
                                _js2n__-refsenv."_js2n__-:definitions/yawl.TrackerUpdateIssue.Action!predicate"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.TrackerUpdateIssueStatus!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "transition" ],
              _js2n__-prdslib.records.record
                {
                  additionalProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.MapValue!predicate"
                        ],
                  key = _js2n__-prdslib.isType '"String",
                  transition = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.Wait!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "duration" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "until" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  duration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  next = _js2n__-prdslib.isType '"String",
                  until = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDBDocument!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "get" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "put" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "update" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "scan" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "database", "tableName" ],
              _js2n__-prdslib.records.record
                {
                  database = _js2n__-prdslib.isType '"String",
                  get =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDBDocumentGet!predicate"
                        ],
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  put =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDBDocumentPut!predicate"
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  scan =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDBDocumentScan!predicate"
                        ],
                  tableName = _js2n__-prdslib.isType '"String",
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  update =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDBDocumentUpdate!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDBDocumentGet!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key" ],
              _js2n__-prdslib.records.record
                { key = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDBDocumentPut!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "item" ],
              _js2n__-prdslib.records.record
                { item = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDBDocumentScan!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "exclusiveStartKey", "limit" ],
              _js2n__-prdslib.records.record
                {
                  exclusiveStartKey = _js2n__-prdslib.isType '"String",
                  limit = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDBDocumentUpdate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression", "key" ],
              _js2n__-prdslib.records.record
                {
                  expression = _js2n__-prdslib.isType '"String",
                  expressionAttributeValues = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDS!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "put" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "database", "topic" ],
              _js2n__-prdslib.records.record
                {
                  database = _js2n__-prdslib.isType '"String",
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  put =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YDSPut!predicate"
                        ],
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                  topic = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YDSPut!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  partitionKey = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YMQ!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "put" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "queueArn" ],
              _js2n__-prdslib.records.record
                {
                  input = _js2n__-prdslib.isType '"String",
                  next = _js2n__-prdslib.isType '"String",
                  output = _js2n__-prdslib.isType '"String",
                  put =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.YMQPut!predicate"
                        ],
                  queueArn = _js2n__-prdslib.isType '"String",
                  retryPolicy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never,
                          _js2n__-refsenv."_js2n__-:definitions/yawl.RetryPolicy!predicate"
                        ],
                  timeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9]+\\.?[0-9]*|\\.[0-9]+)s$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/yawl.YMQPut!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { body = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-refsenv."_js2n__-:definitions/Workflow!contract"