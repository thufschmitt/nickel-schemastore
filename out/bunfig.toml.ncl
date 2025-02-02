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
      define
        | {  .. }
        | doc m%"
          The `define` field allows you to replace certain global identifiers with constant expressions. Bun will replace any usage of the identifier with the expression. The expression should be a JSON string
          https://bun.sh/docs/runtime/bunfig#define
        "%
        | optional,
      install
        | {
          auto
            | std.enum.TagOrString
            | [| 'fallback, 'disable, '"force", 'auto |]
            | doc m%"
              To configure Bun's package auto-install behavior. Default `"auto"` — when no `node_modules` folder is found, Bun will automatically install dependencies on the fly during execution
              https://bun.sh/docs/runtime/bunfig#install-auto
            "%
            | optional,
          ca
            | String
            | doc m%"
              The CA certificate as a string
              https://bun.sh/docs/runtime/bunfig#install-ca-and-install-cafile
            "%
            | optional,
          cache
            | {
              dir
                | String
                | doc m%"
                  The directory to use for the cache
                  https://bun.sh/docs/runtime/bunfig#install-cache
                "%
                | optional,
              disable
                | Bool
                | doc m%"
                  When true, don't load from the global cache.
                  
                  Bun may still write to `node_modules/.cache`
                  https://bun.sh/docs/runtime/bunfig#install-cache
                "%
                | optional,
              disableManifest
                | Bool
                | doc m%"
                  When true, always resolve the latest versions from the registry
                  https://bun.sh/docs/runtime/bunfig#install-cache
                "%
                | optional,
            }
            | doc m%"
              To configure the cache behavior
              https://bun.sh/docs/runtime/bunfig#install-cache
            "%
            | optional,
          cafile
            | String
            | doc m%"
              A path to a CA certificate file. The file can contain multiple certificates.
              https://bun.sh/docs/runtime/bunfig#install-ca-and-install-cafile
            "%
            | optional,
          dev
            | Bool
            | doc m%"
              Whether to install development dependencies. Default `true`
              https://bun.sh/docs/runtime/bunfig#install-dev
            "%
            | optional,
          dryRun
            | Bool
            | doc m%"
              Whether `bun install` will actually install dependencies. Default `false`. When true, it's equivalent to setting `--dry-run` on all `bun install` commands
              https://bun.sh/docs/runtime/bunfig#install-dryrun
            "%
            | optional,
          exact
            | Bool
            | doc m%"
              Whether to set an exact version in package.json. Default `false`
              
              By default Bun uses caret ranges; if the `latest` version of a package is `2.4.1`, the version range in your `package.json` will be `^2.4.1`. This indicates that any version from `2.4.1` up to (but not including) `3.0.0` is acceptable
              https://bun.sh/docs/runtime/bunfig#install-exact
            "%
            | optional,
          frozenLockfile
            | Bool
            | doc m%"
              When true, `bun install` will not update `bun.lock`. Default `false`. If `package.json` and the existing `bun.lock` are not in agreement, this will error
              https://bun.sh/docs/runtime/bunfig#install-frozenlockfile
            "%
            | optional,
          globalBinDir
            | String
            | doc m%"
              To configure the directory where Bun installs globally installed binaries and CLIs
              https://bun.sh/docs/runtime/bunfig#install-globalbindir
            "%
            | optional,
          globalDir
            | String
            | doc m%"
              To configure the directory where Bun puts globally installed packages
              https://bun.sh/docs/runtime/bunfig#install-globaldir
            "%
            | optional,
          lockfile
            | {
              print
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.const "yarn"
                    ])
                | doc m%"
                  Whether to generate a non-Bun lockfile alongside `bun.lock`. (A `bun.lock` will always be created.) Currently `"yarn"` is the only supported value
                  https://bun.sh/docs/runtime/bunfig#install-lockfile
                "%
                | optional,
              save
                | Bool
                | doc m%"
                  Whether to generate a lockfile on `bun install`. Default `true`
                  https://bun.sh/docs/runtime/bunfig#install-lockfile
                "%
                | optional,
            }
            | doc m%"
              To configure lockfile behavior, use the `install.lockfile` section
              https://bun.sh/docs/runtime/bunfig#install-lockfile
            "%
            | optional,
          "optional"
            | Bool
            | doc m%"
              Whether to install optional dependencies. Default `true`
              https://bun.sh/docs/runtime/bunfig#install-optional
            "%
            | optional,
          peer
            | Bool
            | doc m%"
              Whether to install peer dependencies. Default `true`
              https://bun.sh/docs/runtime/bunfig#install-peer
            "%
            | optional,
          production
            | Bool
            | doc m%"
              Whether bun install will run in "production mode". Default `false`
              
              In production mode, `"devDependencies"` are not installed. You can use `--production` in the CLI to override this setting
              https://bun.sh/docs/runtime/bunfig#install-production
            "%
            | optional,
          registry
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          token = _js2n__-prdslib.isType '"String",
                          url = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ])
            | doc m%"
              The default registry is `https://registry.npmjs.org/`. This can be globally configured in `bunfig.toml`
              https://bun.sh/docs/runtime/bunfig#install-registry
            "%
            | optional,
          saveTextLockfile
            | Bool
            | doc m%"
              If false, generate a binary `bun.lockb` instead of a text-based `bun.lock` file when running `bun install` and no lockfile is present
              Default `true` (since Bun v1.2)
              https://bun.sh/docs/runtime/bunfig#install-savetextlockfile
            "%
            | optional,
          scopes
            | {  .. }
            | doc m%"
              To configure a registry for a particular scope (e.g. `@myorg/<package>`) use `install.scopes`. You can reference environment variables with `$variable` notation
              https://bun.sh/docs/runtime/bunfig#install-scopes
            "%
            | optional,
        }
        | doc m%"
          Package management is a complex issue; to support a range of use cases, the behavior of `bun install` can be configured under the `[install]` section
          https://bun.sh/docs/runtime/bunfig#package-manager
        "%
        | optional,
      jsx
        | String
        | doc m%"
          Configure how Bun handles JSX. You can also set these fields in the `compilerOptions` of your `tsconfig.json`, but they are supported here as well for non-TypeScript projects
          https://bun.sh/docs/runtime/bunfig#jsx
          https://www.typescriptlang.org/tsconfig/#jsx
        "%
        | optional,
      jsxFactory
        | String
        | doc m%"
          Specify the function that is used to create JSX elements
          https://www.typescriptlang.org/tsconfig#jsxFactory
        "%
        | optional,
      jsxFragment
        | String
        | doc m%"
          Specify the function that is used for JSX fragments
          https://www.typescriptlang.org/tsconfig#jsxFragment
        "%
        | optional,
      jsxImportSource
        | String
        | doc m%"
          Specify the module specifier to be used for importing the JSX factory functions
          https://www.typescriptlang.org/tsconfig#jsxImportSource
        "%
        | optional,
      loader
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum
                      [
                        "jsx",
                        "js",
                        "ts",
                        "tsx",
                        "css",
                        "file",
                        "json",
                        "toml",
                        "wasm",
                        "napi",
                        "base64",
                        "dataurl",
                        "text"
                      ]
                  ])
            ])
        | doc m%"
          Configure how Bun maps file extensions to loaders. This is useful for loading files that aren't natively supported by Bun
          https://bun.sh/docs/runtime/bunfig#loader
        "%
        | optional,
      logLevel
        | std.enum.TagOrString
        | [| 'error, 'warn, 'debug |]
        | doc m%"
          Set the log level. This can be one of `"debug"`, `"warn"`, or `"error"`
          https://bun.sh/docs/runtime/bunfig#loglevel
        "%
        | optional,
      preload
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ],
              _js2n__-prdslib.isType '"String"
            ])
        | doc m%"
          An array or string of scripts/plugins to run before running the file or script
          https://bun.sh/docs/runtime/bunfig#preload
        "%
        | optional,
      run
        | {
          bun
            | Bool
            | doc m%"
              Auto alias `node` to `bun`
              
              When `true`, this prepends `$PATH` with a `node` symlink that points to the `bun` binary for all scripts or executables invoked by `bun run` or `bun`
              This means that if you have a script that runs `node`, it will actually run `bun` instead, without needing to change your script. This works recursively, so if your script runs another script that runs `node`, it will also run `bun` instead. This applies to shebangs as well, so if you have a script with a shebang that points to `node`, it will actually run `bun` instead.
              By default, this is enabled if `node` is not already in your `$PATH`
              https://bun.sh/docs/runtime/bunfig#run-bun-auto-alias-node-to-bun
            "%
            | optional,
          shell
            | std.enum.TagOrString
            | [| 'bun, 'system |]
            | doc m%"
              The shell to use when running package.json scripts via `bun run` or `bun`. On Windows, this defaults to `"bun"` and on other platforms it defaults to `"system"`
              https://bun.sh/docs/runtime/bunfig#run-shell-use-the-system-shell-or-bun-s-shell
            "%
            | optional,
          silent
            | Bool
            | doc m%"
              When `true`, suppresses the output of the command being run by `bun run` or `bun`
              https://bun.sh/docs/runtime/bunfig#run-silent-suppress-reporting-the-command-being-run
            "%
            | optional,
        }
        | doc m%"
          The `bun run` command can be configured under the `[run]` section. These apply to the `bun run` command and the `bun` command when running a file or executable or script.
          
          Currently, `bunfig.toml` isn't always automatically loaded for `bun run` in a local project (it does check for a global `bunfig.toml`), so you might still need to pass `-c` or `-c=bunfig.toml` to use these settings
          https://bun.sh/docs/runtime/bunfig#bun-run
        "%
        | optional,
      smol
        | Bool
        | doc m%"
          Enable `smol` mode. This reduces memory usage at the cost of performance
          https://bun.sh/docs/runtime/bunfig#smol
        "%
        | optional,
      telemetry
        | Bool
        | doc m%"
          The `telemetry` field permit to enable/disable the analytics records. Bun records bundle timings (so we can answer with data, "is Bun getting faster?") and feature usage (e.g., "are people actually using macros?"). The request body size is about 60 bytes, so it's not a lot of data. By default the telemetry is enabled.
          https://bun.sh/docs/runtime/bunfig#telemetry
        "%
        | optional,
      test
        | {
          coverage
            | Bool
            | doc m%"
              Enables coverage reporting. Default `false`. Use `--coverage` to override
              https://bun.sh/docs/runtime/bunfig#test-coverage
            "%
            | optional,
          coverageSkipTestFiles
            | Bool
            | doc m%"
              Whether to skip test files when computing coverage statistics. Default false
              https://bun.sh/docs/runtime/bunfig#test-coverageskiptestfiles
            "%
            | optional,
          coverageThreshold
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ])
            | doc m%"
              To specify a coverage threshold. By default, no threshold is set. If your test suite does not meet or exceed this threshold, `bun test` will exit with a non-zero exit code to indicate the failure
              https://bun.sh/docs/runtime/bunfig#test-coveragethreshold
            "%
            | optional,
          preload
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
                  _js2n__-prdslib.isType '"String"
                ])
            | doc m%"
              Same as the top-level `preload` field, but only applies to `bun test`
              https://bun.sh/docs/runtime/bunfig#test-preload
            "%
            | optional,
          root
            | String
            | doc m%"
              The root directory to run tests from. Default `.`
              https://bun.sh/docs/runtime/bunfig#test-root
            "%
            | optional,
          smol
            | Bool
            | doc m%"
              Same as the top-level `smol` field, but only applies to `bun test`
              https://bun.sh/docs/runtime/bunfig#test-smol
            "%
            | optional,
        }
        | doc m%"
          Test runner
          https://bun.sh/docs/runtime/bunfig#test-runner
        "%
        | optional,
      ..
    }