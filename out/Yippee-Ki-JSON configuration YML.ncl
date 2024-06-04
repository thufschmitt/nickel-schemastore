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
      "_js2n__-:definitions/actionTypes/definitions/action!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "rules" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-refsenv."_js2n__-:definitions/actionTypes/definitions/actionName!predicate",
                  rules =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/anyRuleType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/actionTypes/definitions/actionName!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/name!predicate",
              _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/actionTypes/definitions/actions!predicate"
        | doc "The array of transformation action we will be able to select from at startup."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/actionTypes/definitions/action!predicate",
              _js2n__-prdslib.arrays.minItems 1
            ],
      "_js2n__-:definitions/commonTypes/definitions/charSet!predicate"
        | doc "Standard character sets."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "ISO-8859-1",
                  "US-ASCII",
                  "UTF-16",
                  "UTF-16BE",
                  "UTF-16LE",
                  "UTF-8"
                ]
            ],
      "_js2n__-:definitions/commonTypes/definitions/chronoUnit!predicate"
        | doc "The chrono unit we want to use."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "NANOS",
                  "MICROS",
                  "MILLIS",
                  "SECONDS",
                  "MINUTES",
                  "HOURS",
                  "HALF_DAYS",
                  "DAYS",
                  "WEEKS",
                  "MONTHS",
                  "YEARS",
                  "DECADES",
                  "CENTURIES",
                  "MILLENNIA",
                  "ERAS",
                  "FOREVER"
                ]
            ],
      "_js2n__-:definitions/commonTypes/definitions/httpHeaders!predicate"
        | doc "HTTP header map."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.arrays.uniqueItems,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/commonTypes/definitions/httpMethod!predicate"
        | doc "Supported HTTP methods."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "GET", "POST" ]
            ],
      "_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate"
        | doc "A JSON Path selecting one or more nodes of the parsed JSON document."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[$@](((\\.|\\.\\.)([$_a-zA-Z]+[$a-zA-Z0-9\\-_]*|\\*))|\\[\\*]|\\[[0-9]+((, [0-9]+)*|:[0-9]+)]|\\['[$_a-zA-Z]+[$a-zA-Z0-9\\-_]*'(, '[$_a-zA-Z]+[$a-zA-Z0-9\\-_]*')*]|\\[\\?\\(.+\\)])*$"
            ],
      "_js2n__-:definitions/commonTypes/definitions/name!predicate"
        | doc "A single JSON key name"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[$_a-zA-Z]+[$a-zA-Z0-9\\-_]*$"
            ],
      "_js2n__-:definitions/functionTypes/definitions/bigDecimalToBigDecimalFunctionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "absoluteValue",
                                  "add",
                                  "divide",
                                  "dividend",
                                  "epochMillisDateAdd",
                                  "multiply",
                                  "roundDecimal",
                                  "subtract",
                                  "subtractFrom"
                                ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "absoluteValue"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionAbsoluteValue!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "add"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionAdd!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "divide"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionDivide!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "dividend"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionDividend!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "epochMillisDateAdd"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionEpochMillisDateAdd!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "multiply"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionMultiply!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "roundDecimal"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionRoundDecimal!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "subtract"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionSubtract!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "subtractFrom"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionSubtractFrom!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionAbsoluteValue!predicate"
        | doc "Absolute value function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "absoluteValue"
                        ],
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionAdd!predicate"
        | doc "Decimal add function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "operand", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "add"
                        ],
                  operand = _js2n__-prdslib.isType '"Number",
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionChangeCase!predicate"
        | doc "Change case"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "to" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "changeCase"
                        ],
                  to =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "CAPITALIZED",
                              "UNCAPITALIZED",
                              "LOWER_CASE",
                              "UPPER_CASE"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionCloneKey!predicate"
        | doc "Clone key function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "name", "to" ],
              _js2n__-prdslib.records.record
                {
                  from =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/name!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "cloneKey"
                        ],
                  to =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/name!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionDivide!predicate"
        | doc "Decimal divide function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "operand", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "divide"
                        ],
                  operand = _js2n__-prdslib.isType '"Number",
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionDividend!predicate"
        | doc "Decimal dividend function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "operand", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "dividend"
                        ],
                  operand = _js2n__-prdslib.isType '"Number",
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionEpochMillisDateAdd!predicate"
        | doc "Epoch millis date add function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "amount", "name", "unit" ],
              _js2n__-prdslib.records.record
                {
                  amount = _js2n__-prdslib.isType 'Integer,
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "epochMillisDateAdd"
                        ],
                  unit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/chronoUnit!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionHttpResourceByUri!predicate"
        | doc "HTTP resource by URI function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 2,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  charset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/charSet!predicate",
                          _js2n__-prdslib.always
                        ],
                  httpHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/httpHeaders!predicate",
                          _js2n__-prdslib.always
                        ],
                  httpMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/httpMethod!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "httpResourceByUri"
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                  uriFunction =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/stringToStringFunctionType!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionJsonParse!predicate"
        | doc "JSON parse function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "jsonParse"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionMultiply!predicate"
        | doc "Decimal multiply function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "operand", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "multiply"
                        ],
                  operand = _js2n__-prdslib.isType '"Number",
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionRegex!predicate"
        | doc "RegEx replace function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "name", "pattern", "replacement" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "regex"
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                  replacement = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionReplace!predicate"
        | doc "Literal replace function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "find", "name", "replace" ],
              _js2n__-prdslib.records.record
                {
                  find = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "replace"
                        ],
                  replace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionRoundDecimal!predicate"
        | doc "Round decimal function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "roundDecimal"
                        ],
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionStringDateAdd!predicate"
        | doc "String date add function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "amount", "formatter", "name", "unit" ],
              _js2n__-prdslib.records.record
                {
                  amount = _js2n__-prdslib.isType 'Integer,
                  formatter = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "stringDateAdd"
                        ],
                  unit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/chronoUnit!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionSubtract!predicate"
        | doc "Decimal subtract function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "operand", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "subtract"
                        ],
                  operand = _js2n__-prdslib.isType '"Number",
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/functionSubtractFrom!predicate"
        | doc "Decimal subtract from function"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "operand", "scale" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "subtractFrom"
                        ],
                  operand = _js2n__-prdslib.isType '"Number",
                  scale = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTypes/definitions/stringObjectMapToStringObjectMapFunctionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "cloneKey" ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "cloneKey"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionCloneKey!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/functionTypes/definitions/stringToObjectFunctionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "changeCase",
                                  "httpResourceByUri",
                                  "jsonParse",
                                  "regex",
                                  "replace",
                                  "stringDateAdd"
                                ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "changeCase"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionChangeCase!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "httpResourceByUri"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionHttpResourceByUri!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "jsonParse"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionJsonParse!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "regex"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionRegex!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "replace"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionReplace!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "stringDateAdd"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionStringDateAdd!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/functionTypes/definitions/stringToStringFunctionType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "changeCase",
                                  "httpResourceByUri",
                                  "regex",
                                  "replace",
                                  "stringDateAdd"
                                ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "changeCase"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionChangeCase!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "httpResourceByUri"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionHttpResourceByUri!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "regex"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionRegex!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "replace"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionReplace!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "stringDateAdd"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/functionStringDateAdd!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "SpEL",
                                  "allMatch",
                                  "anyMatch",
                                  "anyString",
                                  "containsKey",
                                  "evalOn",
                                  "isNull",
                                  "noneMatch",
                                  "notNull",
                                  "regex"
                                ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "allMatch"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateAllMatch!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "anyMatch"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateAnyMatch!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "anyString"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateAnyString!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "containsKey"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateContainsKey!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "evalOn"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateEvalOn!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "isNull"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateIsNull!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "noneMatch"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateNoneMatch!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "notNull"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateNotNull!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "regex"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateRegex!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "SpEL"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/predicateSpEL!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateAllMatch!predicate"
        | doc "All Match predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "name" ],
              _js2n__-prdslib.records.record
                {
                  from =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "allMatch"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateAnyMatch!predicate"
        | doc "Any Match predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "name" ],
              _js2n__-prdslib.records.record
                {
                  from =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "anyMatch"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateAnyString!predicate"
        | doc "Any String predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "anyString"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateContainsKey!predicate"
        | doc "Contains key predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key", "name" ],
              _js2n__-prdslib.records.record
                {
                  key =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/name!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "containsKey"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateEvalOn!predicate"
        | doc "Eval on predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "childPath", "name", "predicate" ],
              _js2n__-prdslib.records.record
                {
                  childPath =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([$_a-zA-Z]+[$a-zA-Z0-9\\-_]+)(.[$_a-zA-Z]+[$a-zA-Z0-9\\-_]+)*$"
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "evalOn"
                        ],
                  predicate =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateIsNull!predicate"
        | doc "Is null predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "isNull"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateNoneMatch!predicate"
        | doc "None Match predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "from", "name" ],
              _js2n__-prdslib.records.record
                {
                  from =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "noneMatch"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateNotNull!predicate"
        | doc "Not null predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "notNull"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateRegex!predicate"
        | doc "RegEx predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "pattern" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "regex"
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/predicateTypes/definitions/predicateSpEL!predicate"
        | doc "SpEL predicate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "expression", "name" ],
              _js2n__-prdslib.records.record
                {
                  expression = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "SpEL"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/anyRuleType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name", "path" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "add",
                                  "calculate",
                                  "copy",
                                  "delete",
                                  "deleteFrom",
                                  "rename",
                                  "replace",
                                  "replaceMap",
                                  "validate"
                                ]
                            ],
                      params = _js2n__-prdslib.isType 'Record,
                      path =
                        _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                    } {} false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "add"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleAdd!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "calculate"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleCalculate!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "copy"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleCopy!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "delete"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleDelete!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "deleteFrom"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleDeleteFrom!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "rename"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleRename!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "replace"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleReplace!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "replaceMap"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleReplaceMap!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "validate"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/ruleTypes/definitions/ruleValidate!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleAdd!predicate"
        | doc "Add"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "add"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "key", "value" ],
                          _js2n__-prdslib.records.record
                            {
                              key =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              value =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleCalculate!predicate"
        | doc "Calculate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "calculate"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "numberFunction" ],
                          _js2n__-prdslib.records.record
                            {
                              numberFunction =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/bigDecimalToBigDecimalFunctionType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              predicate =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleCopy!predicate"
        | doc "Copy"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "copy"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "key", "to" ],
                          _js2n__-prdslib.records.record
                            {
                              key =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              to =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "value" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          value =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                                                  _js2n__-prdslib.always
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleDelete!predicate"
        | doc "Delete"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "delete"
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleDeleteFrom!predicate"
        | doc "Delete from"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "deleteFrom"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.maxProperties 5,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record
                            {
                              deleteKey =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              deleteValue =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              keepKey =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              keepValue =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              predicate =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleRename!predicate"
        | doc "Rename"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "rename"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "newKey", "oldKey" ],
                          _js2n__-prdslib.records.record
                            {
                              newKey =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              oldKey =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleReplace!predicate"
        | doc "Replace"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "replace"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "stringFunction" ],
                          _js2n__-prdslib.records.record
                            {
                              predicate =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              stringFunction =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/stringToStringFunctionType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleReplaceMap!predicate"
        | doc "Replace map"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "replaceMap"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "mapFunction" ],
                          _js2n__-prdslib.records.record
                            {
                              mapFunction =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/stringObjectMapToStringObjectMapFunctionType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                              predicate =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/predicateTypes/definitions/anyPredicateType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/jsonPath!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ruleTypes/definitions/ruleValidate!predicate"
        | doc "JSON Schema validate"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "params", "path" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "validate"
                        ],
                  params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "onFailure", "schema" ],
                          _js2n__-prdslib.records.record
                            {
                              onFailure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "transformation", "violation" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          transformation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "ABORT",
                                                      "SKIP_REST",
                                                      "CONTINUE"
                                                    ]
                                                ],
                                          violation =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "LOG_ONLY",
                                                      "COMMENT_JSON",
                                                      "IGNORE"
                                                    ]
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              schema =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                                      _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  path =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.required [ "name" ],
                  _js2n__-prdslib.records.record
                    {
                      name =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "converting",
                                  "epochMillisRelativeDate",
                                  "file",
                                  "httpResource",
                                  "jsonSchema",
                                  "relativeStringDate",
                                  "schemaStore",
                                  "staticBoolean",
                                  "staticDecimal",
                                  "staticInteger",
                                  "staticJson",
                                  "staticString"
                                ]
                            ],
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "converting"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierConverting!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "epochMillisRelativeDate"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierEpochMillisRelativeDate!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "file"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierFile!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "httpResource"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierHttpResource!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "jsonSchema"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierJsonSchema!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "relativeStringDate"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierRelativeStringDate!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "schemaStore"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierSchemaStore!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "staticBoolean"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierStaticBoolean!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "staticDecimal"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierStaticDecimal!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "staticInteger"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierStaticInteger!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "staticJson"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierStaticJson!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.ifThenElse
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        name =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.const "staticString"
                              ],
                      } {} true _js2n__-prdslib.always
                  ])
                _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/supplierStaticString!predicate"
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierConverting!predicate"
        | doc "Converting supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "converter", "name", "stringSource" ],
              _js2n__-prdslib.records.record
                {
                  converter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/functionTypes/definitions/stringToObjectFunctionType!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "converting"
                        ],
                  stringSource =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierEpochMillisRelativeDate!predicate"
        | doc "Epoch Millis Relative Date supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "amount", "name", "unit" ],
              _js2n__-prdslib.records.record
                {
                  amount = _js2n__-prdslib.isType 'Integer,
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "epochMillisRelativeDate"
                        ],
                  relativeTo = _js2n__-prdslib.isType 'Integer,
                  unit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/chronoUnit!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierFile!predicate"
        | doc "File content supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "path" ],
              _js2n__-prdslib.records.record
                {
                  charset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/charSet!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "file"
                        ],
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierHttpResource!predicate"
        | doc "HTTP resource content supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "uri" ],
              _js2n__-prdslib.records.record
                {
                  charset =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/charSet!predicate",
                          _js2n__-prdslib.always
                        ],
                  httpHeaders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/httpHeaders!predicate",
                          _js2n__-prdslib.always
                        ],
                  httpMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/httpMethod!predicate",
                          _js2n__-prdslib.always
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "httpResource"
                        ],
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierJsonSchema!predicate"
        | doc "JSON schema supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "source" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "jsonSchema"
                        ],
                  source =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/supplierTypes/definitions/anySupplierType!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierRelativeStringDate!predicate"
        | doc "Relative String Date supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "amount", "formatter", "name", "unit" ],
              _js2n__-prdslib.records.record
                {
                  amount = _js2n__-prdslib.isType 'Integer,
                  formatter = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "relativeStringDate"
                        ],
                  relativeTo = _js2n__-prdslib.isType '"String",
                  unit =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/commonTypes/definitions/chronoUnit!predicate",
                          _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierSchemaStore!predicate"
        | doc "SchemaStore schema supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "schemaName" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "schemaStore"
                        ],
                  schemaName = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierStaticBoolean!predicate"
        | doc "Static Boolean supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "staticBoolean"
                        ],
                  value = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierStaticDecimal!predicate"
        | doc "Static BigDecimal supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "staticDecimal"
                        ],
                  value = _js2n__-prdslib.isType '"Number",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierStaticInteger!predicate"
        | doc "Static BigInteger supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "staticInteger"
                        ],
                  value = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierStaticJson!predicate"
        | doc "Static JSON supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "staticJson"
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/supplierTypes/definitions/supplierStaticString!predicate"
        | doc "Static String supplier"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.const "staticString"
                        ],
                  value = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.records.required [ "actions" ],
          _js2n__-prdslib.records.record
            {
              actions =
                _js2n__-refsenv."_js2n__-:definitions/actionTypes/definitions/actions!predicate",
            } {} false _js2n__-prdslib.never
        ])