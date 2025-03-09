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
      "_js2n__-:definitions/clangTidyCheck!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "abseil-cleanup-ctad",
                  "abseil-duration-addition",
                  "abseil-duration-comparison",
                  "abseil-duration-conversion-cast",
                  "abseil-duration-division",
                  "abseil-duration-factory-float",
                  "abseil-duration-factory-scale",
                  "abseil-duration-subtraction",
                  "abseil-duration-unnecessary-conversion",
                  "abseil-faster-strsplit-delimiter",
                  "abseil-no-internal-dependencies",
                  "abseil-no-namespace",
                  "abseil-redundant-strcat-calls",
                  "abseil-str-cat-append",
                  "abseil-string-find-startswith",
                  "abseil-string-find-str-contains",
                  "abseil-time-comparison",
                  "abseil-time-subtraction",
                  "abseil-upgrade-duration-conversions",
                  "altera-id-dependent-backward-branch",
                  "altera-kernel-name-restriction",
                  "altera-single-work-item-barrier",
                  "altera-struct-pack-align",
                  "altera-unroll-loops",
                  "android-cloexec-accept",
                  "android-cloexec-accept4",
                  "android-cloexec-creat",
                  "android-cloexec-dup",
                  "android-cloexec-epoll-create",
                  "android-cloexec-epoll-create1",
                  "android-cloexec-fopen",
                  "android-cloexec-inotify-init",
                  "android-cloexec-inotify-init1",
                  "android-cloexec-memfd-create",
                  "android-cloexec-open",
                  "android-cloexec-pipe",
                  "android-cloexec-pipe2",
                  "android-cloexec-socket",
                  "android-comparison-in-temp-failure-retry",
                  "boost-use-to-string",
                  "bugprone-argument-comment",
                  "bugprone-assert-side-effect",
                  "bugprone-assignment-in-if-condition",
                  "bugprone-bad-signal-to-kill-thread",
                  "bugprone-bool-pointer-implicit-conversion",
                  "bugprone-branch-clone",
                  "bugprone-copy-constructor-init",
                  "bugprone-dangling-handle",
                  "bugprone-dynamic-static-initializers",
                  "bugprone-easily-swappable-parameters",
                  "bugprone-exception-escape",
                  "bugprone-fold-init-type",
                  "bugprone-forward-declaration-namespace",
                  "bugprone-forwarding-reference-overload",
                  "bugprone-implicit-widening-of-multiplication-result",
                  "bugprone-inaccurate-erase",
                  "bugprone-incorrect-roundings",
                  "bugprone-infinite-loop",
                  "bugprone-integer-division",
                  "bugprone-lambda-function-name",
                  "bugprone-macro-parentheses",
                  "bugprone-macro-repeated-side-effects",
                  "bugprone-misplaced-operator-in-strlen-in-alloc",
                  "bugprone-misplaced-pointer-arithmetic-in-alloc",
                  "bugprone-misplaced-widening-cast",
                  "bugprone-move-forwarding-reference",
                  "bugprone-multiple-statement-macro",
                  "bugprone-no-escape",
                  "bugprone-not-null-terminated-result",
                  "bugprone-parent-virtual-call",
                  "bugprone-posix-return",
                  "bugprone-redundant-branch-condition",
                  "bugprone-reserved-identifier",
                  "bugprone-shared-ptr-array-mismatch",
                  "bugprone-signal-handler",
                  "bugprone-signed-char-misuse",
                  "bugprone-sizeof-container",
                  "bugprone-sizeof-expression",
                  "bugprone-spuriously-wake-up-functions",
                  "bugprone-standalone-empty",
                  "bugprone-string-constructor",
                  "bugprone-string-integer-assignment",
                  "bugprone-string-literal-with-embedded-nul",
                  "bugprone-stringview-nullptr",
                  "bugprone-suspicious-enum-usage",
                  "bugprone-suspicious-include",
                  "bugprone-suspicious-memory-comparison",
                  "bugprone-suspicious-memset-usage",
                  "bugprone-suspicious-missing-comma",
                  "bugprone-suspicious-realloc-usage",
                  "bugprone-suspicious-semicolon",
                  "bugprone-suspicious-string-compare",
                  "bugprone-swapped-arguments",
                  "bugprone-terminating-continue",
                  "bugprone-throw-keyword-missing",
                  "bugprone-too-small-loop-variable",
                  "bugprone-unchecked-optional-access",
                  "bugprone-undefined-memory-manipulation",
                  "bugprone-undelegated-constructor",
                  "bugprone-unhandled-exception-at-new",
                  "bugprone-unhandled-self-assignment",
                  "bugprone-unused-raii",
                  "bugprone-unused-return-value",
                  "bugprone-use-after-move",
                  "bugprone-virtual-near-miss",
                  "cert-dcl21-cpp",
                  "cert-dcl50-cpp",
                  "cert-dcl58-cpp",
                  "cert-env33-c",
                  "cert-err33-c",
                  "cert-err34-c",
                  "cert-err52-cpp",
                  "cert-err58-cpp",
                  "cert-err60-cpp",
                  "cert-flp30-c",
                  "cert-mem57-cpp",
                  "cert-msc50-cpp",
                  "cert-msc51-cpp",
                  "cert-oop57-cpp",
                  "cert-oop58-cpp",
                  "clang-analyzer-core.DynamicTypePropagation",
                  "clang-analyzer-core.uninitialized.CapturedBlockVariable",
                  "clang-analyzer-cplusplus.InnerPointer",
                  "clang-analyzer-nullability.NullableReturnedFromNonnull",
                  "clang-analyzer-optin.osx.OSObjectCStyleCast",
                  "clang-analyzer-optin.performance.GCDAntipattern",
                  "clang-analyzer-optin.performance.Padding",
                  "clang-analyzer-optin.portability.UnixAPI",
                  "clang-analyzer-osx.MIG",
                  "clang-analyzer-osx.NumberObjectConversion",
                  "clang-analyzer-osx.OSObjectRetainCount",
                  "clang-analyzer-osx.ObjCProperty",
                  "clang-analyzer-osx.cocoa.AutoreleaseWrite",
                  "clang-analyzer-osx.cocoa.Loops",
                  "clang-analyzer-osx.cocoa.MissingSuperCall",
                  "clang-analyzer-osx.cocoa.NonNilReturnValue",
                  "clang-analyzer-osx.cocoa.RunLoopAutoreleaseLeak",
                  "clang-analyzer-valist.CopyToSelf",
                  "clang-analyzer-valist.Uninitialized",
                  "clang-analyzer-valist.Unterminated",
                  "concurrency-mt-unsafe",
                  "concurrency-thread-canceltype-asynchronous",
                  "cppcoreguidelines-avoid-const-or-ref-data-members",
                  "cppcoreguidelines-avoid-do-while",
                  "cppcoreguidelines-avoid-goto",
                  "cppcoreguidelines-avoid-non-const-global-variables",
                  "cppcoreguidelines-avoid-reference-coroutine-parameters",
                  "cppcoreguidelines-init-variables",
                  "cppcoreguidelines-interfaces-global-init",
                  "cppcoreguidelines-macro-usage",
                  "cppcoreguidelines-narrowing-conversions",
                  "cppcoreguidelines-no-malloc",
                  "cppcoreguidelines-owning-memory",
                  "cppcoreguidelines-prefer-member-initializer",
                  "cppcoreguidelines-pro-bounds-array-to-pointer-decay",
                  "cppcoreguidelines-pro-bounds-constant-array-index",
                  "cppcoreguidelines-pro-bounds-pointer-arithmetic",
                  "cppcoreguidelines-pro-type-const-cast",
                  "cppcoreguidelines-pro-type-cstyle-cast",
                  "cppcoreguidelines-pro-type-member-init",
                  "cppcoreguidelines-pro-type-reinterpret-cast",
                  "cppcoreguidelines-pro-type-static-cast-downcast",
                  "cppcoreguidelines-pro-type-union-access",
                  "cppcoreguidelines-pro-type-vararg",
                  "cppcoreguidelines-slicing",
                  "cppcoreguidelines-special-member-functions",
                  "cppcoreguidelines-virtual-class-destructor",
                  "darwin-avoid-spinlock",
                  "darwin-dispatch-once-nonstatic",
                  "fuchsia-default-arguments-calls",
                  "fuchsia-default-arguments-declarations",
                  "fuchsia-multiple-inheritance",
                  "fuchsia-overloaded-operator",
                  "fuchsia-statically-constructed-objects",
                  "fuchsia-trailing-return",
                  "fuchsia-virtual-inheritance",
                  "google-build-explicit-make-pair",
                  "google-build-namespaces",
                  "google-build-using-namespace",
                  "google-default-arguments",
                  "google-explicit-constructor",
                  "google-global-names-in-headers",
                  "google-objc-avoid-nsobject-new",
                  "google-objc-avoid-throwing-exception",
                  "google-objc-function-naming",
                  "google-objc-global-variable-declaration",
                  "google-readability-avoid-underscore-in-googletest-name",
                  "google-readability-casting",
                  "google-readability-todo",
                  "google-runtime-int",
                  "google-runtime-operator",
                  "google-upgrade-googletest-case",
                  "hicpp-avoid-goto",
                  "hicpp-exception-baseclass",
                  "hicpp-multiway-paths-covered",
                  "hicpp-no-assembler",
                  "hicpp-signed-bitwise",
                  "linuxkernel-must-use-errs",
                  "llvm-header-guard",
                  "llvm-include-order",
                  "llvm-namespace-comment",
                  "llvm-prefer-isa-or-dyn-cast-in-conditionals",
                  "llvm-prefer-register-over-unsigned",
                  "llvm-twine-local",
                  "llvmlibc-callee-namespace",
                  "llvmlibc-implementation-in-namespace",
                  "llvmlibc-restrict-system-libc-headers",
                  "misc-confusable-identifiers",
                  "misc-const-correctness",
                  "misc-definitions-in-headers",
                  "misc-misleading-bidirectional",
                  "misc-misleading-identifier",
                  "misc-misplaced-const",
                  "misc-new-delete-overloads",
                  "misc-no-recursion",
                  "misc-non-copyable-objects",
                  "misc-non-private-member-variables-in-classes",
                  "misc-redundant-expression",
                  "misc-static-assert",
                  "misc-throw-by-value-catch-by-reference",
                  "misc-unconventional-assign-operator",
                  "misc-uniqueptr-reset-release",
                  "misc-unused-alias-decls",
                  "misc-unused-parameters",
                  "misc-unused-using-decls",
                  "misc-use-anonymous-namespace",
                  "modernize-avoid-bind",
                  "modernize-avoid-c-arrays",
                  "modernize-concat-nested-namespaces",
                  "modernize-deprecated-headers",
                  "modernize-deprecated-ios-base-aliases",
                  "modernize-loop-convert",
                  "modernize-macro-to-enum",
                  "modernize-make-shared",
                  "modernize-make-unique",
                  "modernize-pass-by-value",
                  "modernize-raw-string-literal",
                  "modernize-redundant-void-arg",
                  "modernize-replace-auto-ptr",
                  "modernize-replace-disallow-copy-and-assign-macro",
                  "modernize-replace-random-shuffle",
                  "modernize-return-braced-init-list",
                  "modernize-shrink-to-fit",
                  "modernize-unary-static-assert",
                  "modernize-use-auto",
                  "modernize-use-bool-literals",
                  "modernize-use-default-member-init",
                  "modernize-use-emplace",
                  "modernize-use-equals-default",
                  "modernize-use-equals-delete",
                  "modernize-use-nodiscard",
                  "modernize-use-noexcept",
                  "modernize-use-nullptr",
                  "modernize-use-override",
                  "modernize-use-trailing-return-type",
                  "modernize-use-transparent-functors",
                  "modernize-use-uncaught-exceptions",
                  "modernize-use-using",
                  "mpi-buffer-deref",
                  "mpi-type-mismatch",
                  "objc-assert-equals",
                  "objc-avoid-nserror-init",
                  "objc-dealloc-in-category",
                  "objc-forbidden-subclassing",
                  "objc-missing-hash",
                  "objc-nsdate-formatter",
                  "objc-nsinvocation-argument-lifetime",
                  "objc-property-declaration",
                  "objc-super-self",
                  "openmp-exception-escape",
                  "openmp-use-default-none",
                  "performance-faster-string-find",
                  "performance-for-range-copy",
                  "performance-implicit-conversion-in-loop",
                  "performance-inefficient-algorithm",
                  "performance-inefficient-string-concatenation",
                  "performance-inefficient-vector-operation",
                  "performance-move-const-arg",
                  "performance-move-constructor-init",
                  "performance-no-automatic-move",
                  "performance-no-int-to-ptr",
                  "performance-noexcept-move-constructor",
                  "performance-trivially-destructible",
                  "performance-type-promotion-in-math-fn",
                  "performance-unnecessary-copy-initialization",
                  "performance-unnecessary-value-param",
                  "portability-restrict-system-includes",
                  "portability-simd-intrinsics",
                  "portability-std-allocator-const",
                  "readability-avoid-const-params-in-decls",
                  "readability-braces-around-statements",
                  "readability-const-return-type",
                  "readability-container-contains",
                  "readability-container-data-pointer",
                  "readability-container-size-empty",
                  "readability-convert-member-functions-to-static",
                  "readability-delete-null-pointer",
                  "readability-duplicate-include",
                  "readability-else-after-return",
                  "readability-function-cognitive-complexity",
                  "readability-function-size",
                  "readability-identifier-length",
                  "readability-identifier-naming",
                  "readability-implicit-bool-conversion",
                  "readability-inconsistent-declaration-parameter-name",
                  "readability-isolate-declaration",
                  "readability-magic-numbers",
                  "readability-make-member-function-const",
                  "readability-misleading-indentation",
                  "readability-misplaced-array-index",
                  "readability-named-parameter",
                  "readability-non-const-parameter",
                  "readability-qualified-auto",
                  "readability-redundant-access-specifiers",
                  "readability-redundant-control-flow",
                  "readability-redundant-declaration",
                  "readability-redundant-function-ptr-dereference",
                  "readability-redundant-member-init",
                  "readability-redundant-preprocessor",
                  "readability-redundant-smartptr-get",
                  "readability-redundant-string-cstr",
                  "readability-redundant-string-init",
                  "readability-simplify-boolean-expr",
                  "readability-simplify-subscript-expr",
                  "readability-static-accessed-through-instance",
                  "readability-static-definition-in-anonymous-namespace",
                  "readability-string-compare",
                  "readability-suspicious-call-argument",
                  "readability-uniqueptr-delete-release",
                  "readability-uppercase-literal-suffix",
                  "readability-use-anyofallof",
                  "zircon-temporary-objects"
                ]
            ],
      "_js2n__-:definitions/oneOrMoreDiagnostics!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-refsenv."_js2n__-:definitions/clangTidyCheck!predicate"
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.strings.minLength 1
                            ],
                          _js2n__-refsenv."_js2n__-:definitions/clangTidyCheck!predicate"
                        ]),
                    _js2n__-prdslib.arrays.uniqueItems
                  ]
              ]),
      "_js2n__-:definitions/oneOrMoreFlags!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ]),
                    _js2n__-prdslib.arrays.uniqueItems
                  ]
              ]),
      "_js2n__-:definitions/oneOrMorePath!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.oneOf
              [
                _js2n__-prdslib.allOf
                  [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.always ],
                _js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"Array",
                    _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always,
                    _js2n__-prdslib.arrays.uniqueItems
                  ]
              ]),
    }
    in
  {
      CompileFlags
        | {
          Add
            | _js2n__-refsenv."_js2n__-:definitions/oneOrMoreFlags!contract"
            | doc m%"
              Flags to be added to the compile command
              https://clangd.llvm.org/config.html#add
            "%
            | optional,
          CompilationDatabase
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.always,
                  _js2n__-prdslib.enum [ "Ancestors", "None" ]
                ])
            | doc m%"
              A directory to search for compilation database
              https://clangd.llvm.org/config.html#compilationdatabase
            "%
            | optional,
          Compiler
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.minLength 1
                ])
            | doc m%"
              An `argv[0]` replacement
              https://clangd.llvm.org/config.html#compiler
            "%
            | optional,
          Remove
            | _js2n__-refsenv."_js2n__-:definitions/oneOrMoreFlags!contract"
            | doc m%"
              Flags to be removed from the compile command
              https://clangd.llvm.org/config.html#remove
            "%
            | optional,
        }
        | doc m%"
          Flag lists to be added or removed
          https://clangd.llvm.org/config.html#compileflags
        "%
        | optional,
      Completion
        | {
          AllScopes
            | Bool
            | doc m%"
              Whether to include suggestions from scopes that are not visible
              https://clangd.llvm.org/config.html#allscopes
            "%
            | optional,
          ArgumentLists
            | std.enum.TagOrString
            | [| 'FullPlaceholders, 'Delimiters, 'OpenDelimiter, 'None |]
            | doc m%"
              Determines what is inserted in argument list position when completing a call to a function
              https://clangd.llvm.org/config#argumentlists
            "%
            | optional,
        }
        | doc m%"
          Completion options
          https://clangd.llvm.org/config.html#completion
        "%
        | optional,
      Diagnostics
        | {
          ClangTidy
            | {
              Add
                | _js2n__-refsenv."_js2n__-:definitions/oneOrMoreDiagnostics!contract"
                | doc m%"
                  Checks to enable
                  https://clangd.llvm.org/config.html#add-1
                "%
                | optional,
              CheckOptions
                | {  .. }
                | doc m%"
                  Check's options
                  https://clangd.llvm.org/config.html#checkoptions
                "%
                | optional,
              FastCheckFilter
                | std.enum.TagOrString
                | [| 'None, 'Loose, 'Strict |]
                | doc m%"
                  Whether to run clang-tidy checks that may slow down clangd.
                  https://clangd.llvm.org/config.html#fastcheckfilter
                "%
                | optional,
              Remove
                | _js2n__-refsenv."_js2n__-:definitions/oneOrMoreDiagnostics!contract"
                | doc m%"
                  Checks to disable
                  https://clangd.llvm.org/config.html#remove-1
                "%
                | optional,
            }
            | doc m%"
              Clang-Tidy options
              https://clangd.llvm.org/config.html#clangtidy
            "%
            | optional,
          Includes
            | {
              AnalyzeAngledIncludes
                | Bool
                | doc m%"
                  Enables/disables detection of unused angled includes that are not from the Standard Library. Disabled by default to avoid false-positives caused by umbrella headers
                  https://clangd.llvm.org/config.html#analyzeangledincludes
                "%
                | optional,
              IgnoreHeader
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ])
                )
                | doc m%"
                  A list of regexes. Include Cleaner will not produce diagnostics for headers whose path is a suffix match for any of these
                  https://clangd.llvm.org/config.html#ignoreheader
                "%
                | optional,
            }
            | optional,
          MissingIncludes
            | std.enum.TagOrString
            | [| 'Strict, 'None |]
            | doc m%"
              Whether to enable Include Cleaner's missing includes diagnostics
              https://clangd.llvm.org/config.html#missingincludes
            "%
            | optional,
          Suppress
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.const "*"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.minLength 1
                          ]),
                      _js2n__-prdslib.arrays.uniqueItems
                    ]
                ])
            | doc m%"
              Diagnostic codes that to be suppressed
              https://clangd.llvm.org/config.html#suppress
            "%
            | optional,
          UnusedIncludes
            | std.enum.TagOrString
            | [| 'Strict, 'None |]
            | doc m%"
              Whether to enable Include Cleaner's unused includes diagnostics
              https://clangd.llvm.org/config.html#unusedincludes
            "%
            | optional,
        }
        | doc m%"
          Diagnostics
          https://clangd.llvm.org/config.html#diagnostics
        "%
        | optional,
      Hover
        | {
          ShowAKA
            | Bool
            | doc m%"
              Whether to display desugared types
              https://clangd.llvm.org/config.html#showaka
            "%
            | optional,
        }
        | doc m%"
          Hover card's options
          https://clangd.llvm.org/config.html#hover
        "%
        | optional,
      If
        | {
          PathExclude
            | _js2n__-refsenv."_js2n__-:definitions/oneOrMorePath!contract"
            | doc m%"
              An exclude path pattern
              https://clangd.llvm.org/config.html#pathexclude
            "%
            | optional,
          PathMatch
            | _js2n__-refsenv."_js2n__-:definitions/oneOrMorePath!contract"
            | doc m%"
              Path patterns
              https://clangd.llvm.org/config.html#pathmatch
            "%
            | optional,
        }
        | doc m%"
          Conditions
          https://clangd.llvm.org/config.html#if
        "%
        | optional,
      Index
        | {
          Background
            | std.enum.TagOrString
            | [| 'Skip, 'Build |]
            | doc m%"
              Whether to produce a project index from files built in the background
              https://clangd.llvm.org/config.html#background
            "%
            | optional,
          External
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "[nN][oO][nN][eE]"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "File" ],
                      _js2n__-prdslib.records.record
                        { File = _js2n__-prdslib.always, } {} false
                        _js2n__-prdslib.never
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.required [ "Server" ],
                      _js2n__-prdslib.records.record
                        {
                          MountPoint = _js2n__-prdslib.always,
                          Server = _js2n__-prdslib.isType '"String",
                        } {} false _js2n__-prdslib.never
                    ]
                ])
            | doc m%"
              An external index source
              https://clangd.llvm.org/config.html#external
            "%
            | optional,
          StandardLibrary
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.enum [ "Yes", "No" ])
            | doc m%"
              Whether to index a standard library
              https://clangd.llvm.org/config.html#standardlibrary
            "%
            | optional,
        }
        | doc "Code interpretation outside of the current file"
        | optional,
      InlayHints
        | {
          BlockEnd
            | Bool
            | doc m%"
              A boolean that enables/disables inlay-hints for block end comments
              https://clangd.llvm.org/config.html#blockend
            "%
            | optional,
          DeducedTypes
            | Bool
            | doc m%"
              Whether to enable inlay-hints for deduced types
              https://clangd.llvm.org/config.html#deducedtypes
            "%
            | optional,
          DefaultArguments
            | Bool
            | doc m%"
              A boolean that enables/disables inlay hints for default arguments
              https://clangd.llvm.org/config#defaultarguments
            "%
            | optional,
          Designators
            | Bool
            | doc m%"
              Whether to enable inlay-hints for designators in aggregate initialization
              https://clangd.llvm.org/config.html#designators
            "%
            | optional,
          Enabled
            | Bool
            | doc m%"
              Whether to enable inlay-hints
              https://clangd.llvm.org/config.html#enabled
            "%
            | optional,
          ParameterNames
            | Bool
            | doc m%"
              Whether to enable inlay-hints for parameter names in function calls
              https://clangd.llvm.org/config.html#parameternames
            "%
            | optional,
          TypeNameLimit
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc m%"
              Character limit for type hints. Hints that would be longer are not shown. 0 means no limit.
              https://clangd.llvm.org/config.html#typenamelimit
            "%
            | optional,
        }
        | doc m%"
          Inlay-hints options
          https://clangd.llvm.org/config.html#inlayhints
        "%
        | optional,
      SemanticTokens
        | {
          DisabledKinds
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
            )
            | doc m%"
              Specify semantic token kinds that clangd should not send to client
              https://clangd.llvm.org/config.html#disabledkinds
            "%
            | optional,
          DisabledModifiers
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
            )
            | doc m%"
              Specify semantic token modifiers that clangd should not send to client
              https://clangd.llvm.org/config.html#disabledmodifiers
            "%
            | optional,
        }
        | doc m%"
          Configure semantic highlighting
          https://clangd.llvm.org/config.html#semantic-tokens
        "%
        | optional,
      Style
        | {
          AngledHeaders
            | Array (String)
            | doc m%"
              A list of regexes. Headers whose path matches one of these regexes are inserted using <> syntax.
              https://clangd.llvm.org/config#angledheaders
            "%
            | optional,
          FullyQualifiedNamespaces
            | Array (String)
            | doc m%"
              List of fully qualified namespaces
              https://clangd.llvm.org/config.html#fullyqualifiednamespaces
            "%
            | optional,
          QuotedHeaders
            | Array (String)
            | doc m%"
              A list of regexes. Headers whose path matches one of these regexes are inserted using "" syntax
              https://clangd.llvm.org/config#quotedheaders
            "%
            | optional,
          ..
        }
        | doc m%"
          A code base style
          https://clangd.llvm.org/config.html#style
        "%
        | optional,
      ..
    }