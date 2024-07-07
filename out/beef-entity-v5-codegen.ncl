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
      "_js2n__-:definitions/CodeGeneration!predicate"
        | doc "The `CodeGeneration` object defines global properties that are used to drive the underlying entity-driven code generation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  autoImplement =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Database",
                              "EntityFramework",
                              "Cosmos",
                              "OData",
                              "HttpAgent",
                              "None"
                            ]
                        ],
                  cosmosName = _js2n__-prdslib.isType '"String",
                  databaseMapperEx = _js2n__-prdslib.isType '"Bool",
                  databaseName = _js2n__-prdslib.isType '"String",
                  databaseProvider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "SqlServer", "MySQL", "Postgres" ]
                        ],
                  databaseSchema = _js2n__-prdslib.isType '"String",
                  entities =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Entity!predicate"
                        ],
                  entityFrameworkName = _js2n__-prdslib.isType '"String",
                  etagDefaultMapperConverter = _js2n__-prdslib.isType '"String",
                  etagJsonName =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "etag", "eTag", "_etag", "_eTag", "ETag", "ETAG" ]
                        ],
                  eventActionFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "None", "PastTense" ]
                        ],
                  eventPublish =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "None", "DataSvc", "Data" ]
                        ],
                  eventSourceKind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "None",
                              "Absolute",
                              "Relative",
                              "RelativeOrAbsolute"
                            ]
                        ],
                  eventSourceRoot = _js2n__-prdslib.isType '"String",
                  eventSubjectRoot = _js2n__-prdslib.isType '"String",
                  eventSubjectSeparator = _js2n__-prdslib.isType '"String",
                  eventTransaction = _js2n__-prdslib.isType '"Bool",
                  grpc = _js2n__-prdslib.isType '"Bool",
                  httpAgentName = _js2n__-prdslib.isType '"String",
                  jsonSerializer =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SystemText", "Newtonsoft" ]
                        ],
                  managerCleanUp = _js2n__-prdslib.isType '"Bool",
                  namespaceApi = _js2n__-prdslib.isType '"String",
                  namespaceBase = _js2n__-prdslib.isType '"String",
                  namespaceBusiness = _js2n__-prdslib.isType '"String",
                  namespaceCommon = _js2n__-prdslib.isType '"String",
                  odataName = _js2n__-prdslib.isType '"String",
                  pathApi = _js2n__-prdslib.isType '"String",
                  pathBase = _js2n__-prdslib.isType '"String",
                  pathBusiness = _js2n__-prdslib.isType '"String",
                  pathCommon = _js2n__-prdslib.isType '"String",
                  preprocessorDirectives = _js2n__-prdslib.isType '"Bool",
                  refDataCodeDataName = _js2n__-prdslib.isType '"String",
                  refDataCommonNamespace = _js2n__-prdslib.isType '"String",
                  refDataDataCtorParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  refDataDefaultMapperConverter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "ReferenceDataCodeConverter",
                              "ReferenceDataCodeConverter{T}",
                              "ReferenceDataCodeConverter<T>",
                              "ReferenceDataIdConverter{T, int}",
                              "ReferenceDataIdConverter<T, int>",
                              "ReferenceDataIdConverter{T, int?}",
                              "ReferenceDataIdConverter<T, int?>",
                              "ReferenceDataIdConverter{T, long}",
                              "ReferenceDataIdConverter<T, long>",
                              "ReferenceDataIdConverter{T, long?}",
                              "ReferenceDataIdConverter<T, long?>",
                              "ReferenceDataIdConverter{T, Guid}",
                              "ReferenceDataIdConverter<T, Guid>",
                              "ReferenceDataIdConverter{T, Guid?}",
                              "ReferenceDataIdConverter<T, Guid?>",
                              "ReferenceDataInt32IdConverter",
                              "ReferenceDataInt32IdConverter{T}",
                              "ReferenceDataInt32IdConverter<T>",
                              "ReferenceDataNullableInt32IdConverter",
                              "ReferenceDataNullableInt32IdConverter{T}",
                              "ReferenceDataNullableInt32IdConverter<T>",
                              "ReferenceDataInt64IdConverter",
                              "ReferenceDataInt64IdConverter{T}",
                              "ReferenceDataInt64IdConverter<T>",
                              "ReferenceDataNullableInt64IdConverter",
                              "ReferenceDataNullableInt64IdConverter{T}",
                              "ReferenceDataNullableInt64IdConverter<T>",
                              "ReferenceDataGuidIdConverter",
                              "ReferenceDataGuidIdConverter{T}",
                              "ReferenceDataGuidIdConverter<T>",
                              "ReferenceDataNullableGuidIdConverter",
                              "ReferenceDataNullableGuidIdConverter{T}",
                              "ReferenceDataNullableGuidIdConverter<T>"
                            ]
                        ],
                  refDataETagDataName = _js2n__-prdslib.isType '"String",
                  refDataIsActiveDataName = _js2n__-prdslib.isType '"String",
                  refDataNamespace = _js2n__-prdslib.isType '"String",
                  refDataSortOrderDataName = _js2n__-prdslib.isType '"String",
                  refDataText = _js2n__-prdslib.isType '"Bool",
                  refDataTextDataName = _js2n__-prdslib.isType '"String",
                  refDataType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "int", "long", "Guid", "string" ]
                        ],
                  refDataWebApiRoute = _js2n__-prdslib.isType '"String",
                  usingNamespace1 = _js2n__-prdslib.isType '"String",
                  usingNamespace2 = _js2n__-prdslib.isType '"String",
                  usingNamespace3 = _js2n__-prdslib.isType '"String",
                  validationFramework =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "CoreEx", "FluentValidation" ]
                        ],
                  webApiAuthorize = _js2n__-prdslib.isType '"String",
                  webApiAutoLocation = _js2n__-prdslib.isType '"Bool",
                  webApiRoutePrefix = _js2n__-prdslib.isType '"String",
                  webApiTags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  withResult = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Const!predicate"
        | doc "The `Const` object is used to define a .NET (C#) constant value for an `Entity`."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "value" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  value = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Entity!predicate"
        | doc "The `Entity` is used as the primary configuration for driving the entity-driven code generation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  abstract = _js2n__-prdslib.isType '"Bool",
                  argumentName = _js2n__-prdslib.isType '"String",
                  authRole = _js2n__-prdslib.isType '"String",
                  autoImplement =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Database",
                              "EntityFramework",
                              "Cosmos",
                              "OData",
                              "HttpAgent",
                              "None"
                            ]
                        ],
                  behavior = _js2n__-prdslib.isType '"String",
                  collection = _js2n__-prdslib.isType '"Bool",
                  collectionInherits = _js2n__-prdslib.isType '"String",
                  collectionResult = _js2n__-prdslib.isType '"Bool",
                  collectionResultInherits = _js2n__-prdslib.isType '"String",
                  collectionType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Standard", "Keyed", "Dictionary" ]
                        ],
                  constType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "int", "long", "Guid", "string" ]
                        ],
                  consts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Const!predicate"
                        ],
                  cosmosContainerId = _js2n__-prdslib.isType '"String",
                  cosmosCustomMapper = _js2n__-prdslib.isType '"Bool",
                  cosmosMapperBase = _js2n__-prdslib.isType '"String",
                  cosmosModel = _js2n__-prdslib.isType '"String",
                  cosmosName = _js2n__-prdslib.isType '"String",
                  cosmosPartitionKey = _js2n__-prdslib.isType '"String",
                  cosmosValueContainer = _js2n__-prdslib.isType '"Bool",
                  create = _js2n__-prdslib.isType '"Bool",
                  dataCtor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Public", "Private", "Protected" ]
                        ],
                  dataCtorParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dataExtensions = _js2n__-prdslib.isType '"Bool",
                  dataModel = _js2n__-prdslib.isType '"Bool",
                  dataModelInherits = _js2n__-prdslib.isType '"String",
                  dataSvcCaching = _js2n__-prdslib.isType '"Bool",
                  dataSvcCtor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Public", "Private", "Protected" ]
                        ],
                  dataSvcCtorParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  dataSvcExtensions = _js2n__-prdslib.isType '"Bool",
                  databaseCustomerMapper = _js2n__-prdslib.isType '"Bool",
                  databaseMapperEx = _js2n__-prdslib.isType '"Bool",
                  databaseMapperInheritsFrom = _js2n__-prdslib.isType '"String",
                  databaseName = _js2n__-prdslib.isType '"String",
                  databaseSchema = _js2n__-prdslib.isType '"String",
                  delete = _js2n__-prdslib.isType '"Bool",
                  entityFrameworkCustomMapper = _js2n__-prdslib.isType '"Bool",
                  entityFrameworkMapperBase = _js2n__-prdslib.isType '"String",
                  entityFrameworkModel = _js2n__-prdslib.isType '"String",
                  entityFrameworkName = _js2n__-prdslib.isType '"String",
                  eventPublish =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "None", "DataSvc", "Data" ]
                        ],
                  eventSource = _js2n__-prdslib.isType '"String",
                  eventTransaction = _js2n__-prdslib.isType '"Bool",
                  excludeAll = _js2n__-prdslib.isType '"Bool",
                  excludeData =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Include", "Exclude", "RequiresMapper" ]
                        ],
                  excludeDataSvc = _js2n__-prdslib.isType '"Bool",
                  excludeEntity = _js2n__-prdslib.isType '"Bool",
                  excludeGrpcAgent = _js2n__-prdslib.isType '"Bool",
                  excludeIData = _js2n__-prdslib.isType '"Bool",
                  excludeIDataSvc = _js2n__-prdslib.isType '"Bool",
                  excludeIManager = _js2n__-prdslib.isType '"Bool",
                  excludeManager = _js2n__-prdslib.isType '"Bool",
                  excludeWebApi = _js2n__-prdslib.isType '"Bool",
                  excludeWebApiAgent = _js2n__-prdslib.isType '"Bool",
                  fileName = _js2n__-prdslib.isType '"String",
                  genericWithT = _js2n__-prdslib.isType '"Bool",
                  get = _js2n__-prdslib.isType '"Bool",
                  getAll = _js2n__-prdslib.isType '"Bool",
                  getByArgs = _js2n__-prdslib.isType '"Bool",
                  grpc = _js2n__-prdslib.isType '"Bool",
                  httpAgentCode = _js2n__-prdslib.isType '"String",
                  httpAgentCustomMapper = _js2n__-prdslib.isType '"Bool",
                  httpAgentMapperBase = _js2n__-prdslib.isType '"String",
                  httpAgentModel = _js2n__-prdslib.isType '"String",
                  httpAgentName = _js2n__-prdslib.isType '"String",
                  httpAgentReturnModel = _js2n__-prdslib.isType '"String",
                  httpAgentRoutePrefix = _js2n__-prdslib.isType '"String",
                  identifierGenerator = _js2n__-prdslib.isType '"Bool",
                  implements = _js2n__-prdslib.isType '"String",
                  implementsAutoInfer = _js2n__-prdslib.isType '"Bool",
                  inherits = _js2n__-prdslib.isType '"String",
                  internalOnly = _js2n__-prdslib.isType '"Bool",
                  isInitialOverride = _js2n__-prdslib.isType '"Bool",
                  jsonSerializer =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "SystemText", "Newtonsoft" ]
                        ],
                  managerCleanUp = _js2n__-prdslib.isType '"Bool",
                  managerCtor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Public", "Private", "Protected" ]
                        ],
                  managerCtorParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  managerExtensions = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  namespace = _js2n__-prdslib.isType '"String",
                  odataCollectionName = _js2n__-prdslib.isType '"String",
                  odataCustomMapper = _js2n__-prdslib.isType '"Bool",
                  odataModel = _js2n__-prdslib.isType '"String",
                  odataName = _js2n__-prdslib.isType '"String",
                  omitEntityBase = _js2n__-prdslib.isType '"Bool",
                  operations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Operation!predicate"
                        ],
                  patch = _js2n__-prdslib.isType '"Bool",
                  privateName = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Property!predicate"
                        ],
                  refDataCodeDataName = _js2n__-prdslib.isType '"String",
                  refDataETagDataName = _js2n__-prdslib.isType '"String",
                  refDataIdDataName = _js2n__-prdslib.isType '"String",
                  refDataIsActiveDataName = _js2n__-prdslib.isType '"String",
                  refDataSortOrder =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "SortOrder", "Id", "Code", "Text" ]
                        ],
                  refDataSortOrderDataName = _js2n__-prdslib.isType '"String",
                  refDataStoredProcedureName = _js2n__-prdslib.isType '"String",
                  refDataText = _js2n__-prdslib.isType '"Bool",
                  refDataTextDataName = _js2n__-prdslib.isType '"String",
                  refDataType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "int", "long", "Guid", "string" ]
                        ],
                  text = _js2n__-prdslib.isType '"String",
                  update = _js2n__-prdslib.isType '"Bool",
                  validationFramework =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "CoreEx", "FluentValidation" ]
                        ],
                  validator = _js2n__-prdslib.isType '"String",
                  webApiAuthorize = _js2n__-prdslib.isType '"String",
                  webApiAutoLocation = _js2n__-prdslib.isType '"Bool",
                  webApiConcurrency = _js2n__-prdslib.isType '"Bool",
                  webApiCtor =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Public", "Private", "Protected" ]
                        ],
                  webApiCtorParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  webApiGetOperation = _js2n__-prdslib.isType '"String",
                  webApiRoutePrefix = _js2n__-prdslib.isType '"String",
                  webApiTags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  withResult = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Operation!predicate"
        | doc "The code generation for an `Operation` is primarily driven by the `Type` property. This encourages (enforces) a consistent implementation for the standardised **CRUD** (Create, Read, Update and Delete) actions, as well as supporting fully customised operations as required."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  authPermission = _js2n__-prdslib.isType '"String",
                  authRole = _js2n__-prdslib.isType '"String",
                  autoImplement =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Database",
                              "EntityFramework",
                              "Cosmos",
                              "OData",
                              "HttpAgent",
                              "None"
                            ]
                        ],
                  cosmosContainerId = _js2n__-prdslib.isType '"String",
                  cosmosModel = _js2n__-prdslib.isType '"String",
                  cosmosPartitionKey = _js2n__-prdslib.isType '"String",
                  dataEntityMapper = _js2n__-prdslib.isType '"String",
                  dataExtensions = _js2n__-prdslib.isType '"Bool",
                  dataInvoker = _js2n__-prdslib.isType '"Bool",
                  dataSvcCustom = _js2n__-prdslib.isType '"Bool",
                  dataSvcExtensions = _js2n__-prdslib.isType '"Bool",
                  dataSvcInvoker = _js2n__-prdslib.isType '"Bool",
                  dataSvcTransaction = _js2n__-prdslib.isType '"Bool",
                  dataTransaction = _js2n__-prdslib.isType '"Bool",
                  databaseStoredProc = _js2n__-prdslib.isType '"String",
                  entityFrameworkModel = _js2n__-prdslib.isType '"String",
                  eventPublish =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "None", "DataSvc", "Data" ]
                        ],
                  eventSource = _js2n__-prdslib.isType '"String",
                  eventSubject = _js2n__-prdslib.isType '"String",
                  excludeAll = _js2n__-prdslib.isType '"Bool",
                  excludeData = _js2n__-prdslib.isType '"Bool",
                  excludeDataSvc = _js2n__-prdslib.isType '"Bool",
                  excludeGrpcAgent = _js2n__-prdslib.isType '"Bool",
                  excludeIData = _js2n__-prdslib.isType '"Bool",
                  excludeIDataSvc = _js2n__-prdslib.isType '"Bool",
                  excludeIManager = _js2n__-prdslib.isType '"Bool",
                  excludeManager = _js2n__-prdslib.isType '"Bool",
                  excludeWebApi = _js2n__-prdslib.isType '"Bool",
                  excludeWebApiAgent = _js2n__-prdslib.isType '"Bool",
                  grpc = _js2n__-prdslib.isType '"Bool",
                  httpAgentCode = _js2n__-prdslib.isType '"String",
                  httpAgentMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "HttpGet",
                              "HttpPost",
                              "HttpPut",
                              "HttpDelete",
                              "HttpPatch"
                            ]
                        ],
                  httpAgentModel = _js2n__-prdslib.isType '"String",
                  httpAgentReturnModel = _js2n__-prdslib.isType '"String",
                  httpAgentRoute = _js2n__-prdslib.isType '"String",
                  managerCleanUp = _js2n__-prdslib.isType '"Bool",
                  managerCustom = _js2n__-prdslib.isType '"Bool",
                  managerExtensions = _js2n__-prdslib.isType '"Bool",
                  managerOperationType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Create",
                              "Read",
                              "Update",
                              "Delete",
                              "Unspecified"
                            ]
                        ],
                  managerTransaction = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  odataCollectionName = _js2n__-prdslib.isType '"String",
                  paging = _js2n__-prdslib.isType '"Bool",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Parameter!predicate"
                        ],
                  primaryKey = _js2n__-prdslib.isType '"Bool",
                  privateName = _js2n__-prdslib.isType '"String",
                  returnText = _js2n__-prdslib.isType '"String",
                  returnType = _js2n__-prdslib.isType '"String",
                  returnTypeNullable = _js2n__-prdslib.isType '"Bool",
                  text = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Get",
                              "GetColl",
                              "Create",
                              "Update",
                              "Patch",
                              "Delete",
                              "Custom",
                              "CustomManagerOnly"
                            ]
                        ],
                  validationFramework =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "CoreEx", "FluentValidation" ]
                        ],
                  validator = _js2n__-prdslib.isType '"String",
                  valueType = _js2n__-prdslib.isType '"String",
                  webApiAlternateStatus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "OK",
                              "Accepted",
                              "Created",
                              "NoContent",
                              "NotFound",
                              "none"
                            ]
                        ],
                  webApiAuthorize = _js2n__-prdslib.isType '"String",
                  webApiConcurrency = _js2n__-prdslib.isType '"Bool",
                  webApiGetOperation = _js2n__-prdslib.isType '"String",
                  webApiLocation = _js2n__-prdslib.isType '"String",
                  webApiMethod =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "HttpGet", "HttpPost", "HttpPut", "HttpDelete" ]
                        ],
                  webApiProduces =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  webApiProducesResponseType = _js2n__-prdslib.isType '"String",
                  webApiRoute = _js2n__-prdslib.isType '"String",
                  webApiStatus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "OK",
                              "Accepted",
                              "Created",
                              "NoContent",
                              "NotFound"
                            ]
                        ],
                  webApiTags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  webApiUpdateOperation = _js2n__-prdslib.isType '"String",
                  withResult = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Parameter!predicate"
        | doc "The `Parameter` object defines an `Operation` parameter and its charateristics."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  argumentName = _js2n__-prdslib.isType '"String",
                  dataConverter = _js2n__-prdslib.isType '"String",
                  "default" = _js2n__-prdslib.isType '"String",
                  grpcType = _js2n__-prdslib.isType '"String",
                  isMandatory = _js2n__-prdslib.isType '"Bool",
                  layerPassing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "All", "ToManagerSet", "ToManagerCollSet" ]
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  nullable = _js2n__-prdslib.isType '"Bool",
                  privateName = _js2n__-prdslib.isType '"String",
                  property = _js2n__-prdslib.isType '"String",
                  refDataList = _js2n__-prdslib.isType '"Bool",
                  refDataType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "string", "int", "Guid" ]
                        ],
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                  validationFramework =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "CoreEx", "FluentValidation" ]
                        ],
                  validator = _js2n__-prdslib.isType '"String",
                  validatorCode = _js2n__-prdslib.isType '"String",
                  webApiFrom =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "FromQuery",
                              "FromBody",
                              "FromRoute",
                              "FromEntityProperties"
                            ]
                        ],
                  webApiText = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Property!predicate"
        | doc "The `Property` object defines an `Entity` property and its charateristics."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  annotation1 = _js2n__-prdslib.isType '"String",
                  annotation2 = _js2n__-prdslib.isType '"String",
                  annotation3 = _js2n__-prdslib.isType '"String",
                  argumentName = _js2n__-prdslib.isType '"String",
                  autoCreate = _js2n__-prdslib.isType '"Bool",
                  cosmosMapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Set", "Ignore", "Map", "Flatten" ]
                        ],
                  dataAutoGenerated = _js2n__-prdslib.isType '"Bool",
                  dataConverter = _js2n__-prdslib.isType '"String",
                  dataMapperIgnore = _js2n__-prdslib.isType '"Bool",
                  dataModelIgnore = _js2n__-prdslib.isType '"Bool",
                  dataModelSerializationIgnore = _js2n__-prdslib.isType '"Bool",
                  dataName = _js2n__-prdslib.isType '"String",
                  dataOperationTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "Any",
                              "AnyExceptCreate",
                              "AnyExceptUpdate",
                              "AnyExceptGet",
                              "Get",
                              "Create",
                              "Update",
                              "Delete"
                            ]
                        ],
                  databaseDbType = _js2n__-prdslib.isType '"String",
                  databaseIgnore = _js2n__-prdslib.isType '"Bool",
                  databaseMapper = _js2n__-prdslib.isType '"String",
                  dateTimeTransform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "UseDefault",
                              "None",
                              "DateOnly",
                              "DateTimeLocal",
                              "DateTimeUtc",
                              "DateTimeUnspecified"
                            ]
                        ],
                  "default" = _js2n__-prdslib.isType '"String",
                  displayName = _js2n__-prdslib.isType '"String",
                  entityFrameworkMapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Set", "Ignore", "Map", "Flatten" ]
                        ],
                  grpcFieldNo = _js2n__-prdslib.isType 'Integer,
                  grpcType = _js2n__-prdslib.isType '"String",
                  httpAgentMapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Set", "Ignore", "Map", "Flatten" ]
                        ],
                  immutable = _js2n__-prdslib.isType '"Bool",
                  inherited = _js2n__-prdslib.isType '"Bool",
                  internalOnly = _js2n__-prdslib.isType '"Bool",
                  isEntity = _js2n__-prdslib.isType '"Bool",
                  jsonDataModelName = _js2n__-prdslib.isType '"String",
                  jsonName = _js2n__-prdslib.isType '"String",
                  modelText = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  nullable = _js2n__-prdslib.isType '"Bool",
                  odataMapper =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Map", "Ignore", "Skip" ]
                        ],
                  partitionKey = _js2n__-prdslib.isType '"Bool",
                  primaryKey = _js2n__-prdslib.isType '"Bool",
                  privateName = _js2n__-prdslib.isType '"String",
                  refDataList = _js2n__-prdslib.isType '"Bool",
                  refDataMapping = _js2n__-prdslib.isType '"Bool",
                  refDataText =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Optional", "Always", "Never" ]
                        ],
                  refDataTextName = _js2n__-prdslib.isType '"String",
                  refDataType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "string", "int", "Guid" ]
                        ],
                  serializationAlwaysInclude = _js2n__-prdslib.isType '"Bool",
                  serializationIgnore = _js2n__-prdslib.isType '"Bool",
                  stringCasing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "UseDefault", "None", "Lower", "Upper", "Title" ]
                        ],
                  stringTransform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "UseDefault",
                              "None",
                              "NullToEmpty",
                              "EmptyToNull"
                            ]
                        ],
                  stringTrim =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "UseDefault", "None", "Start", "End", "Both" ]
                        ],
                  text = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      _js2n__-refsenv."_js2n__-:definitions/CodeGeneration!predicate"