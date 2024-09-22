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
      "$schema" | String | optional,
      __experimental
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool"
            ])
        | doc "The name of the experiment this block is a part of, or boolean true if there is no specific experiment name."
        | optional,
      allowedBlocks
        | Array (String)
        | doc "The `allowedBlocks` property specifies that only the listed block types can be the children of this block. For example, a ‘List’ block allows only ‘List Item’ blocks as direct children."
        | optional,
      ancestor
        | Array (String)
        | doc "The `ancestor` property makes a block available inside the specified block types at any position of the ancestor block subtree. That allows, for example, to place a ‘Comment Content’ block inside a ‘Column’ block, as long as ‘Column’ is somewhere within a ‘Comment Template’ block."
        | optional,
      apiVersion
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.enum [ 1, 2, 3 ]
            ])
        | doc m%"
          The version of the Block API used by the block. The most recent version is 3 and it was introduced in WordPress 6.3.
          
           See the API versions documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-api-versions/ for more details.
        "%
        | optional,
      attributes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "[a-zA-Z]" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ],
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "enum" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ]
                            ],
                          _js2n__-prdslib.records.record
                            {
                              attribute = _js2n__-prdslib.isType '"String",
                              "default" = _js2n__-prdslib.always,
                              enum =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"Bool",
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.isType '"String"
                                          ])
                                    ],
                              meta = _js2n__-prdslib.isType '"String",
                              query = _js2n__-prdslib.isType 'Record,
                              selector = _js2n__-prdslib.isType '"String",
                              source =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "attribute",
                                          "text",
                                          "rich-text",
                                          "html",
                                          "raw",
                                          "query",
                                          "meta"
                                        ]
                                    ],
                              type =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [
                                              "null",
                                              "boolean",
                                              "object",
                                              "array",
                                              "string",
                                              "rich-text",
                                              "integer",
                                              "number"
                                            ]
                                        ],
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
                                                    "null",
                                                    "boolean",
                                                    "object",
                                                    "array",
                                                    "string",
                                                    "integer",
                                                    "number"
                                                  ]
                                              ]),
                                          _js2n__-prdslib.arrays.uniqueItems
                                        ]
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } false _js2n__-prdslib.never
            ])
        | doc m%"
          Attributes provide the structured data needs of a block. They can exist in different forms when they are serialized, but they are declared together under a common interface.
          
          See the attributes documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-attributes/ for more details.
        "%
        | optional,
      blockHooks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "before", "after", "firstChild", "lastChild" ]
                        ],
                } false _js2n__-prdslib.never
            ])
        | doc m%"
          Block Hooks allow a block to automatically insert itself next to all instances of a given block type.
          
          See the Block Hooks documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-registration/#block-hooks-optional for more details.
        "%
        | optional,
      category
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [ "text", "media", "design", "widgets", "theme", "embed" ]
                ]
            ])
        | doc m%"
          Blocks are grouped into categories to help users browse and discover them.
           Core provided categories are: text, media, design, widgets, theme, embed
          
          Plugins and Themes can also register custom block categories.
          
          https://developer.wordpress.org/block-editor/reference-guides/filters/block-filters/#managing-block-categories
        "%
        | optional,
      description
        | String
        | doc "This is a short description for your block, which can be translated with our translation functions. This will be shown in the block inspector."
        | optional,
      editorScript
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type editor script definition. It will only be enqueued in the context of the editor."
        | optional,
      editorStyle
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type editor style definition. It will only be enqueued in the context of the editor."
        | optional,
      example
        | {
          attributes
            | {  .. }
            | doc "Set the attributes for the block example"
            | optional,
          innerBlocks
            | Array Dyn
            | doc m%"
              Set the inner blocks that should be used within the block example. The blocks should be defined as a nested array like this:
              
              [ { "name": "core/heading", "attributes": { "content": "This is an Example" } } ]
              
              Where each block itself is an object that contains the block name, the block attributes, and the blocks inner blocks.
            "%
            | optional,
          viewportWidth
            | Number
            | doc "The viewportWidth controls the width of the iFrame container in which the block preview will get rendered"
            | optional,
          ..
        }
        | doc m%"
          It provides structured example data for the block. This data is used to construct a preview for the block to be shown in the Inspector Help Panel when the user mouses over the block.
          
          See the example documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-registration/#example-optional for more details.
        "%
        | optional,
      icon
        | String
        | doc "An icon property should be specified to make it easier to identify a block. These can be any of WordPress’ Dashicons (slug serving also as a fallback in non-js contexts)."
        | optional,
      keywords
        | Array (String)
        | doc "Sometimes a block could have aliases that help users discover it while searching. For example, an image block could also want to be discovered by photo. You can do so by providing an array of unlimited terms (which are translated)."
        | optional,
      name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$"
            ])
        | doc "The name for a block is a unique string that identifies a block. Names have to be structured as `namespace/block-name`, where namespace is the name of your plugin or theme.",
      parent
        | Array (String)
        | doc "Setting parent lets a block require that it is only available when nested within the specified blocks. For example, you might want to allow an ‘Add to Cart’ block to only be available within a ‘Product’ block."
        | optional,
      providesContext
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                { "[a-zA-Z]" = _js2n__-prdslib.isType '"String", } true
                _js2n__-prdslib.always
            ])
        | doc m%"
          Context provided for available access by descendants of blocks of this type, in the form of an object which maps a context name to one of the block’s own attribute.
          
          See the block context documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-context/ for more details.
        "%
        | optional,
      render
        | String
        | doc "Template file loaded on the server when rendering a block."
        | optional,
      script
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type frontend and editor script definition. It will be enqueued both in the editor and when viewing the content on the front of the site."
        | optional,
      selectors
        | {
          border
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          color = _js2n__-prdslib.isType '"String",
                          radius = _js2n__-prdslib.isType '"String",
                          root = _js2n__-prdslib.isType '"String",
                          style = _js2n__-prdslib.isType '"String",
                          width = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "Custom CSS selector used to generate rules for the block's theme.json border styles."
            | optional,
          color
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          background = _js2n__-prdslib.isType '"String",
                          root = _js2n__-prdslib.isType '"String",
                          text = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "Custom CSS selector used to generate rules for the block's theme.json color styles."
            | optional,
          dimensions
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          aspectRatio = _js2n__-prdslib.isType '"String",
                          minHeight = _js2n__-prdslib.isType '"String",
                          root = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "Custom CSS selector used to generate rules for the block's theme.json dimensions styles."
            | optional,
          root
            | String
            | doc "The primary CSS class to apply to the block. This replaces the `.wp-block-name` class if set."
            | optional,
          spacing
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          blockGap = _js2n__-prdslib.isType '"String",
                          margin = _js2n__-prdslib.isType '"String",
                          padding = _js2n__-prdslib.isType '"String",
                          root = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "Custom CSS selector used to generate rules for the block's theme.json spacing styles."
            | optional,
          typography
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          fontFamily = _js2n__-prdslib.isType '"String",
                          fontSize = _js2n__-prdslib.isType '"String",
                          fontStyle = _js2n__-prdslib.isType '"String",
                          fontWeight = _js2n__-prdslib.isType '"String",
                          letterSpacing = _js2n__-prdslib.isType '"String",
                          lineHeight = _js2n__-prdslib.isType '"String",
                          root = _js2n__-prdslib.isType '"String",
                          textDecoration = _js2n__-prdslib.isType '"String",
                          textTransform = _js2n__-prdslib.isType '"String",
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "Custom CSS selector used to generate rules for the block's theme.json typography styles."
            | optional,
          ..
        }
        | doc "Provides custom CSS selectors and mappings for the block. Selectors may be set for the block itself or per-feature e.g. typography. Custom selectors per feature or sub-feature, allow different block styles to be applied to different elements within the block."
        | optional,
      style
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type frontend style definition. It will be enqueued both in the editor and when viewing the content on the front of the site."
        | optional,
      styles
        | Array { isDefault | Bool | optional, label | String, name | String, }
        | doc m%"
          Block styles can be used to provide alternative styles to block. It works by adding a class name to the block’s wrapper. Using CSS, a theme developer can target the class name for the block style if it is selected.
          
          Plugins and Themes can also register custom block style for existing blocks.
          
          https://developer.wordpress.org/block-editor/reference-guides/block-api/block-styles
        "%
        | optional,
      supports
        | {
          align
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [ "wide", "full", "left", "center", "right" ]
                          ])
                    ]
                ])
            | doc "This property adds block controls which allow to change block’s alignment."
            | optional,
          alignWide
            | Bool
            | doc "This property allows to enable wide alignment for your theme. To disable this behavior for a single block, set this flag to false."
            | optional,
          anchor
            | Bool
            | doc "Anchors let you link directly to a specific block on a page. This property adds a field to define an id for the block and a button to copy the direct link."
            | optional,
          ariaLabel
            | Bool
            | doc "ARIA-labels let you define an accessible label for elements. This property allows enabling the definition of an aria-label for the block, without exposing a UI field."
            | optional,
          background
            | {
              backgroundImage
                | Bool
                | doc "Allow blocks to define a background image."
                | optional,
              backgroundSize
                | Bool
                | doc "Allow blocks to define values related to the size of a background image, including size, position, and repeat controls"
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the CSS style properties related to background. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
              
              When the block declares support for a specific background property, its attributes definition is extended to include the style attribute.
            "%
            | optional,
          className
            | Bool
            | doc "By default, the class .wp-block-your-block-name is added to the root element of your saved markup. This helps having a consistent mechanism for styling blocks that themes and plugins can rely on. If, for whatever reason, a class is not desired on the markup, this functionality can be disabled."
            | optional,
          color
            | {
              background
                | Bool
                | doc m%"
                  This property adds UI controls which allow the user to apply a solid background color to a block.
                  
                  When color support is declared, this property is enabled by default (along with text), so simply setting color will enable background color.
                  
                  To disable background support while keeping other color supports enabled, set to false.
                  
                  When the block declares support for color.background, its attributes definition is extended to include two new attributes: backgroundColor and style
                "%
                | optional,
              button
                | Bool
                | doc m%"
                  This property adds block controls which allow the user to set button colors in a block. Button color is disabled by default.
                  
                  Button color presets are sourced from the editor-color-palette theme support.
                  
                  When the block declares support for color.button, its attributes definition is extended to include the style attribute
                "%
                | optional,
              enableContrastChecker
                | Bool
                | doc m%"
                  Determines whether the contrast checker widget displays in the block editor UI.
                  
                  The contrast checker appears only if the block declares support for color. It tests the readability of color combinations and warns if there is a potential issue. The property is enabled by default.
                  
                  Set to `false` to explicitly disable.
                "%
                | optional,
              gradients
                | Bool
                | doc m%"
                  This property adds UI controls which allow the user to apply a gradient background to a block.
                  
                  Gradient presets are sourced from editor-gradient-presets theme support.
                  
                  When the block declares support for color.gradient, its attributes definition is extended to include two new attributes: gradient and style
                "%
                | optional,
              heading
                | Bool
                | doc m%"
                  This property adds block controls which allow the user to set heading colors in a block. Heading color is disabled by default.
                  
                  Heading color presets are sourced from the editor-color-palette theme support.
                  
                  When the block declares support for color.heading, its attributes definition is extended to include the style attribute
                "%
                | optional,
              link
                | Bool
                | doc m%"
                  This property adds block controls which allow the user to set link color in a block, link color is disabled by default.
                  
                  Link color presets are sourced from the editor-color-palette theme support.
                  
                  When the block declares support for color.link, its attributes definition is extended to include the style attribute
                "%
                | optional,
              text
                | Bool
                | doc m%"
                  This property adds block controls which allow the user to set text color in a block.
                  
                  When color support is declared, this property is enabled by default (along with background), so simply setting color will enable text color.
                  
                  Text color presets are sourced from the editor-color-palette theme support.
                  
                  When the block declares support for color.text, its attributes definition is extended to include two new attributes: textColor and style
                "%
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the properties related to color. When it does, the block editor will show UI controls for the user to set their values.
              
              Note that the background and text keys have a default value of true, so if the color property is present they’ll also be considered enabled
            "%
            | optional,
          customClassName
            | Bool
            | doc "This property adds a field to define a custom className for the block’s wrapper."
            | optional,
          dimensions
            | {
              aspectRatio
                | Bool
                | doc "Allow blocks to define an aspect ratio value."
                | optional,
              minHeight
                | Bool
                | doc "Allow blocks to define a minimum height value."
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the CSS style properties related to dimensions. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
              
              When the block declares support for a specific dimensions property, its attributes definition is extended to include the style attribute.
            "%
            | optional,
          filter
            | {
              duotone
                | Bool
                | doc "Allow blocks to define a duotone filter."
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the properties related to filters. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
              
              When the block declares support for a specific filter property, its attributes definition is extended to include the style attribute.
            "%
            | optional,
          html
            | Bool
            | doc "By default, a block’s markup can be edited individually. To disable this behavior, set html to false."
            | optional,
          inserter
            | Bool
            | doc "By default, all blocks will appear in the inserter, block transforms menu, Style Book, etc. To hide a block from all parts of the user interface so that it can only be inserted programmatically, set inserter to false."
            | optional,
          interactivity
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          clientNavigation = _js2n__-prdslib.isType '"Bool",
                          interactive = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "Indicates if the block is using Interactivity API features."
            | optional,
          layout
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          allowCustomContentAndWideSize =
                            _js2n__-prdslib.isType '"Bool",
                          allowEditing = _js2n__-prdslib.isType '"Bool",
                          allowInheriting = _js2n__-prdslib.isType '"Bool",
                          allowJustification = _js2n__-prdslib.isType '"Bool",
                          allowOrientation = _js2n__-prdslib.isType '"Bool",
                          allowSizingOnChildren =
                            _js2n__-prdslib.isType '"Bool",
                          allowSwitching = _js2n__-prdslib.isType '"Bool",
                          allowVerticalAlignment =
                            _js2n__-prdslib.isType '"Bool",
                          "default" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      columnCount =
                                        _js2n__-prdslib.isType '"Number",
                                      contentSize =
                                        _js2n__-prdslib.isType '"String",
                                      flexWrap =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "wrap", "nowrap" ]
                                            ],
                                      justifyContent =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "right",
                                                  "center",
                                                  "space-between",
                                                  "left",
                                                  "stretch"
                                                ]
                                            ],
                                      minimumColumnWidth =
                                        _js2n__-prdslib.isType '"String",
                                      orientation =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "horizontal", "vertical" ]
                                            ],
                                      type =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "constrained",
                                                  "grid",
                                                  "flex"
                                                ]
                                            ],
                                      verticalAlignment =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "top",
                                                  "center",
                                                  "bottom",
                                                  "space-between",
                                                  "stretch"
                                                ]
                                            ],
                                      wideSize =
                                        _js2n__-prdslib.isType '"String",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } {} true _js2n__-prdslib.always
                    ]
                ])
            | doc "This value only applies to blocks that are containers for inner blocks. If set to `true` the layout type will be `flow`. For other layout types it's necessary to set the `type` explicitly inside the `default` object."
            | optional,
          lock
            | Bool
            | doc "A block may want to disable the ability to toggle the lock state. It can be locked/unlocked by a user from the block 'Options' dropdown by default. To disable this behavior, set lock to false."
            | optional,
          multiple
            | Bool
            | doc "A non-multiple block can be inserted into each post, one time only. For example, the built-in ‘More’ block cannot be inserted again if it already exists in the post being edited. A non-multiple block’s icon is automatically dimmed (unclickable) to prevent multiple instances."
            | optional,
          position
            | {
              sticky
                | Bool
                | doc "Allow blocks to stick to their immediate parent when scrolling the page."
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the CSS style properties related to position. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
              
              When the block declares support for a specific position property, its attributes definition is extended to include the style attribute.
            "%
            | optional,
          renaming
            | Bool
            | doc "By default, a block can be renamed by a user from the block 'Options' dropdown or the 'Advanced' panel. To disable this behavior, set renaming to false."
            | optional,
          reusable
            | Bool
            | doc "A block may want to disable the ability of being converted into a reusable block. By default all blocks can be converted to a reusable block. If supports reusable is set to false, the option to convert the block into a reusable block will not appear."
            | optional,
          shadow
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"Bool",
                  _js2n__-prdslib.isType 'Record
                ])
            | doc "Allow blocks to define a box shadow."
            | optional,
          spacing
            | {
              margin
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "top", "right", "left", "bottom" ]
                              ])
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "vertical", "horizontal" ]
                              ])
                        ]
                    ])
                | optional,
              padding
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "top", "right", "left", "bottom" ]
                              ])
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "vertical", "horizontal" ]
                              ])
                        ]
                    ])
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the CSS style properties related to spacing. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
              
              When the block declares support for a specific spacing property, its attributes definition is extended to include the style attribute.
            "%
            | optional,
          splitting
            | Bool
            | doc "This property indicates whether the block can split when the Enter key is pressed or when blocks are pasted."
            | optional,
          typography
            | {
              fontSize
                | Bool
                | doc m%"
                  This value signals that a block supports the font-size CSS style property. When it does, the block editor will show an UI control for the user to set its value.
                  
                  The values shown in this control are the ones declared by the theme via the editor-font-sizes theme support, or the default ones if none is provided.
                  
                  When the block declares support for fontSize, its attributes definition is extended to include two new attributes: fontSize and style
                "%
                | optional,
              lineHeight
                | Bool
                | doc m%"
                  This value signals that a block supports the line-height CSS style property. When it does, the block editor will show an UI control for the user to set its value if the theme declares support.
                  
                  When the block declares support for lineHeight, its attributes definition is extended to include a new attribute style of object type with no default assigned. It stores the custom value set by the user. The block can apply a default style by specifying its own style attribute with a default
                "%
                | optional,
              textAlign
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "left", "center", "right" ]
                              ])
                        ]
                    ])
                | doc "This property adds block toolbar controls which allow to change block's text alignment."
                | optional,
              ..
            }
            | doc m%"
              This value signals that a block supports some of the CSS style properties related to typography. When it does, the block editor will show UI controls for the user to set their values if the theme declares support.
              
              When the block declares support for a specific typography property, its attributes definition is extended to include the style attribute.
            "%
            | optional,
          ..
        }
        | doc "It contains as set of options to control features used in the editor. See the supports documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-supports/ for more details."
        | optional,
      textdomain
        | String
        | doc m%"
          The gettext text domain of the plugin/block. More information can be found in the Text Domain section of the How to Internationalize your Plugin page.
          
          https://developer.wordpress.org/plugins/internationalization/how-to-internationalize-your-plugin/
        "%
        | optional,
      title
        | String
        | doc "This is the display title for your block, which can be translated with our translation functions. The block inserter will show this name.",
      usesContext
        | Array (String)
        | doc m%"
          Array of the names of context values to inherit from an ancestor provider.
          
          See the block context documentation at https://developer.wordpress.org/block-editor/reference-guides/block-api/block-context/ for more details.
        "%
        | optional,
      variations
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required [ "name", "title" ],
                        _js2n__-prdslib.records.record
                          {
                            attributes = _js2n__-prdslib.isType 'Record,
                            category =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.enum
                                          [
                                            "text",
                                            "media",
                                            "design",
                                            "widgets",
                                            "theme",
                                            "embed"
                                          ]
                                      ]
                                  ],
                            description = _js2n__-prdslib.isType '"String",
                            example = _js2n__-prdslib.isType 'Record,
                            icon = _js2n__-prdslib.isType '"String",
                            innerBlocks =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"Array")
                                  ],
                            isActive =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            isDefault = _js2n__-prdslib.isType '"Bool",
                            keywords =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String")
                                  ],
                            name = _js2n__-prdslib.isType '"String",
                            scope =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "inserter", "block", "transform" ]
                                        ])
                                  ],
                            title = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ])
                ]
            ])
        | doc "Block Variations is the API that allows a block to have similar versions of it, but all these versions share some common functionality."
        | optional,
      version
        | String
        | doc "The current version number of the block, such as 1.0 or 1.0.3. It’s similar to how plugins are versioned. This field might be used with block assets to control cache invalidation, and when the block author omits it, then the installed version of WordPress is used instead."
        | optional,
      viewScript
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type frontend script definition. It will be enqueued only when viewing the content on the front of the site."
        | optional,
      viewScriptModule
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type frontend script module definition. It will be enqueued only when viewing the content on the front of the site."
        | optional,
      viewStyle
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ])
        | doc "Block type frontend style definition. It will be enqueued only when viewing the content on the front of the site."
        | optional,
    }