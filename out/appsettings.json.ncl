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
      "_js2n__-:definitions/ElmahIo!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "ApiKey", "LogId" ],
              _js2n__-prdslib.records.record
                {
                  ApiKey =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9a-f]{32})|(#\\{.*\\}#?)$"
                        ],
                  Application = _js2n__-prdslib.isType '"String",
                  HandledStatusCodesToLog =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType 'Integer)
                        ],
                  HeartbeatId =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9a-f]{32})|(#\\{.*\\}#?)$"
                        ],
                  LogId =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})|(#\\{.*\\}#?)$"
                        ],
                  TreatLoggingAsBreadcrumbs = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/NLog!predicate"
        | doc "NLog configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  autoReload = _js2n__-prdslib.isType '"Bool",
                  autoShutdown = _js2n__-prdslib.isType '"Bool",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    assembly = _js2n__-prdslib.isType '"String",
                                    assemblyFile =
                                      _js2n__-prdslib.isType '"String",
                                    prefix = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                  globalThreshold =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Trace",
                              "Debug",
                              "Info",
                              "Warn",
                              "Error",
                              "Fatal",
                              "Off"
                            ]
                        ],
                  internalLogFile = _js2n__-prdslib.isType '"String",
                  internalLogLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Trace",
                              "Debug",
                              "Info",
                              "Warn",
                              "Error",
                              "Fatal",
                              "Off"
                            ]
                        ],
                  internalLogToConsole = _js2n__-prdslib.isType '"Bool",
                  internalLogToConsoleError = _js2n__-prdslib.isType '"Bool",
                  rules =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/NLogRulesItem!predicate"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.propertyNames
                                (_js2n__-prdslib.strings.pattern "^[0-9]+$"),
                              _js2n__-prdslib.records.record {}
                                {
                                  ".*" =
                                    _js2n__-refsenv."_js2n__-:definitions/NLogRulesItem!predicate",
                                } true _js2n__-prdslib.always
                            ]
                        ],
                  targetDefaultWrapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "type" ],
                          _js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.isType '"String", } {} true
                            _js2n__-prdslib.always
                        ],
                  targets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { async = _js2n__-prdslib.isType '"Bool", } {} true
                            _js2n__-prdslib.always
                        ],
                  throwConfigExceptions =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Null
                        ],
                  throwExceptions = _js2n__-prdslib.isType '"Bool",
                  variables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.propertyNames
                            (_js2n__-prdslib.strings.pattern
                              "^[A-Za-z0-9_.-]+$"),
                          _js2n__-prdslib.records.record {}
                            {
                              ".*" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Bool"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/NLogRulesItem!predicate"
        | doc "Redirect LogEvents from matching Logger objects to specified targets"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "logger" ],
              _js2n__-prdslib.records.record
                {
                  enabled = _js2n__-prdslib.isType '"Bool",
                  filterDefaultAction =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Neutral",
                              "Log",
                              "Ignore",
                              "LogFinal",
                              "IgnoreFinal"
                            ]
                        ],
                  filters =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        action =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "Neutral",
                                                    "Log",
                                                    "Ignore",
                                                    "LogFinal",
                                                    "IgnoreFinal"
                                                  ]
                                              ],
                                        type = _js2n__-prdslib.isType '"String",
                                      } {} true _js2n__-prdslib.always
                                  ])
                            ],
                          _js2n__-prdslib.isType 'Record
                        ],
                  final = _js2n__-prdslib.isType '"Bool",
                  finalMinLevel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "Trace",
                                  "Debug",
                                  "Info",
                                  "Warn",
                                  "Error",
                                  "Fatal"
                                ]
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  level =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "Trace",
                                  "Debug",
                                  "Info",
                                  "Warn",
                                  "Error",
                                  "Fatal"
                                ]
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  levels = _js2n__-prdslib.isType '"String",
                  logger = _js2n__-prdslib.isType '"String",
                  maxLevel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "Trace",
                                  "Debug",
                                  "Info",
                                  "Warn",
                                  "Error",
                                  "Fatal"
                                ]
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  minLevel =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "Trace",
                                  "Debug",
                                  "Info",
                                  "Warn",
                                  "Error",
                                  "Fatal"
                                ]
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  ruleName = _js2n__-prdslib.isType '"String",
                  writeTo = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Serilog!predicate"
        | doc "Serilog appSettings Configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "$schema" = _js2n__-prdslib.isType '"String",
                  AuditTo =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReference!predicate",
                  Destructure =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReference!predicate",
                  Enrich =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReference!predicate",
                  Filter =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReference!predicate",
                  FilterSwitches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^(?<SerilogLevelSwitcherName>\\${0,1}[A-Za-z]+[A-Za-z0-9]*)$" =
                                _js2n__-prdslib.isType '"String",
                            } false _js2n__-prdslib.never
                        ],
                  LevelSwitches =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^(?<SerilogLevelSwitcherName>\\${0,1}[A-Za-z]+[A-Za-z0-9]*)$" =
                                _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/SerilogLogEventLevel!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  MinimumLevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Record
                            ],
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/SerilogLogEventLevel!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/DetailedMinimumLevel!predicate"
                            ]
                        ],
                  Properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  Using =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/AssemblyReference!predicate",
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  WriteTo =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReference!predicate",
                }
                {
                  "^AuditTo:((?<EnvironmentVariableName>[a-zA-Z_]\\w*)|(?<ArrayIndex>\\d*))$" =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate",
                  "^Destructure:((?<EnvironmentVariableName>[a-zA-Z_]\\w*)|(?<ArrayIndex>\\d*))$" =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate",
                  "^Enrich:((?<EnvironmentVariableName>[a-zA-Z_]\\w*)|(?<ArrayIndex>\\d*))$" =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate",
                  "^Filter:((?<EnvironmentVariableName>[a-zA-Z_]\\w*)|(?<ArrayIndex>\\d*))$" =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate",
                  "^WriteTo:((?<EnvironmentVariableName>[a-zA-Z_]\\w*)|(?<ArrayIndex>\\d*))$" =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Serilog/definitions/AssemblyReference!predicate"
        | doc ".NET Assembly Name, without the file extension"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.strings.pattern "^(?<AssemblyName>\\S+)$"
            ],
      "_js2n__-:definitions/Serilog/definitions/CSharpMethodName!predicate"
        | doc "A name referring to a C# Class method"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.strings.pattern
                "^(?<CSharpMethodName>[a-zA-Z_]\\w*)$"
            ],
      "_js2n__-:definitions/Serilog/definitions/ComplexMethodCallReference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "Name" ],
              _js2n__-prdslib.records.record
                {
                  Args =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^(?<CSharpMethodArgumentName>[a-zA-Z_]\\w*)$" =
                                _js2n__-prdslib.always,
                            } false _js2n__-prdslib.never
                        ],
                  Name =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/CSharpMethodName!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Serilog/definitions/DetailedMinimumLevel!predicate"
        | doc "Detailed Log level threshold object. Allowing set log levels be overridden per logging source."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ControlledBy =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/LoggingLevelSwitch!predicate",
                  Default =
                    _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/SerilogLogLevelThreshold!predicate",
                  Override =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/SerilogLogLevelThreshold!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Serilog/definitions/LoggingLevelSwitch!predicate"
        | doc "Log Level Switch string reference."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(?<SerilogLevelSwitcherName>\\${0,1}[A-Za-z]+[A-Za-z0-9]*)$"
            ],
      "_js2n__-:definitions/Serilog/definitions/MethodCallReference!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record
                ],
              _js2n__-prdslib.strings.minLength 1,
              _js2n__-prdslib.strings.pattern
                "^(?<CSharpMethodName>[a-zA-Z_]\\w*)$",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate",
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate"
            ],
      "_js2n__-:definitions/Serilog/definitions/MethodCallReferenceItem!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/CSharpMethodName!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/ComplexMethodCallReference!predicate"
                ]
            ],
      "_js2n__-:definitions/Serilog/definitions/SerilogLogEventLevel!predicate"
        | doc "Log level threshold."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Verbose",
                  "Debug",
                  "Information",
                  "Warning",
                  "Error",
                  "Fatal"
                ]
            ],
      "_js2n__-:definitions/Serilog/definitions/SerilogLogLevelThreshold!predicate"
        | doc "A Serilog Log Level or a reference to a Log Level Switch name on `LevelSwitches` configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.anyOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/SerilogLogEventLevel!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/Serilog/definitions/LoggingLevelSwitch!predicate"
                ]
            ],
      "_js2n__-:definitions/allowedHosts!predicate"
        | doc "ASP.NET Core host filtering middleware configuration. Allowed hosts is a semicolon-delimited list of host names without port numbers. Requests without a matching host name will be refused. Host names may be prefixed with a '*.' wildcard, or use '*' to allow all hosts."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/cdn!predicate"
        | doc "Definitions for WebEssentials.AspNetCore.CdnTagHelpers"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  prefetch = _js2n__-prdslib.isType '"Bool",
                  url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^((//|https?://).+|)$"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/certificate!predicate"
        | doc "Certificate configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  AllowInvalid = _js2n__-prdslib.isType '"Bool",
                  KeyPath = _js2n__-prdslib.isType '"String",
                  Location =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "LocalMachine", "CurrentUser" ]
                        ],
                  Password = _js2n__-prdslib.isType '"String",
                  Path = _js2n__-prdslib.isType '"String",
                  Store = _js2n__-prdslib.isType '"String",
                  Subject = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/clientCertificateMode!predicate"
        | doc "Specifies the client certificate requirements for a HTTPS connection. Defaults to 'NoCertificate'. Available in .NET 5 and later."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [ "NoCertificate", "AllowCertificate", "RequireCertificate" ]
            ],
      "_js2n__-:definitions/connectionStrings!predicate"
        | doc "Connection string configuration. Get connection strings with the IConfiguration.GetConnectionString(string) extension method."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/kestrel!predicate"
        | doc "ASP.NET Core Kestrel server configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Certificates =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/certificate!predicate"
                        ],
                  EndpointDefaults =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              ClientCertificateMode =
                                _js2n__-refsenv."_js2n__-:definitions/clientCertificateMode!predicate",
                              Protocols =
                                _js2n__-refsenv."_js2n__-:definitions/protocols!predicate",
                              SslProtocols =
                                _js2n__-refsenv."_js2n__-:definitions/sslProtocols!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                  Endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required [ "Url" ],
                                _js2n__-prdslib.records.record
                                  {
                                    Certificate =
                                      _js2n__-refsenv."_js2n__-:definitions/certificate!predicate",
                                    ClientCertificateMode =
                                      _js2n__-refsenv."_js2n__-:definitions/clientCertificateMode!predicate",
                                    Protocols =
                                      _js2n__-refsenv."_js2n__-:definitions/protocols!predicate",
                                    Sni =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true
                                              (_js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      Certificate =
                                                        _js2n__-refsenv."_js2n__-:definitions/certificate!predicate",
                                                      ClientCertificateMode =
                                                        _js2n__-refsenv."_js2n__-:definitions/clientCertificateMode!predicate",
                                                      Protocols =
                                                        _js2n__-refsenv."_js2n__-:definitions/protocols!predicate",
                                                      SslProtocols =
                                                        _js2n__-refsenv."_js2n__-:definitions/sslProtocols!predicate",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ])
                                          ],
                                    SslProtocols =
                                      _js2n__-refsenv."_js2n__-:definitions/sslProtocols!predicate",
                                    Url = _js2n__-prdslib.isType '"String",
                                  } {} true _js2n__-prdslib.always
                              ])
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/logLevel!predicate"
        | doc "Log level configurations used when creating logs. Only logs that exceeds its matching log level will be enabled. Each log level configuration has a category specified by its JSON property name. For more information about configuring log levels, see https://docs.microsoft.com/aspnet/core/fundamentals/logging/#configure-logging."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/logLevelThreshold!predicate"
            ],
      "_js2n__-:definitions/logLevelThreshold!predicate"
        | doc "Log level threshold."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Trace",
                  "Debug",
                  "Information",
                  "Warning",
                  "Error",
                  "Critical",
                  "None"
                ]
            ],
      "_js2n__-:definitions/logging!predicate"
        | doc "Configuration for Microsoft.Extensions.Logging."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  Console =
                    _js2n__-prdslib.records.record
                        {
                          FormatterName = _js2n__-prdslib.isType '"String",
                          FormatterOptions =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      IncludeScopes =
                                        _js2n__-prdslib.isType '"Bool",
                                      TimestampFormat =
                                        _js2n__-prdslib.isType '"String",
                                      UseUtcTimestamp =
                                        _js2n__-prdslib.isType '"Bool",
                                    } {} true _js2n__-prdslib.always
                                ],
                          LogLevel =
                            _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                          LogToStandardErrorThreshold =
                            _js2n__-refsenv."_js2n__-:definitions/logLevelThreshold!predicate",
                        } {} true _js2n__-prdslib.always,
                  Debug =
                    _js2n__-prdslib.records.record
                        {
                          LogLevel =
                            _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                        } {} true _js2n__-prdslib.always,
                  ElmahIo =
                    _js2n__-prdslib.records.record
                        {
                          LogLevel =
                            _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                        } {} true _js2n__-prdslib.always,
                  ElmahIoBreadcrumbs =
                    _js2n__-prdslib.records.record
                        {
                          LogLevel =
                            _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                        } {} true _js2n__-prdslib.always,
                  EventLog =
                    _js2n__-prdslib.records.record
                        {
                          LogLevel =
                            _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                        } {} true _js2n__-prdslib.always,
                  EventSource =
                    _js2n__-prdslib.records.record
                        {
                          LogLevel =
                            _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                        } {} true _js2n__-prdslib.always,
                  LogLevel =
                    _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                } {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        LogLevel =
                          _js2n__-refsenv."_js2n__-:definitions/logLevel!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/protocols!predicate"
        | doc "The protocols enabled on the endpoint."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "None",
                  "Http1",
                  "Http2",
                  "Http1AndHttp2",
                  "Http3",
                  "Http1AndHttp2AndHttp3"
                ]
            ],
      "_js2n__-:definitions/pwa!predicate" =
        _js2n__-prdslib.records.record
            {
              cacheId = _js2n__-prdslib.isType '"String",
              offlineRoute = _js2n__-prdslib.isType '"String",
              registerServiceWorker = _js2n__-prdslib.isType '"Bool",
              registerWebmanifest = _js2n__-prdslib.isType '"Bool",
              routesToPreCache = _js2n__-prdslib.isType '"String",
              strategy =
                _js2n__-prdslib.enum
                    [
                      "cacheFirst",
                      "cacheFirstSafe",
                      "minimal",
                      "networkFirst"
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/sslProtocols!predicate"
        | doc "Specifies allowable SSL protocols. Defaults to 'None' which allows the operating system to choose the best protocol to use, and to block protocols that are not secure. Unless your app has a specific reason not to, you should use this default. Available in .NET 5 and later."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [ "None", "Tls", "Tls11", "Tls12", "Tls13" ]
                  ])
            ],
      "_js2n__-:definitions/webOptimizer!predicate"
        | doc "Settings for WebOptimizer.Core"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  enableCaching = _js2n__-prdslib.isType '"Bool",
                  enableTagHelperBundling = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              AllowedHosts =
                _js2n__-refsenv."_js2n__-:definitions/allowedHosts!predicate",
              ConnectionStrings =
                _js2n__-refsenv."_js2n__-:definitions/connectionStrings!predicate",
              Kestrel =
                _js2n__-refsenv."_js2n__-:definitions/kestrel!predicate",
              Logging =
                _js2n__-refsenv."_js2n__-:definitions/logging!predicate",
            }
            {
              "^(ElmahIo|Elmahio|elmahIo|elmahio)$" =
                _js2n__-refsenv."_js2n__-:definitions/ElmahIo!predicate",
              "^(Serilog|serilog)$" =
                _js2n__-refsenv."_js2n__-:definitions/Serilog!predicate",
              "^(cdn|Cdn)$" =
                _js2n__-refsenv."_js2n__-:definitions/cdn!predicate",
              "^(nlog|Nlog|NLog)$" =
                _js2n__-refsenv."_js2n__-:definitions/NLog!predicate",
              "^(pwa|PWA|Pwa)$" =
                _js2n__-refsenv."_js2n__-:definitions/pwa!predicate",
              "^WebOptimizer$" =
                _js2n__-refsenv."_js2n__-:definitions/webOptimizer!predicate",
              "^webOptimizer$" =
                _js2n__-refsenv."_js2n__-:definitions/webOptimizer!predicate",
              "^weboptimizer$" =
                _js2n__-refsenv."_js2n__-:definitions/webOptimizer!predicate",
            } true _js2n__-prdslib.always
        ])