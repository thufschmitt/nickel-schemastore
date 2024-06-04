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
      "_js2n__-:properties/BasedOnStyle!predicate"
        | doc "The style used for all options not specifically set in the configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "Chromium",
                  "Google",
                  "LLVM",
                  "Mozilla",
                  "WebKit",
                  "Microsoft",
                  "GNU",
                  "InheritParentConfig",
                  "chromium",
                  "google",
                  "llvm",
                  "mozilla",
                  "webkit",
                  "microsoft",
                  "gnu",
                  "inheritparentconfig"
                ]
            ],
      "_js2n__-:properties/Language!predicate"
        | doc "clang-format 3.5\r\r Language, this format style is targeted at."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "None",
                  "Cpp",
                  "ObjC",
                  "CSharp",
                  "Java",
                  "JavaScript",
                  "Json",
                  "Proto",
                  "TableGen",
                  "TextProto",
                  "Verilog"
                ]
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              AccessModifierOffset = _js2n__-prdslib.isType 'Integer,
              AlignAfterOpenBracket =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Align", "DontAlign", "AlwaysBreak", "BlockIndent" ]
                    ],
              AlignArrayOfStructures =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "Left", "Right" ]
                    ],
              AlignConsecutiveAssignments =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "None",
                              "Consecutive",
                              "AcrossEmptyLines",
                              "AcrossComments",
                              "AcrossEmptyLinesAndComments"
                            ]
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              AcrossComments = _js2n__-prdslib.isType '"Bool",
                              AcrossEmptyLines = _js2n__-prdslib.isType '"Bool",
                              AlignCompound = _js2n__-prdslib.isType '"Bool",
                              Enabled = _js2n__-prdslib.isType '"Bool",
                              PadOperators = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              AlignConsecutiveBitFields =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "None",
                              "Consecutive",
                              "AcrossEmptyLines",
                              "AcrossComments",
                              "AcrossEmptyLinesAndComments"
                            ]
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              AcrossComments = _js2n__-prdslib.isType '"Bool",
                              AcrossEmptyLines = _js2n__-prdslib.isType '"Bool",
                              Enabled = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              AlignConsecutiveDeclarations =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "None",
                              "Consecutive",
                              "AcrossEmptyLines",
                              "AcrossComments",
                              "AcrossEmptyLinesAndComments"
                            ]
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              AcrossComments = _js2n__-prdslib.isType '"Bool",
                              AcrossEmptyLines = _js2n__-prdslib.isType '"Bool",
                              AlignFunctionPointers =
                                _js2n__-prdslib.isType '"Bool",
                              Enabled = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              AlignConsecutiveMacros =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "None",
                              "Consecutive",
                              "AcrossEmptyLines",
                              "AcrossComments",
                              "AcrossEmptyLinesAndComments"
                            ]
                        ],
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              AcrossComments = _js2n__-prdslib.isType '"Bool",
                              AcrossEmptyLines = _js2n__-prdslib.isType '"Bool",
                              Enabled = _js2n__-prdslib.isType '"Bool",
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              AlignConsecutiveShortCaseStatements =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AcrossComments = _js2n__-prdslib.isType '"Bool",
                          AcrossEmptyLines = _js2n__-prdslib.isType '"Bool",
                          AlignCaseColons = _js2n__-prdslib.isType '"Bool",
                          Enabled = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              AlignEscapedNewlines =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Left", "Right", "DontAlign" ]
                    ],
              AlignOperands =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Align", "DontAlign", "AlignAfterOperator" ]
                    ],
              AlignTrailingComments =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              Kind =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "Leave", "Always", "Never" ]
                                    ],
                              OverEmptyLines =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                            } {} true _js2n__-prdslib.always
                        ]
                    ],
              AllowAllArgumentsOnNextLine = _js2n__-prdslib.isType '"Bool",
              AllowAllConstructorInitializersOnNextLine =
                _js2n__-prdslib.isType '"Bool",
              AllowAllParametersOfDeclarationOnNextLine =
                _js2n__-prdslib.isType '"Bool",
              AllowBreakBeforeNoexceptSpecifier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Never", "OnlyWithParen", "Always" ]
                    ],
              AllowShortBlocksOnASingleLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Never", "Empty", "Always" ]
                    ],
              AllowShortCaseLabelsOnASingleLine =
                _js2n__-prdslib.isType '"Bool",
              AllowShortCompoundRequirementOnASingleLine =
                _js2n__-prdslib.isType '"Bool",
              AllowShortEnumsOnASingleLine = _js2n__-prdslib.isType '"Bool",
              AllowShortFunctionsOnASingleLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "All", "None", "Inline", "Empty", "InlineOnly" ]
                    ],
              AllowShortIfStatementsOnASingleLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "AllIfsAndElse",
                          "Never",
                          "WithoutElse",
                          "OnlyFirstIf"
                        ]
                    ],
              AllowShortLambdasOnASingleLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "Empty", "Inline", "All" ]
                    ],
              AllowShortLoopsOnASingleLine = _js2n__-prdslib.isType '"Bool",
              AlwaysBreakAfterDefinitionReturnType =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "All", "TopLevel" ]
                    ],
              AlwaysBreakAfterReturnType =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "None",
                          "All",
                          "TopLevel",
                          "AllDefinitions",
                          "TopLevelDefinitions"
                        ]
                    ],
              AlwaysBreakBeforeMultilineStrings =
                _js2n__-prdslib.isType '"Bool",
              AlwaysBreakTemplateDeclarations =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Yes", "No", "MultiLine" ]
                    ],
              AttributeMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              BasedOnStyle =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "Chromium",
                          "Google",
                          "LLVM",
                          "Mozilla",
                          "WebKit",
                          "Microsoft",
                          "GNU",
                          "InheritParentConfig",
                          "chromium",
                          "google",
                          "llvm",
                          "mozilla",
                          "webkit",
                          "microsoft",
                          "gnu",
                          "inheritparentconfig"
                        ]
                    ],
              BinPackArguments = _js2n__-prdslib.isType '"Bool",
              BinPackParameters = _js2n__-prdslib.isType '"Bool",
              BitFieldColonSpacing =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Both", "None", "Before", "After" ]
                    ],
              BraceWrapping =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AfterCaseLabel = _js2n__-prdslib.isType '"Bool",
                          AfterClass = _js2n__-prdslib.isType '"Bool",
                          AfterControlStatement =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.enum
                                    [ "Never", "MultiLine", "Always" ]
                                ],
                          AfterEnum = _js2n__-prdslib.isType '"Bool",
                          AfterExternBlock = _js2n__-prdslib.isType '"Bool",
                          AfterFunction = _js2n__-prdslib.isType '"Bool",
                          AfterNamespace = _js2n__-prdslib.isType '"Bool",
                          AfterObjCDeclaration = _js2n__-prdslib.isType '"Bool",
                          AfterStruct = _js2n__-prdslib.isType '"Bool",
                          AfterUnion = _js2n__-prdslib.isType '"Bool",
                          BeforeCatch = _js2n__-prdslib.isType '"Bool",
                          BeforeElse = _js2n__-prdslib.isType '"Bool",
                          BeforeLambdaBody = _js2n__-prdslib.isType '"Bool",
                          BeforeWhile = _js2n__-prdslib.isType '"Bool",
                          IndentBraces = _js2n__-prdslib.isType '"Bool",
                          SplitEmptyFunction = _js2n__-prdslib.isType '"Bool",
                          SplitEmptyNamespace = _js2n__-prdslib.isType '"Bool",
                          SplitEmptyRecord = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              BracedInitializerIndentWidth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              BreakAdjacentStringLiterals = _js2n__-prdslib.isType '"Bool",
              BreakAfterAttributes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Always", "Leave", "Never" ]
                    ],
              BreakAfterJavaFieldAnnotations = _js2n__-prdslib.isType '"Bool",
              BreakArrays = _js2n__-prdslib.isType '"Bool",
              BreakBeforeBinaryOperators =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "NonAssignment", "All" ]
                    ],
              BreakBeforeBraces =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "Attach",
                          "Linux",
                          "Mozilla",
                          "Stroustrup",
                          "Allman",
                          "Whitesmiths",
                          "GNU",
                          "WebKit",
                          "Custom"
                        ]
                    ],
              BreakBeforeConceptDeclarations =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Never", "Allowed", "Always" ]
                        ]
                    ],
              BreakBeforeInheritanceComma = _js2n__-prdslib.isType '"Bool",
              BreakBeforeInlineASMColon =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Never", "OnlyMultiline", "Always" ]
                    ],
              BreakBeforeTernaryOperators = _js2n__-prdslib.isType '"Bool",
              BreakConstructorInitializers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "BeforeColon", "BeforeComma", "AfterColon" ]
                    ],
              BreakConstructorInitializersBeforeComma =
                _js2n__-prdslib.isType '"Bool",
              BreakInheritanceList =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "BeforeColon",
                          "BeforeComma",
                          "AfterColon",
                          "AfterComma"
                        ]
                    ],
              BreakStringLiterals = _js2n__-prdslib.isType '"Bool",
              ColumnLimit =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              CommentPragmas = _js2n__-prdslib.isType '"String",
              CompactNamespaces = _js2n__-prdslib.isType '"Bool",
              ConstructorInitializerAllOnOneLineOrOnePerLine =
                _js2n__-prdslib.isType '"Bool",
              ConstructorInitializerIndentWidth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              ContinuationIndentWidth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              Cpp11BracedListStyle = _js2n__-prdslib.isType '"Bool",
              DeriveLineEnding = _js2n__-prdslib.isType '"Bool",
              DerivePointerAlignment = _js2n__-prdslib.isType '"Bool",
              DisableFormat = _js2n__-prdslib.isType '"Bool",
              EmptyLineAfterAccessModifier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Never", "Leave", "Always" ]
                    ],
              EmptyLineBeforeAccessModifier =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "LogicalBlock", "Never", "Leave", "Always" ]
                    ],
              ExperimentalAutoDetectBinPacking = _js2n__-prdslib.isType '"Bool",
              FixNamespaceComments = _js2n__-prdslib.isType '"Bool",
              ForEachMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              IfMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              IncludeBlocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Regroup", "Preserve", "Merge" ]
                    ],
              IncludeCategories =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required
                              [ "Priority", "Regex" ],
                            _js2n__-prdslib.records.record
                              {
                                CaseSensitive = _js2n__-prdslib.isType '"Bool",
                                Priority =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                                Regex = _js2n__-prdslib.isType '"String",
                                SortPriority =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Integer,
                                        _js2n__-prdslib.numbers.minimum 0
                                      ],
                              } {} true _js2n__-prdslib.always
                          ])
                    ],
              IncludeIsMainRegex = _js2n__-prdslib.isType '"String",
              IncludeIsMainSourceRegex = _js2n__-prdslib.isType '"String",
              IndentAccessModifiers = _js2n__-prdslib.isType '"Bool",
              IndentCaseBlocks = _js2n__-prdslib.isType '"Bool",
              IndentCaseLabels = _js2n__-prdslib.isType '"Bool",
              IndentExternBlock =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "AfterExternBlock", "NoIndent", "Indent" ]
                    ],
              IndentGotoLabels = _js2n__-prdslib.isType '"Bool",
              IndentPPDirectives =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "AfterHash", "BeforeHash" ]
                    ],
              IndentRequires = _js2n__-prdslib.isType '"Bool",
              IndentRequiresClause = _js2n__-prdslib.isType '"Bool",
              IndentWidth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              IndentWrappedFunctionNames = _js2n__-prdslib.isType '"Bool",
              InsertBraces = _js2n__-prdslib.isType '"Bool",
              InsertNewlineAtEOF = _js2n__-prdslib.isType '"Bool",
              InsertTrailingCommas =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "Wrapped" ]
                    ],
              IntegerLiteralSeparator =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          Binary = _js2n__-prdslib.isType 'Integer,
                          BinaryMinDigits = _js2n__-prdslib.isType 'Integer,
                          Decimal = _js2n__-prdslib.isType 'Integer,
                          DecimalMinDigits = _js2n__-prdslib.isType 'Integer,
                          Hex = _js2n__-prdslib.isType 'Integer,
                          HexMinDigits = _js2n__-prdslib.isType 'Integer,
                        } {} true _js2n__-prdslib.always
                    ],
              JavaImportGroup = _js2n__-prdslib.isType '"Array",
              JavaScriptQuotes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Leave", "Single", "Double" ]
                    ],
              JavaScriptWrapImports = _js2n__-prdslib.isType '"Bool",
              KeepEmptyLinesAtEOF = _js2n__-prdslib.isType '"Bool",
              KeepEmptyLinesAtTheStartOfBlocks = _js2n__-prdslib.isType '"Bool",
              LambdaBodyIndentation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Signature", "OuterScope" ]
                    ],
              Language =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "None",
                          "Cpp",
                          "ObjC",
                          "CSharp",
                          "Java",
                          "JavaScript",
                          "Json",
                          "Proto",
                          "TableGen",
                          "TextProto",
                          "Verilog"
                        ]
                    ],
              LineEnding =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "LF", "CRLF", "DeriveLF", "DeriveCRLF" ]
                    ],
              MacroBlockBegin = _js2n__-prdslib.isType '"String",
              MacroBlockEnd = _js2n__-prdslib.isType '"String",
              Macros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              MaxEmptyLinesToKeep =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              NamespaceIndentation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "None", "Inner", "All" ]
                    ],
              NamespaceMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              ObjCBinPackProtocolList =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Never", "Auto", "Always" ]
                    ],
              ObjCBlockIndentWidth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              ObjCBreakBeforeNestedBlockParam = _js2n__-prdslib.isType '"Bool",
              ObjCPropertyAttributeOrder =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              ObjCSpaceAfterProperty = _js2n__-prdslib.isType '"Bool",
              ObjCSpaceBeforeProtocolList = _js2n__-prdslib.isType '"Bool",
              PPIndentWidth = _js2n__-prdslib.isType 'Integer,
              PackConstructorInitializers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "Never",
                          "BinPack",
                          "CurrentLine",
                          "NextLine",
                          "NextLineOnly"
                        ]
                    ],
              PenaltyBreakAssignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakBeforeFirstCallParameter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakComment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakFirstLessLess =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakOpenParenthesis =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakScopeResolution =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakString =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyBreakTemplateDeclaration =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyExcessCharacter =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyIndentedWhitespace =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PenaltyReturnTypeOnItsOwnLine =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              PointerAlignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Left", "Right", "Middle" ]
                    ],
              QualifierAlignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Leave", "Left", "Right", "Custom" ]
                    ],
              QualifierOrder =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "const",
                                "inline",
                                "static",
                                "friend",
                                "constexpr",
                                "volatile",
                                "restrict",
                                "type"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.contains
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum [ "type" ]
                          ])
                    ],
              RawStringFormats =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.record
                              {
                                BasedOnStyle =
                                  _js2n__-refsenv."_js2n__-:properties/BasedOnStyle!predicate",
                                CanonicalDelimiter =
                                  _js2n__-prdslib.isType '"String",
                                Delimiters =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                                EnclosingFunctions =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ],
                                Language =
                                  _js2n__-refsenv."_js2n__-:properties/Language!predicate",
                              } {} true _js2n__-prdslib.always
                          ])
                    ],
              ReferenceAlignment =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Pointer", "Left", "Right", "Middle" ]
                    ],
              ReflowComments = _js2n__-prdslib.isType '"Bool",
              RemoveBracesLLVM = _js2n__-prdslib.isType '"Bool",
              RemoveParentheses =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Leave", "MultipleParentheses", "ReturnStatement" ]
                    ],
              RemoveSemicolon = _js2n__-prdslib.isType '"Bool",
              RequiresClausePosition =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "OwnLine",
                          "WithPreceding",
                          "WithFollowing",
                          "SingleLine"
                        ]
                    ],
              RequiresExpressionIndentation =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "OuterScope", "Keyword" ]
                    ],
              SeparateDefinitionBlocks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Leave", "Always", "Never" ]
                    ],
              ShortNamespaceLines =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              SkipMacroDefinitionBody = _js2n__-prdslib.isType '"Bool",
              SortIncludes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "CaseSensitive", "CaseInsensitive", "Never" ]
                    ],
              SortJavaStaticImport =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Before", "After" ]
                    ],
              SortUsingDeclarations =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"Bool",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "Never", "Lexicographic", "LexicographicNumeric" ]
                        ]
                    ],
              SpaceAfterCStyleCast = _js2n__-prdslib.isType '"Bool",
              SpaceAfterLogicalNot = _js2n__-prdslib.isType '"Bool",
              SpaceAfterTemplateKeyword = _js2n__-prdslib.isType '"Bool",
              SpaceAroundPointerQualifiers =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "Default", "Before", "After", "Both" ]
                    ],
              SpaceBeforeAssignmentOperators = _js2n__-prdslib.isType '"Bool",
              SpaceBeforeCaseColon = _js2n__-prdslib.isType '"Bool",
              SpaceBeforeCpp11BracedList = _js2n__-prdslib.isType '"Bool",
              SpaceBeforeCtorInitializerColon = _js2n__-prdslib.isType '"Bool",
              SpaceBeforeInheritanceColon = _js2n__-prdslib.isType '"Bool",
              SpaceBeforeJsonColon = _js2n__-prdslib.isType '"Bool",
              SpaceBeforeParens =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "ControlStatements",
                          "Never",
                          "ControlStatementsExceptControlMacros",
                          "NonEmptyParentheses",
                          "Always",
                          "Custom"
                        ]
                    ],
              SpaceBeforeParensOptions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          AfterControlStatements =
                            _js2n__-prdslib.isType '"Bool",
                          AfterForeachMacros = _js2n__-prdslib.isType '"Bool",
                          AfterFunctionDeclarationName =
                            _js2n__-prdslib.isType '"Bool",
                          AfterFunctionDefinitionName =
                            _js2n__-prdslib.isType '"Bool",
                          AfterIfMacros = _js2n__-prdslib.isType '"Bool",
                          AfterOverloadedOperator =
                            _js2n__-prdslib.isType '"Bool",
                          AfterPlacementOperator =
                            _js2n__-prdslib.isType '"Bool",
                          AfterRequiresInClause =
                            _js2n__-prdslib.isType '"Bool",
                          AfterRequiresInExpression =
                            _js2n__-prdslib.isType '"Bool",
                          BeforeNonEmptyParentheses =
                            _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              SpaceBeforeRangeBasedForLoopColon =
                _js2n__-prdslib.isType '"Bool",
              SpaceBeforeSquareBrackets = _js2n__-prdslib.isType '"Bool",
              SpaceInEmptyBlock = _js2n__-prdslib.isType '"Bool",
              SpaceInEmptyParentheses = _js2n__-prdslib.isType '"Bool",
              SpacesBeforeTrailingComments =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              SpacesInAngles =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Never", "Always", "Leave" ]
                    ],
              SpacesInCStyleCastParentheses = _js2n__-prdslib.isType '"Bool",
              SpacesInConditionalStatement = _js2n__-prdslib.isType '"Bool",
              SpacesInContainerLiterals = _js2n__-prdslib.isType '"Bool",
              SpacesInLineCommentPrefix =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          Maximum = _js2n__-prdslib.isType 'Integer,
                          Minimum = _js2n__-prdslib.isType 'Integer,
                        } {} true _js2n__-prdslib.always
                    ],
              SpacesInParens =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "Never", "Custom" ]
                    ],
              SpacesInParensOptions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          InCStyleCasts = _js2n__-prdslib.isType '"Bool",
                          InConditionalStatements =
                            _js2n__-prdslib.isType '"Bool",
                          InEmptyParentheses = _js2n__-prdslib.isType '"Bool",
                          Other = _js2n__-prdslib.isType '"Bool",
                        } {} true _js2n__-prdslib.always
                    ],
              SpacesInParentheses = _js2n__-prdslib.isType '"Bool",
              SpacesInSquareBrackets = _js2n__-prdslib.isType '"Bool",
              Standard =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "Auto",
                          "Latest",
                          "c++03",
                          "c++11",
                          "c++14",
                          "c++17",
                          "c++20"
                        ]
                    ],
              StatementAttributeLikeMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              StatementMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              TabWidth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum 0
                    ],
              TypeNames =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              TypenameMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              UseCRLF = _js2n__-prdslib.isType '"Bool",
              UseTab =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [
                          "Never",
                          "ForIndentation",
                          "ForContinuationAndIndentation",
                          "AlignWithSpaces",
                          "Always"
                        ]
                    ],
              VerilogBreakBetweenInstancePorts = _js2n__-prdslib.isType '"Bool",
              WhitespaceSensitiveMacros =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
            } { "^x-" = _js2n__-prdslib.always, } true _js2n__-prdslib.always
        ])